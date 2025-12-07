#ifndef _PROC_H
#define _PROC_H

#include <stdint.h>
#include "trap.h"
#include "defs.h"

// 进程最大数量
#define NPROC 16

// 用户相关限制
#define NUSER 8              // 最大用户数
#define MAX_PROC_PER_USER 4  // 每个用户最多进程数

// 进程状态定义
enum procstate {
    UNUSED,      // 未使用
    USED,        // 已使用但未准备好
    RUNNABLE,    // 可以运行
    RUNNING,     // 正在运行
    SLEEPING,    // 等待某个事件
    ZOMBIE       // 已退出但父进程未wait
};

// 上下文切换结构 - 保存需要在上下文切换时保存的寄存器
struct context {
    uint64 ra;      // 返回地址 (x1)
    uint64 sp;      // 栈指针 (x2)
    uint64 s0;      // 保存寄存器 (x8)
    uint64 s1;      // 保存寄存器 (x9)
    uint64 s2;      // 保存寄存器 (x18)
    uint64 s3;      // 保存寄存器 (x19)
    uint64 s4;      // 保存寄存器 (x20)
    uint64 s5;      // 保存寄存器 (x21)
    uint64 s6;      // 保存寄存器 (x22)
    uint64 s7;      // 保存寄存器 (x23)
    uint64 s8;      // 保存寄存器 (x24)
    uint64 s9;      // 保存寄存器 (x25)
    uint64 s10;     // 保存寄存器 (x26)
    uint64 s11;     // 保存寄存器 (x27)
};

// 进程结构体定义
struct proc {
    // 进程基本信息
    enum procstate state;    // 进程状态
    int pid;                 // 进程ID
    int ppid;                // 父进程ID
    int uid;                 // 用户ID (新增)
    int xstate;              // 退出状态
    int killed;              // 是否被kill标记
    
    pagetable_t pagetable;   // 用户页表
    uint64 sz;               // 进程内存大小
    char *kstack;            // 内核栈指针
    
    struct trapframe *trapframe;  // 用户陷阱帧
    uint64 ustack;                // 用户栈指针
    
    struct context context;       // 调度上下文
    
    struct proc *parent;          // 父进程指针
    
    void *chan;              // 睡眠通道 (sleep/wait)
    int wait_pid;            // wait时等待的进程ID
};

// CPU状态结构 (简化版本)
struct cpu {
    struct proc *proc;       // 当前运行的进程
    struct context *scheduler_context;  // 调度器上下文
};

// 进程管理全局变量声明
extern struct proc proc[NPROC];
extern struct proc *current_proc;  // 当前运行的进程
extern int nextpid;                // 下一个PID
extern struct cpu cpus[];          // CPU数组
extern volatile int need_resched;  // 抢占标志

// 进程管理基本函数
void proc_init(void);              // 初始化进程系统
struct proc* alloc_proc(void);     // 分配新进程
void free_proc(struct proc *p);    // 释放进程
struct proc* find_proc(int pid);   // 按PID查找进程
void proc_set_kernel_stack(struct proc *p, char *kstack);  // 设置内核栈

// 进程状态转换
void proc_mark_runnable(struct proc *p);   // 标记为可运行
void proc_mark_sleeping(struct proc *p, void *chan);  // 标记为睡眠
void proc_mark_zombie(struct proc *p, int xstate);    // 标记为僵尸

// 进程调度相关
void scheduler(void);              // 调度器主循环
void yield(void);                  // 放弃CPU
void switch_context(struct context *old, struct context *new);  // 上下文切换

// 进程生命周期管理
int fork(void);                    // 创建子进程
void exit(int status);             // 进程退出
int wait(int *status);             // 等待子进程
void kill(int pid);                // 杀死进程
int growproc(int n);               // 增长或收缩进程内存

// 用户程序加载
int setup_user_stack(struct proc *p);  // 设置用户栈
int load_user_program(struct proc *p, void* code, uint64_t sz);  // 加载用户程序

// 进程工具函数
int get_pid(void);                 // 获取当前进程PID
struct proc* get_current_proc(void);  // 获取当前进程结构
void set_current_proc(struct proc *p);  // 设置当前进程

// UID 相关函数
int get_uid(void);                 // 获取当前进程UID
int set_uid(int uid);              // 设置当前进程UID
int count_user_procs(int uid);     // 统计指定用户的进程数
int can_fork(int uid);             // 检查用户是否可以fork

// 进程睡眠/唤醒
void sleep(void *chan);            // 睡眠直到被唤醒
void wakeup(void *chan);           // 唤醒所有睡眠在通道上的进程
void wakeup_one(void *chan);       // 唤醒一个睡眠在通道上的进程

// 等待队列节点
struct wait_queue_node {
    struct proc *proc;              // 等待的进程
    struct wait_queue_node *next;   // 下一个节点
};

// 信号量定义（带等待队列）
typedef struct {
    int value;                      // 信号量计数值
    void *chan;                     // 等待通道（使用信号量地址）
    struct wait_queue_node *head;   // 等待队列头
    struct wait_queue_node *tail;   // 等待队列尾
} semaphore_t;

// 信号量操作
void sem_init(semaphore_t *sem, int value);  // 初始化信号量
void sem_wait(semaphore_t *sem);             // P操作（等待/减少）
void sem_post(semaphore_t *sem);             // V操作（释放/增加）
int sem_trywait(semaphore_t *sem);           // 非阻塞P操作

#endif
