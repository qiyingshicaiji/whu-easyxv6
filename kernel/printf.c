#include "uart.h"
#include "console.h"
#include <stdarg.h>


// 数字转换与输出核心算法
static void print_number(int num, int base, int sign) {
    char buf[32];
    int i = 0;
    unsigned int n;

    if (sign && num < 0) {
        n = (unsigned int)(-(long long)num);
    } else {
        n = (unsigned int)num;
    }

    if (n == 0) {
        buf[i++] = '0';
    } else {
        while (n != 0 && i < sizeof(buf) - 2) {  // 添加边界检查
            int digit = n % base;
            buf[i++] = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
            n /= base;
        }
    }

    if (sign && num < 0 && i < sizeof(buf) - 1) {  // 添加边界检查
        buf[i++] = '-';
    }

    while (--i >= 0) {
        console_putc(buf[i]);
    }
}

int printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    char c;
    for (; (c = *fmt) != 0; fmt++) {
        if (c != '%') {
            console_putc(c);
            continue;
        }
        fmt++;
        c = *fmt;
        if (c == 0) break;
        switch (c) {
        case 'd': {
            int val = va_arg(ap, int);
            print_number(val, 10, 1);
            break;
        }
        case 'x': {
            int val = va_arg(ap, int);
            print_number(val, 16, 0);
            break;
        }
        case 's': {
            const char *s = va_arg(ap, const char *);
            if (!s) s = "(null)";
            for (; *s; s++) console_putc(*s);
            break;
        }
        case 'c': {
            char ch = (char)va_arg(ap, int);
            console_putc(ch);
            break;
        }
        case '%':
            console_putc('%');
            break;
        default:
            console_putc('%');
            console_putc(c);
            break;
        }
    }
    va_end(ap);
    return 0;
}

void test_printf_basic() {
    printf("Testing integer: %d\n", 42);
    printf("Testing negative: %d\n", -123);
    printf("Testing zero: %d\n", 0);
    printf("Testing hex: 0x%x\n", 0xABC);
    printf("Testing string: %s\n", "Hello");
    printf("Testing char: %c\n", 'X');
    printf("Testing percent: %%\n");
}

void test_printf_edge_cases() {
    printf("INT_MAX: %d\n", 2147483647);
    printf("INT_MIN: %d\n", -2147483648);
    printf("NULL string: %s\n", (char*)0);
    printf("Empty string: %s\n", "");
}
