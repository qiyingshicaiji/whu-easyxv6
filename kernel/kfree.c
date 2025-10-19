#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

// 页表项标志位定义
#define PTE_V (1L << 0) // 有效位
#define PTE_R (1L << 1) // 可读
#define PTE_W (1L << 2) // 可写
#define PTE_X (1L << 3) // 可执行
#define PTE_U (1L << 4) // 用户可访问

// 地址操作宏
#define PGSIZE 4096
#define PGSHIFT 12
#define PXMASK 0x1FF // 9位索引
#define PXSHIFT(level) (PGSHIFT+(9*(level)))
#define PX(level, va) ((((uint64)(va)) >> PXSHIFT(level)) & PXMASK)

// 页表项操作宏
#define PA2PTE(pa) ((((uint64)pa) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)
#define PTE_FLAGS(pte) ((pte) & 0x3FF)

// 地址对齐宏
#define PGROUNDUP(sz) (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))

// 页表锁 - 保护页表修改操作
struct spinlock ptlock;

// 初始化页表系统
void paging_init(void) {
    initlock(&ptlock, "pagetable");
}

/**
 * walk - 遍历页表查找页表项
 * @pagetable: 顶级页表指针
 * @va: 虚拟地址
 * @alloc: 是否允许分配新页表
 * 
 * 返回: 指向对应页表项的指针，或0(失败)
 */
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    if(va >= MAXVA)
        panic("walk: virtual address too high");
    
    // 三级页表遍历
    for(int level = 2; level > 0; level--) {
        pte_t *pte = &pagetable[PX(level, va)];
        
        // 有效页表项 - 进入下一级
        if(*pte & PTE_V) {
            pagetable = (pagetable_t)PTE2PA(*pte);
        } 
        // 无效页表项 - 可能需要分配
        else {
            if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
                return 0;
            
            // 初始化新页表
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0, va)];
}

/**
 * mappages - 建立虚拟地址到物理地址的映射
 * @pagetable: 顶级页表
 * @va: 起始虚拟地址
 * @size: 映射区域大小
 * @pa: 起始物理地址
 * @perm: 权限标志
 * 
 * 返回: 0成功, -1失败
 */
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    uint64 a, last;
    pte_t *pte;
    
    if(size == 0)
        panic("mappages: size");
    
    // 计算页对齐的地址范围
    a = PGROUNDDOWN(va);
    last = PGROUNDDOWN(va + size - 1);
    
    // 记录已映射页数用于回滚
    int mapped_count = 0;
    
    for(;;) {
        // 获取页表项
        if((pte = walk(pagetable, a, 1)) == 0) {
            // 分配失败，回滚已建立的映射
            while(mapped_count-- > 0) {
                a -= PGSIZE;
                pte = walk(pagetable, a, 0);
                if(pte && (*pte & PTE_V)) {
                    kfree((void*)PTE2PA(*pte));
                    *pte = 0;
                }
            }
            return -1;
        }
        
        // 检查是否已映射
        if(*pte & PTE_V) {
            // 回滚所有已分配的页表
            while(mapped_count-- > 0) {
                a -= PGSIZE;
                pte = walk(pagetable, a, 0);
                if(pte && (*pte & PTE_V)) {
                    kfree((void*)PTE2PA(*pte));
                    *pte = 0;
                }
            }
            return -1;
        }
        
        // 建立映射
        *pte = PA2PTE(pa) | perm | PTE_V;
        mapped_count++;
        
        if(a == last)
            break;
        
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}

/**
 * uvmunmap - 取消虚拟地址映射
 * @pagetable: 顶级页表
 * @va: 起始虚拟地址
 * @size: 区域大小
 * @do_free: 是否释放物理页
 */
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 size, int do_free) {
    uint64 a, last;
    pte_t *pte;
    
    if(size == 0)
        panic("uvmunmap: size");
    
    a = PGROUNDDOWN(va);
    last = PGROUNDDOWN(va + size - 1);
    
    for(; a <= last; a += PGSIZE) {
        if((pte = walk(pagetable, a, 0)) == 0)
            panic("uvmunmap: walk");
        
        if((*pte & PTE_V) == 0)
            panic("uvmunmap: not mapped");
        
        if(do_free) {
            uint64 pa = PTE2PA(*pte);
            kfree((void*)pa);
        }
        
        *pte = 0;
    }
}

/**
 * uvmcreate - 创建空用户页表
 * 
 * 返回: 新页表指针, 或0(失败)
 */
pagetable_t uvmcreate(void) {
    pagetable_t pagetable;
    
    if((pagetable = (pagetable_t)kalloc()) == 0)
        return 0;
    
    memset(pagetable, 0, PGSIZE);
    return pagetable;
}

/**
 * uvmcopy - 复制页表内容
 * @old: 源页表
 * @new: 目标页表
 * @sz: 要复制的内存大小
 * 
 * 返回: 0成功, -1失败
 */
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    
    for(i = 0; i < sz; i += PGSIZE) {
        if((pte = walk(old, i, 0)) == 0)
            panic("uvmcopy: pte should exist");
        
        if((*pte & PTE_V) == 0)
            panic("uvmcopy: page not present");
        
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);
        
        // 建立新映射
        if(mappages(new, i, PGSIZE, pa, flags) != 0) {
            // 失败时清理已复制的部分
            uvmunmap(new, 0, i, 1);
            return -1;
        }
    }
    return 0;
}

/**
 * freewalk - 递归释放页表
 * @pagetable: 要释放的页表
 */
void freewalk(pagetable_t pagetable) {
    // 遍历所有页表项
    for(int i = 0; i < 512; i++) {
        pte_t pte = pagetable[i];
        
        if(pte & PTE_V) {
            // 页表项指向下一级页表
            if((pte & (PTE_R|PTE_W|PTE_X)) == 0) {
                // 递归释放下级页表
                uint64 child = PTE2PA(pte);
                freewalk((pagetable_t)child);
            }
            // 页表项指向物理页
            else {
                kfree((void*)PTE2PA(pte));
            }
            pagetable[i] = 0;
        }
    }
    kfree((void*)pagetable);
}

/**
 * uvmfree - 释放用户页表及相关资源
 * @pagetable: 要释放的页表
 * @sz: 用户内存大小
 */
void uvmfree(pagetable_t pagetable, uint64 sz) {
    if(sz > 0)
        uvmunmap(pagetable, 0, PGROUNDUP(sz), 1);
    freewalk(pagetable);
}

/**
 * copyout - 从内核复制数据到用户空间
 * @pagetable: 用户页表
 * @dstva: 目标用户虚拟地址
 * @src: 源内核地址
 * @len: 复制长度
 * 
 * 返回: 0成功, -1失败
 */
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    uint64 n, va0, pa0;
    
    while(len > 0) {
        va0 = PGROUNDDOWN(dstva);
        pa0 = walkaddr(pagetable, va0);
        
        if(pa0 == 0)
            return -1;
        
        n = PGSIZE - (dstva - va0);
        if(n > len)
            n = len;
        
        memmove((void *)(pa0 + (dstva - va0)), src, n);
        
        len -= n;
        src += n;
        dstva = va0 + PGSIZE;
    }
    return 0;
}

/**
 * walkaddr - 查找虚拟地址对应的物理地址
 * @pagetable: 页表
 * @va: 虚拟地址
 * 
 * 返回: 物理地址, 或0(未映射)
 */
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    pte_t *pte;
    uint64 pa;
    
    if(va >= MAXVA)
        return 0;
    
    pte = walk(pagetable, va, 0);
    if(pte == 0)
        return 0;
    
    if((*pte & PTE_V) == 0)
        return 0;
    
    if((*pte & PTE_U) == 0)
        return 0;
    
    pa = PTE2PA(*pte);
    return pa;
}