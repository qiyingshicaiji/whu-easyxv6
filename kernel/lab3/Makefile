# 工具链前缀
RISCV_TOOLCHAIN_PREFIX := riscv64-unknown-elf-

# 编译器和链接器
CC := $(RISCV_TOOLCHAIN_PREFIX)gcc
LD := $(RISCV_TOOLCHAIN_PREFIX)ld
OBJCOPY := $(RISCV_TOOLCHAIN_PREFIX)objcopy

# QEMU 模拟器
QEMU := qemu-system-riscv64

# 源文件和对象文件 (新增 kalloc.c 和 vm.c)
SRCS := entry.S main.c uart.c printf.c kalloc.c vm.c
OBJS := $(patsubst %.S, %.o, $(filter %.S, $(SRCS)))
OBJS += $(patsubst %.c, %.o, $(filter %.c, $(SRCS)))

# 编译和链接选项
# -I. 用于包含 riscv.h
CFLAGS := -nostdlib -fno-builtin -mcmodel=medany -g -I.
LDFLAGS := -T kernel.ld

# 目标文件名
TARGET := kernel.elf

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

run: $(TARGET)
	$(QEMU) -machine virt -nographic -bios none -kernel $(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)

# QEMU 运行规则
qemu: $(TARGET)
	@echo "--- Starting QEMU ---"
	@qemu-system-riscv64 -machine virt -nographic -bios none -kernel $(TARGET)
	@echo "\n--- QEMU finished ---"

# GDB 调试规则
qemu-gdb: $(TARGET)
	@echo "--- Starting QEMU for GDB ---"
	@qemu-system-riscv64 -machine virt -nographic -bios none -kernel $(TARGET) -s -S
