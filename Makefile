# 用户程序嵌入相关
USER_BIN_C = kernel/user_test_syscalls_bin.c
USER_ELF = user/test_syscalls.elf
USER_OBJS = user/test_syscalls.o user/syscall.o
USER_LDS = user/user.ld

# FS test program
FS_BIN_C = kernel/user_test_fs_bin.c
FS_ELF = user/test_fs.elf
FS_OBJS = user/test_fs.o user/syscall.o

# 工具链
CC = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump
OBJCOPY = riscv64-unknown-elf-objcopy
LD = riscv64-unknown-elf-ld

# 编译选项
CFLAGS = -Wall -O2 -ffreestanding -nostdlib -nostartfiles \
         -march=rv64g -mabi=lp64d -mcmodel=medany \
         -I include -I kernel -I user

# 链接脚本
LINKER_SCRIPT = kernel/kernel.ld

# 内核目标文件
KERNEL_ELF = kernel.elf
KERNEL_BIN = kernel.bin

# 内核对象文件
KERNEL_OBJS = \
	kernel/boot/entry.o \
	kernel/main.o \
	kernel/printf.o \
	kernel/uart.o \
	kernel/kalloc.o \
	kernel/vm.o \
	kernel/trap.o \
	kernel/proc.o \
	kernel/machinevec.o \
	kernel/kernelvec.o \
	kernel/uservec.o \
	kernel/swtch.o \
	kernel/syscall.o \
	kernel/fs_mem.o \
	kernel/trapret.o


# 用户态测试程序编译规则
USER_ELF = user/test_syscalls.elf
USER_OBJS = user/test_syscalls.o user/syscall.o
USER_LDS = user/user.ld

.PHONY: all clean qemu user

all: $(KERNEL_ELF) $(KERNEL_BIN) kernel.asm kernel.sym $(USER_ELF) $(USER_BIN_C) $(FS_ELF) $(FS_BIN_C)
	@echo "Build complete!"
# 用户态目标
user: $(USER_ELF)
	@echo "User program build complete!"

$(USER_ELF): $(USER_OBJS)
	$(CC) $(CFLAGS) -T $(USER_LDS) -o $@ $^

user/%.o: user/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

# 用户程序转C数组嵌入内核
$(USER_BIN_C): $(USER_ELF)
	$(OBJCOPY) -O binary $< $<.bin
	hexdump -v -e '1/1 "0x%02x, "' $<.bin > $<.bin.txt
	echo "const unsigned char user_test_syscalls_bin[] = {" > $@
	cat $<.bin.txt >> $@
	echo "};" >> $@
	echo "const unsigned int user_test_syscalls_bin_len = sizeof(user_test_syscalls_bin);" >> $@
	rm -f $<.bin $<.bin.txt

# Build FS test user program
$(FS_ELF): $(FS_OBJS)
	$(CC) $(CFLAGS) -T $(USER_LDS) -o $@ $^

user/test_fs.o: user/test_fs.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(FS_BIN_C): $(FS_ELF)
	$(OBJCOPY) -O binary $< $<.bin
	hexdump -v -e '1/1 "0x%02x, "' $<.bin > $<.bin.txt
	echo "const unsigned char user_test_fs_bin[] = {" > $@
	cat $<.bin.txt >> $@
	echo "};" >> $@
	echo "const unsigned int user_test_fs_bin_len = sizeof(user_test_fs_bin);" >> $@
	rm -f $<.bin $<.bin.txt
# 删除重复的用户态目标规则（上方已有）

# 链接内核
$(KERNEL_ELF): $(KERNEL_OBJS)
	$(LD) -T $(LINKER_SCRIPT) -o $@ $^
	@echo "Linking complete!"

# 生成二进制文件
$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@

# 生成反汇编文件
kernel.asm: $(KERNEL_ELF)
	$(OBJDUMP) -S $< > $@

# 生成符号表
kernel.sym: $(KERNEL_ELF)
	$(OBJDUMP) -t $< | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $@

# 编译C源文件
kernel/%.o: kernel/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Ensure generated user binaries exist before compiling main.c that includes them
kernel/main.o: $(FS_BIN_C) $(USER_BIN_C)

# 编译汇编源文件
kernel/%.o: kernel/%.S
	$(CC) $(CFLAGS) -c -o $@ $<

kernel/boot/%.o: kernel/boot/%.S
	$(CC) $(CFLAGS) -c -o $@ $<
	@echo "Compiled $<"

# 清理
clean:
	rm -f $(KERNEL_ELF) $(KERNEL_BIN) kernel.asm kernel.sym $(KERNEL_OBJS) $(USER_ELF) $(USER_OBJS) $(USER_BIN_C) $(FS_ELF) $(FS_OBJS) $(FS_BIN_C)
	@echo "Cleanup complete!"

# 运行QEMU
qemu: all
	qemu-system-riscv64 -machine virt -nographic -bios none -kernel $(KERNEL_ELF)