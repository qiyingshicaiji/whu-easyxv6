.global _start
_start:
    # UART基地址
    li t0, 0x10000000

    # 输出字符'S'表示启动
    li t1, 'S'
    sb t1, 0(t0)

    # 设置栈指针
    la sp, stack_top

    # 输出字符'P'表示栈设置完成
    li t1, 'P'
    sb t1, 0(t0)

    # 清零BSS段
    la t0, _sbss
    la t1, _ebss
    li t2, 0
clear_bss:
    beq t0, t1, bss_cleared
    sd t2, 0(t0)
    add t0, t0, 8
    j clear_bss
bss_cleared:

    # 跳转到C主函数
    jal ra, main

halt_loop:
    j halt_loop