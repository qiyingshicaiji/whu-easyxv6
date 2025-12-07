# 实验5 快速参考指南

## 🎯 核心概念速查

### 进程状态转换
```
UNUSED (未使用)
  ↓ alloc_proc()
USED (已分配)
  ↓ proc_mark_runnable()
RUNNABLE (可运行)
  ↓ scheduler() [切换到该进程]
RUNNING (正在运行)
  ├→ yield() → RUNNABLE (让出CPU)
  ├→ sleep() → SLEEPING (等待事件)
  ├→ exit() → ZOMBIE (退出)
  └→ [时钟中断] → yield() → RUNNABLE
```

### 关键数据结构

#### `struct proc`
```c
struct proc {
    enum procstate state;      // 当前状态
    int pid;                   // 进程ID
    struct context context;    // 调度上下文
    struct trapframe *trapframe;  // 用户状态保存
    char *kstack;              // 内核栈
    // ... 其他字段
};
```

#### `struct context`
```c
struct context {
    uint64 ra;     // 返回地址
    uint64 sp;     // 栈指针
    uint64 s0-s11; // 被调用者保存寄存器
};
```

---

## 🔧 API 参考

### 进程管理

```c
// 初始化进程系统
void proc_init(void);

// 进程分配/释放
struct proc* alloc_proc(void);
void free_proc(struct proc *p);

// 进程查找
struct proc* find_proc(int pid);

// 进程状态转换
void proc_mark_runnable(struct proc *p);
void proc_mark_sleeping(struct proc *p, void *chan);
void proc_mark_zombie(struct proc *p, int xstate);

// 获取当前进程
struct proc* get_current_proc(void);
int get_pid(void);
```

### 调度相关

```c
// 启动调度器（通常在main中调用）
void scheduler(void);

// 当前进程主动让出CPU
void yield(void);

// 进程切换（汇编）
void switch_context(struct context *old, struct context *new);

// 睡眠/唤醒
void sleep(void *chan);
void wakeup(void *chan);
void wakeup_one(void *chan);
```

### 进程生命周期

```c
// 创建子进程
int fork(void);

// 进程退出
void exit(int status);

// 等待子进程
int wait(int *status);

// 杀死进程
void kill(int pid);
```

### 工具函数

```c
// 获取系统时钟滴答数
uint64 get_ticks(void);
```

---

## 💡 常见操作示例

### 创建并运行进程

```c
// 分配进程
struct proc *p = alloc_proc();
if (!p) {
    // 内存不足
}

// 设置进程状态
p->state = RUNNABLE;

// 调度器会在下一个时间片选择它运行
```

### 实现Fork

```c
int fork(void) {
    struct proc *parent = current_proc;
    struct proc *child = alloc_proc();
    
    // 建立父子关系
    child->parent = parent;
    child->ppid = parent->pid;
    
    // 复制内存空间
    // (实际实现中需要复制页表)
    
    // 复制陷阱帧
    memcpy(child->trapframe, parent->trapframe, ...);
    
    // 子进程返回值为0
    child->trapframe->a0 = 0;
    
    // 标记为可运行
    child->state = RUNNABLE;
    
    // 父进程返回子进程PID
    return child->pid;
}
```

### 实现Exit

```c
void exit(int status) {
    struct proc *p = current_proc;
    
    // 标记为僵尸进程
    p->state = ZOMBIE;
    p->xstate = status;
    
    // 重新绑定子进程
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].parent == p) {
            proc[i].ppid = 1;  // 绑定给init
        }
    }
    
    // 让出CPU
    yield();
}
```

### 实现Wait

```c
int wait(int *status) {
    struct proc *p = current_proc;
    
    for (;;) {
        // 查找ZOMBIE子进程
        for (int i = 0; i < NPROC; i++) {
            if (proc[i].parent == p && proc[i].state == ZOMBIE) {
                int pid = proc[i].pid;
                if (status) *status = proc[i].xstate;
                free_proc(&proc[i]);
                return pid;
            }
        }
        
        // 没有子进程返回-1
        // 有子进程但都未结束，睡眠等待
        sleep(p);
    }
}
```

---

## 🐛 调试技巧

### 追踪进程创建

```c
void alloc_proc(void) {
    // ...
    printf("[proc] Allocated process: pid=%d\n", p->pid);
    // 会看到输出
}
```

### 观察调度

在 `scheduler()` 中添加：
```c
printf("[proc] Switching to process %d\n", p->pid);
```

### 检查进程状态

```c
// 在gdb中查看所有进程
(gdb) p proc[]
(gdb) p proc[0].state

// 0=UNUSED, 1=USED, 2=RUNNABLE, 3=RUNNING, 4=SLEEPING, 5=ZOMBIE
```

### 内存检查

```c
// 检查内核栈是否溢出
if ((uint64)p->kstack < mem_start) {
    uart_puts("Kernel stack overflow!\n");
}
```

---

## ⚠️ 常见错误

### 错误1：忘记初始化进程系统
```c
// ✗ 错误
main() {
    // 直接使用alloc_proc()
    struct proc *p = alloc_proc();  // 会失败！
}

// ✓ 正确
main() {
    proc_init();
    struct proc *p = alloc_proc();  // 成功
}
```

### 错误2：上下文切换时没有关闭中断
```c
// ✗ 错误
void yield(void) {
    switch_context(&p->context, &scheduler_context);
    // 可能在切换中发生中断，导致混乱
}

// ✓ 正确
void yield(void) {
    intr_off();
    switch_context(&p->context, &scheduler_context);
    intr_on();
}
```

### 错误3：Fork中忘记设置返回值
```c
// ✗ 错误 - 子进程会看到父进程的返回值
memcpy(child->trapframe, parent->trapframe, sizeof(*child->trapframe));
child->state = RUNNABLE;

// ✓ 正确
memcpy(child->trapframe, parent->trapframe, sizeof(*child->trapframe));
child->trapframe->a0 = 0;  // 子进程返回0
child->state = RUNNABLE;
```

### 错误4：Exit中没有让出CPU
```c
// ✗ 错误 - 进程不会真正退出
void exit(int status) {
    p->state = ZOMBIE;
    // 忘记yield() - 进程还在运行！
}

// ✓ 正确
void exit(int status) {
    p->state = ZOMBIE;
    yield();  // 让出CPU给其他进程
}
```

---

## 📊 进程表大小配置

文件：`include/proc.h`
```c
#define NPROC 16  // 最多16个进程

// 如果需要更多进程，修改为：
#define NPROC 32  // 最多32个进程
```

内存占用估算：
```
每个进程：
  - struct proc: ~200字节
  - trapframe: 272字节
  - 内核栈: 4096字节
  - 总计：~4600字节/进程

16个进程：~73.6 KB
32个进程：~147.2 KB
```

---

## 🔍 性能优化建议

### 1. 调度器优化
```c
// 当前：线性查找O(NPROC)
for (p = proc; p < &proc[NPROC]; p++) {
    if (p->state == RUNNABLE) { ... }
}

// 优化：使用就绪队列
struct list ready_queue;
// 只需要O(1)添加和删除
```

### 2. 上下文切换优化
```asm
# 当前：14个寄存器，112字节
# 优化：使用更少的寄存器（如果可能）
# 或使用RISC-V扩展指令加速
```

### 3. 进程查找优化
```c
// 当前：线性查找O(NPROC)
struct proc* find_proc(int pid) {
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].pid == pid) return &proc[i];
    }
}

// 优化：使用哈希表或树形结构
```

---

## 🧪 测试清单

- [ ] 进程分配和释放
- [ ] 进程查找
- [ ] 进程状态转换
- [ ] Fork系统调用
- [ ] Exit系统调用
- [ ] Wait系统调用
- [ ] 调度器基本功能
- [ ] 上下文切换
- [ ] 时钟中断驱动调度
- [ ] 内存保护（栈溢出检测）

---

## 📚 相关阅读

1. **xv6源代码** - `kernel/proc.c`
   - 完整的进程实现参考

2. **操作系统概念** - 第3章进程
   - 进程状态转换
   - 进程控制

3. **RISC-V特权级规范**
   - CSR寄存器
   - 中断/异常处理

---

