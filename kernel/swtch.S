

.section .text
.align 4
.global switch_context
.type switch_context, @function

# void switch_context(struct context *old, struct context *new)
# a0 = old context pointer
# a1 = new context pointer

switch_context:
    
    # 保存ra (返回地址)
    sd x1, 0(a0)
    
    # 保存sp (栈指针)
    sd x2, 8(a0)
    
    # 保存被调用者保存的寄存器 (s0-s11)
    sd x8, 16(a0)      # s0
    sd x9, 24(a0)      # s1
    sd x18, 32(a0)     # s2
    sd x19, 40(a0)     # s3
    sd x20, 48(a0)     # s4
    sd x21, 56(a0)     # s5
    sd x22, 64(a0)     # s6
    sd x23, 72(a0)     # s7
    sd x24, 80(a0)     # s8
    sd x25, 88(a0)     # s9
    sd x26, 96(a0)     # s10
    sd x27, 104(a0)    # s11
    
    # 从new上下文中恢复被调用者保存的寄存器
    # 按相反的顺序恢复
    
    ld x1, 0(a1)       # 恢复ra
    ld x2, 8(a1)       # 恢复sp
    ld x8, 16(a1)      # 恢复s0
    ld x9, 24(a1)      # 恢复s1
    ld x18, 32(a1)     # 恢复s2
    ld x19, 40(a1)     # 恢复s3
    ld x20, 48(a1)     # 恢复s4
    ld x21, 56(a1)     # 恢复s5
    ld x22, 64(a1)     # 恢复s6
    ld x23, 72(a1)     # 恢复s7
    ld x24, 80(a1)     # 恢复s8
    ld x25, 88(a1)     # 恢复s9
    ld x26, 96(a1)     # 恢复s10
    ld x27, 104(a1)    # 恢复s11
    
    # 返回到new上下文的返回地址
    # 现在x1 (ra)已经恢复为new进程的返回地址
    ret
