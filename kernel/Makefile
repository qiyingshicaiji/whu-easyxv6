RISCV_PREFIX = riscv64-unknown-elf-
CC = $(RISCV_PREFIX)gcc
AS = $(RISCV_PREFIX)as
LD = $(RISCV_PREFIX)ld
OBJCOPY = $(RISCV_PREFIX)objcopy

CFLAGS = -Wall -O0 -ffreestanding -nostdlib -nostartfiles -march=rv64g -mabi=lp64 -mno-relax -mcmodel=medany -fno-common -fno-builtin -fno-stack-protector -fno-omit-frame-pointer
LDFLAGS = -T kernel.ld -nostdlib

OBJS = entry.o main.o uart.o printf.o console.o kalloc.o vm.o

all: kernel.bin

entry.o: entry.S
	$(CC) $(CFLAGS) -c $< -o $@

main.o: main.c uart.h console.h
	$(CC) $(CFLAGS) -c $< -o $@

uart.o: uart.c uart.h
	$(CC) $(CFLAGS) -c $< -o $@

printf.o: printf.c uart.h console.h
	$(CC) $(CFLAGS) -c $< -o $@

kalloc.o: kalloc.c kalloc.h
	$(CC) $(CFLAGS) -c $< -o $@

vm.o: vm.c vm.h memlayout.h riscv.h printf.h
	$(CC) $(CFLAGS) -c $< -o $@

console.o: console.c uart.h console.h
	$(CC) $(CFLAGS) -c $< -o $@

kernel.elf: $(OBJS) kernel.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

kernel.bin: kernel.elf
	$(OBJCOPY) -O binary $< $@

run: kernel.bin
	@echo "Running kernel.bin in QEMU..."
	qemu-system-riscv64 -machine virt -nographic -bios none -kernel kernel.bin || echo "QEMU not installed or path incorrect."

clean:
	rm -f *.o kernel.elf kernel.bin