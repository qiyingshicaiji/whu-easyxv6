# 实验5 实现细节详解

## 目录
1. [核心数据结构](#核心数据结构)
2. [进程管理实现](#进程管理实现)
3. [调度器设计](#调度器设计)
4. [上下文切换](#上下文切换)
5. [系统调用实现](#系统调用实现)
6. [中断集成](#中断集成)

---

## 核心数据结构

### 1. 进程结构体分析

```c
struct proc {
    // 1. 进程标识和状态 (8 bytes)
    enum procstate state;    // UNUSED/USED/RUNNABLE/RUNNING/SLEEPING/ZOMBIE
    
    // 2. 进程ID管理 (12 bytes)
    int pid;                 // 进程ID (唯一)
    int ppid;                // 父进程ID
    int xstate;              // 退出状态码
    int killed;              // kill标志位
    
    // 3. 内存管理 (16 bytes)
    pagetable_t pagetable;   // 用户空间页表
    uint64 sz;               // 进程内存大小
    char *kstack;            // 内核栈指针
    
    // 4. 执行状态 (16 bytes)
    struct trapframe *trapframe;  // 陷阱帧（保存用户态寄存器）
    struct context context;       // 调度上下文（保存内核态寄存器）
    
    // 5. 进程关系 (16 bytes)
    struct proc *parent;         // 父进程指针
    void *chan;                  // 等待通道（用于sleep/wakeup）
    int wait_pid;                // wait时等待的PID
};
```

**内存布局**：
```
进程表 (NPROC个)
  ↓
struct proc proc[16]
  每个占用 ~280字节（不含内核栈和页表）
  总计 ~4.5KB
```

### 2. 上下文结构体分析

```c
struct context {
    // 被调用者保存寄存器（14个 × 8字节 = 112字节）
    uint64 ra;      // x1  - 返回地址（关键！）
    uint64 sp;      // x2  - 栈指针
    uint64 s0-s11;  // x8,x9,x18-x27 - 保存寄存器
};
```

**为什么只保存14个寄存器？**
- 调用者保存寄存器（a0-a7, t0-t6）在函数调用时由调用者保存
- 临时寄存器（t0-t6）在context切换时不需要保存
- 只需保存被调用者保存的寄存器，减少切换开销
- 返回地址(ra)和栈指针(sp)最关键，必须保存

---

## 进程管理实现

### 1. 进程初始化 - `proc_init()`

```c
void proc_init(void) {
    // 1. 清零进程表
    memset(proc, 0, sizeof(proc));
    
    // 2. 初始化全局状态
    nextpid = 1;              // 下一个PID从1开始
    current_proc = 0;         // 还没有当前进程
    
    // 3. 初始化每个进程槽位
    for (int i = 0; i < NPROC; i++) {
        proc[i].state = UNUSED;
        proc[i].pid = 0;
        proc[i].ppid = 0;
    }
}
```

**时间复杂度**：O(NPROC)  
**空间复杂度**：O(1)

### 2. 进程分配 - `alloc_proc()`

```c
struct proc* alloc_proc(void) {
    spin_lock(&proc_lock);  // 互斥保护
    
    // 1. 查找未使用的槽位 O(NPROC)
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].state == UNUSED) {
            struct proc *p = &proc[i];
            
            // 2. 初始化进程元数据
            p->state = USED;
            p->pid = nextpid++;     // 分配唯一PID
            p->ppid = 0;
            p->killed = 0;
            p->xstate = 0;
            
            // 3. 分配陷阱帧 (trapframe pool)
            p->trapframe = alloc_trapframe();
            if (!p->trapframe) {
                spin_unlock(&proc_lock);
                return 0;  // 陷阱帧不足
            }
            
            // 4. 分配内核栈 (4KB)
            p->kstack = (char *)alloc_page();
            if (!p->kstack) {
                free_trapframe(p->trapframe);
                spin_unlock(&proc_lock);
                return 0;  // 内存不足
            }
            
            // 5. 初始化上下文
            memset(&p->context, 0, sizeof(p->context));
            p->context.sp = (uint64)p->kstack + PAGE_SIZE;  // 栈顶
            
            spin_unlock(&proc_lock);
            return p;
        }
    }
    
    spin_unlock(&proc_lock);
    return 0;  // 所有槽位都满了
}
```

**资源分配**：
```
alloc_proc()调用序列：
  1. 分配trapframe (272字节，来自trapframe_pool)
  2. 分配kstack (4096字节，来自物理内存)
  3. 初始化context
```

**失败处理**：
- 如果分配失败，自动回滚之前分配的资源
- 使用自旋锁保证原子性

### 3. 进程释放 - `free_proc()`

```c
void free_proc(struct proc *p) {
    if (!p) return;
    
    spin_lock(&proc_lock);
    
    // 1. 释放陷阱帧
    if (p->trapframe) {
        free_trapframe(p->trapframe);
        p->trapframe = 0;
    }
    
    // 2. 释放内核栈
    if (p->kstack) {
        free_page(p->kstack);
        p->kstack = 0;
    }
    
    // 3. 释放页表（如果有）
    if (p->pagetable) {
        destroy_pagetable(p->pagetable);
        p->pagetable = 0;
    }
    
    // 4. 标记为未使用
    p->state = UNUSED;
    p->pid = 0;
    
    spin_unlock(&proc_lock);
}
```

**释放顺序很重要**：必须先释放陷阱帧，再释放栈，防止悬空指针。

### 4. 进程查找 - `find_proc()`

```c
struct proc* find_proc(int pid) {
    // O(NPROC) 线性查找
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].pid == pid && proc[i].state != UNUSED) {
            return &proc[i];
        }
    }
    return 0;
}
```

**优化机会**：可使用哈希表或树形结构降低到O(log NPROC)。

---

## 调度器设计

### 1. 轮转调度算法

```c
void scheduler(void) {
    struct proc *p;
    struct cpu *c = &cpus[0];
    
    for (;;) {
        // 1. 启用中断（允许硬件中断）
        intr_on();
        
        // 2. 轮转查找RUNNABLE进程
        int found = 0;
        static int last_index = 0;
        
        for (int i = 0; i < NPROC; i++) {
            int idx = (last_index + i) % NPROC;
            p = &proc[idx];
            
            if (p->state == RUNNABLE) {
                // 3. 切换到该进程
                p->state = RUNNING;
                c->proc = p;
                current_proc = p;
                
                intr_off();  // 关闭中断以保护上下文切换
                
                // 4. 执行上下文切换！
                // 保存当前(scheduler)的context，
                // 恢复进程p的context
                switch_context(&scheduler_context, &p->context);
                
                // 当进程yield()回来时，从这里继续
                intr_on();
                
                last_index = (idx + 1) % NPROC;
                found = 1;
                break;
            }
        }
        
        if (!found) {
            // 没有可运行的进程，继续循环
        }
    }
}
```

**关键设计点**：
1. **轮转索引**：使用`last_index`记住上次的位置，实现真正的轮转
2. **中断管理**：
   - `intr_on()` 允许时钟中断，进程可以被抢占
   - `intr_off()` 在上下文切换时保护
3. **状态转换**：RUNNABLE → RUNNING → yield() → RUNNABLE

### 2. 让出CPU - `yield()`

```c
void yield(void) {
    struct proc *p = current_proc;
    if (!p) return;
    
    // 1. 关闭中断（原子操作）
    intr_off();
    
    // 2. 获取锁
    spin_lock(&proc_lock);
    if (p->state == RUNNING) {
        p->state = RUNNABLE;
    }
    spin_unlock(&proc_lock);
    
    printf("[proc] Process %d yielding CPU\n", p->pid);
    
    // 3. 切换回调度器
    // 这会保存当前进程的context，
    // 恢复scheduler_context
    switch_context(&p->context, &scheduler_context);
    
    // 当该进程再次被调度时，从这里恢复
    intr_on();
}
```

**执行流**：
```
进程运行 →(yield被调用) 
    → 保存进程context
    → 恢复scheduler_context
    → 回到scheduler()中switch_context之后
    → scheduler继续循环选择下一个进程
```

---

## 上下文切换

### 1. 汇编实现 - `switch_context()`

```asm
# void switch_context(struct context *old, struct context *new)
# a0 = old context pointer
# a1 = new context pointer

switch_context:
    # ===== 保存old上下文 =====
    
    # 1. 返回地址和栈指针（最关键）
    sd x1, 0(a0)        # 保存ra (返回地址)
    sd x2, 8(a0)        # 保存sp (栈指针)
    
    # 2. 被调用者保存寄存器（必须保存）
    sd x8,  16(a0)      # s0
    sd x9,  24(a0)      # s1
    sd x18, 32(a0)      # s2
    sd x19, 40(a0)      # s3
    sd x20, 48(a0)      # s4
    sd x21, 56(a0)      # s5
    sd x22, 64(a0)      # s6
    sd x23, 72(a0)      # s7
    sd x24, 80(a0)      # s8
    sd x25, 88(a0)      # s9
    sd x26, 96(a0)      # s10
    sd x27, 104(a0)     # s11
    
    # ===== 恢复new上下文 =====
    
    # 1. 恢复被调用者保存寄存器
    ld x1,  0(a1)       # 恢复ra
    ld x2,  8(a1)       # 恢复sp
    ld x8,  16(a1)      # 恢复s0
    ld x9,  24(a1)      # 恢复s1
    ld x18, 32(a1)      # 恢复s2
    ld x19, 40(a1)      # 恢复s3
    ld x20, 48(a1)      # 恢复s4
    ld x21, 56(a1)      # 恢复s5
    ld x22, 64(a1)      # 恢复s6
    ld x23, 72(a1)      # 恢复s7
    ld x24, 80(a1)      # 恢复s8
    ld x25, 88(a1)      # 恢复s9
    ld x26, 96(a1)      # 恢复s10
    ld x27, 104(a1)     # 恢复s11
    
    # 2. 返回到new进程的返回地址
    # 现在x1 = new->ra，所以ret会跳转到new进程的地方
    ret
```

**执行细节**：
```
切换前：sp指向old栈，x1=old的返回地址，其他寄存器是old的值
执行switch_context:
  1. 保存所有old的寄存器到old context
  2. 从new context恢复所有寄存器
  3. ret指令跳转到new->ra（new进程的返回地址）
切换后：sp指向new栈，x1=new的返回地址，其他寄存器是new的值
```

### 2. 切换的时间开销

```
每次切换需要：
  - 14次 store (存储到内存)
  - 14次 load (从内存加载)
  - 1次 ret
  
共29条指令 × (~10周期) ≈ 290 CPU周期 @ 10MHz ≈ 29微秒
```

---

## 系统调用实现

### 1. Fork实现

```c
int fork(void) {
    struct proc *parent = current_proc;
    if (!parent) {
        uart_puts("[proc] fork: no current process\n");
        return -1;
    }
    
    // 1. 分配新进程
    struct proc *child = alloc_proc();
    if (!child) {
        uart_puts("[proc] fork: failed to allocate process\n");
        return -1;
    }
    
    // 2. 建立父子关系
    child->parent = parent;
    child->ppid = parent->pid;
    
    // 3. 复制页表
    if (parent->pagetable) {
        child->pagetable = create_pagetable();
        if (!child->pagetable) {
            free_proc(child);
            return -1;
        }
        // TODO: 复制内存内容或使用写时复制
    }
    
    // 4. 复制陷阱帧
    if (parent->trapframe && child->trapframe) {
        memcpy(child->trapframe, parent->trapframe, 
               sizeof(struct trapframe));
        
        // 关键：设置返回值
        // 子进程的a0（返回值）必须是0
        child->trapframe->a0 = 0;
    }
    
    // 5. 标记为可运行
    child->state = RUNNABLE;
    
    printf("[proc] fork: created process %d (parent %d)\n", 
           child->pid, parent->pid);
    
    // 6. 父进程返回子进程PID
    return child->pid;
}
```

**返回值设置的魔法**：
```
Parent (fork()返回后):
  a0 = child_pid (返回给父进程)
  
Child (创建后):
  trapframe->a0 = 0 (预设返回值)
  state = RUNNABLE (等待被调度)
  
Child (被调度运行后):
  从user entry point恢复
  a0 = 0（从trapframe恢复）
  返回到用户代码，fork()返回0给子进程
```

### 2. Exit实现

```c
void exit(int status) {
    struct proc *p = current_proc;
    if (!p) return;
    
    spin_lock(&proc_lock);
    
    // 1. 标记为僵尸进程
    p->xstate = status;
    p->state = ZOMBIE;
    
    // 2. 重新绑定子进程给init进程
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].parent == p) {
            proc[i].parent = 0;
            proc[i].ppid = 1;  // 假设PID 1是init
        }
    }
    
    printf("[proc] exit: process %d exited with status %d\n", 
           p->pid, status);
    
    spin_unlock(&proc_lock);
    
    // 3. 让出CPU给其他进程
    // （本进程不会再被运行）
    yield();
}
```

**关键点**：
- 进程不能自己释放自己（自杀）
- 进程变成ZOMBIE，等待父进程wait()收割
- 让出CPU使其他进程能运行

### 3. Wait实现

```c
int wait(int *status) {
    struct proc *p = current_proc;
    if (!p) return -1;
    
    for (;;) {
        spin_lock(&proc_lock);
        
        // 1. 查找任何ZOMBIE子进程
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
            // 2. 找到ZOMBIE子进程，收割它
            int pid = zombie->pid;
            if (status) {
                *status = zombie->xstate;
            }
            
            // 3. 清理进程资源
            free_proc(zombie);
            
            printf("[proc] wait: reaped process %d\n", pid);
            
            spin_unlock(&proc_lock);
            return pid;
        }
        
        // 4. 检查是否有子进程
        int has_children = 0;
        for (int i = 0; i < NPROC; i++) {
            if (proc[i].parent == p && proc[i].state != UNUSED) {
                has_children = 1;
                break;
            }
        }
        
        if (!has_children) {
            // 没有子进程，返回-1
            spin_unlock(&proc_lock);
            return -1;
        }
        
        spin_unlock(&proc_lock);
        
        // 5. 有子进程但都未结束，睡眠等待
        sleep(p);
    }
}
```

---

## 中断集成

### 1. 时钟中断驱动调度

```c
void handle_timer_interrupt(void) {
    printf("[timer] Timer interrupt: ticks=%ld\n", ticks);
    
    // 获取当前进程
    struct proc *p = get_current_proc();
    
    // 只有进程正在运行时才抢占
    if (p && p->state == RUNNING) {
        printf("[timer] Preempting process %d, yielding CPU\n", p->pid);
        
        // 调用yield()让出CPU
        // 这会触发上下文切换回调度器
        yield();
    }
}
```

**流程图**：
```
定时器硬件
  ↓ (每100ms)
时钟中断发生
  ↓
M-mode中断处理 (machinevec.S)
  ↓
S-mode中断处理 (kernelvec.S)
  ↓
trap() / usertrap()
  ↓
devintr() (中断分发)
  ↓
handle_timer_interrupt()
  ↓
yield() (当前进程让出)
  ↓
switch_context() (保存→调度器)
  ↓
scheduler() (选择下一个进程)
  ↓
switch_context() (调度器→新进程)
  ↓
新进程继续执行
```

### 2. 中断驱动的抢占

优势：
- 自动触发，无需主动检查
- 实现真正的时间片轮转
- 进程无法独占CPU
- 公平性好

---

## 总结

实验5实现了一个完整的进程调度系统，核心特点：

1. **简洁而有效的数据结构** - struct proc和struct context设计优雅
2. **汇编级上下文切换** - 高效的寄存器保存和恢复
3. **轮转调度算法** - 简单公平的调度策略
4. **中断驱动** - 基于时钟中断的自动抢占
5. **进程生命周期完整** - Fork/Exit/Wait框架就绪

系统已为虚拟内存、文件系统等高层功能的实现做好了准备。

