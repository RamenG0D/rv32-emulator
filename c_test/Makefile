
# can be overridden by the user via the command line
# example: make PREFIX=riscv32-unknown-elf-
# riscv32-unknown-linux-gnu-
PREFIX=riscv32-unknown-elf-

CC = $(PREFIX)gcc
OBJDUMP = $(PREFIX)objdump
OBJCOPY = $(PREFIX)objcopy

CFLAGS=-march=rv32imazicsr -mabi=ilp32
CFLAGS += -DPRINTF_INCLUDE_CONFIG_H
CFLAGS += -Wall -Wextra
# CFLAGS += -Werror
CFLAGS += -O0
CFLAGS += -ffast-math -nostartfiles -nostdlib
CFLAGS += -g

# OBJFLAGS=-fno-lto

BUILD_FLAGS=-Wl,-Ttext=0x80000000,-Tdata=0x80100000
BUILD_FLAGS+=-flto

INCLUDE=-I.

TEST=vaddr

DUMP_OPTS=-S -M no-aliases

OBJDIR=objs
OUTPUT=out

# make the objs dir
$(shell mkdir -p $(OBJDIR))
# make the output dir
$(shell mkdir -p $(OUTPUT))

# default target
all: test

# used to compile the test's into object files
%.o: %.c
	$(CC) $(OBJFLAGS) $(CFLAGS) $(INCLUDE) -o $(OBJDIR)/$@ -c $<
# $(OBJDIR)/%.o: %.S
# 	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<

# used to make an executable from the test's
test: $(TEST).o printf.o
# string.o standard.o mem.o signal.o
#$(wildcard $(OBJDIR)/*.o)
	$(CC) -o $(OUTPUT)/$@ $(CFLAGS) $(BUILD_FLAGS) $(INCLUDE) $(OBJDIR)/$(TEST).o $(OBJDIR)/printf.o $(LIBS)
	$(OBJDUMP) $(DUMP_OPTS) -D $(OUTPUT)/$@ > $(OUTPUT)/$@.asm
	$(OBJCOPY) -O binary $(OUTPUT)/$@ $(OUTPUT)/$@.bin

# used to clean up the directory
clean:
	rm -rf $(OBJDIR)
	rm -rf $(OUTPUT)
