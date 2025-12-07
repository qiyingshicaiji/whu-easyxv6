#include "proc.h"
#include "trap.h"
#include "uart.h"
#include "defs.h"

extern volatile uint64 ticks;
uint64 get_ticks(void);

static void* memset_impl(void *s, int c, unsigned long n) {
    char *p = (char *)s;
    for (unsigned long i = 0; i < n; i++) {
        p[i] = c;
    }
    return s;
}

static void* memcpy_impl(void *dest, const void *src, unsigned long n) {
    char *d = (char *)dest;
    const char *s = (const char *)src;
    for (unsigned long i = 0; i < n; i++) {
        d[i] = s[i];
    }
    return dest;
}

#define memset memset_impl
#define memcpy memcpy_impl

// 进程表和全局状态
struct proc proc[NPROC];
struct proc *current_proc = 0;
int nextpid = 1;
struct cpu cpus[1];  // 简化：只支持单核

// 抢占标志：当时间中断发生时，调度器应该进行进程切换
volatile int need_resched = 0;

// 自旋锁 (简化实现)
typedef struct {
    int locked;
} spinlock_t;

static spinlock_t proc_lock = {0};

static void spin_lock(spinlock_t *lock) {
    while (__sync_lock_test_and_set(&lock->locked, 1)) {
        // 自旋等待
    }
}

static void spin_unlock(spinlock_t *lock) {
    __sync_lock_release(&lock->locked);
}

/**
 * 初始化进程系统
 */
void proc_init(void) {
    uart_puts("[proc] Initializing process system...\n");
    
    memset(proc, 0, sizeof(proc));
    nextpid = 1;
    current_proc = 0;
    
    // 初始化进程表
    for (int i = 0; i < NPROC; i++) {
        proc[i].state = UNUSED;
        proc[i].pid = 0;
        proc[i].ppid = 0;
        proc[i].uid = 0;
    }
    
    uart_puts("[proc] Process system initialized\n");
}

/**
 * 分配新进程结构
 */
struct proc* alloc_proc(void) {
    spin_lock(&proc_lock);
    
    struct proc *p = 0;
    
    // 在进程表中查找未使用的槽位
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].state == UNUSED) {
            p = &proc[i];
            goto found;
        }
    }
    
    spin_unlock(&proc_lock);
    uart_puts("[proc] No free process slot\n");
    return 0;

found:
    p->state = USED;
    p->pid = nextpid++;
    p->ppid = 0;
    p->uid = 0;              // 默认为root用户(uid=0)
    p->killed = 0;
    p->xstate = 0;
    p->parent = 0;
    p->chan = 0;
    p->sz = 0;
    
    spin_unlock(&proc_lock);
    
    // 分配trapframe
    p->trapframe = alloc_trapframe();
    if (!p->trapframe) {
        uart_puts("[proc] Failed to allocate trapframe\n");
        p->state = UNUSED;
        return 0;
    }
    
    // 分配内核栈 (4KB)
    p->kstack = (char *)alloc_page();
    if (!p->kstack) {
        uart_puts("[proc] Failed to allocate kernel stack\n");
        free_trapframe(p->trapframe);
        p->state = UNUSED;
        return 0;
    }
    
    // 清零内核栈
    memset(p->kstack, 0, PAGE_SIZE);
    
    // 初始化上下文
    memset(&p->context, 0, sizeof(p->context));
    p->context.sp = (uint64)p->kstack + PAGE_SIZE;  // 栈顶
    
    // 创建用户页表
    p->pagetable = proc_pagetable(p);
    if (p->pagetable == 0) {
        uart_puts("[proc] Failed to create user pagetable\n");
        free_page(p->kstack);
        free_trapframe(p->trapframe);
        p->state = UNUSED;
        return 0;
    }
    
    printf("[proc] Allocated process: pid=%d\n", p->pid);
    
    return p;
}

/**
 * 释放进程
 */
void free_proc(struct proc *p) {
    if (!p) return;
    
    if (p->trapframe) {
        free_trapframe(p->trapframe);
        p->trapframe = 0;
    }
    
    if (p->kstack) {
        free_page(p->kstack);
        p->kstack = 0;
    }
    
    if (p->pagetable) {
        proc_freepagetable(p->pagetable, p->sz);
        p->pagetable = 0;
    }
    
    p->sz = 0;
    p->pid = 0;
    p->ppid = 0;
    p->parent = 0;
    p->chan = 0;
    p->killed = 0;
    p->xstate = 0;
    p->state = UNUSED;
}

/**
 * 按PID查找进程
 */
struct proc* find_proc(int pid) {
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].pid == pid && proc[i].state != UNUSED) {
            return &proc[i];
        }
    }
    return 0;
}

/**
 * 设置进程内核栈
 */
void proc_set_kernel_stack(struct proc *p, char *kstack) {
    if (p) {
        p->kstack = kstack;
        p->context.sp = (uint64)kstack + PAGE_SIZE;
    }
}

/**
 * 标记进程为可运行
 */
void proc_mark_runnable(struct proc *p) {
    if (p && p->state != RUNNABLE && p->state != RUNNING && p->state != ZOMBIE) {
        p->state = RUNNABLE;
    }
}

/**
 * 标记进程为睡眠
 */
void proc_mark_sleeping(struct proc *p, void *chan) {
    if (p && p->state == RUNNING) {
        p->state = SLEEPING;
        p->chan = chan;
    }
}

/**
 * 标记进程为僵尸
 */
void proc_mark_zombie(struct proc *p, int xstate) {
    if (p && p->state != ZOMBIE) {
        p->state = ZOMBIE;
        p->xstate = xstate;
    }
}

/**
 * 获取当前进程的PID
 */
int get_pid(void) {
    if (current_proc) {
        return current_proc->pid;
    }
    return -1;
}

/**
 * 获取当前进程结构
 */
struct proc* get_current_proc(void) {
    return current_proc;
}

/**
 * 设置当前进程
 */
void set_current_proc(struct proc *p) {
    current_proc = p;
}

/**
 * 获取当前进程的UID
 */
int get_uid(void) {
    if (current_proc) {
        return current_proc->uid;
    }
    return 0;  // 默认返回root
}

/**
 * 设置当前进程的UID（需要权限检查）
 */
int set_uid(int uid) {
    if (!current_proc) {
        return -1;
    }
    
    // 简化版：只有root(uid=0)可以修改UID
    if (current_proc->uid != 0) {
        printf("[proc] Permission denied: only root can change UID\n");
        return -1;
    }
    
    if (uid < 0 || uid >= NUSER) {
        printf("[proc] Invalid UID: %d (must be 0-%d)\n", uid, NUSER-1);
        return -1;
    }
    
    current_proc->uid = uid;
    printf("[proc] Changed UID to %d for process %d\n", uid, current_proc->pid);
    return 0;
}

/**
 * 统计指定用户的进程数
 */
int count_user_procs(int uid) {
    int count = 0;
    
    spin_lock(&proc_lock);
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].state != UNUSED && proc[i].uid == uid) {
            count++;
        }
    }
    spin_unlock(&proc_lock);
    
    return count;
}

/**
 * 检查用户是否可以fork（是否达到进程数上限）
 */
int can_fork(int uid) {
    int count = count_user_procs(uid);
    
    if (count >= MAX_PROC_PER_USER) {
        printf("[proc] Fork denied: user %d has %d processes (max %d)\n", 
               uid, count, MAX_PROC_PER_USER);
        return 0;
    }
    
    return 1;
}

/**
 * 为进程分配并初始化用户栈
 * 分配PAGE_SIZE字节作为用户栈
 */
int setup_user_stack(struct proc *p) {
    if (!p || !p->pagetable) {
        return -1;
    }
    
    // 分配用户栈（在用户空间高地址）
    // 注意：trampoline和trapframe占据最高的两页
    uint64_t trampoline_va = (1L << 38) - PAGE_SIZE;
    uint64_t trapframe_va = trampoline_va - PAGE_SIZE;
    uint64_t stack_top = trapframe_va;
    uint64_t stack_base = stack_top - PAGE_SIZE;
    
    // 分配栈内存
    char* mem = (char*)alloc_page();
    if (mem == 0) {
        return -1;
    }
    
    // 清零栈
    memset(mem, 0, PAGE_SIZE);
    
    // 映射栈页面到用户地址空间
    if (map_page(p->pagetable, stack_base, (uint64_t)mem, 
                 PTE_R | PTE_W | PTE_U) != 0) {
        free_page(mem);
        return -1;
    }
    
    // 设置栈指针（栈从高地址向低地址增长）
    p->ustack = stack_top;
    
    return 0;
}

/**
 * 加载简单的用户程序到进程
 * code: 用户代码
 * sz: 代码大小
 */
int load_user_program(struct proc *p, void* code, uint64_t sz) {
    if (!p || !code || sz == 0) {
        return -1;
    }
    
    // 分配足够的用户内存来存放代码
    uint64_t oldsz = p->sz;
    uint64_t newsz = uvmalloc(p->pagetable, oldsz, oldsz + sz);
    if (newsz == 0) {
        return -1;
    }
    p->sz = newsz;
    
    // 复制代码到用户内存
    if (copyout(p->pagetable, 0, (char*)code, sz) < 0) {
        uvmdealloc(p->pagetable, newsz, oldsz);
        p->sz = oldsz;
        return -1;
    }
    
    // 设置用户栈
    if (setup_user_stack(p) < 0) {
        uvmdealloc(p->pagetable, newsz, oldsz);
        p->sz = oldsz;
        return -1;
    }
    
    // 初始化trapframe
    if (p->trapframe) {
        memset(p->trapframe, 0, sizeof(struct trapframe));
        p->trapframe->sepc = 0;  // 程序从地址0开始
        p->trapframe->sp = p->ustack;  // 用户栈指针
    }
    
    return 0;
}

// 调度器的上下文 (调度器本身的执行状态)
static struct context scheduler_context;
static int scheduler_initialized = 0;


void scheduler(void) {
    if (!scheduler_initialized) {
        uart_puts("[proc] Scheduler started\n");
        scheduler_initialized = 1;
    }
    
    struct proc *p;
    struct cpu *c = &cpus[0];  // 单核
    static int last_index = 0;

    for (;;) {
        intr_on(); // 允许中断

        // 从上一个停止的地方继续扫描，实现轮转
        int found = 0;
        for (int i = 0; i < NPROC; i++) {
            int idx = (last_index + i) % NPROC;
            p = &proc[idx];
            
            if (p->state == RUNNABLE) {
                p->state = RUNNING;
                c->proc = p;
                current_proc = p;
                need_resched = 0;  // 清除抢占标志

                printf("[proc] Scheduler: switching to process %d\n", p->pid);

                // 如果是用户进程，直接trapret返回用户态
                if (p->trapframe && p->pagetable) {
                    extern void trapret(struct trapframe*, pagetable_t);
                    trapret(p->trapframe, p->pagetable);
                } else {
                    intr_off();
                    switch_context(&scheduler_context, &p->context);
                }

                // 当进程 yield() 或被时间中断抢占后回到这里...
                // 进程完成了它的时间片或主动让出CPU
                intr_on();

                c->proc = 0;
                current_proc = 0;

                // 更新索引，确保下次从该进程的下一个进程开始
                last_index = (idx + 1) % NPROC;
                found = 1;
                break;  // 跳出for循环，回到for(;;)重新扫描
            }
        }

        // 如果一整轮扫描都没有找到 RUNNABLE 进程
        if (!found) {
            // 短暂让出CPU，避免忙轮询

        }
    }
}

/**
 * 放弃CPU，让出给其他进程
 * 
 * yield流程：
 * 1. 关闭中断（保护）
 * 2. 标记当前进程为RUNNABLE
 * 3. 通过switch_context切换回scheduler
 * 4. scheduler会选择下一个进程运行
 * 
 * 注意：调用者应该确保在合适的中断状态下调用此函数
 */
void yield(void) {
    struct proc *p = current_proc;
    if (!p) return;
    
    int was_intr_on = intr_get();
    
    intr_off();
    
    spin_lock(&proc_lock);
    if (p->state == RUNNING) {
        p->state = RUNNABLE;
    }
    spin_unlock(&proc_lock);
    
    printf("[proc] Process %d yielding CPU\n", p->pid);
    
    // switch_context保存当前进程的context，恢复scheduler的context，这会回到scheduler()函数中的switch_context调用之后
    switch_context(&p->context, &scheduler_context);
    
    // 恢复到调用yield()时的中断状态
    if (was_intr_on) {
        intr_on();
    }
}

/**
 * 创建子进程 (fork系统调用)
 * 复制父进程的内存、寄存器状态等
 * 父进程返回子进程PID，子进程返回0
 */
int fork(void) {
    struct proc *p = current_proc;
    if (!p) {
        uart_puts("[proc] fork: no current process\n");
        return -1;
    }
    
    // 检查用户进程数限制
    if (!can_fork(p->uid)) {
        return -1;  // 已打印错误消息
    }
    
    // 分配新进程
    struct proc *np = alloc_proc();
    if (!np) {
        uart_puts("[proc] fork: failed to allocate process\n");
        return -1;
    }
    
    // 继承父进程的UID
    np->uid = p->uid;
    
    // 复制父进程的内存内容到子进程
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
        uart_puts("[proc] fork: failed to copy memory\n");
        free_proc(np);
        return -1;
    }
    np->sz = p->sz;
    
    // 设置父子关系
    spin_lock(&proc_lock);
    np->parent = p;
    np->ppid = p->pid;
    spin_unlock(&proc_lock);
    
    // 复制trapframe（保存所有寄存器状态）
    if (p->trapframe && np->trapframe) {
        memcpy(np->trapframe, p->trapframe, sizeof(struct trapframe));
        // 子进程的返回值设为0
        np->trapframe->a0 = 0;
    }
    
    // 复制打开的文件描述符（简化版：暂不实现）
    // 复制工作目录（简化版：暂不实现）
    
    // 将子进程标记为RUNNABLE
    spin_lock(&proc_lock);
    np->state = RUNNABLE;
    spin_unlock(&proc_lock);
    
    printf("[proc] fork: created process %d (parent %d, uid %d)\n", 
           np->pid, p->pid, np->uid);
    
    // 父进程返回子进程PID
    return np->pid;
}

/**
 * 增长或收缩用户内存 (sbrk系统调用的底层实现)
 * n > 0: 增长n字节
 * n < 0: 收缩-n字节
 * 返回旧的大小，失败返回-1
 */
int growproc(int n) {
    uint64_t sz;
    struct proc *p = current_proc;
    
    if (!p) {
        return -1;
    }
    
    sz = p->sz;
    
    if (n > 0) {
        // 增长内存
        if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
            return -1;
        }
    } else if (n < 0) {
        // 收缩内存
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    }
    
    p->sz = sz;
    return 0;
}

/**
 * 进程退出
 */
void exit(int status) {
    struct proc *p = current_proc;
    if (!p) return;
    
    spin_lock(&proc_lock);
    
    // 标记为僵尸进程
    p->xstate = status;
    p->state = ZOMBIE;
    
    // 重新绑定子进程给init进程 (这里简化)
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].parent == p) {
            proc[i].parent = 0;
            proc[i].ppid = 1;  // 假设pid=1是init进程
        }
    }
    
    printf("[proc] exit: process %d exited with status %d\n", p->pid, status);
    
    spin_unlock(&proc_lock);
    
    // 调度到其他进程
    yield();
}

/**
 * 等待子进程
 */
int wait(int *status) {
    struct proc *p = current_proc;
    if (!p) return -1;
    
    for (;;) {
        spin_lock(&proc_lock);
        
        // 查找任何ZOMBIE子进程
        int found = 0;
        struct proc *zombie = 0;
        
        for (int i = 0; i < NPROC; i++) {
            if (proc[i].parent == p && proc[i].state == ZOMBIE) {
                zombie = &proc[i];
                found = 1;
                break;
            }
        }
        
        if (found) {
            // 找到了僵尸子进程
            int pid = zombie->pid;
            if (status) {
                *status = zombie->xstate;
            }
            
            // 清理进程
            free_proc(zombie);
            
            printf("[proc] wait: reaped process %d\n", pid);
            
            spin_unlock(&proc_lock);
            return pid;
        }
        
        // 没有子进程
        int has_children = 0;
        for (int i = 0; i < NPROC; i++) {
            if (proc[i].parent == p && proc[i].state != UNUSED) {
                has_children = 1;
                break;
            }
        }
        
        if (!has_children) {
            spin_unlock(&proc_lock);
            return -1;
        }
        
        spin_unlock(&proc_lock);
        
        // 睡眠等待子进程 (简化：直接睡眠)
        sleep(p);  // 在子进程exit时会被唤醒
    }
}

/**
 * 杀死进程
 */
void kill(int pid) {
    struct proc *p = find_proc(pid);
    if (p) {
        spin_lock(&proc_lock);
        p->killed = 1;
        if (p->state == SLEEPING) {
            p->state = RUNNABLE;
        }
        spin_unlock(&proc_lock);
    }
}

/**
 * 睡眠直到被唤醒
 * chan: 等待通道 (可以是任何指针值)
 */
void sleep(void *chan) {
    struct proc *p = current_proc;
    if (!p) return;
    
    spin_lock(&proc_lock);
    
    // 标记为睡眠
    p->state = SLEEPING;
    p->chan = chan;
    
    spin_unlock(&proc_lock);
    
    // 让出CPU
    yield();
}

/**
 * 唤醒所有睡眠在指定通道上的进程
 */
void wakeup(void *chan) {
    spin_lock(&proc_lock);
    
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].state == SLEEPING && proc[i].chan == chan) {
            proc[i].state = RUNNABLE;
        }
    }
    
    spin_unlock(&proc_lock);
}

/**
 * 唤醒一个睡眠在指定通道上的进程
 */
void wakeup_one(void *chan) {
    spin_lock(&proc_lock);
    
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].state == SLEEPING && proc[i].chan == chan) {
            proc[i].state = RUNNABLE;
            break;
        }
    }
    
    spin_unlock(&proc_lock);
}

// ============================================================================
// 信号量实现（带等待队列）
// ============================================================================

/**
 * 将进程加入等待队列
 */
static void sem_enqueue(semaphore_t *sem, struct proc *p) {
    // 分配等待队列节点
    struct wait_queue_node *node = (struct wait_queue_node *)alloc_page();
    if (!node) return;
    
    node->proc = p;
    node->next = 0;
    
    if (sem->tail) {
        sem->tail->next = node;
        sem->tail = node;
    } else {
        sem->head = sem->tail = node;
    }
}

/**
 * 从等待队列移除并返回第一个进程
 */
static struct proc* sem_dequeue(semaphore_t *sem) {
    if (!sem->head) return 0;
    
    struct wait_queue_node *node = sem->head;
    struct proc *p = node->proc;
    
    sem->head = node->next;
    if (!sem->head) {
        sem->tail = 0;
    }
    
    free_page((char *)node);
    return p;
}

/**
 * 初始化信号量
 */
void sem_init(semaphore_t *sem, int value) {
    if (!sem) return;
    sem->value = value;
    sem->chan = (void *)sem;
    sem->head = 0;
    sem->tail = 0;
}

/**
 * P操作（带等待队列）
 */
void sem_wait(semaphore_t *sem) {
    if (!sem) return;
    
    struct proc *p = current_proc;
    if (!p) return;
    
    spin_lock(&proc_lock);
    
    while (sem->value <= 0) {
        // 加入等待队列
        sem_enqueue(sem, p);
        
        // 标记为睡眠
        p->state = SLEEPING;
        p->chan = sem->chan;
        
        spin_unlock(&proc_lock);
        
        printf("[sem_wait] Process %d blocked (value=%d)\n", p->pid, sem->value);
        yield();
        
        spin_lock(&proc_lock);
    }
    
    sem->value--;
    printf("[sem_wait] Process %d acquired (value=%d)\n", p->pid, sem->value);
    
    spin_unlock(&proc_lock);
}

/**
 * V操作（带等待队列）
 */
void sem_post(semaphore_t *sem) {
    if (!sem) return;
    
    spin_lock(&proc_lock);
    
    sem->value++;
    printf("[sem_post] Semaphore released (value=%d)\n", sem->value);
    
    // 从等待队列中唤醒一个进程
    struct proc *p = sem_dequeue(sem);
    if (p && p->state == SLEEPING && p->chan == sem->chan) {
        p->state = RUNNABLE;
        p->chan = 0;
        printf("[sem_post] Woke up process %d\n", p->pid);
    }
    
    spin_unlock(&proc_lock);
}

/**
 * 非阻塞P操作
 */
int sem_trywait(semaphore_t *sem) {
    if (!sem) return -1;
    
    spin_lock(&proc_lock);
    
    if (sem->value > 0) {
        sem->value--;
        spin_unlock(&proc_lock);
        return 0;  // 成功
    }
    
    spin_unlock(&proc_lock);
    return -1;  // 失败
}

struct proc* myproc(void) {
    return current_proc;
}
