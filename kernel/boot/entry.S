# 启动代码入口
.section .text
.global _entry
_entry:
    # 在启动时发送字符'S'作为调试标记
    li t0, 0x10000000    
    li t1, 'S'           
    sb t1, 0(t0)         

    # 设置栈指针
    la sp, stack_top     # 加载栈顶地址
    
    # 发送字符'P'表示栈设置完成
    li t1, 'P'           
    sb t1, 0(t0)         

    # ============================================================
    # Machine模式初始化 - 时间中断配置
    # ============================================================
    
    # 设置 Machine 模式中断向量
    la t0, machinevec
    csrw mtvec, t0
    
    # 启用 Machine 模式时钟中断
    li t0, 0x80
    csrw mie, t0              # MIE_MTIE = 1 << 7
    
    # 设置第一个时间中断
    # 读取当前 mtime
    li t0, 0x2000BFF8         # mtime 地址
    ld t1, 0(t0)              # 读取 mtime
    
    # 计算下一个中断时间 (mtime + 1000000)
    li t2, 1000000
    add t3, t1, t2
    
    # 写入 mtimecmp
    li t4, 0x2004000          # mtimecmp 地址
    sd t3, 0(t4)              # 设置 mtimecmp
    
    # 启用全局中断
    li t0, 0x8                # MSTATUS_MIE = 1 << 3
    csrw mstatus, t0

    # 清零BSS段
    la t0, bss_start     # BSS段起始地址
    la t1, bss_end       # BSS段结束地址
bss_clear:
    beq t0, t1, bss_done # 如果已经清零完成，跳转
    sd zero, (t0)        # 清零8字节
    addi t0, t0, 8       # 移动到下一个8字节
    j bss_clear          # 继续循环
bss_done:

    # 跳转到C代码
    call main            # 调用C主函数

    # 如果main返回，进入死循环
loop:
    j loop

# 定义栈空间
.section .bss
.align 16
stack_bottom:
    .skip 4096          # 分配4KB栈空间
stack_top:
