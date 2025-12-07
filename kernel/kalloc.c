#include "defs.h"
#include <stdint.h>

// 定义页面大小为4KB
#define PAGE_SIZE 4096
#define PAGE_ALIGN_UP(addr) (((addr) + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
#define PAGE_ALIGN_DOWN(addr) ((addr) & ~(PAGE_SIZE - 1))

// 物理页描述符
struct run {
    struct run *next;
};

// 内存区域描述符
struct mem_area {
    uint64_t start;
    uint64_t end;
};

// 全局变量
static struct run *freelist;  // 空闲页链表
static uint64_t mem_start;    // 可用内存起始地址
static uint64_t mem_end;      // 可用内存结束地址

// 函数声明
void pmm_init(uint64_t start, uint64_t end);
void* alloc_page(void);
void free_page(void* page);
void* alloc_pages(int n);

// 初始化物理内存管理器
void pmm_init(uint64_t start, uint64_t end) {
    // 对齐内存边界到页面边界
    mem_start = PAGE_ALIGN_UP(start);
    mem_end = PAGE_ALIGN_DOWN(end);
    
    // 初始化空闲链表
    freelist = 0;
    
    // 将整个可用内存区域添加到空闲链表中
    for (uint64_t addr = mem_start; addr < mem_end; addr += PAGE_SIZE) {
        free_page((void*)addr);
    }
}

// 分配一个物理页
void* alloc_page(void) {
    struct run *r;
    
    // 从空闲链表中取出第一个页面
    r = freelist;
    if (r == 0) {
        return 0; // 没有可用页面
    }
    
    freelist = r->next;
    return (void*)r;
}

// 释放一个物理页
void free_page(void* page) {
    struct run *r;
    
    if (page == 0) {
        return; // 无效地址
    }
    
    // 检查页面地址是否在合法范围内
    uint64_t addr = (uint64_t)page;
    if (addr < mem_start || addr >= mem_end) {
        return; // 地址超出范围
    }
    
    // 检查页面地址是否对齐
    if (addr & (PAGE_SIZE - 1)) {
        return; // 地址未对齐
    }
    
    // 将页面添加到空闲链表头部
    r = (struct run*)page;
    r->next = freelist;
    freelist = r;
}

// 分配连续的n个页面（链表扫描法，保证物理连续）
void* alloc_pages(int n) {
    if (n <= 0) {
        return 0;
    }
    if (n == 1) {
        return alloc_page();
    }
    struct run *prev = 0, *start = freelist, *cur = freelist;
    int count = 1;
    while (cur) {
        struct run *next = cur->next;
        if (count == n) {
            if (prev)
                prev->next = next;
            else
                freelist = next;
            struct run *last = cur;
            last->next = 0;
            return start;
        }
        if (next && (uint64_t)next == (uint64_t)cur + PAGE_SIZE) {
            cur = next;
            count++;
        } else {
            prev = cur;
            cur = cur->next;
            start = cur;
            count = 1;
        }
    }
    return 0;
}
