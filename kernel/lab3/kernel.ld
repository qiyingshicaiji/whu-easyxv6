/* 链接器脚本 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

/* 定义QEMU virt平台的内存布局 */
BASE_ADDRESS = 0x80000000;

SECTIONS {
    . = BASE_ADDRESS;

    .text : {
        _text_start = .;
        *(.text.entry)
        *(.text)
        . = ALIGN(4K);
        _text_end = .;
    }

    /* 在代码段结束后定义 etext 符号 */
    PROVIDE(etext = .); 

    .rodata : {
        _rodata_start = .;
        *(.rodata)
        . = ALIGN(4K);
        _rodata_end = .;
    }

    .data : {
        _data_start = .;
        *(.data)
        . = ALIGN(4K);
        _data_end = .;
    }

    .bss : {
        _bss_start = .;
        *(.bss)
        . = ALIGN(4K);
        _bss_end = .;
    }

    /* 定义栈，并将其放在BSS段之后 */
    . = ALIGN(16);
    .stack : {
        . = . + 4K; /* 预留 4KB 栈空间 */
        stack_top = .;
    }

    PROVIDE(end = .); /* 定义整个内核映像的结束点 */
}