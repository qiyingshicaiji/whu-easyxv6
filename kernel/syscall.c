#include "defs.h"
#include "proc.h"
#include "trap.h"
#include "uart.h"
#include "syscall.h"
#include "fs.h"

#define MAX_SYSCALLS 64
// 系统调用表
extern struct syscall_desc syscall_table[];

// 从用户空间获取参数
// 提取系统调用参数
int get_syscall_arg(int n, long *arg) {
    struct proc *p = myproc();
    if (!p || !p->trapframe) return -1;
    switch (n) {
    case 0: *arg = p->trapframe->a0; return 0;
    case 1: *arg = p->trapframe->a1; return 0;
    case 2: *arg = p->trapframe->a2; return 0;
    case 3: *arg = p->trapframe->a3; return 0;
    case 4: *arg = p->trapframe->a4; return 0;
    case 5: *arg = p->trapframe->a5; return 0;
    default: return -1;
    }
}

// 从用户空间获取字符串
// 简单用户字符串拷贝
int get_user_string(const char __user *str, char *buf, int max) {
    if (!str || !buf || max <= 0) return -1;
    if (check_user_ptr((const void *)str, 1) < 0) return -1;
    int i = 0;
    const char *p = (const char *)str;
    for (; i < max - 1; i++) {
        char c = p[i];
        buf[i] = c;
        if (c == '\0') break;
    }
    buf[i < max ? i : max - 1] = '\0';
    return 0;
}

// 从用户空间获取缓冲区
// 简单用户缓冲区拷贝
int get_user_buffer(const void __user *ptr, void *buf, int size) {
    if (!ptr || !buf || size <= 0) return -1;
    if (check_user_ptr((const void *)ptr, size) < 0) return -1;
    const char *src = (const char *)ptr;
    char *dst = (char *)buf;
    for (int i = 0; i < size; i++) dst[i] = src[i];
    return 0;
}

// 检查用户指针是否有效
int check_user_ptr(const void *ptr, int size) {
    struct proc *p = myproc();
    uint64 start = (uint64)ptr;
    uint64 end = start + size;

    // 检查指针是否在用户地址空间范围内
    if (start >= p->sz || end > p->sz || start >= end) {
        return -1;
    }

    // 检查指针是否具有相应权限（示例：只读或可写）
    // 此处可以扩展权限检查逻辑

    return 0;
}

// 系统调用分发器
void syscall_dispatch(void) {
    struct proc *p = myproc();
    int syscall_num = p->trapframe->a7;  // 系统调用编号

    if (syscall_num < 0 || syscall_num >= MAX_SYSCALLS) {
        uart_puts("无效的系统调用编号\n");
        p->trapframe->a0 = -1;  // 返回错误码
        return;
    }

    struct syscall_desc *desc = &syscall_table[syscall_num];
    uart_puts("执行系统调用: ");
    uart_puts(desc->name);
    uart_puts("\n");

    // 调用系统调用函数
    p->trapframe->a0 = desc->func();
}

// 只实现getpid和write
int sys_getpid(void) {
    struct proc *p = myproc();
    if (!p) return -1;
    return p->pid;
}

int sys_write(void) {
    int fd;
    char *buf;
    int count;
    if (get_syscall_arg(0, (long *)&fd) < 0 ||
        get_syscall_arg(1, (long *)&buf) < 0 ||
        get_syscall_arg(2, (long *)&count) < 0) {
        return -1;
    }
    if (fd < 0 || count < 0) return -1;
    if (count == 0) return 0;
    char tmp[256];
    int n = count;
    if (n > (int)sizeof(tmp)) n = (int)sizeof(tmp);
    if (get_user_buffer(buf, tmp, n) < 0) return -1;
    // fd 1/2 -> console; other fds -> filesystem
    if (fd == 1 || fd == 2) {
        for (int i = 0; i < n; i++) uart_putc(tmp[i]);
        return n;
    }
    return fs_write(fd, tmp, n);
}

// new filesystem syscalls
int sys_open(void) {
    char *path;
    int flags;
    if (get_syscall_arg(0, (long *)&path) < 0 ||
        get_syscall_arg(1, (long *)&flags) < 0) return -1;
    char buf[128];
    if (get_user_string((const char __user*)path, buf, sizeof(buf)) < 0) return -1;
    int create = (flags & 1) ? 1 : 0; // simple: bit0 indicates create
    return fs_open(buf, create);
}

int sys_close(void) {
    int fd;
    if (get_syscall_arg(0, (long *)&fd) < 0) return -1;
    return fs_close(fd);
}

int sys_read(void) {
    int fd; void *ubuf; int n;
    if (get_syscall_arg(0, (long *)&fd) < 0 ||
        get_syscall_arg(1, (long *)&ubuf) < 0 ||
        get_syscall_arg(2, (long *)&n) < 0) return -1;
    if (n <= 0) return 0;
    char kbuf[256];
    int m = n; if (m > (int)sizeof(kbuf)) m = (int)sizeof(kbuf);
    int r = fs_read(fd, kbuf, m);
    if (r <= 0) return r;
    // copy back to user
    char *dst = (char*)ubuf;
    for (int i=0;i<r;i++) dst[i] = kbuf[i];
    return r;
}

int sys_unlink(void) {
    char *path;
    if (get_syscall_arg(0, (long *)&path) < 0) return -1;
    char buf[128];
    if (get_user_string((const char __user*)path, buf, sizeof(buf)) < 0) return -1;
    return fs_unlink(buf);
}

// 更新系统调用表
struct syscall_desc syscall_table[] = {
    {sys_getpid, "sys_getpid", 0},    // 0
    {sys_write,  "sys_write",  3},    // 1
    {sys_open,   "sys_open",   2},    // 2
    {sys_close,  "sys_close",  1},    // 3
    {sys_read,   "sys_read",   3},    // 4
    {sys_unlink, "sys_unlink", 1},    // 5
};
