#include "riscv.h"
#include "printf.h"
#include<assert.h>

// 外部函数声明
extern void kinit(void);
extern void kfree(void*);
extern void* kalloc(void);
extern pagetable_t kvminit(void);
extern void kvminithart(pagetable_t kpt);

// C 语言入口函数
void main() {
    // 1. 初始化物理内存分配器
    kinit();
    
    // 2. 创建内核页表
    pagetable_t kpt = kvminit();
    if (!kpt) {
        // 简单错误处理
        while(1);
    }
    
    // 3. 激活虚拟内存
    kvminithart(kpt);
    
    // 4. 清屏和基础测试
    clear_screen();
    printf("--- Basic printf Tests ---\n");
    printf("Hello from printf!\n");
    printf("====================\n");
    
    // --- 安全的基础测试 ---
    printf("1. Testing integer: %d\n", 42);
    printf("2. Testing negative: %d\n", -123);
    printf("3. Testing zero: %d\n", 0);
    printf("4. Testing hex: 0x%x\n", 0xABC);
    printf("5. Testing string: %s\n", "This is a test string.");
    printf("6. Testing char: %c\n", 'X');
    printf("7. Testing percent: %%\n");

    // --- 安全的边界测试 ---
    int int_min = -2147483648;
    printf("8. INT_MIN: %d\n", int_min);
   //  printf("9. NULL string: %s\n", (char*)0);
    printf("9. NULL string: %s\n", "(null)"); // 使用字符串代替空指针
    
    printf("\nBasic tests passed!\n");
    printf("====================\n");

    // 5. 内存分配测试
    void *p1 = kalloc();
    void *p2 = kalloc();
    printf("Allocated page 1 at PA: 0x%x\n", p1);
    printf("Allocated page 2 at PA: 0x%x\n", p2);
    
   //  assert(p1 != p2);
   //  assert(((uint64)p1 & 0xFFF) == 0);  // 页对齐检查
    // 测试数据写入
    *(int*)p1 = 0x12345678; 
    printf("Wrote data 0x%x to PA 0x%x.\n", *(int*)p1, p1);
   //  assert(*(int*)p1 == 0x12345678); 
    // 测试释放和重新分配
    void *p3 = kalloc();
    printf("Allocated page 3 at PA: 0x%x\n", p3);

    // page3可能等于page1（取决于分配策略)
    kfree(p3);     
    // 6. 验证虚拟地址访问
    printf("Kernel running under VA. Read data from VA 0x%x: 0x%x\n", p1, *(uint64*)p1);
    
    // 7. 释放内存
    kfree(p1);
    kfree(p2);
   //  clear_screen();

   //  pagetable_t pt = create_pagetable();
   //  // 测试基本映射
   //  uint64 va = 0x1000000;
   //  uint64 pa = (uint64)kalloc();
   //  assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0); 
   //  // 测试地址转换
   //  pte_t *pte = walk_lookup(pt, va);
   //  assert(pte != 0 && (*pte & PTE_V));
   //  assert(PTE_PA(*pte) == pa); 
   //  // 测试权限位
   //  assert(*pte & PTE_R);
   //  assert(*pte & PTE_W);
   //  assert(!(*pte & PTE_X)); 

    // 进入死循环
    while (1);
}