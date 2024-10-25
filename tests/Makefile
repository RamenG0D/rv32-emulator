
PREFIX = riscv32-unknown-elf-

CC = $(PREFIX)gcc
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy

CFLAGS = -I. -Wall -g -O3 -pedantic -nostdlib -march="rv32ima"
# -Werror

.PHONY: all

all: test.bin

# compiles all *.c files to *.s files
%.s: %.c
	$(CC) $(CFLAGS) -S -o $@ $<

# compiles all *.s files to *.o files then links them to a binary
DUMP_ARGS = -D # disassemble data sections
DUMP_ARGS += -M no-aliases # disable this if you want to see shortend instructions / pseudo instructions
DUMP_ARGS += -m riscv:rv32 # set the architecture
DUMP_ARGS += --adjust-vma=0x80000000 # set the base address
DUMP_ARGS += "-S" # include source code
test.bin: test.s custom_gl.s
	$(CC) $(CFLAGS) -flto -Wl,-Ttext=0x80000000 -o test $^
	$(OBJCOPY) -O binary test $@
# 	rm test
# 	create a disassembly of the binary
	$(PREFIX)objdump $(DUMP_ARGS) test > diasm.s

# clean up
clean:
	rm -f *.s test.bin test
