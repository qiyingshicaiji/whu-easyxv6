#include <stdint.h>
#include "uart.h"
#include "proc.h"

// 页表项相关定义
typedef uint64_t pte_t;
typedef uint64_t* pagetable_t;

// RISC-V SV39页表项权限位
#define PTE_V (1L << 0)  // 有效位
#define PTE_R (1L << 1)  // 读权限
#define PTE_W (1L << 2)  // 写权限
#define PTE_X (1L << 3)  // 执行权限
#define PTE_U (1L << 4)  // 用户权限
#define PTE_G (1L << 5)  // 全局位
#define PTE_A (1L << 6)  // 访问位
#define PTE_D (1L << 7)  // 脏位

// 从PTE提取标志位
#define PTE_FLAGS(pte) ((pte) & 0x3FF)

// 页表相关常量
#define PAGE_SIZE 4096
#define PTE_SIZE sizeof(pte_t)
#define PT_ENTRIES 512  // 每级页表512个条目
#define PTE_PER_PAGE (PAGE_SIZE / PTE_SIZE)

// 虚拟地址相关宏定义
#define PXMASK 0x1FF  // 9位索引掩码
#define PXSHIFT(level) (12 + 9 * (level))  // 第level级页表索引偏移量
#define PX(level, va) ((((uint64_t)(va)) >> PXSHIFT(level)) & PXMASK)  // 提取第level级页表索引

// 虚拟地址各部分宏定义
#define VPN0(va) PX(0, va)  // 页内偏移索引
#define VPN1(va) PX(1, va)  // 二级页表索引
#define VPN2(va) PX(2, va)  // 一级页表索引

#define PTE2PA(pte) (((pte) >> 10) << 12)  // 页表项到物理地址
#define PA2PTE(pa) (((pa) >> 12) << 10)    // 物理地址到页表项

// 虚拟地址和物理地址对齐检查
#define PGROUNDUP(sz) (((sz) + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
#define PGROUNDDOWN(a) (((a)) & ~(PAGE_SIZE - 1))

// 内核内存布局相关定义
#define KERNBASE 0x80000000L           // 内核基地址
#define UART0 0x10000000L              // UART设备地址
#define PHYSTOP 0x88000000L            // 物理内存结束地址

// SATP寄存器相关定义
#define SATP_MODE_SV39 (8L << 60)      // SV39模式

// 声明物理内存分配函数
void* alloc_page(void);
void free_page(void* page);

// 页面替换相关定义
#define MAX_SWAPPED_PAGES 1024      // 最大交换页面数量
#define SWAP_NONE 0xFFFFFFFF         // 无效交换索引
#define PAGE_FRAME_MAX 256           // 最大物理页帧数

// 页面状态定义
#define PAGE_PRESENT  (1 << 0)       // 页面在内存中
#define PAGE_SWAPPED  (1 << 1)       // 页面已交换出去
#define PAGE_DIRTY    (1 << 2)       // 页面已修改
#define PAGE_ACCESSED (1 << 3)       // 页面最近被访问

// 页面描述符结构
struct page_desc {
    uint64_t vaddr;                  // 虚拟地址
    uint64_t paddr;                  // 物理地址
    uint32_t swap_offset;            // 交换区偏移
    uint32_t flags;                  // 页面状态标志
    struct page_desc* prev;          // LRU链表前驱
    struct page_desc* next;          // LRU链表后继
    pagetable_t pagetable;          // 所属页表
};

// 交换区管理结构
struct swap_manager {
    uint32_t swap_bitmap[MAX_SWAPPED_PAGES / 32]; // 交换区位图
    uint32_t next_free;              // 下一个空闲交换块
    uint32_t total_pages;            // 总交换页面数
    uint32_t used_pages;             // 已使用页面数
};

// LRU页面管理结构
struct lru_manager {
    struct page_desc* head;          // LRU链表头
    struct page_desc* tail;          // LRU链表尾
    struct page_desc page_pool[PAGE_FRAME_MAX]; // 页面描述符池
    uint32_t active_pages;           // 活跃页面数
    uint32_t max_pages;              // 最大页面数
};

// 全局变量声明
static struct swap_manager swap_mgr;
static struct lru_manager lru_mgr;
static uint8_t swap_area[MAX_SWAPPED_PAGES * PAGE_SIZE]; // 模拟交换区

// 内核页表
pagetable_t kernel_pagetable;

// 函数声明
pagetable_t create_pagetable(void);
int map_page(pagetable_t pt, uint64_t va, uint64_t pa, int perm);
int map_region(pagetable_t pagetable, uint64_t va, uint64_t pa, uint64_t size, int perm);
void destroy_pagetable(pagetable_t pt);
void kvminit(void);
void kvminithart(void);
void dump_pagetable(pagetable_t pt, int level);

// 页面替换相关函数声明
void init_page_replacement(void);
int handle_page_fault(pagetable_t pt, uint64_t va, int perm);
struct page_desc* find_victim_page(void);
int swap_out_page(struct page_desc* page);
int swap_in_page(struct page_desc* page, uint64_t paddr);
void lru_add_page(struct page_desc* page);
void lru_remove_page(struct page_desc* page);
void lru_touch_page(uint64_t va);
struct page_desc* find_page_desc(uint64_t va);
uint32_t alloc_swap_slot(void);
void free_swap_slot(uint32_t slot);

// 页表遍历函数（内部使用）
static pte_t* walk_create(pagetable_t pagetable, uint64_t va);
static pte_t* walk_lookup(pagetable_t pagetable, uint64_t va);

// 创建页表
pagetable_t create_pagetable(void) {
    pagetable_t pagetable = (pagetable_t)alloc_page();
    if (pagetable == 0) {
        return 0;
    }
    
    // 初始化页表内容为0
    for (int i = 0; i < PTE_PER_PAGE; i++) {
        pagetable[i] = 0;
    }
    
    return pagetable;
}

// 映射内存区域
int map_region(pagetable_t pagetable, uint64_t va, uint64_t pa, uint64_t size, int perm) {
    uint64_t end = PGROUNDUP(va + size);
    
    for (uint64_t a = va; a < end; a += PAGE_SIZE, pa += PAGE_SIZE) {
        if (map_page(pagetable, a, pa, perm) != 0) {
            return -1;
        }
    }
    
    return 0;
}

// 映射虚拟地址到物理地址
int map_page(pagetable_t pt, uint64_t va, uint64_t pa, int perm) {
    // 检查地址是否按页对齐
    if ((va % PAGE_SIZE) != 0 || (pa % PAGE_SIZE) != 0) {
        return -1; // 地址未对齐
    }
    
    // 获取页表项地址
    pte_t* pte = walk_create(pt, va);
    if (pte == 0) {
        return -1; // 无法创建页表项
    }
    
    // 检查是否已经映射
    if ((*pte & PTE_V) != 0) {
        return -1; // 已经映射
    }
    
    // 设置页表项
    *pte = PA2PTE(pa) | perm | PTE_V;
    
    // 如果启用了页面替换，添加页面跟踪
    if (lru_mgr.max_pages > 0) {
        // 查找空闲的页面描述符
        for (int i = 0; i < PAGE_FRAME_MAX; i++) {
            if (lru_mgr.page_pool[i].flags == 0) {
                struct page_desc* page = &lru_mgr.page_pool[i];
                page->vaddr = va & ~(PAGE_SIZE - 1);
                page->paddr = pa;
                page->pagetable = pt;
                page->swap_offset = SWAP_NONE;
                page->flags = PAGE_PRESENT;
                if (perm & PTE_W) {
                    page->flags |= PAGE_DIRTY;
                }
                lru_add_page(page);
                break;
            }
        }
    }
    
    return 0;
}

// 销毁页表
void destroy_pagetable(pagetable_t pt) {
    // 遍历一级页表
    for (int i = 0; i < PT_ENTRIES; i++) {
        if ((pt[i] & PTE_V) && (pt[i] & (PTE_R | PTE_W | PTE_X)) == 0) {
            // 有效的非叶节点（指向下一级页表）
            uint64_t pa = PTE2PA(pt[i]);
            pte_t* next_pt = (pte_t*)pa;
            
            // 递归销毁下一级页表
            destroy_pagetable(next_pt);
        }
    }
    
    // 释放当前页表占用的物理页
    free_page((void*)pt);
}

// 页表遍历函数 - 查找或创建页表项
static pte_t* walk_create(pagetable_t pagetable, uint64_t va) {
    // 从一级页表开始遍历
    for (int level = 2; level > 0; level--) {
        // 获取当前级页表索引
        uint64_t index = PX(level, va);
        pte_t* pte = &pagetable[index];
        
        // 检查页表项是否有效
        if (*pte & PTE_V) {
            // 有效页表项，检查是否为叶节点
            if ((*pte & (PTE_R | PTE_W | PTE_X)) != 0) {
                // 叶节点，但不是我们想要的级别
                return 0;
            }
            // 继续下一级页表
            pagetable = (pagetable_t)PTE2PA(*pte);
        } else {
            // 无效页表项，需要创建新的页表
            pagetable_t new_pt = (pagetable_t)alloc_page();
            if (new_pt == 0) {
                return 0; // 内存不足
            }
            
            // 初始化新页表
            for (int i = 0; i < PTE_PER_PAGE; i++) {
                new_pt[i] = 0;
            }
            
            // 更新当前页表项指向新页表
            *pte = PA2PTE((uint64_t)new_pt) | PTE_V;
            pagetable = new_pt;
        }
    }
    
    // 返回二级页表中的页表项
    return &pagetable[PX(0, va)];
}

// 页表遍历函数 - 仅查找页表项
static pte_t* walk_lookup(pagetable_t pagetable, uint64_t va) {
    // 从一级页表开始遍历
    for (int level = 2; level > 0; level--) {
        // 获取当前级页表索引
        uint64_t index = PX(level, va);
        pte_t* pte = &pagetable[index];
        
        // 检查页表项是否有效
        if (*pte & PTE_V) {
            // 有效页表项，检查是否为叶节点
            if ((*pte & (PTE_R | PTE_W | PTE_X)) != 0) {
                // 叶节点
                return (level == 0) ? pte : 0;
            }
            // 继续下一级页表
            pagetable = (pagetable_t)PTE2PA(*pte);
        } else {
            // 无效页表项
            return 0;
        }
    }
    
    // 返回二级页表中的页表项
    return &pagetable[PX(0, va)];
}

// 初始化内核页表
void kvminit(void) {
    // 初始化页面替换系统
    init_page_replacement();
    
    // 创建内核页表
    kernel_pagetable = create_pagetable();
    if (kernel_pagetable == 0) {
        return;
    }
    
    // 获取链接脚本中定义的符号
    extern char text_start[], text_end[], rodata_start[], rodata_end[], data_start[], data_end[], bss_start[], bss_end[], end[];
    
    // 映射内核代码段（R+X权限）
    map_region(kernel_pagetable, (uint64_t)text_start, (uint64_t)text_start, 
               (uint64_t)text_end - (uint64_t)text_start, PTE_R | PTE_X);
    
    // 映射内核只读数据段（R权限）
    map_region(kernel_pagetable, (uint64_t)rodata_start, (uint64_t)rodata_start,
               (uint64_t)rodata_end - (uint64_t)rodata_start, PTE_R);
    
    // 映射内核数据段（R+W权限）
    map_region(kernel_pagetable, (uint64_t)data_start, (uint64_t)data_start,
               (uint64_t)data_end - (uint64_t)data_start, PTE_R | PTE_W);
    
    // 映射内核BSS段（R+W权限）
    map_region(kernel_pagetable, (uint64_t)bss_start, (uint64_t)bss_start,
               (uint64_t)bss_end - (uint64_t)bss_start, PTE_R | PTE_W);
    
    // 映射内核堆空间（从BSS结束到物理内存结束，R+W权限）
    map_region(kernel_pagetable, (uint64_t)end, (uint64_t)end,
               (uint64_t)PHYSTOP - (uint64_t)end, PTE_R | PTE_W);
    
    // 映射设备内存（UART等）（R+W权限）
    map_region(kernel_pagetable, UART0, UART0, PAGE_SIZE, PTE_R | PTE_W);
}

// 写入satp寄存器的内联汇编函数
static inline void w_satp(uint64_t x) {
    asm volatile("csrw satp, %0" : : "r" (x));
}

// sfence.vma指令的内联汇编函数
static inline void sfence_vma() {
    asm volatile("sfence.vma zero, zero");
}

// 激活内核页表
void kvminithart(void) {
    // 构造SATP寄存器值（SV39模式 + 页表基地址）
    uint64_t satp = SATP_MODE_SV39 | (((uint64_t)kernel_pagetable) >> 12);
    
    // 写入satp寄存器
    w_satp(satp);
    
    // 刷新TLB
    sfence_vma();
}

// 递归打印页表内容用于调试
void dump_pagetable(pagetable_t pt, int level) {
    // 打印缩进
    for (int i = 0; i < level; i++) {
        uart_putc(' ');
    }
    
    uart_puts("Page table level ");
    // 手动打印level数字
    if (level >= 10) {
        uart_putc('0' + (level / 10));
        uart_putc('0' + (level % 10));
    } else {
        uart_putc('0' + level);
    }
    uart_puts(":\n");
    
    // 遍历页表项
    for (int i = 0; i < PT_ENTRIES; i++) {
        if (pt[i] & PTE_V) {
            // 打印缩进
            for (int j = 0; j < level + 1; j++) {
                uart_putc(' ');
            }
            
            // 打印索引
            uart_puts("Index ");
            // 手动打印索引
            if (i >= 100) {
                uart_putc('0' + (i / 100));
                uart_putc('0' + ((i % 100) / 10));
                uart_putc('0' + (i % 10));
            } else if (i >= 10) {
                uart_putc('0' + (i / 10));
                uart_putc('0' + (i % 10));
            } else {
                uart_putc('0' + i);
            }
            
            uart_puts(": ");
            
            // 检查是否为叶节点
            if (pt[i] & (PTE_R | PTE_W | PTE_X)) {
                // 叶节点，打印物理地址和权限
                uint64_t pa = PTE2PA(pt[i]);
                uart_puts("PA=0x");
                // 简化打印物理地址（只打印高20位）
                uint64_t pa_high = pa >> 12;
                // 手动将数字转换为十六进制字符串
                int shift = 60;
                int started = 0;
                while (shift >= 0) {
                    int digit = (pa_high >> shift) & 0xF;
                    if (digit != 0 || started || shift == 0) {
                        started = 1;
                        uart_putc(digit < 10 ? '0' + digit : 'A' + digit - 10);
                    }
                    shift -= 4;
                }
                
                uart_puts(", perm=");
                if (pt[i] & PTE_R) uart_putc('R');
                if (pt[i] & PTE_W) uart_putc('W');
                if (pt[i] & PTE_X) uart_putc('X');
                if (pt[i] & PTE_U) uart_putc('U');
                uart_putc('\n');
            } else {
                // 非叶节点，递归打印下一级页表
                uart_puts("next level\n");
                pagetable_t next_pt = (pagetable_t)PTE2PA(pt[i]);
                dump_pagetable(next_pt, level + 1);
            }
        }
    }
}

// 页面替换系统实现

// 初始化页面替换系统
void init_page_replacement(void) {
    // 初始化交换管理器
    swap_mgr.next_free = 0;
    swap_mgr.total_pages = MAX_SWAPPED_PAGES;
    swap_mgr.used_pages = 0;
    
    // 清空交换区位图
    for (int i = 0; i < MAX_SWAPPED_PAGES / 32; i++) {
        swap_mgr.swap_bitmap[i] = 0;
    }
    
    // 初始化LRU管理器
    lru_mgr.head = 0;
    lru_mgr.tail = 0;
    lru_mgr.active_pages = 0;
    lru_mgr.max_pages = PAGE_FRAME_MAX;
    
    // 初始化页面描述符池
    for (int i = 0; i < PAGE_FRAME_MAX; i++) {
        lru_mgr.page_pool[i].vaddr = 0;
        lru_mgr.page_pool[i].paddr = 0;
        lru_mgr.page_pool[i].swap_offset = SWAP_NONE;
        lru_mgr.page_pool[i].flags = 0;
        lru_mgr.page_pool[i].prev = 0;
        lru_mgr.page_pool[i].next = 0;
        lru_mgr.page_pool[i].pagetable = 0;
    }
}

// 分配交换区槽位
uint32_t alloc_swap_slot(void) {
    if (swap_mgr.used_pages >= swap_mgr.total_pages) {
        return SWAP_NONE; // 交换区已满
    }
    
    // 查找空闲槽位
    for (uint32_t i = swap_mgr.next_free; i < swap_mgr.total_pages; i++) {
        uint32_t word_idx = i / 32;
        uint32_t bit_idx = i % 32;
        
        if (!(swap_mgr.swap_bitmap[word_idx] & (1 << bit_idx))) {
            // 找到空闲槽位
            swap_mgr.swap_bitmap[word_idx] |= (1 << bit_idx);
            swap_mgr.used_pages++;
            swap_mgr.next_free = (i + 1) % swap_mgr.total_pages;
            return i;
        }
    }
    
    // 从头开始查找
    for (uint32_t i = 0; i < swap_mgr.next_free; i++) {
        uint32_t word_idx = i / 32;
        uint32_t bit_idx = i % 32;
        
        if (!(swap_mgr.swap_bitmap[word_idx] & (1 << bit_idx))) {
            swap_mgr.swap_bitmap[word_idx] |= (1 << bit_idx);
            swap_mgr.used_pages++;
            swap_mgr.next_free = (i + 1) % swap_mgr.total_pages;
            return i;
        }
    }
    
    return SWAP_NONE; // 没有找到空闲槽位
}

// 释放交换区槽位
void free_swap_slot(uint32_t slot) {
    if (slot >= swap_mgr.total_pages || slot == SWAP_NONE) {
        return; // 无效槽位
    }
    
    uint32_t word_idx = slot / 32;
    uint32_t bit_idx = slot % 32;
    
    if (swap_mgr.swap_bitmap[word_idx] & (1 << bit_idx)) {
        swap_mgr.swap_bitmap[word_idx] &= ~(1 << bit_idx);
        swap_mgr.used_pages--;
        if (slot < swap_mgr.next_free) {
            swap_mgr.next_free = slot;
        }
    }
}

// 查找页面描述符
struct page_desc* find_page_desc(uint64_t va) {
    for (int i = 0; i < PAGE_FRAME_MAX; i++) {
        if (lru_mgr.page_pool[i].vaddr == (va & ~(PAGE_SIZE - 1)) && 
            lru_mgr.page_pool[i].flags & PAGE_PRESENT) {
            return &lru_mgr.page_pool[i];
        }
    }
    return 0;
}

// 添加页面到LRU链表头部（最近使用）
void lru_add_page(struct page_desc* page) {
    if (!page) return;
    
    page->next = lru_mgr.head;
    page->prev = 0;
    
    if (lru_mgr.head) {
        lru_mgr.head->prev = page;
    } else {
        lru_mgr.tail = page;
    }
    
    lru_mgr.head = page;
    lru_mgr.active_pages++;
}

// 从LRU链表中移除页面
void lru_remove_page(struct page_desc* page) {
    if (!page) return;
    
    if (page->prev) {
        page->prev->next = page->next;
    } else {
        lru_mgr.head = page->next;
    }
    
    if (page->next) {
        page->next->prev = page->prev;
    } else {
        lru_mgr.tail = page->prev;
    }
    
    page->next = 0;
    page->prev = 0;
    lru_mgr.active_pages--;
}

// 更新页面访问时间（移动到链表头部）
void lru_touch_page(uint64_t va) {
    struct page_desc* page = find_page_desc(va);
    if (page) {
        lru_remove_page(page);
        lru_add_page(page);
    }
}

// 选择被替换的页面（LRU算法）
struct page_desc* find_victim_page(void) {
    if (!lru_mgr.tail) {
        return 0; // 没有可替换的页面
    }
    
    return lru_mgr.tail; // 返回最久未使用的页面
}

// 将页面换出到交换区
int swap_out_page(struct page_desc* page) {
    if (!page || !(page->flags & PAGE_PRESENT)) {
        return -1; // 页面无效或不在内存中
    }
    
    // 分配交换槽位
    uint32_t swap_slot = alloc_swap_slot();
    if (swap_slot == SWAP_NONE) {
        return -1; // 交换区已满
    }
    
    // 计算交换区地址
    uint8_t* swap_addr = swap_area + swap_slot * PAGE_SIZE;
    uint8_t* page_addr = (uint8_t*)page->paddr;
    
    // 如果页面是脏的，需要写入交换区
    if (page->flags & PAGE_DIRTY) {
        // 复制页面内容到交换区
        for (int i = 0; i < PAGE_SIZE; i++) {
            swap_addr[i] = page_addr[i];
        }
    }
    
    // 更新页面表项，标记为不存在
    pte_t* pte = walk_lookup(page->pagetable, page->vaddr);
    if (pte && (*pte & PTE_V)) {
        *pte = (*pte & ~PTE_V) | (swap_slot << 10); // 在页表项中存储交换槽位
    }
    
    // 更新页面描述符
    page->swap_offset = swap_slot;
    page->flags &= ~PAGE_PRESENT;
    page->flags |= PAGE_SWAPPED;
    
    // 释放物理页面
    free_page((void*)page->paddr);
    page->paddr = 0;
    
    // 从LRU链表中移除
    lru_remove_page(page);
    
    return 0;
}

// 将页面从交换区换入内存
int swap_in_page(struct page_desc* page, uint64_t paddr) {
    if (!page || !(page->flags & PAGE_SWAPPED)) {
        return -1; // 页面无效或不在交换区
    }
    
    // 计算交换区地址
    uint8_t* swap_addr = swap_area + page->swap_offset * PAGE_SIZE;
    uint8_t* page_addr = (uint8_t*)paddr;
    
    // 从交换区复制页面内容
    for (int i = 0; i < PAGE_SIZE; i++) {
        page_addr[i] = swap_addr[i];
    }
    
    // 更新页面表项
    pte_t* pte = walk_lookup(page->pagetable, page->vaddr);
    if (pte) {
        int perm = (*pte) & (PTE_R | PTE_W | PTE_X | PTE_U);
        *pte = PA2PTE(paddr) | perm | PTE_V;
    }
    
    // 更新页面描述符
    page->paddr = paddr;
    page->flags &= ~PAGE_SWAPPED;
    page->flags |= PAGE_PRESENT;
    
    // 释放交换槽位
    free_swap_slot(page->swap_offset);
    page->swap_offset = SWAP_NONE;
    
    // 添加到LRU链表头部
    lru_add_page(page);
    
    return 0;
}

// 处理页面缺失异常
int handle_page_fault(pagetable_t pt, uint64_t va, int perm) {
    uint64_t page_va = va & ~(PAGE_SIZE - 1);
    
    // 查找页面表项
    pte_t* pte = walk_lookup(pt, page_va);
    if (!pte) {
        return -1; // 页面映射不存在
    }
    
    // 检查页面是否在交换区
    if (!(*pte & PTE_V) && (*pte != 0)) {
        // 页面在交换区，需要换入
        uint32_t swap_slot = (*pte) >> 10;
        
        // 分配物理页面
        uint64_t paddr = (uint64_t)alloc_page();
        if (!paddr) {
            // 物理内存不足，需要换出一个页面
            struct page_desc* victim = find_victim_page();
            if (!victim) {
                return -1; // 没有可替换的页面
            }
            
            // 换出选中的页面
            if (swap_out_page(victim) != 0) {
                return -1; // 换出失败
            }
            
            // 重新分配物理页面
            paddr = (uint64_t)alloc_page();
            if (!paddr) {
                return -1; // 仍然无法分配内存
            }
        }
        
        // 查找对应的页面描述符
        struct page_desc* page = 0;
        for (int i = 0; i < PAGE_FRAME_MAX; i++) {
            if (lru_mgr.page_pool[i].vaddr == page_va && 
                lru_mgr.page_pool[i].flags & PAGE_SWAPPED &&
                lru_mgr.page_pool[i].swap_offset == swap_slot) {
                page = &lru_mgr.page_pool[i];
                break;
            }
        }
        
        if (!page) {
            // 创建新的页面描述符
            for (int i = 0; i < PAGE_FRAME_MAX; i++) {
                if (lru_mgr.page_pool[i].flags == 0) {
                    page = &lru_mgr.page_pool[i];
                    page->vaddr = page_va;
                    page->pagetable = pt;
                    page->swap_offset = swap_slot;
                    page->flags = PAGE_SWAPPED;
                    break;
                }
            }
        }
        
        if (page && swap_in_page(page, paddr) == 0) {
            return 0; // 换入成功
        } else {
            free_page((void*)paddr);
            return -1; // 换入失败
        }
    }
    
    return -1; // 其他类型的页面缺失
}

// 获取虚拟地址对应的物理地址，支持页面替换
uint64_t va2pa_with_replacement(pagetable_t pt, uint64_t va) {
    pte_t* pte = walk_lookup(pt, va);
    
    if (!pte) {
        return 0; // 页面映射不存在
    }
    
    if (*pte & PTE_V) {
        // 页面在内存中，更新访问记录
        lru_touch_page(va);
        return PTE2PA(*pte) + (va & (PAGE_SIZE - 1));
    } else if (*pte != 0) {
        // 页面在交换区，触发页面缺失处理
        if (handle_page_fault(pt, va, PTE_R | PTE_W) == 0) {
            pte = walk_lookup(pt, va);
            if (pte && (*pte & PTE_V)) {
                return PTE2PA(*pte) + (va & (PAGE_SIZE - 1));
            }
        }
    }
    
    return 0; // 页面不可访问
}

// 安全的内存访问函数，支持页面替换
int safe_copyout(pagetable_t pt, uint64_t dstva, char* src, uint64_t len) {
    while (len > 0) {
        uint64_t va0 = dstva & ~(PAGE_SIZE - 1);
        uint64_t pa = va2pa_with_replacement(pt, va0);
        
        if (pa == 0) {
            return -1; // 页面不可访问
        }
        
        uint64_t n = PAGE_SIZE - (dstva - va0);
        if (n > len) {
            n = len;
        }
        
        // 复制数据
        char* dst = (char*)(pa + (dstva - va0));
        for (uint64_t i = 0; i < n; i++) {
            dst[i] = src[i];
        }
        
        // 标记页面为脏
        struct page_desc* page = find_page_desc(va0);
        if (page) {
            page->flags |= PAGE_DIRTY;
        }
        
        len -= n;
        src += n;
        dstva = va0 + PAGE_SIZE;
    }
    
    return 0;
}

// 安全的内存读取函数，支持页面替换
int safe_copyin(pagetable_t pt, char* dst, uint64_t srcva, uint64_t len) {
    while (len > 0) {
        uint64_t va0 = srcva & ~(PAGE_SIZE - 1);
        uint64_t pa = va2pa_with_replacement(pt, va0);
        
        if (pa == 0) {
            return -1; // 页面不可访问
        }
        
        uint64_t n = PAGE_SIZE - (srcva - va0);
        if (n > len) {
            n = len;
        }
        
        // 复制数据
        char* src = (char*)(pa + (srcva - va0));
        for (uint64_t i = 0; i < n; i++) {
            dst[i] = src[i];
        }
        
        len -= n;
        dst += n;
        srcva = va0 + PAGE_SIZE;
    }
    
    return 0;
}

// 页面替换测试函数
void test_page_replacement(void) {
    uart_puts("Testing page replacement system...\n");
    
    // 测试交换区管理
    uart_puts("1. Testing swap slot allocation...\n");
    uint32_t slot1 = alloc_swap_slot();
    uint32_t slot2 = alloc_swap_slot();
    uint32_t slot3 = alloc_swap_slot();
    
    if (slot1 != SWAP_NONE && slot2 != SWAP_NONE && slot3 != SWAP_NONE &&
        slot1 != slot2 && slot2 != slot3 && slot1 != slot3) {
        uart_puts("   Swap slot allocation: PASS\n");
    } else {
        uart_puts("   Swap slot allocation: FAIL\n");
    }
    
    // 测试交换区释放
    free_swap_slot(slot2);
    uint32_t slot4 = alloc_swap_slot();
    if (slot4 == slot2) {
        uart_puts("   Swap slot free/realloc: PASS\n");
    } else {
        uart_puts("   Swap slot free/realloc: FAIL\n");
    }
    
    // 测试LRU链表操作
    uart_puts("2. Testing LRU operations...\n");
    
    // 重置LRU管理器
    lru_mgr.head = 0;
    lru_mgr.tail = 0;
    lru_mgr.active_pages = 0;
    
    // 创建测试页面
    struct page_desc test_pages[3];
    for (int i = 0; i < 3; i++) {
        test_pages[i].vaddr = 0x10000 + i * PAGE_SIZE;
        test_pages[i].paddr = 0x80000000 + i * PAGE_SIZE;
        test_pages[i].flags = PAGE_PRESENT;
        test_pages[i].swap_offset = SWAP_NONE;
        test_pages[i].next = 0;
        test_pages[i].prev = 0;
        test_pages[i].pagetable = kernel_pagetable;
    }
    
    // 添加页面到LRU链表
    lru_add_page(&test_pages[0]);
    lru_add_page(&test_pages[1]);
    lru_add_page(&test_pages[2]);
    
    if (lru_mgr.active_pages == 3 && lru_mgr.head == &test_pages[2] && 
        lru_mgr.tail == &test_pages[0]) {
        uart_puts("   LRU add operations: PASS\n");
    } else {
        uart_puts("   LRU add operations: FAIL\n");
    }
    
    // 测试LRU移除
    lru_remove_page(&test_pages[1]);
    if (lru_mgr.active_pages == 2 && lru_mgr.head == &test_pages[2] && 
        lru_mgr.tail == &test_pages[0]) {
        uart_puts("   LRU remove operations: PASS\n");
    } else {
        uart_puts("   LRU remove operations: FAIL\n");
    }
    
    // 测试受害页面选择
    struct page_desc* victim = find_victim_page();
    if (victim == &test_pages[0]) {
        uart_puts("   Victim page selection: PASS\n");
    } else {
        uart_puts("   Victim page selection: FAIL\n");
    }
    
    uart_puts("Page replacement test completed.\n");
}

// ==================== 用户进程页表管理 ====================

// 从虚拟地址获取物理地址（不带页面替换）
uint64_t walkaddr(pagetable_t pagetable, uint64_t va) {
    if (va >= (1L << 39)) {
        return 0;
    }
    
    pte_t* pte = walk_lookup(pagetable, va);
    if (pte == 0 || (*pte & PTE_V) == 0) {
        return 0;
    }
    if ((*pte & PTE_U) == 0) {
        return 0;
    }
    
    uint64_t pa = PTE2PA(*pte);
    return pa;
}

// 复制用户内存到内核
// 从用户页表pagetable的srcva地址复制len字节到内核的dst
int copyin(pagetable_t pagetable, char* dst, uint64_t srcva, uint64_t len) {
    uint64_t n, va0, pa0;
    
    while (len > 0) {
        va0 = PGROUNDDOWN(srcva);
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        
        n = PAGE_SIZE - (srcva - va0);
        if (n > len) {
            n = len;
        }
        
        // 简单的内存复制
        char* src = (char*)(pa0 + (srcva - va0));
        for (uint64_t i = 0; i < n; i++) {
            dst[i] = src[i];
        }
        
        len -= n;
        dst += n;
        srcva = va0 + PAGE_SIZE;
    }
    
    return 0;
}

// 复制内核内存到用户
// 从内核的src复制len字节到用户页表pagetable的dstva地址
int copyout(pagetable_t pagetable, uint64_t dstva, char* src, uint64_t len) {
    uint64_t n, va0, pa0;
    
    while (len > 0) {
        va0 = PGROUNDDOWN(dstva);
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        
        n = PAGE_SIZE - (dstva - va0);
        if (n > len) {
            n = len;
        }
        
        // 简单的内存复制
        char* dst = (char*)(pa0 + (dstva - va0));
        for (uint64_t i = 0; i < n; i++) {
            dst[i] = src[i];
        }
        
        len -= n;
        src += n;
        dstva = va0 + PAGE_SIZE;
    }
    
    return 0;
}

// 取消用户页表的映射，释放对应物理页
// 从va开始，取消npages个页面的映射
// do_free为1时释放物理页
void uvmunmap(pagetable_t pagetable, uint64_t va, uint64_t npages, int do_free) {
    if ((va % PAGE_SIZE) != 0) {
        return;  // va must be page-aligned
    }
    
    for (uint64_t a = va; a < va + npages * PAGE_SIZE; a += PAGE_SIZE) {
        pte_t* pte = walk_lookup(pagetable, a);
        if (pte == 0) {
            continue;
        }
        if ((*pte & PTE_V) == 0) {
            continue;
        }
        if (PTE2PA(*pte) == 0) {
            continue;
        }
        
        if (do_free) {
            uint64_t pa = PTE2PA(*pte);
            free_page((void*)pa);
        }
        
        *pte = 0;
    }
}

// 释放用户内存：从oldsz缩减到newsz
// 返回新的大小
uint64_t uvmdealloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz) {
    if (newsz >= oldsz) {
        return oldsz;
    }
    
    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PAGE_SIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }
    
    return newsz;
}

// 分配用户内存：从oldsz增长到newsz
// 返回新的大小，失败返回0
uint64_t uvmalloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz) {
    if (newsz < oldsz) {
        return oldsz;
    }
    
    oldsz = PGROUNDUP(oldsz);
    
    for (uint64_t a = oldsz; a < newsz; a += PAGE_SIZE) {
        void* mem = alloc_page();
        if (mem == 0) {
            uvmdealloc(pagetable, a, oldsz);
            return 0;
        }
        
        // 清零新分配的页面
        char* p = (char*)mem;
        for (int i = 0; i < PAGE_SIZE; i++) {
            p[i] = 0;
        }
        
        if (map_page(pagetable, a, (uint64_t)mem, PTE_W | PTE_R | PTE_X | PTE_U) != 0) {
            free_page(mem);
            uvmdealloc(pagetable, a, oldsz);
            return 0;
        }
    }
    
    return newsz;
}

// 释放用户页表中的所有页面（递归）
void freewalk(pagetable_t pagetable) {
    // 遍历所有512个PTE
    for (int i = 0; i < 512; i++) {
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
            // 这个PTE指向下一级页表
            uint64_t child = PTE2PA(pte);
            freewalk((pagetable_t)child);
            pagetable[i] = 0;
        } else if (pte & PTE_V) {
            // 忽略已映射的叶子页面
        }
    }
    free_page((void*)pagetable);
}

// 释放用户内存页面，但不释放页表页
void uvmfree(pagetable_t pagetable, uint64_t sz) {
    if (sz > 0) {
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PAGE_SIZE, 1);
    }
}

// 为新进程创建用户页表
// 简化版本：暂时不映射trapframe到用户空间
// trapframe在内核空间管理
pagetable_t proc_pagetable(struct proc* p) {
    pagetable_t pagetable;
    
    if (!p) {
        uart_puts("[vm] proc_pagetable: null proc\n");
        return 0;
    }
    
    // 创建空的页表
    pagetable = create_pagetable();
    if (pagetable == 0) {
        uart_puts("[vm] proc_pagetable: failed to create pagetable\n");
        return 0;
    }
    
    // 注意：trapframe保留在内核空间，不映射到用户空间
    // 在真实的xv6中，trapframe会映射到用户空间以便快速访问
    // 这里简化处理，trapframe只在内核中访问
    
    return pagetable;
}

// 释放进程的用户页表
void proc_freepagetable(pagetable_t pagetable, uint64_t sz) {
    // 释放用户内存页面
    if (sz > 0) {
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PAGE_SIZE, 1);
    }
    
    // 释放页表本身
    freewalk(pagetable);
}

// 复制父进程的用户内存到子进程
int uvmcopy(pagetable_t old, pagetable_t new, uint64_t sz) {
    pte_t* pte;
    uint64_t pa, i;
    uint64_t flags;
    char* mem;
    
    for (i = 0; i < sz; i += PAGE_SIZE) {
        if ((pte = walk_lookup(old, i)) == 0) {
            goto err;
        }
        if ((*pte & PTE_V) == 0) {
            goto err;
        }
        
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);
        
        if ((mem = (char*)alloc_page()) == 0) {
            goto err;
        }
        
        // 复制页面内容
        char* src = (char*)pa;
        for (int j = 0; j < PAGE_SIZE; j++) {
            mem[j] = src[j];
        }
        
        if (map_page(new, i, (uint64_t)mem, flags) != 0) {
            free_page(mem);
            goto err;
        }
    }
    
    return 0;

err:
    uvmunmap(new, 0, i / PAGE_SIZE, 1);
    return -1;
}