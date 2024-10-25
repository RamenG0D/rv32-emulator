#!/bin/bash

prefix ()
{
  "riscv32-unknown-elf-$@"
}

prefix gcc -O3 -march="rv32ima" -nostdlib -nostartfiles -flto -Wl,-Ttext=0x80000000 -o $1 $1.S
prefix objdump -SD $1 > $1.asm
prefix objcopy -O binary $1 $1.bin

rm $1
