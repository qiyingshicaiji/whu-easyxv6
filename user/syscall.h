#ifndef USER_SYSCALL_H
#define USER_SYSCALL_H

#include <stdint.h>

// 用户态系统调用声明
int getpid(void);
int write(int fd, const void *buf, int count);
int open(const char *path, int flags);
int close(int fd);
int read(int fd, void *buf, int count);
int unlink(const char *path);

#endif
