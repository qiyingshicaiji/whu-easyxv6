
#include "syscall.h"

// 简单整数转字符串（十进制，正数）
void itoa(int n, char *buf) {
    char tmp[16];
    int i = 0, j = 0;
    if (n == 0) {
        buf[0] = '0'; buf[1] = '\n'; buf[2] = 0; return;
    }
    if (n < 0) {
        buf[j++] = '-'; n = -n;
    }
    while (n > 0) { tmp[i++] = (n % 10) + '0'; n /= 10; }
    while (i > 0) buf[j++] = tmp[--i];
    buf[j++] = '\n'; buf[j] = 0;
}

int main() {
        write(1, "[user] test_syscalls.c 用户态测试程序已启动\n", 44);
    int pid = getpid();
    write(1, "[user] getpid returned: ", 24);
    char buf[32];
    itoa(pid, buf);
    // 输出pid字符串
    int len = 0; while (buf[len] && buf[len] != 0) ++len;
    write(1, buf, len);

    // 测试write到标准输出
    const char *msg = "[user] write to stdout\n";
    write(1, msg, 23);

    // 测试write到标准错误
    const char *errmsg = "[user] write to stderr\n";
    write(2, errmsg, 23);

    // 测试write空字符串
    write(1, "", 0);

    // 测试write长字符串
    char longstr[128];
    for (int i = 0; i < 127; ++i) longstr[i] = 'A' + (i % 26);
    longstr[127] = '\0';
    write(1, longstr, 127);

    // 测试无效fd
    write(-1, "[user] invalid fd\n", 18);

    // 你可以继续添加open/close/read等系统调用测试
    return 0;
}
