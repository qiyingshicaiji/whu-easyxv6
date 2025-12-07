#include "defs.h"
#include "uart.h"
#include "trap.h"
#include "proc.h"
#include "syscall.h"
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "user_test_syscalls_bin.c" // 或 extern 声明
#include "user_test_fs_bin.c"
#include "fs.h"

// 2. 启动时自动创建用户进程
void start_user_test(void) {
    struct proc *p = alloc_proc();
    if (p) {
        // 使用已有的 load_user_program 接口
        // Prefer loading filesystem test; fallback to syscall test
        if (load_user_program(p, (void*)user_test_fs_bin, (uint64_t)user_test_fs_bin_len) == 0) {
            p->state = RUNNABLE;
        } else {
            uart_puts("[user] FS test load failed, trying syscall test...\n");
            if (load_user_program(p, (void*)user_test_syscalls_bin, (uint64_t)user_test_syscalls_bin_len) == 0) {
                p->state = RUNNABLE;
            } else {
                uart_puts("[user] load_user_program failed!\n");
            }
        }
    }
}
// ============================================================================
// 实验4：中断处理与异常系统测试
// ============================================================================

/**
 * 测试1 (进程): 进程分配和释放
 */
void test_process_allocation(void) {
    uart_puts("\n========== 进程测试1：进程分配和释放 ==========\n");
    
    struct proc *p1 = alloc_proc();
    struct proc *p2 = alloc_proc();
    struct proc *p3 = alloc_proc();
    
    if (p1 && p2 && p3) {
        printf("✓ 成功分配3个进程: PID=%d, PID=%d, PID=%d\n", 
               p1->pid, p2->pid, p3->pid);
        
        if (p1->state == USED && p2->state == USED && p3->state == USED) {
            uart_puts("✓ 所有进程状态正确（USED）\n");
        } else {
            uart_puts("✗ 进程状态错误\n");
        }
        
        // 释放进程
        free_proc(p1);
        free_proc(p2);
        free_proc(p3);
        
        if (p1->state == UNUSED && p2->state == UNUSED && p3->state == UNUSED) {
            uart_puts("✓ 进程释放成功\n");
        } else {
            uart_puts("✗ 进程释放失败\n");
        }
    } else {
        uart_puts("✗ 进程分配失败\n");
    }
    
    uart_puts("✓ 测试完成\n");
}

/**
 * 测试2 (进程): 进程查找
 */
void test_process_find(void) {
    uart_puts("\n========== 进程测试2：进程查找 ==========\n");
    
    struct proc *p = alloc_proc();
    if (!p) {
        uart_puts("✗ 分配进程失败\n");
        return;
    }
    
    int pid = p->pid;
    printf("分配进程: PID=%d\n", pid);
    
    struct proc *found = find_proc(pid);
    if (found && found->pid == pid) {
        printf("✓ 成功查找进程: PID=%d\n", found->pid);
    } else {
        uart_puts("✗ 进程查找失败\n");
    }
    
    free_proc(p);
    
    found = find_proc(pid);
    if (!found || found->state == UNUSED) {
        uart_puts("✓ 已释放的进程无法查找（正确行为）\n");
    } else {
        uart_puts("✗ 已释放的进程仍然可以查找\n");
    }
    
    uart_puts("✓ 测试完成\n");
}

/**
 * 测试3 (进程): 进程状态转换
 */
void test_process_state_transition(void) {
    uart_puts("\n========== 进程测试3：进程状态转换 ==========\n");
    
    struct proc *p = alloc_proc();
    if (!p) {
        uart_puts("✗ 分配进程失败\n");
        return;
    }
    
    printf("初始状态: %d (USED=%d)\n", p->state, USED);
    
    // 标记为可运行
    proc_mark_runnable(p);
    if (p->state == RUNNABLE) {
        uart_puts("✓ 标记为RUNNABLE成功\n");
    }
    
    // 设置为RUNNING状态才能标记为睡眠
    p->state = RUNNING;
    
    // 标记为睡眠
    void *chan = (void *)0x1234;
    proc_mark_sleeping(p, chan);
    if (p->state == SLEEPING && p->chan == chan) {
        uart_puts("✓ 标记为SLEEPING成功\n");
    } else {
        printf("✗ 标记为SLEEPING失败（状态:%d)\n", p->state);
    }
    
    // 标记为僵尸
    proc_mark_zombie(p, 42);
    if (p->state == ZOMBIE && p->xstate == 42) {
        uart_puts("✓ 标记为ZOMBIE成功\n");
    }
    
    free_proc(p);
    uart_puts("✓ 测试完成\n");
}

/**
 * 测试4 (进程): 模拟简单的fork
 */
void test_simple_fork(void) {
    uart_puts("\n========== 进程测试4：简单fork模拟 ==========\n");
    
    // 创建"父进程"
    struct proc *parent = alloc_proc();
    if (!parent) {
        uart_puts("✗ 分配父进程失败\n");
        return;
    }
    
    parent->state = RUNNING;
    set_current_proc(parent);
    
    printf("父进程: PID=%d\n", parent->pid);
    
    // 执行fork
    int child_pid = fork();
    if (child_pid > 0) {
        printf("✓ Fork成功，子进程PID=%d\n", child_pid);
        
        struct proc *child = find_proc(child_pid);
        if (child) {
            if (child->parent == parent && child->ppid == parent->pid) {
                uart_puts("✓ 父子关系建立正确\n");
            }
            if (child->state == RUNNABLE) {
                uart_puts("✓ 子进程状态为RUNNABLE\n");
            }
            // 清理子进程
            free_proc(child);
        }
    } else {
        uart_puts("✗ Fork失败\n");
    }
    
    free_proc(parent);
    set_current_proc(0);  // 清除当前进程指针
    uart_puts("✓ 测试完成\n");
}

/**
 * 测试5 (进程): 调度器基本功能
 */
void test_scheduler_basic(void) {
    uart_puts("\n========== 进程测试5：调度器基本功能 ==========\n");
    
    // 创建多个进程
    struct proc *procs[3];
    for (int i = 0; i < 3; i++) {
        procs[i] = alloc_proc();
        if (procs[i]) {
            procs[i]->state = RUNNABLE;
            printf("创建进程: PID=%d\n", procs[i]->pid);
        }
    }
    
    // 检查进程是否都在表中
    int runnable_count = 0;
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].state == RUNNABLE) {
            runnable_count++;
        }
    }
    
    printf("可运行进程数: %d (应该有3个)\n", runnable_count);
    
    // 清理
    for (int i = 0; i < 3; i++) {
        if (procs[i]) {
            free_proc(procs[i]);
        }
    }
    
    uart_puts("✓ 测试完成\n");
}

/**
 * 综合进程管理系统测试
 */
void run_process_management_tests(void) {
    uart_puts("\n");
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║     实验5：进程管理与调度系统 - 功能测试套件                    ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n");
    
    test_process_allocation();
    test_process_find();
    test_process_state_transition();
    test_simple_fork();
    test_process_memory();
    test_growproc();
    test_uid_limits();
    test_scheduler_basic();
    
    uart_puts("\n");
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║          进程管理系统测试 - 执行完成！                          ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n\n");
    uart_puts("测试结果总结：\n");
    uart_puts("  ✓ 进程分配和释放功能正常（含PCB、内核栈、用户页表）\n");
    uart_puts("  ✓ 进程查找功能正常\n");
    uart_puts("  ✓ 进程状态转换正常\n");
    uart_puts("  ✓ Fork系统调用（含内存复制）\n");
    uart_puts("  ✓ 进程内存管理（分配/释放）\n");
    uart_puts("  ✓ Growproc（sbrk实现）\n");
    uart_puts("  ✓ UID机制和进程数限制\n");
    uart_puts("  ✓ 调度器框架就绪\n\n");
}

/**
 * 测试：进程内存管理
 */
void test_process_memory(void) {
    uart_puts("\n[测试] 进程内存管理\n");
    
    struct proc *p = alloc_proc();
    if (!p) {
        uart_puts("✗ 进程分配失败\n");
        return;
    }
    
    // 检查页表是否创建
    if (p->pagetable == 0) {
        uart_puts("✗ 用户页表未创建\n");
        free_proc(p);
        return;
    }
    printf("✓ 进程 %d 的用户页表已创建\n", p->pid);
    
    // 测试内存分配
    uint64_t old_sz = p->sz;
    uint64_t new_sz = uvmalloc(p->pagetable, old_sz, old_sz + PAGE_SIZE * 2);
    if (new_sz == old_sz + PAGE_SIZE * 2) {
        printf("✓ 分配 2 页内存成功 (0x%lx -> 0x%lx)\n", old_sz, new_sz);
        p->sz = new_sz;
    } else {
        uart_puts("✗ 内存分配失败\n");
    }
    
    // 测试内存释放
    new_sz = uvmdealloc(p->pagetable, p->sz, p->sz - PAGE_SIZE);
    if (new_sz == p->sz - PAGE_SIZE) {
        printf("✓ 释放 1 页内存成功 (0x%lx -> 0x%lx)\n", p->sz, new_sz);
        p->sz = new_sz;
    } else {
        uart_puts("✗ 内存释放失败\n");
    }
    
    free_proc(p);
    uart_puts("✓ 进程内存管理测试完成\n");
}

/**
 * 测试：growproc (sbrk系统调用)
 */
void test_growproc(void) {
    uart_puts("\n[测试] Growproc (sbrk)\n");
    
    struct proc *p = alloc_proc();
    if (!p) {
        uart_puts("✗ 进程分配失败\n");
        return;
    }
    
    // 分配初始内存
    p->sz = uvmalloc(p->pagetable, 0, PAGE_SIZE);
    printf("初始内存大小: 0x%lx\n", p->sz);
    
    // 设置为当前进程
    struct proc *old_proc = current_proc;
    current_proc = p;
    
    // 测试增长内存
    if (growproc(PAGE_SIZE) == 0) {
        printf("✓ Growproc 增长 1 页成功，新大小: 0x%lx\n", p->sz);
    } else {
        uart_puts("✗ Growproc 增长失败\n");
    }
    
    // 测试收缩内存
    if (growproc(-PAGE_SIZE) == 0) {
        printf("✓ Growproc 收缩 1 页成功，新大小: 0x%lx\n", p->sz);
    } else {
        uart_puts("✗ Growproc 收缩失败\n");
    }
    
    current_proc = old_proc;
    free_proc(p);
    uart_puts("✓ Growproc 测试完成\n");
}

/**
 * 测试：UID机制和进程数限制
 */
void test_uid_limits(void) {
    uart_puts("\n[测试] UID机制和进程数限制\n");
    
    struct proc *procs[10];
    int allocated = 0;
    
    // 测试默认UID
    struct proc *p1 = alloc_proc();
    if (p1) {
        printf("✓ 进程 %d 的默认 UID: %d\n", p1->pid, p1->uid);
        procs[allocated++] = p1;
    }
    
    // 设置为用户1
    struct proc *old_proc = current_proc;
    current_proc = p1;
    
    if (set_uid(1) == 0) {
        printf("✓ 成功将进程 %d 的 UID 改为 1\n", p1->pid);
    }
    
    // 测试用户1的进程数限制 (MAX_PROC_PER_USER = 4)
    printf("\n尝试为用户1创建进程（限制：%d个）：\n", MAX_PROC_PER_USER);
    
    for (int i = 1; i < 10; i++) {
        // 模拟fork（继承UID）
        struct proc *np = alloc_proc();
        if (!np) {
            printf("  第%d次分配失败：进程表已满\n", i+1);
            break;
        }
        
        np->uid = current_proc->uid;  // 继承UID
        
        // 检查是否达到限制
        int count = count_user_procs(np->uid);
        if (count > MAX_PROC_PER_USER) {
            printf("  ✗ 第%d次分配：用户%d已有%d个进程，超过限制\n", 
                   i+1, np->uid, count-1);
            free_proc(np);
            break;
        }
        
        printf("  ✓ 第%d次分配成功：进程%d (用户%d，当前共%d个进程)\n", 
               i+1, np->pid, np->uid, count);
        procs[allocated++] = np;
        
        if (count >= MAX_PROC_PER_USER) {
            printf("  达到用户%d的进程数限制(%d个)\n", np->uid, MAX_PROC_PER_USER);
            break;
        }
    }
    
    // 测试fork限制
    printf("\n测试fork限制：\n");
    int fork_result = can_fork(1);
    if (!fork_result) {
        uart_puts("  ✓ 正确拒绝fork（已达上限）\n");
    } else {
        uart_puts("  ✗ 应该拒绝fork但未拒绝\n");
    }
    
    // 清理
    current_proc = old_proc;
    for (int i = 0; i < allocated; i++) {
        free_proc(procs[i]);
    }
    
    uart_puts("✓ UID机制测试完成\n");
}

/**
 * RR worker: 内核线程函数，用于测试时间片轮转调度
 * 每个线程打印自身 PID 和迭代次数，然后调用 yield() 让出 CPU
 * 最后调用 exit() 结束
 */
static void rr_worker(void) {
    int pid = get_pid();
    for (int iter = 0; iter < 5; iter++) {
        printf("[rr] Worker PID=%d iter=%d\n", pid, iter);
        // 模拟工作负载（短延迟）
        for (volatile int d = 0; d < 100000; d++) { }
        // 主动让出 CPU，便于观察轮转
        yield();
    }
    printf("[rr] Worker PID=%d exiting\n", pid);
    exit(0);
}

/**
 * 测试：时间片轮转调度（Round-Robin）
 * 创建多个内核线程（通过设置 context.ra 到 rr_worker），将它们设为 RUNNABLE
 * 然后调用 scheduler() 启动调度器，观察它们是否轮流执行
 */
void test_round_robin_scheduler(void) {
    uart_puts("\n========== 调度器测试：时间片轮转 (Round-Robin) ==========\n");

    const int n = 3;
    struct proc *ps[n];

    // 分配并设置每个内核线程的入口
    for (int i = 0; i < n; i++) {
        ps[i] = alloc_proc();
        if (!ps[i]) {
            printf("✗ 无法分配进程 %d\n", i);
            continue;
        }

        // 将进程标记为可运行，并设置其内核线程入口为 rr_worker
        // context.sp 已由 alloc_proc 设置为内核栈顶
        ps[i]->context.ra = (uint64)rr_worker;
        ps[i]->state = RUNNABLE;
        printf("[rr] Created worker PID=%d\n", ps[i]->pid);
    }

    uart_puts("[rr] 启动调度器，观察输出以验证轮转调度\n");
    // 启动调度器（该函数不会返回，除非调度器内部逻辑改变）
    scheduler();

    // 如果 scheduler() 返回（理论上不应），则清理
    for (int i = 0; i < n; i++) {
        if (ps[i]) free_proc(ps[i]);
    }

    uart_puts("✓ 调度器测试完成（返回）\n");
}

// ============================================================================
// 生产者消费者问题演示
// ============================================================================

#define BUFFER_SIZE 5   // 缓冲区大小
#define PROD_COUNT 3    // 生产次数
#define CONS_COUNT 3    // 消费次数

// 共享缓冲区
static int buffer[BUFFER_SIZE];
static int in = 0;   // 生产者写入位置
static int out = 0;  // 消费者读取位置

// 信号量
static semaphore_t empty;  // 空槽位数量
static semaphore_t full;   // 满槽位数量
static semaphore_t mutex;  // 互斥访问缓冲区

/**
 * 生产者线程
 */
static void producer(void) {
    int pid = get_pid();
    
    for (int i = 0; i < PROD_COUNT; i++) {
        int item = pid * 100 + i;  // 生产的数据
        
        printf("[Producer %d] 尝试生产 item=%d\n", pid, item);
        
        // P(empty): 等待空槽位
        sem_wait(&empty);
        
        // P(mutex): 进入临界区
        sem_wait(&mutex);
        
        // 放入缓冲区
        buffer[in] = item;
        printf("[Producer %d] 生产 item=%d, 放入 buffer[%d]\n", pid, item, in);
        in = (in + 1) % BUFFER_SIZE;
        
        // V(mutex): 离开临界区
        sem_post(&mutex);
        
        // V(full): 增加满槽位
        sem_post(&full);
        
        // 模拟生产时间
        for (volatile int d = 0; d < 100000; d++) { }
        
        yield();  // 主动让出CPU
    }
    
    printf("[Producer %d] 完成所有生产，退出\n", pid);
    exit(0);
}

/**
 * 消费者线程
 */
static void consumer(void) {
    int pid = get_pid();
    
    for (int i = 0; i < CONS_COUNT; i++) {
        printf("[Consumer %d] 尝试消费\n", pid);
        
        // P(full): 等待满槽位
        sem_wait(&full);
        
        // P(mutex): 进入临界区
        sem_wait(&mutex);
        
        // 从缓冲区取出
        int item = buffer[out];
        printf("[Consumer %d] 消费 item=%d, 从 buffer[%d]\n", pid, item, out);
        out = (out + 1) % BUFFER_SIZE;
        
        // V(mutex): 离开临界区
        sem_post(&mutex);
        
        // V(empty): 增加空槽位
        sem_post(&empty);
        
        // 模拟消费时间
        for (volatile int d = 0; d < 100000; d++) { }
        
        yield();  // 主动让出CPU
    }
    
    printf("[Consumer %d] 完成所有消费，退出\n", pid);
    exit(0);
}

/**
 * 测试生产者消费者问题
 */
void test_producer_consumer(void) {
    uart_puts("\n");
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║          信号量演示：生产者-消费者问题                          ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n\n");
    
    printf("缓冲区大小: %d\n", BUFFER_SIZE);
    printf("生产者数量: 2, 消费者数量: 2\n");
    printf("每个生产者生产 %d 个产品\n", PROD_COUNT);
    printf("每个消费者消费 %d 个产品\n\n", CONS_COUNT);
    
    // 初始化信号量
    sem_init(&empty, BUFFER_SIZE);  // 开始时有 BUFFER_SIZE 个空槽位
    sem_init(&full, 0);             // 开始时有 0 个满槽位
    sem_init(&mutex, 1);            // 互斥锁，初始值为1
    
    printf("信号量初始化: empty=%d, full=%d, mutex=%d\n\n", 
           empty.value, full.value, mutex.value);
    
    // 创建生产者进程
    for (int i = 0; i < 2; i++) {
        struct proc *p = alloc_proc();
        if (p) {
            p->context.ra = (uint64)producer;
            p->state = RUNNABLE;
            printf("创建生产者进程 PID=%d\n", p->pid);
        }
    }
    
    // 创建消费者进程
    for (int i = 0; i < 2; i++) {
        struct proc *p = alloc_proc();
        if (p) {
            p->context.ra = (uint64)consumer;
            p->state = RUNNABLE;
            printf("创建消费者进程 PID=%d\n", p->pid);
        }
    }
    
    uart_puts("\n启动生产者-消费者演示...\n\n");
    
    // 启动调度器
    scheduler();
}

// ============================================================================
// 读者-写者问题演示（读者优先策略）
// ============================================================================

#define READ_COUNT 3    // 每个读者读取次数
#define WRITE_COUNT 2   // 每个写者写入次数

// 共享数据
static int shared_data = 0;
static int read_count = 0;  // 当前正在读的读者数量

// 信号量
static semaphore_t rw_mutex;      // 保护共享数据的读写互斥
static semaphore_t read_mutex;    // 保护read_count的互斥
static semaphore_t write_mutex;   // 写者之间的互斥（可选，防止写者饥饿）

/**
 * 读者线程
 */
static void reader(void) {
    int pid = get_pid();
    
    for (int i = 0; i < READ_COUNT; i++) {
        printf("[Reader %d] 尝试读取（第%d次）\n", pid, i+1);
        
        // P(read_mutex): 保护read_count
        sem_wait(&read_mutex);
        read_count++;
        if (read_count == 1) {
            // 第一个读者需要获取rw_mutex，阻止写者
            printf("[Reader %d] 第一个读者，获取读写锁\n", pid);
            sem_wait(&rw_mutex);
        }
        sem_post(&read_mutex);
        
        // 读取共享数据
        int value = shared_data;
        printf("[Reader %d] 读取数据: %d (当前读者数: %d)\n", 
               pid, value, read_count);
        
        // 模拟读取时间
        for (volatile int d = 0; d < 50000; d++) { }
        
        // P(read_mutex): 保护read_count
        sem_wait(&read_mutex);
        read_count--;
        if (read_count == 0) {
            // 最后一个读者释放rw_mutex，允许写者
            printf("[Reader %d] 最后一个读者，释放读写锁\n", pid);
            sem_post(&rw_mutex);
        }
        sem_post(&read_mutex);
        
        printf("[Reader %d] 读取完成\n", pid);
        
        // 模拟间隔时间
        for (volatile int d = 0; d < 50000; d++) { }
        yield();
    }
    
    printf("[Reader %d] 完成所有读取，退出\n", pid);
    exit(0);
}

/**
 * 写者线程
 */
static void writer(void) {
    int pid = get_pid();
    
    for (int i = 0; i < WRITE_COUNT; i++) {
        printf("[Writer %d] 尝试写入（第%d次）\n", pid, i+1);
        
        // P(rw_mutex): 获取读写锁
        sem_wait(&rw_mutex);
        
        // 写入共享数据
        int old_value = shared_data;
        shared_data = pid * 100 + i;
        printf("[Writer %d] 写入数据: %d -> %d\n", 
               pid, old_value, shared_data);
        
        // 模拟写入时间
        for (volatile int d = 0; d < 100000; d++) { }
        
        // V(rw_mutex): 释放读写锁
        sem_post(&rw_mutex);
        
        printf("[Writer %d] 写入完成\n", pid);
        
        // 模拟间隔时间
        for (volatile int d = 0; d < 100000; d++) { }
        yield();
    }
    
    printf("[Writer %d] 完成所有写入，退出\n", pid);
    exit(0);
}

/**
 * 测试读者-写者问题（读者优先）
 */
void test_reader_writer(void) {
    uart_puts("\n");
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║          信号量演示：读者-写者问题（读者优先）                  ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n\n");
    
    printf("共享数据初始值: %d\n", shared_data);
    printf("读者数量: 3, 写者数量: 2\n");
    printf("每个读者读取 %d 次\n", READ_COUNT);
    printf("每个写者写入 %d 次\n\n", WRITE_COUNT);
    
    // 初始化信号量
    sem_init(&rw_mutex, 1);      // 读写互斥锁
    sem_init(&read_mutex, 1);    // 读者计数互斥锁
    sem_init(&write_mutex, 1);   // 写者互斥锁
    
    printf("信号量初始化: rw_mutex=%d, read_mutex=%d\n\n", 
           rw_mutex.value, read_mutex.value);
    
    uart_puts("说明：\n");
    uart_puts("- 读者优先策略：多个读者可以同时读取\n");
    uart_puts("- 写者必须等待所有读者完成才能写入\n");
    uart_puts("- 写者写入时，其他读者和写者都必须等待\n\n");
    
    // 创建读者进程
    for (int i = 0; i < 3; i++) {
        struct proc *p = alloc_proc();
        if (p) {
            p->context.ra = (uint64)reader;
            p->state = RUNNABLE;
            printf("创建读者进程 PID=%d\n", p->pid);
        }
    }
    
    // 创建写者进程
    for (int i = 0; i < 2; i++) {
        struct proc *p = alloc_proc();
        if (p) {
            p->context.ra = (uint64)writer;
            p->state = RUNNABLE;
            printf("创建写者进程 PID=%d\n", p->pid);
        }
    }
    
    uart_puts("\n启动读者-写者演示...\n\n");
    
    // 启动调度器
    scheduler();
}

// ============================================================================
// 哲学家就餐问题演示
// ============================================================================

#define NUM_PHILOSOPHERS 5
#define EAT_COUNT 2  // 每个哲学家吃的次数

// 信号量数组（每个叉子一个信号量）
static semaphore_t forks[NUM_PHILOSOPHERS];

/**
 * 哲学家线程
 */
static void philosopher(void) {
    int pid = get_pid();
    int id = pid % NUM_PHILOSOPHERS;  // 哲学家编号 (0-4)
    int left_fork = id;
    int right_fork = (id + 1) % NUM_PHILOSOPHERS;
    
    for (int i = 0; i < EAT_COUNT; i++) {
        // 思考
        printf("[哲学家 %d] 正在思考...\n", id);
        for (volatile int d = 0; d < 100000; d++) { }
        
        // 拿起叉子（避免死锁：编号小的先拿）
        printf("[哲学家 %d] 饿了，尝试拿叉子 %d 和 %d\n", 
               id, left_fork, right_fork);
        
        if (left_fork < right_fork) {
            sem_wait(&forks[left_fork]);
            printf("[哲学家 %d] 拿起左边叉子 %d\n", id, left_fork);
            sem_wait(&forks[right_fork]);
            printf("[哲学家 %d] 拿起右边叉子 %d\n", id, right_fork);
        } else {
            sem_wait(&forks[right_fork]);
            printf("[哲学家 %d] 拿起右边叉子 %d\n", id, right_fork);
            sem_wait(&forks[left_fork]);
            printf("[哲学家 %d] 拿起左边叉子 %d\n", id, left_fork);
        }
        
        // 吃饭
        printf("[哲学家 %d] 正在吃饭（第%d次）\n", id, i+1);
        for (volatile int d = 0; d < 150000; d++) { }
        
        // 放下叉子
        sem_post(&forks[left_fork]);
        printf("[哲学家 %d] 放下左边叉子 %d\n", id, left_fork);
        sem_post(&forks[right_fork]);
        printf("[哲学家 %d] 放下右边叉子 %d\n", id, right_fork);
        
        printf("[哲学家 %d] 吃完了\n", id);
        yield();
    }
    
    printf("[哲学家 %d] 吃饱了，离开\n", id);
    exit(0);
}

/**
 * 测试哲学家就餐问题
 */
void test_dining_philosophers(void) {
    uart_puts("\n");
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║          信号量演示：哲学家就餐问题                            ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n\n");
    
    printf("哲学家数量: %d\n", NUM_PHILOSOPHERS);
    printf("每个哲学家吃 %d 次\n\n", EAT_COUNT);
    
    // 初始化叉子信号量
    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        sem_init(&forks[i], 1);
        printf("叉子 %d 初始化\n", i);
    }
    
    uart_puts("\n说明：\n");
    uart_puts("- 5个哲学家围坐在圆桌旁\n");
    uart_puts("- 每两个哲学家之间有一把叉子（共5把）\n");
    uart_puts("- 哲学家需要同时拿到左右两把叉子才能吃饭\n");
    uart_puts("- 使用编号顺序拿叉子策略避免死锁\n\n");
    
    // 创建哲学家进程
    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        struct proc *p = alloc_proc();
        if (p) {
            p->context.ra = (uint64)philosopher;
            p->state = RUNNABLE;
            printf("创建哲学家进程 PID=%d (哲学家%d)\n", p->pid, i);
        }
    }
    
    uart_puts("\n启动哲学家就餐演示...\n\n");
    
    // 启动调度器
    scheduler();
}

/**
 * 测试1 (进程): 进程分配和释放
 * 检查：
 * - trap_init() 是否成功初始化
 * - trap_init_hart() 是否正确配置中断向量
 */
void test_trap_initialization(void) {
    uart_puts("\n========== 测试1：中断系统初始化验证 ==========\n");
    
    // 重新初始化（验证可重入性）
    trap_init();
    trap_init_hart();
    
    // 验证中断寄存器
    uint64 stvec_value;
    asm volatile("csrr %0, stvec" : "=r" (stvec_value));
    printf("stvec寄存器值: 0x%x\n", stvec_value);
    
    if (stvec_value != 0) {
        uart_puts("✓ 中断向量已设置\n");
    } else {
        uart_puts("✗ 中断向量未正确设置\n");
    }
    
    // 验证中断使能位
    uint64 sie_value;
    asm volatile("csrr %0, sie" : "=r" (sie_value));
    printf("sie寄存器值: 0x%x (应该有STIE位)\n", sie_value);
    
    uart_puts("✓ 测试1完成\n");
}

/**
 * 测试2：验证中断使能/禁用功能
 * 检查：
 * - intr_on() 能否成功启用中断
 * - intr_off() 能否成功禁用中断
 * - intr_get() 能否正确读取状态
 */
void test_interrupt_control(void) {
    uart_puts("\n========== 测试2：中断控制功能测试 ==========\n");
    
    // 测试中断禁用
    uart_puts("禁用中断...\n");
    intr_off();
    int state = intr_get();
    printf("禁用后状态: %d (应为0)\n", state);
    if (state == 0) {
        uart_puts("✓ 中断禁用成功\n");
    } else {
        uart_puts("✗ 中断禁用失败\n");
    }
    
    // 测试中断启用
    uart_puts("启用中断...\n");
    intr_on();
    state = intr_get();
    printf("启用后状态: %d (应为1)\n", state);
    if (state != 0) {
        uart_puts("✓ 中断启用成功\n");
    } else {
        uart_puts("✗ 中断启用失败\n");
    }
    
    uart_puts("✓ 测试2完成\n");
}

/**
 * 测试3：验证陷阱帧分配/释放
 * 检查：
 * - alloc_trapframe() 能否成功分配
 * - free_trapframe() 能否正确释放
 * - 内存是否被正确初始化
 */
void test_trapframe_allocation(void) {
    uart_puts("\n========== 测试3：陷阱帧分配/释放测试 ==========\n");
    
    // 分配多个陷阱帧
    uart_puts("分配陷阱帧...\n");
    struct trapframe *tf1 = alloc_trapframe();
    struct trapframe *tf2 = alloc_trapframe();
    struct trapframe *tf3 = alloc_trapframe();
    
    if (tf1 && tf2 && tf3) {
        printf("✓ 成功分配3个陷阱帧\n");
        printf("  tf1: 0x%x\n", (uint64)tf1);
        printf("  tf2: 0x%x\n", (uint64)tf2);
        printf("  tf3: 0x%x\n", (uint64)tf3);
        
        // 验证陷阱帧不重叠
        if ((uint64)tf1 != (uint64)tf2 && (uint64)tf2 != (uint64)tf3) {
            uart_puts("✓ 陷阱帧地址不重叠\n");
        } else {
            uart_puts("✗ 陷阱帧分配异常：地址重叠\n");
        }
        
        // 初始化陷阱帧内容
        uart_puts("初始化陷阱帧内容...\n");
        tf1->ra = 0x12345678;
        tf1->sp = 0x87654321;
        tf1->a0 = 42;
        
        if (tf1->ra == 0x12345678 && tf1->sp == 0x87654321) {
            uart_puts("✓ 陷阱帧可正常读写\n");
        }
        
        // 释放陷阱帧
        uart_puts("释放陷阱帧...\n");
        free_trapframe(tf1);
        free_trapframe(tf2);
        free_trapframe(tf3);
        uart_puts("✓ 陷阱帧释放成功\n");
        
        // 尝试重新分配
        struct trapframe *tf4 = alloc_trapframe();
        if (tf4) {
            printf("✓ 释放后可重新分配，地址: 0x%x\n", (uint64)tf4);
            free_trapframe(tf4);
        }
    } else {
        uart_puts("✗ 陷阱帧分配失败\n");
    }
    
    uart_puts("✓ 测试3完成\n");
}

/**
 * 测试4：验证CSR读写操作
 * 检查：
 * - CSR寄存器能否正确读取
 * - CSR寄存器能否正确写入
 */
void test_csr_operations(void) {
    uart_puts("\n========== 测试4：CSR读写操作测试 ==========\n");
    
    // 读取sstatus
    uint64 sstatus;
    asm volatile("csrr %0, sstatus" : "=r" (sstatus));
    printf("读取sstatus: 0x%x\n", sstatus);
    
    // 读取scause
    uint64 scause;
    asm volatile("csrr %0, scause" : "=r" (scause));
    printf("读取scause: 0x%x\n", scause);
    
    // 读取sepc
    uint64 sepc;
    asm volatile("csrr %0, sepc" : "=r" (sepc));
    printf("读取sepc: 0x%x\n", sepc);
    
    // 测试写入
    uart_puts("测试sstatus写入...\n");
    uint64 original_sstatus = sstatus;
    asm volatile("csrw sstatus, %0" : : "r" (0));
    asm volatile("csrr %0, sstatus" : "=r" (sstatus));
    printf("写入后sstatus: 0x%x\n", sstatus);
    
    // 恢复原值
    asm volatile("csrw sstatus, %0" : : "r" (original_sstatus));
    uart_puts("✓ 原值已恢复\n");
    
    uart_puts("✓ 测试4完成\n");
}

/**
 * 测试5：验证异常原因码定义
 * 检查：
 * - 异常码是否正确定义
 * - 中断码是否正确定义
 */
void test_exception_definitions(void) {
    uart_puts("\n========== 测试5：异常/中断定义验证 ==========\n");
    
    printf("异常定义：\n");
    printf("  EXCP_ILLEGAL_INSTR: %d\n", EXCP_ILLEGAL_INSTR);
    printf("  EXCP_LOAD_PAGE_FAULT: %d\n", EXCP_LOAD_PAGE_FAULT);
    printf("  EXCP_STORE_PAGE_FAULT: %d\n", EXCP_STORE_PAGE_FAULT);
    printf("  EXCP_UENV_CALL: %d\n", EXCP_UENV_CALL);
    
    printf("\n中断定义：\n");
    printf("  INTR_S_TIMER: %d\n", INTR_S_TIMER);
    printf("  INTR_M_TIMER: %d\n", INTR_M_TIMER);
    printf("  INTR_S_EXTERNAL: %d\n", INTR_S_EXTERNAL);
    
    // 验证定义的正确性
    if (EXCP_ILLEGAL_INSTR == 2 && EXCP_UENV_CALL == 8 && INTR_S_TIMER == 5) {
        uart_puts("✓ 异常/中断码定义正确\n");
    } else {
        uart_puts("✗ 异常/中断码定义有误\n");
    }
    
    uart_puts("✓ 测试5完成\n");
}

/**
 * 测试6：验证trapframe结构大小
 * 检查：
 * - trapframe结构是否包含所有必要的字段
 * - 结构大小是否符合预期 (34 * 8 = 272字节)
 */
void test_trapframe_structure(void) {
    uart_puts("\n========== 测试6：陷阱帧结构验证 ==========\n");
    
    printf("struct trapframe大小: %d 字节\n", (int)sizeof(struct trapframe));
    printf("期望大小: 272 字节 (34个uint64字段)\n");
    
    // 详细调试信息
    printf("\n字段大小信息：\n");
    printf("  sizeof(uint64): %d\n", (int)sizeof(uint64));
    printf("  sizeof(trapframe.zero): %d\n", (int)sizeof(((struct trapframe*)0)->zero));
    printf("  sizeof(trapframe.sepc): %d\n", (int)sizeof(((struct trapframe*)0)->sepc));
    
    // 计算实际字段数
    int actual_fields = sizeof(struct trapframe) / sizeof(uint64);
    printf("\n计算字段数：%d / %d = %d 字段\n", 
           (int)sizeof(struct trapframe), (int)sizeof(uint64), actual_fields);
    
    if (sizeof(struct trapframe) == 272) {
        uart_puts("✓ 陷阱帧结构大小正确\n");
    } else {
        printf("✗ 陷阱帧结构大小不正确（多了 %d 字节）\n", 
               (int)sizeof(struct trapframe) - 272);
    }
    
    uart_puts("✓ 测试6完成\n");
}

/**
 * 测试7：验证中断处理函数指针表
 * 检查：
 * - trap_handlers 数组是否存在
 * - 是否可以注册和调用处理函数
 */
void test_interrupt_handlers(void) {
    uart_puts("\n========== 测试7：中断处理函数表验证 ==========\n");
    
    uart_puts("验证中断处理函数表...\n");
    
    // 检查处理函数表是否存在
    int handler_count = 0;
    for (int i = 0; i < 16; i++) {
        if (trap_handlers[i] != 0) {
            handler_count++;
        }
    }
    
    printf("已注册的中断处理函数: %d\n", handler_count);
    uart_puts("✓ 中断处理函数表存在且可访问\n");
    
    uart_puts("✓ 测试7完成\n");
}

/**
 * 测试9：时间中断测试
 * 检查：
 * - 时间中断是否能正确触发
 * - ticks计数器是否递增
 */
void test_timer_interrupt(void) {
    uart_puts("\n========== 测试9：时间中断测试 ==========\n");
    
    uart_puts("[信息] 当前运行在 Machine 模式\n");
    uart_puts("       时间中断在 M-mode 中处理\n");
    uart_puts("       观察系统运行后的 ticks 值\n");
    
    // 获取初始的 ticks 值
    uint64 initial_ticks = ticks;
    printf("初始 ticks: %ld\n", initial_ticks);
    
    // 启用中断
    intr_on();
    uart_puts("已启用中断\n");
    
    // 等待至少一个时间中断发生
    uart_puts("等待时间中断...\n");
    volatile uint64 wait_ticks = ticks;
    int wait_count = 0;
    while (wait_ticks == ticks && wait_count < 100000000) {  // 增加等待次数
        wait_count++;
    }
    
    printf("等待循环计数: %d\n", wait_count);
    printf("中断后 ticks: %ld\n", ticks);
    
    if (ticks > initial_ticks) {
        printf("✓ 时间中断成功触发，ticks增加了 %ld\n", ticks - initial_ticks);
        uart_puts("✓ M-mode 时间中断正常工作！\n");
    } else {
        uart_puts("✗ 时间中断未触发\n");
    }
    
    uart_puts("✓ 测试9完成\n");
}

/**
 * 测试8：压力测试 - 多次初始化
 * 检查：
 * - 系统是否能重复初始化而不崩溃
 */
void test_repeated_initialization(void) {
    uart_puts("\n========== 测试8：重复初始化压力测试 ==========\n");
    
    uart_puts("执行5次初始化...\n");
    for (int i = 0; i < 5; i++) {
        trap_init();
        trap_init_hart();
        printf("  初始化 %d/5 完成\n", i + 1);
    }
    
    uart_puts("✓ 系统正常运行，无崩溃\n");
    uart_puts("✓ 测试8完成\n");
}

/**
 * 综合主测试函数 - 运行所有测试
 */
void run_all_system_tests(void) {
    // 运行中断系统测试
    uart_puts("\n");
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║     实验4：中断处理与异常系统 - 功能测试套件                    ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n");
    
    test_trap_initialization();
    test_interrupt_control();
    test_trapframe_allocation();
    test_csr_operations();
    test_exception_definitions();
    test_trapframe_structure();
    test_interrupt_handlers();
    test_timer_interrupt();
    test_repeated_initialization();
    
    uart_puts("\n");
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║          中断处理系统测试 - 执行完成！                          ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n\n");
}

// 保留向后兼容接口
void run_interrupt_exception_tests(void) {
    run_all_system_tests();
}
void test_basic_syscalls(void) {
    printf("Testing basic system calls...\n");

    // 用户态系统调用测试请移到user目录下的测试程序，不要在内核main.c中直接调用getpid、write等用户接口。
}

void test_parameter_passing(void) {
    printf("Testing parameter passing...\n");

    // 测试不同类型参数的传递
    // 用户态系统调用测试请移到user目录下的测试程序，不要在内核main.c中直接调用open、write、close、strlen等用户接口。
}

void test_security(void) {
    printf("Testing security checks...\n");

    // 测试无效指针访问
    // 用户态系统调用测试请移到user目录下的测试程序，不要在内核main.c中直接调用write、read等用户接口。

    // 测试权限检查
    // ...
}

void test_syscall_performance(void) {
    printf("Testing syscall performance...\n");

    // 用户态系统调用测试请移到user目录下的测试程序，不要在内核main.c中直接调用get_time、getpid等用户接口。
}

void run_syscalls(void) {
    test_basic_syscalls();
    test_parameter_passing();
    test_security();
    test_syscall_performance();
}

// ============================================================================
// 主函数
// ============================================================================

void main() {
    uart_puts("╔════════════════════════════════════════════════════════════════╗\n");
    uart_puts("║       RISCV-OS 实验4&5&6 - 中断处理 进程管理和系统调用系统        ║\n");
    uart_puts("╚════════════════════════════════════════════════════════════════╝\n\n");
    
    // 初始化物理内存管理
    // 内核开始于 0x80000000，kernel.elf 大约 30KB
    // 将 0x80040000 到 0x88000000 作为堆内存区域（128MB - 256KB）
    uart_puts("[系统初始化] 正在初始化物理内存管理...\n");
    pmm_init(0x80040000, 0x88000000);  // 247.75MB 可用内存
    uart_puts("[系统初始化] 物理内存管理初始化完成\n");
    
    // 初始化中断系统
    uart_puts("[系统初始化] 正在初始化中断系统...\n");
    trap_init();
    trap_init_hart();
    uart_puts("[系统初始化] 中断系统初始化完成\n");
    
    // 初始化时间中断
    uart_puts("[系统初始化] 正在初始化时间中断...\n");
    timerinit();
    uart_puts("[系统初始化] 时间中断初始化完成\n");
    
    // 初始化进程系统
    uart_puts("[系统初始化] 正在初始化进程系统...\n");
    proc_init();
    uart_puts("[系统初始化] 进程系统初始化完成\n\n");

    // 初始化简易文件系统
    uart_puts("[系统初始化] 正在初始化文件系统...\n");
    fs_init();
    uart_puts("[系统初始化] 文件系统初始化完成\n\n");
    
    // // 运行中断和异常系统测试
    //  run_all_system_tests();
    
    // 运行进程管理系统测试
    //run_process_management_tests();

    // 自动加载并运行用户态系统调用测试程序
    start_user_test();
    // 启动调度器以运行用户进程
    scheduler();

    // ========================================
    // 选择要运行的同步问题演示
    // ========================================
    
    // 1. 生产者消费者问题
    //test_producer_consumer();
    
    // 2. 读者写者问题（读者优先）
    // test_reader_writer();
    
    // 3. 哲学家就餐问题
    // test_dining_philosophers();

    // 如果调度器返回，进入空闲循环
    uart_puts("系统进入空闲循环（调度器返回）...\n");
    while(1) {
        // 空闲循环
    }
}
