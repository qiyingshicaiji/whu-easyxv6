#ifndef _MEMLAYOUT_H_
#define _MEMLAYOUT_H_

// 内核虚拟地址起始
#define KERNBASE 0x80000000L

// 物理内存顶部
#define PHYSTOP (KERNBASE + 128 * 1024 * 1024) // 128MB

// 设备地址
#define UART0 0x10000000L
#define VIRTIO0 0x10001000L
#define CLINT 0x2000000L
#define PLIC 0x0c000000L

// 内核内存区域声明
extern char etext[];  // 内核代码结束地址
extern char end[];    // 内核数据结束地址

#endif // _MEMLAYOUT_H_