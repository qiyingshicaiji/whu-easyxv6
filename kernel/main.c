#include "uart.h"
#include "console.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "printf.h"
#include "kalloc.h"
#include "vm.h"
#include "defs.h"
#include<assert.h>
#include<stdio.h>

// 声明printf.c中的测试函数
//void test_printf_basic(void);
//void test_printf_edge_cases(void);
// C主函数，启动后由entry.S跳转到这里
 void test_physical_memory(void) {
    // 测试基本分配和释放
    void *page1 = alloc_page();
    void *page2 = alloc_page();
    assert(page1 != page2);
    assert(((uint64)page1 & 0xFFF) == 0);  // 页对齐检查
    // 测试数据写入
    *(int*)page1 = 0x12345678; 
    assert(*(int*)page1 == 0x12345678); 
    // 测试释放和重新分配
    free_page(page1);
    void *page3 = alloc_page();
    // page3可能等于page1（取决于分配策略)
    free_page(page2); 
    free_page(page3); 
 }
  void test_pagetable(void) { 
    pagetable_t pt = create_pagetable();
    // 测试基本映射
    uint64 va = 0x1000000;
    uint64 pa = (uint64)alloc_page();
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0); 
    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    assert(pte != 0 && (*pte & PTE_V));
    assert(PTE_PA(*pte) == pa); 
    // 测试权限位
    assert(*pte & PTE_R);
    assert(*pte & PTE_W);
    assert(!(*pte & PTE_X)); 
 }
 void test_virtual_memory(void) {
    printf("Before enabling paging...\n");
    // 启用分页
    kvminit();
    kvminithart();
    printf("After enabling paging...\n");
    // 测试内核代码仍然可执行
    // 测试内核数据仍然可访问
    // 测试设备访问仍然正常
}
void main() {
    // clear_screen();
    uart_puts("Hello, OS!\n");

    printf("Testing integer: %d\n", 42);
    printf("Testing negative: %d\n", -123);
    printf("Testing zero: %d\n", 0);
    printf("Testing hex: 0x%x\n", 0xabc);
    printf("Testing string: %s\n", "Hello");
    printf("Testing char: %c\n", 'X');
    printf("Testing percent: %%\n");
    printf("INT_MAX: %d\n", 2147483647);
    printf("INT_MIN: %d\n", -2147483648);
    printf("NULL string: %s\n", (char*)0);
    printf("Empty string: %s\n", "");
    printf("NULL: %s\n", "");
    // clear_screen();
    // 程序结束后进入死循环，防止意外退出
    while (1) {};
}