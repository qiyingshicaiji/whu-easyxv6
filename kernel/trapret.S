.section .text
.align 4
.globl trapret
.type trapret, @function

# Minimal trap return stub: does not yet restore full trapframe.
# It switches to the provided pagetable and executes sret to return.
# Arguments (per RISC-V ABI):
# a0 = struct trapframe* (ignored here)
# a1 = pagetable_t (satp value must be constructed elsewhere)
trapret:
    # Expect a1 to already contain a properly constructed satp value
    mv t0, a1
    csrw satp, t0
    sfence.vma
    # For now, just sret; your usertrap should have set sepc/sstatus
    sret