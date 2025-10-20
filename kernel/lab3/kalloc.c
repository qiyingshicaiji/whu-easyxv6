#include "riscv.h"
#include "printf.h"

// 定义空闲页链表结构，该结构本身存储在空闲页的头部
struct run {
    struct run *next;
};

// 空闲页链表的头指针
static struct run *freelist;

// 内核代码段结束地址 (由链接脚本定义)
extern uint64 etext[];

// 内存上限 (假设 QEMU virt 平台有 128MB 内存)
#define PHYSTOP 0x80800000 

// 释放一个物理页，将其添加到空闲链表头部
void kfree(void *pa) {
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (uint64)pa < (uint64)etext || (uint64)pa >= PHYSTOP) {
        printf("kfree: invalid address %p\n", pa);
        return;
    }

    // 将该页用作链表节点
    r = (struct run*)pa;
    r->next = freelist;
    freelist = r;
}

// 将一段物理内存初始化并加入空闲链表
static void freerange(void *pa_start, void *pa_end) {
    char *p;
    p = (char*)PGROUNDUP((uint64)pa_start);
    for (; (uint64)p + PGSIZE <= (uint64)pa_end; p += PGSIZE) {
        kfree(p);
    }
}

// 初始化物理内存分配器
void kinit() {
    // 从 etext 之后开始，初始化到 PHYSTOP
    freerange(etext, (void*)PHYSTOP);
    printf("PMM initialized. Total available memory: %dMB\n", (PHYSTOP - (uint64)etext) / (1024 * 1024));
}

// 分配一个物理页 (从空闲链表头部取出)
void *kalloc() {
    struct run *r;

    r = freelist;
    if (r) {
        freelist = r->next;
    } else {
        // 内存耗尽
        printf("kalloc: out of memory!\n");
        return (void*)0; // 内存耗尽时返回空指针
    }
    
    // 返回分配的页面
    return (void*)r; 
}