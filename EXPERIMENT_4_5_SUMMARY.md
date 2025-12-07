# 实验4 & 5 实现总结 - 中断处理与进程管理

## 概述
本次实现参考xv6操作系统，为RISCV-OS添加了完整的中断处理系统（实验4）和进程管理与调度系统（实验5）。

## 实验4：中断处理与时钟管理

### 核心文件
- `include/trap.h` - 中断处理框架定义
- `kernel/trap.c` - 中断处理核心实现
- `kernel/kernelvec.S` - 内核态中断向量入口
- `kernel/uservec.S` - 用户态中断向量入口

### 主要功能

#### 1. 中断框架 (`include/trap.h`)
```c
struct trapframe {
    // 32个通用寄存器
    uint64 zero, ra, sp, gp, tp, t0, t1, t2, s0, s1, a0, a1, a2, a3, a4, a5, a6, a7;
    uint64 s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, t3, t4, t5, t6;
    
    // 4个重要的CSR
    uint64 sstatus;   // 监督模式状态
    uint64 sepc;      // 异常程序计数器
    uint64 scause;    // 异常原因
    uint64 stval;     // 陷阱值
};
```

#### 2. 异常类型支持
- 指令/数据页故障处理
- 非法指令异常
- 系统调用（ecall）
- 时钟中断
- 外部中断

#### 3. CSR操作函数
- `r_sstatus/w_sstatus` - 状态寄存器读写
- `r_scause` - 中断原因寄存器读
- `r_sepc/w_sepc` - 异常PC读写
- `r_sie/w_sie` - 中断使能寄存器读写

#### 4. 中断使能/禁用
```c
void intr_on(void);    // 启用中断
void intr_off(void);   // 禁用中断
int intr_get(void);    // 获取当前中断状态
```

#### 5. 中断处理流程
- 用户态中断 → `uservec.S` → `usertrap()` → C处理
- 内核态中断 → `kernelvec.S` → `kerneltrap()` → C处理
- 设备中断分发 → `devintr()`
- 异常处理 → `handle_exception()`

### 关键设计决定

1. **上下文保存**：在kernelvec.S中保存所有32个寄存器 + 2个CSR（272字节）
2. **中断嵌套**：暂时未支持嵌套中断，可在future work中扩展
3. **中断优先级**：简化实现，所有中断优先级相同

---

## 实验5：进程管理与调度

### 核心文件
- `include/proc.h` - 进程管理框架定义
- `kernel/proc.c` - 进程管理核心实现
- `kernel/swtch.S` - 上下文切换汇编代码

### 主要功能

#### 1. 进程结构 (`include/proc.h`)
```c
struct proc {
    enum procstate state;      // 进程状态
    int pid, ppid;            // 进程ID和父进程ID
    int xstate;               // 退出状态
    int killed;               // 是否被杀死
    
    pagetable_t pagetable;    // 用户页表
    uint64 sz;                // 内存大小
    char *kstack;             // 内核栈
    
    struct trapframe *trapframe;  // 用户陷阱帧
    struct context context;       // 调度上下文
    struct proc *parent;          // 父进程指针
    void *chan;               // 睡眠通道
};
```

#### 2. 进程状态转换
```
UNUSED → USED → RUNNABLE → RUNNING → SLEEPING → ZOMBIE → (reaped)
```

#### 3. 上下文结构 (`struct context`)
只保存被调用者保存的寄存器（14个寄存器，112字节）：
- `ra` - 返回地址
- `sp` - 栈指针  
- `s0-s11` - 保存寄存器

#### 4. 核心进程操作

**进程生命周期：**
```c
int fork(void);              // 创建子进程（简化版）
void exit(int status);       // 进程退出
int wait(int *status);       // 等待子进程
```

**进程管理：**
```c
void proc_init(void);        // 初始化进程系统
struct proc* alloc_proc(void);     // 分配进程
void free_proc(struct proc *p);    // 释放进程
struct proc* find_proc(int pid);   // 按PID查找
```

**进程调度：**
```c
void scheduler(void);        // 调度器主循环
void yield(void);           // 放弃CPU
void switch_context(...);   // 上下文切换
```

**进程睡眠/唤醒：**
```c
void sleep(void *chan);     // 睡眠
void wakeup(void *chan);    // 唤醒所有
void wakeup_one(void *chan); // 唤醒一个
```

#### 5. 上下文切换（`swtch.S`）
```assembly
switch_context(old_ctx, new_ctx):
    # 保存old_ctx中的被调用者保存寄存器
    # 恢复new_ctx中的被调用者保存寄存器
    # 返回到new_ctx的返回地址
```

### 进程表管理

- **进程数量**：`NPROC = 16`（可配置）
- **进程ID分配**：递增分配，从1开始
- **进程表**：`proc[NPROC]` 全局数组

### 关键设计决定

1. **进程数量限制**：固定16个进程，简化实现
2. **调度算法**：简单的轮转调度（round-robin）
3. **同步机制**：使用自旋锁保护进程表
4. **内核栈**：每个进程1页（4KB）
5. **错误处理**：简化，主要通过返回值指示错误

---

## 集成到主系统

### main.c 初始化序列
```c
void main() {
    // 1. 初始化中断系统
    trap_init();
    trap_init_hart();
    
    // 2. 初始化进程系统
    proc_init();
    
    // 3. 其他初始化...
}
```

### Makefile 更新
新增编译规则：
- `kernel/trap.o` - 中断处理
- `kernel/proc.o` - 进程管理
- `kernel/kernelvec.o` - 内核中断向量
- `kernel/uservec.o` - 用户中断向量
- `kernel/swtch.o` - 上下文切换

---

## 编译与测试

### 编译
```bash
cd /root/work/op/riscv-os
make clean
make
```

### 生成的文件
- `kernel.elf` - 可执行内核
- `kernel.bin` - 二进制镜像
- `kernel.asm` - 反汇编代码

---

## 参考实现

### 对xv6的参考
- 中断框架结构（trapframe）
- 上下文切换机制（context）
- 进程状态转换
- 调度器主循环设计

### 简化点
- 单CPU实现（可扩展为多核）
- 固定进程数量
- 基本的轮转调度
- 无中断优先级

---

## Future Work

1. **时钟中断驱动的调度**
   - 集成SBI时钟接口
   - 实现时间片抢占

2. **系统调用接口**
   - 实现fork、exit、wait等系统调用
   - 添加更多系统调用支持

3. **多核支持**
   - 多CPU调度
   - IPI中断处理

4. **进程间通信**
   - 管道（pipe）
   - 信号（signal）
   - 共享内存

5. **高级调度**
   - 优先级调度
   - 公平队列调度
   - 实时调度

6. **内存优化**
   - 写时复制（COW）
   - 需求页
   - 页面交换

---

## 测试场景

### 中断处理测试
- [ ] 验证中断寄存器设置
- [ ] 测试时钟中断触发
- [ ] 验证上下文保存/恢复
- [ ] 异常处理测试

### 进程管理测试
- [ ] 进程创建和销毁
- [ ] 进程状态转换
- [ ] 调度器功能
- [ ] 父子进程关系

---

## 已知限制

1. 用户态中断处理未完全实现sscratch机制
2. 没有实际的时钟中断驱动
3. fork()是简化版本（不复制内存）
4. 没有实现信号处理
5. 没有实现进程组和会话

---

## 文件清单

### 头文件
- `include/trap.h` (98 lines) - 中断处理定义
- `include/proc.h` (124 lines) - 进程管理定义

### 实现文件
- `kernel/trap.c` (326 lines) - 中断处理实现
- `kernel/proc.c` (380+ lines) - 进程管理实现
- `kernel/kernelvec.S` (95 lines) - 内核中断向量
- `kernel/uservec.S` (143 lines) - 用户中断向量
- `kernel/swtch.S` (63 lines) - 上下文切换

### 修改文件
- `Makefile` - 添加新文件编译规则
- `include/defs.h` - 添加新函数声明
- `kernel/main.c` - 添加初始化代码

---

## 总结

本次实现成功地为RISCV-OS添加了以下功能：

1. **完整的中断处理框架**（实验4）
   - RISC-V特权级中断机制理解
   - 上下文保存/恢复
   - 异常分类处理
   - 中断使能/禁用控制

2. **完整的进程管理系统**（实验5）
   - 进程结构设计和生命周期管理
   - 上下文切换机制
   - 简单的轮转调度器
   - 基本的进程间同步

这些实现为后续添加时钟中断、系统调用、多进程执行等功能奠定了基础。
