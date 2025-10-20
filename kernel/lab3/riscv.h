#ifndef RISCV_H
#define RISCV_H

// 基础类型定义
typedef unsigned char   uint8;
typedef unsigned short  uint16;
typedef unsigned int    uint32;
typedef unsigned long   uint64;
typedef uint64          size_t;
typedef uint64          pte_t;
typedef uint64* pagetable_t;

// 页大小：4KB
#define PGSIZE 4096

// --- 地址和页表宏 ---
#define PGROUNDUP(sz)   (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a)  (((a)) & ~(PGSIZE-1))

// RISC-V Sv39 页表格式定义
#define PTE_V (1L << 0) // Valid (有效)
#define PTE_R (1L << 1) // Read (读权限)
#define PTE_W (1L << 2) // Write (写权限)
#define PTE_X (1L << 3) // Execute (执行权限)
#define PTE_U (1L << 4) // User (用户模式可访问)

// PTE 中 PPN (物理页号) 的提取和设置
#define PTE_PPN_SHIFT 10
#define PTE_PA(pte)     (((pte) >> 10) << 12)  // 从 PTE 提取物理地址
#define PA2PTE(pa)      (((pa) >> 12) << 10)  // 将物理地址转为 PTE 格式

// SATP 寄存器模式 (Sv39 模式)
#define SATP_SV39 (8L << 60)
#define MAKE_SATP(pagetable) (SATP_SV39 | (((uint64)(pagetable)) >> 12))

// --- CSR 寄存器读写函数 (使用内联汇编) ---

static inline uint64 r_satp(void) {
    uint64 x;
    asm volatile("csrr %0, satp" : "=r" (x));
    return x;
}

static inline void w_satp(uint64 x) {
    asm volatile("csrw satp, %0" : : "r" (x));
}

// TLB 刷新指令
static inline void sfence_vma() {
    asm volatile("sfence.vma zero, zero");
}

#endif