#include "uart.h"
#include <stdarg.h>
#include <stdint.h>

// 数字转字符表
static const char digits[] = "0123456789ABCDEF";

// 错误处理状态码
typedef enum {
    PRINTF_OK = 0,
    PRINTF_ERROR_NULL_POINTER = -1,
    PRINTF_ERROR_INVALID_FORMAT = -2,
} printf_status_t;

// 数字转换缓冲区大小
#define NUM_BUF_SIZE 32

static void print_number(int num, int base, int sign) {
    char buf[NUM_BUF_SIZE];
    int i = NUM_BUF_SIZE - 1;
    int negative = 0;
    unsigned int n;

    // 处理base参数错误的情况
    if(base < 2 || base > 16) {
        uart_puts("Invalid base\n");
        return;
    }

    // 处理0的特殊情况
    if(num == 0) {
        uart_putc('0');
        return;
    }

    // 处理负数
    if(sign && num < 0) {
        negative = 1;
        // 特殊处理INT_MIN
        if(num == -2147483648) {
            n = 2147483648U;
        } else {
            n = -num;
        }
    } else {
        n = num;
    }

    // 转换数字到字符
    buf[i] = '\0';  // 字符串结束符
    while(n) {
        i--;
        buf[i] = digits[n % base];
        n /= base;
    }

    // 添加负号
    if(negative) {
        i--;
        buf[i] = '-';
    }

    // 输出结果
    while(buf[i]) {
        uart_putc(buf[i++]);
    }
}

static void print_number_long(long num, int base, int sign) {
    char buf[NUM_BUF_SIZE];
    int i = NUM_BUF_SIZE - 1;
    int negative = 0;
    unsigned long n;

    // 处理base参数错误的情况
    if(base < 2 || base > 16) {
        uart_puts("Invalid base\n");
        return;
    }

    // 处理0的特殊情况
    if(num == 0) {
        uart_putc('0');
        return;
    }

    // 处理负数
    if(sign && num < 0) {
        negative = 1;
        n = -num;
    } else {
        n = num;
    }

    // 转换数字到字符
    buf[i] = '\0';  // 字符串结束符
    while(n) {
        i--;
        buf[i] = digits[n % base];
        n /= base;
    }

    // 添加负号
    if(negative) {
        i--;
        buf[i] = '-';
    }

    // 输出结果
    while(buf[i]) {
        uart_putc(buf[i++]);
    }
}

// 输出字符串
static void print_string(const char *s) {
    if (!s) {
        uart_puts("(null)");
        return;
    }
    while (*s) {
        uart_putc(*s++);
    }
}

// 清屏函数 - 使用ANSI转义序列清除屏幕
void clear_screen(void) {
    // \033[2J - 清除整个屏幕
    // \033[H - 光标回到左上角
    uart_puts("\033[2J\033[H");
}

// 清除当前行
void clear_line(void) {
    // \033[K - 清除从光标位置到行尾的内容
    uart_puts("\033[K");
}

// 光标定位到指定位置
void goto_xy(int x, int y) {
    // ANSI转义序列格式: \033[y;xH
    // 手动构造转义序列，避免使用printf函数
    uart_putc(0x1B);  // ESC字符
    uart_putc('[');
    
    // 输出y坐标 (行)
    if (y >= 100) {
        uart_putc('0' + (y / 100));
        uart_putc('0' + ((y % 100) / 10));
        uart_putc('0' + (y % 10));
    } else if (y >= 10) {
        uart_putc('0' + (y / 10));
        uart_putc('0' + (y % 10));
    } else if (y > 0) {
        uart_putc('0' + y);
    } else {
        uart_putc('1'); // 最小值为1
    }
    
    uart_putc(';');
    
    // 输出x坐标 (列)
    if (x >= 100) {
        uart_putc('0' + (x / 100));
        uart_putc('0' + ((x % 100) / 10));
        uart_putc('0' + (x % 10));
    } else if (x >= 10) {
        uart_putc('0' + (x / 10));
        uart_putc('0' + (x % 10));
    } else if (x > 0) {
        uart_putc('0' + x);
    } else {
        uart_putc('1'); // 最小值为1
    }
    
    uart_putc('H');
}

// 带颜色输出的printf函数
int printf_color(color_t color, const char *fmt, ...) {
    va_list ap;
    const char *s;
    int status = PRINTF_OK;
    
    // 设置前景色
    uart_putc('\033');
    uart_putc('[');
    
    // 输出颜色代码
    if (color >= 100) {
        uart_putc('0' + (color / 100));
        uart_putc('0' + ((color % 100) / 10));
        uart_putc('0' + (color % 10));
    } else if (color >= 10) {
        uart_putc('0' + (color / 10));
        uart_putc('0' + (color % 10));
    } else {
        uart_putc('0' + color);
    }
    
    uart_putc('m');
    
    if (!fmt) {
        return PRINTF_ERROR_NULL_POINTER;
    }

    va_start(ap, fmt);

    for (s = fmt; *s; s++) {
        if (*s != '%') {
            uart_putc(*s);
            continue;
        }

        // 处理格式化标记
        s++;
        if (!*s) {  // 字符串末尾出现单个%
            uart_putc('%');
            break;
        }

        switch (*s) {
            case 'd':  // 十进制整数
                print_number(va_arg(ap, int), 10, 1);
                break;

            case 'x':  // 十六进制整数
            case 'X':
                print_number(va_arg(ap, int), 16, 0);
                break;

            case 's':  // 字符串
                print_string(va_arg(ap, const char *));
                break;

            case 'c':  // 字符
                uart_putc(va_arg(ap, int));
                break;

            case '%':  // 百分号
                uart_putc('%');
                break;

            default:  // 未知格式符
                uart_putc('%');
                uart_putc(*s);
                status = PRINTF_ERROR_INVALID_FORMAT;
                break;
        }
    }

    va_end(ap);
    
    // 重置颜色
    uart_puts("\033[0m");
    
    return status;
}

int printf(const char *fmt, ...) {
    va_list ap;
    const char *s;
    int status = PRINTF_OK;

    if (!fmt) {
        return PRINTF_ERROR_NULL_POINTER;
    }

    va_start(ap, fmt);

    for (s = fmt; *s; s++) {
        if (*s != '%') {
            uart_putc(*s);
            continue;
        }

        // 处理格式化标记
        s++;
        if (!*s) {  // 字符串末尾出现单个%
            uart_putc('%');
            break;
        }

        // 检查长整型修饰符
        int is_long = 0;
        if (*s == 'l') {
            is_long = 1;
            s++;
            if (!*s) {
                uart_putc('%');
                uart_putc('l');
                break;
            }
        }

        switch (*s) {
            case 'd':  // 十进制整数
                if (is_long) {
                    print_number_long(va_arg(ap, long), 10, 1);
                } else {
                    print_number(va_arg(ap, int), 10, 1);
                }
                break;

            case 'x':  // 十六进制整数
            case 'X':
                if (is_long) {
                    print_number_long(va_arg(ap, long), 16, 0);
                } else {
                    print_number(va_arg(ap, int), 16, 0);
                }
                break;

            case 's':  // 字符串
                print_string(va_arg(ap, const char *));
                break;

            case 'c':  // 字符
                uart_putc(va_arg(ap, int));
                break;

            case '%':  // 百分号
                uart_putc('%');
                break;

            default:  // 未知格式符
                uart_putc('%');
                if (is_long) {
                    uart_putc('l');
                }
                uart_putc(*s);
                status = PRINTF_ERROR_INVALID_FORMAT;
                break;
        }
    }

    va_end(ap);
    return status;
}

// 基础测试用例
void test_printf_basic(void) {
    printf("Testing integer: %d\n", 42);
    printf("Testing negative: %d\n", -123);
    printf("Testing zero: %d\n", 0);
    printf("Testing hex: 0x%x\n", 0xABC);
    printf("Testing string: %s\n", "Hello");
    printf("Testing char: %c\n", 'X');
    printf("Testing percent: %%\n");
}

// 边界情况测试用例
void test_printf_edge_cases(void) {
    printf("INT_MAX: %d\n", 2147483647);
    printf("INT_MIN: %d\n", -2147483648);
    printf("NULL string: %s\n", (char*)0);
    printf("Empty string: %s\n", "");
    printf("Bad format: %z\n");
    printf("Truncated format: %");
}