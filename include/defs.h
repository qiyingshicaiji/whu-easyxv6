#ifndef _DEFS_H
#define _DEFS_H
#include <stdint.h>

#define PAGE_SIZE 4096


// 权限位定义
#define PTE_R (1L << 1)  // 读权限
#define PTE_W (1L << 2)  // 写权限
#define PTE_X (1L << 3)  // 执行权限
#define PTE_U (1L << 4)  // 用户权限

// 页表类型定义
typedef uint64_t* pagetable_t;
#define PAGE_SIZE 4096

// 权限位定义
#define PTE_R (1L << 1)  // 读权限
#define PTE_W (1L << 2)  // 写权限
#define PTE_X (1L << 3)  // 执行权限
#define PTE_U (1L << 4)  // 用户权限

// 物理内存分配器接口
typedef uint64_t paddr_t;
void pmm_init(uint64_t start, uint64_t end);
void* alloc_page(void);
void free_page(void* page);
void* alloc_pages(int n);

// 其他全局声明可在此扩展

// 页表管理器函数声明
pagetable_t create_pagetable(void);
int map_page(pagetable_t pt, uint64_t va, uint64_t pa, int perm);
int map_region(pagetable_t pagetable, uint64_t va, uint64_t pa, uint64_t size, int perm);
void destroy_pagetable(pagetable_t pt);
void dump_pagetable(pagetable_t pt, int level);
void kvminit(void);
void kvminithart(void);

// 用户进程页表管理函数声明
struct proc;  // 前向声明
pagetable_t proc_pagetable(struct proc* p);
void proc_freepagetable(pagetable_t pagetable, uint64_t sz);
uint64_t uvmalloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz);
uint64_t uvmdealloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz);
void uvmunmap(pagetable_t pagetable, uint64_t va, uint64_t npages, int do_free);
void uvmfree(pagetable_t pagetable, uint64_t sz);
int uvmcopy(pagetable_t old, pagetable_t new, uint64_t sz);
void freewalk(pagetable_t pagetable);
uint64_t walkaddr(pagetable_t pagetable, uint64_t va);
int copyin(pagetable_t pagetable, char* dst, uint64_t srcva, uint64_t len);
int copyout(pagetable_t pagetable, uint64_t dstva, char* src, uint64_t len);


// 页面替换系统函数声明
void init_page_replacement(void);
int handle_page_fault(pagetable_t pt, uint64_t va, int perm);
uint64_t va2pa_with_replacement(pagetable_t pt, uint64_t va);
int safe_copyout(pagetable_t pt, uint64_t dstva, char* src, uint64_t len);
int safe_copyin(pagetable_t pt, char* dst, uint64_t srcva, uint64_t len);
void lru_touch_page(uint64_t va);

// 测试函数声明
void basic_format_test();
void boundary_test();
void color_test();
void screen_test();
void performance_test();
void error_recovery_test();
void pmm_test();
void pt_test();
void test_virtual_memory(void);
void test_page_replacement(void);

// 页面替换演示函数声明
void demonstrate_page_replacement(void);
void print_page_replacement_info(void);

// 中断和进程管理函数声明
void trap_init(void);
void trap_init_hart(void);
void proc_init(void);
void scheduler(void);

#endif
