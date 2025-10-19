#ifndef VM_H
#define VM_H

#include <stdint.h>
#include <stddef.h>

#define PGSIZE 4096
#define PTE_V (1L << 0) // valid
#define PTE_R (1L << 1) // readable
#define PTE_W (1L << 2) // writable
#define PTE_X (1L << 3) // executable
#define PTE_U (1L << 4) // user accessible

typedef uint64_t pte_t;
typedef uint64_t uintptr_t;
typedef uint64_t physaddr_t;
typedef uint64* pagetable_t;

// Physical memory allocator
void kinit(void);
void* kalloc(void);
void kfree(void* pa);

// Virtual memory management
void kvminit(void);
void kvmmap(uintptr_t va, uintptr_t pa, uint64_t size, int perm);
pte_t* walk(uint64_t va, int create);

#endif // VM_H
