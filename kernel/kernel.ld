OUTPUT_ARCH( "riscv" )
ENTRY( _entry )

SECTIONS
{
  /* 代码段起始于QEMU RISC-V virt机器的ROM地址 */
  . = 0x80000000;

  .text : {
    PROVIDE(text_start = .);
    *(.text.entry)   /* 入口代码段 */
    *(.text .text.*) /* 其他代码段 */
    PROVIDE(text_end = .);
  }

  /* 只读数据段 */
  .rodata : ALIGN(4K) {
    PROVIDE(rodata_start = .);
    *(.rodata .rodata.*)
    *(.srodata .srodata.*)
    PROVIDE(rodata_end = .);
  }

  /* 数据段 */
  .data : ALIGN(4K) {
    PROVIDE(data_start = .);
    *(.data .data.*)
    *(.sdata .sdata.*)
    PROVIDE(data_end = .);
  }

  /* 定义一些重要的符号供程序使用 */
  PROVIDE(etext = .);     /* 代码段结束地址 */
  PROVIDE(edata = .);     /* 数据段结束地址 */

  /* BSS段（未初始化数据） */
  .bss : {
    PROVIDE(bss_start = .);
    *(.bss .bss.*)
    *(.sbss .sbss.*)
    *(COMMON)
    PROVIDE(bss_end = .);
  }

  PROVIDE(end = .);       /* 程序结束地址 */
}
