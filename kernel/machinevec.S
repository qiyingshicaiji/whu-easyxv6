# Machine mode interrupt vector
# Handles interrupts that occur in Machine mode.

.section .text
.align 4
.global machinevec
.type machinevec, @function

machinevec:
    # This is the machine-mode interrupt handler.
    # It needs to save the full context of the interrupted code
    # before calling a C function, and restore it afterward.

    # 1. Allocate space on the stack for 31 general-purpose registers (x1-x31).
    #    x0 is hardwired to zero and doesn't need saving.
    #    We save 31 * 8 = 248 bytes.
    addi sp, sp, -248

    # 2. Save all general-purpose registers.
    sd ra, 0(sp)    # x1
    # sd sp, 8(sp)  # We save the original sp later
    sd gp, 16(sp)   # x3
    sd tp, 24(sp)   # x4
    sd t0, 32(sp)   # x5
    sd t1, 40(sp)   # x6
    sd t2, 48(sp)   # x7
    sd s0, 56(sp)   # x8
    sd s1, 64(sp)   # x9
    sd a0, 72(sp)   # x10
    sd a1, 80(sp)   # x11
    sd a2, 88(sp)   # x12
    sd a3, 96(sp)   # x13
    sd a4, 104(sp)  # x14
    sd a5, 112(sp)  # x15
    sd a6, 120(sp)  # x16
    sd a7, 128(sp)  # x17
    sd s2, 136(sp)  # x18
    sd s3, 144(sp)  # x19
    sd s4, 152(sp)  # x20
    sd s5, 160(sp)  # x21
    sd s6, 168(sp)  # x22
    sd s7, 176(sp)  # x23
    sd s8, 184(sp)  # x24
    sd s9, 192(sp)  # x25
    sd s10, 200(sp) # x26
    sd s11, 208(sp) # x27
    sd t3, 216(sp)  # x28
    sd t4, 224(sp)  # x29
    sd t5, 232(sp)  # x30
    sd t6, 240(sp)  # x31

    # Save the original stack pointer (sp).
    # sp was adjusted, so we read the original value and save it.
    addi t0, sp, 248
    sd t0, 8(sp)    # x2

    # 3. Check the cause of the interrupt.
    csrr a0, mcause

    # Check if it's a machine timer interrupt (cause = 7).
    # The high bit is 1 for interrupts, 0 for exceptions.
    # Machine timer interrupt code is 7. So mcause is 0x8000000000000007.
    li t0, 0x8000000000000007
    bne a0, t0, not_timer_interrupt

# machine_timer_interrupt:
    # Call the C handler for the timer interrupt.
    call machine_timer_handler
    j interrupt_return

not_timer_interrupt:
    # Handle other interrupts or exceptions if necessary.
    # For now, we just return.
    # You can add debug prints here.

interrupt_return:
    # 4. Restore all general-purpose registers from the stack.
    ld ra, 0(sp)
    # ld sp, 8(sp) # sp is restored last
    ld gp, 16(sp)
    ld tp, 24(sp)
    ld t0, 32(sp)
    ld t1, 40(sp)
    ld t2, 48(sp)
    ld s0, 56(sp)
    ld s1, 64(sp)
    ld a0, 72(sp)
    ld a1, 80(sp)
    ld a2, 88(sp)
    ld a3, 96(sp)
    ld a4, 104(sp)
    ld a5, 112(sp)
    ld a6, 120(sp)
    ld a7, 128(sp)
    ld s2, 136(sp)
    ld s3, 144(sp)
    ld s4, 152(sp)
    ld s5, 160(sp)
    ld s6, 168(sp)
    ld s7, 176(sp)
    ld s8, 184(sp)
    ld s9, 192(sp)
    ld s10, 200(sp)
    ld s11, 208(sp)
    ld t3, 216(sp)
    ld t4, 224(sp)
    ld t5, 232(sp)
    ld t6, 240(sp)

    # Restore the original stack pointer.
    ld sp, 8(sp)

    # 5. Return from interrupt.
    mret

.end
