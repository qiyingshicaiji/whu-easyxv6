# uservec.S - RISC-V用户态中断向量入口
# 参考xv6的uservec.S和trampoline.S
# 当CPU在用户态（用户模式）执行时发生中断或异常，跳转到这里
# 这个入口点通常映射到用户进程的虚拟地址空间中

.section .text
.align 4
.global uservec
.type uservec, @function

uservec:
    # 用户态中断处理流程:
    # 1. 在用户空间中，我们不能直接使用内核栈
    # 2. 需要切换到内核栈
    # 3. 使用sscratch寄存器来存储用户进程的信息
    
    # 在用户模式下发生陷阱时:
    # - sstatus被保存
    # - sepc指向被中断的指令
    # - scause表示中断/异常原因
    # - sscratch由内核设置为指向内核数据的指针
    
    # sscratch约定: 指向当前进程的struct proc指针
    # 从中可以获取内核栈指针和陷阱帧
    
    # 第一步: 切换到内核栈
    # 保存用户sp到t0 (临时寄存器)
    mv t0, sp
    
    # 从sscratch加载内核栈指针或proc指针
    # csrr sp, sscratch  # 现在sp指向内核区域
    # 但我们需要先设置好sscratch，这在内核代码中进行
    
    # 简化实现: 使用全局内核栈
    # 实际xv6中，每个CPU有一个中断栈
    
    # 由于简化的实现，我们无法在这里直接处理
    # 用户态陷阱的完整处理需要:
    # 1. 每个进程有自己的内核栈
    # 2. 通过sscratch指向进程结构
    # 3. 从进程结构获取内核栈指针
    
    # 对于当前实现，我们使用一个全局数组来保存用户态陷阱帧
    
    # 保存用户态的所有寄存器到临时位置
    # 使用全局trapframe_buffer (在trap.c中定义)
    
    # 简化实现：直接在栈上分配空间
    # 注意：实际实现需要在内核初始化时设置sscratch寄存器
    addi sp, sp, -272  # 分配trapframe空间
    
    # 保存用户寄存器
    sd t0, 16(sp)      # 保存用户的原始sp
    sd x1, 8(sp)       # ra
    sd x3, 24(sp)      # gp
    sd x4, 32(sp)      # tp
    sd x5, 40(sp)      # t0
    sd x6, 48(sp)      # t1
    sd x7, 56(sp)      # t2
    sd x8, 64(sp)      # s0
    sd x9, 72(sp)      # s1
    sd x10, 80(sp)     # a0
    sd x11, 88(sp)     # a1
    sd x12, 96(sp)     # a2
    sd x13, 104(sp)    # a3
    sd x14, 112(sp)    # a4
    sd x15, 120(sp)    # a5
    sd x16, 128(sp)    # a6
    sd x17, 136(sp)    # a7
    sd x18, 144(sp)    # s2
    sd x19, 152(sp)    # s3
    sd x20, 160(sp)    # s4
    sd x21, 168(sp)    # s5
    sd x22, 176(sp)    # s6
    sd x23, 184(sp)    # s7
    sd x24, 192(sp)    # s8
    sd x25, 200(sp)    # s9
    sd x26, 208(sp)    # s10
    sd x27, 216(sp)    # s11
    sd x28, 224(sp)    # t3
    sd x29, 232(sp)    # t4
    sd x30, 240(sp)    # t5
    sd x31, 248(sp)    # t6
    
    # 保存CSR
    csrr t1, sstatus
    sd t1, 256(sp)     # sstatus
    
    csrr t1, sepc
    sd t1, 264(sp)     # sepc
    
    # 调用C处理函数
    call usertrap
    
    # 从usertrap返回后，恢复用户上下文
    ld x1, 8(sp)       # ra
    ld x3, 24(sp)      # gp
    ld x4, 32(sp)      # tp
    ld x5, 40(sp)      # t0
    ld x6, 48(sp)      # t1
    ld x7, 56(sp)      # t2
    ld x8, 64(sp)      # s0
    ld x9, 72(sp)      # s1
    ld x10, 80(sp)     # a0
    ld x11, 88(sp)     # a1
    ld x12, 96(sp)     # a2
    ld x13, 104(sp)    # a3
    ld x14, 112(sp)    # a4
    ld x15, 120(sp)    # a5
    ld x16, 128(sp)    # a6
    ld x17, 136(sp)    # a7
    ld x18, 144(sp)    # s2
    ld x19, 152(sp)    # s3
    ld x20, 160(sp)    # s4
    ld x21, 168(sp)    # s5
    ld x22, 176(sp)    # s6
    ld x23, 184(sp)    # s7
    ld x24, 192(sp)    # s8
    ld x25, 200(sp)    # s9
    ld x26, 208(sp)    # s10
    ld x27, 216(sp)    # s11
    ld x28, 224(sp)    # t3
    ld x29, 232(sp)    # t4
    ld x30, 240(sp)    # t5
    ld x31, 248(sp)    # t6
    
    # 恢复CSR
    ld t1, 256(sp)     # sstatus
    csrw sstatus, t1
    
    ld t1, 264(sp)     # sepc
    csrw sepc, t1
    
    # 恢复用户sp
    ld x2, 16(sp)      # sp
    
    # 清理栈
    # 由于我们即将使用sret跳回用户空间，sp已经恢复
    # 所以不需要显式调整
    
    # 返回到用户态
    sret
