#ifndef _RISCV_H_
#define _RISCV_H_

#include "types.h"

// 页操作宏
#define PGSIZE 4096
#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))

// SATP寄存器操作
static inline void w_satp(uint64 x) {
    asm volatile("csrw satp, %0" : : "r" (x));
}

#endif // _RISCV_H_
