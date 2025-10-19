/* kernel.ld - 简化版内核链接脚本 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
    . = 0x80000000;         /* 内核起始地址 */

    .text : {
        *(.text .text.*)
    }

    .rodata : {
        *(.rodata .rodata.*)
    }

    .data : {
        *(.data .data.*)
    }

    .bss : {
        _sbss = .;          /* BSS段起始符号 */
        *(.bss .bss.*)
        _ebss = .;          /* BSS段结束符号 */
    }

    . = ALIGN(16);
    stack_top = .;          /* 栈顶符号，供汇编使用 */
    . = . + 16384;           /* 分配16KB栈空间 */
    stack_bottom = .;

    /* 结尾对齐 */
    . = ALIGN(16);
}