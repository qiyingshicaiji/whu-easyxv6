#include "syscall.h"

#define SYS_getpid 0
#define SYS_write  1
#define SYS_open   2
#define SYS_close  3
#define SYS_read   4
#define SYS_unlink 5

static inline int syscall(int num, ...) {
    int ret;
    asm volatile (
        "mv a7, %1\n"
        "ecall\n"
        "mv %0, a0\n"
        : "=r" (ret)
        : "r" (num)
        : "memory", "a7", "a0"
    );
    return ret;
}

int getpid(void) {
    return syscall(SYS_getpid);
}

int write(int fd, const void *buf, int count) {
    return syscall(SYS_write, fd, buf, count);
}

int open(const char *path, int flags) {
    return syscall(SYS_open, path, flags);
}

int close(int fd) {
    return syscall(SYS_close, fd);
}

int read(int fd, void *buf, int count) {
    return syscall(SYS_read, fd, buf, count);
}

int unlink(const char *path) {
    return syscall(SYS_unlink, path);
}
