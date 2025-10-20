#ifndef _PRINTF_H_
#define _PRINTF_H_

#include <stdarg.h>

// 定义终端颜色，使用 ANSI 转义序列
typedef enum {
    COLOR_RESET = 0,
    COLOR_RED = 31,
    COLOR_GREEN = 32,
    COLOR_YELLOW = 33,
    COLOR_BLUE = 34
} term_color_t;

int printf(const char *fmt, ...);
void clear_screen();
void goto_xy(int x, int y);
void clear_line();
void printf_color(term_color_t color, const char *fmt, ...);

#endif