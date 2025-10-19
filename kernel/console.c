#include "uart.h"

void console_putc(char c) {
    uart_putc(c);
}

void clear_screen(void) {
    uart_puts("\033[2J\033[H");
}

// 简单itoa实现，仅支持0-99
static void itoa2(int val, char *buf) {
    if (val >= 10) {
        *buf++ = '0' + (val / 10);
    }
    *buf++ = '0' + (val % 10);
    *buf = 0;
}

void goto_xy(int x, int y) {
    char buf[16];
    char *p = buf;
    *p++ = '\033';
    *p++ = '[';
    itoa2(y, p); while (*p) p++;
    *p++ = ';';
    itoa2(x, p); while (*p) p++;
    *p++ = 'H';
    *p = 0;
    uart_puts(buf);
}

void clear_line(void) {
    uart_puts("\033[K");
}
