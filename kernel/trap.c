#include "trap.h"
#include "uart.h"
#include "defs.h"
#include "proc.h"
#include <stddef.h>

// CSR读写函数实现 - 内联汇编读写控制和状态寄存器

static inline uint64 r_sstatus(void) {
    uint64 x;
    asm volatile("csrr %0, sstatus" : "=r" (x));
    return x;
}

static inline void w_sstatus(uint64 x) {
    asm volatile("csrw sstatus, %0" : : "r" (x));
}

static inline uint64 r_sip(void) {
    uint64 x;
    asm volatile("csrr %0, sip" : "=r" (x));
    return x;
}

static inline void w_sip(uint64 x) {
    asm volatile("csrw sip, %0" : : "r" (x));
}

static inline uint64 r_sie(void) {
    uint64 x;
    asm volatile("csrr %0, sie" : "=r" (x));
    return x;
}

static inline void w_sie(uint64 x) {
    asm volatile("csrw sie, %0" : : "r" (x));
}

static inline uint64 r_scause(void) {
    uint64 x;
    asm volatile("csrr %0, scause" : "=r" (x));
    return x;
}

static inline uint64 r_sepc(void) {
    uint64 x;
    asm volatile("csrr %0, sepc" : "=r" (x));
    return x;
}

static inline void w_sepc(uint64 x) {
    asm volatile("csrw sepc, %0" : : "r" (x));
}

static inline uint64 r_stval(void) {
    uint64 x;
    asm volatile("csrr %0, stval" : "=r" (x));
    return x;
}

static inline uint64 r_stvec(void) {
    uint64 x;
    asm volatile("csrr %0, stvec" : "=r" (x));
    return x;
}

static inline void w_stvec(uint64 x) {
    asm volatile("csrw stvec, %0" : : "r" (x));
}

// RISC-V权限级CSR定义
#define SSTATUS_SPP (1L << 8)   // Previous privilege level
#define SSTATUS_SPIE (1L << 5)  // Previous interrupt enable
#define SSTATUS_SIE (1L << 1)   // Interrupt enable

#define SIE_SEIE (1L << 9)      // External interrupt enable
#define SIE_STIE (1L << 5)      // Timer interrupt enable
#define SIE_SSIE (1L << 1)      // Software interrupt enable

// 全局时钟计数器
volatile uint64 ticks = 0;

// 机器模式时钟中断计数
static volatile uint64 m_mode_ticks = 0;

/**
 * 获取当前系统时钟滴答数
 */
uint64 get_ticks(void) {
    return ticks;
}

// 机器模式时钟中断处理函数
void machine_timer_handler(void) {
    // 递增 M-mode 下的 ticks 计数
    m_mode_ticks++;
    ticks++;  // 也递增全局 ticks
    
    printf("[M-mode] Timer interrupt! m_mode_ticks=%ld\n", m_mode_ticks);
    
    // 设置下一个时间中断
    uint64 current_time = *(uint64*)CLINT_MTIME;
    uint64 next_time = current_time + TIMER_INTERVAL;
    *(uint64*)CLINT_MTIMECMP = next_time;
}

// 陷阱帧池 - 用于分配trapframe
#define MAX_TRAPFRAMES 256
struct trapframe trapframe_pool[MAX_TRAPFRAMES];
int trapframe_used[MAX_TRAPFRAMES];

// 中断处理器向量表
trap_handler_t trap_handlers[16];

// 当前中断状态 (简化实现，每个hart一个)
static int intr_state = 0;

/**
 * 分配陷阱帧
 */
struct trapframe* alloc_trapframe(void) {
    for (int i = 0; i < MAX_TRAPFRAMES; i++) {
        if (!trapframe_used[i]) {
            trapframe_used[i] = 1;
            return &trapframe_pool[i];
        }
    }
    return 0;
}

/**
 * 释放陷阱帧
 */
void free_trapframe(struct trapframe* tf) {
    if (tf >= trapframe_pool && tf < trapframe_pool + MAX_TRAPFRAMES) {
        trapframe_used[tf - trapframe_pool] = 0;
    }
}

/**
 * 启用中断
 */
void intr_on(void) {
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    intr_state = 1;
}

/**
 * 禁用中断
 */
void intr_off(void) {
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    intr_state = 0;
}

/**
 * 获取中断状态
 */
int intr_get(void) {
    return (r_sstatus() & SSTATUS_SIE) != 0;
}

/**
 * 设置中断向量地址
 * mode: 0 = direct (mtvec = trapvec_addr)
 *       1 = vectored (mtvec = trapvec_addr + 4*cause)
 */
void set_stvec(uint64 addr, int mode) {
    w_stvec(addr + mode);
}

/**
 * 初始化中断系统
 * 参考xv6的initializerasproc
 */
void trap_init(void) {
    uart_puts("[trap] Initializing trap system...\n");
    
    // 初始化trapframe池
    for (int i = 0; i < MAX_TRAPFRAMES; i++) {
        trapframe_used[i] = 0;
    }
    
    // 初始化处理器向量表并注册处理函数
    for (int i = 0; i < 16; i++) {
        trap_handlers[i] = NULL;
    }
    
    // 注册中断处理函数
    // 时钟中断（IRQ 5）
    trap_handlers[5] = (trap_handler_t)handle_timer_interrupt;
    
    // 外部中断（IRQ 9）
    trap_handlers[9] = (trap_handler_t)handle_external_interrupt;
    
    // 软件中断（IRQ 1）
    trap_handlers[1] = (trap_handler_t)handle_software_interrupt;
    
    // 异常处理函数不通过 trap_handlers 注册，而是在 handle_exception 中直接处理
    // 包括：系统调用、页故障、非法指令等
    
    int registered_count = 0;
    for (int i = 0; i < 16; i++) {
        if (trap_handlers[i] != NULL) {
            registered_count++;
        }
    }
    printf("[trap] Registered %d interrupt handlers\n", registered_count);
    
    uart_puts("[trap] Trap system initialized\n");
}

/**
 * 初始化当前Hart的中断
 */
void trap_init_hart(void) {
    uart_puts("[trap] Initializing trap for hart...\n");
    
    // 设置监督模式中断向量基址
    // 外部代码应该提供kernelvec的地址
    extern void kernelvec();
    set_stvec((uint64)&kernelvec, 0);  // direct mode
    
    // 启用监督模式下的时钟中断、外部中断、软件中断
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    
    // 启用全局中断
    intr_on();
    
    uart_puts("[trap] Trap for hart initialized\n");
}

/**
 * 设置下一个时间中断
 * 在 QEMU virt 平台中，CLINT 使用 mtime 和 mtimecmp 寄存器
 */
void set_next_timer(void) {
    // 读取当前时间值
    uint64 current_time = *(uint64*)CLINT_MTIME;
    // 设置下一次中断的时间
    uint64 next_time = current_time + TIMER_INTERVAL;
    *(uint64*)CLINT_MTIMECMP = next_time;
    printf("[timer] current_time=0x%lx, next_time=0x%lx\n", current_time, next_time);
}

/**
 * 初始化时间中断
 */
void timerinit(void) {
    uart_puts("[trap] Initializing timer...\n");
    
    // 设置第一个时间中断
    set_next_timer();
    
    // 启用监督模式时钟中断 (在 trap_init_hart 中已经启用)
    // w_sie(r_sie() | SIE_STIE);
    
    uart_puts("[trap] Timer initialized\n");
}

/**
 * 设备中断分发函数
 * 根据中断源调用相应的处理函数
 * 返回非零表示处理了中断
 */
int devintr(void) {
    uint64 scause = r_scause();
    
    // 检查是否是中断 (最高位为1)
    if (!(scause & (1UL << 63))) {
        return 0;  // 不是中断，是异常
    }
    
    // 提取中断类型 (低位)
    int irq = scause & 0x0F;
    
    switch (irq) {
        case INTR_S_TIMER:
            // 时钟中断处理
            ticks++;
            set_next_timer();
            printf("[trap] Timer interrupt (tick %ld)\n", ticks);
            handle_timer_interrupt();
            return 1;
            
        case INTR_S_EXTERNAL:
            // 外部中断处理
            uart_puts("[trap] External interrupt\n");
            handle_external_interrupt();
            return 1;
            
        case 1:  // 软件中断
            uart_puts("[trap] Software interrupt\n");
            // 清除软件中断
            w_sip(r_sip() & ~2);
            handle_software_interrupt();
            return 1;
            
        default:
            printf("[trap] Unknown interrupt: %d\n", irq);
            return 0;
    }
}

/**
 * 处理异常（同步异常）
 */
void handle_exception(struct trapframe *tf) {
    uint64 scause = r_scause();
    uint64 sepc = r_sepc();
    
    switch (scause) {
        case EXCP_UENV_CALL:  // 用户系统调用 (ecall)
            // 调用系统调用处理函数
            handle_syscall(tf);
            // 在 handle_syscall 中负责更新 sepc
            break;
            
        case EXCP_INSTR_PAGE_FAULT:
            printf("[trap] Instruction page fault at 0x%lx\n", sepc);
            handle_trap_page_fault(tf, 0);  // 0 表示读/执行操作
            break;
            
        case EXCP_LOAD_PAGE_FAULT:
            printf("[trap] Load page fault\n");
            handle_trap_page_fault(tf, 0);  // 0 表示读操作
            break;
            
        case EXCP_STORE_PAGE_FAULT:
            printf("[trap] Store page fault\n");
            handle_trap_page_fault(tf, 1);  // 1 表示写操作
            break;
            
        case EXCP_ILLEGAL_INSTR:
            printf("[trap] Illegal instruction at 0x%lx\n", sepc);
            handle_illegal_instruction(tf);
            break;
            
        case EXCP_BREAKPOINT:
            printf("[trap] Breakpoint at 0x%lx\n", sepc);
            handle_breakpoint(tf);
            break;
            
        case EXCP_LOAD_MISALIGNED:
            printf("[trap] Load address misaligned at 0x%lx\n", sepc);
            break;
            
        case EXCP_STORE_MISALIGNED:
            printf("[trap] Store address misaligned at 0x%lx\n", sepc);
            break;
            
        default:
            printf("[trap] Unknown exception: %ld at 0x%lx\n", scause, sepc);
            break;
    }
}

/**
 * 内核态中断处理 - 从kernelvec.S调用
 * 处理在内核执行时发生的中断和异常
 */
void kerneltrap(void) {
    uint64 scause = r_scause();
    uint64 sepc = r_sepc();
    
    // 检查中断/异常属性
    if (scause & (1UL << 63)) {
        // 中断 (异步)
        if (!devintr()) {
            printf("[trap] Unknown device interrupt, scause=%d\n", scause & 0x0F);
        }
    } else {
        // 异常 (同步)
        handle_exception((struct trapframe *)sepc);  // 这里可能需要调整
    }
}

/**
 * 用户态中断处理 - 从uservec.S调用
 * 处理在用户程序执行时发生的中断和异常
 */
void usertrap(void) {
    uint64 scause = r_scause();
    
    if (scause & (1UL << 63)) {
        // 中断 (异步)
        if (!devintr()) {
            printf("[trap] Unknown interrupt in user mode\n");
        }
    } else {
        // 异常 (同步)
        switch (scause) {
            case EXCP_UENV_CALL:  // 系统调用
                uart_puts("[trap] User syscall\n");
                // TODO: 处理系统调用
                // 跳过ecall指令
                break;
                
            case EXCP_INSTR_PAGE_FAULT:
            case EXCP_LOAD_PAGE_FAULT:
            case EXCP_STORE_PAGE_FAULT:
                uart_puts("[trap] Page fault in user mode\n");
                // TODO: 页故障处理
                break;
                
            default:
                printf("[trap] Unknown exception %d in user mode\n", scause);
                break;
        }
    }
}

/**
 * ============================================================================
 * 具体的中断/异常处理函数实现
 * ============================================================================
 */

/**
 * 定时器中断处理
 * 参考 xv6 的时间中断处理
 * 
 * 功能：
 * 1. 计数时钟滴答
 * 2. 设置下一次定时器中断
 * 3. 设置抢占标志（不直接调用yield()避免嵌套调用问题）
 */
void handle_timer_interrupt(void) {
    printf("[timer] Timer interrupt: ticks=%ld\n", ticks);
    
    extern volatile int need_resched;
    need_resched = 1;
}

/**
 * 外部中断处理
 * 用于处理 UART、网络、磁盘等外部设备中断
 */
void handle_external_interrupt(void) {
    // 外部中断处理逻辑
    printf("[handle_external] External interrupt received\n");
}

/**
 * 软件中断处理
 * 用于处理处理器间中断 (IPI)
 */
void handle_software_interrupt(void) {
    // 软件中断处理逻辑
    printf("[handle_software] Software interrupt received\n");
}

/**
 * 系统调用处理
 * 参数: tf - 用户程序的陷阱帧
 * 
 * RISC-V 系统调用约定:
 * - a7 寄存器: 系统调用号
 * - a0-a6 寄存器: 系统调用参数
 * - a0 寄存器: 返回值
 */
void handle_syscall(struct trapframe *tf) {
    // 系统调用处理逻辑（暂时空着，为后续实现保留）
    
    if (tf == NULL) {
        uart_puts("[error] handle_syscall: trapframe is NULL\n");
        return;
    }
    
    // 获取系统调用号（在 a7 寄存器中）
    uint64 syscall_num = tf->a7;
    
    printf("[syscall] Syscall #%ld received\n", syscall_num);
    
    // 系统调用分发示例
    switch (syscall_num) {
        case 0:  // 示例: sys_exit
            printf("[syscall] sys_exit called\n");
            // TODO: 实现 exit 系统调用
            break;
            
        case 1:  // 示例: sys_fork
            printf("[syscall] sys_fork called\n");
            // TODO: 实现 fork 系统调用
            break;
            
        case 2:  // 示例: sys_read
            printf("[syscall] sys_read called\n");
            // TODO: 实现 read 系统调用
            break;
            
        case 3:  // 示例: sys_write
            printf("[syscall] sys_write called\n");
            // TODO: 实现 write 系统调用
            break;
            
        default:
            printf("[syscall] Unknown syscall #%ld\n", syscall_num);
            break;
    }
    
    // 跳过 ecall 指令（sepc += 4）
    // 注：在用户程序的陷阱帧中更新 sepc，使其恢复后继续执行 ecall 之后的指令
}

/**
 * 页故障处理
 * 参数: tf - 陷阱帧
 *       is_write - 是否是写操作导致的页故障
 */
void handle_trap_page_fault(struct trapframe *tf, int is_write) {
    if (tf == NULL) {
        uart_puts("[error] handle_trap_page_fault: trapframe is NULL\n");
        return;
    }
    
    // 获取访问失败的地址（在 stval 中）
    uint64 fault_addr = r_stval();
    
    if (is_write) {
        printf("[page_fault] Write page fault at 0x%lx\n", fault_addr);
    } else {
        printf("[page_fault] Read/Exec page fault at 0x%lx\n", fault_addr);
    }
    
}

/**
 * 非法指令处理
 * 参数: tf - 陷阱帧
 */
void handle_illegal_instruction(struct trapframe *tf) {
    if (tf == NULL) {
        uart_puts("[error] handle_illegal_instruction: trapframe is NULL\n");
        return;
    }
    
    printf("[illegal_instr] Illegal instruction at 0x%lx\n", tf->sepc);
    
}

/**
 * 断点异常处理
 * 参数: tf - 陷阱帧
 */
void handle_breakpoint(struct trapframe *tf) {
    if (tf == NULL) {
        uart_puts("[error] handle_breakpoint: trapframe is NULL\n");
        return;
    }
    
    printf("[breakpoint] Breakpoint at 0x%lx\n", tf->sepc);
    
}
