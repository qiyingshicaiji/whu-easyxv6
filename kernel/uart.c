#include "uart.h"

// UART寄存器地址定义
#define UART0 0x10000000L
#define UART_THR 0  // 发送保持寄存器
#define UART_LSR 5  // 线路状态寄存器
#define UART_LSR_EMPTY_MASK 0x20  // 发送保持寄存器空标志位

// 从指定地址读取一个字节
static inline unsigned char uart_read_reg(int reg) {
    return *(volatile unsigned char *)((unsigned long)(UART0 + reg));
}

// 向指定地址写入一个字节
static inline void uart_write_reg(int reg, unsigned char v) {
    *(volatile unsigned char *)((unsigned long)(UART0 + reg)) = v;
}

// 等待UART就绪
static void uart_wait() {
    while((uart_read_reg(UART_LSR) & UART_LSR_EMPTY_MASK) == 0);
}

// 输出一个字符
void uart_putc(char c) {
    uart_wait();
    uart_write_reg(UART_THR, c);
}

// 输出字符串
void uart_puts(const char *s) {
    while(*s) {
        uart_putc(*s++);
    }
}
