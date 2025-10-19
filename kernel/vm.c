#include "vm.h"
#include "printf.h"
#include "memlayout.h"

// 内核页表全局变量
pagetable_t kernel_pagetable;

// 内核内存区域定义
extern char etext[];  // 内核代码结束地址
extern char end[];    // 内核数据结束地址

// 创建新页表
pagetable_t create_pagetable(void) {
    pagetable_t pt = (pagetable_t)alloc_page();
    if (pt) {
        memset(pt, 0, PGSIZE); // 初始化页表内容为0
    }
    return pt;
}

// 查找页表项（不创建新页表）
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    if (!pt) return 0;
    
    pagetable_t cur = pt;
    for (int level = PAGE_LEVELS - 1; level >= 0; level--) {
        pte_t* pte = &cur[VPN_MASK(va, level)];
        if (!(*pte & PTE_V)) {
            return 0; // 无效页表项
        }
        cur = (pagetable_t)PTE2PA(*pte);
    }
    return &cur[VPN_MASK(va, 0)];
}

// 查找或创建页表项
pte_t* walk_create(pagetable_t pt, uint64 va) {
    if (!pt) return 0;
    
    pagetable_t cur = pt;
    for (int level = PAGE_LEVELS - 1; level > 0; level--) {
        pte_t* pte = &cur[VPN_MASK(va, level)];
        if (*pte & PTE_V) {
            cur = (pagetable_t)PTE2PA(*pte);
        } else {
            // 分配新页表
            pagetable_t new_pt = create_pagetable();
            if (!new_pt) return 0;
            
            *pte = PA2PTE(new_pt) | PTE_V;
            cur = new_pt;
        }
    }
    return &cur[VPN_MASK(va, 0)];
}

// 建立虚拟地址到物理地址的映射
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    // 检查地址对齐
    if (va % PGSIZE != 0 || pa % PGSIZE != 0) {
        return -1; // 地址未对齐
    }
    
    pte_t* pte = walk_create(pt, va);
    if (!pte) {
        return -1; // 分配失败
    }
    
    // 检查是否已映射
    if (*pte & PTE_V) {
        return -1; // 映射冲突
    }
    
    // 设置页表项
    *pte = PA2PTE(pa) | perm | PTE_V;
    return 0;
}

// 连续映射内存区域
int map_region(pagetable_t pagetable, uint64 va, uint64 pa, uint64 size, int perm) {
    if (size == 0)
        return -1;
    
    uint64 a, last;
    a = PGROUNDDOWN(va);
    last = PGROUNDDOWN(va + size - 1);
    
    for (;;) {
        if (map_page(pagetable, a, pa, perm) < 0) {
            return -1;
        }
        if (a == last)
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}

// 递归销毁页表
static void free_pagetable_recursive(pagetable_t pt, int level) {
    if (!pt) return;
    
    // 如果是最后一级页表，直接释放
    if (level == 0) {
        free_page(pt);
        return;
    }
    
    // 遍历所有页表项
    for (int i = 0; i < 512; i++) {
        pte_t pte = pt[i];
        if (pte & PTE_V) {
            // 递归释放下级页表
            free_pagetable_recursive((pagetable_t)PTE2PA(pte), level - 1);
        }
    }
    
    // 释放当前页表
    free_page(pt);
}

// 销毁整个页表
void destroy_pagetable(pagetable_t pt) {
    if (!pt) return;
    free_pagetable_recursive(pt, PAGE_LEVELS - 1);
}

// 递归打印页表内容
static void dump_pagetable_recursive(pagetable_t pt, uint64 base_va, int level) {
    if (!pt) return;
    
    for (int i = 0; i < 512; i++) {
        pte_t pte = pt[i];
        if (pte & PTE_V) {
            uint64 va = base_va | ((uint64)i << VPN_SHIFT(level));
            
            if (level > 0) {
                // 中间级页表
                printf("L%d: VA: 0x%lx -> PTE: 0x%lx\n", level, va, pte);
                dump_pagetable_recursive((pagetable_t)PTE2PA(pte), va, level - 1);
            } else {
                // 最后一级页表
                uint64 pa = PTE2PA(pte);
                printf("L0: VA: 0x%lx -> PA: 0x%lx | Perm: ", va, pa);
                
                // 打印权限位
                if (pte & PTE_R) printf("R");
                if (pte & PTE_W) printf("W");
                if (pte & PTE_X) printf("X");
                if (pte & PTE_U) printf("U");
                printf("\n");
            }
        }
    }
}

// 打印页表内容
void dump_pagetable(pagetable_t pt, int level) {
    if (!pt) return;
    printf("--- Page Table Dump (Level %d) ---\n", level);
    dump_pagetable_recursive(pt, 0, level);
    printf("----------------------------------\n");
}

// 创建内核页表
void kvminit(void) {
    // 1. 创建内核页表
    kernel_pagetable = create_pagetable();
    if (!kernel_pagetable)
        panic("kvminit: failed to create kernel pagetable");
    
    // 2. 映射内核代码段（R+X权限）
    map_region(kernel_pagetable, KERNBASE, KERNBASE, 
               (uint64)etext - KERNBASE, PTE_R | PTE_X);
    
    // 3. 映射内核数据段（R+W权限）
    map_region(kernel_pagetable, (uint64)etext, (uint64)etext, 
               PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    
    // 4. 映射设备内存
    map_region(kernel_pagetable, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    map_region(kernel_pagetable, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    
    // 5. 映射CLINT（核心本地中断器）
    map_region(kernel_pagetable, CLINT, CLINT, 0x10000, PTE_R | PTE_W);
}

// SATP寄存器构造宏
#define MAKE_SATP(pagetable) (((uint64)8 << 60) | ((uint64)(pagetable) >> 12))

// 刷新TLB
void sfence_vma(void) {
    asm volatile("sfence.vma zero, zero");
}

// 激活内核页表
void kvminithart(void) {
    // 设置SATP寄存器
    w_satp(MAKE_SATP(kernel_pagetable));
    
    // 刷新TLB
    sfence_vma();
}