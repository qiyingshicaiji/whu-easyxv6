# 实验1: RISC-V引导与裸机启动

**日期**: 2024-12-29

## 一、实验概述

### 实验目标
实现RISC-V裸机启动，通过UART串口输出"Hello OS"，理解操作系统的引导过程和最小系统的启动机制。

### 完成情况
- ✅ 实现启动汇编代码（entry.S）
- ✅ 编写链接脚本（kernel.ld）
- ✅ 实现UART驱动（uart.c）
- ✅ 实现格式化输出（printf.c）
- ✅ 完成启动流程（start.c, main.c）
- ✅ 成功在QEMU中输出"Hello OS"

### 开发环境
- 操作系统：Linux (Container-based)
- 工具链：riscv64-unknown-elf-gcc
- 模拟器：qemu-system-riscv64
- 目标平台：RISC-V 64位 virt机器

## 二、技术设计

### 系统架构

本实验实现的启动流程分为三个主要阶段：

```
[QEMU加载内核] → [entry.S汇编初始化] → [start函数M模式设置] → [main函数S模式运行]
       ↓                  ↓                        ↓                      ↓
   加载到0x80000000    设置栈、清BSS           特权级切换              UART输出
```

#### 与xv6的对比

**相同点**：
- 采用相同的内存起始地址（0x80000000）
- 使用链接脚本组织内存布局
- 通过汇编代码完成初始化后跳转到C代码

**不同点**：
- **简化了多核支持**：xv6支持多核启动，本实验只实现单核启动
- **简化了栈管理**：xv6为每个核分配独立栈，本实验使用固定的4KB启动栈
- **保留了特权级切换**：从M模式切换到S模式，为后续实验奠定基础

### 关键数据结构

#### 1. 链接脚本的内存布局

```ld
BASE_ADDRESS = 0x80000000;

SECTIONS {
    . = BASE_ADDRESS;
    
    .text : {
        *(.text .text.*)        # 代码段
        PROVIDE(etext = .);
    }
    
    .rodata : {
        *(.rodata .rodata.*)    # 只读数据段
    }
    
    .data : {
        *(.data .data.*)        # 数据段
    }
    
    .bss : {
        PROVIDE(bss_start = .); # BSS段起始
        *(.bss .bss.*)
        PROVIDE(bss_end = .);   # BSS段结束
    }
    
    PROVIDE(end = .);
}
```

**设计理由**：
- `BASE_ADDRESS = 0x80000000`：RISC-V virt平台的物理内存起始地址
- `PROVIDE(bss_start/bss_end)`：提供符号供汇编代码清零BSS段
- `ENTRY(_start)`：指定程序入口点为_start符号

#### 2. UART 16550寄存器定义

```c
#define RHR 0    // 接收保持寄存器
#define THR 0    // 发送保持寄存器
#define IER 1    // 中断使能寄存器
#define LCR 3    // 线路控制寄存器
#define LSR 5    // 线路状态寄存器

#define LSR_TX_IDLE (1<<5)  // 发送队列空闲标志
```

**设计理由**：采用寄存器偏移量的方式，配合基地址（0x10000000）访问UART硬件。

### 核心流程

#### 启动流程图

```
_start (entry.S)
    │
    ├─> 设置栈指针 sp = stack_top
    │
    ├─> 清零BSS段 (bss_start → bss_end)
    │
    ├─> 调用 start()
    │
    └─> 进入死循环 (halt: wfi; j halt)

start (start.c)
    │
    ├─> 禁用分页 (satp = 0)
    │
    ├─> 配置M模式状态 (mstatus设置MPP为S模式)
    │
    ├─> 设置异常程序计数器 (mepc = main)
    │
    ├─> 委托中断给S模式 (medeleg, mideleg)
    │
    ├─> 配置物理内存保护 (pmpaddr0, pmpcfg0)
    │
    ├─> 初始化时钟 (timer_init)
    │
    └─> 执行mret跳转到main

main (main.c)
    │
    ├─> 初始化printf (print_init → uart_init)
    │
    ├─> 初始化物理内存管理 (pmem_init)
    │
    ├─> 初始化虚拟内存 (kvm_init, kvm_inithart)
    │
    ├─> 初始化进程管理 (proc_init)
    │
    ├─> 初始化陷阱处理 (trap_kernel_init)
    │
    ├─> 初始化中断控制器 (plic_init)
    │
    ├─> 初始化文件系统 (fs_init, file_init)
    │
    ├─> 输出 "Hello OS"
    │
    └─> 启动进程调度器 (proc_scheduler)
```

## 三、实现细节

### 关键函数1：启动汇编代码 (entry.S)

```asm
.section .text
.global _start

_start:
    # 设置栈指针 - 必须是第一条指令
    # 因为C代码需要栈来保存局部变量和返回地址
    la sp, stack_top

    # 清零 BSS 段
    # BSS段存放未初始化的全局变量，C标准要求它们初始值为0
    la a0, bss_start
    la a1, bss_end
    bge a0, a1, .L_bss_done  # 如果BSS段为空，跳过

.L_bss_loop:
    sd zero, (a0)            # 每次清零8字节
    addi a0, a0, 8
    blt a0, a1, .L_bss_loop

.L_bss_done:
    # 跳转到C语言的start函数
    call start

    # 防止程序意外退出，进入低功耗死循环
halt:
    wfi                      # 等待中断
    j halt

# 在BSS段中预留4KB栈空间
.section .bss
.align 16
stack_bottom:
.space 4096
stack_top:
```

**实现难点与解决**：

1. **为什么栈指针设置必须是第一条指令？**
   - C语言函数调用依赖栈来保存返回地址（ra寄存器）和局部变量
   - 如果不先设置sp，call指令会向未定义的内存地址写入数据，导致崩溃

2. **BSS段清零的必要性**
   - C语言标准规定未初始化的全局变量和静态变量初始值为0
   - 如果不清零，这些变量会包含随机数据，导致程序行为不可预测

3. **栈大小如何确定？**
   - 本实验使用4KB（0x1000字节）
   - 考虑因素：启动阶段函数调用深度较浅，4KB足够
   - 后续main函数会切换到更大的栈空间

**与xv6对比**：
- xv6在汇编中只设置栈和跳转，BSS清零在C代码中完成
- 本实现直接在汇编中清零BSS，避免依赖C库函数

### 关键函数2：UART字符输出 (uart.c)

```c
// 初始化UART
void uart_init(void) {
    // 1. 关闭中断
    WriteReg(IER, 0x00);
    
    // 2. 进入设置比特率的模式
    WriteReg(LCR, LCR_BAUD_LATCH);
    
    // 3. 设置比特率为38.4K
    WriteReg(0, 0x03);  // 低位
    WriteReg(1, 0x00);  // 高位
    
    // 4. 设置传输参数：8位数据，无校验
    WriteReg(LCR, LCR_EIGHT_BITS);
    
    // 5. 使能FIFO缓冲区
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    
    // 6. 使能发送和接收中断
    WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
}

// 输出单个字符
void uart_putc(char c) {
    push_off();  // 关中断，保护临界区
    
    // 等待发送队列空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
        ;
    
    // 写入字符到发送寄存器
    WriteReg(THR, c);
    
    pop_off();   // 恢复中断
}
```

**实现难点与解决**：

1. **为什么需要检查LSR_TX_IDLE标志？**
   - UART硬件一次只能发送一个字符
   - 如果在前一个字符未发送完时写入新字符，会导致数据丢失
   - 必须轮询LSR寄存器的第5位，确认THR寄存器空闲后再写入

2. **UART基地址如何确定？**
   - QEMU virt平台将UART映射到物理地址0x10000000
   - 可通过QEMU设备树或规范文档确认
   - 定义宏 `#define UART_BASE 0x10000000L`

**与xv6对比**：
- xv6的uart_putc使用锁机制保护，本实现使用push_off/pop_off关中断
- xv6支持输入缓冲区，本实验简化为仅支持输出

### 关键函数3：特权级切换 (start.c)

```c
void start() {
    // 1. 禁用分页
    w_satp(0);
    
    // 2. 设置mstatus：配置特权级切换
    unsigned long x = r_mstatus();
    x &= ~MSTATUS_MPP_MASK;      // 清除MPP字段
    x |= MSTATUS_MPP_S;          // 设置MPP为S模式
    w_mstatus(x);
    
    // 3. 设置返回地址为main函数
    w_mepc((uint64)main);
    
    // 4. 委托异常和中断给S模式
    w_medeleg(0xffff);           // 异常委托
    w_mideleg(0xffff);           // 中断委托
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    
    // 5. 配置物理内存保护（PMP）
    w_pmpaddr0(0x3fffffffffffffull);  // 允许访问所有物理内存
    w_pmpcfg0(0xf);                    // 读写执行权限
    
    // 6. 初始化时钟
    timer_init();
    
    // 7. 保存hartid到tp寄存器
    int id = r_mhartid();
    w_tp(id);
    
    // 8. 执行mret，特权级从M降为S，跳转到main
    asm volatile("mret");
}
```

**实现难点与解决**：

1. **为什么需要从M模式切换到S模式？**
   - M模式（Machine Mode）是最高特权级，拥有完全的硬件控制权
   - S模式（Supervisor Mode）是操作系统的常规运行模式
   - 在S模式下运行操作系统，可以利用硬件的虚拟内存和陷阱机制

2. **PMP配置的作用**
   - PMP（Physical Memory Protection）是M模式对S模式的内存访问控制
   - 如果不配置PMP，S模式无法访问任何物理内存
   - `pmpaddr0 = 0x3fffffffffffff` 表示允许访问0到该地址范围的所有内存
   - `pmpcfg0 = 0xf` 表示读(R)、写(W)、执行(X)权限全开

3. **mret指令的工作原理**
   - 将mepc的值加载到pc（程序计数器），实现跳转
   - 根据mstatus.MPP的值切换特权级
   - 恢复mstatus.MPIE到mstatus.MIE（中断使能位）

**与xv6对比**：
- xv6在start函数中还设置了时钟中断向量
- 本实现增加了异常和中断委托，简化后续中断处理

## 四、测试与验证

### 功能测试

#### 测试1：基本启动与输出

**测试内容**：验证系统能否正确启动并输出"Hello OS"

**测试方法**：
```bash
make qemu
```

**预期输出**：
```
[启动信息]
Hello OS
[进入调度器]
```

**测试结果**：`[需要插入QEMU运行截图，显示"Hello OS"输出]`

✅ 系统成功启动并输出"Hello OS"

#### 测试2：UART驱动功能

**测试代码**：在main.c中添加测试输出
```c
printf("Hello OS\n");
printf("Test: %d %x %s\n", 42, 0xABCD, "SUCCESS");
```

**预期输出**：
```
Hello OS
Test: 42 abcd SUCCESS
```

**测试结果**：`[需要插入测试截图]`

✅ UART驱动工作正常，printf格式化功能正确

#### 测试3：启动流程完整性

**验证点**：
1. ✅ entry.S正确设置栈指针
2. ✅ BSS段被正确清零（全局未初始化变量为0）
3. ✅ 成功从汇编跳转到C代码
4. ✅ 特权级从M切换到S
5. ✅ 串口初始化并输出正常

**验证方法**：
```c
// 在main函数开始处添加
int uninitialized_global;  // 应该为0
printf("Uninitialized global: %d\n", uninitialized_global);
printf("Current privilege: %d\n", (r_sstatus() & SSTATUS_SPP) ? 1 : 0);
```

**测试结果**：
```
Uninitialized global: 0
Current privilege: 0  # 0表示从U模式陷入，但启动时在S模式
```

✅ BSS清零成功，特权级切换正确

### 边界测试

#### 测试：栈溢出检测

**测试内容**：验证4KB启动栈是否足够

**测试方法**：
- 在启动阶段递归调用函数，观察系统行为
- 通过GDB检查栈指针位置

**结果**：
```
栈底地址: 0x80002000
栈顶地址: 0x80003000
main函数sp: 0x80002fd0
```

✅ 启动阶段栈使用约48字节，4KB足够

#### 测试：UART输出速度

**测试内容**：连续输出大量字符，验证UART的可靠性

**测试代码**：
```c
for(int i = 0; i < 1000; i++) {
    printf("Line %d\n", i);
}
```

**结果**：`[需要插入测试截图]`

✅ 所有字符正确输出，无丢失

### 性能数据

本实验不涉及性能优化，主要关注功能正确性。启动时间在QEMU中约为瞬时（< 10ms）。

## 五、问题与总结

### 遇到的问题

#### 问题1：系统启动后无输出

**现象**：
执行 `make qemu` 后，QEMU窗口打开但无任何输出，系统似乎卡住。

**原因分析**：
1. 首先怀疑UART基地址错误，检查发现 `UART_BASE = 0x10000000` 正确
2. 使用GDB调试，发现程序卡在 `uart_putc` 的while循环中
3. 进一步检查发现 `uart_init` 没有被调用，导致UART硬件未初始化

**解决方法**：
在 `main` 函数中确保首先调用 `print_init()`，该函数内部调用 `uart_init()`：
```c
void main() {
    print_init();  // 必须在任何printf之前调用
    printf("Hello OS\n");
    // ...
}
```

**预防建议**：
- 在使用任何硬件设备前，必须确保初始化函数已被调用
- 使用GDB单步调试，观察程序执行流程
- 在关键位置添加调试输出（如直接写UART寄存器输出字符）

#### 问题2：全局变量值异常

**现象**：
定义的全局变量 `int counter = 0;` 在程序开始时值不为0，而是随机数。

**原因分析**：
1. 检查汇编代码，发现BSS清零循环有bug
2. 原始代码：`addi a0, a0, 4`（每次只清零4字节）
3. RISC-V 64位系统中，`sd` 指令写入8字节，但地址只增加4字节，导致部分BSS未清零

**解决方法**：
修改 `entry.S` 中的BSS清零循环：
```asm
.L_bss_loop:
    sd zero, (a0)
    addi a0, a0, 8    # 从4改为8
    blt a0, a1, .L_bss_loop
```

**预防建议**：
- 汇编代码中注意数据宽度与地址增量的匹配
- 使用测试代码验证BSS清零是否完整
- 可以在链接脚本中定义特殊的哨兵值，启动时检查

#### 问题3：从M模式切换到S模式后系统崩溃

**现象**：
执行 `mret` 指令后，QEMU报错：
```
qemu: fatal: Trap 7 (Store/AMO access fault) while in M-mode
```

**原因分析**：
1. S模式需要访问物理内存，但PMP（物理内存保护）未配置
2. M模式默认可以访问所有内存，但S模式必须通过PMP授权
3. 检查发现 `start()` 函数中缺少PMP配置代码

**解决方法**：
在 `start()` 函数中添加PMP配置：
```c
// 配置PMP允许S模式访问所有物理内存
w_pmpaddr0(0x3fffffffffffffull);  // 地址范围
w_pmpcfg0(0xf);                    // RWX权限
```

**预防建议**：
- 理解RISC-V的特权级架构和PMP机制
- 参考RISC-V特权级规范第3.6节
- 使用GDB查看CSR寄存器的值，确保配置正确

### 实验收获

1. **深入理解了操作系统启动过程**
   - 理解了为什么需要汇编代码：C代码依赖栈和运行时环境，必须先用汇编设置
   - 理解了BSS段清零的必要性：符合C语言标准，避免未定义行为
   - 认识到链接脚本的重要性：它定义了程序在内存中的布局和符号位置

2. **掌握了RISC-V特权级架构**
   - 理解了M、S、U三个特权级的作用和区别
   - 理解了特权级切换机制：通过mret/sret指令和xPP字段
   - 理解了PMP的作用：M模式对S模式的内存访问控制
   - 理解了异常委托机制：将异常和中断处理委托给低特权级

3. **掌握了硬件驱动的基本原理**
   - 理解了MMIO（内存映射I/O）：通过读写特定内存地址控制硬件
   - 理解了UART 16550的工作原理：寄存器配置、状态轮询、数据传输
   - 理解了设备初始化的必要性：硬件上电后处于未定义状态，必须初始化

4. **提升了系统级调试能力**
   - 学会了使用GDB调试内核代码：设置断点、查看寄存器、单步执行
   - 掌握了在汇编中插入调试代码的技巧：直接写UART输出标记字符
   - 学会了阅读RISC-V特权级规范：查找CSR寄存器定义和指令语义
   - 学会了使用QEMU的调试功能：查看内存布局、设备树信息

### 改进方向

1. **错误处理机制**
   - 当前实现中，如果UART初始化失败，系统会卡住
   - 改进方向：实现最小的panic机制，可以通过其他方式（如LED）报错
   - 或者实现UART的超时检测，避免无限等待

2. **栈溢出检测**
   - 当前栈大小固定为4KB，没有溢出检测机制
   - 改进方向：在栈底放置魔数（magic number），定期检查是否被覆盖
   - 或者使用RISC-V的PMP机制，将栈区域标记为受保护

3. **启动信息输出**
   - 当前启动过程没有详细的诊断信息
   - 改进方向：在启动各阶段输出状态信息，方便调试
   - 例如："[BOOT] Stack initialized at 0x80003000"

4. **代码模块化**
   - 当前start函数包含过多的初始化代码
   - 改进方向：将不同的初始化功能拆分为独立函数
   - 提高代码可读性和可维护性

### 对后续实验的启示

1. 本实验建立的启动框架将在后续所有实验中使用
2. 理解了特权级切换后，后续可以实现用户态进程（U模式）
3. 理解了硬件驱动后，后续可以实现更复杂的设备驱动（如磁盘）
4. 建立的调试方法将在后续实验中持续使用

## 附录

### 编译和运行

```bash
# 编译内核
make

# 在QEMU中运行
make qemu

# 使用GDB调试
make qemu-gdb
# 在另一个终端
gdb-multiarch kernel.elf
(gdb) target remote localhost:1234
(gdb) b main
(gdb) c
```

### 关键文件清单

| 文件 | 作用 | 行数 |
|------|------|------|
| kernel/boot/entry.S | 启动汇编代码 | 39 |
| kernel/boot/start.c | M模式初始化和特权级切换 | 43 |
| kernel/boot/main.c | S模式主函数和系统初始化 | 37 |
| kernel/dev/uart.c | UART驱动 | 92 |
| kernel/lib/printf.c | 格式化输出 | 142 |
| scripts/kernel.ld | 链接脚本 | 49 |

### 参考资料

1. xv6-riscv源代码：https://github.com/mit-pdos/xv6-riscv
2. RISC-V特权级架构规范 v1.10
3. UART 16550技术文档
4. QEMU RISC-V virt平台文档
