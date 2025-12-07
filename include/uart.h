#ifndef _UART_H
#define _UART_H

#include <stdint.h>

#define __section(x) __attribute__((section(x)))
#define RODATA __section(".rodata")

// ANSI颜色代码
typedef enum {
    COLOR_BLACK = 30,
    COLOR_RED = 31,
    COLOR_GREEN = 32,
    COLOR_YELLOW = 33,
    COLOR_BLUE = 34,
    COLOR_MAGENTA = 35,
    COLOR_CYAN = 36,
    COLOR_WHITE = 37,
    COLOR_DEFAULT = 39
} color_t;

void uart_putc(char c);
void uart_puts(const char *s);

// 屏幕操作函数
void clear_screen(void);
void clear_line(void);
void goto_xy(int x, int y);
int printf_color(color_t color, const char *fmt, ...);
int printf(const char *fmt, ...);

#endif