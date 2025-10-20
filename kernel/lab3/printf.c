// --------------------------------------------------------
// 内核 printf 扩展实现 (lab2/printf.c)
// --------------------------------------------------------
#include "riscv.h" 
#include "printf.h"
#include <stdarg.h>

// 外部函数声明
void uart_putc(char c);

// 打印单个字符
static void putc(char c) {
    uart_putc(c);
}

// 打印字符串
static void puts(const char *s) {
    while (*s) {
        putc(*s++);
    }
}

// 整数转换为字符串 (保持不变)
static void print_int(int val, int base) {
    char buf[20];
    char *s = buf + sizeof(buf) - 1;
    *s = '\0';
    unsigned int uval = (base == 10 && val < 0) ? -val : val;

    if (uval == 0) {
        s--;
        *s = '0';
    } else {
        while (uval > 0) {
            s--;
            *s = "0123456789ABCDEF"[uval % base];
            uval /= base;
        }
    }

    if (base == 10 && val < 0) {
        s--;
        *s = '-';
    }
    
    puts(s);
}

// 核心 vprintf 实现，供所有 printf 变体调用
static void vprintf_internal(const char *fmt, va_list args) {
    const char *p;
    for (p = fmt; *p; p++) {
        if (*p == '%') {
            p++;
            switch (*p) {
                case 's':
                    puts(va_arg(args, const char *));
                    break;
                case 'd':
                    print_int(va_arg(args, int), 10);
                    break;
                case 'x':
                    print_int(va_arg(args, int), 16);
                    break;
                case 'c':
                    putc(va_arg(args, int));
                    break;
                case '%':
                    putc('%');
                    break;
                default:
                    // 打印未识别的格式符
                    putc('%');
                    putc(*p);
                    break;
            }
        } else {
            putc(*p);
        }
    }
}

// 完整的 printf 函数，作为 vprintf_internal 的包装器
int printf(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    vprintf_internal(fmt, args);
    va_end(args);
    return 0; // 简化处理
}

// 清屏功能实现，利用 ANSI 转义序列
void clear_screen() {
    // 清空整个屏幕，并将光标移动到左上角
    printf("\033[2J\033[H");
}

// 将光标移动到 (x, y) 坐标 (1-based index)
void goto_xy(int x, int y) {
    printf("\033[%d;%dH", y, x);
}

// 清空当前光标所在的行
void clear_line() {
    printf("\033[2K");
}

// 带颜色的 printf
void printf_color(term_color_t color, const char *fmt, ...) {
    va_list args;
    
    // 设置颜色
    printf("\033[%dm", color);
    
    // 打印内容
    va_start(args, fmt);
    vprintf_internal(fmt, args);
    va_end(args);
    
    // 恢复默认颜色
    printf("\033[%dm", COLOR_RESET);
}