#include "riscv.h"
#include "printf.h"

// 外部函数声明 (从 kalloc.c 和 vm.c 引入)
extern void kinit(void);
extern void kfree(void*);
extern void* kalloc(void);
extern pagetable_t kvminit(void);
extern void kvminithart(pagetable_t kpt);

// C 语言入口函数
void main() {
    // 1. 初始化物理内存分配器 (PMM)
    kinit();
    
    // 2. 内存分配测试
    void *p1 = kalloc();
    void *p2 = kalloc();
    printf("Allocated page 1 at PA: 0x%x\n", p1);
    printf("Allocated page 2 at PA: 0x%x\n", p2);
    
    // 写入数据测试 (写入物理内存)
    if (p1) {
        *(uint64*)p1 = 0xDEADBEEF; 
        printf("Wrote data 0x%x to PA 0x%x.\n", 0xDEADBEEF, p1);
    }
    
    // 3. 创建和初始化内核页表
    pagetable_t kpt = kvminit();
    
    // 4. 激活虚拟内存
    if (kpt) {
        kvminithart(kpt);
    }

    // 5. 验证：激活后，通过虚拟地址访问数据。
    // 由于我们使用的是恒等映射 (VA == PA)，这里 p1 也是 VA
    printf("Kernel running under VA. Read data from VA 0x%x: 0x%x\n", p1, *(uint64*)p1);
    
    // 6. 释放内存
    kfree(p1);
    kfree(p2);

    // 进入死循环, 防止程序跑飞
    while (1);
}