#!/bin/bash

prefix ()
{
  "riscv32-unknown-linux-gnu-$@"
}

IncludeFlag="-I."
CFlags="-nostdlib -O3 -DPRINTF_INCLUDE_CONFIG_H"

# get the filename without the extension
C_FILE=$1
FNAME=$(basename $1 .c)
ASM=$FNAME.s
DUMP_OPTS= ""
BUILD_OPTS="-flto -Wl,-Ttext=0x80000000"

prefix gcc $CFlags $IncludeFlag -S $C_FILE debug.c
prefix gcc $CFlags $IncludeFlag $BUILD_OPTS -o $FNAME $ASM debug.s
prefix objdump $DUMP_OPTS -D $FNAME > $FNAME.asm
prefix objcopy -O binary $FNAME $FNAME.bin

rm $ASM debug.s
rm $FNAME
