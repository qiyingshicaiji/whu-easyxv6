#include "kalloc.h"


// 物理页元数据结构
struct run {
  struct run *next;
};

// 全局内存管理结构
struct {
  struct spinlock lock;       // 保护空闲链表的锁
  struct run *freelist;       // 空闲页链表
  uint64 free_pages;          // 空闲页计数
  uint64 total_pages;         // 总页数
} kmem;

// 自旋锁实现
void initlock(struct spinlock *lk, char *name) {
  lk->locked = 0;
}

void acquire(struct spinlock *lk) {
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0);
  __sync_synchronize();
}

void release(struct spinlock *lk) {
  __sync_synchronize();
  __sync_lock_release(&lk->locked);
}

// 内存错误处理
void panic(char *s) {
  // 实际实现中应有更完整的错误处理
  for(;;);
}

// 初始化物理内存管理器
void pmm_init(void) {
  // 初始化锁
  initlock(&kmem.lock, "kmem");
  
  // 计算可用内存范围
  extern char end[];  // 内核结束地址
  uint64 pa_start = (uint64)PGROUNDUP((uint64)end);
  uint64 pa_end = PHYSTOP;
  
  // 初始化统计信息
  kmem.freelist = 0;
  kmem.free_pages = 0;
  kmem.total_pages = (pa_end - pa_start) / PGSIZE;
  
  // 将所有可用内存页加入空闲链表
  for (uint64 pa = pa_start; pa < pa_end; pa += PGSIZE) {
    free_page((void*)pa);
  }
  
  // 输出内存信息
  printf("pmm_init: %d/%d free pages\n", kmem.free_pages, kmem.total_pages);
}

// 分配单个物理页
void* alloc_page(void) {
  acquire(&kmem.lock);
  
  struct run *r = kmem.freelist;
  if (r) {
    kmem.freelist = r->next;
    kmem.free_pages--;
    
    // 清空页面内容
    memset((char*)r, 0, PGSIZE);
  }
  
  release(&kmem.lock);
  return (void*)r;
}

// 释放单个物理页
void free_page(void* pa) {
  // 基本安全检查
  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("free_page: invalid address");
  
  struct run *r = (struct run*)pa;
  acquire(&kmem.lock);
  
  // 双重释放检查
  for (struct run *p = kmem.freelist; p; p = p->next) {
    if (p == r)
      panic("free_page: double free detected");
  }
  
  // 添加到链表头部
  r->next = kmem.freelist;
  kmem.freelist = r;
  kmem.free_pages++;
  
  release(&kmem.lock);
}

// 分配连续n个物理页
void* alloc_pages(int n) {
  if (n <= 0) 
    return 0;
  
  acquire(&kmem.lock);
  
  void *first = 0;
  for (int i = 0; i < n; i++) {
    struct run *r = kmem.freelist;
    if (!r) {
      // 分配失败 - 回滚已分配的页
      while (i-- > 0) {
        struct run *rollback = (struct run*)((char*)first + i * PGSIZE);
        rollback->next = kmem.freelist;
        kmem.freelist = rollback;
        kmem.free_pages++;
      }
      release(&kmem.lock);
      return 0;
    }
    
    kmem.freelist = r->next;
    kmem.free_pages--;
    
    if (i == 0) first = r;  // 记录第一页
    
    // 清空页面
    memset((char*)r, 0, PGSIZE);
  }
  
  release(&kmem.lock);
  return first;
}

// 获取内存统计信息
uint64 get_free_pages(void) {
  return kmem.free_pages;
}

uint64 get_total_pages(void) {
  return kmem.total_pages;
}
