简化版 xv6 操作系统实验

这是一个基于 RISC-V 架构的简化版 xv6 操作系统实验项目，包含了操作系统核心功能的实现。

项目概述

本项目实现了一个简化的 xv6 操作系统，主要包含以下核心功能：

• 引导加载程序：系统启动和初始化

• 内核基本功能：Hello OS 输出、内核级 printf 函数

• 显示控制：清屏功能实现

• 内存管理：页表管理和内存分配机制

• RISC-V 架构支持：针对 RISC-V 64 位架构的优化

功能特性

已完成功能

• ✅ Hello OS 启动输出

• ✅ 内核级 printf 格式化输出

• ✅ 屏幕清空功能

• ✅ 页表管理机制

• ✅ 物理内存管理

• ✅ RISC-V 异常处理框架


开发环境要求

必需工具链

• RISC-V 64 位交叉编译工具链

  • riscv64-unknown-elf-gcc

  • riscv64-unknown-elf-objcopy

  • riscv64-unknown-elf-objdump

• QEMU 系统模拟器（支持 RISC-V）

• Make 构建工具

可选开发工具

• GDB 调试器（riscv64-unknown-elf-gdb）

• 串口终端工具（如 minicom、screen）

构建和运行

1. 获取源码

git clone <repository-url>
cd xv6-labs


2. 编译项目

make


3. 在 QEMU 中运行

# 基本运行
make qemu

# 使用 GDB 调试
make qemu-gdb


4. 清理构建文件

make clean


项目结构


xv6-labs/
├── kernel/           # 内核源代码
│   ├── entry.S      # 内核入口点（汇编）
│   ├── main.c       # 内核主函数
│   ├── printf.c     # 内核 printf 实现
│   ├── console.c    # 控制台和清屏功能
│   ├── vm.c         # 虚拟内存管理
│   └── ...
├── scripts/         #
├── vscode/          # 
├── include/         # 头文件
├── Makefile         # 构建配置
└── README.md        # 项目说明


实验进度记录

已实现功能详情

Hello OS 输出

• 系统启动时显示欢迎信息

• 基本的字符串输出功能

内核 printf

• 支持格式符：%d, %x, %p, %s等

• 可变参数处理

• 直接控制台输出

清屏功能

• 清除整个屏幕显示

• 重置光标位置

• 支持控制台滚动

页表管理

• 三级页表结构（Sv39）

• 虚拟地址到物理地址映射

• 页表项属性设置

内存管理

• 物理页帧分配

• 内核空间映射

• 内存区域管理

调试技巧

1. 使用 GDB 调试

# 终端1：启动 QEMU 等待 GDB 连接
make qemu-gdb

# 终端2：启动 GDB 调试
make gdb


2. 串口输出调试

• 内核 printf 输出到串口

• 查看 QEMU 控制台信息

3. 常见问题解决

• 编译错误：检查 RISC-V 工具链安装

• 链接错误：确认内存布局配置

• 运行崩溃：使用 GDB 查看异常地址

后续开发计划

1. 进程管理
   • 实现进程控制块（PCB）

   • 添加进程调度算法

   • 实现上下文切换

2. 系统调用
   • 定义系统调用接口

   • 实现基本的系统调用

   • 用户态和内核态切换

3. 文件系统
   • 简单的文件系统结构

   • 文件操作接口

   • 块设备驱动

参考资料

• https://pdos.csail.mit.edu/6.828/xv6/

• https://riscv.org/technical/specifications/

• https://www.qemu.org/docs/

贡献指南

欢迎提交 Issue 和 Pull Request 来改进这个项目。

许可证

本项目仅用于教学和研究目的。