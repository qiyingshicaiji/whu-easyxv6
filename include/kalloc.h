#ifndef _KALLOC_H_
#define _KALLOC_H_

#include "types.h"
#include "spinlock.h"

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

// 函数声明
void pmm_init(void);           // 初始化物理内存管理器
void* alloc_page(void);         // 分配单个物理页
void free_page(void* page);     // 释放单个物理页
void* alloc_pages(int n);       // 分配连续n个物理页
uint64 get_free_pages(void);    // 获取空闲页数
uint64 get_total_pages(void);   // 获取总页数

#endif // _KALLOC_H_
