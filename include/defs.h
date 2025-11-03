#include "vm.h"
#ifndef _DEFS_H_
#define _DEFS_H_

#include "types.h"

// 物理内存管理接口
void            pmm_init(void);
void*           alloc_page(void);
void            free_page(void*);
void*           alloc_pages(int n);
uint64          get_free_pages(void);
uint64          get_total_pages(void);

// 虚拟内存管理接口  
pagetable_t     create_pagetable(void);
int             map_page(pagetable_t pt, uint64 va, uint64 pa, int perm);
void            destroy_pagetable(pagetable_t pt);
void            kvminit(void);
void            kvminithart(void);

// 其他函数声明

#endif // _DEFS_H_
