.section .text.entry
.globl _start
_start:
    /* 设置栈指针 sp */
    la sp, stack_top
    
    /* 清零 .bss 段 */
    /* _bss_start 和 _bss_end 由链接脚本 kernel.ld 定义 */
    la a0, _bss_start
    la a1, _bss_end
    sub a1, a1, a0

.L_clear_bss_loop:
    beq a1, zero, .L_clear_bss_done
    sb zero, (a0)
    addi a0, a0, 1
    addi a1, a1, -1
    j .L_clear_bss_loop

.L_clear_bss_done:
    /* 跳转到 C 语言的 main 函数 */
    call main

/* 如果 main 函数返回, 则进入死循环 */
loop:
    j loop