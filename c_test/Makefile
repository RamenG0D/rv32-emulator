
# can be overridden by the user via the command line
# example: make PREFIX=riscv32-unknown-elf-
PREFIX=riscv32-unknown-linux-gnu-

CC = $(PREFIX)gcc
OBJDUMP = $(PREFIX)objdump
OBJCOPY = $(PREFIX)objcopy

CFLAGS = -Wall -Wextra -Werror -g -O3 -nostdlib -DPRINTF_INCLUDE_CONFIG_H
BUILD_FLAGS=-flto -Wl,-Ttext=0x80000000
INCLUDE=-I.

TEST=fib

DUMP_OPTS=-S -M no-aliases

# default target
all: test

# used to compile the test's into object files
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

# used to make an executable from the test's
test: $(TEST).o debug.o
	$(CC) $(CFLAGS) $(BUILD_FLAGS) $(INCLUDE) $^ -o $@
	$(OBJDUMP) $(DUMP_OPTS) -D $@ > $@.asm
	$(OBJCOPY) -O binary $@ $@.bin
#   run the test
	@cargo run run bin -b $@.bin

# used to clean up the directory
clean:
	rm -f *.o *.asm *.bin test

.PHONY: all clean
