#include "riscv.h"
#include "printf.h"

// 外部函数声明
extern void* kalloc(void);
extern void kfree(void*);

// 提取虚拟地址在指定级页表中的索引 (9位)
#define VPN_SHIFT(level) (12 + 9 * (level))
#define VPN(va, level) (((va) >> VPN_SHIFT(level)) & 0x1FF)

/**
 * @brief 遍历页表以查找虚拟地址 va 对应的 PTE
 * @param pt 根页表指针
 * @param va 虚拟地址
 * @param alloc 是否在 PTE 无效时分配新的页表页 (非叶子节点)
 * @return 指向 PTE 的指针，如果找不到且 alloc=0 则返回 0
 */
pte_t *walk(pagetable_t pt, uint64 va, int alloc) {
    // Sv39 使用 3 级页表 (level 从 2 递减到 0)
    for (int level = 2; level > 0; level--) {
        pte_t *pte = &pt[VPN(va, level)];

        if (*pte & PTE_V) {
            // 页表项有效，pt 指向下一级页表的物理地址
            pt = (pagetable_t)PTE_PA(*pte);
        } else {
            // 页表项无效，如果允许分配，则分配一个新的页表页
            if (!alloc || (pt = (pagetable_t)kalloc()) == 0) {
                return 0; // 无法找到或分配页表页
            }
            // 将新的页表物理地址写入当前 PTE
            // 新的 PTE 必须设置 PTE_V (有效)
            *pte = PA2PTE((uint64)pt) | PTE_V;
        }
    }
    // 达到叶子节点，返回 PTE 的地址
    return &pt[VPN(va, 0)];
}

/**
 * @brief 建立虚拟地址 va 到物理地址 pa 的映射
 * @param pt 根页表
 * @param va 虚拟地址
 * @param pa 物理地址
 * @param perm 权限位 (PTE_R/W/X)
 * @return 0 成功，-1 失败
 */
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    pte_t *pte;

    if (va % PGSIZE != 0 || pa % PGSIZE != 0) {
        printf("map_page: addresses must be page aligned.\n");
        return -1;
    }

    // 查找叶子节点 PTE，如果中间节点不存在则创建 (alloc=1)
    if ((pte = walk(pt, va, 1)) == 0) {
        return -1; // 页表分配失败
    }

    if (*pte & PTE_V) {
        printf("map_page: already mapped.\n");
        return -1; // 地址已被映射
    }

    // 建立映射：写入物理页号和权限位
    *pte = PA2PTE(pa) | perm | PTE_V;
    
    return 0;
}

// 创建和初始化内核页表
pagetable_t kvminit() {
    // kalloc 返回的地址是 4KB 对齐的，可直接作为根页表
    pagetable_t kpt = (pagetable_t)kalloc();
    if (kpt == 0) return 0;
    
    // 0. 定义内核内存范围 (使用链接脚本和 kalloc.c 中定义的地址)
    uint64 KERNBASE = 0x80000000;
    
    // 1. 映射内核代码和数据段 (恒等映射)
    // 简化处理：只映射内核起始页和 UART 设备页
    if (map_page(kpt, KERNBASE, KERNBASE, PTE_R | PTE_W | PTE_X) != 0) {
        printf("kvminit: failed to map kernel base.\n");
        return 0;
    }
    
    // 2. 映射设备 (UART)
    uint64 UART0 = 0x10000000;
    if (map_page(kpt, UART0, UART0, PTE_R | PTE_W) != 0) {
        printf("kvminit: failed to map UART.\n");
        return 0;
    }
    
    return kpt;
}

// 激活内核页表
void kvminithart(pagetable_t kpt) {
    if (kpt == 0) {
        printf("kvminithart: invalid page table.\n");
        return;
    }
    
    // 写入 SATP 寄存器，启用 Sv39 模式
    w_satp(MAKE_SATP(kpt));
    
    // 刷新 TLB
    sfence_vma();
    
    printf("Virtual Memory Enabled (Sv39).\n");
}