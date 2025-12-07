#ifndef SYSCALL_H
#define SYSCALL_H
#define __user
#include "defs.h"

// 系统调用描述符
struct syscall_desc {
    int (*func)(void);  // 实现函数
    char *name;         // 系统调用名称
    int arg_count;      // 参数个数
};

// 系统调用表
extern struct syscall_desc syscall_table[];

// 系统调用分发器
void syscall_dispatch(void);

// 参数获取辅助函数
int get_syscall_arg(int n, long *arg);
int get_user_string(const char __user *str, char *buf, int max);
int get_user_buffer(const void __user *ptr, void *buf, int size);

#endif
