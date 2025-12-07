#ifndef SYSCALL_TEST_H
#define SYSCALL_TEST_H
#define ENABLE_TEST 0

#include "syscall.h"
#include <stdio.h>
#include <string.h>

// 根据标志条件声明函数
void test_basic_syscalls(void);
void test_parameter_passing(void);
void test_security(void);
void test_syscall_performance(void);
void run_syscalls(void);

#endif
