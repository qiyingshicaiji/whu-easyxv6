#include <stdint.h>  // 用于uint8_t类型

#define UART0 0x10000000L
#define UART_THR (UART0 + 0)   // 发送寄存器
#define UART_LSR (UART0 + 5)   // 状态寄存器
#define UART_LSR_TX_IDLE 0x20  // 发送缓冲区空

static inline void outb(unsigned long addr, unsigned char val) {
    *(volatile unsigned char*)addr = val;
}

static inline unsigned char inb(unsigned long addr) {
    return *(volatile unsigned char*)addr;
}

// 输出单个字符
void uart_putc(char c) {
    // 等待发送缓冲区空
    while ((inb(UART_LSR) & UART_LSR_TX_IDLE) == 0);
    outb(UART_THR, c);
}

// 输出字符串
void uart_puts(const char *s) {
    while (*s) {
        uart_putc(*s++);
    }
}