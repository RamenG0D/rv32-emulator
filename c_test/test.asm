
test:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <main>:

#include "debug.h"

int main(void) {
    printf("Number: {%f}\n", 100.4);
80000000:	800037b7          	lui	a5,0x80003
80000004:	0007a603          	lw	a2,0(a5) # 80003000 <__DATA_BEGIN__>
80000008:	0047a683          	lw	a3,4(a5)
8000000c:	80002537          	lui	a0,0x80002
int main(void) {
80000010:	ff010113          	addi	sp,sp,-16
    printf("Number: {%f}\n", 100.4);
80000014:	cc050513          	addi	a0,a0,-832 # 80001cc0 <fctprintf+0x60>
int main(void) {
80000018:	00112623          	sw	ra,12(sp)
    printf("Number: {%f}\n", 100.4);
8000001c:	2f5010ef          	jal	ra,80001b10 <printf_>

    return 0;
}
80000020:	00c12083          	lw	ra,12(sp)
80000024:	00000513          	addi	a0,zero,0
80000028:	01010113          	addi	sp,sp,16
8000002c:	00008067          	jalr	zero,0(ra)

80000030 <_out_buffer>:
} out_fct_wrap_type;

// internal buffer output
static inline void _out_buffer(char character, void *buffer, size_t idx,
                               size_t maxlen) {
    if (idx < maxlen) {
80000030:	00d67663          	bgeu	a2,a3,8000003c <_out_buffer+0xc>
        ((char *)buffer)[idx] = character;
80000034:	00c585b3          	add	a1,a1,a2
80000038:	00a58023          	sb	a0,0(a1)
    }
}
8000003c:	00008067          	jalr	zero,0(ra)

80000040 <_out_null>:
                                             size_t idx, size_t maxlen) {
    (void)character;
    (void)buffer;
    (void)idx;
    (void)maxlen;
}
80000040:	00008067          	jalr	zero,0(ra)

80000044 <_out_char>:
static inline __always_inline void _out_char(char character, void *buffer,
                                             size_t idx, size_t maxlen) {
    (void)buffer;
    (void)idx;
    (void)maxlen;
    if (character) {
80000044:	00050663          	beq	a0,zero,80000050 <_out_char+0xc>
void _putchar(char character) { UART(0) = character; }
80000048:	100007b7          	lui	a5,0x10000
8000004c:	00a78023          	sb	a0,0(a5) # 10000000 <main-0x70000000>
        _putchar(character);
    }
}
80000050:	00008067          	jalr	zero,0(ra)

80000054 <_out_rev>:
}

// output the specified string in reverse, taking care of any zero-padding
static size_t _out_rev(out_fct_type out, char *buffer, size_t idx,
                       size_t maxlen, const char *buf, size_t len,
                       unsigned int width, unsigned int flags) {
80000054:	fd010113          	addi	sp,sp,-48
80000058:	02812423          	sw	s0,40(sp)
8000005c:	01312e23          	sw	s3,28(sp)
80000060:	01412c23          	sw	s4,24(sp)
80000064:	01512a23          	sw	s5,20(sp)
80000068:	01612823          	sw	s6,16(sp)
8000006c:	01712623          	sw	s7,12(sp)
80000070:	01812423          	sw	s8,8(sp)
80000074:	01912223          	sw	s9,4(sp)
80000078:	02112623          	sw	ra,44(sp)
8000007c:	00088c93          	addi	s9,a7,0
80000080:	02912223          	sw	s1,36(sp)
80000084:	03212023          	sw	s2,32(sp)
    const size_t start_idx = idx;

    // pad spaces up to given width
    if (!(flags & FLAGS_LEFT) && !(flags & FLAGS_ZEROPAD)) {
80000088:	0038f893          	andi	a7,a7,3
                       unsigned int width, unsigned int flags) {
8000008c:	00050993          	addi	s3,a0,0
80000090:	00058a13          	addi	s4,a1,0
80000094:	00060b13          	addi	s6,a2,0
80000098:	00068a93          	addi	s5,a3,0
8000009c:	00070b93          	addi	s7,a4,0
800000a0:	00078413          	addi	s0,a5,0
800000a4:	00080c13          	addi	s8,a6,0
    if (!(flags & FLAGS_LEFT) && !(flags & FLAGS_ZEROPAD)) {
800000a8:	0c089263          	bne	a7,zero,8000016c <_out_rev+0x118>
        for (size_t i = len; i < width; i++) {
800000ac:	40f80933          	sub	s2,a6,a5
800000b0:	00c90933          	add	s2,s2,a2
800000b4:	00060493          	addi	s1,a2,0
800000b8:	0d07f263          	bgeu	a5,a6,8000017c <_out_rev+0x128>
            out(' ', buffer, idx++, maxlen);
800000bc:	00048613          	addi	a2,s1,0
800000c0:	000a8693          	addi	a3,s5,0
800000c4:	00148493          	addi	s1,s1,1
800000c8:	000a0593          	addi	a1,s4,0
800000cc:	02000513          	addi	a0,zero,32
800000d0:	000980e7          	jalr	ra,0(s3)
        for (size_t i = len; i < width; i++) {
800000d4:	ff2494e3          	bne	s1,s2,800000bc <_out_rev+0x68>
        }
    }

    // reverse string
    while (len) {
800000d8:	04040e63          	beq	s0,zero,80000134 <_out_rev+0xe0>
800000dc:	00890933          	add	s2,s2,s0
800000e0:	40890633          	sub	a2,s2,s0
        out(buf[--len], buffer, idx++, maxlen);
800000e4:	fff40413          	addi	s0,s0,-1
800000e8:	008b87b3          	add	a5,s7,s0
800000ec:	0007c503          	lbu	a0,0(a5)
800000f0:	000a8693          	addi	a3,s5,0
800000f4:	000a0593          	addi	a1,s4,0
800000f8:	00090493          	addi	s1,s2,0
800000fc:	000980e7          	jalr	ra,0(s3)
    while (len) {
80000100:	fe0410e3          	bne	s0,zero,800000e0 <_out_rev+0x8c>
    }

    // append pad spaces up to given width
    if (flags & FLAGS_LEFT) {
80000104:	002cfc93          	andi	s9,s9,2
80000108:	020c8663          	beq	s9,zero,80000134 <_out_rev+0xe0>
        while (idx - start_idx < width) {
8000010c:	41648b33          	sub	s6,s1,s6
80000110:	038b7263          	bgeu	s6,s8,80000134 <_out_rev+0xe0>
            out(' ', buffer, idx++, maxlen);
80000114:	00048613          	addi	a2,s1,0
80000118:	000a8693          	addi	a3,s5,0
8000011c:	000a0593          	addi	a1,s4,0
80000120:	02000513          	addi	a0,zero,32
        while (idx - start_idx < width) {
80000124:	001b0b13          	addi	s6,s6,1
            out(' ', buffer, idx++, maxlen);
80000128:	00148493          	addi	s1,s1,1
8000012c:	000980e7          	jalr	ra,0(s3)
        while (idx - start_idx < width) {
80000130:	ff8b62e3          	bltu	s6,s8,80000114 <_out_rev+0xc0>
        }
    }

    return idx;
}
80000134:	02c12083          	lw	ra,44(sp)
80000138:	02812403          	lw	s0,40(sp)
8000013c:	02012903          	lw	s2,32(sp)
80000140:	01c12983          	lw	s3,28(sp)
80000144:	01812a03          	lw	s4,24(sp)
80000148:	01412a83          	lw	s5,20(sp)
8000014c:	01012b03          	lw	s6,16(sp)
80000150:	00c12b83          	lw	s7,12(sp)
80000154:	00812c03          	lw	s8,8(sp)
80000158:	00412c83          	lw	s9,4(sp)
8000015c:	00048513          	addi	a0,s1,0
80000160:	02412483          	lw	s1,36(sp)
80000164:	03010113          	addi	sp,sp,48
80000168:	00008067          	jalr	zero,0(ra)
    while (len) {
8000016c:	00060913          	addi	s2,a2,0
80000170:	00060493          	addi	s1,a2,0
80000174:	f60794e3          	bne	a5,zero,800000dc <_out_rev+0x88>
80000178:	f8dff06f          	jal	zero,80000104 <_out_rev+0xb0>
8000017c:	00060913          	addi	s2,a2,0
80000180:	f4079ee3          	bne	a5,zero,800000dc <_out_rev+0x88>
80000184:	fb1ff06f          	jal	zero,80000134 <_out_rev+0xe0>

80000188 <_ntoa_long>:

// internal itoa for 'long' type
static size_t _ntoa_long(out_fct_type out, char *buffer, size_t idx,
                         size_t maxlen, unsigned long value, bool negative,
                         unsigned long base, unsigned int prec,
                         unsigned int width, unsigned int flags) {
80000188:	fc010113          	addi	sp,sp,-64
8000018c:	02912a23          	sw	s1,52(sp)
80000190:	04412483          	lw	s1,68(sp)
80000194:	03212823          	sw	s2,48(sp)
80000198:	03312623          	sw	s3,44(sp)
8000019c:	03412423          	sw	s4,40(sp)
800001a0:	02112e23          	sw	ra,60(sp)
800001a4:	03512223          	sw	s5,36(sp)
800001a8:	00080e93          	addi	t4,a6,0
800001ac:	00070e13          	addi	t3,a4,0
800001b0:	04012803          	lw	a6,64(sp)
800001b4:	00078993          	addi	s3,a5,0
800001b8:	00088913          	addi	s2,a7,0
    if (!value) {
        flags &= ~FLAGS_HASH;
    }

    // write if precision != 0 and value is != 0
    if (!(flags & FLAGS_PRECISION) || value) {
800001bc:	4004fa13          	andi	s4,s1,1024
    if (!value) {
800001c0:	0e070263          	beq	a4,zero,800002a4 <_ntoa_long+0x11c>
800001c4:	0054d793          	srli	a5,s1,0x5
800001c8:	02812c23          	sw	s0,56(sp)
    if (!(flags & FLAGS_PRECISION) || value) {
800001cc:	0017f793          	andi	a5,a5,1
    if (flags & FLAGS_HASH) {
800001d0:	0104fa93          	andi	s5,s1,16
800001d4:	06100293          	addi	t0,zero,97
800001d8:	0e079863          	bne	a5,zero,800002c8 <_ntoa_long+0x140>
        do {
            const char digit = (char)(value % base);
            buf[len++] =
800001dc:	ff628293          	addi	t0,t0,-10
                digit < 10 ? '0' + digit
                           : (flags & FLAGS_UPPERCASE ? 'A' : 'a') + digit - 10;
800001e0:	00000793          	addi	a5,zero,0
800001e4:	00010713          	addi	a4,sp,0
            buf[len++] =
800001e8:	00900393          	addi	t2,zero,9
            value /= base;
        } while (value && (len < PRINTF_NTOA_BUFFER_SIZE));
800001ec:	02000413          	addi	s0,zero,32
800001f0:	00c0006f          	jal	zero,800001fc <_ntoa_long+0x74>
800001f4:	10878a63          	beq	a5,s0,80000308 <_ntoa_long+0x180>
            value /= base;
800001f8:	00030e13          	addi	t3,t1,0
            const char digit = (char)(value % base);
800001fc:	03de7f33          	remu	t5,t3,t4
80000200:	0fff7313          	andi	t1,t5,255
            buf[len++] =
80000204:	03030f93          	addi	t6,t1,48
80000208:	00530333          	add	t1,t1,t0
8000020c:	0ff37313          	andi	t1,t1,255
80000210:	01e3e463          	bltu	t2,t5,80000218 <_ntoa_long+0x90>
80000214:	0ffff313          	andi	t1,t6,255
80000218:	00178793          	addi	a5,a5,1
8000021c:	00f70f33          	add	t5,a4,a5
80000220:	fe6f0fa3          	sb	t1,-1(t5)
            value /= base;
80000224:	03de5333          	divu	t1,t3,t4
        } while (value && (len < PRINTF_NTOA_BUFFER_SIZE));
80000228:	fdde76e3          	bgeu	t3,t4,800001f4 <_ntoa_long+0x6c>
    if (!(flags & FLAGS_LEFT)) {
8000022c:	0024f893          	andi	a7,s1,2
80000230:	14089263          	bne	a7,zero,80000374 <_ntoa_long+0x1ec>
        if (width && (flags & FLAGS_ZEROPAD) &&
80000234:	12080e63          	beq	a6,zero,80000370 <_ntoa_long+0x1e8>
80000238:	0014ff13          	andi	t5,s1,1
8000023c:	240f0663          	beq	t5,zero,80000488 <_ntoa_long+0x300>
80000240:	2e098463          	beq	s3,zero,80000528 <_ntoa_long+0x3a0>
            width--;
80000244:	03812403          	lw	s0,56(sp)
80000248:	fff80813          	addi	a6,a6,-1
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
8000024c:	0d27ec63          	bltu	a5,s2,80000324 <_ntoa_long+0x19c>
        while ((flags & FLAGS_ZEROPAD) && (len < width) &&
80000250:	0f07ec63          	bltu	a5,a6,80000348 <_ntoa_long+0x1c0>
80000254:	00080313          	addi	t1,a6,0
80000258:	00078813          	addi	a6,a5,0
    if (flags & FLAGS_HASH) {
8000025c:	1c0a8c63          	beq	s5,zero,80000434 <_ntoa_long+0x2ac>
        if (!(flags & FLAGS_PRECISION) && len &&
80000260:	2e0a1e63          	bne	s4,zero,8000055c <_ntoa_long+0x3d4>
80000264:	46081463          	bne	a6,zero,800006cc <_ntoa_long+0x544>
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
80000268:	01000793          	addi	a5,zero,16
8000026c:	34fe8e63          	beq	t4,a5,800005c8 <_ntoa_long+0x440>
        } else if ((base == 2U) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000270:	00200793          	addi	a5,zero,2
80000274:	38fe8063          	beq	t4,a5,800005f4 <_ntoa_long+0x46c>
            buf[len++] = '0';
80000278:	03000793          	addi	a5,zero,48
8000027c:	00f10023          	sb	a5,0(sp)
80000280:	00030813          	addi	a6,t1,0
80000284:	00048893          	addi	a7,s1,0
80000288:	00100793          	addi	a5,zero,1
        if (negative) {
8000028c:	18098663          	beq	s3,zero,80000418 <_ntoa_long+0x290>
            buf[len++] = '-';
80000290:	00278333          	add	t1,a5,sp
80000294:	02d00e13          	addi	t3,zero,45
80000298:	01c30023          	sb	t3,0(t1)
8000029c:	00178793          	addi	a5,a5,1
800002a0:	1480006f          	jal	zero,800003e8 <_ntoa_long+0x260>
        flags &= ~FLAGS_HASH;
800002a4:	fef4f893          	andi	a7,s1,-17
    if (!(flags & FLAGS_PRECISION) || value) {
800002a8:	020a1463          	bne	s4,zero,800002d0 <_ntoa_long+0x148>
        flags &= ~FLAGS_HASH;
800002ac:	00088493          	addi	s1,a7,0
800002b0:	0054d793          	srli	a5,s1,0x5
800002b4:	02812c23          	sw	s0,56(sp)
800002b8:	0017f793          	andi	a5,a5,1
    if (!(flags & FLAGS_PRECISION) || value) {
800002bc:	00000a93          	addi	s5,zero,0
800002c0:	06100293          	addi	t0,zero,97
800002c4:	f0078ce3          	beq	a5,zero,800001dc <_ntoa_long+0x54>
800002c8:	04100293          	addi	t0,zero,65
800002cc:	f11ff06f          	jal	zero,800001dc <_ntoa_long+0x54>
    if (!(flags & FLAGS_LEFT)) {
800002d0:	0024f793          	andi	a5,s1,2
800002d4:	12079c63          	bne	a5,zero,8000040c <_ntoa_long+0x284>
        if (width && (flags & FLAGS_ZEROPAD) &&
800002d8:	22080663          	beq	a6,zero,80000504 <_ntoa_long+0x37c>
800002dc:	0014ff13          	andi	t5,s1,1
800002e0:	280f0663          	beq	t5,zero,8000056c <_ntoa_long+0x3e4>
800002e4:	32098663          	beq	s3,zero,80000610 <_ntoa_long+0x488>
            width--;
800002e8:	fff80813          	addi	a6,a6,-1
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
800002ec:	28091263          	bne	s2,zero,80000570 <_ntoa_long+0x3e8>
800002f0:	00010713          	addi	a4,sp,0
        while ((flags & FLAGS_ZEROPAD) && (len < width) &&
800002f4:	0e080663          	beq	a6,zero,800003e0 <_ntoa_long+0x258>
        flags &= ~FLAGS_HASH;
800002f8:	00088493          	addi	s1,a7,0
        while ((flags & FLAGS_ZEROPAD) && (len < width) &&
800002fc:	00000a93          	addi	s5,zero,0
    if (!(flags & FLAGS_PRECISION) || value) {
80000300:	40000a13          	addi	s4,zero,1024
80000304:	0440006f          	jal	zero,80000348 <_ntoa_long+0x1c0>
    if (!(flags & FLAGS_LEFT)) {
80000308:	0024f893          	andi	a7,s1,2
8000030c:	0a089863          	bne	a7,zero,800003bc <_ntoa_long+0x234>
        if (width && (flags & FLAGS_ZEROPAD) &&
80000310:	f20814e3          	bne	a6,zero,80000238 <_ntoa_long+0xb0>
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000314:	2b27f263          	bgeu	a5,s2,800005b8 <_ntoa_long+0x430>
80000318:	03812403          	lw	s0,56(sp)
        if (width && (flags & FLAGS_ZEROPAD) &&
8000031c:	0014ff13          	andi	t5,s1,1
80000320:	00000813          	addi	a6,zero,0
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000324:	02000313          	addi	t1,zero,32
            buf[len++] = '0';
80000328:	03000e13          	addi	t3,zero,48
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
8000032c:	00678a63          	beq	a5,t1,80000340 <_ntoa_long+0x1b8>
            buf[len++] = '0';
80000330:	00178793          	addi	a5,a5,1
80000334:	00f708b3          	add	a7,a4,a5
80000338:	ffc88fa3          	sb	t3,-1(a7)
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
8000033c:	ff27e8e3          	bltu	a5,s2,8000032c <_ntoa_long+0x1a4>
        while ((flags & FLAGS_ZEROPAD) && (len < width) &&
80000340:	100f0663          	beq	t5,zero,8000044c <_ntoa_long+0x2c4>
80000344:	1107f463          	bgeu	a5,a6,8000044c <_ntoa_long+0x2c4>
80000348:	02000893          	addi	a7,zero,32
            buf[len++] = '0';
8000034c:	03000e13          	addi	t3,zero,48
        while ((flags & FLAGS_ZEROPAD) && (len < width) &&
80000350:	11178663          	beq	a5,a7,8000045c <_ntoa_long+0x2d4>
            buf[len++] = '0';
80000354:	00178793          	addi	a5,a5,1
80000358:	00f70333          	add	t1,a4,a5
8000035c:	ffc30fa3          	sb	t3,-1(t1)
        while ((flags & FLAGS_ZEROPAD) && (len < width) &&
80000360:	ff0798e3          	bne	a5,a6,80000350 <_ntoa_long+0x1c8>
80000364:	00080313          	addi	t1,a6,0
    if (flags & FLAGS_HASH) {
80000368:	ee0a9ce3          	bne	s5,zero,80000260 <_ntoa_long+0xd8>
8000036c:	0c80006f          	jal	zero,80000434 <_ntoa_long+0x2ac>
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000370:	fb27e4e3          	bltu	a5,s2,80000318 <_ntoa_long+0x190>
    if (flags & FLAGS_HASH) {
80000374:	060a8263          	beq	s5,zero,800003d8 <_ntoa_long+0x250>
        if (!(flags & FLAGS_PRECISION) && len &&
80000378:	1a0a1263          	bne	s4,zero,8000051c <_ntoa_long+0x394>
8000037c:	03812403          	lw	s0,56(sp)
80000380:	20f90263          	beq	s2,a5,80000584 <_ntoa_long+0x3fc>
80000384:	00048893          	addi	a7,s1,0
            ((len == prec) || (len == width))) {
80000388:	1f078e63          	beq	a5,a6,80000584 <_ntoa_long+0x3fc>
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
8000038c:	01000313          	addi	t1,zero,16
80000390:	126e8263          	beq	t4,t1,800004b4 <_ntoa_long+0x32c>
        } else if ((base == 2U) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000394:	00200313          	addi	t1,zero,2
80000398:	146e8663          	beq	t4,t1,800004e4 <_ntoa_long+0x35c>
        if (len < PRINTF_NTOA_BUFFER_SIZE) {
8000039c:	02000313          	addi	t1,zero,32
800003a0:	04678463          	beq	a5,t1,800003e8 <_ntoa_long+0x260>
            buf[len++] = '0';
800003a4:	00078313          	addi	t1,a5,0
800003a8:	00178793          	addi	a5,a5,1
800003ac:	00230333          	add	t1,t1,sp
800003b0:	03000e13          	addi	t3,zero,48
800003b4:	01c30023          	sb	t3,0(t1)
800003b8:	0280006f          	jal	zero,800003e0 <_ntoa_long+0x258>
    if (flags & FLAGS_HASH) {
800003bc:	00048893          	addi	a7,s1,0
800003c0:	080a8263          	beq	s5,zero,80000444 <_ntoa_long+0x2bc>
        if (!(flags & FLAGS_PRECISION) && len &&
800003c4:	080a1063          	bne	s4,zero,80000444 <_ntoa_long+0x2bc>
800003c8:	22f90e63          	beq	s2,a5,80000604 <_ntoa_long+0x47c>
            ((len == prec) || (len == width))) {
800003cc:	22f80c63          	beq	a6,a5,80000604 <_ntoa_long+0x47c>
800003d0:	03812403          	lw	s0,56(sp)
800003d4:	fb9ff06f          	jal	zero,8000038c <_ntoa_long+0x204>
800003d8:	03812403          	lw	s0,56(sp)
    if (flags & FLAGS_HASH) {
800003dc:	00048893          	addi	a7,s1,0
    if (len < PRINTF_NTOA_BUFFER_SIZE) {
800003e0:	02000313          	addi	t1,zero,32
800003e4:	ea6794e3          	bne	a5,t1,8000028c <_ntoa_long+0x104>
    return _out_rev(out, buffer, idx, maxlen, buf, len, width, flags);
800003e8:	c6dff0ef          	jal	ra,80000054 <_out_rev>
    }

    return _ntoa_format(out, buffer, idx, maxlen, buf, len, negative,
                        (unsigned int)base, prec, width, flags);
}
800003ec:	03c12083          	lw	ra,60(sp)
800003f0:	03412483          	lw	s1,52(sp)
800003f4:	03012903          	lw	s2,48(sp)
800003f8:	02c12983          	lw	s3,44(sp)
800003fc:	02812a03          	lw	s4,40(sp)
80000400:	02412a83          	lw	s5,36(sp)
80000404:	04010113          	addi	sp,sp,64
80000408:	00008067          	jalr	zero,0(ra)
    size_t len = 0U;
8000040c:	00000793          	addi	a5,zero,0
80000410:	00010713          	addi	a4,sp,0
        if (negative) {
80000414:	e6099ee3          	bne	s3,zero,80000290 <_ntoa_long+0x108>
        } else if (flags & FLAGS_PLUS) {
80000418:	0048f313          	andi	t1,a7,4
8000041c:	06030c63          	beq	t1,zero,80000494 <_ntoa_long+0x30c>
            buf[len++] = '+'; // ignore the space if the '+' exists
80000420:	00278333          	add	t1,a5,sp
80000424:	02b00e13          	addi	t3,zero,43
80000428:	01c30023          	sb	t3,0(t1)
8000042c:	00178793          	addi	a5,a5,1
80000430:	fb9ff06f          	jal	zero,800003e8 <_ntoa_long+0x260>
80000434:	00080793          	addi	a5,a6,0
80000438:	00048893          	addi	a7,s1,0
8000043c:	00030813          	addi	a6,t1,0
80000440:	fa1ff06f          	jal	zero,800003e0 <_ntoa_long+0x258>
80000444:	03812403          	lw	s0,56(sp)
80000448:	fa1ff06f          	jal	zero,800003e8 <_ntoa_long+0x260>
    if (flags & FLAGS_HASH) {
8000044c:	080a8863          	beq	s5,zero,800004dc <_ntoa_long+0x354>
        if (!(flags & FLAGS_PRECISION) && len &&
80000450:	00048893          	addi	a7,s1,0
80000454:	f20a06e3          	beq	s4,zero,80000380 <_ntoa_long+0x1f8>
80000458:	f35ff06f          	jal	zero,8000038c <_ntoa_long+0x204>
    if (flags & FLAGS_HASH) {
8000045c:	00048893          	addi	a7,s1,0
80000460:	f80a84e3          	beq	s5,zero,800003e8 <_ntoa_long+0x260>
        if (!(flags & FLAGS_PRECISION) && len &&
80000464:	f80a12e3          	bne	s4,zero,800003e8 <_ntoa_long+0x260>
80000468:	f0f91ee3          	bne	s2,a5,80000384 <_ntoa_long+0x1fc>
            len--;
8000046c:	01f00313          	addi	t1,zero,31
            if (len && (base == 16U)) {
80000470:	01000893          	addi	a7,zero,16
80000474:	1d1e8c63          	beq	t4,a7,8000064c <_ntoa_long+0x4c4>
        } else if ((base == 2U) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000478:	00200893          	addi	a7,zero,2
8000047c:	131e8a63          	beq	t4,a7,800005b0 <_ntoa_long+0x428>
            buf[len++] = '0';
80000480:	00048893          	addi	a7,s1,0
80000484:	f29ff06f          	jal	zero,800003ac <_ntoa_long+0x224>
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000488:	ef27f6e3          	bgeu	a5,s2,80000374 <_ntoa_long+0x1ec>
8000048c:	03812403          	lw	s0,56(sp)
80000490:	e95ff06f          	jal	zero,80000324 <_ntoa_long+0x19c>
        } else if (flags & FLAGS_SPACE) {
80000494:	0088f313          	andi	t1,a7,8
80000498:	f40308e3          	beq	t1,zero,800003e8 <_ntoa_long+0x260>
            buf[len++] = ' ';
8000049c:	02000e13          	addi	t3,zero,32
800004a0:	01c78333          	add	t1,a5,t3
800004a4:	00230333          	add	t1,t1,sp
800004a8:	ffc30023          	sb	t3,-32(t1)
800004ac:	00178793          	addi	a5,a5,1
800004b0:	f39ff06f          	jal	zero,800003e8 <_ntoa_long+0x260>
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
800004b4:	0204f493          	andi	s1,s1,32
800004b8:	02000313          	addi	t1,zero,32
800004bc:	08049463          	bne	s1,zero,80000544 <_ntoa_long+0x3bc>
800004c0:	f26784e3          	beq	a5,t1,800003e8 <_ntoa_long+0x260>
            buf[len++] = 'x';
800004c4:	00678333          	add	t1,a5,t1
800004c8:	07800e13          	addi	t3,zero,120
800004cc:	00230333          	add	t1,t1,sp
800004d0:	ffc30023          	sb	t3,-32(t1)
800004d4:	00178793          	addi	a5,a5,1
800004d8:	ec5ff06f          	jal	zero,8000039c <_ntoa_long+0x214>
    if (flags & FLAGS_HASH) {
800004dc:	00048893          	addi	a7,s1,0
800004e0:	f01ff06f          	jal	zero,800003e0 <_ntoa_long+0x258>
        } else if ((base == 2U) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
800004e4:	02000313          	addi	t1,zero,32
800004e8:	f06780e3          	beq	a5,t1,800003e8 <_ntoa_long+0x260>
            buf[len++] = 'X';
800004ec:	00078313          	addi	t1,a5,0
800004f0:	00178793          	addi	a5,a5,1
            buf[len++] = 'b';
800004f4:	00230333          	add	t1,t1,sp
800004f8:	06200e13          	addi	t3,zero,98
800004fc:	01c30023          	sb	t3,0(t1)
80000500:	e9dff06f          	jal	zero,8000039c <_ntoa_long+0x214>
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000504:	1a090663          	beq	s2,zero,800006b0 <_ntoa_long+0x528>
        flags &= ~FLAGS_HASH;
80000508:	00088493          	addi	s1,a7,0
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
8000050c:	00000a93          	addi	s5,zero,0
    if (!(flags & FLAGS_PRECISION) || value) {
80000510:	40000a13          	addi	s4,zero,1024
80000514:	00010713          	addi	a4,sp,0
80000518:	e05ff06f          	jal	zero,8000031c <_ntoa_long+0x194>
8000051c:	03812403          	lw	s0,56(sp)
        if (!(flags & FLAGS_PRECISION) && len &&
80000520:	00048893          	addi	a7,s1,0
80000524:	e69ff06f          	jal	zero,8000038c <_ntoa_long+0x204>
            (negative || (flags & (FLAGS_PLUS | FLAGS_SPACE)))) {
80000528:	00c4f893          	andi	a7,s1,12
8000052c:	03812403          	lw	s0,56(sp)
80000530:	00088463          	beq	a7,zero,80000538 <_ntoa_long+0x3b0>
            width--;
80000534:	fff80813          	addi	a6,a6,-1
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000538:	00100f13          	addi	t5,zero,1
8000053c:	df27e4e3          	bltu	a5,s2,80000324 <_ntoa_long+0x19c>
80000540:	d11ff06f          	jal	zero,80000250 <_ntoa_long+0xc8>
        } else if ((base == 16U) && (flags & FLAGS_UPPERCASE) &&
80000544:	ea6782e3          	beq	a5,t1,800003e8 <_ntoa_long+0x260>
            buf[len++] = 'X';
80000548:	00278333          	add	t1,a5,sp
8000054c:	05800e13          	addi	t3,zero,88
80000550:	01c30023          	sb	t3,0(t1)
80000554:	00178793          	addi	a5,a5,1
80000558:	e45ff06f          	jal	zero,8000039c <_ntoa_long+0x214>
8000055c:	00080793          	addi	a5,a6,0
80000560:	00048893          	addi	a7,s1,0
80000564:	00030813          	addi	a6,t1,0
80000568:	e25ff06f          	jal	zero,8000038c <_ntoa_long+0x204>
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
8000056c:	14090263          	beq	s2,zero,800006b0 <_ntoa_long+0x528>
        flags &= ~FLAGS_HASH;
80000570:	00088493          	addi	s1,a7,0
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000574:	00000a93          	addi	s5,zero,0
    if (!(flags & FLAGS_PRECISION) || value) {
80000578:	40000a13          	addi	s4,zero,1024
8000057c:	00010713          	addi	a4,sp,0
80000580:	da5ff06f          	jal	zero,80000324 <_ntoa_long+0x19c>
            len--;
80000584:	fff78313          	addi	t1,a5,-1
            if (len && (base == 16U)) {
80000588:	ee0314e3          	bne	t1,zero,80000470 <_ntoa_long+0x2e8>
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
8000058c:	01000793          	addi	a5,zero,16
80000590:	08fe8e63          	beq	t4,a5,8000062c <_ntoa_long+0x4a4>
        } else if ((base == 2U) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000594:	00200793          	addi	a5,zero,2
80000598:	0cfe8a63          	beq	t4,a5,8000066c <_ntoa_long+0x4e4>
            buf[len++] = '0';
8000059c:	03000793          	addi	a5,zero,48
800005a0:	00f10023          	sb	a5,0(sp)
800005a4:	00048893          	addi	a7,s1,0
800005a8:	00100793          	addi	a5,zero,1
800005ac:	ce1ff06f          	jal	zero,8000028c <_ntoa_long+0x104>
        } else if ((base == 2U) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
800005b0:	00048893          	addi	a7,s1,0
800005b4:	f41ff06f          	jal	zero,800004f4 <_ntoa_long+0x36c>
    if (flags & FLAGS_HASH) {
800005b8:	100a9063          	bne	s5,zero,800006b8 <_ntoa_long+0x530>
800005bc:	03812403          	lw	s0,56(sp)
800005c0:	00048893          	addi	a7,s1,0
800005c4:	e25ff06f          	jal	zero,800003e8 <_ntoa_long+0x260>
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
800005c8:	01a49793          	slli	a5,s1,0x1a
800005cc:	41f7d793          	srai	a5,a5,0x1f
800005d0:	fe07f793          	andi	a5,a5,-32
800005d4:	07878793          	addi	a5,a5,120
            buf[len++] = '0';
800005d8:	03000813          	addi	a6,zero,48
            buf[len++] = 'X';
800005dc:	00f10023          	sb	a5,0(sp)
            buf[len++] = '0';
800005e0:	010100a3          	sb	a6,1(sp)
800005e4:	00030813          	addi	a6,t1,0
800005e8:	00048893          	addi	a7,s1,0
800005ec:	00200793          	addi	a5,zero,2
800005f0:	c9dff06f          	jal	zero,8000028c <_ntoa_long+0x104>
            buf[len++] = 'b';
800005f4:	000037b7          	lui	a5,0x3
800005f8:	06278793          	addi	a5,a5,98 # 3062 <main-0x7fffcf9e>
800005fc:	00f11023          	sh	a5,0(sp)
    if (len < PRINTF_NTOA_BUFFER_SIZE) {
80000600:	fe5ff06f          	jal	zero,800005e4 <_ntoa_long+0x45c>
80000604:	03812403          	lw	s0,56(sp)
            len--;
80000608:	01f00313          	addi	t1,zero,31
8000060c:	e65ff06f          	jal	zero,80000470 <_ntoa_long+0x2e8>
            (negative || (flags & (FLAGS_PLUS | FLAGS_SPACE)))) {
80000610:	00c4fa93          	andi	s5,s1,12
        flags &= ~FLAGS_HASH;
80000614:	00088493          	addi	s1,a7,0
            (negative || (flags & (FLAGS_PLUS | FLAGS_SPACE)))) {
80000618:	060a9263          	bne	s5,zero,8000067c <_ntoa_long+0x4f4>
    if (!(flags & FLAGS_PRECISION) || value) {
8000061c:	40000a13          	addi	s4,zero,1024
80000620:	00010713          	addi	a4,sp,0
        while ((len < prec) && (len < PRINTF_NTOA_BUFFER_SIZE)) {
80000624:	d00910e3          	bne	s2,zero,80000324 <_ntoa_long+0x19c>
80000628:	d21ff06f          	jal	zero,80000348 <_ntoa_long+0x1c0>
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
8000062c:	0204f793          	andi	a5,s1,32
80000630:	06079863          	bne	a5,zero,800006a0 <_ntoa_long+0x518>
            buf[len++] = 'x';
80000634:	000037b7          	lui	a5,0x3
80000638:	07878793          	addi	a5,a5,120 # 3078 <main-0x7fffcf88>
8000063c:	00f11023          	sh	a5,0(sp)
            buf[len++] = '0';
80000640:	00048893          	addi	a7,s1,0
80000644:	00200793          	addi	a5,zero,2
80000648:	c45ff06f          	jal	zero,8000028c <_ntoa_long+0x104>
                len--;
8000064c:	ffe78893          	addi	a7,a5,-2
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
80000650:	0204fe13          	andi	t3,s1,32
            buf[len++] = 'x';
80000654:	011708b3          	add	a7,a4,a7
        if ((base == 16U) && !(flags & FLAGS_UPPERCASE) &&
80000658:	020e1c63          	bne	t3,zero,80000690 <_ntoa_long+0x508>
            buf[len++] = 'x';
8000065c:	07800e13          	addi	t3,zero,120
80000660:	01c88023          	sb	t3,0(a7)
            buf[len++] = '0';
80000664:	00048893          	addi	a7,s1,0
80000668:	d45ff06f          	jal	zero,800003ac <_ntoa_long+0x224>
            buf[len++] = 'b';
8000066c:	000037b7          	lui	a5,0x3
80000670:	06278793          	addi	a5,a5,98 # 3062 <main-0x7fffcf9e>
80000674:	00f11023          	sh	a5,0(sp)
    if (len < PRINTF_NTOA_BUFFER_SIZE) {
80000678:	fc9ff06f          	jal	zero,80000640 <_ntoa_long+0x4b8>
            (negative || (flags & (FLAGS_PLUS | FLAGS_SPACE)))) {
8000067c:	00000a93          	addi	s5,zero,0
    if (!(flags & FLAGS_PRECISION) || value) {
80000680:	40000a13          	addi	s4,zero,1024
80000684:	00010713          	addi	a4,sp,0
            width--;
80000688:	fff80813          	addi	a6,a6,-1
8000068c:	eadff06f          	jal	zero,80000538 <_ntoa_long+0x3b0>
            buf[len++] = 'X';
80000690:	05800e13          	addi	t3,zero,88
80000694:	01c88023          	sb	t3,0(a7)
            buf[len++] = '0';
80000698:	00048893          	addi	a7,s1,0
8000069c:	d11ff06f          	jal	zero,800003ac <_ntoa_long+0x224>
            buf[len++] = 'X';
800006a0:	000037b7          	lui	a5,0x3
800006a4:	05878793          	addi	a5,a5,88 # 3058 <main-0x7fffcfa8>
800006a8:	00f11023          	sh	a5,0(sp)
    if (len < PRINTF_NTOA_BUFFER_SIZE) {
800006ac:	f95ff06f          	jal	zero,80000640 <_ntoa_long+0x4b8>
800006b0:	00010713          	addi	a4,sp,0
800006b4:	bd9ff06f          	jal	zero,8000028c <_ntoa_long+0x104>
    if (flags & FLAGS_HASH) {
800006b8:	03812403          	lw	s0,56(sp)
800006bc:	00078813          	addi	a6,a5,0
800006c0:	00000313          	addi	t1,zero,0
        if (!(flags & FLAGS_PRECISION) && len &&
800006c4:	ba0a00e3          	beq	s4,zero,80000264 <_ntoa_long+0xdc>
800006c8:	e95ff06f          	jal	zero,8000055c <_ntoa_long+0x3d4>
800006cc:	00080793          	addi	a5,a6,0
800006d0:	00030813          	addi	a6,t1,0
800006d4:	cadff06f          	jal	zero,80000380 <_ntoa_long+0x1f8>

800006d8 <_out_fct>:
    if (character) {
800006d8:	00050863          	beq	a0,zero,800006e8 <_out_fct+0x10>
        ((out_fct_wrap_type *)buffer)
800006dc:	0005a783          	lw	a5,0(a1)
800006e0:	0045a583          	lw	a1,4(a1)
800006e4:	00078067          	jalr	zero,0(a5)
}
800006e8:	00008067          	jalr	zero,0(ra)

800006ec <_ftoa>:
#endif

// internal ftoa for fixed decimal floating point
static size_t _ftoa(out_fct_type out, char *buffer, size_t idx, size_t maxlen,
                    double value, unsigned int prec, unsigned int width,
                    unsigned int flags) {
800006ec:	fa010113          	addi	sp,sp,-96
800006f0:	00f12623          	sw	a5,12(sp)
800006f4:	00e12423          	sw	a4,8(sp)
800006f8:	00813787          	fld	fa5,8(sp)
800006fc:	04812c23          	sw	s0,88(sp)
80000700:	04912a23          	sw	s1,84(sp)
    static const double pow10[] = {1,         10,        100,     1000,
                                   10000,     100000,    1000000, 10000000,
                                   100000000, 1000000000};

    // test for special values
    if (value != value)
80000704:	a2f7a7d3          	feq.d	a5,fa5,fa5
                    unsigned int flags) {
80000708:	05212823          	sw	s2,80(sp)
8000070c:	05312623          	sw	s3,76(sp)
80000710:	05412423          	sw	s4,72(sp)
80000714:	05512223          	sw	s5,68(sp)
80000718:	04112e23          	sw	ra,92(sp)
8000071c:	05612023          	sw	s6,64(sp)
80000720:	06012a83          	lw	s5,96(sp)
80000724:	00050413          	addi	s0,a0,0
80000728:	00058493          	addi	s1,a1,0
8000072c:	00060a13          	addi	s4,a2,0
80000730:	00068913          	addi	s2,a3,0
80000734:	00088993          	addi	s3,a7,0
    if (value != value)
80000738:	16078c63          	beq	a5,zero,800008b0 <_ftoa+0x1c4>
        return _out_rev(out, buffer, idx, maxlen, "nan", 3, width, flags);
    if (value < -DBL_MAX)
8000073c:	8081b707          	fld	fa4,-2040(gp) # 80003008 <__DATA_BEGIN__+0x8>
80000740:	a2e797d3          	flt.d	a5,fa5,fa4
80000744:	2a079c63          	bne	a5,zero,800009fc <_ftoa+0x310>
        return _out_rev(out, buffer, idx, maxlen, "fni-", 4, width, flags);
    if (value > DBL_MAX)
80000748:	8101b707          	fld	fa4,-2032(gp) # 80003010 <__DATA_BEGIN__+0x10>
8000074c:	a2f717d3          	flt.d	a5,fa4,fa5
80000750:	10079663          	bne	a5,zero,8000085c <_ftoa+0x170>
                        (flags & FLAGS_PLUS) ? 4U : 3U, width, flags);

    // test for very large values
    // standard printf behavior is to print EVERY whole number digit -- which
    // could be 100s of characters overflowing your buffers == bad
    if ((value > PRINTF_MAX_FLOAT) || (value < -PRINTF_MAX_FLOAT)) {
80000754:	8181b707          	fld	fa4,-2024(gp) # 80003018 <__DATA_BEGIN__+0x18>
80000758:	a2f717d3          	flt.d	a5,fa4,fa5
8000075c:	24079a63          	bne	a5,zero,800009b0 <_ftoa+0x2c4>
80000760:	8201b707          	fld	fa4,-2016(gp) # 80003020 <__DATA_BEGIN__+0x20>
80000764:	a2e797d3          	flt.d	a5,fa5,fa4
80000768:	24079463          	bne	a5,zero,800009b0 <_ftoa+0x2c4>
#endif
    }

    // test for negative
    bool negative = false;
    if (value < 0) {
8000076c:	d2000753          	fcvt.d.w	fa4,zero
    bool negative = false;
80000770:	00000513          	addi	a0,zero,0
    if (value < 0) {
80000774:	a2e797d3          	flt.d	a5,fa5,fa4
80000778:	22079663          	bne	a5,zero,800009a4 <_ftoa+0x2b8>
        negative = true;
        value = 0 - value;
    }

    // set default precision, if not set explicitly
    if (!(flags & FLAGS_PRECISION)) {
8000077c:	400af793          	andi	a5,s5,1024
80000780:	00079463          	bne	a5,zero,80000788 <_ftoa+0x9c>
        prec = PRINTF_DEFAULT_FLOAT_PRECISION;
80000784:	00600813          	addi	a6,zero,6
    }
    // limit precision to 9, cause a prec >= 10 can lead to overflow errors
    while ((len < PRINTF_FTOA_BUFFER_SIZE) && (prec > 9U)) {
80000788:	01010713          	addi	a4,sp,16
8000078c:	00070613          	addi	a2,a4,0
80000790:	fe080593          	addi	a1,a6,-32
        prec = PRINTF_DEFAULT_FLOAT_PRECISION;
80000794:	00080693          	addi	a3,a6,0
    while ((len < PRINTF_FTOA_BUFFER_SIZE) && (prec > 9U)) {
80000798:	00900793          	addi	a5,zero,9
        buf[len++] = '0';
8000079c:	03000893          	addi	a7,zero,48
    while ((len < PRINTF_FTOA_BUFFER_SIZE) && (prec > 9U)) {
800007a0:	30d7f663          	bgeu	a5,a3,80000aac <_ftoa+0x3c0>
        buf[len++] = '0';
800007a4:	01160023          	sb	a7,0(a2)
        prec--;
800007a8:	fff68693          	addi	a3,a3,-1
    while ((len < PRINTF_FTOA_BUFFER_SIZE) && (prec > 9U)) {
800007ac:	00160613          	addi	a2,a2,1
800007b0:	feb698e3          	bne	a3,a1,800007a0 <_ftoa+0xb4>
800007b4:	02000793          	addi	a5,zero,32
    }

    int whole = (int)value;
800007b8:	c2079653          	fcvt.w.d	a2,fa5,rtz
    double tmp = (value - whole) * pow10[prec];
800007bc:	800026b7          	lui	a3,0x80002
800007c0:	00359813          	slli	a6,a1,0x3
800007c4:	d2060753          	fcvt.d.w	fa4,a2
800007c8:	e5868693          	addi	a3,a3,-424 # 80001e58 <pow10.0>
800007cc:	010686b3          	add	a3,a3,a6
800007d0:	0ae7f753          	fsub.d	fa4,fa5,fa4
800007d4:	0006b607          	fld	fa2,0(a3)
    unsigned long frac = (unsigned long)tmp;
    diff = tmp - frac;

    if (diff > 0.5) {
800007d8:	8281b687          	fld	fa3,-2008(gp) # 80003028 <__DATA_BEGIN__+0x28>
    double tmp = (value - whole) * pow10[prec];
800007dc:	12c77753          	fmul.d	fa4,fa4,fa2
    unsigned long frac = (unsigned long)tmp;
800007e0:	c21718d3          	fcvt.wu.d	a7,fa4,rtz
    diff = tmp - frac;
800007e4:	d21885d3          	fcvt.d.wu	fa1,a7
800007e8:	0ab77753          	fsub.d	fa4,fa4,fa1
    if (diff > 0.5) {
800007ec:	a2e69853          	flt.d	a6,fa3,fa4
800007f0:	2c080463          	beq	a6,zero,80000ab8 <_ftoa+0x3cc>
        ++frac;
800007f4:	00188893          	addi	a7,a7,1
        // handle rollover, e.g. case 0.99 with prec 1 is 1.0
        if (frac >= pow10[prec]) {
800007f8:	d2188753          	fcvt.d.wu	fa4,a7
800007fc:	a2e60853          	fle.d	a6,fa2,fa4
80000800:	00080663          	beq	a6,zero,8000080c <_ftoa+0x120>
            frac = 0;
            ++whole;
80000804:	00160613          	addi	a2,a2,1
            frac = 0;
80000808:	00000893          	addi	a7,zero,0
    } else if ((frac == 0U) || (frac & 1U)) {
        // if halfway, round up if odd OR if last digit is 0
        ++frac;
    }

    if (prec == 0U) {
8000080c:	2c058063          	beq	a1,zero,80000acc <_ftoa+0x3e0>
    } else {
        unsigned int count = prec;
        // now do fractional part, as an unsigned number
        while (len < PRINTF_FTOA_BUFFER_SIZE) {
            --count;
            buf[len++] = (char)(48U + (frac % 10U));
80000810:	ccccde37          	lui	t3,0xccccd
80000814:	ccde0e13          	addi	t3,t3,-819 # cccccccd <__global_pointer$+0x4ccc94cd>
        while (len < PRINTF_FTOA_BUFFER_SIZE) {
80000818:	02000e93          	addi	t4,zero,32
            if (!(frac /= 10U)) {
8000081c:	00900f13          	addi	t5,zero,9
        while (len < PRINTF_FTOA_BUFFER_SIZE) {
80000820:	3fd78463          	beq	a5,t4,80000c08 <_ftoa+0x51c>
            buf[len++] = (char)(48U + (frac % 10U));
80000824:	03c8b833          	mulhu	a6,a7,t3
80000828:	00178793          	addi	a5,a5,1
8000082c:	00f70333          	add	t1,a4,a5
            --count;
80000830:	fff58593          	addi	a1,a1,-1
            buf[len++] = (char)(48U + (frac % 10U));
80000834:	00385813          	srli	a6,a6,0x3
80000838:	00281693          	slli	a3,a6,0x2
8000083c:	010686b3          	add	a3,a3,a6
80000840:	00169693          	slli	a3,a3,0x1
80000844:	40d886b3          	sub	a3,a7,a3
80000848:	03068693          	addi	a3,a3,48
8000084c:	fed30fa3          	sb	a3,-1(t1)
            if (!(frac /= 10U)) {
80000850:	391f7a63          	bgeu	t5,a7,80000be4 <_ftoa+0x4f8>
80000854:	00080893          	addi	a7,a6,0
80000858:	fc9ff06f          	jal	zero,80000820 <_ftoa+0x134>
                        (flags & FLAGS_PLUS) ? "fni+" : "fni",
8000085c:	004af793          	andi	a5,s5,4
        return _out_rev(out, buffer, idx, maxlen,
80000860:	12079a63          	bne	a5,zero,80000994 <_ftoa+0x2a8>
80000864:	80002737          	lui	a4,0x80002
80000868:	cd870713          	addi	a4,a4,-808 # 80001cd8 <fctprintf+0x78>
8000086c:	00300793          	addi	a5,zero,3
80000870:	00040513          	addi	a0,s0,0
            buf[len++] = ' ';
        }
    }

    return _out_rev(out, buffer, idx, maxlen, buf, len, width, flags);
}
80000874:	05812403          	lw	s0,88(sp)
80000878:	05c12083          	lw	ra,92(sp)
8000087c:	04012b03          	lw	s6,64(sp)
        return _out_rev(out, buffer, idx, maxlen,
80000880:	000a8893          	addi	a7,s5,0
80000884:	00098813          	addi	a6,s3,0
}
80000888:	04412a83          	lw	s5,68(sp)
8000088c:	04c12983          	lw	s3,76(sp)
        return _out_rev(out, buffer, idx, maxlen,
80000890:	00090693          	addi	a3,s2,0
80000894:	000a0613          	addi	a2,s4,0
}
80000898:	05012903          	lw	s2,80(sp)
8000089c:	04812a03          	lw	s4,72(sp)
        return _out_rev(out, buffer, idx, maxlen,
800008a0:	00048593          	addi	a1,s1,0
}
800008a4:	05412483          	lw	s1,84(sp)
800008a8:	06010113          	addi	sp,sp,96
        return _out_rev(out, buffer, idx, maxlen,
800008ac:	fa8ff06f          	jal	zero,80000054 <_out_rev>
800008b0:	03712e23          	sw	s7,60(sp)
800008b4:	03812c23          	sw	s8,56(sp)
800008b8:	03912a23          	sw	s9,52(sp)
    if (!(flags & FLAGS_LEFT) && !(flags & FLAGS_ZEROPAD)) {
800008bc:	003af793          	andi	a5,s5,3
800008c0:	00060b13          	addi	s6,a2,0
800008c4:	02079a63          	bne	a5,zero,800008f8 <_ftoa+0x20c>
        for (size_t i = len; i < width; i++) {
800008c8:	00300793          	addi	a5,zero,3
800008cc:	0317f663          	bgeu	a5,a7,800008f8 <_ftoa+0x20c>
800008d0:	ffd60b13          	addi	s6,a2,-3
800008d4:	011b0b33          	add	s6,s6,a7
800008d8:	00060b93          	addi	s7,a2,0
            out(' ', buffer, idx++, maxlen);
800008dc:	000b8613          	addi	a2,s7,0
800008e0:	00090693          	addi	a3,s2,0
800008e4:	001b8b93          	addi	s7,s7,1
800008e8:	00048593          	addi	a1,s1,0
800008ec:	02000513          	addi	a0,zero,32
800008f0:	000400e7          	jalr	ra,0(s0)
        for (size_t i = len; i < width; i++) {
800008f4:	ff6b94e3          	bne	s7,s6,800008dc <_ftoa+0x1f0>
    while (len) {
800008f8:	80002bb7          	lui	s7,0x80002
800008fc:	cdcb8b93          	addi	s7,s7,-804 # 80001cdc <fctprintf+0x7c>
80000900:	ffdb8c93          	addi	s9,s7,-3
        for (size_t i = len; i < width; i++) {
80000904:	000b0c13          	addi	s8,s6,0
        out(buf[--len], buffer, idx++, maxlen);
80000908:	002bc503          	lbu	a0,2(s7)
8000090c:	000c0613          	addi	a2,s8,0
80000910:	00090693          	addi	a3,s2,0
80000914:	00048593          	addi	a1,s1,0
    while (len) {
80000918:	fffb8b93          	addi	s7,s7,-1
        out(buf[--len], buffer, idx++, maxlen);
8000091c:	001c0c13          	addi	s8,s8,1
80000920:	000400e7          	jalr	ra,0(s0)
    while (len) {
80000924:	ff9b92e3          	bne	s7,s9,80000908 <_ftoa+0x21c>
    if (flags & FLAGS_LEFT) {
80000928:	002afa93          	andi	s5,s5,2
8000092c:	003b0b13          	addi	s6,s6,3
80000930:	020a8663          	beq	s5,zero,8000095c <_ftoa+0x270>
        while (idx - start_idx < width) {
80000934:	414b07b3          	sub	a5,s6,s4
80000938:	0337f263          	bgeu	a5,s3,8000095c <_ftoa+0x270>
            out(' ', buffer, idx++, maxlen);
8000093c:	000b0613          	addi	a2,s6,0
80000940:	00090693          	addi	a3,s2,0
80000944:	00048593          	addi	a1,s1,0
80000948:	02000513          	addi	a0,zero,32
8000094c:	001b0b13          	addi	s6,s6,1
80000950:	000400e7          	jalr	ra,0(s0)
        while (idx - start_idx < width) {
80000954:	414b07b3          	sub	a5,s6,s4
80000958:	ff37e2e3          	bltu	a5,s3,8000093c <_ftoa+0x250>
8000095c:	03c12b83          	lw	s7,60(sp)
80000960:	03812c03          	lw	s8,56(sp)
80000964:	03412c83          	lw	s9,52(sp)
}
80000968:	05c12083          	lw	ra,92(sp)
8000096c:	05812403          	lw	s0,88(sp)
80000970:	05412483          	lw	s1,84(sp)
80000974:	05012903          	lw	s2,80(sp)
80000978:	04c12983          	lw	s3,76(sp)
8000097c:	04812a03          	lw	s4,72(sp)
80000980:	04412a83          	lw	s5,68(sp)
80000984:	000b0513          	addi	a0,s6,0
80000988:	04012b03          	lw	s6,64(sp)
8000098c:	06010113          	addi	sp,sp,96
80000990:	00008067          	jalr	zero,0(ra)
        return _out_rev(out, buffer, idx, maxlen,
80000994:	80002737          	lui	a4,0x80002
80000998:	cd070713          	addi	a4,a4,-816 # 80001cd0 <fctprintf+0x70>
8000099c:	00400793          	addi	a5,zero,4
800009a0:	ed1ff06f          	jal	zero,80000870 <_ftoa+0x184>
        value = 0 - value;
800009a4:	0af777d3          	fsub.d	fa5,fa4,fa5
        negative = true;
800009a8:	00100513          	addi	a0,zero,1
800009ac:	dd1ff06f          	jal	zero,8000077c <_ftoa+0x90>
        return _etoa(out, buffer, idx, maxlen, value, prec, width, flags);
800009b0:	00f13427          	fsd	fa5,8(sp)
800009b4:	00040513          	addi	a0,s0,0
}
800009b8:	05812403          	lw	s0,88(sp)
        return _etoa(out, buffer, idx, maxlen, value, prec, width, flags);
800009bc:	07512023          	sw	s5,96(sp)
800009c0:	00812703          	lw	a4,8(sp)
800009c4:	00c12783          	lw	a5,12(sp)
}
800009c8:	05c12083          	lw	ra,92(sp)
800009cc:	04412a83          	lw	s5,68(sp)
800009d0:	04012b03          	lw	s6,64(sp)
        return _etoa(out, buffer, idx, maxlen, value, prec, width, flags);
800009d4:	00098893          	addi	a7,s3,0
800009d8:	00090693          	addi	a3,s2,0
}
800009dc:	04c12983          	lw	s3,76(sp)
800009e0:	05012903          	lw	s2,80(sp)
        return _etoa(out, buffer, idx, maxlen, value, prec, width, flags);
800009e4:	000a0613          	addi	a2,s4,0
800009e8:	00048593          	addi	a1,s1,0
}
800009ec:	04812a03          	lw	s4,72(sp)
800009f0:	05412483          	lw	s1,84(sp)
800009f4:	06010113          	addi	sp,sp,96
        return _etoa(out, buffer, idx, maxlen, value, prec, width, flags);
800009f8:	27c0006f          	jal	zero,80000c74 <_etoa>
800009fc:	03712e23          	sw	s7,60(sp)
80000a00:	03812c23          	sw	s8,56(sp)
80000a04:	03912a23          	sw	s9,52(sp)
    if (!(flags & FLAGS_LEFT) && !(flags & FLAGS_ZEROPAD)) {
80000a08:	003af793          	andi	a5,s5,3
80000a0c:	00060b13          	addi	s6,a2,0
80000a10:	02079a63          	bne	a5,zero,80000a44 <_ftoa+0x358>
        for (size_t i = len; i < width; i++) {
80000a14:	00400793          	addi	a5,zero,4
80000a18:	0317f663          	bgeu	a5,a7,80000a44 <_ftoa+0x358>
80000a1c:	ffc60b13          	addi	s6,a2,-4
80000a20:	011b0b33          	add	s6,s6,a7
80000a24:	00060b93          	addi	s7,a2,0
            out(' ', buffer, idx++, maxlen);
80000a28:	000b8613          	addi	a2,s7,0
80000a2c:	00090693          	addi	a3,s2,0
80000a30:	001b8b93          	addi	s7,s7,1
80000a34:	00048593          	addi	a1,s1,0
80000a38:	02000513          	addi	a0,zero,32
80000a3c:	000400e7          	jalr	ra,0(s0)
        for (size_t i = len; i < width; i++) {
80000a40:	ff6b94e3          	bne	s7,s6,80000a28 <_ftoa+0x33c>
    while (len) {
80000a44:	80002bb7          	lui	s7,0x80002
80000a48:	ce0b8c13          	addi	s8,s7,-800 # 80001ce0 <fctprintf+0x80>
        for (size_t i = len; i < width; i++) {
80000a4c:	ce0b8b93          	addi	s7,s7,-800
80000a50:	ffcc0c13          	addi	s8,s8,-4
80000a54:	016b8cb3          	add	s9,s7,s6
        out(buf[--len], buffer, idx++, maxlen);
80000a58:	003bc503          	lbu	a0,3(s7)
80000a5c:	417c8633          	sub	a2,s9,s7
80000a60:	00090693          	addi	a3,s2,0
80000a64:	00048593          	addi	a1,s1,0
    while (len) {
80000a68:	fffb8b93          	addi	s7,s7,-1
        out(buf[--len], buffer, idx++, maxlen);
80000a6c:	000400e7          	jalr	ra,0(s0)
    while (len) {
80000a70:	ff8b94e3          	bne	s7,s8,80000a58 <_ftoa+0x36c>
    if (flags & FLAGS_LEFT) {
80000a74:	002afa93          	andi	s5,s5,2
80000a78:	004b0b13          	addi	s6,s6,4
80000a7c:	ee0a80e3          	beq	s5,zero,8000095c <_ftoa+0x270>
        while (idx - start_idx < width) {
80000a80:	414b07b3          	sub	a5,s6,s4
80000a84:	ed37fce3          	bgeu	a5,s3,8000095c <_ftoa+0x270>
            out(' ', buffer, idx++, maxlen);
80000a88:	000b0613          	addi	a2,s6,0
80000a8c:	00090693          	addi	a3,s2,0
80000a90:	00048593          	addi	a1,s1,0
80000a94:	02000513          	addi	a0,zero,32
80000a98:	001b0b13          	addi	s6,s6,1
80000a9c:	000400e7          	jalr	ra,0(s0)
        while (idx - start_idx < width) {
80000aa0:	414b07b3          	sub	a5,s6,s4
80000aa4:	ff37e2e3          	bltu	a5,s3,80000a88 <_ftoa+0x39c>
80000aa8:	eb5ff06f          	jal	zero,8000095c <_ftoa+0x270>
80000aac:	40d807b3          	sub	a5,a6,a3
    while ((len < PRINTF_FTOA_BUFFER_SIZE) && (prec > 9U)) {
80000ab0:	00068593          	addi	a1,a3,0
80000ab4:	d05ff06f          	jal	zero,800007b8 <_ftoa+0xcc>
    } else if (diff < 0.5) {
80000ab8:	a2d71853          	flt.d	a6,fa4,fa3
80000abc:	d40818e3          	bne	a6,zero,8000080c <_ftoa+0x120>
    } else if ((frac == 0U) || (frac & 1U)) {
80000ac0:	18089263          	bne	a7,zero,80000c44 <_ftoa+0x558>
        ++frac;
80000ac4:	00188893          	addi	a7,a7,1
    if (prec == 0U) {
80000ac8:	d40594e3          	bne	a1,zero,80000810 <_ftoa+0x124>
        diff = value - (double)whole;
80000acc:	d2060753          	fcvt.d.w	fa4,a2
        if ((!(diff < 0.5) || (diff > 0.5)) && (whole & 1)) {
80000ad0:	8281b687          	fld	fa3,-2008(gp) # 80003028 <__DATA_BEGIN__+0x28>
        diff = value - (double)whole;
80000ad4:	0ae7f7d3          	fsub.d	fa5,fa5,fa4
        if ((!(diff < 0.5) || (diff > 0.5)) && (whole & 1)) {
80000ad8:	a2d796d3          	flt.d	a3,fa5,fa3
80000adc:	00069663          	bne	a3,zero,80000ae8 <_ftoa+0x3fc>
80000ae0:	00160613          	addi	a2,a2,1
80000ae4:	ffe67613          	andi	a2,a2,-2
        buf[len++] = (char)(48 + (whole % 10));
80000ae8:	666668b7          	lui	a7,0x66666
80000aec:	66788893          	addi	a7,a7,1639 # 66666667 <main-0x19999999>
    while (len < PRINTF_FTOA_BUFFER_SIZE) {
80000af0:	02000e13          	addi	t3,zero,32
80000af4:	0380006f          	jal	zero,80000b2c <_ftoa+0x440>
        buf[len++] = (char)(48 + (whole % 10));
80000af8:	031616b3          	mulh	a3,a2,a7
80000afc:	00178793          	addi	a5,a5,1
80000b00:	00f70833          	add	a6,a4,a5
80000b04:	4026d693          	srai	a3,a3,0x2
80000b08:	40b686b3          	sub	a3,a3,a1
80000b0c:	00269313          	slli	t1,a3,0x2
80000b10:	00d30333          	add	t1,t1,a3
80000b14:	00131313          	slli	t1,t1,0x1
80000b18:	40660333          	sub	t1,a2,t1
80000b1c:	03030313          	addi	t1,t1,48
80000b20:	fe680fa3          	sb	t1,-1(a6)
        if (!(whole /= 10)) {
80000b24:	00068613          	addi	a2,a3,0
80000b28:	04068463          	beq	a3,zero,80000b70 <_ftoa+0x484>
        buf[len++] = (char)(48 + (whole % 10));
80000b2c:	41f65593          	srai	a1,a2,0x1f
    while (len < PRINTF_FTOA_BUFFER_SIZE) {
80000b30:	fdc794e3          	bne	a5,t3,80000af8 <_ftoa+0x40c>
    if (!(flags & FLAGS_LEFT) && (flags & FLAGS_ZEROPAD)) {
80000b34:	003af693          	andi	a3,s5,3
80000b38:	00100613          	addi	a2,zero,1
80000b3c:	04c69e63          	bne	a3,a2,80000b98 <_ftoa+0x4ac>
        if (width && (negative || (flags & (FLAGS_PLUS | FLAGS_SPACE)))) {
80000b40:	04098c63          	beq	s3,zero,80000b98 <_ftoa+0x4ac>
80000b44:	06050c63          	beq	a0,zero,80000bbc <_ftoa+0x4d0>
            width--;
80000b48:	fff98993          	addi	s3,s3,-1
        while ((len < width) && (len < PRINTF_FTOA_BUFFER_SIZE)) {
80000b4c:	0537f663          	bgeu	a5,s3,80000b98 <_ftoa+0x4ac>
80000b50:	02000613          	addi	a2,zero,32
            buf[len++] = '0';
80000b54:	03000593          	addi	a1,zero,48
        while ((len < width) && (len < PRINTF_FTOA_BUFFER_SIZE)) {
80000b58:	04c78063          	beq	a5,a2,80000b98 <_ftoa+0x4ac>
            buf[len++] = '0';
80000b5c:	00178793          	addi	a5,a5,1
80000b60:	00f706b3          	add	a3,a4,a5
80000b64:	feb68fa3          	sb	a1,-1(a3)
        while ((len < width) && (len < PRINTF_FTOA_BUFFER_SIZE)) {
80000b68:	ff37e8e3          	bltu	a5,s3,80000b58 <_ftoa+0x46c>
80000b6c:	0100006f          	jal	zero,80000b7c <_ftoa+0x490>
    if (!(flags & FLAGS_LEFT) && (flags & FLAGS_ZEROPAD)) {
80000b70:	003af693          	andi	a3,s5,3
80000b74:	00100613          	addi	a2,zero,1
80000b78:	0ec68263          	beq	a3,a2,80000c5c <_ftoa+0x570>
    if (len < PRINTF_FTOA_BUFFER_SIZE) {
80000b7c:	02000693          	addi	a3,zero,32
80000b80:	00d78c63          	beq	a5,a3,80000b98 <_ftoa+0x4ac>
        if (negative) {
80000b84:	04050863          	beq	a0,zero,80000bd4 <_ftoa+0x4e8>
            buf[len++] = '-';
80000b88:	02d00613          	addi	a2,zero,45
            buf[len++] = '+'; // ignore the space if the '+' exists
80000b8c:	002786b3          	add	a3,a5,sp
80000b90:	00c68823          	sb	a2,16(a3)
80000b94:	00178793          	addi	a5,a5,1
    return _out_rev(out, buffer, idx, maxlen, buf, len, width, flags);
80000b98:	000a8893          	addi	a7,s5,0
80000b9c:	00098813          	addi	a6,s3,0
80000ba0:	00090693          	addi	a3,s2,0
80000ba4:	000a0613          	addi	a2,s4,0
80000ba8:	00048593          	addi	a1,s1,0
80000bac:	00040513          	addi	a0,s0,0
80000bb0:	ca4ff0ef          	jal	ra,80000054 <_out_rev>
80000bb4:	00050b13          	addi	s6,a0,0
80000bb8:	db1ff06f          	jal	zero,80000968 <_ftoa+0x27c>
        if (width && (negative || (flags & (FLAGS_PLUS | FLAGS_SPACE)))) {
80000bbc:	00caf693          	andi	a3,s5,12
80000bc0:	08068a63          	beq	a3,zero,80000c54 <_ftoa+0x568>
            width--;
80000bc4:	fff98993          	addi	s3,s3,-1
        while ((len < width) && (len < PRINTF_FTOA_BUFFER_SIZE)) {
80000bc8:	f937e4e3          	bltu	a5,s3,80000b50 <_ftoa+0x464>
    if (len < PRINTF_FTOA_BUFFER_SIZE) {
80000bcc:	02000693          	addi	a3,zero,32
80000bd0:	fcd784e3          	beq	a5,a3,80000b98 <_ftoa+0x4ac>
        } else if (flags & FLAGS_PLUS) {
80000bd4:	004af693          	andi	a3,s5,4
80000bd8:	04068663          	beq	a3,zero,80000c24 <_ftoa+0x538>
            buf[len++] = '+'; // ignore the space if the '+' exists
80000bdc:	02b00613          	addi	a2,zero,43
80000be0:	fadff06f          	jal	zero,80000b8c <_ftoa+0x4a0>
        while ((len < PRINTF_FTOA_BUFFER_SIZE) && (count-- > 0U)) {
80000be4:	03d78263          	beq	a5,t4,80000c08 <_ftoa+0x51c>
80000be8:	00f585b3          	add	a1,a1,a5
            buf[len++] = '0';
80000bec:	03000893          	addi	a7,zero,48
        while ((len < PRINTF_FTOA_BUFFER_SIZE) && (count-- > 0U)) {
80000bf0:	02000813          	addi	a6,zero,32
80000bf4:	00f58e63          	beq	a1,a5,80000c10 <_ftoa+0x524>
            buf[len++] = '0';
80000bf8:	00178793          	addi	a5,a5,1
80000bfc:	00f706b3          	add	a3,a4,a5
80000c00:	ff168fa3          	sb	a7,-1(a3)
        while ((len < PRINTF_FTOA_BUFFER_SIZE) && (count-- > 0U)) {
80000c04:	ff0798e3          	bne	a5,a6,80000bf4 <_ftoa+0x508>
            if (!(frac /= 10U)) {
80000c08:	02000793          	addi	a5,zero,32
80000c0c:	eddff06f          	jal	zero,80000ae8 <_ftoa+0x3fc>
            buf[len++] = '.';
80000c10:	002585b3          	add	a1,a1,sp
80000c14:	02e00693          	addi	a3,zero,46
80000c18:	00178793          	addi	a5,a5,1
80000c1c:	00d58823          	sb	a3,16(a1)
80000c20:	ec9ff06f          	jal	zero,80000ae8 <_ftoa+0x3fc>
        } else if (flags & FLAGS_SPACE) {
80000c24:	008af693          	andi	a3,s5,8
80000c28:	f60688e3          	beq	a3,zero,80000b98 <_ftoa+0x4ac>
            buf[len++] = ' ';
80000c2c:	02000613          	addi	a2,zero,32
80000c30:	00c786b3          	add	a3,a5,a2
80000c34:	002686b3          	add	a3,a3,sp
80000c38:	fec68823          	sb	a2,-16(a3)
80000c3c:	00178793          	addi	a5,a5,1
80000c40:	f59ff06f          	jal	zero,80000b98 <_ftoa+0x4ac>
    } else if ((frac == 0U) || (frac & 1U)) {
80000c44:	0018f813          	andi	a6,a7,1
80000c48:	bc0802e3          	beq	a6,zero,8000080c <_ftoa+0x120>
        ++frac;
80000c4c:	00188893          	addi	a7,a7,1
80000c50:	e79ff06f          	jal	zero,80000ac8 <_ftoa+0x3dc>
        while ((len < width) && (len < PRINTF_FTOA_BUFFER_SIZE)) {
80000c54:	ef37eee3          	bltu	a5,s3,80000b50 <_ftoa+0x464>
80000c58:	f41ff06f          	jal	zero,80000b98 <_ftoa+0x4ac>
        if (width && (negative || (flags & (FLAGS_PLUS | FLAGS_SPACE)))) {
80000c5c:	f20980e3          	beq	s3,zero,80000b7c <_ftoa+0x490>
80000c60:	f4050ee3          	beq	a0,zero,80000bbc <_ftoa+0x4d0>
            width--;
80000c64:	fff98993          	addi	s3,s3,-1
        while ((len < width) && (len < PRINTF_FTOA_BUFFER_SIZE)) {
80000c68:	ef37e4e3          	bltu	a5,s3,80000b50 <_ftoa+0x464>
    if (len < PRINTF_FTOA_BUFFER_SIZE) {
80000c6c:	f1c79ee3          	bne	a5,t3,80000b88 <_ftoa+0x49c>
80000c70:	f29ff06f          	jal	zero,80000b98 <_ftoa+0x4ac>

80000c74 <_etoa>:
#if defined(PRINTF_SUPPORT_EXPONENTIAL)
// internal ftoa variant for exponential floating-point type, contributed by
// Martijn Jasperse <m.jasperse@gmail.com>
static size_t _etoa(out_fct_type out, char *buffer, size_t idx, size_t maxlen,
                    double value, unsigned int prec, unsigned int width,
                    unsigned int flags) {
80000c74:	fb010113          	addi	sp,sp,-80
80000c78:	00f12e23          	sw	a5,28(sp)
80000c7c:	00e12c23          	sw	a4,24(sp)
80000c80:	01813787          	fld	fa5,24(sp)
80000c84:	04812423          	sw	s0,72(sp)
80000c88:	04912223          	sw	s1,68(sp)
    // check for NaN and special values
    if ((value != value) || (value > DBL_MAX) || (value < -DBL_MAX)) {
80000c8c:	a2f7a7d3          	feq.d	a5,fa5,fa5
                    unsigned int flags) {
80000c90:	05212023          	sw	s2,64(sp)
80000c94:	03412c23          	sw	s4,56(sp)
80000c98:	03512a23          	sw	s5,52(sp)
80000c9c:	03612823          	sw	s6,48(sp)
80000ca0:	04112623          	sw	ra,76(sp)
80000ca4:	05012903          	lw	s2,80(sp)
80000ca8:	00050a93          	addi	s5,a0,0
80000cac:	00058413          	addi	s0,a1,0
80000cb0:	00060a13          	addi	s4,a2,0
80000cb4:	00068493          	addi	s1,a3,0
80000cb8:	00088b13          	addi	s6,a7,0
    if ((value != value) || (value > DBL_MAX) || (value < -DBL_MAX)) {
80000cbc:	1e078263          	beq	a5,zero,80000ea0 <_etoa+0x22c>
80000cc0:	8101b707          	fld	fa4,-2032(gp) # 80003010 <__DATA_BEGIN__+0x10>
80000cc4:	a2f717d3          	flt.d	a5,fa4,fa5
80000cc8:	1c079c63          	bne	a5,zero,80000ea0 <_etoa+0x22c>
80000ccc:	8081b707          	fld	fa4,-2040(gp) # 80003008 <__DATA_BEGIN__+0x8>
80000cd0:	a2e797d3          	flt.d	a5,fa5,fa4
80000cd4:	1c079663          	bne	a5,zero,80000ea0 <_etoa+0x22c>
        return _ftoa(out, buffer, idx, maxlen, value, prec, width, flags);
    }

    // determine the sign
    const bool negative = value < 0;
    if (negative) {
80000cd8:	d2000753          	fcvt.d.w	fa4,zero
80000cdc:	03312e23          	sw	s3,60(sp)
80000ce0:	03712623          	sw	s7,44(sp)
80000ce4:	a2e797d3          	flt.d	a5,fa5,fa4
80000ce8:	03812423          	sw	s8,40(sp)
80000cec:	34079a63          	bne	a5,zero,80001040 <_etoa+0x3cc>
80000cf0:	00f13c27          	fsd	fa5,24(sp)
80000cf4:	01812703          	lw	a4,24(sp)
80000cf8:	01c12783          	lw	a5,28(sp)
        value = -value;
    }

    // default precision
    if (!(flags & FLAGS_PRECISION)) {
80000cfc:	40097613          	andi	a2,s2,1024
80000d00:	00061463          	bne	a2,zero,80000d08 <_etoa+0x94>
        prec = PRINTF_DEFAULT_FLOAT_PRECISION;
80000d04:	00600813          	addi	a6,zero,6
        uint64_t U;
        double F;
    } conv;

    conv.F = value;
    int exp2 = (int)((conv.U >> 52U) & 0x07FFU) - 1023; // effectively log2
80000d08:	0147d693          	srli	a3,a5,0x14
80000d0c:	7ff6f693          	andi	a3,a3,2047
80000d10:	c0168693          	addi	a3,a3,-1023
    conv.U = (conv.U & ((1ULL << 52U) - 1U)) |
             (1023ULL << 52U); // drop the exponent so conv.F is now in [1,2)
    // now approximate log10 from the log2 integer part and an expansion of ln
    // around 1.5
    int expval = (int)(0.1760912590558 + exp2 * 0.301029995663981 +
80000d14:	d20686d3          	fcvt.d.w	fa3,a3
    conv.U = (conv.U & ((1ULL << 52U) - 1U)) |
80000d18:	00c79693          	slli	a3,a5,0xc
    int expval = (int)(0.1760912590558 + exp2 * 0.301029995663981 +
80000d1c:	8381b607          	fld	fa2,-1992(gp) # 80003038 <__DATA_BEGIN__+0x38>
80000d20:	8301b587          	fld	fa1,-2000(gp) # 80003030 <__DATA_BEGIN__+0x30>
                       (conv.F - 1.5) * 0.289529654602168);
80000d24:	8401b707          	fld	fa4,-1984(gp) # 80003040 <__DATA_BEGIN__+0x40>
    conv.U = (conv.U & ((1ULL << 52U) - 1U)) |
80000d28:	00c6d693          	srli	a3,a3,0xc
80000d2c:	3ff005b7          	lui	a1,0x3ff00
80000d30:	00b6e3b3          	or	t2,a3,a1
                       (conv.F - 1.5) * 0.289529654602168);
80000d34:	00e12c23          	sw	a4,24(sp)
80000d38:	00712e23          	sw	t2,28(sp)
    int expval = (int)(0.1760912590558 + exp2 * 0.301029995663981 +
80000d3c:	62b6f6c3          	fmadd.d	fa3,fa3,fa1,fa2
                       (conv.F - 1.5) * 0.289529654602168);
80000d40:	01813607          	fld	fa2,24(sp)
    int expval = (int)(0.1760912590558 + exp2 * 0.301029995663981 +
80000d44:	8481b507          	fld	fa0,-1976(gp) # 80003048 <__DATA_BEGIN__+0x48>
                       (conv.F - 1.5) * 0.289529654602168);
80000d48:	0ae67753          	fsub.d	fa4,fa2,fa4
    // now we want to compute 10^expval but we want to be sure it won't overflow
    exp2 = (int)(expval * 3.321928094887362 + 0.5);
80000d4c:	8281b587          	fld	fa1,-2008(gp) # 80003028 <__DATA_BEGIN__+0x28>
80000d50:	8501b607          	fld	fa2,-1968(gp) # 80003050 <__DATA_BEGIN__+0x50>
    const double z = expval * 2.302585092994046 - exp2 * 0.6931471805599453;
80000d54:	8581b187          	fld	ft3,-1960(gp) # 80003058 <__DATA_BEGIN__+0x58>
    int expval = (int)(0.1760912590558 + exp2 * 0.301029995663981 +
80000d58:	6aa77743          	fmadd.d	fa4,fa4,fa0,fa3
    const double z = expval * 2.302585092994046 - exp2 * 0.6931471805599453;
80000d5c:	8601b107          	fld	ft2,-1952(gp) # 80003060 <__DATA_BEGIN__+0x60>
    const double z2 = z * z;
    conv.U = (uint64_t)(exp2 + 1023) << 52U;
    // compute exp(z) using continued fractions, see
    // https://en.wikipedia.org/wiki/Exponential_function#Continued_fractions_for_ex
    conv.F *= 1 + 2 * z / (2 - z + (z2 / (6 + (z2 / (10 + z2 / 14)))));
80000d60:	8681b687          	fld	fa3,-1944(gp) # 80003068 <__DATA_BEGIN__+0x68>
80000d64:	8701b507          	fld	fa0,-1936(gp) # 80003070 <__DATA_BEGIN__+0x70>
    int expval = (int)(0.1760912590558 + exp2 * 0.301029995663981 +
80000d68:	c2071bd3          	fcvt.w.d	s7,fa4,rtz
    conv.F *= 1 + 2 * z / (2 - z + (z2 / (6 + (z2 / (10 + z2 / 14)))));
80000d6c:	8781b087          	fld	ft1,-1928(gp) # 80003078 <__DATA_BEGIN__+0x78>
    exp2 = (int)(expval * 3.321928094887362 + 0.5);
80000d70:	d20b8753          	fcvt.d.w	fa4,s7
    conv.U = (uint64_t)(exp2 + 1023) << 52U;
80000d74:	00000513          	addi	a0,zero,0
    exp2 = (int)(expval * 3.321928094887362 + 0.5);
80000d78:	5ac77643          	fmadd.d	fa2,fa4,fa2,fa1
    conv.F *= 1 + 2 * z / (2 - z + (z2 / (6 + (z2 / (10 + z2 / 14)))));
80000d7c:	8801b587          	fld	fa1,-1920(gp) # 80003080 <__DATA_BEGIN__+0x80>
80000d80:	8881b007          	fld	ft0,-1912(gp) # 80003088 <__DATA_BEGIN__+0x88>
80000d84:	00a12c23          	sw	a0,24(sp)
    exp2 = (int)(expval * 3.321928094887362 + 0.5);
80000d88:	c20616d3          	fcvt.w.d	a3,fa2,rtz
    const double z = expval * 2.302585092994046 - exp2 * 0.6931471805599453;
80000d8c:	d2068653          	fcvt.d.w	fa2,a3
    conv.U = (uint64_t)(exp2 + 1023) << 52U;
80000d90:	3ff68693          	addi	a3,a3,1023
80000d94:	01469593          	slli	a1,a3,0x14
    const double z = expval * 2.302585092994046 - exp2 * 0.6931471805599453;
80000d98:	12367653          	fmul.d	fa2,fa2,ft3
    conv.F *= 1 + 2 * z / (2 - z + (z2 / (6 + (z2 / (10 + z2 / 14)))));
80000d9c:	00b12e23          	sw	a1,28(sp)
    const double z = expval * 2.302585092994046 - exp2 * 0.6931471805599453;
80000da0:	62277747          	fmsub.d	fa4,fa4,ft2,fa2
    const double z2 = z * z;
80000da4:	12e77653          	fmul.d	fa2,fa4,fa4
    conv.F *= 1 + 2 * z / (2 - z + (z2 / (6 + (z2 / (10 + z2 / 14)))));
80000da8:	0ae5f5d3          	fsub.d	fa1,fa1,fa4
80000dac:	02e77753          	fadd.d	fa4,fa4,fa4
80000db0:	1ad676d3          	fdiv.d	fa3,fa2,fa3
80000db4:	02a6f6d3          	fadd.d	fa3,fa3,fa0
80000db8:	1ad676d3          	fdiv.d	fa3,fa2,fa3
80000dbc:	0216f6d3          	fadd.d	fa3,fa3,ft1
80000dc0:	1ad67653          	fdiv.d	fa2,fa2,fa3
80000dc4:	01813687          	fld	fa3,24(sp)
    // correct for rounding errors
    if (value < conv.F) {
80000dc8:	00e12c23          	sw	a4,24(sp)
80000dcc:	00f12e23          	sw	a5,28(sp)
    conv.F *= 1 + 2 * z / (2 - z + (z2 / (6 + (z2 / (10 + z2 / 14)))));
80000dd0:	02b67653          	fadd.d	fa2,fa2,fa1
80000dd4:	1ac77753          	fdiv.d	fa4,fa4,fa2
80000dd8:	02077753          	fadd.d	fa4,fa4,ft0
80000ddc:	12d77753          	fmul.d	fa4,fa4,fa3
    if (value < conv.F) {
80000de0:	01813687          	fld	fa3,24(sp)
80000de4:	a2e696d3          	flt.d	a3,fa3,fa4
80000de8:	00068663          	beq	a3,zero,80000df4 <_etoa+0x180>
        expval--;
        conv.F /= 10;
80000dec:	1aa77753          	fdiv.d	fa4,fa4,fa0
        expval--;
80000df0:	fffb8b93          	addi	s7,s7,-1
    // the exponent format is "%+03d" and largest value is "307", so set aside
    // 4-5 characters
    unsigned int minwidth = ((expval < 100) && (expval > -100)) ? 4U : 5U;

    // in "%g" mode, "prec" is the number of *significant figures* not decimals
    if (flags & FLAGS_ADAPT_EXP) {
80000df4:	000016b7          	lui	a3,0x1
80000df8:	80068693          	addi	a3,a3,-2048 # 800 <main-0x7ffff800>
    unsigned int minwidth = ((expval < 100) && (expval > -100)) ? 4U : 5U;
80000dfc:	063b8993          	addi	s3,s7,99
80000e00:	0c600593          	addi	a1,zero,198
80000e04:	0135b9b3          	sltu	s3,a1,s3
    if (flags & FLAGS_ADAPT_EXP) {
80000e08:	00d978b3          	and	a7,s2,a3
    unsigned int minwidth = ((expval < 100) && (expval > -100)) ? 4U : 5U;
80000e0c:	00498993          	addi	s3,s3,4
        fwidth -= minwidth;
    } else {
        // not enough characters, so go back to default sizing
        fwidth = 0U;
    }
    if ((flags & FLAGS_LEFT) && minwidth) {
80000e10:	00297c13          	andi	s8,s2,2
    if (flags & FLAGS_ADAPT_EXP) {
80000e14:	0c088a63          	beq	a7,zero,80000ee8 <_etoa+0x274>
        if ((value >= 1e-4) && (value < 1e6)) {
80000e18:	00e12c23          	sw	a4,24(sp)
80000e1c:	00f12e23          	sw	a5,28(sp)
80000e20:	8901b687          	fld	fa3,-1904(gp) # 80003090 <__DATA_BEGIN__+0x90>
80000e24:	01813607          	fld	fa2,24(sp)
80000e28:	a2c686d3          	fle.d	a3,fa3,fa2
80000e2c:	1c068c63          	beq	a3,zero,80001004 <_etoa+0x390>
80000e30:	00e12c23          	sw	a4,24(sp)
80000e34:	00f12e23          	sw	a5,28(sp)
80000e38:	8981b687          	fld	fa3,-1896(gp) # 80003098 <__DATA_BEGIN__+0x98>
80000e3c:	01813607          	fld	fa2,24(sp)
80000e40:	a2d616d3          	flt.d	a3,fa2,fa3
80000e44:	1c068063          	beq	a3,zero,80001004 <_etoa+0x390>
            if ((int)prec > expval) {
80000e48:	00000693          	addi	a3,zero,0
80000e4c:	010bd663          	bge	s7,a6,80000e58 <_etoa+0x1e4>
                prec = (unsigned)((int)prec - expval - 1);
80000e50:	417806b3          	sub	a3,a6,s7
80000e54:	fff68693          	addi	a3,a3,-1
        value /= conv.F;
    }

    // output the floating part
    const size_t start_idx = idx;
    idx = _ftoa(out, buffer, idx, maxlen, negative ? -value : value, prec,
80000e58:	d2000753          	fcvt.d.w	fa4,zero
80000e5c:	a2e79653          	flt.d	a2,fa5,fa4
80000e60:	1e061a63          	bne	a2,zero,80001054 <_etoa+0x3e0>
80000e64:	fffff337          	lui	t1,0xfffff
80000e68:	7ff30313          	addi	t1,t1,2047 # fffff7ff <__global_pointer$+0x7fffbfff>
80000e6c:	00697333          	and	t1,s2,t1
80000e70:	40036313          	ori	t1,t1,1024
80000e74:	00068813          	addi	a6,a3,0
80000e78:	03c12983          	lw	s3,60(sp)
80000e7c:	02c12b83          	lw	s7,44(sp)
80000e80:	02812c03          	lw	s8,40(sp)
80000e84:	000b0893          	addi	a7,s6,0
80000e88:	00048693          	addi	a3,s1,0
80000e8c:	000a0613          	addi	a2,s4,0
80000e90:	00040593          	addi	a1,s0,0
80000e94:	000a8513          	addi	a0,s5,0
80000e98:	04612823          	sw	t1,80(sp)
80000e9c:	0280006f          	jal	zero,80000ec4 <_etoa+0x250>
        return _ftoa(out, buffer, idx, maxlen, value, prec, width, flags);
80000ea0:	00f13c27          	fsd	fa5,24(sp)
80000ea4:	01812703          	lw	a4,24(sp)
80000ea8:	01c12783          	lw	a5,28(sp)
80000eac:	05212823          	sw	s2,80(sp)
80000eb0:	000b0893          	addi	a7,s6,0
80000eb4:	00048693          	addi	a3,s1,0
80000eb8:	000a0613          	addi	a2,s4,0
80000ebc:	00040593          	addi	a1,s0,0
80000ec0:	000a8513          	addi	a0,s5,0
            while (idx - start_idx < width)
                out(' ', buffer, idx++, maxlen);
        }
    }
    return idx;
}
80000ec4:	04812403          	lw	s0,72(sp)
80000ec8:	04c12083          	lw	ra,76(sp)
80000ecc:	04412483          	lw	s1,68(sp)
80000ed0:	04012903          	lw	s2,64(sp)
80000ed4:	03812a03          	lw	s4,56(sp)
80000ed8:	03412a83          	lw	s5,52(sp)
80000edc:	03012b03          	lw	s6,48(sp)
80000ee0:	05010113          	addi	sp,sp,80
    idx = _ftoa(out, buffer, idx, maxlen, negative ? -value : value, prec,
80000ee4:	809ff06f          	jal	zero,800006ec <_ftoa>
    if (width > minwidth) {
80000ee8:	0169f663          	bgeu	s3,s6,80000ef4 <_etoa+0x280>
    if ((flags & FLAGS_LEFT) && minwidth) {
80000eec:	120c0c63          	beq	s8,zero,80001024 <_etoa+0x3b0>
80000ef0:	00200c13          	addi	s8,zero,2
    if (expval) {
80000ef4:	020b8063          	beq	s7,zero,80000f14 <_etoa+0x2a0>
        value /= conv.F;
80000ef8:	00e12c23          	sw	a4,24(sp)
80000efc:	00f12e23          	sw	a5,28(sp)
80000f00:	01813687          	fld	fa3,24(sp)
80000f04:	1ae6f753          	fdiv.d	fa4,fa3,fa4
80000f08:	00e13c27          	fsd	fa4,24(sp)
80000f0c:	01812703          	lw	a4,24(sp)
80000f10:	01c12783          	lw	a5,28(sp)
    idx = _ftoa(out, buffer, idx, maxlen, negative ? -value : value, prec,
80000f14:	d2000753          	fcvt.d.w	fa4,zero
80000f18:	a2e796d3          	flt.d	a3,fa5,fa4
80000f1c:	16069063          	bne	a3,zero,8000107c <_etoa+0x408>
80000f20:	fffff6b7          	lui	a3,0xfffff
80000f24:	7ff68693          	addi	a3,a3,2047 # fffff7ff <__global_pointer$+0x7fffbfff>
80000f28:	00d976b3          	and	a3,s2,a3
80000f2c:	00d12023          	sw	a3,0(sp)
80000f30:	000a0613          	addi	a2,s4,0
80000f34:	00048693          	addi	a3,s1,0
80000f38:	00040593          	addi	a1,s0,0
80000f3c:	000a8513          	addi	a0,s5,0
80000f40:	facff0ef          	jal	ra,800006ec <_ftoa>
80000f44:	00050613          	addi	a2,a0,0
        out((flags & FLAGS_UPPERCASE) ? 'E' : 'e', buffer, idx++, maxlen);
80000f48:	fff94513          	xori	a0,s2,-1
80000f4c:	02057513          	andi	a0,a0,32
80000f50:	04550513          	addi	a0,a0,69
80000f54:	00048693          	addi	a3,s1,0
80000f58:	00040593          	addi	a1,s0,0
80000f5c:	00160913          	addi	s2,a2,1
80000f60:	000a80e7          	jalr	ra,0(s5)
                         (expval < 0) ? -expval : expval, expval < 0, 10, 0,
80000f64:	41fbd793          	srai	a5,s7,0x1f
        idx = _ntoa_long(out, buffer, idx, maxlen,
80000f68:	00500693          	addi	a3,zero,5
                         (expval < 0) ? -expval : expval, expval < 0, 10, 0,
80000f6c:	0177c733          	xor	a4,a5,s7
        idx = _ntoa_long(out, buffer, idx, maxlen,
80000f70:	fff98993          	addi	s3,s3,-1
80000f74:	00090613          	addi	a2,s2,0
80000f78:	00d12223          	sw	a3,4(sp)
80000f7c:	40f70733          	sub	a4,a4,a5
80000f80:	01312023          	sw	s3,0(sp)
80000f84:	01fbd793          	srli	a5,s7,0x1f
80000f88:	00048693          	addi	a3,s1,0
80000f8c:	00040593          	addi	a1,s0,0
80000f90:	000a8513          	addi	a0,s5,0
80000f94:	00000893          	addi	a7,zero,0
80000f98:	00a00813          	addi	a6,zero,10
80000f9c:	9ecff0ef          	jal	ra,80000188 <_ntoa_long>
80000fa0:	00050913          	addi	s2,a0,0
        if (flags & FLAGS_LEFT) {
80000fa4:	020c0663          	beq	s8,zero,80000fd0 <_etoa+0x35c>
            while (idx - start_idx < width)
80000fa8:	41450a33          	sub	s4,a0,s4
80000fac:	036a7263          	bgeu	s4,s6,80000fd0 <_etoa+0x35c>
                out(' ', buffer, idx++, maxlen);
80000fb0:	00090613          	addi	a2,s2,0
80000fb4:	00048693          	addi	a3,s1,0
80000fb8:	00040593          	addi	a1,s0,0
80000fbc:	02000513          	addi	a0,zero,32
            while (idx - start_idx < width)
80000fc0:	001a0a13          	addi	s4,s4,1
                out(' ', buffer, idx++, maxlen);
80000fc4:	00190913          	addi	s2,s2,1
80000fc8:	000a80e7          	jalr	ra,0(s5)
            while (idx - start_idx < width)
80000fcc:	ff6a62e3          	bltu	s4,s6,80000fb0 <_etoa+0x33c>
}
80000fd0:	04c12083          	lw	ra,76(sp)
80000fd4:	04812403          	lw	s0,72(sp)
80000fd8:	03c12983          	lw	s3,60(sp)
80000fdc:	02c12b83          	lw	s7,44(sp)
80000fe0:	02812c03          	lw	s8,40(sp)
80000fe4:	04412483          	lw	s1,68(sp)
80000fe8:	03812a03          	lw	s4,56(sp)
80000fec:	03412a83          	lw	s5,52(sp)
80000ff0:	03012b03          	lw	s6,48(sp)
80000ff4:	00090513          	addi	a0,s2,0
80000ff8:	04012903          	lw	s2,64(sp)
80000ffc:	05010113          	addi	sp,sp,80
80001000:	00008067          	jalr	zero,0(ra)
            if ((prec > 0) && (flags & FLAGS_PRECISION)) {
80001004:	02080463          	beq	a6,zero,8000102c <_etoa+0x3b8>
80001008:	02060263          	beq	a2,zero,8000102c <_etoa+0x3b8>
                --prec;
8000100c:	fff80813          	addi	a6,a6,-1
    if (width > minwidth) {
80001010:	0169f663          	bgeu	s3,s6,8000101c <_etoa+0x3a8>
    if ((flags & FLAGS_LEFT) && minwidth) {
80001014:	000c0863          	beq	s8,zero,80001024 <_etoa+0x3b0>
80001018:	00200c13          	addi	s8,zero,2
        fwidth = 0U;
8000101c:	00000893          	addi	a7,zero,0
80001020:	ed5ff06f          	jal	zero,80000ef4 <_etoa+0x280>
        fwidth -= minwidth;
80001024:	413b08b3          	sub	a7,s6,s3
80001028:	ecdff06f          	jal	zero,80000ef4 <_etoa+0x280>
    if (width > minwidth) {
8000102c:	ff69f8e3          	bgeu	s3,s6,8000101c <_etoa+0x3a8>
    if ((flags & FLAGS_LEFT) && minwidth) {
80001030:	fe0c0ae3          	beq	s8,zero,80001024 <_etoa+0x3b0>
        fwidth = 0U;
80001034:	00000893          	addi	a7,zero,0
    if ((flags & FLAGS_LEFT) && minwidth) {
80001038:	00200c13          	addi	s8,zero,2
8000103c:	eb9ff06f          	jal	zero,80000ef4 <_etoa+0x280>
        value = -value;
80001040:	22f79753          	fsgnjn.d	fa4,fa5,fa5
80001044:	00e13c27          	fsd	fa4,24(sp)
80001048:	01812703          	lw	a4,24(sp)
8000104c:	01c12783          	lw	a5,28(sp)
80001050:	cadff06f          	jal	zero,80000cfc <_etoa+0x88>
    idx = _ftoa(out, buffer, idx, maxlen, negative ? -value : value, prec,
80001054:	00e12c23          	sw	a4,24(sp)
80001058:	00f12e23          	sw	a5,28(sp)
8000105c:	01813787          	fld	fa5,24(sp)
80001060:	fffff337          	lui	t1,0xfffff
80001064:	7ff30313          	addi	t1,t1,2047 # fffff7ff <__global_pointer$+0x7fffbfff>
80001068:	22f797d3          	fsgnjn.d	fa5,fa5,fa5
8000106c:	00f13c27          	fsd	fa5,24(sp)
80001070:	01812703          	lw	a4,24(sp)
80001074:	01c12783          	lw	a5,28(sp)
80001078:	df5ff06f          	jal	zero,80000e6c <_etoa+0x1f8>
8000107c:	00e12c23          	sw	a4,24(sp)
80001080:	00f12e23          	sw	a5,28(sp)
80001084:	01813787          	fld	fa5,24(sp)
80001088:	fffff6b7          	lui	a3,0xfffff
8000108c:	22f797d3          	fsgnjn.d	fa5,fa5,fa5
80001090:	00f13c27          	fsd	fa5,24(sp)
80001094:	01812703          	lw	a4,24(sp)
80001098:	01c12783          	lw	a5,28(sp)
8000109c:	e89ff06f          	jal	zero,80000f24 <_etoa+0x2b0>

800010a0 <_vsnprintf>:
        }                                                                      \
    }

// internal vsnprintf
static int _vsnprintf(out_fct_type out, char *buffer, const size_t maxlen,
                      const char *format, va_list va) {
800010a0:	f9010113          	addi	sp,sp,-112
800010a4:	06912223          	sw	s1,100(sp)
800010a8:	07212023          	sw	s2,96(sp)
800010ac:	05312e23          	sw	s3,92(sp)
800010b0:	05912223          	sw	s9,68(sp)
800010b4:	05a12023          	sw	s10,64(sp)
800010b8:	06112623          	sw	ra,108(sp)
800010bc:	06812423          	sw	s0,104(sp)
800010c0:	03b12e23          	sw	s11,60(sp)
800010c4:	00058913          	addi	s2,a1,0 # 3ff00000 <main-0x40100000>
800010c8:	00060493          	addi	s1,a2,0
800010cc:	00068d13          	addi	s10,a3,0 # fffff000 <__global_pointer$+0x7fffb800>
800010d0:	00070c93          	addi	s9,a4,0
800010d4:	00050993          	addi	s3,a0,0
    unsigned int flags, width, precision, n;
    size_t idx = 0U;

    if (!buffer) {
800010d8:	46058463          	beq	a1,zero,80001540 <_vsnprintf+0x4a0>
        // use null output function
        out = _out_null;
    }

    while (*format) {
800010dc:	000d4503          	lbu	a0,0(s10)
800010e0:	00000d93          	addi	s11,zero,0
800010e4:	46050863          	beq	a0,zero,80001554 <_vsnprintf+0x4b4>
800010e8:	05412c23          	sw	s4,88(sp)
800010ec:	05512a23          	sw	s5,84(sp)
800010f0:	05612823          	sw	s6,80(sp)
800010f4:	05712623          	sw	s7,76(sp)
800010f8:	05812423          	sw	s8,72(sp)
        // format specifier?  %[flags][width][.precision][length]
        if (*format != '%') {
800010fc:	02500b13          	addi	s6,zero,37
        }

        // evaluate flags
        flags = 0U;
        do {
            switch (*format) {
80001100:	01000413          	addi	s0,zero,16
80001104:	80002a37          	lui	s4,0x80002
            }
        } while (n);

        // evaluate width field
        width = 0U;
        if (_is_digit(*format)) {
80001108:	00900a93          	addi	s5,zero,9
8000110c:	0200006f          	jal	zero,8000112c <_vsnprintf+0x8c>
            out('%', buffer, idx++, maxlen);
            format++;
            break;

        default:
            out(*format, buffer, idx++, maxlen);
80001110:	000d8613          	addi	a2,s11,0
80001114:	00048693          	addi	a3,s1,0
80001118:	00090593          	addi	a1,s2,0
8000111c:	001d8d93          	addi	s11,s11,1
80001120:	000980e7          	jalr	ra,0(s3)
    while (*format) {
80001124:	000d4503          	lbu	a0,0(s10)
80001128:	1a050863          	beq	a0,zero,800012d8 <_vsnprintf+0x238>
            format++;
8000112c:	001d0d13          	addi	s10,s10,1
        if (*format != '%') {
80001130:	ff6510e3          	bne	a0,s6,80001110 <_vsnprintf+0x70>
        flags = 0U;
80001134:	00000693          	addi	a3,zero,0
            switch (*format) {
80001138:	000d4503          	lbu	a0,0(s10)
            format++;
8000113c:	001d0713          	addi	a4,s10,1
            switch (*format) {
80001140:	fe050793          	addi	a5,a0,-32
80001144:	0ff7f793          	andi	a5,a5,255
80001148:	00f46c63          	bltu	s0,a5,80001160 <_vsnprintf+0xc0>
8000114c:	00279793          	slli	a5,a5,0x2
80001150:	d08a0613          	addi	a2,s4,-760 # 80001d08 <fctprintf+0xa8>
80001154:	00c787b3          	add	a5,a5,a2
80001158:	0007a783          	lw	a5,0(a5)
8000115c:	00078067          	jalr	zero,0(a5)
static inline bool _is_digit(char ch) { return (ch >= '0') && (ch <= '9'); }
80001160:	fd050793          	addi	a5,a0,-48
        if (_is_digit(*format)) {
80001164:	0ff7f793          	andi	a5,a5,255
80001168:	0afafe63          	bgeu	s5,a5,80001224 <_vsnprintf+0x184>
        } else if (*format == '*') {
8000116c:	02a00793          	addi	a5,zero,42
        width = 0U;
80001170:	00000b93          	addi	s7,zero,0
        } else if (*format == '*') {
80001174:	1cf50c63          	beq	a0,a5,8000134c <_vsnprintf+0x2ac>
        if (*format == '.') {
80001178:	02e00793          	addi	a5,zero,46
        precision = 0U;
8000117c:	00000813          	addi	a6,zero,0
        if (*format == '.') {
80001180:	0ef50063          	beq	a0,a5,80001260 <_vsnprintf+0x1c0>
        switch (*format) {
80001184:	06c00613          	addi	a2,zero,108
            format++;
80001188:	00070793          	addi	a5,a4,0
        switch (*format) {
8000118c:	10c50663          	beq	a0,a2,80001298 <_vsnprintf+0x1f8>
80001190:	1aa66463          	bltu	a2,a0,80001338 <_vsnprintf+0x298>
80001194:	06800613          	addi	a2,zero,104
80001198:	38c50663          	beq	a0,a2,80001524 <_vsnprintf+0x484>
8000119c:	06a00613          	addi	a2,zero,106
800011a0:	1ec51063          	bne	a0,a2,80001380 <_vsnprintf+0x2e0>
            if (*format == 'l') {
800011a4:	001d4503          	lbu	a0,1(s10)
            flags |= (sizeof(intmax_t) == sizeof(long) ? FLAGS_LONG
800011a8:	2006e593          	ori	a1,a3,512
        switch (*format) {
800011ac:	06700713          	addi	a4,zero,103
            format++;
800011b0:	00178d13          	addi	s10,a5,1
        switch (*format) {
800011b4:	1ea76863          	bltu	a4,a0,800013a4 <_vsnprintf+0x304>
800011b8:	02400793          	addi	a5,zero,36
800011bc:	f4a7fae3          	bgeu	a5,a0,80001110 <_vsnprintf+0x70>
800011c0:	fdb50793          	addi	a5,a0,-37
800011c4:	0ff7f793          	andi	a5,a5,255
800011c8:	04200713          	addi	a4,zero,66
800011cc:	f4f762e3          	bltu	a4,a5,80001110 <_vsnprintf+0x70>
800011d0:	80002737          	lui	a4,0x80002
800011d4:	00279793          	slli	a5,a5,0x2
800011d8:	d4c70713          	addi	a4,a4,-692 # 80001d4c <fctprintf+0xec>
800011dc:	00e787b3          	add	a5,a5,a4
800011e0:	0007a783          	lw	a5,0(a5)
800011e4:	00078067          	jalr	zero,0(a5)
                flags |= FLAGS_ZEROPAD;
800011e8:	0016e693          	ori	a3,a3,1
    while (*format) {
800011ec:	00070d13          	addi	s10,a4,0
800011f0:	f49ff06f          	jal	zero,80001138 <_vsnprintf+0x98>
                flags |= FLAGS_LEFT;
800011f4:	0026e693          	ori	a3,a3,2
    while (*format) {
800011f8:	00070d13          	addi	s10,a4,0
800011fc:	f3dff06f          	jal	zero,80001138 <_vsnprintf+0x98>
                flags |= FLAGS_PLUS;
80001200:	0046e693          	ori	a3,a3,4
    while (*format) {
80001204:	00070d13          	addi	s10,a4,0
80001208:	f31ff06f          	jal	zero,80001138 <_vsnprintf+0x98>
                flags |= FLAGS_HASH;
8000120c:	0106e693          	ori	a3,a3,16
    while (*format) {
80001210:	00070d13          	addi	s10,a4,0
80001214:	f25ff06f          	jal	zero,80001138 <_vsnprintf+0x98>
                flags |= FLAGS_SPACE;
80001218:	0086e693          	ori	a3,a3,8
    while (*format) {
8000121c:	00070d13          	addi	s10,a4,0
80001220:	f19ff06f          	jal	zero,80001138 <_vsnprintf+0x98>
    unsigned int i = 0U;
80001224:	00000b93          	addi	s7,zero,0
        i = i * 10U + (unsigned int)(*((*str)++) - '0');
80001228:	002b9793          	slli	a5,s7,0x2
8000122c:	017787b3          	add	a5,a5,s7
80001230:	00179793          	slli	a5,a5,0x1
80001234:	00a787b3          	add	a5,a5,a0
    while (_is_digit(**str)) {
80001238:	00074503          	lbu	a0,0(a4)
        i = i * 10U + (unsigned int)(*((*str)++) - '0');
8000123c:	fd078b93          	addi	s7,a5,-48
80001240:	00070d13          	addi	s10,a4,0
static inline bool _is_digit(char ch) { return (ch >= '0') && (ch <= '9'); }
80001244:	fd050793          	addi	a5,a0,-48
    while (_is_digit(**str)) {
80001248:	0ff7f793          	andi	a5,a5,255
8000124c:	00170713          	addi	a4,a4,1
80001250:	fcfafce3          	bgeu	s5,a5,80001228 <_vsnprintf+0x188>
        if (*format == '.') {
80001254:	02e00793          	addi	a5,zero,46
        precision = 0U;
80001258:	00000813          	addi	a6,zero,0
        if (*format == '.') {
8000125c:	f2f514e3          	bne	a0,a5,80001184 <_vsnprintf+0xe4>
            if (_is_digit(*format)) {
80001260:	001d4503          	lbu	a0,1(s10)
80001264:	00900793          	addi	a5,zero,9
            flags |= FLAGS_PRECISION;
80001268:	4006e693          	ori	a3,a3,1024
static inline bool _is_digit(char ch) { return (ch >= '0') && (ch <= '9'); }
8000126c:	fd050593          	addi	a1,a0,-48
            if (_is_digit(*format)) {
80001270:	0ff5f593          	andi	a1,a1,255
            format++;
80001274:	00070613          	addi	a2,a4,0
            if (_is_digit(*format)) {
80001278:	40b7fa63          	bgeu	a5,a1,8000168c <_vsnprintf+0x5ec>
            } else if (*format == '*') {
8000127c:	02a00793          	addi	a5,zero,42
80001280:	44f50263          	beq	a0,a5,800016c4 <_vsnprintf+0x624>
            format++;
80001284:	00070d13          	addi	s10,a4,0
        switch (*format) {
80001288:	06c00613          	addi	a2,zero,108
8000128c:	00170713          	addi	a4,a4,1
            format++;
80001290:	00070793          	addi	a5,a4,0
        switch (*format) {
80001294:	eec51ee3          	bne	a0,a2,80001190 <_vsnprintf+0xf0>
            if (*format == 'l') {
80001298:	001d4503          	lbu	a0,1(s10)
8000129c:	06c00713          	addi	a4,zero,108
            flags |= FLAGS_LONG;
800012a0:	1006e593          	ori	a1,a3,256
            if (*format == 'l') {
800012a4:	f0e514e3          	bne	a0,a4,800011ac <_vsnprintf+0x10c>
                DEBUG_MSG("LONG LONG SUPPORT DISABLED!");
800012a8:	800027b7          	lui	a5,0x80002
800012ac:	ce878793          	addi	a5,a5,-792 # 80001ce8 <fctprintf+0x88>
800012b0:	04c00713          	addi	a4,zero,76
void _putchar(char character) { UART(0) = character; }
800012b4:	10000637          	lui	a2,0x10000
                DEBUG_MSG("LONG LONG SUPPORT DISABLED!");
800012b8:	00178793          	addi	a5,a5,1
void _putchar(char character) { UART(0) = character; }
800012bc:	00e60023          	sb	a4,0(a2) # 10000000 <main-0x70000000>
                DEBUG_MSG("LONG LONG SUPPORT DISABLED!");
800012c0:	0007c703          	lbu	a4,0(a5)
800012c4:	fe071ae3          	bne	a4,zero,800012b8 <_vsnprintf+0x218>
        switch (*format) {
800012c8:	002d4503          	lbu	a0,2(s10)
                flags |= FLAGS_LONG_LONG;
800012cc:	3006e593          	ori	a1,a3,768
                format++;
800012d0:	002d0793          	addi	a5,s10,2
800012d4:	ed9ff06f          	jal	zero,800011ac <_vsnprintf+0x10c>

    // termination
    out((char)0, buffer, idx < maxlen ? idx : maxlen - 1U, maxlen);

    // return written chars without terminating \0
    return (int)idx;
800012d8:	05812a03          	lw	s4,88(sp)
800012dc:	05412a83          	lw	s5,84(sp)
800012e0:	05012b03          	lw	s6,80(sp)
800012e4:	04c12b83          	lw	s7,76(sp)
800012e8:	04812c03          	lw	s8,72(sp)
800012ec:	000d8413          	addi	s0,s11,0
    out((char)0, buffer, idx < maxlen ? idx : maxlen - 1U, maxlen);
800012f0:	009de463          	bltu	s11,s1,800012f8 <_vsnprintf+0x258>
800012f4:	fff48d93          	addi	s11,s1,-1
800012f8:	00048693          	addi	a3,s1,0
800012fc:	000d8613          	addi	a2,s11,0
80001300:	00090593          	addi	a1,s2,0
80001304:	00000513          	addi	a0,zero,0
80001308:	000980e7          	jalr	ra,0(s3)
}
8000130c:	06c12083          	lw	ra,108(sp)
80001310:	00040513          	addi	a0,s0,0
80001314:	06812403          	lw	s0,104(sp)
80001318:	06412483          	lw	s1,100(sp)
8000131c:	06012903          	lw	s2,96(sp)
80001320:	05c12983          	lw	s3,92(sp)
80001324:	04412c83          	lw	s9,68(sp)
80001328:	04012d03          	lw	s10,64(sp)
8000132c:	03c12d83          	lw	s11,60(sp)
80001330:	07010113          	addi	sp,sp,112
80001334:	00008067          	jalr	zero,0(ra)
        switch (*format) {
80001338:	07a00613          	addi	a2,zero,122
8000133c:	06c51063          	bne	a0,a2,8000139c <_vsnprintf+0x2fc>
            if (*format == 'l') {
80001340:	001d4503          	lbu	a0,1(s10)
            flags |=
80001344:	1006e593          	ori	a1,a3,256
            break;
80001348:	e65ff06f          	jal	zero,800011ac <_vsnprintf+0x10c>
            const int w = va_arg(va, int);
8000134c:	000cab83          	lw	s7,0(s9)
80001350:	004c8c93          	addi	s9,s9,4
            if (w < 0) {
80001354:	000bca63          	blt	s7,zero,80001368 <_vsnprintf+0x2c8>
        if (*format == '.') {
80001358:	001d4503          	lbu	a0,1(s10)
            format++;
8000135c:	00070d13          	addi	s10,a4,0
80001360:	00170713          	addi	a4,a4,1
80001364:	e15ff06f          	jal	zero,80001178 <_vsnprintf+0xd8>
        if (*format == '.') {
80001368:	001d4503          	lbu	a0,1(s10)
                flags |= FLAGS_LEFT; // reverse padding
8000136c:	0026e693          	ori	a3,a3,2
            format++;
80001370:	00070d13          	addi	s10,a4,0
                width = (unsigned int)-w;
80001374:	41700bb3          	sub	s7,zero,s7
            format++;
80001378:	00170713          	addi	a4,a4,1
8000137c:	dfdff06f          	jal	zero,80001178 <_vsnprintf+0xd8>
        switch (*format) {
80001380:	06700793          	addi	a5,zero,103
            format++;
80001384:	00070d13          	addi	s10,a4,0
        switch (*format) {
80001388:	00068593          	addi	a1,a3,0
8000138c:	e2a7f6e3          	bgeu	a5,a0,800011b8 <_vsnprintf+0x118>
80001390:	f9750793          	addi	a5,a0,-105
80001394:	0ff7f793          	andi	a5,a5,255
80001398:	01c0006f          	jal	zero,800013b4 <_vsnprintf+0x314>
            format++;
8000139c:	00070d13          	addi	s10,a4,0
        switch (*format) {
800013a0:	00068593          	addi	a1,a3,0
        switch (*format) {
800013a4:	f9750793          	addi	a5,a0,-105
800013a8:	0ff7f793          	andi	a5,a5,255
800013ac:	00f00713          	addi	a4,zero,15
800013b0:	d6f760e3          	bltu	a4,a5,80001110 <_vsnprintf+0x70>
800013b4:	00100c13          	addi	s8,zero,1
800013b8:	00009737          	lui	a4,0x9
800013bc:	00fc1c33          	sll	s8,s8,a5
800013c0:	04170713          	addi	a4,a4,65 # 9041 <main-0x7fff6fbf>
800013c4:	00ec7733          	and	a4,s8,a4
800013c8:	02e12023          	sw	a4,32(sp)
800013cc:	24071463          	bne	a4,zero,80001614 <_vsnprintf+0x574>
800013d0:	00a00713          	addi	a4,zero,10
800013d4:	18e78663          	beq	a5,a4,80001560 <_vsnprintf+0x4c0>
800013d8:	00700713          	addi	a4,zero,7
800013dc:	d2e79ae3          	bne	a5,a4,80001110 <_vsnprintf+0x70>
                idx = _ntoa_long(out, buffer, idx, maxlen,
800013e0:	000ca703          	lw	a4,0(s9)
            flags |= FLAGS_ZEROPAD | FLAGS_UPPERCASE;
800013e4:	0215e593          	ori	a1,a1,33
                idx = _ntoa_long(out, buffer, idx, maxlen,
800013e8:	00800793          	addi	a5,zero,8
800013ec:	00080893          	addi	a7,a6,0
800013f0:	000d8613          	addi	a2,s11,0
800013f4:	00b12223          	sw	a1,4(sp)
800013f8:	00f12023          	sw	a5,0(sp)
800013fc:	01000813          	addi	a6,zero,16
80001400:	00000793          	addi	a5,zero,0
80001404:	00048693          	addi	a3,s1,0
80001408:	00090593          	addi	a1,s2,0
8000140c:	00098513          	addi	a0,s3,0
80001410:	d79fe0ef          	jal	ra,80000188 <_ntoa_long>
                                 (unsigned long)((uintptr_t)va_arg(va, void *)),
80001414:	004c8c93          	addi	s9,s9,4
                idx = _ntoa_long(out, buffer, idx, maxlen,
80001418:	00050d93          	addi	s11,a0,0
            break;
8000141c:	d09ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
            if ((*format == 'g') || (*format == 'G'))
80001420:	06700793          	addi	a5,zero,103
80001424:	30f50263          	beq	a0,a5,80001728 <_vsnprintf+0x688>
80001428:	04700793          	addi	a5,zero,71
8000142c:	3cf50e63          	beq	a0,a5,80001808 <_vsnprintf+0x768>
            if ((*format == 'E') || (*format == 'G'))
80001430:	04500793          	addi	a5,zero,69
80001434:	3ef50063          	beq	a0,a5,80001814 <_vsnprintf+0x774>
            idx = _etoa(out, buffer, idx, maxlen, va_arg(va, double), precision,
80001438:	007c8c93          	addi	s9,s9,7
8000143c:	ff8cfc93          	andi	s9,s9,-8
80001440:	000ca703          	lw	a4,0(s9)
80001444:	004ca783          	lw	a5,4(s9)
80001448:	000d8613          	addi	a2,s11,0
8000144c:	00b12023          	sw	a1,0(sp)
80001450:	000b8893          	addi	a7,s7,0
80001454:	00048693          	addi	a3,s1,0
80001458:	00090593          	addi	a1,s2,0
8000145c:	00098513          	addi	a0,s3,0
80001460:	815ff0ef          	jal	ra,80000c74 <_etoa>
80001464:	008c8c93          	addi	s9,s9,8
80001468:	00050d93          	addi	s11,a0,0
            break;
8000146c:	cb9ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
            if (*format == 'F')
80001470:	04600793          	addi	a5,zero,70
80001474:	2cf50263          	beq	a0,a5,80001738 <_vsnprintf+0x698>
            idx = _ftoa(out, buffer, idx, maxlen, va_arg(va, double), precision,
80001478:	007c8c93          	addi	s9,s9,7
8000147c:	ff8cfc93          	andi	s9,s9,-8
80001480:	000ca703          	lw	a4,0(s9)
80001484:	004ca783          	lw	a5,4(s9)
80001488:	000d8613          	addi	a2,s11,0
8000148c:	00b12023          	sw	a1,0(sp)
80001490:	000b8893          	addi	a7,s7,0
80001494:	00048693          	addi	a3,s1,0
80001498:	00090593          	addi	a1,s2,0
8000149c:	00098513          	addi	a0,s3,0
800014a0:	a4cff0ef          	jal	ra,800006ec <_ftoa>
800014a4:	008c8c93          	addi	s9,s9,8
800014a8:	00050d93          	addi	s11,a0,0
            break;
800014ac:	c79ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
            out('%', buffer, idx++, maxlen);
800014b0:	000d8613          	addi	a2,s11,0
800014b4:	00048693          	addi	a3,s1,0
800014b8:	00090593          	addi	a1,s2,0
800014bc:	02500513          	addi	a0,zero,37
800014c0:	001d8d93          	addi	s11,s11,1
800014c4:	000980e7          	jalr	ra,0(s3)
            break;
800014c8:	c5dff06f          	jal	zero,80001124 <_vsnprintf+0x84>
                    const long value = va_arg(va, long);
800014cc:	004c8793          	addi	a5,s9,4
            if (!(flags & FLAGS_LEFT)) {
800014d0:	0025f593          	andi	a1,a1,2
                    const long value = va_arg(va, long);
800014d4:	02f12023          	sw	a5,32(sp)
            out(*format, buffer, idx++, maxlen);
800014d8:	001d8c13          	addi	s8,s11,1
            if (!(flags & FLAGS_LEFT)) {
800014dc:	34058663          	beq	a1,zero,80001828 <_vsnprintf+0x788>
            out((char)va_arg(va, int), buffer, idx++, maxlen);
800014e0:	000cc503          	lbu	a0,0(s9)
800014e4:	000d8613          	addi	a2,s11,0
800014e8:	00048693          	addi	a3,s1,0
800014ec:	00090593          	addi	a1,s2,0
800014f0:	000980e7          	jalr	ra,0(s3)
                while (l++ < width) {
800014f4:	00100793          	addi	a5,zero,1
800014f8:	017d8db3          	add	s11,s11,s7
800014fc:	4577fa63          	bgeu	a5,s7,80001950 <_vsnprintf+0x8b0>
                    out(' ', buffer, idx++, maxlen);
80001500:	000c0613          	addi	a2,s8,0
80001504:	00048693          	addi	a3,s1,0
80001508:	001c0c13          	addi	s8,s8,1
8000150c:	00090593          	addi	a1,s2,0
80001510:	02000513          	addi	a0,zero,32
80001514:	000980e7          	jalr	ra,0(s3)
                while (l++ < width) {
80001518:	ffbc14e3          	bne	s8,s11,80001500 <_vsnprintf+0x460>
            out((char)va_arg(va, int), buffer, idx++, maxlen);
8000151c:	02012c83          	lw	s9,32(sp)
            break;
80001520:	c05ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
            if (*format == 'h') {
80001524:	001d4503          	lbu	a0,1(s10)
            flags |= FLAGS_SHORT;
80001528:	0806e593          	ori	a1,a3,128
            if (*format == 'h') {
8000152c:	c8c510e3          	bne	a0,a2,800011ac <_vsnprintf+0x10c>
        switch (*format) {
80001530:	002d4503          	lbu	a0,2(s10)
                flags |= FLAGS_CHAR;
80001534:	0c06e593          	ori	a1,a3,192
                format++;
80001538:	002d0793          	addi	a5,s10,2
8000153c:	c71ff06f          	jal	zero,800011ac <_vsnprintf+0x10c>
    while (*format) {
80001540:	000d4503          	lbu	a0,0(s10)
        out = _out_null;
80001544:	800009b7          	lui	s3,0x80000
80001548:	04098993          	addi	s3,s3,64 # 80000040 <_out_null>
    while (*format) {
8000154c:	00000d93          	addi	s11,zero,0
80001550:	b8051ce3          	bne	a0,zero,800010e8 <_vsnprintf+0x48>
80001554:	00000413          	addi	s0,zero,0
    out((char)0, buffer, idx < maxlen ? idx : maxlen - 1U, maxlen);
80001558:	da9de0e3          	bltu	s11,s1,800012f8 <_vsnprintf+0x258>
8000155c:	d99ff06f          	jal	zero,800012f4 <_vsnprintf+0x254>
            const char *p = va_arg(va, char *);
80001560:	004c8793          	addi	a5,s9,4
80001564:	02f12423          	sw	a5,40(sp)
80001568:	000cac03          	lw	s8,0(s9)
            unsigned int l = _strnlen_s(p, precision ? precision : (size_t)-1);
8000156c:	fff00693          	addi	a3,zero,-1
80001570:	00080463          	beq	a6,zero,80001578 <_vsnprintf+0x4d8>
80001574:	00080693          	addi	a3,a6,0
    for (s = str; *s && maxsize--; ++s)
80001578:	000c4503          	lbu	a0,0(s8)
8000157c:	00dc06b3          	add	a3,s8,a3
80001580:	000c0793          	addi	a5,s8,0
80001584:	32050e63          	beq	a0,zero,800018c0 <_vsnprintf+0x820>
80001588:	00d78863          	beq	a5,a3,80001598 <_vsnprintf+0x4f8>
8000158c:	0017c703          	lbu	a4,1(a5)
80001590:	00178793          	addi	a5,a5,1
80001594:	fe071ae3          	bne	a4,zero,80001588 <_vsnprintf+0x4e8>
    return (unsigned int)(s - str);
80001598:	418787b3          	sub	a5,a5,s8
            if (flags & FLAGS_PRECISION) {
8000159c:	4005f713          	andi	a4,a1,1024
    return (unsigned int)(s - str);
800015a0:	02f12223          	sw	a5,36(sp)
            if (flags & FLAGS_PRECISION) {
800015a4:	14070263          	beq	a4,zero,800016e8 <_vsnprintf+0x648>
                l = (l < precision ? l : precision);
800015a8:	02412783          	lw	a5,36(sp)
800015ac:	00f87463          	bgeu	a6,a5,800015b4 <_vsnprintf+0x514>
800015b0:	03012223          	sw	a6,36(sp)
            if (!(flags & FLAGS_LEFT)) {
800015b4:	0025f593          	andi	a1,a1,2
800015b8:	3a058263          	beq	a1,zero,8000195c <_vsnprintf+0x8bc>
800015bc:	00200793          	addi	a5,zero,2
                out(*(p++), buffer, idx++, maxlen);
800015c0:	000d8c93          	addi	s9,s11,0
            if (!(flags & FLAGS_LEFT)) {
800015c4:	02f12023          	sw	a5,32(sp)
800015c8:	01980db3          	add	s11,a6,s9
                while (l++ < width) {
800015cc:	000c8793          	addi	a5,s9,0
            while ((*p != 0) && (!(flags & FLAGS_PRECISION) || precision--)) {
800015d0:	02fd8a63          	beq	s11,a5,80001604 <_vsnprintf+0x564>
                out(*(p++), buffer, idx++, maxlen);
800015d4:	00078613          	addi	a2,a5,0
800015d8:	00178793          	addi	a5,a5,1
800015dc:	00f12e23          	sw	a5,28(sp)
800015e0:	00048693          	addi	a3,s1,0
800015e4:	00090593          	addi	a1,s2,0
800015e8:	000980e7          	jalr	ra,0(s3)
            while ((*p != 0) && (!(flags & FLAGS_PRECISION) || precision--)) {
800015ec:	01c12783          	lw	a5,28(sp)
800015f0:	41978733          	sub	a4,a5,s9
800015f4:	00ec0733          	add	a4,s8,a4
800015f8:	00074503          	lbu	a0,0(a4)
800015fc:	fc051ae3          	bne	a0,zero,800015d0 <_vsnprintf+0x530>
                out(*(p++), buffer, idx++, maxlen);
80001600:	00078d93          	addi	s11,a5,0
            if (flags & FLAGS_LEFT) {
80001604:	02012783          	lw	a5,32(sp)
80001608:	12079c63          	bne	a5,zero,80001740 <_vsnprintf+0x6a0>
            const char *p = va_arg(va, char *);
8000160c:	02812c83          	lw	s9,40(sp)
            break;
80001610:	b15ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
            if (*format == 'x' || *format == 'X') {
80001614:	06f00793          	addi	a5,zero,111
80001618:	16f50063          	beq	a0,a5,80001778 <_vsnprintf+0x6d8>
8000161c:	26a7e263          	bltu	a5,a0,80001880 <_vsnprintf+0x7e0>
            if ((*format != 'i') && (*format != 'd')) {
80001620:	06900793          	addi	a5,zero,105
                flags &= ~FLAGS_HASH; // no hash for dec format
80001624:	fef5f693          	andi	a3,a1,-17
            if ((*format != 'i') && (*format != 'd')) {
80001628:	30f51463          	bne	a0,a5,80001930 <_vsnprintf+0x890>
            if (flags & FLAGS_PRECISION) {
8000162c:	4005f793          	andi	a5,a1,1024
80001630:	26079463          	bne	a5,zero,80001898 <_vsnprintf+0x7f8>
                if (flags & FLAGS_LONG_LONG) {
80001634:	2006f793          	andi	a5,a3,512
80001638:	ae0796e3          	bne	a5,zero,80001124 <_vsnprintf+0x84>
                } else if (flags & FLAGS_LONG) {
8000163c:	1006f793          	andi	a5,a3,256
                    const long value = va_arg(va, long);
80001640:	004c8c13          	addi	s8,s9,4
                } else if (flags & FLAGS_LONG) {
80001644:	32079e63          	bne	a5,zero,80001980 <_vsnprintf+0x8e0>
                        (flags & FLAGS_CHAR)    ? (char)va_arg(va, int)
80001648:	0406f793          	andi	a5,a3,64
                        : (flags & FLAGS_SHORT) ? (short int)va_arg(va, int)
8000164c:	24079a63          	bne	a5,zero,800018a0 <_vsnprintf+0x800>
80001650:	0806f793          	andi	a5,a3,128
                                                : va_arg(va, int);
80001654:	36078463          	beq	a5,zero,800019bc <_vsnprintf+0x91c>
                        : (flags & FLAGS_SHORT) ? (short int)va_arg(va, int)
80001658:	000c9783          	lh	a5,0(s9)
                        (unsigned int)(value > 0 ? value : 0 - value),
8000165c:	40f7d613          	srai	a2,a5,0xf
80001660:	00c7c733          	xor	a4,a5,a2
80001664:	40c70733          	sub	a4,a4,a2
80001668:	01071713          	slli	a4,a4,0x10
8000166c:	01075713          	srli	a4,a4,0x10
                    idx = _ntoa_long(
80001670:	00080893          	addi	a7,a6,0
80001674:	00d12223          	sw	a3,4(sp)
80001678:	01712023          	sw	s7,0(sp)
8000167c:	01f7d793          	srli	a5,a5,0x1f
80001680:	000d8613          	addi	a2,s11,0
80001684:	00a00813          	addi	a6,zero,10
80001688:	13c0006f          	jal	zero,800017c4 <_vsnprintf+0x724>
    while (_is_digit(**str)) {
8000168c:	00078713          	addi	a4,a5,0
        i = i * 10U + (unsigned int)(*((*str)++) - '0');
80001690:	00281793          	slli	a5,a6,0x2
80001694:	010787b3          	add	a5,a5,a6
80001698:	00160613          	addi	a2,a2,1
8000169c:	00179793          	slli	a5,a5,0x1
800016a0:	00a787b3          	add	a5,a5,a0
    while (_is_digit(**str)) {
800016a4:	00064503          	lbu	a0,0(a2)
        i = i * 10U + (unsigned int)(*((*str)++) - '0');
800016a8:	fd078813          	addi	a6,a5,-48
static inline bool _is_digit(char ch) { return (ch >= '0') && (ch <= '9'); }
800016ac:	fd050793          	addi	a5,a0,-48
    while (_is_digit(**str)) {
800016b0:	0ff7f793          	andi	a5,a5,255
800016b4:	fcf77ee3          	bgeu	a4,a5,80001690 <_vsnprintf+0x5f0>
800016b8:	00060d13          	addi	s10,a2,0
800016bc:	00160713          	addi	a4,a2,1
800016c0:	ac5ff06f          	jal	zero,80001184 <_vsnprintf+0xe4>
                precision = prec > 0 ? (unsigned int)prec : 0U;
800016c4:	000ca803          	lw	a6,0(s9)
        switch (*format) {
800016c8:	002d4503          	lbu	a0,2(s10)
                format++;
800016cc:	002d0d13          	addi	s10,s10,2
                precision = prec > 0 ? (unsigned int)prec : 0U;
800016d0:	fff84793          	xori	a5,a6,-1
800016d4:	41f7d793          	srai	a5,a5,0x1f
                const int prec = (int)va_arg(va, int);
800016d8:	004c8c93          	addi	s9,s9,4
                precision = prec > 0 ? (unsigned int)prec : 0U;
800016dc:	00f87833          	and	a6,a6,a5
                format++;
800016e0:	001d0713          	addi	a4,s10,1
800016e4:	aa1ff06f          	jal	zero,80001184 <_vsnprintf+0xe4>
            if (!(flags & FLAGS_LEFT)) {
800016e8:	0025f593          	andi	a1,a1,2
800016ec:	1e058463          	beq	a1,zero,800018d4 <_vsnprintf+0x834>
800016f0:	00200793          	addi	a5,zero,2
            while ((*p != 0) && (!(flags & FLAGS_PRECISION) || precision--)) {
800016f4:	000d8c93          	addi	s9,s11,0
            if (!(flags & FLAGS_LEFT)) {
800016f8:	02f12023          	sw	a5,32(sp)
                while (l++ < width) {
800016fc:	000c8d93          	addi	s11,s9,0
                out(*(p++), buffer, idx++, maxlen);
80001700:	000d8613          	addi	a2,s11,0
80001704:	00048693          	addi	a3,s1,0
80001708:	00090593          	addi	a1,s2,0
8000170c:	000980e7          	jalr	ra,0(s3)
80001710:	001d8d93          	addi	s11,s11,1
            while ((*p != 0) && (!(flags & FLAGS_PRECISION) || precision--)) {
80001714:	419d87b3          	sub	a5,s11,s9
80001718:	00fc07b3          	add	a5,s8,a5
8000171c:	0007c503          	lbu	a0,0(a5)
80001720:	fe0510e3          	bne	a0,zero,80001700 <_vsnprintf+0x660>
80001724:	ee1ff06f          	jal	zero,80001604 <_vsnprintf+0x564>
                flags |= FLAGS_ADAPT_EXP;
80001728:	000017b7          	lui	a5,0x1
8000172c:	80078793          	addi	a5,a5,-2048 # 800 <main-0x7ffff800>
80001730:	00f5e5b3          	or	a1,a1,a5
            if ((*format == 'E') || (*format == 'G'))
80001734:	d05ff06f          	jal	zero,80001438 <_vsnprintf+0x398>
                flags |= FLAGS_UPPERCASE;
80001738:	0205e593          	ori	a1,a1,32
8000173c:	d3dff06f          	jal	zero,80001478 <_vsnprintf+0x3d8>
80001740:	000d8c13          	addi	s8,s11,0
                while (l++ < width) {
80001744:	02412783          	lw	a5,36(sp)
80001748:	ed77f2e3          	bgeu	a5,s7,8000160c <_vsnprintf+0x56c>
8000174c:	01bb8eb3          	add	t4,s7,s11
80001750:	40fe8db3          	sub	s11,t4,a5
                    out(' ', buffer, idx++, maxlen);
80001754:	000c0613          	addi	a2,s8,0
80001758:	00048693          	addi	a3,s1,0
8000175c:	001c0c13          	addi	s8,s8,1
80001760:	00090593          	addi	a1,s2,0
80001764:	02000513          	addi	a0,zero,32
80001768:	000980e7          	jalr	ra,0(s3)
                while (l++ < width) {
8000176c:	ffbc14e3          	bne	s8,s11,80001754 <_vsnprintf+0x6b4>
            const char *p = va_arg(va, char *);
80001770:	02812c83          	lw	s9,40(sp)
80001774:	9b1ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
        switch (*format) {
80001778:	00800693          	addi	a3,zero,8
            if (flags & FLAGS_PRECISION) {
8000177c:	4005f713          	andi	a4,a1,1024
                flags &= ~(FLAGS_PLUS | FLAGS_SPACE);
80001780:	ff35f793          	andi	a5,a1,-13
            if (flags & FLAGS_PRECISION) {
80001784:	00070463          	beq	a4,zero,8000178c <_vsnprintf+0x6ec>
                flags &= ~FLAGS_ZEROPAD;
80001788:	ff25f793          	andi	a5,a1,-14
                if (flags & FLAGS_LONG_LONG) {
8000178c:	2007f713          	andi	a4,a5,512
80001790:	98071ae3          	bne	a4,zero,80001124 <_vsnprintf+0x84>
                } else if (flags & FLAGS_LONG) {
80001794:	1007f713          	andi	a4,a5,256
                    const long value = va_arg(va, long);
80001798:	004c8c13          	addi	s8,s9,4
                } else if (flags & FLAGS_LONG) {
8000179c:	10071863          	bne	a4,zero,800018ac <_vsnprintf+0x80c>
                        (flags & FLAGS_CHAR)
800017a0:	0407f713          	andi	a4,a5,64
                        : (flags & FLAGS_SHORT)
800017a4:	20070463          	beq	a4,zero,800019ac <_vsnprintf+0x90c>
800017a8:	000cc703          	lbu	a4,0(s9)
                    idx = _ntoa_long(out, buffer, idx, maxlen, value, false,
800017ac:	00f12223          	sw	a5,4(sp)
800017b0:	01712023          	sw	s7,0(sp)
800017b4:	00080893          	addi	a7,a6,0
800017b8:	00068813          	addi	a6,a3,0
800017bc:	000d8613          	addi	a2,s11,0
800017c0:	00000793          	addi	a5,zero,0
800017c4:	00048693          	addi	a3,s1,0
800017c8:	00090593          	addi	a1,s2,0
800017cc:	00098513          	addi	a0,s3,0
800017d0:	9b9fe0ef          	jal	ra,80000188 <_ntoa_long>
800017d4:	000c0c93          	addi	s9,s8,0
800017d8:	00050d93          	addi	s11,a0,0
            break;
800017dc:	949ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
            if (*format == 'x' || *format == 'X') {
800017e0:	05800793          	addi	a5,zero,88
800017e4:	02f50c63          	beq	a0,a5,8000181c <_vsnprintf+0x77c>
800017e8:	06200793          	addi	a5,zero,98
        switch (*format) {
800017ec:	00200693          	addi	a3,zero,2
800017f0:	f8f506e3          	beq	a0,a5,8000177c <_vsnprintf+0x6dc>
            if (flags & FLAGS_PRECISION) {
800017f4:	4005f793          	andi	a5,a1,1024
                flags &= ~FLAGS_ZEROPAD;
800017f8:	fee5f693          	andi	a3,a1,-18
            if (flags & FLAGS_PRECISION) {
800017fc:	e2079ce3          	bne	a5,zero,80001634 <_vsnprintf+0x594>
                flags &= ~FLAGS_HASH; // no hash for dec format
80001800:	fef5f693          	andi	a3,a1,-17
80001804:	e31ff06f          	jal	zero,80001634 <_vsnprintf+0x594>
                flags |= FLAGS_ADAPT_EXP;
80001808:	000017b7          	lui	a5,0x1
8000180c:	80078793          	addi	a5,a5,-2048 # 800 <main-0x7ffff800>
80001810:	00f5e5b3          	or	a1,a1,a5
                flags |= FLAGS_UPPERCASE;
80001814:	0205e593          	ori	a1,a1,32
80001818:	c21ff06f          	jal	zero,80001438 <_vsnprintf+0x398>
                flags |= FLAGS_UPPERCASE;
8000181c:	0205e593          	ori	a1,a1,32
80001820:	01000693          	addi	a3,zero,16
80001824:	f59ff06f          	jal	zero,8000177c <_vsnprintf+0x6dc>
                while (l++ < width) {
80001828:	00100793          	addi	a5,zero,1
8000182c:	1177f863          	bgeu	a5,s7,8000193c <_vsnprintf+0x89c>
80001830:	fffd8c13          	addi	s8,s11,-1
80001834:	017c07b3          	add	a5,s8,s7
80001838:	00f12e23          	sw	a5,28(sp)
8000183c:	000d8c13          	addi	s8,s11,0
                    out(' ', buffer, idx++, maxlen);
80001840:	000c0613          	addi	a2,s8,0
80001844:	00048693          	addi	a3,s1,0
80001848:	00090593          	addi	a1,s2,0
8000184c:	02000513          	addi	a0,zero,32
80001850:	000980e7          	jalr	ra,0(s3)
                while (l++ < width) {
80001854:	01c12783          	lw	a5,28(sp)
                    out(' ', buffer, idx++, maxlen);
80001858:	001c0c13          	addi	s8,s8,1
                while (l++ < width) {
8000185c:	fefc12e3          	bne	s8,a5,80001840 <_vsnprintf+0x7a0>
            out((char)va_arg(va, int), buffer, idx++, maxlen);
80001860:	000cc503          	lbu	a0,0(s9)
80001864:	000c0613          	addi	a2,s8,0
80001868:	00048693          	addi	a3,s1,0
8000186c:	00090593          	addi	a1,s2,0
80001870:	000980e7          	jalr	ra,0(s3)
80001874:	017d8db3          	add	s11,s11,s7
80001878:	02012c83          	lw	s9,32(sp)
8000187c:	8a9ff06f          	jal	zero,80001124 <_vsnprintf+0x84>
80001880:	07800793          	addi	a5,zero,120
        switch (*format) {
80001884:	01000693          	addi	a3,zero,16
80001888:	eef50ae3          	beq	a0,a5,8000177c <_vsnprintf+0x6dc>
                flags &= ~FLAGS_HASH; // no hash for dec format
8000188c:	fef5f593          	andi	a1,a1,-17
80001890:	00a00693          	addi	a3,zero,10
80001894:	ee9ff06f          	jal	zero,8000177c <_vsnprintf+0x6dc>
                flags &= ~FLAGS_ZEROPAD;
80001898:	fee5f693          	andi	a3,a1,-18
            if ((*format == 'i') || (*format == 'd')) {
8000189c:	d99ff06f          	jal	zero,80001634 <_vsnprintf+0x594>
800018a0:	000cc783          	lbu	a5,0(s9)
800018a4:	00078713          	addi	a4,a5,0
800018a8:	dc9ff06f          	jal	zero,80001670 <_vsnprintf+0x5d0>
                    idx = _ntoa_long(out, buffer, idx, maxlen,
800018ac:	000ca703          	lw	a4,0(s9)
800018b0:	00080893          	addi	a7,a6,0
800018b4:	00f12223          	sw	a5,4(sp)
800018b8:	01712023          	sw	s7,0(sp)
800018bc:	efdff06f          	jal	zero,800017b8 <_vsnprintf+0x718>
            if (flags & FLAGS_PRECISION) {
800018c0:	4005f793          	andi	a5,a1,1024
800018c4:	02f12223          	sw	a5,36(sp)
800018c8:	10079863          	bne	a5,zero,800019d8 <_vsnprintf+0x938>
            if (!(flags & FLAGS_LEFT)) {
800018cc:	0025f593          	andi	a1,a1,2
800018d0:	e60598e3          	bne	a1,zero,80001740 <_vsnprintf+0x6a0>
                while (l++ < width) {
800018d4:	02412783          	lw	a5,36(sp)
800018d8:	02012623          	sw	zero,44(sp)
800018dc:	1177fa63          	bgeu	a5,s7,800019f0 <_vsnprintf+0x950>
800018e0:	02412783          	lw	a5,36(sp)
800018e4:	01bb8cb3          	add	s9,s7,s11
800018e8:	40fc8cb3          	sub	s9,s9,a5
800018ec:	01012e23          	sw	a6,28(sp)
                    out(' ', buffer, idx++, maxlen);
800018f0:	000d8613          	addi	a2,s11,0
800018f4:	00048693          	addi	a3,s1,0
800018f8:	00090593          	addi	a1,s2,0
800018fc:	02000513          	addi	a0,zero,32
80001900:	000980e7          	jalr	ra,0(s3)
80001904:	001d8d93          	addi	s11,s11,1
                while (l++ < width) {
80001908:	01c12803          	lw	a6,28(sp)
8000190c:	ff9d90e3          	bne	s11,s9,800018ec <_vsnprintf+0x84c>
            while ((*p != 0) && (!(flags & FLAGS_PRECISION) || precision--)) {
80001910:	000c4503          	lbu	a0,0(s8)
80001914:	001b8793          	addi	a5,s7,1
80001918:	02f12223          	sw	a5,36(sp)
8000191c:	ce0508e3          	beq	a0,zero,8000160c <_vsnprintf+0x56c>
80001920:	02c12783          	lw	a5,44(sp)
80001924:	ca0792e3          	bne	a5,zero,800015c8 <_vsnprintf+0x528>
80001928:	02012023          	sw	zero,32(sp)
8000192c:	dd1ff06f          	jal	zero,800016fc <_vsnprintf+0x65c>
                flags &= ~FLAGS_HASH; // no hash for dec format
80001930:	00068593          	addi	a1,a3,0
            if ((*format != 'i') && (*format != 'd')) {
80001934:	00a00693          	addi	a3,zero,10
80001938:	e45ff06f          	jal	zero,8000177c <_vsnprintf+0x6dc>
            out((char)va_arg(va, int), buffer, idx++, maxlen);
8000193c:	000cc503          	lbu	a0,0(s9)
80001940:	000d8613          	addi	a2,s11,0
80001944:	00048693          	addi	a3,s1,0
80001948:	00090593          	addi	a1,s2,0
8000194c:	000980e7          	jalr	ra,0(s3)
80001950:	02012c83          	lw	s9,32(sp)
80001954:	000c0d93          	addi	s11,s8,0
            break;
80001958:	fccff06f          	jal	zero,80001124 <_vsnprintf+0x84>
                while (l++ < width) {
8000195c:	40000793          	addi	a5,zero,1024
80001960:	02f12623          	sw	a5,44(sp)
80001964:	02412783          	lw	a5,36(sp)
80001968:	f777ece3          	bltu	a5,s7,800018e0 <_vsnprintf+0x840>
            while ((*p != 0) && (!(flags & FLAGS_PRECISION) || precision--)) {
8000196c:	ca0500e3          	beq	a0,zero,8000160c <_vsnprintf+0x56c>
                while (l++ < width) {
80001970:	00178793          	addi	a5,a5,1
80001974:	02f12223          	sw	a5,36(sp)
80001978:	000d8c93          	addi	s9,s11,0
8000197c:	c4dff06f          	jal	zero,800015c8 <_vsnprintf+0x528>
                    const long value = va_arg(va, long);
80001980:	000ca783          	lw	a5,0(s9)
                    idx = _ntoa_long(
80001984:	00d12223          	sw	a3,4(sp)
80001988:	00080893          	addi	a7,a6,0
                        (unsigned long)(value > 0 ? value : 0 - value),
8000198c:	41f7d713          	srai	a4,a5,0x1f
80001990:	00f746b3          	xor	a3,a4,a5
                    idx = _ntoa_long(
80001994:	01712023          	sw	s7,0(sp)
80001998:	000d8613          	addi	a2,s11,0
8000199c:	40e68733          	sub	a4,a3,a4
800019a0:	01f7d793          	srli	a5,a5,0x1f
800019a4:	00a00813          	addi	a6,zero,10
800019a8:	e1dff06f          	jal	zero,800017c4 <_vsnprintf+0x724>
                        : (flags & FLAGS_SHORT)
800019ac:	0807f713          	andi	a4,a5,128
                            : va_arg(va, unsigned int);
800019b0:	02070063          	beq	a4,zero,800019d0 <_vsnprintf+0x930>
800019b4:	000cd703          	lhu	a4,0(s9)
800019b8:	df5ff06f          	jal	zero,800017ac <_vsnprintf+0x70c>
                                                : va_arg(va, int);
800019bc:	000ca783          	lw	a5,0(s9)
                        (unsigned int)(value > 0 ? value : 0 - value),
800019c0:	41f7d613          	srai	a2,a5,0x1f
800019c4:	00f64733          	xor	a4,a2,a5
800019c8:	40c70733          	sub	a4,a4,a2
800019cc:	ca5ff06f          	jal	zero,80001670 <_vsnprintf+0x5d0>
                            : va_arg(va, unsigned int);
800019d0:	000ca703          	lw	a4,0(s9)
800019d4:	dd9ff06f          	jal	zero,800017ac <_vsnprintf+0x70c>
            if (!(flags & FLAGS_LEFT)) {
800019d8:	0025f793          	andi	a5,a1,2
800019dc:	02f12223          	sw	a5,36(sp)
800019e0:	f6078ee3          	beq	a5,zero,8000195c <_vsnprintf+0x8bc>
800019e4:	000d8c13          	addi	s8,s11,0
            unsigned int l = _strnlen_s(p, precision ? precision : (size_t)-1);
800019e8:	02012223          	sw	zero,36(sp)
800019ec:	d59ff06f          	jal	zero,80001744 <_vsnprintf+0x6a4>
                while (l++ < width) {
800019f0:	00178793          	addi	a5,a5,1
800019f4:	02f12223          	sw	a5,36(sp)
800019f8:	000d8c93          	addi	s9,s11,0
            while ((*p != 0) && (!(flags & FLAGS_PRECISION) || precision--)) {
800019fc:	d00510e3          	bne	a0,zero,800016fc <_vsnprintf+0x65c>
            const char *p = va_arg(va, char *);
80001a00:	02812c83          	lw	s9,40(sp)
80001a04:	f20ff06f          	jal	zero,80001124 <_vsnprintf+0x84>

80001a08 <char2int>:
int char2int(char c) { return c - '0'; }
80001a08:	fd050513          	addi	a0,a0,-48
80001a0c:	00008067          	jalr	zero,0(ra)

80001a10 <get_char>:
    while ((UART(5) & 0x01) == 0)
80001a10:	10000737          	lui	a4,0x10000
80001a14:	00570713          	addi	a4,a4,5 # 10000005 <main-0x6ffffffb>
80001a18:	100006b7          	lui	a3,0x10000
80001a1c:	00074783          	lbu	a5,0(a4)
80001a20:	0017f793          	andi	a5,a5,1
80001a24:	fe078ce3          	beq	a5,zero,80001a1c <get_char+0xc>
    return UART(0);
80001a28:	0006c503          	lbu	a0,0(a3) # 10000000 <main-0x70000000>
}
80001a2c:	00008067          	jalr	zero,0(ra)

80001a30 <get_string>:
    while ((UART(5) & 0x01) == 0)
80001a30:	10000737          	lui	a4,0x10000
80001a34:	00570713          	addi	a4,a4,5 # 10000005 <main-0x6ffffffb>
80001a38:	100006b7          	lui	a3,0x10000
80001a3c:	00074783          	lbu	a5,0(a4)
80001a40:	0017f793          	andi	a5,a5,1
80001a44:	fe078ce3          	beq	a5,zero,80001a3c <get_string+0xc>
    return UART(0);
80001a48:	0006c783          	lbu	a5,0(a3) # 10000000 <main-0x70000000>
    while (c != '\n') {
80001a4c:	00a00893          	addi	a7,zero,10
    return UART(0);
80001a50:	0ff7f813          	andi	a6,a5,255
    while (c != '\n') {
80001a54:	07178663          	beq	a5,a7,80001ac0 <get_string+0x90>
    while ((UART(5) & 0x01) == 0)
80001a58:	10000737          	lui	a4,0x10000
80001a5c:	00570713          	addi	a4,a4,5 # 10000005 <main-0x6ffffffb>
    int i = 0;
80001a60:	00000693          	addi	a3,zero,0
    while ((UART(5) & 0x01) == 0)
80001a64:	10000337          	lui	t1,0x10000
        if (i < size) {
80001a68:	00068613          	addi	a2,a3,0
80001a6c:	00b6d863          	bge	a3,a1,80001a7c <get_string+0x4c>
            buffer[i] = c;
80001a70:	00d507b3          	add	a5,a0,a3
80001a74:	01078023          	sb	a6,0(a5)
            i++;
80001a78:	00168613          	addi	a2,a3,1
    while ((UART(5) & 0x01) == 0)
80001a7c:	00074783          	lbu	a5,0(a4)
80001a80:	0017f793          	andi	a5,a5,1
80001a84:	fe078ce3          	beq	a5,zero,80001a7c <get_string+0x4c>
    return UART(0);
80001a88:	00034783          	lbu	a5,0(t1) # 10000000 <main-0x70000000>
80001a8c:	0ff7f813          	andi	a6,a5,255
    while (c != '\n') {
80001a90:	03178663          	beq	a5,a7,80001abc <get_string+0x8c>
80001a94:	02b6ca63          	blt	a3,a1,80001ac8 <get_string+0x98>
    while ((UART(5) & 0x01) == 0)
80001a98:	10000737          	lui	a4,0x10000
80001a9c:	00570713          	addi	a4,a4,5 # 10000005 <main-0x6ffffffb>
80001aa0:	100005b7          	lui	a1,0x10000
    while (c != '\n') {
80001aa4:	00a00693          	addi	a3,zero,10
    while ((UART(5) & 0x01) == 0)
80001aa8:	00074783          	lbu	a5,0(a4)
80001aac:	0017f793          	andi	a5,a5,1
80001ab0:	fe078ce3          	beq	a5,zero,80001aa8 <get_string+0x78>
    return UART(0);
80001ab4:	0005c783          	lbu	a5,0(a1) # 10000000 <main-0x70000000>
    while (c != '\n') {
80001ab8:	fed798e3          	bne	a5,a3,80001aa8 <get_string+0x78>
    buffer[i] = '\0';
80001abc:	00c50533          	add	a0,a0,a2
80001ac0:	00050023          	sb	zero,0(a0)
}
80001ac4:	00008067          	jalr	zero,0(ra)
    while (c != '\n') {
80001ac8:	00060693          	addi	a3,a2,0
80001acc:	f9dff06f          	jal	zero,80001a68 <get_string+0x38>

80001ad0 <str2int>:
    while (str[i] != '\0') {
80001ad0:	00054703          	lbu	a4,0(a0)
80001ad4:	02070463          	beq	a4,zero,80001afc <str2int+0x2c>
80001ad8:	00150793          	addi	a5,a0,1
    int result = 0;
80001adc:	00000513          	addi	a0,zero,0
        result = result * base + char2int(str[i]);
80001ae0:	02a58533          	mul	a0,a1,a0
    while (str[i] != '\0') {
80001ae4:	00178793          	addi	a5,a5,1
int char2int(char c) { return c - '0'; }
80001ae8:	fd070693          	addi	a3,a4,-48
    while (str[i] != '\0') {
80001aec:	fff7c703          	lbu	a4,-1(a5)
        result = result * base + char2int(str[i]);
80001af0:	00a68533          	add	a0,a3,a0
    while (str[i] != '\0') {
80001af4:	fe0716e3          	bne	a4,zero,80001ae0 <str2int+0x10>
80001af8:	00008067          	jalr	zero,0(ra)
    int result = 0;
80001afc:	00000513          	addi	a0,zero,0
}
80001b00:	00008067          	jalr	zero,0(ra)

80001b04 <_putchar>:
void _putchar(char character) { UART(0) = character; }
80001b04:	100007b7          	lui	a5,0x10000
80001b08:	00a78023          	sb	a0,0(a5) # 10000000 <main-0x70000000>
80001b0c:	00008067          	jalr	zero,0(ra)

80001b10 <printf_>:

///////////////////////////////////////////////////////////////////////////////

int printf_(const char *format, ...) {
80001b10:	fc010113          	addi	sp,sp,-64
    va_list va;
    va_start(va, format);
80001b14:	02410313          	addi	t1,sp,36
    char buffer[1];
    const int ret = _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
80001b18:	80000e37          	lui	t3,0x80000
int printf_(const char *format, ...) {
80001b1c:	02b12223          	sw	a1,36(sp)
80001b20:	02c12423          	sw	a2,40(sp)
80001b24:	02d12623          	sw	a3,44(sp)
80001b28:	02e12823          	sw	a4,48(sp)
    const int ret = _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
80001b2c:	00050693          	addi	a3,a0,0
80001b30:	00810593          	addi	a1,sp,8
80001b34:	00030713          	addi	a4,t1,0
80001b38:	044e0513          	addi	a0,t3,68 # 80000044 <_out_char>
80001b3c:	fff00613          	addi	a2,zero,-1
int printf_(const char *format, ...) {
80001b40:	00112e23          	sw	ra,28(sp)
80001b44:	02f12a23          	sw	a5,52(sp)
80001b48:	03012c23          	sw	a6,56(sp)
80001b4c:	03112e23          	sw	a7,60(sp)
    va_start(va, format);
80001b50:	00612623          	sw	t1,12(sp)
    const int ret = _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
80001b54:	d4cff0ef          	jal	ra,800010a0 <_vsnprintf>
    va_end(va);
    return ret;
}
80001b58:	01c12083          	lw	ra,28(sp)
80001b5c:	04010113          	addi	sp,sp,64
80001b60:	00008067          	jalr	zero,0(ra)

80001b64 <sprintf_>:

int sprintf_(char *buffer, const char *format, ...) {
80001b64:	fc010113          	addi	sp,sp,-64
    va_list va;
    va_start(va, format);
80001b68:	02810313          	addi	t1,sp,40
int sprintf_(char *buffer, const char *format, ...) {
80001b6c:	00058e93          	addi	t4,a1,0
    const int ret = _vsnprintf(_out_buffer, buffer, (size_t)-1, format, va);
80001b70:	80000e37          	lui	t3,0x80000
int sprintf_(char *buffer, const char *format, ...) {
80001b74:	02c12423          	sw	a2,40(sp)
80001b78:	02d12623          	sw	a3,44(sp)
80001b7c:	02e12823          	sw	a4,48(sp)
    const int ret = _vsnprintf(_out_buffer, buffer, (size_t)-1, format, va);
80001b80:	00050593          	addi	a1,a0,0
80001b84:	000e8693          	addi	a3,t4,0
80001b88:	00030713          	addi	a4,t1,0
80001b8c:	030e0513          	addi	a0,t3,48 # 80000030 <_out_buffer>
80001b90:	fff00613          	addi	a2,zero,-1
int sprintf_(char *buffer, const char *format, ...) {
80001b94:	00112e23          	sw	ra,28(sp)
80001b98:	02f12a23          	sw	a5,52(sp)
80001b9c:	03012c23          	sw	a6,56(sp)
80001ba0:	03112e23          	sw	a7,60(sp)
    va_start(va, format);
80001ba4:	00612623          	sw	t1,12(sp)
    const int ret = _vsnprintf(_out_buffer, buffer, (size_t)-1, format, va);
80001ba8:	cf8ff0ef          	jal	ra,800010a0 <_vsnprintf>
    va_end(va);
    return ret;
}
80001bac:	01c12083          	lw	ra,28(sp)
80001bb0:	04010113          	addi	sp,sp,64
80001bb4:	00008067          	jalr	zero,0(ra)

80001bb8 <snprintf_>:

int snprintf_(char *buffer, size_t count, const char *format, ...) {
80001bb8:	fc010113          	addi	sp,sp,-64
    va_list va;
    va_start(va, format);
80001bbc:	02c10313          	addi	t1,sp,44
int snprintf_(char *buffer, size_t count, const char *format, ...) {
80001bc0:	00058f13          	addi	t5,a1,0
80001bc4:	00060e93          	addi	t4,a2,0
    const int ret = _vsnprintf(_out_buffer, buffer, count, format, va);
80001bc8:	80000e37          	lui	t3,0x80000
int snprintf_(char *buffer, size_t count, const char *format, ...) {
80001bcc:	02d12623          	sw	a3,44(sp)
80001bd0:	02e12823          	sw	a4,48(sp)
    const int ret = _vsnprintf(_out_buffer, buffer, count, format, va);
80001bd4:	00050593          	addi	a1,a0,0
80001bd8:	000f0613          	addi	a2,t5,0
80001bdc:	000e8693          	addi	a3,t4,0
80001be0:	00030713          	addi	a4,t1,0
80001be4:	030e0513          	addi	a0,t3,48 # 80000030 <_out_buffer>
int snprintf_(char *buffer, size_t count, const char *format, ...) {
80001be8:	00112e23          	sw	ra,28(sp)
80001bec:	02f12a23          	sw	a5,52(sp)
80001bf0:	03012c23          	sw	a6,56(sp)
80001bf4:	03112e23          	sw	a7,60(sp)
    va_start(va, format);
80001bf8:	00612623          	sw	t1,12(sp)
    const int ret = _vsnprintf(_out_buffer, buffer, count, format, va);
80001bfc:	ca4ff0ef          	jal	ra,800010a0 <_vsnprintf>
    va_end(va);
    return ret;
}
80001c00:	01c12083          	lw	ra,28(sp)
80001c04:	04010113          	addi	sp,sp,64
80001c08:	00008067          	jalr	zero,0(ra)

80001c0c <vprintf_>:

int vprintf_(const char *format, va_list va) {
80001c0c:	fe010113          	addi	sp,sp,-32
80001c10:	00050693          	addi	a3,a0,0
    char buffer[1];
    return _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
80001c14:	80000537          	lui	a0,0x80000
int vprintf_(const char *format, va_list va) {
80001c18:	00058713          	addi	a4,a1,0
    return _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
80001c1c:	04450513          	addi	a0,a0,68 # 80000044 <_out_char>
80001c20:	00c10593          	addi	a1,sp,12
80001c24:	fff00613          	addi	a2,zero,-1
int vprintf_(const char *format, va_list va) {
80001c28:	00112e23          	sw	ra,28(sp)
    return _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
80001c2c:	c74ff0ef          	jal	ra,800010a0 <_vsnprintf>
}
80001c30:	01c12083          	lw	ra,28(sp)
80001c34:	02010113          	addi	sp,sp,32
80001c38:	00008067          	jalr	zero,0(ra)

80001c3c <vsnprintf_>:

int vsnprintf_(char *buffer, size_t count, const char *format, va_list va) {
80001c3c:	00058893          	addi	a7,a1,0
80001c40:	00060813          	addi	a6,a2,0
    return _vsnprintf(_out_buffer, buffer, count, format, va);
80001c44:	800007b7          	lui	a5,0x80000
int vsnprintf_(char *buffer, size_t count, const char *format, va_list va) {
80001c48:	00068713          	addi	a4,a3,0
    return _vsnprintf(_out_buffer, buffer, count, format, va);
80001c4c:	00050593          	addi	a1,a0,0
80001c50:	00088613          	addi	a2,a7,0
80001c54:	00080693          	addi	a3,a6,0
80001c58:	03078513          	addi	a0,a5,48 # 80000030 <_out_buffer>
80001c5c:	c44ff06f          	jal	zero,800010a0 <_vsnprintf>

80001c60 <fctprintf>:
}

int fctprintf(void (*out)(char character, void *arg), void *arg,
              const char *format, ...) {
80001c60:	fc010113          	addi	sp,sp,-64
    va_list va;
    va_start(va, format);
80001c64:	02c10313          	addi	t1,sp,44
    const out_fct_wrap_type out_fct_wrap = {out, arg};
    const int ret = _vsnprintf(_out_fct, (char *)(uintptr_t)&out_fct_wrap,
80001c68:	80000f37          	lui	t5,0x80000
              const char *format, ...) {
80001c6c:	00050e93          	addi	t4,a0,0
80001c70:	00058e13          	addi	t3,a1,0
80001c74:	02d12623          	sw	a3,44(sp)
80001c78:	02e12823          	sw	a4,48(sp)
    const int ret = _vsnprintf(_out_fct, (char *)(uintptr_t)&out_fct_wrap,
80001c7c:	00060693          	addi	a3,a2,0
80001c80:	00810593          	addi	a1,sp,8
80001c84:	00030713          	addi	a4,t1,0
80001c88:	6d8f0513          	addi	a0,t5,1752 # 800006d8 <_out_fct>
80001c8c:	fff00613          	addi	a2,zero,-1
              const char *format, ...) {
80001c90:	00112e23          	sw	ra,28(sp)
    const out_fct_wrap_type out_fct_wrap = {out, arg};
80001c94:	01d12423          	sw	t4,8(sp)
80001c98:	01c12623          	sw	t3,12(sp)
              const char *format, ...) {
80001c9c:	02f12a23          	sw	a5,52(sp)
80001ca0:	03012c23          	sw	a6,56(sp)
80001ca4:	03112e23          	sw	a7,60(sp)
    va_start(va, format);
80001ca8:	00612223          	sw	t1,4(sp)
    const int ret = _vsnprintf(_out_fct, (char *)(uintptr_t)&out_fct_wrap,
80001cac:	bf4ff0ef          	jal	ra,800010a0 <_vsnprintf>
                               (size_t)-1, format, va);
    va_end(va);
    return ret;
}
80001cb0:	01c12083          	lw	ra,28(sp)
80001cb4:	04010113          	addi	sp,sp,64
80001cb8:	00008067          	jalr	zero,0(ra)

Disassembly of section .rodata:

80001cc0 <pow10.0-0x198>:
80001cc0:	754e                	.insn	2, 0x754e
80001cc2:	626d                	.insn	2, 0x626d
80001cc4:	7265                	.insn	2, 0x7265
80001cc6:	203a                	.insn	2, 0x203a
80001cc8:	7d66257b          	.insn	4, 0x7d66257b
80001ccc:	000a                	.insn	2, 0x000a
80001cce:	0000                	.insn	2, 0x
80001cd0:	6e66                	.insn	2, 0x6e66
80001cd2:	2b69                	.insn	2, 0x2b69
80001cd4:	0000                	.insn	2, 0x
80001cd6:	0000                	.insn	2, 0x
80001cd8:	6e66                	.insn	2, 0x6e66
80001cda:	0069                	.insn	2, 0x0069
80001cdc:	616e                	.insn	2, 0x616e
80001cde:	006e                	.insn	2, 0x006e
80001ce0:	6e66                	.insn	2, 0x6e66
80001ce2:	2d69                	.insn	2, 0x2d69
80001ce4:	0000                	.insn	2, 0x
80001ce6:	0000                	.insn	2, 0x
80001ce8:	4f4c                	.insn	2, 0x4f4c
80001cea:	474e                	.insn	2, 0x474e
80001cec:	4c20                	.insn	2, 0x4c20
80001cee:	20474e4f          	fnmadd.s	ft8,fa4,ft4,ft4,rmm
80001cf2:	50505553          	.insn	4, 0x50505553
80001cf6:	2054524f          	fnmadd.s	ft4,fs0,ft5,ft4,unknown
80001cfa:	4944                	.insn	2, 0x4944
80001cfc:	4c424153          	.insn	4, 0x4c424153
80001d00:	4445                	.insn	2, 0x4445
80001d02:	0021                	.insn	2, 0x0021
80001d04:	0000                	.insn	2, 0x
80001d06:	0000                	.insn	2, 0x
80001d08:	1218                	.insn	2, 0x1218
80001d0a:	8000                	.insn	2, 0x8000
80001d0c:	1160                	.insn	2, 0x1160
80001d0e:	8000                	.insn	2, 0x8000
80001d10:	1160                	.insn	2, 0x1160
80001d12:	8000                	.insn	2, 0x8000
80001d14:	120c                	.insn	2, 0x120c
80001d16:	8000                	.insn	2, 0x8000
80001d18:	1160                	.insn	2, 0x1160
80001d1a:	8000                	.insn	2, 0x8000
80001d1c:	1160                	.insn	2, 0x1160
80001d1e:	8000                	.insn	2, 0x8000
80001d20:	1160                	.insn	2, 0x1160
80001d22:	8000                	.insn	2, 0x8000
80001d24:	1160                	.insn	2, 0x1160
80001d26:	8000                	.insn	2, 0x8000
80001d28:	1160                	.insn	2, 0x1160
80001d2a:	8000                	.insn	2, 0x8000
80001d2c:	1160                	.insn	2, 0x1160
80001d2e:	8000                	.insn	2, 0x8000
80001d30:	1160                	.insn	2, 0x1160
80001d32:	8000                	.insn	2, 0x8000
80001d34:	1200                	.insn	2, 0x1200
80001d36:	8000                	.insn	2, 0x8000
80001d38:	1160                	.insn	2, 0x1160
80001d3a:	8000                	.insn	2, 0x8000
80001d3c:	11f4                	.insn	2, 0x11f4
80001d3e:	8000                	.insn	2, 0x8000
80001d40:	1160                	.insn	2, 0x1160
80001d42:	8000                	.insn	2, 0x8000
80001d44:	1160                	.insn	2, 0x1160
80001d46:	8000                	.insn	2, 0x8000
80001d48:	11e8                	.insn	2, 0x11e8
80001d4a:	8000                	.insn	2, 0x8000
80001d4c:	14b0                	.insn	2, 0x14b0
80001d4e:	8000                	.insn	2, 0x8000
80001d50:	1110                	.insn	2, 0x1110
80001d52:	8000                	.insn	2, 0x8000
80001d54:	1110                	.insn	2, 0x1110
80001d56:	8000                	.insn	2, 0x8000
80001d58:	1110                	.insn	2, 0x1110
80001d5a:	8000                	.insn	2, 0x8000
80001d5c:	1110                	.insn	2, 0x1110
80001d5e:	8000                	.insn	2, 0x8000
80001d60:	1110                	.insn	2, 0x1110
80001d62:	8000                	.insn	2, 0x8000
80001d64:	1110                	.insn	2, 0x1110
80001d66:	8000                	.insn	2, 0x8000
80001d68:	1110                	.insn	2, 0x1110
80001d6a:	8000                	.insn	2, 0x8000
80001d6c:	1110                	.insn	2, 0x1110
80001d6e:	8000                	.insn	2, 0x8000
80001d70:	1110                	.insn	2, 0x1110
80001d72:	8000                	.insn	2, 0x8000
80001d74:	1110                	.insn	2, 0x1110
80001d76:	8000                	.insn	2, 0x8000
80001d78:	1110                	.insn	2, 0x1110
80001d7a:	8000                	.insn	2, 0x8000
80001d7c:	1110                	.insn	2, 0x1110
80001d7e:	8000                	.insn	2, 0x8000
80001d80:	1110                	.insn	2, 0x1110
80001d82:	8000                	.insn	2, 0x8000
80001d84:	1110                	.insn	2, 0x1110
80001d86:	8000                	.insn	2, 0x8000
80001d88:	1110                	.insn	2, 0x1110
80001d8a:	8000                	.insn	2, 0x8000
80001d8c:	1110                	.insn	2, 0x1110
80001d8e:	8000                	.insn	2, 0x8000
80001d90:	1110                	.insn	2, 0x1110
80001d92:	8000                	.insn	2, 0x8000
80001d94:	1110                	.insn	2, 0x1110
80001d96:	8000                	.insn	2, 0x8000
80001d98:	1110                	.insn	2, 0x1110
80001d9a:	8000                	.insn	2, 0x8000
80001d9c:	1110                	.insn	2, 0x1110
80001d9e:	8000                	.insn	2, 0x8000
80001da0:	1110                	.insn	2, 0x1110
80001da2:	8000                	.insn	2, 0x8000
80001da4:	1110                	.insn	2, 0x1110
80001da6:	8000                	.insn	2, 0x8000
80001da8:	1110                	.insn	2, 0x1110
80001daa:	8000                	.insn	2, 0x8000
80001dac:	1110                	.insn	2, 0x1110
80001dae:	8000                	.insn	2, 0x8000
80001db0:	1110                	.insn	2, 0x1110
80001db2:	8000                	.insn	2, 0x8000
80001db4:	1110                	.insn	2, 0x1110
80001db6:	8000                	.insn	2, 0x8000
80001db8:	1110                	.insn	2, 0x1110
80001dba:	8000                	.insn	2, 0x8000
80001dbc:	1110                	.insn	2, 0x1110
80001dbe:	8000                	.insn	2, 0x8000
80001dc0:	1110                	.insn	2, 0x1110
80001dc2:	8000                	.insn	2, 0x8000
80001dc4:	1110                	.insn	2, 0x1110
80001dc6:	8000                	.insn	2, 0x8000
80001dc8:	1110                	.insn	2, 0x1110
80001dca:	8000                	.insn	2, 0x8000
80001dcc:	1420                	.insn	2, 0x1420
80001dce:	8000                	.insn	2, 0x8000
80001dd0:	1470                	.insn	2, 0x1470
80001dd2:	8000                	.insn	2, 0x8000
80001dd4:	1420                	.insn	2, 0x1420
80001dd6:	8000                	.insn	2, 0x8000
80001dd8:	1110                	.insn	2, 0x1110
80001dda:	8000                	.insn	2, 0x8000
80001ddc:	1110                	.insn	2, 0x1110
80001dde:	8000                	.insn	2, 0x8000
80001de0:	1110                	.insn	2, 0x1110
80001de2:	8000                	.insn	2, 0x8000
80001de4:	1110                	.insn	2, 0x1110
80001de6:	8000                	.insn	2, 0x8000
80001de8:	1110                	.insn	2, 0x1110
80001dea:	8000                	.insn	2, 0x8000
80001dec:	1110                	.insn	2, 0x1110
80001dee:	8000                	.insn	2, 0x8000
80001df0:	1110                	.insn	2, 0x1110
80001df2:	8000                	.insn	2, 0x8000
80001df4:	1110                	.insn	2, 0x1110
80001df6:	8000                	.insn	2, 0x8000
80001df8:	1110                	.insn	2, 0x1110
80001dfa:	8000                	.insn	2, 0x8000
80001dfc:	1110                	.insn	2, 0x1110
80001dfe:	8000                	.insn	2, 0x8000
80001e00:	1110                	.insn	2, 0x1110
80001e02:	8000                	.insn	2, 0x8000
80001e04:	1110                	.insn	2, 0x1110
80001e06:	8000                	.insn	2, 0x8000
80001e08:	1110                	.insn	2, 0x1110
80001e0a:	8000                	.insn	2, 0x8000
80001e0c:	1110                	.insn	2, 0x1110
80001e0e:	8000                	.insn	2, 0x8000
80001e10:	1110                	.insn	2, 0x1110
80001e12:	8000                	.insn	2, 0x8000
80001e14:	1110                	.insn	2, 0x1110
80001e16:	8000                	.insn	2, 0x8000
80001e18:	17e0                	.insn	2, 0x17e0
80001e1a:	8000                	.insn	2, 0x8000
80001e1c:	1110                	.insn	2, 0x1110
80001e1e:	8000                	.insn	2, 0x8000
80001e20:	1110                	.insn	2, 0x1110
80001e22:	8000                	.insn	2, 0x8000
80001e24:	1110                	.insn	2, 0x1110
80001e26:	8000                	.insn	2, 0x8000
80001e28:	1110                	.insn	2, 0x1110
80001e2a:	8000                	.insn	2, 0x8000
80001e2c:	1110                	.insn	2, 0x1110
80001e2e:	8000                	.insn	2, 0x8000
80001e30:	1110                	.insn	2, 0x1110
80001e32:	8000                	.insn	2, 0x8000
80001e34:	1110                	.insn	2, 0x1110
80001e36:	8000                	.insn	2, 0x8000
80001e38:	1110                	.insn	2, 0x1110
80001e3a:	8000                	.insn	2, 0x8000
80001e3c:	1110                	.insn	2, 0x1110
80001e3e:	8000                	.insn	2, 0x8000
80001e40:	17e0                	.insn	2, 0x17e0
80001e42:	8000                	.insn	2, 0x8000
80001e44:	14cc                	.insn	2, 0x14cc
80001e46:	8000                	.insn	2, 0x8000
80001e48:	17e0                	.insn	2, 0x17e0
80001e4a:	8000                	.insn	2, 0x8000
80001e4c:	1420                	.insn	2, 0x1420
80001e4e:	8000                	.insn	2, 0x8000
80001e50:	1470                	.insn	2, 0x1470
80001e52:	8000                	.insn	2, 0x8000
80001e54:	1420                	.insn	2, 0x1420
80001e56:	8000                	.insn	2, 0x8000

80001e58 <pow10.0>:
    static const double pow10[] = {1,         10,        100,     1000,
80001e58:	0000                	.insn	2, 0x
80001e5a:	0000                	.insn	2, 0x
80001e5c:	0000                	.insn	2, 0x
80001e5e:	3ff0                	.insn	2, 0x3ff0
80001e60:	0000                	.insn	2, 0x
80001e62:	0000                	.insn	2, 0x
80001e64:	0000                	.insn	2, 0x
80001e66:	4024                	.insn	2, 0x4024
80001e68:	0000                	.insn	2, 0x
80001e6a:	0000                	.insn	2, 0x
80001e6c:	0000                	.insn	2, 0x
80001e6e:	4059                	.insn	2, 0x4059
80001e70:	0000                	.insn	2, 0x
80001e72:	0000                	.insn	2, 0x
80001e74:	4000                	.insn	2, 0x4000
80001e76:	0000408f          	.insn	4, 0x408f
80001e7a:	0000                	.insn	2, 0x
80001e7c:	8800                	.insn	2, 0x8800
80001e7e:	000040c3          	fmadd.s	ft1,ft0,ft0,ft0,rmm
80001e82:	0000                	.insn	2, 0x
80001e84:	6a00                	.insn	2, 0x6a00
80001e86:	40f8                	.insn	2, 0x40f8
80001e88:	0000                	.insn	2, 0x
80001e8a:	0000                	.insn	2, 0x
80001e8c:	8480                	.insn	2, 0x8480
80001e8e:	412e                	.insn	2, 0x412e
80001e90:	0000                	.insn	2, 0x
80001e92:	0000                	.insn	2, 0x
80001e94:	12d0                	.insn	2, 0x12d0
80001e96:	00004163          	blt	zero,zero,80001e98 <pow10.0+0x40>
80001e9a:	0000                	.insn	2, 0x
80001e9c:	d784                	.insn	2, 0xd784
80001e9e:	00004197          	auipc	gp,0x4
80001ea2:	0000                	.insn	2, 0x
80001ea4:	cd65                	.insn	2, 0xcd65
80001ea6:	41cd                	.insn	2, 0x41cd

Disassembly of section .eh_frame_hdr:

80001ea8 <__GNU_EH_FRAME_HDR>:
80001ea8:	1b01                	.insn	2, 0x1b01
80001eaa:	00b03b03          	.insn	4, 0x00b03b03
80001eae:	0000                	.insn	2, 0x
80001eb0:	0015                	.insn	2, 0x0015
80001eb2:	0000                	.insn	2, 0x
80001eb4:	e158                	.insn	2, 0xe158
80001eb6:	ffff                	.insn	2, 0xffff
80001eb8:	00c8                	.insn	2, 0x00c8
80001eba:	0000                	.insn	2, 0x
80001ebc:	e188                	.insn	2, 0xe188
80001ebe:	ffff                	.insn	2, 0xffff
80001ec0:	00e4                	.insn	2, 0x00e4
80001ec2:	0000                	.insn	2, 0x
80001ec4:	e198                	.insn	2, 0xe198
80001ec6:	ffff                	.insn	2, 0xffff
80001ec8:	00f8                	.insn	2, 0x00f8
80001eca:	0000                	.insn	2, 0x
80001ecc:	e19c                	.insn	2, 0xe19c
80001ece:	ffff                	.insn	2, 0xffff
80001ed0:	010c                	.insn	2, 0x010c
80001ed2:	0000                	.insn	2, 0x
80001ed4:	e1ac                	.insn	2, 0xe1ac
80001ed6:	ffff                	.insn	2, 0xffff
80001ed8:	0120                	.insn	2, 0x0120
80001eda:	0000                	.insn	2, 0x
80001edc:	e2e0                	.insn	2, 0xe2e0
80001ede:	ffff                	.insn	2, 0xffff
80001ee0:	016c                	.insn	2, 0x016c
80001ee2:	0000                	.insn	2, 0x
80001ee4:	e830                	.insn	2, 0xe830
80001ee6:	ffff                	.insn	2, 0xffff
80001ee8:	01ec                	.insn	2, 0x01ec
80001eea:	0000                	.insn	2, 0x
80001eec:	e844                	.insn	2, 0xe844
80001eee:	ffff                	.insn	2, 0xffff
80001ef0:	0200                	.insn	2, 0x0200
80001ef2:	0000                	.insn	2, 0x
80001ef4:	edcc                	.insn	2, 0xedcc
80001ef6:	ffff                	.insn	2, 0xffff
80001ef8:	0284                	.insn	2, 0x0284
80001efa:	0000                	.insn	2, 0x
80001efc:	f1f8                	.insn	2, 0xf1f8
80001efe:	ffff                	.insn	2, 0xffff
80001f00:	02fc                	.insn	2, 0x02fc
80001f02:	0000                	.insn	2, 0x
80001f04:	fb60                	.insn	2, 0xfb60
80001f06:	ffff                	.insn	2, 0xffff
80001f08:	037c                	.insn	2, 0x037c
80001f0a:	0000                	.insn	2, 0x
80001f0c:	fb68                	.insn	2, 0xfb68
80001f0e:	ffff                	.insn	2, 0xffff
80001f10:	0390                	.insn	2, 0x0390
80001f12:	0000                	.insn	2, 0x
80001f14:	fb88                	.insn	2, 0xfb88
80001f16:	ffff                	.insn	2, 0xffff
80001f18:	03a4                	.insn	2, 0x03a4
80001f1a:	0000                	.insn	2, 0x
80001f1c:	fc28                	.insn	2, 0xfc28
80001f1e:	ffff                	.insn	2, 0xffff
80001f20:	03b8                	.insn	2, 0x03b8
80001f22:	0000                	.insn	2, 0x
80001f24:	fc5c                	.insn	2, 0xfc5c
80001f26:	ffff                	.insn	2, 0xffff
80001f28:	03cc                	.insn	2, 0x03cc
80001f2a:	0000                	.insn	2, 0x
80001f2c:	fc68                	.insn	2, 0xfc68
80001f2e:	ffff                	.insn	2, 0xffff
80001f30:	03e0                	.insn	2, 0x03e0
80001f32:	0000                	.insn	2, 0x
80001f34:	fcbc                	.insn	2, 0xfcbc
80001f36:	ffff                	.insn	2, 0xffff
80001f38:	03fc                	.insn	2, 0x03fc
80001f3a:	0000                	.insn	2, 0x
80001f3c:	fd10                	.insn	2, 0xfd10
80001f3e:	ffff                	.insn	2, 0xffff
80001f40:	0418                	.insn	2, 0x0418
80001f42:	0000                	.insn	2, 0x
80001f44:	fd64                	.insn	2, 0xfd64
80001f46:	ffff                	.insn	2, 0xffff
80001f48:	0434                	.insn	2, 0x0434
80001f4a:	0000                	.insn	2, 0x
80001f4c:	fd94                	.insn	2, 0xfd94
80001f4e:	ffff                	.insn	2, 0xffff
80001f50:	0450                	.insn	2, 0x0450
80001f52:	0000                	.insn	2, 0x
80001f54:	fdb8                	.insn	2, 0xfdb8
80001f56:	ffff                	.insn	2, 0xffff
80001f58:	0464                	.insn	2, 0x0464
	...

Disassembly of section .eh_frame:

80001f5c <.eh_frame>:
80001f5c:	0010                	.insn	2, 0x0010
80001f5e:	0000                	.insn	2, 0x
80001f60:	0000                	.insn	2, 0x
80001f62:	0000                	.insn	2, 0x
80001f64:	00527a03          	.insn	4, 0x00527a03
80001f68:	7c01                	.insn	2, 0x7c01
80001f6a:	0101                	.insn	2, 0x0101
80001f6c:	00020c1b          	.insn	4, 0x00020c1b
80001f70:	0018                	.insn	2, 0x0018
80001f72:	0000                	.insn	2, 0x
80001f74:	0018                	.insn	2, 0x0018
80001f76:	0000                	.insn	2, 0x
80001f78:	e088                	.insn	2, 0xe088
80001f7a:	ffff                	.insn	2, 0xffff
80001f7c:	0030                	.insn	2, 0x0030
80001f7e:	0000                	.insn	2, 0x
80001f80:	5400                	.insn	2, 0x5400
80001f82:	100e                	.insn	2, 0x100e
80001f84:	8148                	.insn	2, 0x8148
80001f86:	4801                	.insn	2, 0x4801
80001f88:	48c1                	.insn	2, 0x48c1
80001f8a:	000e                	.insn	2, 0x000e
80001f8c:	0010                	.insn	2, 0x0010
80001f8e:	0000                	.insn	2, 0x
80001f90:	0034                	.insn	2, 0x0034
80001f92:	0000                	.insn	2, 0x
80001f94:	e09c                	.insn	2, 0xe09c
80001f96:	ffff                	.insn	2, 0xffff
80001f98:	0010                	.insn	2, 0x0010
80001f9a:	0000                	.insn	2, 0x
80001f9c:	0000                	.insn	2, 0x
80001f9e:	0000                	.insn	2, 0x
80001fa0:	0010                	.insn	2, 0x0010
80001fa2:	0000                	.insn	2, 0x
80001fa4:	0048                	.insn	2, 0x0048
80001fa6:	0000                	.insn	2, 0x
80001fa8:	e098                	.insn	2, 0xe098
80001faa:	ffff                	.insn	2, 0xffff
80001fac:	0004                	.insn	2, 0x0004
80001fae:	0000                	.insn	2, 0x
80001fb0:	0000                	.insn	2, 0x
80001fb2:	0000                	.insn	2, 0x
80001fb4:	0010                	.insn	2, 0x0010
80001fb6:	0000                	.insn	2, 0x
80001fb8:	005c                	.insn	2, 0x005c
80001fba:	0000                	.insn	2, 0x
80001fbc:	e088                	.insn	2, 0xe088
80001fbe:	ffff                	.insn	2, 0xffff
80001fc0:	0010                	.insn	2, 0x0010
80001fc2:	0000                	.insn	2, 0x
80001fc4:	0000                	.insn	2, 0x
80001fc6:	0000                	.insn	2, 0x
80001fc8:	0048                	.insn	2, 0x0048
80001fca:	0000                	.insn	2, 0x
80001fcc:	0070                	.insn	2, 0x0070
80001fce:	0000                	.insn	2, 0x
80001fd0:	e084                	.insn	2, 0xe084
80001fd2:	ffff                	.insn	2, 0xffff
80001fd4:	0134                	.insn	2, 0x0134
80001fd6:	0000                	.insn	2, 0x
80001fd8:	4400                	.insn	2, 0x4400
80001fda:	300e                	.insn	2, 0x300e
80001fdc:	8864                	.insn	2, 0x8864
80001fde:	9302                	.insn	2, 0x9302
80001fe0:	9405                	.insn	2, 0x9405
80001fe2:	9506                	.insn	2, 0x9506
80001fe4:	97089607          	.insn	4, 0x97089607
80001fe8:	9809                	.insn	2, 0x9809
80001fea:	990a                	.insn	2, 0x990a
80001fec:	4c01810b          	.insn	4, 0x4c01810b
80001ff0:	0389                	.insn	2, 0x0389
80001ff2:	0492                	.insn	2, 0x0492
80001ff4:	b002                	.insn	2, 0xb002
80001ff6:	c10a                	.insn	2, 0xc10a
80001ff8:	c844                	.insn	2, 0xc844
80001ffa:	d244                	.insn	2, 0xd244
80001ffc:	d344                	.insn	2, 0xd344
80001ffe:	d444                	.insn	2, 0xd444
80002000:	d544                	.insn	2, 0xd544
80002002:	d644                	.insn	2, 0xd644
80002004:	d744                	.insn	2, 0xd744
80002006:	d844                	.insn	2, 0xd844
80002008:	d944                	.insn	2, 0xd944
8000200a:	c948                	.insn	2, 0xc948
8000200c:	0e44                	.insn	2, 0x0e44
8000200e:	4400                	.insn	2, 0x4400
80002010:	0000000b          	.insn	4, 0x000b
80002014:	007c                	.insn	2, 0x007c
80002016:	0000                	.insn	2, 0x
80002018:	00bc                	.insn	2, 0x00bc
8000201a:	0000                	.insn	2, 0x
8000201c:	e16c                	.insn	2, 0xe16c
8000201e:	ffff                	.insn	2, 0xffff
80002020:	0550                	.insn	2, 0x0550
80002022:	0000                	.insn	2, 0x
80002024:	4400                	.insn	2, 0x4400
80002026:	400e                	.insn	2, 0x400e
80002028:	8944                	.insn	2, 0x8944
8000202a:	04926403          	.insn	4, 0x04926403
8000202e:	06940593          	addi	a1,s0,105
80002032:	0181                	.insn	2, 0x0181
80002034:	0795                	.insn	2, 0x0795
80002036:	8864                	.insn	2, 0x8864
80002038:	0202                	.insn	2, 0x0202
8000203a:	c870                	.insn	2, 0xc870
8000203c:	7002                	.insn	2, 0x7002
8000203e:	0288                	.insn	2, 0x0288
80002040:	c858                	.insn	2, 0xc858
80002042:	8878                	.insn	2, 0x8878
80002044:	5402                	.insn	2, 0x5402
80002046:	02c8                	.insn	2, 0x02c8
80002048:	8854                	.insn	2, 0x8854
8000204a:	5002                	.insn	2, 0x5002
8000204c:	7cc8                	.insn	2, 0x7cc8
8000204e:	0288                	.insn	2, 0x0288
80002050:	0a58                	.insn	2, 0x0a58
80002052:	44c8                	.insn	2, 0x44c8
80002054:	54c8440b          	.insn	4, 0x54c8440b
80002058:	c10a                	.insn	2, 0xc10a
8000205a:	c944                	.insn	2, 0xc944
8000205c:	d244                	.insn	2, 0xd244
8000205e:	d344                	.insn	2, 0xd344
80002060:	d444                	.insn	2, 0xd444
80002062:	d544                	.insn	2, 0xd544
80002064:	0e44                	.insn	2, 0x0e44
80002066:	4400                	.insn	2, 0x4400
80002068:	0288780b          	.insn	4, 0x0288780b
8000206c:	c844                	.insn	2, 0xc844
8000206e:	4002                	.insn	2, 0x4002
80002070:	0288                	.insn	2, 0x0288
80002072:	c848                	.insn	2, 0xc848
80002074:	8c02                	.insn	2, 0x8c02
80002076:	0288                	.insn	2, 0x0288
80002078:	0a44                	.insn	2, 0x0a44
8000207a:	48c8                	.insn	2, 0x48c8
8000207c:	02c8480b          	.insn	4, 0x02c8480b
80002080:	8888                	.insn	2, 0x8888
80002082:	4802                	.insn	2, 0x4802
80002084:	02c8                	.insn	2, 0x02c8
80002086:	8844                	.insn	2, 0x8844
80002088:	4402                	.insn	2, 0x4402
8000208a:	02c8                	.insn	2, 0x02c8
8000208c:	88b0                	.insn	2, 0x88b0
8000208e:	4402                	.insn	2, 0x4402
80002090:	00c8                	.insn	2, 0x00c8
80002092:	0000                	.insn	2, 0x
80002094:	0010                	.insn	2, 0x0010
80002096:	0000                	.insn	2, 0x
80002098:	013c                	.insn	2, 0x013c
8000209a:	0000                	.insn	2, 0x
8000209c:	e63c                	.insn	2, 0xe63c
8000209e:	ffff                	.insn	2, 0xffff
800020a0:	0014                	.insn	2, 0x0014
800020a2:	0000                	.insn	2, 0x
800020a4:	0000                	.insn	2, 0x
800020a6:	0000                	.insn	2, 0x
800020a8:	0080                	.insn	2, 0x0080
800020aa:	0000                	.insn	2, 0x
800020ac:	0150                	.insn	2, 0x0150
800020ae:	0000                	.insn	2, 0x
800020b0:	e63c                	.insn	2, 0xe63c
800020b2:	ffff                	.insn	2, 0xffff
800020b4:	0588                	.insn	2, 0x0588
800020b6:	0000                	.insn	2, 0x
800020b8:	4400                	.insn	2, 0x4400
800020ba:	600e                	.insn	2, 0x600e
800020bc:	8870                	.insn	2, 0x8870
800020be:	8902                	.insn	2, 0x8902
800020c0:	93049203          	lh	tp,-1744(s1)
800020c4:	9405                	.insn	2, 0x9405
800020c6:	9506                	.insn	2, 0x9506
800020c8:	96018107          	.insn	4, 0x96018107
800020cc:	0308                	.insn	2, 0x0308
800020ce:	0158                	.insn	2, 0x0158
800020d0:	c80a                	.insn	2, 0xc80a
800020d2:	c144                	.insn	2, 0xc144
800020d4:	d644                	.insn	2, 0xd644
800020d6:	d54c                	.insn	2, 0xd54c
800020d8:	d344                	.insn	2, 0xd344
800020da:	d24c                	.insn	2, 0xd24c
800020dc:	d444                	.insn	2, 0xd444
800020de:	c948                	.insn	2, 0xc948
800020e0:	0e44                	.insn	2, 0x0e44
800020e2:	4400                	.insn	2, 0x4400
800020e4:	0997540b          	.insn	4, 0x0997540b
800020e8:	0a98                	.insn	2, 0x0a98
800020ea:	0b99                	.insn	2, 0x0b99
800020ec:	9c02                	.insn	2, 0x9c02
800020ee:	44d844d7          	.insn	4, 0x44d844d7
800020f2:	44d9                	.insn	2, 0x44d9
800020f4:	c10a                	.insn	2, 0xc10a
800020f6:	c844                	.insn	2, 0xc844
800020f8:	c944                	.insn	2, 0xc944
800020fa:	d244                	.insn	2, 0xd244
800020fc:	d344                	.insn	2, 0xd344
800020fe:	d444                	.insn	2, 0xd444
80002100:	d544                	.insn	2, 0xd544
80002102:	d648                	.insn	2, 0xd648
80002104:	0e44                	.insn	2, 0x0e44
80002106:	4400                	.insn	2, 0x4400
80002108:	c80a680b          	.insn	4, 0xc80a680b
8000210c:	c150                	.insn	2, 0xc150
8000210e:	d544                	.insn	2, 0xd544
80002110:	d644                	.insn	2, 0xd644
80002112:	d34c                	.insn	2, 0xd34c
80002114:	d244                	.insn	2, 0xd244
80002116:	d44c                	.insn	2, 0xd44c
80002118:	c944                	.insn	2, 0xc944
8000211a:	0e44                	.insn	2, 0x0e44
8000211c:	4400                	.insn	2, 0x4400
8000211e:	09974c0b          	.insn	4, 0x09974c0b
80002122:	0a98                	.insn	2, 0x0a98
80002124:	0b99                	.insn	2, 0x0b99
80002126:	a402                	.insn	2, 0xa402
80002128:	00d9d8d7          	.insn	4, 0x00d9d8d7
8000212c:	0074                	.insn	2, 0x0074
8000212e:	0000                	.insn	2, 0x
80002130:	01d4                	.insn	2, 0x01d4
80002132:	0000                	.insn	2, 0x
80002134:	eb40                	.insn	2, 0xeb40
80002136:	ffff                	.insn	2, 0xffff
80002138:	042c                	.insn	2, 0x042c
8000213a:	0000                	.insn	2, 0x
8000213c:	4400                	.insn	2, 0x4400
8000213e:	500e                	.insn	2, 0x500e
80002140:	886c                	.insn	2, 0x886c
80002142:	8902                	.insn	2, 0x8902
80002144:	94049203          	lh	tp,-1728(s1)
80002148:	9506                	.insn	2, 0x9506
8000214a:	81089607          	.insn	4, 0x81089607
8000214e:	0201                	.insn	2, 0x0201
80002150:	9348                	.insn	2, 0x9348
80002152:	9705                	.insn	2, 0x9705
80002154:	9809                	.insn	2, 0x9809
80002156:	030a                	.insn	2, 0x030a
80002158:	0190                	.insn	2, 0x0190
8000215a:	44d744d3          	.insn	4, 0x44d744d3
8000215e:	02d8                	.insn	2, 0x02d8
80002160:	c844                	.insn	2, 0xc844
80002162:	c144                	.insn	2, 0xc144
80002164:	c944                	.insn	2, 0xc944
80002166:	d244                	.insn	2, 0xd244
80002168:	d444                	.insn	2, 0xd444
8000216a:	d544                	.insn	2, 0xd544
8000216c:	d644                	.insn	2, 0xd644
8000216e:	0e44                	.insn	2, 0x0e44
80002170:	4400                	.insn	2, 0x4400
80002172:	500e                	.insn	2, 0x500e
80002174:	0181                	.insn	2, 0x0181
80002176:	0288                	.insn	2, 0x0288
80002178:	0389                	.insn	2, 0x0389
8000217a:	0492                	.insn	2, 0x0492
8000217c:	06940593          	addi	a1,s0,105
80002180:	0795                	.insn	2, 0x0795
80002182:	0896                	.insn	2, 0x0896
80002184:	0a980997          	auipc	s3,0xa980
80002188:	ec02                	.insn	2, 0xec02
8000218a:	c10a                	.insn	2, 0xc10a
8000218c:	c844                	.insn	2, 0xc844
8000218e:	d344                	.insn	2, 0xd344
80002190:	d744                	.insn	2, 0xd744
80002192:	d844                	.insn	2, 0xd844
80002194:	c944                	.insn	2, 0xc944
80002196:	d444                	.insn	2, 0xd444
80002198:	d544                	.insn	2, 0xd544
8000219a:	d644                	.insn	2, 0xd644
8000219c:	d248                	.insn	2, 0xd248
8000219e:	0e44                	.insn	2, 0x0e44
800021a0:	4400                	.insn	2, 0x4400
800021a2:	007c000b          	.insn	4, 0x007c000b
800021a6:	0000                	.insn	2, 0x
800021a8:	024c                	.insn	2, 0x024c
800021aa:	0000                	.insn	2, 0x
800021ac:	eef4                	.insn	2, 0xeef4
800021ae:	ffff                	.insn	2, 0xffff
800021b0:	0968                	.insn	2, 0x0968
800021b2:	0000                	.insn	2, 0x
800021b4:	4400                	.insn	2, 0x4400
800021b6:	700e                	.insn	2, 0x700e
800021b8:	8960                	.insn	2, 0x8960
800021ba:	93049203          	lh	tp,-1744(s1)
800021be:	9905                	.insn	2, 0x9905
800021c0:	810c9a0b          	.insn	4, 0x810c9a0b
800021c4:	8801                	.insn	2, 0x8801
800021c6:	9b02                	.insn	2, 0x9b02
800021c8:	780d                	.insn	2, 0x780d
800021ca:	0694                	.insn	2, 0x0694
800021cc:	0795                	.insn	2, 0x0795
800021ce:	0896                	.insn	2, 0x0896
800021d0:	0a980997          	auipc	s3,0xa980
800021d4:	d401e003          	.insn	4, 0xd401e003
800021d8:	d544                	.insn	2, 0xd544
800021da:	d644                	.insn	2, 0xd644
800021dc:	d744                	.insn	2, 0xd744
800021de:	d844                	.insn	2, 0xd844
800021e0:	c164                	.insn	2, 0xc164
800021e2:	c848                	.insn	2, 0xc848
800021e4:	c944                	.insn	2, 0xc944
800021e6:	d244                	.insn	2, 0xd244
800021e8:	d344                	.insn	2, 0xd344
800021ea:	d944                	.insn	2, 0xd944
800021ec:	da44                	.insn	2, 0xda44
800021ee:	db44                	.insn	2, 0xdb44
800021f0:	0e44                	.insn	2, 0x0e44
800021f2:	4400                	.insn	2, 0x4400
800021f4:	700e                	.insn	2, 0x700e
800021f6:	0181                	.insn	2, 0x0181
800021f8:	0288                	.insn	2, 0x0288
800021fa:	0389                	.insn	2, 0x0389
800021fc:	0492                	.insn	2, 0x0492
800021fe:	06940593          	addi	a1,s0,105
80002202:	0795                	.insn	2, 0x0795
80002204:	0896                	.insn	2, 0x0896
80002206:	0a980997          	auipc	s3,0xa980
8000220a:	0b99                	.insn	2, 0x0b99
8000220c:	0c9a                	.insn	2, 0x0c9a
8000220e:	08030d9b          	.insn	4, 0x08030d9b
80002212:	d402                	.insn	2, 0xd402
80002214:	d6d5                	.insn	2, 0xd6d5
80002216:	9460d8d7          	.insn	4, 0x9460d8d7
8000221a:	9506                	.insn	2, 0x9506
8000221c:	97089607          	.insn	4, 0x97089607
80002220:	9809                	.insn	2, 0x9809
80002222:	000a                	.insn	2, 0x000a
80002224:	0010                	.insn	2, 0x0010
80002226:	0000                	.insn	2, 0x
80002228:	02cc                	.insn	2, 0x02cc
8000222a:	0000                	.insn	2, 0x
8000222c:	f7dc                	.insn	2, 0xf7dc
8000222e:	ffff                	.insn	2, 0xffff
80002230:	0008                	.insn	2, 0x0008
80002232:	0000                	.insn	2, 0x
80002234:	0000                	.insn	2, 0x
80002236:	0000                	.insn	2, 0x
80002238:	0010                	.insn	2, 0x0010
8000223a:	0000                	.insn	2, 0x
8000223c:	02e0                	.insn	2, 0x02e0
8000223e:	0000                	.insn	2, 0x
80002240:	f7d0                	.insn	2, 0xf7d0
80002242:	ffff                	.insn	2, 0xffff
80002244:	0020                	.insn	2, 0x0020
80002246:	0000                	.insn	2, 0x
80002248:	0000                	.insn	2, 0x
8000224a:	0000                	.insn	2, 0x
8000224c:	0010                	.insn	2, 0x0010
8000224e:	0000                	.insn	2, 0x
80002250:	02f4                	.insn	2, 0x02f4
80002252:	0000                	.insn	2, 0x
80002254:	f7dc                	.insn	2, 0xf7dc
80002256:	ffff                	.insn	2, 0xffff
80002258:	00a0                	.insn	2, 0x00a0
8000225a:	0000                	.insn	2, 0x
8000225c:	0000                	.insn	2, 0x
8000225e:	0000                	.insn	2, 0x
80002260:	0010                	.insn	2, 0x0010
80002262:	0000                	.insn	2, 0x
80002264:	0308                	.insn	2, 0x0308
80002266:	0000                	.insn	2, 0x
80002268:	f868                	.insn	2, 0xf868
8000226a:	ffff                	.insn	2, 0xffff
8000226c:	0034                	.insn	2, 0x0034
8000226e:	0000                	.insn	2, 0x
80002270:	0000                	.insn	2, 0x
80002272:	0000                	.insn	2, 0x
80002274:	0010                	.insn	2, 0x0010
80002276:	0000                	.insn	2, 0x
80002278:	031c                	.insn	2, 0x031c
8000227a:	0000                	.insn	2, 0x
8000227c:	f888                	.insn	2, 0xf888
8000227e:	ffff                	.insn	2, 0xffff
80002280:	000c                	.insn	2, 0x000c
80002282:	0000                	.insn	2, 0x
80002284:	0000                	.insn	2, 0x
80002286:	0000                	.insn	2, 0x
80002288:	0018                	.insn	2, 0x0018
8000228a:	0000                	.insn	2, 0x
8000228c:	0330                	.insn	2, 0x0330
8000228e:	0000                	.insn	2, 0x
80002290:	f880                	.insn	2, 0xf880
80002292:	ffff                	.insn	2, 0xffff
80002294:	0054                	.insn	2, 0x0054
80002296:	0000                	.insn	2, 0x
80002298:	4400                	.insn	2, 0x4400
8000229a:	400e                	.insn	2, 0x400e
8000229c:	8170                	.insn	2, 0x8170
8000229e:	5809                	.insn	2, 0x5809
800022a0:	44c1                	.insn	2, 0x44c1
800022a2:	000e                	.insn	2, 0x000e
800022a4:	0018                	.insn	2, 0x0018
800022a6:	0000                	.insn	2, 0x
800022a8:	034c                	.insn	2, 0x034c
800022aa:	0000                	.insn	2, 0x
800022ac:	f8b8                	.insn	2, 0xf8b8
800022ae:	ffff                	.insn	2, 0xffff
800022b0:	0054                	.insn	2, 0x0054
800022b2:	0000                	.insn	2, 0x
800022b4:	4400                	.insn	2, 0x4400
800022b6:	400e                	.insn	2, 0x400e
800022b8:	8170                	.insn	2, 0x8170
800022ba:	5809                	.insn	2, 0x5809
800022bc:	44c1                	.insn	2, 0x44c1
800022be:	000e                	.insn	2, 0x000e
800022c0:	0018                	.insn	2, 0x0018
800022c2:	0000                	.insn	2, 0x
800022c4:	0368                	.insn	2, 0x0368
800022c6:	0000                	.insn	2, 0x
800022c8:	f8f0                	.insn	2, 0xf8f0
800022ca:	ffff                	.insn	2, 0xffff
800022cc:	0054                	.insn	2, 0x0054
800022ce:	0000                	.insn	2, 0x
800022d0:	4400                	.insn	2, 0x4400
800022d2:	400e                	.insn	2, 0x400e
800022d4:	8170                	.insn	2, 0x8170
800022d6:	5809                	.insn	2, 0x5809
800022d8:	44c1                	.insn	2, 0x44c1
800022da:	000e                	.insn	2, 0x000e
800022dc:	0018                	.insn	2, 0x0018
800022de:	0000                	.insn	2, 0x
800022e0:	0384                	.insn	2, 0x0384
800022e2:	0000                	.insn	2, 0x
800022e4:	f928                	.insn	2, 0xf928
800022e6:	ffff                	.insn	2, 0xffff
800022e8:	0030                	.insn	2, 0x0030
800022ea:	0000                	.insn	2, 0x
800022ec:	4400                	.insn	2, 0x4400
800022ee:	200e                	.insn	2, 0x200e
800022f0:	815c                	.insn	2, 0x815c
800022f2:	4801                	.insn	2, 0x4801
800022f4:	44c1                	.insn	2, 0x44c1
800022f6:	000e                	.insn	2, 0x000e
800022f8:	0010                	.insn	2, 0x0010
800022fa:	0000                	.insn	2, 0x
800022fc:	03a0                	.insn	2, 0x03a0
800022fe:	0000                	.insn	2, 0x
80002300:	f93c                	.insn	2, 0xf93c
80002302:	ffff                	.insn	2, 0xffff
80002304:	0024                	.insn	2, 0x0024
80002306:	0000                	.insn	2, 0x
80002308:	0000                	.insn	2, 0x
8000230a:	0000                	.insn	2, 0x
8000230c:	0018                	.insn	2, 0x0018
8000230e:	0000                	.insn	2, 0x
80002310:	03b4                	.insn	2, 0x03b4
80002312:	0000                	.insn	2, 0x
80002314:	f94c                	.insn	2, 0xf94c
80002316:	ffff                	.insn	2, 0xffff
80002318:	005c                	.insn	2, 0x005c
8000231a:	0000                	.insn	2, 0x
8000231c:	4400                	.insn	2, 0x4400
8000231e:	400e                	.insn	2, 0x400e
80002320:	8170                	.insn	2, 0x8170
80002322:	6009                	.insn	2, 0x6009
80002324:	44c1                	.insn	2, 0x44c1
80002326:	000e                	.insn	2, 0x000e

Disassembly of section .sdata:

80003000 <__DATA_BEGIN__>:
80003000:	999a                	.insn	2, 0x999a
80003002:	9999                	.insn	2, 0x9999
80003004:	1999                	.insn	2, 0x1999
80003006:	4059                	.insn	2, 0x4059
80003008:	ffff                	.insn	2, 0xffff
8000300a:	ffff                	.insn	2, 0xffff
8000300c:	ffff                	.insn	2, 0xffff
8000300e:	ffffffef          	jal	t6,8000300c <__DATA_BEGIN__+0xc>
80003012:	ffff                	.insn	2, 0xffff
80003014:	ffff                	.insn	2, 0xffff
80003016:	00007fef          	jal	t6,8000a016 <__global_pointer$+0x6816>
8000301a:	0000                	.insn	2, 0x
8000301c:	cd65                	.insn	2, 0xcd65
8000301e:	41cd                	.insn	2, 0x41cd
80003020:	0000                	.insn	2, 0x
80003022:	0000                	.insn	2, 0x
80003024:	cd65                	.insn	2, 0xcd65
80003026:	c1cd                	.insn	2, 0xc1cd
80003028:	0000                	.insn	2, 0x
8000302a:	0000                	.insn	2, 0x
8000302c:	0000                	.insn	2, 0x
8000302e:	3fe0                	.insn	2, 0x3fe0
80003030:	509f79fb          	.insn	4, 0x509f79fb
80003034:	3fd34413          	xori	s0,t1,1021
80003038:	8b60c8b3          	.insn	4, 0x8b60c8b3
8000303c:	8a28                	.insn	2, 0x8a28
8000303e:	3fc6                	.insn	2, 0x3fc6
80003040:	0000                	.insn	2, 0x
80003042:	0000                	.insn	2, 0x
80003044:	0000                	.insn	2, 0x
80003046:	3ff8                	.insn	2, 0x3ff8
80003048:	4361                	.insn	2, 0x4361
8000304a:	87a7636f          	jal	t1,7ff790c4 <main-0x86f3c>
8000304e:	3fd2                	.insn	2, 0x3fd2
80003050:	a371                	.insn	2, 0xa371
80003052:	0979                	.insn	2, 0x0979
80003054:	400a934f          	fnmadd.s	ft6,fs5,ft0,fs0,rtz
80003058:	fefa39ef          	jal	s3,7ffa7046 <main-0x58fba>
8000305c:	2e42                	.insn	2, 0x2e42
8000305e:	3fe6                	.insn	2, 0x3fe6
80003060:	5516                	.insn	2, 0x5516
80003062:	bbb5                	.insn	2, 0xbbb5
80003064:	6bb1                	.insn	2, 0x6bb1
80003066:	4002                	.insn	2, 0x4002
80003068:	0000                	.insn	2, 0x
8000306a:	0000                	.insn	2, 0x
8000306c:	0000                	.insn	2, 0x
8000306e:	402c                	.insn	2, 0x402c
80003070:	0000                	.insn	2, 0x
80003072:	0000                	.insn	2, 0x
80003074:	0000                	.insn	2, 0x
80003076:	4024                	.insn	2, 0x4024
80003078:	0000                	.insn	2, 0x
8000307a:	0000                	.insn	2, 0x
8000307c:	0000                	.insn	2, 0x
8000307e:	4018                	.insn	2, 0x4018
80003080:	0000                	.insn	2, 0x
80003082:	0000                	.insn	2, 0x
80003084:	0000                	.insn	2, 0x
80003086:	4000                	.insn	2, 0x4000
80003088:	0000                	.insn	2, 0x
8000308a:	0000                	.insn	2, 0x
8000308c:	0000                	.insn	2, 0x
8000308e:	3ff0                	.insn	2, 0x3ff0
80003090:	432d                	.insn	2, 0x432d
80003092:	eb1c                	.insn	2, 0xeb1c
80003094:	36e2                	.insn	2, 0x36e2
80003096:	3f1a                	.insn	2, 0x3f1a
80003098:	0000                	.insn	2, 0x
8000309a:	0000                	.insn	2, 0x
8000309c:	8480                	.insn	2, 0x8480
8000309e:	412e                	.insn	2, 0x412e

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	.insn	2, 0x2820
   6:	36343067          	.insn	4, 0x36343067
   a:	3639                	.insn	2, 0x3639
   c:	6664                	.insn	2, 0x6664
   e:	3930                	.insn	2, 0x3930
  10:	3336                	.insn	2, 0x3336
  12:	2029                	.insn	2, 0x2029
  14:	3431                	.insn	2, 0x3431
  16:	322e                	.insn	2, 0x322e
  18:	302e                	.insn	2, 0x302e
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	5441                	.insn	2, 0x5441
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <main-0x7fffffec>
   c:	004a                	.insn	2, 0x004a
   e:	0000                	.insn	2, 0x
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	.insn	2, 0x5f31
  1c:	326d                	.insn	2, 0x326d
  1e:	3070                	.insn	2, 0x3070
  20:	615f 7032 5f31      	.insn	6, 0x5f317032615f
  26:	3266                	.insn	2, 0x3266
  28:	3270                	.insn	2, 0x3270
  2a:	645f 7032 5f32      	.insn	6, 0x5f327032645f
  30:	697a                	.insn	2, 0x697a
  32:	32727363          	bgeu	tp,t2,358 <main-0x7ffffca8>
  36:	3070                	.insn	2, 0x3070
  38:	7a5f 6d6d 6c75      	.insn	6, 0x6c756d6d7a5f
  3e:	7031                	.insn	2, 0x7031
  40:	5f30                	.insn	2, 0x5f30
  42:	617a                	.insn	2, 0x617a
  44:	6d61                	.insn	2, 0x6d61
  46:	3070316f          	jal	sp,3b4c <main-0x7fffc4b4>
  4a:	7a5f 6c61 7372      	.insn	6, 0x73726c617a5f
  50:	30703163          	.insn	4, 0x30703163
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	001c                	.insn	2, 0x001c
   2:	0000                	.insn	2, 0x
   4:	0002                	.insn	2, 0x0002
   6:	0000                	.insn	2, 0x
   8:	0000                	.insn	2, 0x
   a:	0004                	.insn	2, 0x0004
   c:	0000                	.insn	2, 0x
   e:	0000                	.insn	2, 0x
  10:	0000                	.insn	2, 0x
  12:	8000                	.insn	2, 0x8000
  14:	0030                	.insn	2, 0x0030
	...
  1e:	0000                	.insn	2, 0x
  20:	001c                	.insn	2, 0x001c
  22:	0000                	.insn	2, 0x
  24:	0002                	.insn	2, 0x0002
  26:	0096                	.insn	2, 0x0096
  28:	0000                	.insn	2, 0x
  2a:	0004                	.insn	2, 0x0004
  2c:	0000                	.insn	2, 0x
  2e:	0000                	.insn	2, 0x
  30:	0030                	.insn	2, 0x0030
  32:	8000                	.insn	2, 0x8000
  34:	1c8c                	.insn	2, 0x1c8c
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	0092                	.insn	2, 0x0092
       2:	0000                	.insn	2, 0x
       4:	0005                	.insn	2, 0x0005
       6:	0401                	.insn	2, 0x0401
       8:	0000                	.insn	2, 0x
       a:	0000                	.insn	2, 0x
       c:	0002                	.insn	2, 0x0002
       e:	0000                	.insn	2, 0x
      10:	1d00                	.insn	2, 0x1d00
      12:	0000                	.insn	2, 0x
      14:	0000                	.insn	2, 0x
      16:	000d                	.insn	2, 0x000d
      18:	0000                	.insn	2, 0x
      1a:	000c                	.insn	2, 0x000c
	...
      24:	0000                	.insn	2, 0x
      26:	69050403          	lb	s0,1680(a0)
      2a:	746e                	.insn	2, 0x746e
      2c:	0100                	.insn	2, 0x0100
      2e:	0704                	.insn	2, 0x0704
      30:	000000d7          	.insn	4, 0x00d7
      34:	0801                	.insn	2, 0x0801
      36:	7f05                	.insn	2, 0x7f05
      38:	0000                	.insn	2, 0x
      3a:	0100                	.insn	2, 0x0100
      3c:	0410                	.insn	2, 0x0410
      3e:	006e                	.insn	2, 0x006e
      40:	0000                	.insn	2, 0x
      42:	4204                	.insn	2, 0x4204
      44:	0002                	.insn	2, 0x0002
      46:	0200                	.insn	2, 0x0200
      48:	00260543          	fmadd.s	fa0,fa2,ft2,ft0,rne
      4c:	0000                	.insn	2, 0x
      4e:	0059                	.insn	2, 0x0059
      50:	0000                	.insn	2, 0x
      52:	5905                	.insn	2, 0x5905
      54:	0000                	.insn	2, 0x
      56:	0600                	.insn	2, 0x0600
      58:	0700                	.insn	2, 0x0700
      5a:	6604                	.insn	2, 0x6604
      5c:	0000                	.insn	2, 0x
      5e:	0100                	.insn	2, 0x0100
      60:	0801                	.insn	2, 0x0801
      62:	0201                	.insn	2, 0x0201
      64:	0000                	.insn	2, 0x
      66:	5f08                	.insn	2, 0x5f08
      68:	0000                	.insn	2, 0x
      6a:	0900                	.insn	2, 0x0900
      6c:	007a                	.insn	2, 0x007a
      6e:	0000                	.insn	2, 0x
      70:	0401                	.insn	2, 0x0401
      72:	2605                	.insn	2, 0x2605
      74:	0000                	.insn	2, 0x
      76:	0000                	.insn	2, 0x
      78:	0000                	.insn	2, 0x
      7a:	3080                	.insn	2, 0x3080
      7c:	0000                	.insn	2, 0x
      7e:	0100                	.insn	2, 0x0100
      80:	0a9c                	.insn	2, 0x0a9c
      82:	0020                	.insn	2, 0x0020
      84:	8000                	.insn	2, 0x8000
      86:	0042                	.insn	2, 0x0042
      88:	0000                	.insn	2, 0x
      8a:	055a010b          	.insn	4, 0x055a010b
      8e:	001cc003          	lbu	zero,1(s9)
      92:	0080                	.insn	2, 0x0080
      94:	0000                	.insn	2, 0x
      96:	1861                	.insn	2, 0x1861
      98:	0000                	.insn	2, 0x
      9a:	0005                	.insn	2, 0x0005
      9c:	0401                	.insn	2, 0x0401
      9e:	008a                	.insn	2, 0x008a
      a0:	0000                	.insn	2, 0x
      a2:	00000037          	lui	zero,0x0
      a6:	1d00                	.insn	2, 0x1d00
      a8:	0040                	.insn	2, 0x0040
      aa:	0000                	.insn	2, 0x
      ac:	000d                	.insn	2, 0x000d
      ae:	0000                	.insn	2, 0x
      b0:	0030                	.insn	2, 0x0030
      b2:	8000                	.insn	2, 0x8000
      b4:	1c8c                	.insn	2, 0x1c8c
      b6:	0000                	.insn	2, 0x
      b8:	0084                	.insn	2, 0x0084
      ba:	0000                	.insn	2, 0x
      bc:	cd070807          	.insn	4, 0xcd070807
      c0:	0000                	.insn	2, 0x
      c2:	0700                	.insn	2, 0x0700
      c4:	0704                	.insn	2, 0x0704
      c6:	000000d7          	.insn	4, 0x00d7
      ca:	73040807          	.insn	4, 0x73040807
      ce:	0000                	.insn	2, 0x
      d0:	3800                	.insn	2, 0x3800
      d2:	0504                	.insn	2, 0x0504
      d4:	6e69                	.insn	2, 0x6e69
      d6:	0074                	.insn	2, 0x0074
      d8:	f8080107          	.insn	4, 0xf8080107
      dc:	0001                	.insn	2, 0x0001
      de:	0700                	.insn	2, 0x0700
      e0:	0702                	.insn	2, 0x0702
      e2:	015e                	.insn	2, 0x015e
      e4:	0000                	.insn	2, 0x
      e6:	2d0c                	.insn	2, 0x2d0c
      e8:	0000                	.insn	2, 0x
      ea:	0700                	.insn	2, 0x0700
      ec:	0704                	.insn	2, 0x0704
      ee:	00d2                	.insn	2, 0x00d2
      f0:	0000                	.insn	2, 0x
      f2:	fa060107          	.insn	4, 0xfa060107
      f6:	0001                	.insn	2, 0x0001
      f8:	0700                	.insn	2, 0x0700
      fa:	0502                	.insn	2, 0x0502
      fc:	020c                	.insn	2, 0x020c
      fe:	0000                	.insn	2, 0x
     100:	3b0c                	.insn	2, 0x3b0c
     102:	0000                	.insn	2, 0x
     104:	0700                	.insn	2, 0x0700
     106:	0508                	.insn	2, 0x0508
     108:	007f 0000 be11 0001 	.insn	10, 0x02000001be110000007f
     110:	0200 
     112:	2e30                	.insn	2, 0x2e30
     114:	0026                	.insn	2, 0x0026
     116:	0000                	.insn	2, 0x
     118:	84050407          	.insn	4, 0x84050407
     11c:	0000                	.insn	2, 0x
     11e:	0c00                	.insn	2, 0x0c00
     120:	0082                	.insn	2, 0x0082
     122:	0000                	.insn	2, 0x
     124:	0439                	.insn	2, 0x0439
     126:	0000951b          	.insn	4, 0x951b
     12a:	0700                	.insn	2, 0x0700
     12c:	0801                	.insn	2, 0x0801
     12e:	0201                	.insn	2, 0x0201
     130:	0000                	.insn	2, 0x
     132:	950c                	.insn	2, 0x950c
     134:	0000                	.insn	2, 0x
     136:	1100                	.insn	2, 0x1100
     138:	01c0                	.insn	2, 0x01c0
     13a:	0000                	.insn	2, 0x
     13c:	76141b03          	lh	s6,1889(s0)
     140:	0000                	.insn	2, 0x
     142:	1100                	.insn	2, 0x1100
     144:	009f 0000 5504      	.insn	6, 0x55040000009f
     14a:	00002d17          	auipc	s10,0x2
     14e:	1100                	.insn	2, 0x1100
     150:	01a4                	.insn	2, 0x01a4
     152:	0000                	.insn	2, 0x
     154:	2805                	.insn	2, 0x2805
     156:	0000c51b          	.insn	4, 0xc51b
     15a:	3a00                	.insn	2, 0x3a00
     15c:	f404                	.insn	2, 0xf404
     15e:	0000                	.insn	2, 0x
     160:	1100                	.insn	2, 0x1100
     162:	000001ab          	.insn	4, 0x01ab
     166:	6705                	.insn	2, 0x6705
     168:	b918                	.insn	2, 0xb918
     16a:	0000                	.insn	2, 0x
     16c:	1100                	.insn	2, 0x1100
     16e:	0098                	.insn	2, 0x0098
     170:	0000                	.insn	2, 0x
     172:	d606                	.insn	2, 0xd606
     174:	00002d17          	auipc	s10,0x2
     178:	0c00                	.insn	2, 0x0c00
     17a:	000000d7          	.insn	4, 0x00d7
     17e:	6e041007          	.insn	4, 0x6e041007
     182:	0000                	.insn	2, 0x
     184:	1100                	.insn	2, 0x1100
     186:	01e5                	.insn	2, 0x01e5
     188:	0000                	.insn	2, 0x
     18a:	9a01                	.insn	2, 0x9a01
     18c:	fb10                	.insn	2, 0xfb10
     18e:	0000                	.insn	2, 0x
     190:	1b00                	.insn	2, 0x1b00
     192:	0100                	.insn	2, 0x0100
     194:	0000                	.insn	2, 0x
     196:	00011a2f          	.insn	4, 0x00011a2f
     19a:	1700                	.insn	2, 0x1700
     19c:	0095                	.insn	2, 0x0095
     19e:	0000                	.insn	2, 0x
     1a0:	00008e17          	auipc	t3,0x8
     1a4:	1700                	.insn	2, 0x1700
     1a6:	000000d7          	.insn	4, 0x00d7
     1aa:	0000d717          	auipc	a4,0xd
     1ae:	0000                	.insn	2, 0x
     1b0:	a001083b          	.insn	4, 0xa001083b
     1b4:	3c09                	.insn	2, 0x3c09
     1b6:	0001                	.insn	2, 0x0001
     1b8:	3000                	.insn	2, 0x3000
     1ba:	6366                	.insn	2, 0x6366
     1bc:	0074                	.insn	2, 0x0074
     1be:	0ca1                	.insn	2, 0x0ca1
     1c0:	014c                	.insn	2, 0x014c
     1c2:	0000                	.insn	2, 0x
     1c4:	3000                	.insn	2, 0x3000
     1c6:	7261                	.insn	2, 0x7261
     1c8:	0ba20067          	jalr	zero,186(tp) # ba <main-0x7fffff46>
     1cc:	008e                	.insn	2, 0x008e
     1ce:	0000                	.insn	2, 0x
     1d0:	0004                	.insn	2, 0x0004
     1d2:	00014c2f          	.insn	4, 0x00014c2f
     1d6:	1700                	.insn	2, 0x1700
     1d8:	0095                	.insn	2, 0x0095
     1da:	0000                	.insn	2, 0x
     1dc:	00008e17          	auipc	t3,0x8
     1e0:	0000                	.insn	2, 0x
     1e2:	00013c1b          	.insn	4, 0x00013c1b
     1e6:	1100                	.insn	2, 0x1100
     1e8:	0216                	.insn	2, 0x0216
     1ea:	0000                	.insn	2, 0x
     1ec:	a301                	.insn	2, 0xa301
     1ee:	00011a03          	lh	s4,0(sp)
     1f2:	0c00                	.insn	2, 0x0c00
     1f4:	0151                	.insn	2, 0x0151
     1f6:	0000                	.insn	2, 0x
     1f8:	6318                	.insn	2, 0x6318
     1fa:	0002                	.insn	2, 0x0002
     1fc:	ea00                	.insn	2, 0xea00
     1fe:	00003b03          	.insn	4, 0x3b03
     202:	6000                	.insn	2, 0x6000
     204:	001c                	.insn	2, 0x001c
     206:	5c80                	.insn	2, 0x5c80
     208:	0000                	.insn	2, 0x
     20a:	0100                	.insn	2, 0x0100
     20c:	0a9c                	.insn	2, 0x0a9c
     20e:	0002                	.insn	2, 0x0002
     210:	1200                	.insn	2, 0x1200
     212:	0074756f          	jal	a0,47a18 <main-0x7ffb85e8>
     216:	03ea                	.insn	2, 0x03ea
     218:	4c16                	.insn	2, 0x4c16
     21a:	0001                	.insn	2, 0x0001
     21c:	0c00                	.insn	2, 0x0c00
     21e:	0000                	.insn	2, 0x
     220:	1200                	.insn	2, 0x1200
     222:	7261                	.insn	2, 0x7261
     224:	03ea0067          	jalr	zero,62(s4)
     228:	8e3d                	.insn	2, 0x8e3d
     22a:	0000                	.insn	2, 0x
     22c:	2b00                	.insn	2, 0x2b00
     22e:	0000                	.insn	2, 0x
     230:	0400                	.insn	2, 0x0400
     232:	022e                	.insn	2, 0x022e
     234:	0000                	.insn	2, 0x
     236:	0a1b03eb          	.insn	4, 0x0a1b03eb
     23a:	0002                	.insn	2, 0x0002
     23c:	4a00                	.insn	2, 0x4a00
     23e:	0000                	.insn	2, 0x
     240:	1f00                	.insn	2, 0x1f00
     242:	760d                	.insn	2, 0x760d
     244:	0061                	.insn	2, 0x0061
     246:	03ec                	.insn	2, 0x03ec
     248:	cb0d                	.insn	2, 0xcb0d
     24a:	0000                	.insn	2, 0x
     24c:	0200                	.insn	2, 0x0200
     24e:	4491                	.insn	2, 0x4491
     250:	d81c                	.insn	2, 0xd81c
     252:	0001                	.insn	2, 0x0001
     254:	ee00                	.insn	2, 0xee00
     256:	015d1d03          	lh	s10,21(s10) # 2189 <main-0x7fffde77>
     25a:	0000                	.insn	2, 0x
     25c:	9102                	.insn	2, 0x9102
     25e:	0d48                	.insn	2, 0x0d48
     260:	6572                	.insn	2, 0x6572
     262:	0074                	.insn	2, 0x0074
     264:	6a0f03ef          	jal	t2,f0904 <main-0x7ff0f6fc>
     268:	0000                	.insn	2, 0x
     26a:	0100                	.insn	2, 0x0100
     26c:	165a                	.insn	2, 0x165a
     26e:	1cb0                	.insn	2, 0x1cb0
     270:	8000                	.insn	2, 0x8000
     272:	04ff 0000 0101 055a 	.insn	10, 0xd803055a0101000004ff
     27a:	d803 
     27c:	0006                	.insn	2, 0x0006
     27e:	0180                	.insn	2, 0x0180
     280:	5b01                	.insn	2, 0x5b01
     282:	9102                	.insn	2, 0x9102
     284:	0148                	.insn	2, 0x0148
     286:	5c01                	.insn	2, 0x5c01
     288:	0902                	.insn	2, 0x0902
     28a:	01ff 5d01 a309 a503 	.insn	10, 0x260ca503a3095d0101ff
     292:	260c 
     294:	2da8                	.insn	2, 0x2da8
     296:	00a8                	.insn	2, 0x00a8
     298:	0101                	.insn	2, 0x0101
     29a:	025e                	.insn	2, 0x025e
     29c:	6c91                	.insn	2, 0x6c91
     29e:	0000                	.insn	2, 0x
     2a0:	00009c1b          	.insn	4, 0x9c1b
     2a4:	1800                	.insn	2, 0x1800
     2a6:	0000023f 003b03e6 	.insn	8, 0x003b03e60000023f
     2ae:	0000                	.insn	2, 0x
     2b0:	1c3c                	.insn	2, 0x1c3c
     2b2:	8000                	.insn	2, 0x8000
     2b4:	0024                	.insn	2, 0x0024
     2b6:	0000                	.insn	2, 0x
     2b8:	9c01                	.insn	2, 0x9c01
     2ba:	000002af          	.insn	4, 0x02af
     2be:	4004                	.insn	2, 0x4004
     2c0:	0001                	.insn	2, 0x0001
     2c2:	e600                	.insn	2, 0xe600
     2c4:	00901603          	lh	a2,9(zero) # 9 <main-0x7ffffff7>
     2c8:	0000                	.insn	2, 0x
     2ca:	0069                	.insn	2, 0x0069
     2cc:	0000                	.insn	2, 0x
     2ce:	8d04                	.insn	2, 0x8d04
     2d0:	0000                	.insn	2, 0x
     2d2:	e600                	.insn	2, 0xe600
     2d4:	00d72503          	lw	a0,13(a4) # d1b7 <main-0x7fff2e49>
     2d8:	0000                	.insn	2, 0x
     2da:	0088                	.insn	2, 0x0088
     2dc:	0000                	.insn	2, 0x
     2de:	2e04                	.insn	2, 0x2e04
     2e0:	0002                	.insn	2, 0x0002
     2e2:	e600                	.insn	2, 0xe600
     2e4:	020a3803          	.insn	4, 0x020a3803
     2e8:	0000                	.insn	2, 0x
     2ea:	000000a7          	.insn	4, 0x00a7
     2ee:	7612                	.insn	2, 0x7612
     2f0:	0061                	.insn	2, 0x0061
     2f2:	03e6                	.insn	2, 0x03e6
     2f4:	cb48                	.insn	2, 0xcb48
     2f6:	0000                	.insn	2, 0x
     2f8:	c600                	.insn	2, 0xc600
     2fa:	0000                	.insn	2, 0x
     2fc:	3c00                	.insn	2, 0x3c00
     2fe:	1c60                	.insn	2, 0x1c60
     300:	8000                	.insn	2, 0x8000
     302:	04ff 0000 0101 055a 	.insn	10, 0x3003055a0101000004ff
     30a:	3003 
     30c:	0000                	.insn	2, 0x
     30e:	0180                	.insn	2, 0x0180
     310:	5b01                	.insn	2, 0x5b01
     312:	a309                	.insn	2, 0xa309
     314:	260aa503          	lw	a0,608(s5)
     318:	2da8                	.insn	2, 0x2da8
     31a:	00a8                	.insn	2, 0x00a8
     31c:	0101                	.insn	2, 0x0101
     31e:	095c                	.insn	2, 0x095c
     320:	0ba503a3          	sb	s10,167(a0)
     324:	a826                	.insn	2, 0xa826
     326:	a82d                	.insn	2, 0xa82d
     328:	0100                	.insn	2, 0x0100
     32a:	5d01                	.insn	2, 0x5d01
     32c:	a309                	.insn	2, 0xa309
     32e:	260ca503          	lw	a0,608(s9)
     332:	2da8                	.insn	2, 0x2da8
     334:	00a8                	.insn	2, 0x00a8
     336:	0101                	.insn	2, 0x0101
     338:	095e                	.insn	2, 0x095e
     33a:	0da503a3          	sb	s10,199(a0)
     33e:	a826                	.insn	2, 0xa826
     340:	a82d                	.insn	2, 0xa82d
     342:	0000                	.insn	2, 0x
     344:	1800                	.insn	2, 0x1800
     346:	0150                	.insn	2, 0x0150
     348:	0000                	.insn	2, 0x
     34a:	03e1                	.insn	2, 0x03e1
     34c:	0000003b          	.insn	4, 0x003b
     350:	1c0c                	.insn	2, 0x1c0c
     352:	8000                	.insn	2, 0x8000
     354:	0030                	.insn	2, 0x0030
     356:	0000                	.insn	2, 0x
     358:	9c01                	.insn	2, 0x9c01
     35a:	0330                	.insn	2, 0x0330
     35c:	0000                	.insn	2, 0x
     35e:	2e04                	.insn	2, 0x2e04
     360:	0002                	.insn	2, 0x0002
     362:	e100                	.insn	2, 0xe100
     364:	020a1a03          	lh	s4,32(s4)
     368:	0000                	.insn	2, 0x
     36a:	00e5                	.insn	2, 0x00e5
     36c:	0000                	.insn	2, 0x
     36e:	7612                	.insn	2, 0x7612
     370:	0061                	.insn	2, 0x0061
     372:	03e1                	.insn	2, 0x03e1
     374:	cb2a                	.insn	2, 0xcb2a
     376:	0000                	.insn	2, 0x
     378:	0400                	.insn	2, 0x0400
     37a:	0001                	.insn	2, 0x0001
     37c:	1c00                	.insn	2, 0x1c00
     37e:	0140                	.insn	2, 0x0140
     380:	0000                	.insn	2, 0x
     382:	03e2                	.insn	2, 0x03e2
     384:	300a                	.insn	2, 0x300a
     386:	02000003          	lb	zero,32(zero) # 20 <main-0x7fffffe0>
     38a:	6c91                	.insn	2, 0x6c91
     38c:	3016                	.insn	2, 0x3016
     38e:	001c                	.insn	2, 0x001c
     390:	ff80                	.insn	2, 0xff80
     392:	0004                	.insn	2, 0x0004
     394:	0100                	.insn	2, 0x0100
     396:	5a01                	.insn	2, 0x5a01
     398:	0305                	.insn	2, 0x0305
     39a:	0044                	.insn	2, 0x0044
     39c:	8000                	.insn	2, 0x8000
     39e:	0101                	.insn	2, 0x0101
     3a0:	6c91025b          	.insn	4, 0x6c91025b
     3a4:	0101                	.insn	2, 0x0101
     3a6:	025c                	.insn	2, 0x025c
     3a8:	ff09                	.insn	2, 0xff09
     3aa:	0101                	.insn	2, 0x0101
     3ac:	095d                	.insn	2, 0x095d
     3ae:	0aa503a3          	sb	a0,167(a0)
     3b2:	a826                	.insn	2, 0xa826
     3b4:	a82d                	.insn	2, 0xa82d
     3b6:	0100                	.insn	2, 0x0100
     3b8:	5e01                	.insn	2, 0x5e01
     3ba:	a309                	.insn	2, 0xa309
     3bc:	260ba503          	lw	a0,608(s7)
     3c0:	2da8                	.insn	2, 0x2da8
     3c2:	00a8                	.insn	2, 0x00a8
     3c4:	0000                	.insn	2, 0x
     3c6:	9524                	.insn	2, 0x9524
     3c8:	0000                	.insn	2, 0x
     3ca:	4000                	.insn	2, 0x4000
     3cc:	25000003          	lb	zero,592(zero) # 250 <main-0x7ffffdb0>
     3d0:	002d                	.insn	2, 0x002d
     3d2:	0000                	.insn	2, 0x
     3d4:	0000                	.insn	2, 0x
     3d6:	4018                	.insn	2, 0x4018
     3d8:	0002                	.insn	2, 0x0002
     3da:	d900                	.insn	2, 0xd900
     3dc:	00003b03          	.insn	4, 0x3b03
     3e0:	b800                	.insn	2, 0xb800
     3e2:	5480001b          	.insn	4, 0x5480001b
     3e6:	0000                	.insn	2, 0x
     3e8:	0100                	.insn	2, 0x0100
     3ea:	e79c                	.insn	2, 0xe79c
     3ec:	04000003          	lb	zero,64(zero) # 40 <main-0x7fffffc0>
     3f0:	0140                	.insn	2, 0x0140
     3f2:	0000                	.insn	2, 0x
     3f4:	03d9                	.insn	2, 0x03d9
     3f6:	9015                	.insn	2, 0x9015
     3f8:	0000                	.insn	2, 0x
     3fa:	2300                	.insn	2, 0x2300
     3fc:	0001                	.insn	2, 0x0001
     3fe:	0400                	.insn	2, 0x0400
     400:	008d                	.insn	2, 0x008d
     402:	0000                	.insn	2, 0x
     404:	03d9                	.insn	2, 0x03d9
     406:	d724                	.insn	2, 0xd724
     408:	0000                	.insn	2, 0x
     40a:	4200                	.insn	2, 0x4200
     40c:	0001                	.insn	2, 0x0001
     40e:	0400                	.insn	2, 0x0400
     410:	022e                	.insn	2, 0x022e
     412:	0000                	.insn	2, 0x
     414:	03d9                	.insn	2, 0x03d9
     416:	00020a37          	lui	s4,0x20
     41a:	6100                	.insn	2, 0x6100
     41c:	0001                	.insn	2, 0x0001
     41e:	1f00                	.insn	2, 0x1f00
     420:	760d                	.insn	2, 0x760d
     422:	0061                	.insn	2, 0x0061
     424:	03da                	.insn	2, 0x03da
     426:	cb0d                	.insn	2, 0xcb0d
     428:	0000                	.insn	2, 0x
     42a:	0200                	.insn	2, 0x0200
     42c:	4c91                	.insn	2, 0x4c91
     42e:	720d                	.insn	2, 0x720d
     430:	7465                	.insn	2, 0x7465
     432:	dc00                	.insn	2, 0xdc00
     434:	006a0f03          	lb	t5,6(s4) # 20006 <main-0x7ffdfffa>
     438:	0000                	.insn	2, 0x
     43a:	5a01                	.insn	2, 0x5a01
     43c:	0016                	.insn	2, 0x0016
     43e:	001c                	.insn	2, 0x001c
     440:	ff80                	.insn	2, 0xff80
     442:	0004                	.insn	2, 0x0004
     444:	0100                	.insn	2, 0x0100
     446:	5a01                	.insn	2, 0x5a01
     448:	0305                	.insn	2, 0x0305
     44a:	0030                	.insn	2, 0x0030
     44c:	8000                	.insn	2, 0x8000
     44e:	0101                	.insn	2, 0x0101
     450:	03a3095b          	.insn	4, 0x03a3095b
     454:	0aa5                	.insn	2, 0x0aa5
     456:	a826                	.insn	2, 0xa826
     458:	a82d                	.insn	2, 0xa82d
     45a:	0100                	.insn	2, 0x0100
     45c:	5c01                	.insn	2, 0x5c01
     45e:	a309                	.insn	2, 0xa309
     460:	260ba503          	lw	a0,608(s7)
     464:	2da8                	.insn	2, 0x2da8
     466:	00a8                	.insn	2, 0x00a8
     468:	0101                	.insn	2, 0x0101
     46a:	095d                	.insn	2, 0x095d
     46c:	0ca503a3          	sb	a0,199(a0)
     470:	a826                	.insn	2, 0xa826
     472:	a82d                	.insn	2, 0xa82d
     474:	0100                	.insn	2, 0x0100
     476:	5e01                	.insn	2, 0x5e01
     478:	9102                	.insn	2, 0x9102
     47a:	006c                	.insn	2, 0x006c
     47c:	1800                	.insn	2, 0x1800
     47e:	0115                	.insn	2, 0x0115
     480:	0000                	.insn	2, 0x
     482:	03d1                	.insn	2, 0x03d1
     484:	0000003b          	.insn	4, 0x003b
     488:	1b64                	.insn	2, 0x1b64
     48a:	8000                	.insn	2, 0x8000
     48c:	0054                	.insn	2, 0x0054
     48e:	0000                	.insn	2, 0x
     490:	9c01                	.insn	2, 0x9c01
     492:	00000477          	.insn	4, 0x0477
     496:	4004                	.insn	2, 0x4004
     498:	0001                	.insn	2, 0x0001
     49a:	d100                	.insn	2, 0xd100
     49c:	00901403          	lh	s0,9(zero) # 9 <main-0x7ffffff7>
     4a0:	0000                	.insn	2, 0x
     4a2:	0180                	.insn	2, 0x0180
     4a4:	0000                	.insn	2, 0x
     4a6:	2e04                	.insn	2, 0x2e04
     4a8:	0002                	.insn	2, 0x0002
     4aa:	d100                	.insn	2, 0xd100
     4ac:	020a2803          	lw	a6,32(s4)
     4b0:	0000                	.insn	2, 0x
     4b2:	019f 0000 0d1f      	.insn	6, 0x0d1f0000019f
     4b8:	6176                	.insn	2, 0x6176
     4ba:	d200                	.insn	2, 0xd200
     4bc:	00cb0d03          	lb	s10,12(s6)
     4c0:	0000                	.insn	2, 0x
     4c2:	9102                	.insn	2, 0x9102
     4c4:	0d4c                	.insn	2, 0x0d4c
     4c6:	6572                	.insn	2, 0x6572
     4c8:	0074                	.insn	2, 0x0074
     4ca:	03d4                	.insn	2, 0x03d4
     4cc:	00006a0f          	.insn	4, 0x6a0f
     4d0:	0100                	.insn	2, 0x0100
     4d2:	165a                	.insn	2, 0x165a
     4d4:	1bac                	.insn	2, 0x1bac
     4d6:	8000                	.insn	2, 0x8000
     4d8:	04ff 0000 0101 055a 	.insn	10, 0x3003055a0101000004ff
     4e0:	3003 
     4e2:	0000                	.insn	2, 0x
     4e4:	0180                	.insn	2, 0x0180
     4e6:	5b01                	.insn	2, 0x5b01
     4e8:	a309                	.insn	2, 0xa309
     4ea:	260aa503          	lw	a0,608(s5)
     4ee:	2da8                	.insn	2, 0x2da8
     4f0:	00a8                	.insn	2, 0x00a8
     4f2:	0101                	.insn	2, 0x0101
     4f4:	025c                	.insn	2, 0x025c
     4f6:	ff09                	.insn	2, 0xff09
     4f8:	0101                	.insn	2, 0x0101
     4fa:	095d                	.insn	2, 0x095d
     4fc:	0ba503a3          	sb	s10,167(a0)
     500:	a826                	.insn	2, 0xa826
     502:	a82d                	.insn	2, 0xa82d
     504:	0100                	.insn	2, 0x0100
     506:	5e01                	.insn	2, 0x5e01
     508:	9102                	.insn	2, 0x9102
     50a:	0068                	.insn	2, 0x0068
     50c:	1800                	.insn	2, 0x1800
     50e:	0242                	.insn	2, 0x0242
     510:	0000                	.insn	2, 0x
     512:	03c8                	.insn	2, 0x03c8
     514:	0000003b          	.insn	4, 0x003b
     518:	1b10                	.insn	2, 0x1b10
     51a:	8000                	.insn	2, 0x8000
     51c:	0054                	.insn	2, 0x0054
     51e:	0000                	.insn	2, 0x
     520:	9c01                	.insn	2, 0x9c01
     522:	04ff 0000 2e04 0002 	.insn	10, 0xc80000022e04000004ff
     52a:	c800 
     52c:	020a1903          	lh	s2,32(s4)
     530:	0000                	.insn	2, 0x
     532:	01be                	.insn	2, 0x01be
     534:	0000                	.insn	2, 0x
     536:	0d1f 6176 c900      	.insn	6, 0xc90061760d1f
     53c:	00cb0d03          	lb	s10,12(s6)
     540:	0000                	.insn	2, 0x
     542:	9102                	.insn	2, 0x9102
     544:	1c4c                	.insn	2, 0x1c4c
     546:	0140                	.insn	2, 0x0140
     548:	0000                	.insn	2, 0x
     54a:	300a03cb          	fnmsub.s	ft7,fs4,ft0,ft6,rne
     54e:	02000003          	lb	zero,32(zero) # 20 <main-0x7fffffe0>
     552:	4891                	.insn	2, 0x4891
     554:	720d                	.insn	2, 0x720d
     556:	7465                	.insn	2, 0x7465
     558:	cc00                	.insn	2, 0xcc00
     55a:	006a0f03          	lb	t5,6(s4)
     55e:	0000                	.insn	2, 0x
     560:	5a01                	.insn	2, 0x5a01
     562:	5816                	.insn	2, 0x5816
     564:	ff80001b          	.insn	4, 0xff80001b
     568:	0004                	.insn	2, 0x0004
     56a:	0100                	.insn	2, 0x0100
     56c:	5a01                	.insn	2, 0x5a01
     56e:	0305                	.insn	2, 0x0305
     570:	0044                	.insn	2, 0x0044
     572:	8000                	.insn	2, 0x8000
     574:	0101                	.insn	2, 0x0101
     576:	4891025b          	.insn	4, 0x4891025b
     57a:	0101                	.insn	2, 0x0101
     57c:	025c                	.insn	2, 0x025c
     57e:	ff09                	.insn	2, 0xff09
     580:	0101                	.insn	2, 0x0101
     582:	095d                	.insn	2, 0x095d
     584:	0aa503a3          	sb	a0,167(a0)
     588:	a826                	.insn	2, 0xa826
     58a:	a82d                	.insn	2, 0xa82d
     58c:	0100                	.insn	2, 0x0100
     58e:	5e01                	.insn	2, 0x5e01
     590:	9102                	.insn	2, 0x9102
     592:	0064                	.insn	2, 0x0064
     594:	3100                	.insn	2, 0x3100
     596:	00e9                	.insn	2, 0x00e9
     598:	0000                	.insn	2, 0x
     59a:	027e                	.insn	2, 0x027e
     59c:	3b0c                	.insn	2, 0x3b0c
     59e:	0000                	.insn	2, 0x
     5a0:	a000                	.insn	2, 0xa000
     5a2:	0010                	.insn	2, 0x0010
     5a4:	6880                	.insn	2, 0x6880
     5a6:	0009                	.insn	2, 0x0009
     5a8:	0100                	.insn	2, 0x0100
     5aa:	a19c                	.insn	2, 0xa19c
     5ac:	0009                	.insn	2, 0x0009
     5ae:	1200                	.insn	2, 0x1200
     5b0:	0074756f          	jal	a0,47db6 <main-0x7ffb824a>
     5b4:	027e                	.insn	2, 0x027e
     5b6:	ef24                	.insn	2, 0xef24
     5b8:	0000                	.insn	2, 0x
     5ba:	dd00                	.insn	2, 0xdd00
     5bc:	0001                	.insn	2, 0x0001
     5be:	0400                	.insn	2, 0x0400
     5c0:	0140                	.insn	2, 0x0140
     5c2:	0000                	.insn	2, 0x
     5c4:	027e                	.insn	2, 0x027e
     5c6:	0000902f          	.insn	4, 0x902f
     5ca:	1800                	.insn	2, 0x1800
     5cc:	0002                	.insn	2, 0x0002
     5ce:	0400                	.insn	2, 0x0400
     5d0:	0171                	.insn	2, 0x0171
     5d2:	0000                	.insn	2, 0x
     5d4:	027e                	.insn	2, 0x027e
     5d6:	e344                	.insn	2, 0xe344
     5d8:	0000                	.insn	2, 0x
     5da:	4c00                	.insn	2, 0x4c00
     5dc:	0002                	.insn	2, 0x0002
     5de:	0400                	.insn	2, 0x0400
     5e0:	022e                	.insn	2, 0x022e
     5e2:	0000                	.insn	2, 0x
     5e4:	027f 0a23 0002 7200 	.insn	10, 0x0002720000020a23027f
     5ec:	0002 
     5ee:	1200                	.insn	2, 0x1200
     5f0:	6176                	.insn	2, 0x6176
     5f2:	7f00                	.insn	2, 0x7f00
     5f4:	3302                	.insn	2, 0x3302
     5f6:	000000cb          	fnmsub.s	ft1,ft0,ft0,ft0,rne
     5fa:	0332                	.insn	2, 0x0332
     5fc:	0000                	.insn	2, 0x
     5fe:	00027c13          	andi	s8,tp,0
     602:	8000                	.insn	2, 0x8000
     604:	1202                	.insn	2, 0x1202
     606:	002d                	.insn	2, 0x002d
     608:	0000                	.insn	2, 0x
     60a:	0456                	.insn	2, 0x0456
     60c:	0000                	.insn	2, 0x
     60e:	00025d13          	srli	s10,tp,0x0
     612:	8000                	.insn	2, 0x8000
     614:	1902                	.insn	2, 0x1902
     616:	002d                	.insn	2, 0x002d
     618:	0000                	.insn	2, 0x
     61a:	0564                	.insn	2, 0x0564
     61c:	0000                	.insn	2, 0x
     61e:	00023513          	sltiu	a0,tp,0
     622:	8000                	.insn	2, 0x8000
     624:	2002                	.insn	2, 0x2002
     626:	002d                	.insn	2, 0x002d
     628:	0000                	.insn	2, 0x
     62a:	05be                	.insn	2, 0x05be
     62c:	0000                	.insn	2, 0x
     62e:	6e19                	.insn	2, 0x6e19
     630:	8000                	.insn	2, 0x8000
     632:	2b02                	.insn	2, 0x2b02
     634:	002d                	.insn	2, 0x002d
     636:	0000                	.insn	2, 0x
     638:	05df 0000 6919      	.insn	6, 0x6919000005df
     63e:	7864                	.insn	2, 0x7864
     640:	8100                	.insn	2, 0x8100
     642:	0c02                	.insn	2, 0x0c02
     644:	000000d7          	.insn	4, 0x00d7
     648:	0628                	.insn	2, 0x0628
     64a:	0000                	.insn	2, 0x
     64c:	e414                	.insn	2, 0xe414
     64e:	0000                	.insn	2, 0x
     650:	ca00                	.insn	2, 0xca00
     652:	0005                	.insn	2, 0x0005
     654:	1a00                	.insn	2, 0x1a00
     656:	02bc0077          	.insn	4, 0x02bc0077
     65a:	00006a17          	auipc	s4,0x6
     65e:	0000                	.insn	2, 0x
     660:	cf14                	.insn	2, 0xcf14
     662:	0001                	.insn	2, 0x0001
     664:	e000                	.insn	2, 0xe000
     666:	0005                	.insn	2, 0x0005
     668:	0800                	.insn	2, 0x0800
     66a:	00000093          	addi	ra,zero,0
     66e:	02ce                	.insn	2, 0x02ce
     670:	00006a1b          	.insn	4, 0x6a1b
     674:	0000                	.insn	2, 0x
     676:	a83d                	.insn	2, 0xa83d
     678:	0012                	.insn	2, 0x0012
     67a:	2080                	.insn	2, 0x2080
     67c:	0000                	.insn	2, 0x
     67e:	1800                	.insn	2, 0x1800
     680:	0006                	.insn	2, 0x0006
     682:	1300                	.insn	2, 0x1300
     684:	0159                	.insn	2, 0x0159
     686:	0000                	.insn	2, 0x
     688:	0a1102db          	.insn	4, 0x0a1102db
     68c:	0002                	.insn	2, 0x0002
     68e:	2400                	.insn	2, 0x2400
     690:	26000007          	.insn	4, 0x26000007
     694:	0ffe                	.insn	2, 0x0ffe
     696:	0000                	.insn	2, 0x
     698:	12b4                	.insn	2, 0x12b4
     69a:	8000                	.insn	2, 0x8000
     69c:	0000017b          	.insn	4, 0x017b
     6a0:	021102db          	.insn	4, 0x021102db
     6a4:	0000100b          	.insn	4, 0x100b
     6a8:	072c                	.insn	2, 0x072c
     6aa:	0000                	.insn	2, 0x
     6ac:	0000                	.insn	2, 0x
     6ae:	f914                	.insn	2, 0xf914
     6b0:	0000                	.insn	2, 0x
     6b2:	9600                	.insn	2, 0x9600
     6b4:	0006                	.insn	2, 0x0006
     6b6:	1300                	.insn	2, 0x1300
     6b8:	0196                	.insn	2, 0x0196
     6ba:	0000                	.insn	2, 0x
     6bc:	0308                	.insn	2, 0x0308
     6be:	2d1a                	.insn	2, 0x2d1a
     6c0:	0000                	.insn	2, 0x
     6c2:	3400                	.insn	2, 0x3400
     6c4:	14000007          	.insn	4, 0x14000007
     6c8:	0136                	.insn	2, 0x0136
     6ca:	0000                	.insn	2, 0x
     6cc:	0649                	.insn	2, 0x0649
     6ce:	0000                	.insn	2, 0x
     6d0:	1e1c                	.insn	2, 0x1e1c
     6d2:	0001                	.insn	2, 0x0001
     6d4:	2f00                	.insn	2, 0x2f00
     6d6:	00892003          	lw	zero,8(s2)
     6da:	0000                	.insn	2, 0x
     6dc:	5f01                	.insn	2, 0x5f01
     6de:	1400                	.insn	2, 0x1400
     6e0:	0150                	.insn	2, 0x0150
     6e2:	0000                	.insn	2, 0x
     6e4:	00000663          	beq	zero,zero,6f0 <main-0x7ffff910>
     6e8:	00011e13          	slli	t3,sp,0x0
     6ec:	3500                	.insn	2, 0x3500
     6ee:	006a1f03          	lh	t5,6(s4) # 6660 <main-0x7fff99a0>
     6f2:	0000                	.insn	2, 0x
     6f4:	074d                	.insn	2, 0x074d
     6f6:	0000                	.insn	2, 0x
     6f8:	2000                	.insn	2, 0x2000
     6fa:	0160                	.insn	2, 0x0160
     6fc:	0000                	.insn	2, 0x
     6fe:	00011e13          	slli	t3,sp,0x0
     702:	4b00                	.insn	2, 0x4b00
     704:	00502803          	lw	a6,5(zero) # 5 <main-0x7ffffffb>
     708:	0000                	.insn	2, 0x
     70a:	0755                	.insn	2, 0x0755
     70c:	0000                	.insn	2, 0x
     70e:	d416                	.insn	2, 0xd416
     710:	b3800017          	auipc	zero,0xb3800
     714:	0100000b          	.insn	4, 0x0100000b
     718:	5a01                	.insn	2, 0x5a01
     71a:	8302                	.insn	2, 0x8302
     71c:	0100                	.insn	2, 0x0100
     71e:	5b01                	.insn	2, 0x5b01
     720:	8202                	.insn	2, 0x8202
     722:	0100                	.insn	2, 0x0100
     724:	5d01                	.insn	2, 0x5d01
     726:	7902                	.insn	2, 0x7902
     728:	0000                	.insn	2, 0x
     72a:	0000                	.insn	2, 0x
     72c:	8614                	.insn	2, 0x8614
     72e:	0001                	.insn	2, 0x0001
     730:	4200                	.insn	2, 0x4200
     732:	19000007          	.insn	4, 0x19000007
     736:	006c                	.insn	2, 0x006c
     738:	0371                	.insn	2, 0x0371
     73a:	2d1a                	.insn	2, 0x2d1a
     73c:	0000                	.insn	2, 0x
     73e:	5d00                	.insn	2, 0x5d00
     740:	09000007          	.insn	4, 0x09000007
     744:	14f4                	.insn	2, 0x14f4
     746:	8000                	.insn	2, 0x8000
     748:	06c9                	.insn	2, 0x06c9
     74a:	0000                	.insn	2, 0x
     74c:	0101                	.insn	2, 0x0101
     74e:	0082025b          	.insn	4, 0x0082025b
     752:	0101                	.insn	2, 0x0101
     754:	025c                	.insn	2, 0x025c
     756:	0101008b          	.insn	4, 0x0101008b
     75a:	025d                	.insn	2, 0x025d
     75c:	0079                	.insn	2, 0x0079
     75e:	0900                	.insn	2, 0x0900
     760:	1518                	.insn	2, 0x1518
     762:	8000                	.insn	2, 0x8000
     764:	000006eb          	.insn	4, 0x06eb
     768:	0101                	.insn	2, 0x0101
     76a:	025a                	.insn	2, 0x025a
     76c:	2008                	.insn	2, 0x2008
     76e:	0101                	.insn	2, 0x0101
     770:	0082025b          	.insn	4, 0x0082025b
     774:	0101                	.insn	2, 0x0101
     776:	025c                	.insn	2, 0x025c
     778:	7f88                	.insn	2, 0x7f88
     77a:	0101                	.insn	2, 0x0101
     77c:	025d                	.insn	2, 0x025d
     77e:	0079                	.insn	2, 0x0079
     780:	0900                	.insn	2, 0x0900
     782:	1854                	.insn	2, 0x1854
     784:	8000                	.insn	2, 0x8000
     786:	070d                	.insn	2, 0x070d
     788:	0000                	.insn	2, 0x
     78a:	0101                	.insn	2, 0x0101
     78c:	025a                	.insn	2, 0x025a
     78e:	2008                	.insn	2, 0x2008
     790:	0101                	.insn	2, 0x0101
     792:	0082025b          	.insn	4, 0x0082025b
     796:	0101                	.insn	2, 0x0101
     798:	025c                	.insn	2, 0x025c
     79a:	0088                	.insn	2, 0x0088
     79c:	0101                	.insn	2, 0x0101
     79e:	025d                	.insn	2, 0x025d
     7a0:	0079                	.insn	2, 0x0079
     7a2:	0900                	.insn	2, 0x0900
     7a4:	1874                	.insn	2, 0x1874
     7a6:	8000                	.insn	2, 0x8000
     7a8:	0729                	.insn	2, 0x0729
     7aa:	0000                	.insn	2, 0x
     7ac:	0101                	.insn	2, 0x0101
     7ae:	0082025b          	.insn	4, 0x0082025b
     7b2:	0101                	.insn	2, 0x0101
     7b4:	025c                	.insn	2, 0x025c
     7b6:	0088                	.insn	2, 0x0088
     7b8:	0101                	.insn	2, 0x0101
     7ba:	025d                	.insn	2, 0x025d
     7bc:	0079                	.insn	2, 0x0079
     7be:	0a00                	.insn	2, 0x0a00
     7c0:	1950                	.insn	2, 0x1950
     7c2:	8000                	.insn	2, 0x8000
     7c4:	0101                	.insn	2, 0x0101
     7c6:	0082025b          	.insn	4, 0x0082025b
     7ca:	0101                	.insn	2, 0x0101
     7cc:	025c                	.insn	2, 0x025c
     7ce:	0101008b          	.insn	4, 0x0101008b
     7d2:	025d                	.insn	2, 0x025d
     7d4:	0079                	.insn	2, 0x0079
     7d6:	0000                	.insn	2, 0x
     7d8:	a014                	.insn	2, 0xa014
     7da:	0001                	.insn	2, 0x0001
     7dc:	1200                	.insn	2, 0x1200
     7de:	0008                	.insn	2, 0x0008
     7e0:	1900                	.insn	2, 0x1900
     7e2:	0070                	.insn	2, 0x0070
     7e4:	0385                	.insn	2, 0x0385
     7e6:	0a19                	.insn	2, 0x0a19
     7e8:	0002                	.insn	2, 0x0002
     7ea:	c200                	.insn	2, 0xc200
     7ec:	19000007          	.insn	4, 0x19000007
     7f0:	006c                	.insn	2, 0x006c
     7f2:	0386                	.insn	2, 0x0386
     7f4:	2d1a                	.insn	2, 0x2d1a
     7f6:	0000                	.insn	2, 0x
     7f8:	3a00                	.insn	2, 0x3a00
     7fa:	0008                	.insn	2, 0x0008
     7fc:	2700                	.insn	2, 0x2700
     7fe:	00000e9b          	.insn	4, 0x0e9b
     802:	1578                	.insn	2, 0x1578
     804:	8000                	.insn	2, 0x8000
     806:	000001bf 951e0386 	.insn	8, 0x951e0386000001bf
     80e:	0b000007          	.insn	4, 0x0b000007
     812:	00000eab          	.insn	4, 0x0eab
     816:	000eb60b          	.insn	4, 0x000eb60b
     81a:	2000                	.insn	2, 0x2000
     81c:	000001bf 000ec103 	.insn	8, 0x000ec103000001bf
     824:	a900                	.insn	2, 0xa900
     826:	0008                	.insn	2, 0x0008
     828:	0000                	.insn	2, 0x
     82a:	0900                	.insn	2, 0x0900
     82c:	15ec                	.insn	2, 0x15ec
     82e:	8000                	.insn	2, 0x8000
     830:	07b5                	.insn	2, 0x07b5
     832:	0000                	.insn	2, 0x
     834:	0101                	.insn	2, 0x0101
     836:	0082025b          	.insn	4, 0x0082025b
     83a:	0101                	.insn	2, 0x0101
     83c:	065c                	.insn	2, 0x065c
     83e:	ac91                	.insn	2, 0xac91
     840:	067f 1c31 0101 025d 	.insn	10, 0x0079025d01011c31067f
     848:	0079 
     84a:	0900                	.insn	2, 0x0900
     84c:	1710                	.insn	2, 0x1710
     84e:	8000                	.insn	2, 0x8000
     850:	07d1                	.insn	2, 0x07d1
     852:	0000                	.insn	2, 0x
     854:	0101                	.insn	2, 0x0101
     856:	0082025b          	.insn	4, 0x0082025b
     85a:	0101                	.insn	2, 0x0101
     85c:	025c                	.insn	2, 0x025c
     85e:	0101008b          	.insn	4, 0x0101008b
     862:	025d                	.insn	2, 0x025d
     864:	0079                	.insn	2, 0x0079
     866:	0900                	.insn	2, 0x0900
     868:	176c                	.insn	2, 0x176c
     86a:	8000                	.insn	2, 0x8000
     86c:	000007f3          	.insn	4, 0x07f3
     870:	0101                	.insn	2, 0x0101
     872:	025a                	.insn	2, 0x025a
     874:	2008                	.insn	2, 0x2008
     876:	0101                	.insn	2, 0x0101
     878:	0082025b          	.insn	4, 0x0082025b
     87c:	0101                	.insn	2, 0x0101
     87e:	025c                	.insn	2, 0x025c
     880:	7f88                	.insn	2, 0x7f88
     882:	0101                	.insn	2, 0x0101
     884:	025d                	.insn	2, 0x025d
     886:	0079                	.insn	2, 0x0079
     888:	0a00                	.insn	2, 0x0a00
     88a:	1904                	.insn	2, 0x1904
     88c:	8000                	.insn	2, 0x8000
     88e:	0101                	.insn	2, 0x0101
     890:	025a                	.insn	2, 0x025a
     892:	2008                	.insn	2, 0x2008
     894:	0101                	.insn	2, 0x0101
     896:	0082025b          	.insn	4, 0x0082025b
     89a:	0101                	.insn	2, 0x0101
     89c:	025c                	.insn	2, 0x025c
     89e:	0101008b          	.insn	4, 0x0101008b
     8a2:	025d                	.insn	2, 0x025d
     8a4:	0079                	.insn	2, 0x0079
     8a6:	0000                	.insn	2, 0x
     8a8:	8021                	.insn	2, 0x8021
     8aa:	000e                	.insn	2, 0x000e
     8ac:	6000                	.insn	2, 0x6000
     8ae:	0011                	.insn	2, 0x0011
     8b0:	0480                	.insn	2, 0x0480
     8b2:	0000                	.insn	2, 0x
     8b4:	b900                	.insn	2, 0xb900
     8b6:	0d02                	.insn	2, 0x0d02
     8b8:	082c                	.insn	2, 0x082c
     8ba:	0000                	.insn	2, 0x
     8bc:	000e900b          	.insn	4, 0x000e900b
     8c0:	0000                	.insn	2, 0x
     8c2:	5621                	.insn	2, 0x5621
     8c4:	000e                	.insn	2, 0x000e
     8c6:	2400                	.insn	2, 0x2400
     8c8:	0012                	.insn	2, 0x0012
     8ca:	3080                	.insn	2, 0x3080
     8cc:	0000                	.insn	2, 0x
     8ce:	ba00                	.insn	2, 0xba00
     8d0:	1502                	.insn	2, 0x1502
     8d2:	0864                	.insn	2, 0x0864
     8d4:	0000                	.insn	2, 0x
     8d6:	000e660b          	.insn	4, 0x000e660b
     8da:	0300                	.insn	2, 0x0300
     8dc:	0e71                	.insn	2, 0x0e71
     8de:	0000                	.insn	2, 0x
     8e0:	08b8                	.insn	2, 0x08b8
     8e2:	0000                	.insn	2, 0x
     8e4:	8022                	.insn	2, 0x8022
     8e6:	000e                	.insn	2, 0x000e
     8e8:	4400                	.insn	2, 0x4400
     8ea:	0012                	.insn	2, 0x0012
     8ec:	0480                	.insn	2, 0x0480
     8ee:	0000                	.insn	2, 0x
     8f0:	de00                	.insn	2, 0xde00
     8f2:	0b0c                	.insn	2, 0x0b0c
     8f4:	0e90                	.insn	2, 0x0e90
     8f6:	0000                	.insn	2, 0x
     8f8:	0000                	.insn	2, 0x
     8fa:	000e8027          	.insn	4, 0x000e8027
     8fe:	6c00                	.insn	2, 0x6c00
     900:	0012                	.insn	2, 0x0012
     902:	7080                	.insn	2, 0x7080
     904:	0001                	.insn	2, 0x0001
     906:	cb00                	.insn	2, 0xcb00
     908:	1102                	.insn	2, 0x1102
     90a:	087e                	.insn	2, 0x087e
     90c:	0000                	.insn	2, 0x
     90e:	000e900b          	.insn	4, 0x000e900b
     912:	0000                	.insn	2, 0x
     914:	5621                	.insn	2, 0x5621
     916:	000e                	.insn	2, 0x000e
     918:	8c00                	.insn	2, 0x8c00
     91a:	0016                	.insn	2, 0x0016
     91c:	3880                	.insn	2, 0x3880
     91e:	0000                	.insn	2, 0x
     920:	cc00                	.insn	2, 0xcc00
     922:	1d02                	.insn	2, 0x1d02
     924:	08b6                	.insn	2, 0x08b6
     926:	0000                	.insn	2, 0x
     928:	000e660b          	.insn	4, 0x000e660b
     92c:	0300                	.insn	2, 0x0300
     92e:	0e71                	.insn	2, 0x0e71
     930:	0000                	.insn	2, 0x
     932:	000008c7          	fmsub.s	fa7,ft0,ft0,ft0,rne
     936:	8022                	.insn	2, 0x8022
     938:	000e                	.insn	2, 0x000e
     93a:	ac00                	.insn	2, 0xac00
     93c:	0016                	.insn	2, 0x0016
     93e:	0480                	.insn	2, 0x0480
     940:	0000                	.insn	2, 0x
     942:	de00                	.insn	2, 0xde00
     944:	0b0c                	.insn	2, 0x0b0c
     946:	0e90                	.insn	2, 0x0e90
     948:	0000                	.insn	2, 0x
     94a:	0000                	.insn	2, 0x
     94c:	2409                	.insn	2, 0x2409
     94e:	0011                	.insn	2, 0x0011
     950:	d280                	.insn	2, 0xd280
     952:	0008                	.insn	2, 0x0008
     954:	0100                	.insn	2, 0x0100
     956:	5b01                	.insn	2, 0x5b01
     958:	8202                	.insn	2, 0x8202
     95a:	0100                	.insn	2, 0x0100
     95c:	5c01                	.insn	2, 0x5c01
     95e:	8b02                	.insn	2, 0x8b02
     960:	017f 5d01 7902 0000 	.insn	10, 0x0c09000079025d01017f
     968:	0c09 
     96a:	f3800013          	addi	zero,zero,-200
     96e:	0008                	.insn	2, 0x0008
     970:	0100                	.insn	2, 0x0100
     972:	5a01                	.insn	2, 0x5a01
     974:	3001                	.insn	2, 0x3001
     976:	0101                	.insn	2, 0x0101
     978:	0082025b          	.insn	4, 0x0082025b
     97c:	0101                	.insn	2, 0x0101
     97e:	025c                	.insn	2, 0x025c
     980:	0101008b          	.insn	4, 0x0101008b
     984:	025d                	.insn	2, 0x025d
     986:	0079                	.insn	2, 0x0079
     988:	1d00                	.insn	2, 0x1d00
     98a:	1414                	.insn	2, 0x1414
     98c:	8000                	.insn	2, 0x8000
     98e:	00000bb3          	add	s7,zero,zero
     992:	092a                	.insn	2, 0x092a
     994:	0000                	.insn	2, 0x
     996:	0101                	.insn	2, 0x0101
     998:	025a                	.insn	2, 0x025a
     99a:	01010083          	lb	ra,16(sp)
     99e:	0082025b          	.insn	4, 0x0082025b
     9a2:	0101                	.insn	2, 0x0101
     9a4:	025c                	.insn	2, 0x025c
     9a6:	0101008b          	.insn	4, 0x0101008b
     9aa:	025d                	.insn	2, 0x025d
     9ac:	0079                	.insn	2, 0x0079
     9ae:	0101                	.insn	2, 0x0101
     9b0:	015f 0130 6001      	.insn	6, 0x60010130015f
     9b6:	7802                	.insn	2, 0x7802
     9b8:	0100                	.insn	2, 0x0100
     9ba:	7202                	.insn	2, 0x7202
     9bc:	0100                	.insn	2, 0x0100
     9be:	0038                	.insn	2, 0x0038
     9c0:	641d                	.insn	2, 0x641d
     9c2:	0014                	.insn	2, 0x0014
     9c4:	a180                	.insn	2, 0xa180
     9c6:	0009                	.insn	2, 0x0009
     9c8:	5600                	.insn	2, 0x5600
     9ca:	0009                	.insn	2, 0x0009
     9cc:	0100                	.insn	2, 0x0100
     9ce:	5a01                	.insn	2, 0x5a01
     9d0:	8302                	.insn	2, 0x8302
     9d2:	0100                	.insn	2, 0x0100
     9d4:	5b01                	.insn	2, 0x5b01
     9d6:	8202                	.insn	2, 0x8202
     9d8:	0100                	.insn	2, 0x0100
     9da:	5c01                	.insn	2, 0x5c01
     9dc:	8b02                	.insn	2, 0x8b02
     9de:	0100                	.insn	2, 0x0100
     9e0:	5d01                	.insn	2, 0x5d01
     9e2:	7902                	.insn	2, 0x7902
     9e4:	0100                	.insn	2, 0x0100
     9e6:	6101                	.insn	2, 0x6101
     9e8:	8702                	.insn	2, 0x8702
     9ea:	0000                	.insn	2, 0x
     9ec:	a41d                	.insn	2, 0xa41d
     9ee:	0014                	.insn	2, 0x0014
     9f0:	aa80                	.insn	2, 0xaa80
     9f2:	000a                	.insn	2, 0x000a
     9f4:	8200                	.insn	2, 0x8200
     9f6:	0009                	.insn	2, 0x0009
     9f8:	0100                	.insn	2, 0x0100
     9fa:	5a01                	.insn	2, 0x5a01
     9fc:	8302                	.insn	2, 0x8302
     9fe:	0100                	.insn	2, 0x0100
     a00:	5b01                	.insn	2, 0x5b01
     a02:	8202                	.insn	2, 0x8202
     a04:	0100                	.insn	2, 0x0100
     a06:	5c01                	.insn	2, 0x5c01
     a08:	8b02                	.insn	2, 0x8b02
     a0a:	0100                	.insn	2, 0x0100
     a0c:	5d01                	.insn	2, 0x5d01
     a0e:	7902                	.insn	2, 0x7902
     a10:	0100                	.insn	2, 0x0100
     a12:	6101                	.insn	2, 0x6101
     a14:	8702                	.insn	2, 0x8702
     a16:	0000                	.insn	2, 0x
     a18:	c80a                	.insn	2, 0xc80a
     a1a:	0014                	.insn	2, 0x0014
     a1c:	0180                	.insn	2, 0x0180
     a1e:	5a01                	.insn	2, 0x5a01
     a20:	8602                	.insn	2, 0x8602
     a22:	0100                	.insn	2, 0x0100
     a24:	5b01                	.insn	2, 0x5b01
     a26:	8202                	.insn	2, 0x8202
     a28:	0100                	.insn	2, 0x0100
     a2a:	5c01                	.insn	2, 0x5c01
     a2c:	8b02                	.insn	2, 0x8b02
     a2e:	017f 5d01 7902 0000 	.insn	10, 0x2800000079025d01017f
     a36:	2800 
     a38:	0276                	.insn	2, 0x0276
     a3a:	0000                	.insn	2, 0x
     a3c:	01ff 00d7 0000 0a99 	.insn	10, 0x0a99000000d701ff
     a44:	0000 
     a46:	6f15                	.insn	2, 0x6f15
     a48:	7475                	.insn	2, 0x7475
     a4a:	ff00                	.insn	2, 0xff00
     a4c:	2201                	.insn	2, 0x2201
     a4e:	000000ef          	jal	ra,a4e <main-0x7ffff5b2>
     a52:	4005                	.insn	2, 0x4005
     a54:	0001                	.insn	2, 0x0001
     a56:	ff00                	.insn	2, 0xff00
     a58:	2d01                	.insn	2, 0x2d01
     a5a:	0090                	.insn	2, 0x0090
     a5c:	0000                	.insn	2, 0x
     a5e:	6915                	.insn	2, 0x6915
     a60:	7864                	.insn	2, 0x7864
     a62:	ff00                	.insn	2, 0xff00
     a64:	3c01                	.insn	2, 0x3c01
     a66:	000000d7          	.insn	4, 0x00d7
     a6a:	7105                	.insn	2, 0x7105
     a6c:	0001                	.insn	2, 0x0001
     a6e:	ff00                	.insn	2, 0xff00
     a70:	4801                	.insn	2, 0x4801
     a72:	000000d7          	.insn	4, 0x00d7
     a76:	1e05                	.insn	2, 0x1e05
     a78:	0001                	.insn	2, 0x0001
     a7a:	0000                	.insn	2, 0x
     a7c:	1c02                	.insn	2, 0x1c02
     a7e:	0034                	.insn	2, 0x0034
     a80:	0000                	.insn	2, 0x
     a82:	9305                	.insn	2, 0x9305
     a84:	0000                	.insn	2, 0x
     a86:	0000                	.insn	2, 0x
     a88:	3002                	.insn	2, 0x3002
     a8a:	002d                	.insn	2, 0x002d
     a8c:	0000                	.insn	2, 0x
     a8e:	5d05                	.insn	2, 0x5d05
     a90:	0002                	.insn	2, 0x0002
     a92:	0000                	.insn	2, 0x
     a94:	4302                	.insn	2, 0x4302
     a96:	002d                	.insn	2, 0x002d
     a98:	0000                	.insn	2, 0x
     a9a:	7c05                	.insn	2, 0x7c05
     a9c:	0002                	.insn	2, 0x0002
     a9e:	0100                	.insn	2, 0x0100
     aa0:	2202                	.insn	2, 0x2202
     aa2:	002d                	.insn	2, 0x002d
     aa4:	0000                	.insn	2, 0x
     aa6:	8208                	.insn	2, 0x8208
     aa8:	0002                	.insn	2, 0x0002
     aaa:	0800                	.insn	2, 0x0800
     aac:	1002                	.insn	2, 0x1002
     aae:	0aa5                	.insn	2, 0x0aa5
     ab0:	0000                	.insn	2, 0x
     ab2:	083e                	.insn	2, 0x083e
     ab4:	1501                	.insn	2, 0x1501
     ab6:	0502                	.insn	2, 0x0502
     ab8:	00000a3b          	.insn	4, 0x0a3b
     abc:	5532                	.insn	2, 0x5532
     abe:	1600                	.insn	2, 0x1600
     ac0:	1202                	.insn	2, 0x1202
     ac2:	00a1                	.insn	2, 0x00a1
     ac4:	0000                	.insn	2, 0x
     ac6:	4632                	.insn	2, 0x4632
     ac8:	1700                	.insn	2, 0x1700
     aca:	1002                	.insn	2, 0x1002
     acc:	0034                	.insn	2, 0x0034
     ace:	0000                	.insn	2, 0x
     ad0:	0800                	.insn	2, 0x0800
     ad2:	0106                	.insn	2, 0x0106
     ad4:	0000                	.insn	2, 0x
     ad6:	0218                	.insn	2, 0x0218
     ad8:	000a1c07          	.insn	4, 0x000a1c07
     adc:	0800                	.insn	2, 0x0800
     ade:	00000187          	.insn	4, 0x0187
     ae2:	3b09021b          	.insn	4, 0x3b09021b
     ae6:	0000                	.insn	2, 0x
     ae8:	0800                	.insn	2, 0x0800
     aea:	024a                	.insn	2, 0x024a
     aec:	0000                	.insn	2, 0x
     aee:	0220                	.insn	2, 0x0220
     af0:	3b09                	.insn	2, 0x3b09
     af2:	0000                	.insn	2, 0x
     af4:	1a00                	.insn	2, 0x1a00
     af6:	007a                	.insn	2, 0x007a
     af8:	0224                	.insn	2, 0x0224
     afa:	9912                	.insn	2, 0x9912
     afc:	000a                	.insn	2, 0x000a
     afe:	1a00                	.insn	2, 0x1a00
     b00:	327a                	.insn	2, 0x327a
     b02:	2500                	.insn	2, 0x2500
     b04:	1202                	.insn	2, 0x1202
     b06:	0a99                	.insn	2, 0x0a99
     b08:	0000                	.insn	2, 0x
     b0a:	9b08                	.insn	2, 0x9b08
     b0c:	0001                	.insn	2, 0x0001
     b0e:	3200                	.insn	2, 0x3200
     b10:	1202                	.insn	2, 0x1202
     b12:	002d                	.insn	2, 0x002d
     b14:	0000                	.insn	2, 0x
     b16:	5c08                	.insn	2, 0x5c08
     b18:	0002                	.insn	2, 0x0002
     b1a:	4a00                	.insn	2, 0x4a00
     b1c:	1202                	.insn	2, 0x1202
     b1e:	002d                	.insn	2, 0x002d
     b20:	0000                	.insn	2, 0x
     b22:	c908                	.insn	2, 0xc908
     b24:	0001                	.insn	2, 0x0001
     b26:	5e00                	.insn	2, 0x5e00
     b28:	1202                	.insn	2, 0x1202
     b2a:	000000e3          	beq	zero,zero,132a <main-0x7fffecd6>
     b2e:	0c00                	.insn	2, 0x0c00
     b30:	0034                	.insn	2, 0x0034
     b32:	0000                	.insn	2, 0x
     b34:	f2020107          	.insn	4, 0xf2020107
     b38:	0001                	.insn	2, 0x0001
     b3a:	0c00                	.insn	2, 0x0c00
     b3c:	0a9e                	.insn	2, 0x0a9e
     b3e:	0000                	.insn	2, 0x
     b40:	bd28                	.insn	2, 0xbd28
     b42:	0000                	.insn	2, 0x
     b44:	7e00                	.insn	2, 0x7e00
     b46:	d701                	.insn	2, 0xd701
     b48:	0000                	.insn	2, 0x
     b4a:	8e00                	.insn	2, 0x8e00
     b4c:	1500000b          	.insn	4, 0x1500000b
     b50:	0074756f          	jal	a0,48356 <main-0x7ffb7caa>
     b54:	017e                	.insn	2, 0x017e
     b56:	ef22                	.insn	2, 0xef22
     b58:	0000                	.insn	2, 0x
     b5a:	0500                	.insn	2, 0x0500
     b5c:	0140                	.insn	2, 0x0140
     b5e:	0000                	.insn	2, 0x
     b60:	017e                	.insn	2, 0x017e
     b62:	902d                	.insn	2, 0x902d
     b64:	0000                	.insn	2, 0x
     b66:	1500                	.insn	2, 0x1500
     b68:	6469                	.insn	2, 0x6469
     b6a:	0078                	.insn	2, 0x0078
     b6c:	017e                	.insn	2, 0x017e
     b6e:	d73c                	.insn	2, 0xd73c
     b70:	0000                	.insn	2, 0x
     b72:	0500                	.insn	2, 0x0500
     b74:	0171                	.insn	2, 0x0171
     b76:	0000                	.insn	2, 0x
     b78:	017e                	.insn	2, 0x017e
     b7a:	d748                	.insn	2, 0xd748
     b7c:	0000                	.insn	2, 0x
     b7e:	0500                	.insn	2, 0x0500
     b80:	011e                	.insn	2, 0x011e
     b82:	0000                	.insn	2, 0x
     b84:	017f 341c 0000 0500 	.insn	10, 0x009305000000341c017f
     b8c:	0093 
     b8e:	0000                	.insn	2, 0x
     b90:	017f 2d30 0000 0500 	.insn	10, 0x025d050000002d30017f
     b98:	025d 
     b9a:	0000                	.insn	2, 0x
     b9c:	017f 2d43 0000 0500 	.insn	10, 0x027c050000002d43017f
     ba4:	027c 
     ba6:	0000                	.insn	2, 0x
     ba8:	0180                	.insn	2, 0x0180
     baa:	2d22                	.insn	2, 0x2d22
     bac:	0000                	.insn	2, 0x
     bae:	1a00                	.insn	2, 0x1a00
     bb0:	7562                	.insn	2, 0x7562
     bb2:	0066                	.insn	2, 0x0066
     bb4:	0181                	.insn	2, 0x0181
     bb6:	8e0a                	.insn	2, 0x8e0a
     bb8:	1a00000b          	.insn	4, 0x1a00000b
     bbc:	656c                	.insn	2, 0x656c
     bbe:	006e                	.insn	2, 0x006e
     bc0:	0182                	.insn	2, 0x0182
     bc2:	d70c                	.insn	2, 0xd70c
     bc4:	0000                	.insn	2, 0x
     bc6:	0800                	.insn	2, 0x0800
     bc8:	00e4                	.insn	2, 0x00e4
     bca:	0000                	.insn	2, 0x
     bcc:	340c0183          	lb	gp,832(s8)
     bd0:	0000                	.insn	2, 0x
     bd2:	1c00                	.insn	2, 0x1c00
     bd4:	0206                	.insn	2, 0x0206
     bd6:	0000                	.insn	2, 0x
     bd8:	0186                	.insn	2, 0x0186
     bda:	ae19                	.insn	2, 0xae19
     bdc:	0500000b          	.insn	4, 0x0500000b
     be0:	001e5803          	lhu	a6,1(t3) # 81dd <main-0x7fff7e23>
     be4:	0880                	.insn	2, 0x0880
     be6:	0282                	.insn	2, 0x0282
     be8:	0000                	.insn	2, 0x
     bea:	01a0                	.insn	2, 0x01a0
     bec:	9e0a                	.insn	2, 0x9e0a
     bee:	000a                	.insn	2, 0x000a
     bf0:	0800                	.insn	2, 0x0800
     bf2:	0181                	.insn	2, 0x0181
     bf4:	0000                	.insn	2, 0x
     bf6:	01b0                	.insn	2, 0x01b0
     bf8:	3b09                	.insn	2, 0x3b09
     bfa:	0000                	.insn	2, 0x
     bfc:	1a00                	.insn	2, 0x1a00
     bfe:	6d74                	.insn	2, 0x6d74
     c00:	0070                	.insn	2, 0x0070
     c02:	01b1                	.insn	2, 0x01b1
     c04:	340c                	.insn	2, 0x340c
     c06:	0000                	.insn	2, 0x
     c08:	0800                	.insn	2, 0x0800
     c0a:	000001d3          	fadd.s	ft3,ft0,ft0,rne
     c0e:	01b2                	.insn	2, 0x01b2
     c10:	00005513          	srli	a0,zero,0x0
     c14:	3300                	.insn	2, 0x3300
     c16:	8d08                	.insn	2, 0x8d08
     c18:	0000                	.insn	2, 0x
     c1a:	ca00                	.insn	2, 0xca00
     c1c:	1601                	.insn	2, 0x1601
     c1e:	002d                	.insn	2, 0x002d
     c20:	0000                	.insn	2, 0x
     c22:	0000                	.insn	2, 0x
     c24:	9524                	.insn	2, 0x9524
     c26:	0000                	.insn	2, 0x
     c28:	9e00                	.insn	2, 0x9e00
     c2a:	2500000b          	.insn	4, 0x2500000b
     c2e:	002d                	.insn	2, 0x002d
     c30:	0000                	.insn	2, 0x
     c32:	001f 9924 000a      	.insn	6, 0x000a9924001f
     c38:	ae00                	.insn	2, 0xae00
     c3a:	2500000b          	.insn	4, 0x2500000b
     c3e:	002d                	.insn	2, 0x002d
     c40:	0000                	.insn	2, 0x
     c42:	0009                	.insn	2, 0x0009
     c44:	9e0c                	.insn	2, 0x9e0c
     c46:	3100000b          	.insn	4, 0x3100000b
     c4a:	000001b3          	add	gp,zero,zero
     c4e:	0139                	.insn	2, 0x0139
     c50:	0000d70f          	.insn	4, 0xd70f
     c54:	8800                	.insn	2, 0x8800
     c56:	0001                	.insn	2, 0x0001
     c58:	5080                	.insn	2, 0x5080
     c5a:	0005                	.insn	2, 0x0005
     c5c:	0100                	.insn	2, 0x0100
     c5e:	249c                	.insn	2, 0x249c
     c60:	000d                	.insn	2, 0x000d
     c62:	1200                	.insn	2, 0x1200
     c64:	0074756f          	jal	a0,4846a <main-0x7ffb7b96>
     c68:	0139                	.insn	2, 0x0139
     c6a:	0000ef27          	.insn	4, 0xef27
     c6e:	d800                	.insn	2, 0xd800
     c70:	0008                	.insn	2, 0x0008
     c72:	0400                	.insn	2, 0x0400
     c74:	0140                	.insn	2, 0x0140
     c76:	0000                	.insn	2, 0x
     c78:	0139                	.insn	2, 0x0139
     c7a:	9032                	.insn	2, 0x9032
     c7c:	0000                	.insn	2, 0x
     c7e:	f700                	.insn	2, 0xf700
     c80:	0008                	.insn	2, 0x0008
     c82:	1200                	.insn	2, 0x1200
     c84:	6469                	.insn	2, 0x6469
     c86:	0078                	.insn	2, 0x0078
     c88:	0139                	.insn	2, 0x0139
     c8a:	d741                	.insn	2, 0xd741
     c8c:	0000                	.insn	2, 0x
     c8e:	1600                	.insn	2, 0x1600
     c90:	0009                	.insn	2, 0x0009
     c92:	0400                	.insn	2, 0x0400
     c94:	0171                	.insn	2, 0x0171
     c96:	0000                	.insn	2, 0x
     c98:	013a                	.insn	2, 0x013a
     c9a:	d721                	.insn	2, 0xd721
     c9c:	0000                	.insn	2, 0x
     c9e:	3500                	.insn	2, 0x3500
     ca0:	0009                	.insn	2, 0x0009
     ca2:	0400                	.insn	2, 0x0400
     ca4:	011e                	.insn	2, 0x011e
     ca6:	0000                	.insn	2, 0x
     ca8:	013a                	.insn	2, 0x013a
     caa:	00005537          	lui	a0,0x5
     cae:	5400                	.insn	2, 0x5400
     cb0:	0009                	.insn	2, 0x0009
     cb2:	0400                	.insn	2, 0x0400
     cb4:	0282                	.insn	2, 0x0282
     cb6:	0000                	.insn	2, 0x
     cb8:	013a                	.insn	2, 0x013a
     cba:	000a9e43          	fmadd.s	ft8,fs5,ft0,ft0,rtz
     cbe:	3d00                	.insn	2, 0x3d00
     cc0:	000a                	.insn	2, 0x000a
     cc2:	0400                	.insn	2, 0x0400
     cc4:	0196                	.insn	2, 0x0196
     cc6:	0000                	.insn	2, 0x
     cc8:	5528013b          	.insn	4, 0x5528013b
     ccc:	0000                	.insn	2, 0x
     cce:	7800                	.insn	2, 0x7800
     cd0:	000a                	.insn	2, 0x000a
     cd2:	0400                	.insn	2, 0x0400
     cd4:	00000093          	addi	ra,zero,0
     cd8:	2d3b013b          	.insn	4, 0x2d3b013b
     cdc:	0000                	.insn	2, 0x
     cde:	9e00                	.insn	2, 0x9e00
     ce0:	000a                	.insn	2, 0x000a
     ce2:	0400                	.insn	2, 0x0400
     ce4:	025d                	.insn	2, 0x025d
     ce6:	0000                	.insn	2, 0x
     ce8:	013c                	.insn	2, 0x013c
     cea:	00002d27          	fsw	ft0,26(zero) # 1a <main-0x7fffffe6>
     cee:	d200                	.insn	2, 0xd200
     cf0:	000a                	.insn	2, 0x000a
     cf2:	0400                	.insn	2, 0x0400
     cf4:	027c                	.insn	2, 0x027c
     cf6:	0000                	.insn	2, 0x
     cf8:	013c                	.insn	2, 0x013c
     cfa:	00002d3b          	.insn	4, 0x2d3b
     cfe:	b500                	.insn	2, 0xb500
     d00:	0d00000b          	.insn	4, 0x0d00000b
     d04:	7562                	.insn	2, 0x7562
     d06:	0066                	.insn	2, 0x0066
     d08:	013d                	.insn	2, 0x013d
     d0a:	8e0a                	.insn	2, 0x8e0a
     d0c:	0200000b          	.insn	4, 0x0200000b
     d10:	4091                	.insn	2, 0x4091
     d12:	6c19                	.insn	2, 0x6c19
     d14:	6e65                	.insn	2, 0x6e65
     d16:	3e00                	.insn	2, 0x3e00
     d18:	0c01                	.insn	2, 0x0c01
     d1a:	000000d7          	.insn	4, 0x00d7
     d1e:	0c74                	.insn	2, 0x0c74
     d20:	0000                	.insn	2, 0x
     d22:	6114                	.insn	2, 0x6114
     d24:	0000                	.insn	2, 0x
     d26:	a600                	.insn	2, 0xa600
     d28:	000c                	.insn	2, 0x000c
     d2a:	1300                	.insn	2, 0x1300
     d2c:	0000028f          	.insn	4, 0x028f
     d30:	0148                	.insn	2, 0x0148
     d32:	9c18                	.insn	2, 0x9c18
     d34:	0000                	.insn	2, 0x
     d36:	f900                	.insn	2, 0xf900
     d38:	000c                	.insn	2, 0x000c
     d3a:	0000                	.insn	2, 0x
     d3c:	2426                	.insn	2, 0x2426
     d3e:	000d                	.insn	2, 0x000d
     d40:	d000                	.insn	2, 0xd000
     d42:	0001                	.insn	2, 0x0001
     d44:	1f80                	.insn	2, 0x1f80
     d46:	0000                	.insn	2, 0x
     d48:	5000                	.insn	2, 0x5000
     d4a:	0c01                	.insn	2, 0x0c01
     d4c:	3302                	.insn	2, 0x3302
     d4e:	000d                	.insn	2, 0x000d
     d50:	6400                	.insn	2, 0x6400
     d52:	000d                	.insn	2, 0x000d
     d54:	0200                	.insn	2, 0x0200
     d56:	00000d3f 00000d8a 	.insn	8, 0x0d8a00000d3f
     d5e:	4b02                	.insn	2, 0x4b02
     d60:	000d                	.insn	2, 0x000d
     d62:	b000                	.insn	2, 0xb000
     d64:	000d                	.insn	2, 0x000d
     d66:	0200                	.insn	2, 0x0200
     d68:	00000d57          	.insn	4, 0x0d57
     d6c:	0dd6                	.insn	2, 0x0dd6
     d6e:	0000                	.insn	2, 0x
     d70:	6302                	.insn	2, 0x6302
     d72:	000d                	.insn	2, 0x000d
     d74:	fc00                	.insn	2, 0xfc00
     d76:	000d                	.insn	2, 0x000d
     d78:	0200                	.insn	2, 0x0200
     d7a:	00000d6f          	jal	s10,d7a <main-0x7ffff286>
     d7e:	0e12                	.insn	2, 0x0e12
     d80:	0000                	.insn	2, 0x
     d82:	7b02                	.insn	2, 0x7b02
     d84:	000d                	.insn	2, 0x000d
     d86:	cb00                	.insn	2, 0xcb00
     d88:	0200000f          	fence	r,unknown
     d8c:	00000d87          	.insn	4, 0x0d87
     d90:	0fe1                	.insn	2, 0x0fe1
     d92:	0000                	.insn	2, 0x
     d94:	9302                	.insn	2, 0x9302
     d96:	000d                	.insn	2, 0x000d
     d98:	0700                	.insn	2, 0x0700
     d9a:	0010                	.insn	2, 0x0010
     d9c:	0200                	.insn	2, 0x0200
     d9e:	0d9f 0000 101d      	.insn	6, 0x101d00000d9f
     da4:	0000                	.insn	2, 0x
     da6:	ab02                	.insn	2, 0xab02
     da8:	000d                	.insn	2, 0x000d
     daa:	c600                	.insn	2, 0xc600
     dac:	0010                	.insn	2, 0x0010
     dae:	3f00                	.insn	2, 0x3f00
     db0:	03ec                	.insn	2, 0x03ec
     db2:	8000                	.insn	2, 0x8000
     db4:	0db8                	.insn	2, 0x0db8
     db6:	0000                	.insn	2, 0x
     db8:	0000                	.insn	2, 0x
     dba:	2828                	.insn	2, 0x2828
     dbc:	0002                	.insn	2, 0x0002
     dbe:	0100                	.insn	2, 0x0100
     dc0:	d701                	.insn	2, 0xd701
     dc2:	0000                	.insn	2, 0x
     dc4:	b800                	.insn	2, 0xb800
     dc6:	000d                	.insn	2, 0x000d
     dc8:	1500                	.insn	2, 0x1500
     dca:	0074756f          	jal	a0,485d0 <main-0x7ffb7a30>
     dce:	0101                	.insn	2, 0x0101
     dd0:	ef29                	.insn	2, 0xef29
     dd2:	0000                	.insn	2, 0x
     dd4:	0500                	.insn	2, 0x0500
     dd6:	0140                	.insn	2, 0x0140
     dd8:	0000                	.insn	2, 0x
     dda:	0101                	.insn	2, 0x0101
     ddc:	9034                	.insn	2, 0x9034
     dde:	0000                	.insn	2, 0x
     de0:	1500                	.insn	2, 0x1500
     de2:	6469                	.insn	2, 0x6469
     de4:	0078                	.insn	2, 0x0078
     de6:	0101                	.insn	2, 0x0101
     de8:	0000d743          	fmadd.s	fa4,ft1,ft0,ft0,unknown
     dec:	0500                	.insn	2, 0x0500
     dee:	0171                	.insn	2, 0x0171
     df0:	0000                	.insn	2, 0x
     df2:	0102                	.insn	2, 0x0102
     df4:	0000d723          	.insn	4, 0xd723
     df8:	1500                	.insn	2, 0x1500
     dfa:	7562                	.insn	2, 0x7562
     dfc:	0066                	.insn	2, 0x0066
     dfe:	0102                	.insn	2, 0x0102
     e00:	9031                	.insn	2, 0x9031
     e02:	0000                	.insn	2, 0x
     e04:	1500                	.insn	2, 0x1500
     e06:	656c                	.insn	2, 0x656c
     e08:	006e                	.insn	2, 0x006e
     e0a:	0102                	.insn	2, 0x0102
     e0c:	d73d                	.insn	2, 0xd73d
     e0e:	0000                	.insn	2, 0x
     e10:	0500                	.insn	2, 0x0500
     e12:	0282                	.insn	2, 0x0282
     e14:	0000                	.insn	2, 0x
     e16:	0102                	.insn	2, 0x0102
     e18:	000a9e47          	fmsub.s	ft8,fs5,ft0,ft0,rtz
     e1c:	0500                	.insn	2, 0x0500
     e1e:	0196                	.insn	2, 0x0196
     e20:	0000                	.insn	2, 0x
     e22:	2d290103          	lb	sp,722(s2)
     e26:	0000                	.insn	2, 0x
     e28:	0500                	.insn	2, 0x0500
     e2a:	00000093          	addi	ra,zero,0
     e2e:	2d3c0103          	lb	sp,723(s8)
     e32:	0000                	.insn	2, 0x
     e34:	0500                	.insn	2, 0x0500
     e36:	025d                	.insn	2, 0x025d
     e38:	0000                	.insn	2, 0x
     e3a:	0104                	.insn	2, 0x0104
     e3c:	2d29                	.insn	2, 0x2d29
     e3e:	0000                	.insn	2, 0x
     e40:	0500                	.insn	2, 0x0500
     e42:	027c                	.insn	2, 0x027c
     e44:	0000                	.insn	2, 0x
     e46:	0104                	.insn	2, 0x0104
     e48:	2d3d                	.insn	2, 0x2d3d
     e4a:	0000                	.insn	2, 0x
     e4c:	0000                	.insn	2, 0x
     e4e:	00017823          	.insn	4, 0x00017823
     e52:	e500                	.insn	2, 0xe500
     e54:	0000d70f          	.insn	4, 0xd70f
     e58:	0100                	.insn	2, 0x0100
     e5a:	0e56                	.insn	2, 0x0e56
     e5c:	0000                	.insn	2, 0x
     e5e:	6f0e                	.insn	2, 0x6f0e
     e60:	7475                	.insn	2, 0x7475
     e62:	e500                	.insn	2, 0xe500
     e64:	ef25                	.insn	2, 0xef25
     e66:	0000                	.insn	2, 0x
     e68:	0f00                	.insn	2, 0x0f00
     e6a:	0140                	.insn	2, 0x0140
     e6c:	0000                	.insn	2, 0x
     e6e:	30e5                	.insn	2, 0x30e5
     e70:	0090                	.insn	2, 0x0090
     e72:	0000                	.insn	2, 0x
     e74:	690e                	.insn	2, 0x690e
     e76:	7864                	.insn	2, 0x7864
     e78:	e500                	.insn	2, 0xe500
     e7a:	0000d73f 01710f00 	.insn	8, 0x01710f000000d73f
     e82:	0000                	.insn	2, 0x
     e84:	1fe6                	.insn	2, 0x1fe6
     e86:	000000d7          	.insn	4, 0x00d7
     e8a:	620e                	.insn	2, 0x620e
     e8c:	6675                	.insn	2, 0x6675
     e8e:	e600                	.insn	2, 0xe600
     e90:	00020a33          	add	s4,tp,zero
     e94:	0e00                	.insn	2, 0x0e00
     e96:	656c                	.insn	2, 0x656c
     e98:	006e                	.insn	2, 0x006e
     e9a:	3fe6                	.insn	2, 0x3fe6
     e9c:	000000d7          	.insn	4, 0x00d7
     ea0:	00025d0f          	.insn	4, 0x00025d0f
     ea4:	e700                	.insn	2, 0xe700
     ea6:	2d25                	.insn	2, 0x2d25
     ea8:	0000                	.insn	2, 0x
     eaa:	0f00                	.insn	2, 0x0f00
     eac:	027c                	.insn	2, 0x027c
     eae:	0000                	.insn	2, 0x
     eb0:	002d39e7          	.insn	4, 0x002d39e7
     eb4:	0000                	.insn	2, 0x
     eb6:	c940                	.insn	2, 0xc940
     eb8:	0001                	.insn	2, 0x0001
     eba:	0100                	.insn	2, 0x0100
     ebc:	12e8                	.insn	2, 0x12e8
     ebe:	000000e3          	beq	zero,zero,16be <main-0x7fffe942>
     ec2:	00692933          	slt	s2,s2,t1
     ec6:	15ec                	.insn	2, 0x15ec
     ec8:	000000d7          	.insn	4, 0x00d7
     ecc:	d40a                	.insn	2, 0xd40a
     ece:	0000                	.insn	2, 0x
     ed0:	0180                	.insn	2, 0x0180
     ed2:	5a01                	.insn	2, 0x5a01
     ed4:	0802                	.insn	2, 0x0802
     ed6:	0120                	.insn	2, 0x0120
     ed8:	5b01                	.insn	2, 0x5b01
     eda:	8402                	.insn	2, 0x8402
     edc:	0100                	.insn	2, 0x0100
     ede:	5c01                	.insn	2, 0x5c01
     ee0:	7902                	.insn	2, 0x7902
     ee2:	017f 5d01 8502 0000 	.insn	10, 0x85025d01017f
     eea:	0000 
     eec:	00013523          	.insn	4, 0x00013523
     ef0:	dc00                	.insn	2, 0xdc00
     ef2:	2d15                	.insn	2, 0x2d15
     ef4:	0000                	.insn	2, 0x
     ef6:	0100                	.insn	2, 0x0100
     ef8:	00000e7b          	.insn	4, 0x0e7b
     efc:	730e                	.insn	2, 0x730e
     efe:	7274                	.insn	2, 0x7274
     f00:	dc00                	.insn	2, 0xdc00
     f02:	7b28                	.insn	2, 0x7b28
     f04:	000e                	.insn	2, 0x000e
     f06:	2900                	.insn	2, 0x2900
     f08:	0069                	.insn	2, 0x0069
     f0a:	12dd                	.insn	2, 0x12dd
     f0c:	002d                	.insn	2, 0x002d
     f0e:	0000                	.insn	2, 0x
     f10:	1b00                	.insn	2, 0x1b00
     f12:	020a                	.insn	2, 0x020a
     f14:	0000                	.insn	2, 0x
     f16:	00028b23          	sb	zero,22(t0)
     f1a:	d900                	.insn	2, 0xd900
     f1c:	9e14                	.insn	2, 0x9e14
     f1e:	000a                	.insn	2, 0x000a
     f20:	0300                	.insn	2, 0x0300
     f22:	00000e9b          	.insn	4, 0x0e9b
     f26:	630e                	.insn	2, 0x630e
     f28:	0068                	.insn	2, 0x0068
     f2a:	23d9                	.insn	2, 0x23d9
     f2c:	0095                	.insn	2, 0x0095
     f2e:	0000                	.insn	2, 0x
     f30:	2300                	.insn	2, 0x2300
     f32:	0251                	.insn	2, 0x0251
     f34:	0000                	.insn	2, 0x
     f36:	1cd0                	.insn	2, 0x1cd0
     f38:	002d                	.insn	2, 0x002d
     f3a:	0000                	.insn	2, 0x
     f3c:	000ecb03          	lbu	s6,0(t4)
     f40:	0e00                	.insn	2, 0x0e00
     f42:	00727473          	csrrci	s0,0x7,4
     f46:	33d0                	.insn	2, 0x33d0
     f48:	020a                	.insn	2, 0x020a
     f4a:	0000                	.insn	2, 0x
     f4c:	0002950f          	.insn	4, 0x0002950f
     f50:	d000                	.insn	2, 0xd000
     f52:	0000d73f 00732900 	.insn	8, 0x007329000000d73f
     f5a:	11d1                	.insn	2, 0x11d1
     f5c:	020a                	.insn	2, 0x020a
     f5e:	0000                	.insn	2, 0x
     f60:	4100                	.insn	2, 0x4100
     f62:	012c                	.insn	2, 0x012c
     f64:	0000                	.insn	2, 0x
     f66:	c201                	.insn	2, 0xc201
     f68:	0314                	.insn	2, 0x0314
     f6a:	0f05                	.insn	2, 0x0f05
     f6c:	0000                	.insn	2, 0x
     f6e:	00010b0f          	.insn	4, 0x00010b0f
     f72:	c200                	.insn	2, 0xc200
     f74:	9522                	.insn	2, 0x9522
     f76:	0000                	.insn	2, 0x
     f78:	0f00                	.insn	2, 0x0f00
     f7a:	0140                	.insn	2, 0x0140
     f7c:	0000                	.insn	2, 0x
     f7e:	33c2                	.insn	2, 0x33c2
     f80:	008e                	.insn	2, 0x008e
     f82:	0000                	.insn	2, 0x
     f84:	690e                	.insn	2, 0x690e
     f86:	7864                	.insn	2, 0x7864
     f88:	c200                	.insn	2, 0xc200
     f8a:	d742                	.insn	2, 0xd742
     f8c:	0000                	.insn	2, 0x
     f8e:	0f00                	.insn	2, 0x0f00
     f90:	0171                	.insn	2, 0x0171
     f92:	0000                	.insn	2, 0x
     f94:	00d724c3          	fmadd.s	fs1,fa4,fa3,ft0,rdn
     f98:	0000                	.insn	2, 0x
     f9a:	2a00                	.insn	2, 0x2a00
     f9c:	000000c3          	fmadd.s	ft1,ft0,ft0,ft0,rne
     fa0:	004424b7          	lui	s1,0x442
     fa4:	8000                	.insn	2, 0x8000
     fa6:	0010                	.insn	2, 0x0010
     fa8:	0000                	.insn	2, 0x
     faa:	9c01                	.insn	2, 0x9c01
     fac:	0f68                	.insn	2, 0x0f68
     fae:	0000                	.insn	2, 0x
     fb0:	0b10                	.insn	2, 0x0b10
     fb2:	0001                	.insn	2, 0x0001
     fb4:	b700                	.insn	2, 0xb700
     fb6:	00009533          	sll	a0,ra,zero
     fba:	0100                	.insn	2, 0x0100
     fbc:	105a                	.insn	2, 0x105a
     fbe:	0140                	.insn	2, 0x0140
     fc0:	0000                	.insn	2, 0x
     fc2:	008e44b7          	lui	s1,0x8e4
     fc6:	0000                	.insn	2, 0x
     fc8:	5b01                	.insn	2, 0x5b01
     fca:	7864692b          	.insn	4, 0x7864692b
     fce:	b800                	.insn	2, 0xb800
     fd0:	d735                	.insn	2, 0xd735
     fd2:	0000                	.insn	2, 0x
     fd4:	0100                	.insn	2, 0x0100
     fd6:	105c                	.insn	2, 0x105c
     fd8:	0171                	.insn	2, 0x0171
     fda:	0000                	.insn	2, 0x
     fdc:	41b8                	.insn	2, 0x41b8
     fde:	000000d7          	.insn	4, 0x00d7
     fe2:	5d01                	.insn	2, 0x5d01
     fe4:	fe22                	.insn	2, 0xfe22
     fe6:	4800000f          	.insn	4, 0x4800000f
     fea:	0000                	.insn	2, 0x
     fec:	0880                	.insn	2, 0x0880
     fee:	0000                	.insn	2, 0x
     ff0:	bd00                	.insn	2, 0xbd00
     ff2:	0209                	.insn	2, 0x0209
     ff4:	0000100b          	.insn	4, 0x100b
     ff8:	1168                	.insn	2, 0x1168
     ffa:	0000                	.insn	2, 0x
     ffc:	0000                	.insn	2, 0x
     ffe:	8c2a                	.insn	2, 0x8c2a
    1000:	0001                	.insn	2, 0x0001
    1002:	ae00                	.insn	2, 0xae00
    1004:	4024                	.insn	2, 0x4024
    1006:	0000                	.insn	2, 0x
    1008:	0480                	.insn	2, 0x0480
    100a:	0000                	.insn	2, 0x
    100c:	0100                	.insn	2, 0x0100
    100e:	b29c                	.insn	2, 0xb29c
    1010:	1000000f          	.insn	4, 0x1000000f
    1014:	0000010b          	.insn	4, 0x010b
    1018:	33ae                	.insn	2, 0x33ae
    101a:	0095                	.insn	2, 0x0095
    101c:	0000                	.insn	2, 0x
    101e:	5a01                	.insn	2, 0x5a01
    1020:	4010                	.insn	2, 0x4010
    1022:	0001                	.insn	2, 0x0001
    1024:	ae00                	.insn	2, 0xae00
    1026:	8e44                	.insn	2, 0x8e44
    1028:	0000                	.insn	2, 0x
    102a:	0100                	.insn	2, 0x0100
    102c:	64692b5b          	.insn	4, 0x64692b5b
    1030:	0078                	.insn	2, 0x0078
    1032:	00d735af          	.insn	4, 0x00d735af
    1036:	0000                	.insn	2, 0x
    1038:	5c01                	.insn	2, 0x5c01
    103a:	7110                	.insn	2, 0x7110
    103c:	0001                	.insn	2, 0x0001
    103e:	af00                	.insn	2, 0xaf00
    1040:	d741                	.insn	2, 0xd741
    1042:	0000                	.insn	2, 0x
    1044:	0100                	.insn	2, 0x0100
    1046:	005d                	.insn	2, 0x005d
    1048:	3b2a                	.insn	2, 0x3b2a
    104a:	0001                	.insn	2, 0x0001
    104c:	a600                	.insn	2, 0xa600
    104e:	3014                	.insn	2, 0x3014
    1050:	0000                	.insn	2, 0x
    1052:	1080                	.insn	2, 0x1080
    1054:	0000                	.insn	2, 0x
    1056:	0100                	.insn	2, 0x0100
    1058:	fe9c                	.insn	2, 0xfe9c
    105a:	1000000f          	.insn	4, 0x1000000f
    105e:	0000010b          	.insn	4, 0x010b
    1062:	25a6                	.insn	2, 0x25a6
    1064:	0095                	.insn	2, 0x0095
    1066:	0000                	.insn	2, 0x
    1068:	5a01                	.insn	2, 0x5a01
    106a:	402c                	.insn	2, 0x402c
    106c:	0001                	.insn	2, 0x0001
    106e:	a600                	.insn	2, 0xa600
    1070:	8e36                	.insn	2, 0x8e36
    1072:	0000                	.insn	2, 0x
    1074:	6e00                	.insn	2, 0x6e00
    1076:	0011                	.insn	2, 0x0011
    1078:	2b00                	.insn	2, 0x2b00
    107a:	6469                	.insn	2, 0x6469
    107c:	0078                	.insn	2, 0x0078
    107e:	45a6                	.insn	2, 0x45a6
    1080:	000000d7          	.insn	4, 0x00d7
    1084:	5c01                	.insn	2, 0x5c01
    1086:	7110                	.insn	2, 0x7110
    1088:	0001                	.insn	2, 0x0001
    108a:	a700                	.insn	2, 0xa700
    108c:	0000d727          	.insn	4, 0xd727
    1090:	0100                	.insn	2, 0x0100
    1092:	005d                	.insn	2, 0x005d
    1094:	b442                	.insn	2, 0xb442
    1096:	0000                	.insn	2, 0x
    1098:	0100                	.insn	2, 0x0100
    109a:	069d                	.insn	2, 0x069d
    109c:	1701                	.insn	2, 0x1701
    109e:	0010                	.insn	2, 0x0010
    10a0:	0f00                	.insn	2, 0x0f00
    10a2:	0000010b          	.insn	4, 0x010b
    10a6:	149d                	.insn	2, 0x149d
    10a8:	0095                	.insn	2, 0x0095
    10aa:	0000                	.insn	2, 0x
    10ac:	4300                	.insn	2, 0x4300
    10ae:	0124                	.insn	2, 0x0124
    10b0:	0000                	.insn	2, 0x
    10b2:	4001                	.insn	2, 0x4001
    10b4:	3b05                	.insn	2, 0x3b05
    10b6:	0000                	.insn	2, 0x
    10b8:	d000                	.insn	2, 0xd000
    10ba:	001a                	.insn	2, 0x001a
    10bc:	3480                	.insn	2, 0x3480
    10be:	0000                	.insn	2, 0x
    10c0:	0100                	.insn	2, 0x0100
    10c2:	829c                	.insn	2, 0x829c
    10c4:	0010                	.insn	2, 0x0010
    10c6:	4400                	.insn	2, 0x4400
    10c8:	00727473          	csrrci	s0,0x7,4
    10cc:	4001                	.insn	2, 0x4001
    10ce:	0a19                	.insn	2, 0x0a19
    10d0:	0002                	.insn	2, 0x0002
    10d2:	8200                	.insn	2, 0x8200
    10d4:	0011                	.insn	2, 0x0011
    10d6:	1000                	.insn	2, 0x1000
    10d8:	0196                	.insn	2, 0x0196
    10da:	0000                	.insn	2, 0x
    10dc:	2240                	.insn	2, 0x2240
    10de:	0000003b          	.insn	4, 0x003b
    10e2:	5b01                	.insn	2, 0x5b01
    10e4:	9d45                	.insn	2, 0x9d45
    10e6:	0002                	.insn	2, 0x0002
    10e8:	0100                	.insn	2, 0x0100
    10ea:	0941                	.insn	2, 0x0941
    10ec:	0000003b          	.insn	4, 0x003b
    10f0:	11b1                	.insn	2, 0x11b1
    10f2:	0000                	.insn	2, 0x
    10f4:	692d                	.insn	2, 0x692d
    10f6:	4200                	.insn	2, 0x4200
    10f8:	3b09                	.insn	2, 0x3b09
    10fa:	0000                	.insn	2, 0x
    10fc:	d000                	.insn	2, 0xd000
    10fe:	0011                	.insn	2, 0x0011
    1100:	4600                	.insn	2, 0x4600
    1102:	10fc                	.insn	2, 0x10fc
    1104:	0000                	.insn	2, 0x
    1106:	1ae4                	.insn	2, 0x1ae4
    1108:	8000                	.insn	2, 0x8000
    110a:	01ff 0000 4401 0b22 	.insn	10, 0x110d0b224401000001ff
    1112:	110d 
    1114:	0000                	.insn	2, 0x
    1116:	0000                	.insn	2, 0x
    1118:	0000a947          	fmsub.s	fs2,ft1,ft0,ft0,rdn
    111c:	0100                	.insn	2, 0x0100
    111e:	1a300633          	.insn	4, 0x1a300633
    1122:	8000                	.insn	2, 0x8000
    1124:	00a0                	.insn	2, 0x00a0
    1126:	0000                	.insn	2, 0x
    1128:	9c01                	.insn	2, 0x9c01
    112a:	000010ef          	jal	ra,212a <main-0x7fffded6>
    112e:	402c                	.insn	2, 0x402c
    1130:	0001                	.insn	2, 0x0001
    1132:	3300                	.insn	2, 0x3300
    1134:	00009017          	auipc	zero,0x9
    1138:	0a00                	.insn	2, 0x0a00
    113a:	0012                	.insn	2, 0x0012
    113c:	2c00                	.insn	2, 0x2c00
    113e:	0298                	.insn	2, 0x0298
    1140:	0000                	.insn	2, 0x
    1142:	003b2333          	slt	t1,s6,gp
    1146:	0000                	.insn	2, 0x
    1148:	1229                	.insn	2, 0x1229
    114a:	0000                	.insn	2, 0x
    114c:	692d                	.insn	2, 0x692d
    114e:	3400                	.insn	2, 0x3400
    1150:	3b09                	.insn	2, 0x3b09
    1152:	0000                	.insn	2, 0x
    1154:	4800                	.insn	2, 0x4800
    1156:	0012                	.insn	2, 0x0012
    1158:	2d00                	.insn	2, 0x2d00
    115a:	0a350063          	beq	a0,gp,11fa <main-0x7fffee06>
    115e:	0095                	.insn	2, 0x0095
    1160:	0000                	.insn	2, 0x
    1162:	1266                	.insn	2, 0x1266
    1164:	0000                	.insn	2, 0x
    1166:	ef34                	.insn	2, 0xef34
    1168:	0010                	.insn	2, 0x0010
    116a:	3000                	.insn	2, 0x3000
    116c:	001a                	.insn	2, 0x001a
    116e:	da80                	.insn	2, 0xda80
    1170:	0001                	.insn	2, 0x0001
    1172:	3500                	.insn	2, 0x3500
    1174:	340e                	.insn	2, 0x340e
    1176:	000010ef          	jal	ra,2176 <main-0x7fffde8a>
    117a:	1a58                	.insn	2, 0x1a58
    117c:	8000                	.insn	2, 0x8000
    117e:	01e5                	.insn	2, 0x01e5
    1180:	0000                	.insn	2, 0x
    1182:	48000d3b          	.insn	4, 0x48000d3b
    1186:	00000147          	fmsub.s	ft2,ft0,ft0,ft0,rne
    118a:	2d01                	.insn	2, 0x2d01
    118c:	9506                	.insn	2, 0x9506
    118e:	0000                	.insn	2, 0x
    1190:	0100                	.insn	2, 0x0100
    1192:	6d49                	.insn	2, 0x6d49
    1194:	0002                	.insn	2, 0x0002
    1196:	0100                	.insn	2, 0x0100
    1198:	003b052b          	.insn	4, 0x003b052b
    119c:	0000                	.insn	2, 0x
    119e:	1701                	.insn	2, 0x1701
    11a0:	0011                	.insn	2, 0x0011
    11a2:	0e00                	.insn	2, 0x0e00
    11a4:	132b0063          	beq	s6,s2,12c4 <main-0x7fffed3c>
    11a8:	0095                	.insn	2, 0x0095
    11aa:	0000                	.insn	2, 0x
    11ac:	1e00                	.insn	2, 0x1e00
    11ae:	0db8                	.insn	2, 0x0db8
    11b0:	0000                	.insn	2, 0x
    11b2:	0054                	.insn	2, 0x0054
    11b4:	8000                	.insn	2, 0x8000
    11b6:	0134                	.insn	2, 0x0134
    11b8:	0000                	.insn	2, 0x
    11ba:	9c01                	.insn	2, 0x9c01
    11bc:	11d5                	.insn	2, 0x11d5
    11be:	0000                	.insn	2, 0x
    11c0:	c802                	.insn	2, 0xc802
    11c2:	000d                	.insn	2, 0x000d
    11c4:	7c00                	.insn	2, 0x7c00
    11c6:	0012                	.insn	2, 0x0012
    11c8:	0200                	.insn	2, 0x0200
    11ca:	00000dd3          	fadd.s	fs11,ft0,ft0,rne
    11ce:	12a1                	.insn	2, 0x12a1
    11d0:	0000                	.insn	2, 0x
    11d2:	de02                	.insn	2, 0xde02
    11d4:	000d                	.insn	2, 0x000d
    11d6:	c600                	.insn	2, 0xc600
    11d8:	0012                	.insn	2, 0x0012
    11da:	0200                	.insn	2, 0x0200
    11dc:	0de9                	.insn	2, 0x0de9
    11de:	0000                	.insn	2, 0x
    11e0:	1300                	.insn	2, 0x1300
    11e2:	0000                	.insn	2, 0x
    11e4:	f402                	.insn	2, 0xf402
    11e6:	000d                	.insn	2, 0x000d
    11e8:	2500                	.insn	2, 0x2500
    11ea:	02000013          	addi	zero,zero,32
    11ee:	0dff 0000 134a 0000 	.insn	10, 0x0a020000134a00000dff
    11f6:	0a02 
    11f8:	000e                	.insn	2, 0x000e
    11fa:	6600                	.insn	2, 0x6600
    11fc:	02000013          	addi	zero,zero,32
    1200:	0e15                	.insn	2, 0x0e15
    1202:	0000                	.insn	2, 0x
    1204:	0000138b          	.insn	4, 0x138b
    1208:	000e2003          	lw	zero,0(t3)
    120c:	ae00                	.insn	2, 0xae00
    120e:	4a000013          	addi	zero,zero,1184
    1212:	0e2c                	.insn	2, 0x0e2c
    1214:	0000                	.insn	2, 0x
    1216:	00ac                	.insn	2, 0x00ac
    1218:	8000                	.insn	2, 0x8000
    121a:	002c                	.insn	2, 0x002c
    121c:	0000                	.insn	2, 0x
    121e:	1196                	.insn	2, 0x1196
    1220:	0000                	.insn	2, 0x
    1222:	000e2d03          	lw	s10,0(t3)
    1226:	da00                	.insn	2, 0xda00
    1228:	00000013          	addi	zero,zero,0
    122c:	0009                	.insn	2, 0x0009
    122e:	0001                	.insn	2, 0x0001
    1230:	b680                	.insn	2, 0xb680
    1232:	0011                	.insn	2, 0x0011
    1234:	0100                	.insn	2, 0x0100
    1236:	5b01                	.insn	2, 0x5b01
    1238:	8402                	.insn	2, 0x8402
    123a:	0100                	.insn	2, 0x0100
    123c:	5c01                	.insn	2, 0x5c01
    123e:	7806                	.insn	2, 0x7806
    1240:	2000                	.insn	2, 0x2000
    1242:	0079                	.insn	2, 0x0079
    1244:	0122                	.insn	2, 0x0122
    1246:	5d01                	.insn	2, 0x5d01
    1248:	8502                	.insn	2, 0x8502
    124a:	0000                	.insn	2, 0x
    124c:	300a                	.insn	2, 0x300a
    124e:	0001                	.insn	2, 0x0001
    1250:	0180                	.insn	2, 0x0180
    1252:	5a01                	.insn	2, 0x5a01
    1254:	0802                	.insn	2, 0x0802
    1256:	0120                	.insn	2, 0x0120
    1258:	5b01                	.insn	2, 0x5b01
    125a:	8402                	.insn	2, 0x8402
    125c:	0100                	.insn	2, 0x0100
    125e:	5c01                	.insn	2, 0x5c01
    1260:	7902                	.insn	2, 0x7902
    1262:	017f 5d01 8502 0000 	.insn	10, 0x1e00000085025d01017f
    126a:	1e00 
    126c:	00000ecb          	fnmsub.s	ft9,ft0,ft0,ft0,rne
    1270:	06d8                	.insn	2, 0x06d8
    1272:	8000                	.insn	2, 0x8000
    1274:	0014                	.insn	2, 0x0014
    1276:	0000                	.insn	2, 0x
    1278:	9c01                	.insn	2, 0x9c01
    127a:	1250                	.insn	2, 0x1250
    127c:	0000                	.insn	2, 0x
    127e:	d802                	.insn	2, 0xd802
    1280:	000e                	.insn	2, 0x000e
    1282:	1700                	.insn	2, 0x1700
    1284:	0014                	.insn	2, 0x0014
    1286:	0200                	.insn	2, 0x0200
    1288:	00000ee3          	beq	zero,zero,1aa4 <main-0x7fffe55c>
    128c:	1436                	.insn	2, 0x1436
    128e:	0000                	.insn	2, 0x
    1290:	ee02                	.insn	2, 0xee02
    1292:	000e                	.insn	2, 0x000e
    1294:	5500                	.insn	2, 0x5500
    1296:	0014                	.insn	2, 0x0014
    1298:	0200                	.insn	2, 0x0200
    129a:	0ef9                	.insn	2, 0x0ef9
    129c:	0000                	.insn	2, 0x
    129e:	1474                	.insn	2, 0x1474
    12a0:	0000                	.insn	2, 0x
    12a2:	cb22                	.insn	2, 0xcb22
    12a4:	000e                	.insn	2, 0x000e
    12a6:	dc00                	.insn	2, 0xdc00
    12a8:	0006                	.insn	2, 0x0006
    12aa:	0c80                	.insn	2, 0x0c80
    12ac:	0000                	.insn	2, 0x
    12ae:	c200                	.insn	2, 0xc200
    12b0:	0214                	.insn	2, 0x0214
    12b2:	0eee                	.insn	2, 0x0eee
    12b4:	0000                	.insn	2, 0x
    12b6:	00001493          	slli	s1,zero,0x0
    12ba:	f902                	.insn	2, 0xf902
    12bc:	000e                	.insn	2, 0x000e
    12be:	ab00                	.insn	2, 0xab00
    12c0:	0014                	.insn	2, 0x0014
    12c2:	0b00                	.insn	2, 0x0b00
    12c4:	0ed8                	.insn	2, 0x0ed8
    12c6:	0000                	.insn	2, 0x
    12c8:	e302                	.insn	2, 0xe302
    12ca:	000e                	.insn	2, 0x000e
    12cc:	c300                	.insn	2, 0xc300
    12ce:	0014                	.insn	2, 0x0014
    12d0:	4b00                	.insn	2, 0x4b00
    12d2:	06e8                	.insn	2, 0x06e8
    12d4:	8000                	.insn	2, 0x8000
    12d6:	0101                	.insn	2, 0x0101
    12d8:	095a                	.insn	2, 0x095a
    12da:	0aa503a3          	sb	a0,167(a0) # 50a7 <main-0x7fffaf59>
    12de:	a826                	.insn	2, 0xa826
    12e0:	a842                	.insn	2, 0xa842
    12e2:	0000                	.insn	2, 0x
    12e4:	0000                	.insn	2, 0x
    12e6:	aa1e                	.insn	2, 0xaa1e
    12e8:	000a                	.insn	2, 0x000a
    12ea:	ec00                	.insn	2, 0xec00
    12ec:	0006                	.insn	2, 0x0006
    12ee:	8880                	.insn	2, 0x8880
    12f0:	0005                	.insn	2, 0x0005
    12f2:	0100                	.insn	2, 0x0100
    12f4:	109c                	.insn	2, 0x109c
    12f6:	0016                	.insn	2, 0x0016
    12f8:	0200                	.insn	2, 0x0200
    12fa:	0ab9                	.insn	2, 0x0ab9
    12fc:	0000                	.insn	2, 0x
    12fe:	000014db          	.insn	4, 0x14db
    1302:	c502                	.insn	2, 0xc502
    1304:	000a                	.insn	2, 0x000a
    1306:	3d00                	.insn	2, 0x3d00
    1308:	0015                	.insn	2, 0x0015
    130a:	0200                	.insn	2, 0x0200
    130c:	0ad1                	.insn	2, 0x0ad1
    130e:	0000                	.insn	2, 0x
    1310:	159f 0000 dd02      	.insn	6, 0xdd020000159f
    1316:	000a                	.insn	2, 0x000a
    1318:	2400                	.insn	2, 0x2400
    131a:	0016                	.insn	2, 0x0016
    131c:	0200                	.insn	2, 0x0200
    131e:	0ae9                	.insn	2, 0x0ae9
    1320:	0000                	.insn	2, 0x
    1322:	16a9                	.insn	2, 0x16a9
    1324:	0000                	.insn	2, 0x
    1326:	f502                	.insn	2, 0xf502
    1328:	000a                	.insn	2, 0x000a
    132a:	3a00                	.insn	2, 0x3a00
    132c:	02000017          	auipc	zero,0x2000
    1330:	0b01                	.insn	2, 0x0b01
    1332:	0000                	.insn	2, 0x
    1334:	17ae                	.insn	2, 0x17ae
    1336:	0000                	.insn	2, 0x
    1338:	0d02                	.insn	2, 0x0d02
    133a:	aa00000b          	.insn	4, 0xaa00000b
    133e:	0018                	.insn	2, 0x0018
    1340:	0600                	.insn	2, 0x0600
    1342:	0b19                	.insn	2, 0x0b19
    1344:	0000                	.insn	2, 0x
    1346:	254c                	.insn	2, 0x254c
    1348:	0000000b          	.insn	4, 0x000b
    134c:	314d                	.insn	2, 0x314d
    134e:	0800000b          	.insn	4, 0x0800000b
	...
    135a:	4f06                	.insn	2, 0x4f06
    135c:	0600000b          	.insn	4, 0x0600000b
    1360:	00000b5b          	.insn	4, 0x0b5b
    1364:	6706                	.insn	2, 0x6706
    1366:	0600000b          	.insn	4, 0x0600000b
    136a:	00000b73          	.insn	4, 0x0b73
    136e:	000aaa27          	fsw	ft0,20(s5)
    1372:	4800                	.insn	2, 0x4800
    1374:	71800007          	.insn	4, 0x71800007
    1378:	0000                	.insn	2, 0x
    137a:	7e00                	.insn	2, 0x7e00
    137c:	0f01                	.insn	2, 0x0f01
    137e:	1464                	.insn	2, 0x1464
    1380:	0000                	.insn	2, 0x
    1382:	b902                	.insn	2, 0xb902
    1384:	000a                	.insn	2, 0x000a
    1386:	0600                	.insn	2, 0x0600
    1388:	0019                	.insn	2, 0x0019
    138a:	0200                	.insn	2, 0x0200
    138c:	0ac5                	.insn	2, 0x0ac5
    138e:	0000                	.insn	2, 0x
    1390:	1958                	.insn	2, 0x1958
    1392:	0000                	.insn	2, 0x
    1394:	d102                	.insn	2, 0xd102
    1396:	000a                	.insn	2, 0x000a
    1398:	aa00                	.insn	2, 0xaa00
    139a:	0019                	.insn	2, 0x0019
    139c:	0200                	.insn	2, 0x0200
    139e:	0add                	.insn	2, 0x0add
    13a0:	0000                	.insn	2, 0x
    13a2:	1a11                	.insn	2, 0x1a11
    13a4:	0000                	.insn	2, 0x
    13a6:	e902                	.insn	2, 0xe902
    13a8:	000a                	.insn	2, 0x000a
    13aa:	7800                	.insn	2, 0x7800
    13ac:	001a                	.insn	2, 0x001a
    13ae:	0200                	.insn	2, 0x0200
    13b0:	0af5                	.insn	2, 0x0af5
    13b2:	0000                	.insn	2, 0x
    13b4:	00001ab3          	sll	s5,zero,zero
    13b8:	0102                	.insn	2, 0x0102
    13ba:	f700000b          	.insn	4, 0xf700000b
    13be:	001a                	.insn	2, 0x001a
    13c0:	0200                	.insn	2, 0x0200
    13c2:	0b0d                	.insn	2, 0x0b0d
    13c4:	0000                	.insn	2, 0x
    13c6:	1b5e                	.insn	2, 0x1b5e
    13c8:	0000                	.insn	2, 0x
    13ca:	7120                	.insn	2, 0x7120
    13cc:	0000                	.insn	2, 0x
    13ce:	3500                	.insn	2, 0x3500
    13d0:	0b19                	.insn	2, 0x0b19
    13d2:	0000                	.insn	2, 0x
    13d4:	7fb09103          	lh	sp,2043(ra)
    13d8:	000b2503          	lw	a0,0(s6)
    13dc:	a300                	.insn	2, 0xa300
    13de:	0300001b          	.insn	4, 0x0300001b
    13e2:	0b31                	.insn	2, 0x0b31
    13e4:	0000                	.insn	2, 0x
    13e6:	00001c53          	fadd.s	fs8,ft0,ft0,rtz
    13ea:	000b4f03          	lbu	t5,0(s6)
    13ee:	f300                	.insn	2, 0xf300
    13f0:	001c                	.insn	2, 0x001c
    13f2:	0300                	.insn	2, 0x0300
    13f4:	00000b5b          	.insn	4, 0x0b5b
    13f8:	1d19                	.insn	2, 0x1d19
    13fa:	0000                	.insn	2, 0x
    13fc:	000b6703          	.insn	4, 0x000b6703
    1400:	5b00                	.insn	2, 0x5b00
    1402:	001d                	.insn	2, 0x001d
    1404:	0300                	.insn	2, 0x0300
    1406:	00000b73          	.insn	4, 0x0b73
    140a:	1e06                	.insn	2, 0x1e06
    140c:	0000                	.insn	2, 0x
    140e:	7f2e                	.insn	2, 0x7f2e
    1410:	a900000b          	.insn	4, 0xa900000b
    1414:	0000                	.insn	2, 0x
    1416:	8f00                	.insn	2, 0x8f00
    1418:	03000013          	addi	zero,zero,48
    141c:	0b80                	.insn	2, 0x0b80
    141e:	0000                	.insn	2, 0x
    1420:	1e42                	.insn	2, 0x1e42
    1422:	0000                	.insn	2, 0x
    1424:	3600                	.insn	2, 0x3600
    1426:	08b0                	.insn	2, 0x08b0
    1428:	8000                	.insn	2, 0x8000
    142a:	0db8                	.insn	2, 0x0db8
    142c:	0000                	.insn	2, 0x
    142e:	13e5                	.insn	2, 0x13e5
    1430:	0000                	.insn	2, 0x
    1432:	0101                	.insn	2, 0x0101
    1434:	095a                	.insn	2, 0x095a
    1436:	0aa503a3          	sb	a0,167(a0)
    143a:	a826                	.insn	2, 0xa826
    143c:	a82d                	.insn	2, 0xa82d
    143e:	0100                	.insn	2, 0x0100
    1440:	5b01                	.insn	2, 0x5b01
    1442:	a309                	.insn	2, 0xa309
    1444:	260ba503          	lw	a0,608(s7)
    1448:	2da8                	.insn	2, 0x2da8
    144a:	00a8                	.insn	2, 0x00a8
    144c:	0101                	.insn	2, 0x0101
    144e:	095c                	.insn	2, 0x095c
    1450:	0ca503a3          	sb	a0,199(a0)
    1454:	a826                	.insn	2, 0xa826
    1456:	a82d                	.insn	2, 0xa82d
    1458:	0100                	.insn	2, 0x0100
    145a:	5d01                	.insn	2, 0x5d01
    145c:	a309                	.insn	2, 0xa309
    145e:	260da503          	lw	a0,608(s11)
    1462:	2da8                	.insn	2, 0x2da8
    1464:	00a8                	.insn	2, 0x00a8
    1466:	0101                	.insn	2, 0x0101
    1468:	0960                	.insn	2, 0x0960
    146a:	11a503a3          	sb	s10,263(a0)
    146e:	a826                	.insn	2, 0xa826
    1470:	a82d                	.insn	2, 0xa82d
    1472:	0100                	.insn	2, 0x0100
    1474:	6101                	.insn	2, 0x6101
    1476:	06007203          	.insn	4, 0x06007203
    147a:	3600                	.insn	2, 0x3600
    147c:	09fc                	.insn	2, 0x09fc
    147e:	8000                	.insn	2, 0x8000
    1480:	09a1                	.insn	2, 0x09a1
    1482:	0000                	.insn	2, 0x
    1484:	1434                	.insn	2, 0x1434
    1486:	0000                	.insn	2, 0x
    1488:	0101                	.insn	2, 0x0101
    148a:	095a                	.insn	2, 0x095a
    148c:	0aa503a3          	sb	a0,167(a0)
    1490:	a826                	.insn	2, 0xa826
    1492:	a82d                	.insn	2, 0xa82d
    1494:	0100                	.insn	2, 0x0100
    1496:	5b01                	.insn	2, 0x5b01
    1498:	a309                	.insn	2, 0xa309
    149a:	260ba503          	lw	a0,608(s7)
    149e:	2da8                	.insn	2, 0x2da8
    14a0:	00a8                	.insn	2, 0x00a8
    14a2:	0101                	.insn	2, 0x0101
    14a4:	095c                	.insn	2, 0x095c
    14a6:	0ca503a3          	sb	a0,199(a0)
    14aa:	a826                	.insn	2, 0xa826
    14ac:	a82d                	.insn	2, 0xa82d
    14ae:	0100                	.insn	2, 0x0100
    14b0:	5d01                	.insn	2, 0x5d01
    14b2:	a309                	.insn	2, 0xa309
    14b4:	260da503          	lw	a0,608(s11)
    14b8:	2da8                	.insn	2, 0x2da8
    14ba:	00a8                	.insn	2, 0x00a8
    14bc:	0101                	.insn	2, 0x0101
    14be:	0961                	.insn	2, 0x0961
    14c0:	11a503a3          	sb	s10,263(a0)
    14c4:	a826                	.insn	2, 0xa826
    14c6:	a82d                	.insn	2, 0xa82d
    14c8:	0000                	.insn	2, 0x
    14ca:	b416                	.insn	2, 0xb416
    14cc:	b880000b          	.insn	4, 0xb880000b
    14d0:	000d                	.insn	2, 0x000d
    14d2:	0100                	.insn	2, 0x0100
    14d4:	5a01                	.insn	2, 0x5a01
    14d6:	7802                	.insn	2, 0x7802
    14d8:	0100                	.insn	2, 0x0100
    14da:	5b01                	.insn	2, 0x5b01
    14dc:	7902                	.insn	2, 0x7902
    14de:	0100                	.insn	2, 0x0100
    14e0:	5c01                	.insn	2, 0x5c01
    14e2:	8402                	.insn	2, 0x8402
    14e4:	0100                	.insn	2, 0x0100
    14e6:	5d01                	.insn	2, 0x5d01
    14e8:	8202                	.insn	2, 0x8202
    14ea:	0100                	.insn	2, 0x0100
    14ec:	6001                	.insn	2, 0x6001
    14ee:	8302                	.insn	2, 0x8302
    14f0:	0100                	.insn	2, 0x0100
    14f2:	6101                	.insn	2, 0x6101
    14f4:	8502                	.insn	2, 0x8502
    14f6:	0000                	.insn	2, 0x
    14f8:	0000                	.insn	2, 0x
    14fa:	b821                	.insn	2, 0xb821
    14fc:	000d                	.insn	2, 0x000d
    14fe:	bc00                	.insn	2, 0xbc00
    1500:	0008                	.insn	2, 0x0008
    1502:	ac80                	.insn	2, 0xac80
    1504:	0000                	.insn	2, 0x
    1506:	8c00                	.insn	2, 0x8c00
    1508:	1001                	.insn	2, 0x1001
    150a:	1539                	.insn	2, 0x1539
    150c:	0000                	.insn	2, 0x
    150e:	f402                	.insn	2, 0xf402
    1510:	000d                	.insn	2, 0x000d
    1512:	5a00                	.insn	2, 0x5a00
    1514:	001e                	.insn	2, 0x001e
    1516:	0200                	.insn	2, 0x0200
    1518:	0dff 0000 1e67 0000 	.insn	10, 0xc80200001e6700000dff
    1520:	c802 
    1522:	000d                	.insn	2, 0x000d
    1524:	8e00                	.insn	2, 0x8e00
    1526:	001e                	.insn	2, 0x001e
    1528:	0200                	.insn	2, 0x0200
    152a:	00000dd3          	fadd.s	fs11,ft0,ft0,rne
    152e:	1e96                	.insn	2, 0x1e96
    1530:	0000                	.insn	2, 0x
    1532:	de02                	.insn	2, 0xde02
    1534:	000d                	.insn	2, 0x000d
    1536:	9e00                	.insn	2, 0x9e00
    1538:	001e                	.insn	2, 0x001e
    153a:	0200                	.insn	2, 0x0200
    153c:	0de9                	.insn	2, 0x0de9
    153e:	0000                	.insn	2, 0x
    1540:	1ec2                	.insn	2, 0x1ec2
    1542:	0000                	.insn	2, 0x
    1544:	0a02                	.insn	2, 0x0a02
    1546:	000e                	.insn	2, 0x000e
    1548:	d100                	.insn	2, 0xd100
    154a:	001e                	.insn	2, 0x001e
    154c:	0200                	.insn	2, 0x0200
    154e:	0e15                	.insn	2, 0x0e15
    1550:	0000                	.insn	2, 0x
    1552:	1ee0                	.insn	2, 0x1ee0
    1554:	0000                	.insn	2, 0x
    1556:	000e2003          	lw	zero,0(t3)
    155a:	f000                	.insn	2, 0xf000
    155c:	001e                	.insn	2, 0x001e
    155e:	2e00                	.insn	2, 0x2e00
    1560:	0e2c                	.insn	2, 0x0e2c
    1562:	0000                	.insn	2, 0x
    1564:	00b4                	.insn	2, 0x00b4
    1566:	0000                	.insn	2, 0x
    1568:	14fe                	.insn	2, 0x14fe
    156a:	0000                	.insn	2, 0x
    156c:	000e2d03          	lw	s10,0(t3)
    1570:	ff00                	.insn	2, 0xff00
    1572:	001e                	.insn	2, 0x001e
    1574:	0a00                	.insn	2, 0x0a00
    1576:	08f4                	.insn	2, 0x08f4
    1578:	8000                	.insn	2, 0x8000
    157a:	0101                	.insn	2, 0x0101
    157c:	025a                	.insn	2, 0x025a
    157e:	2008                	.insn	2, 0x2008
    1580:	0101                	.insn	2, 0x0101
    1582:	0079025b          	.insn	4, 0x0079025b
    1586:	0101                	.insn	2, 0x0101
    1588:	025c                	.insn	2, 0x025c
    158a:	01017f87          	.insn	4, 0x01017f87
    158e:	025d                	.insn	2, 0x025d
    1590:	0082                	.insn	2, 0x0082
    1592:	0000                	.insn	2, 0x
    1594:	2409                	.insn	2, 0x2409
    1596:	0009                	.insn	2, 0x0009
    1598:	1a80                	.insn	2, 0x1a80
    159a:	0015                	.insn	2, 0x0015
    159c:	0100                	.insn	2, 0x0100
    159e:	5b01                	.insn	2, 0x5b01
    15a0:	7902                	.insn	2, 0x7902
    15a2:	0100                	.insn	2, 0x0100
    15a4:	5c01                	.insn	2, 0x5c01
    15a6:	8802                	.insn	2, 0x8802
    15a8:	017f 5d01 8202 0000 	.insn	10, 0x540a000082025d01017f
    15b0:	540a 
    15b2:	0009                	.insn	2, 0x0009
    15b4:	0180                	.insn	2, 0x0180
    15b6:	5a01                	.insn	2, 0x5a01
    15b8:	0802                	.insn	2, 0x0802
    15ba:	0120                	.insn	2, 0x0120
    15bc:	5b01                	.insn	2, 0x5b01
    15be:	7902                	.insn	2, 0x7902
    15c0:	0100                	.insn	2, 0x0100
    15c2:	5c01                	.insn	2, 0x5c01
    15c4:	8602                	.insn	2, 0x8602
    15c6:	017f 5d01 8202 0000 	.insn	10, 0x4e00000082025d01017f
    15ce:	4e00 
    15d0:	0db8                	.insn	2, 0x0db8
    15d2:	0000                	.insn	2, 0x
    15d4:	0a08                	.insn	2, 0x0a08
    15d6:	8000                	.insn	2, 0x8000
    15d8:	00a8                	.insn	2, 0x00a8
    15da:	0000                	.insn	2, 0x
    15dc:	8e01                	.insn	2, 0x8e01
    15de:	1001                	.insn	2, 0x1001
    15e0:	c802                	.insn	2, 0xc802
    15e2:	000d                	.insn	2, 0x000d
    15e4:	4000                	.insn	2, 0x4000
    15e6:	001f 0200 0dd3      	.insn	6, 0x0dd30200001f
    15ec:	0000                	.insn	2, 0x
    15ee:	1f48                	.insn	2, 0x1f48
    15f0:	0000                	.insn	2, 0x
    15f2:	de02                	.insn	2, 0xde02
    15f4:	000d                	.insn	2, 0x000d
    15f6:	5000                	.insn	2, 0x5000
    15f8:	001f 0200 0de9      	.insn	6, 0x0de90200001f
    15fe:	0000                	.insn	2, 0x
    1600:	00001fa3          	sh	zero,31(zero) # 1f <main-0x7fffffe1>
    1604:	f402                	.insn	2, 0xf402
    1606:	000d                	.insn	2, 0x000d
    1608:	b200                	.insn	2, 0xb200
    160a:	001f 0200 0dff      	.insn	6, 0x0dff0200001f
    1610:	0000                	.insn	2, 0x
    1612:	00001fbf 000e0a02 	.insn	8, 0x000e0a0200001fbf
    161a:	e600                	.insn	2, 0xe600
    161c:	001f 0200 0e15      	.insn	6, 0x0e150200001f
    1622:	0000                	.insn	2, 0x
    1624:	1ff5                	.insn	2, 0x1ff5
    1626:	0000                	.insn	2, 0x
    1628:	000e2003          	lw	zero,0(t3)
    162c:	0500                	.insn	2, 0x0500
    162e:	0020                	.insn	2, 0x0020
    1630:	2e00                	.insn	2, 0x2e00
    1632:	0e2c                	.insn	2, 0x0e2c
    1634:	0000                	.insn	2, 0x
    1636:	00c4                	.insn	2, 0x00c4
    1638:	0000                	.insn	2, 0x
    163a:	15d0                	.insn	2, 0x15d0
    163c:	0000                	.insn	2, 0x
    163e:	000e2d03          	lw	s10,0(t3)
    1642:	1400                	.insn	2, 0x1400
    1644:	0020                	.insn	2, 0x0020
    1646:	0a00                	.insn	2, 0x0a00
    1648:	0a40                	.insn	2, 0x0a40
    164a:	8000                	.insn	2, 0x8000
    164c:	0101                	.insn	2, 0x0101
    164e:	025a                	.insn	2, 0x025a
    1650:	2008                	.insn	2, 0x2008
    1652:	0101                	.insn	2, 0x0101
    1654:	0079025b          	.insn	4, 0x0079025b
    1658:	0101                	.insn	2, 0x0101
    165a:	025c                	.insn	2, 0x025c
    165c:	01017f87          	.insn	4, 0x01017f87
    1660:	025d                	.insn	2, 0x025d
    1662:	0082                	.insn	2, 0x0082
    1664:	0000                	.insn	2, 0x
    1666:	7009                	.insn	2, 0x7009
    1668:	000a                	.insn	2, 0x000a
    166a:	f080                	.insn	2, 0xf080
    166c:	0015                	.insn	2, 0x0015
    166e:	0100                	.insn	2, 0x0100
    1670:	5b01                	.insn	2, 0x5b01
    1672:	7902                	.insn	2, 0x7902
    1674:	0100                	.insn	2, 0x0100
    1676:	5c01                	.insn	2, 0x5c01
    1678:	8706                	.insn	2, 0x8706
    167a:	2000                	.insn	2, 0x2000
    167c:	0089                	.insn	2, 0x0089
    167e:	0122                	.insn	2, 0x0122
    1680:	5d01                	.insn	2, 0x5d01
    1682:	8202                	.insn	2, 0x8202
    1684:	0000                	.insn	2, 0x
    1686:	a00a                	.insn	2, 0xa00a
    1688:	000a                	.insn	2, 0x000a
    168a:	0180                	.insn	2, 0x0180
    168c:	5a01                	.insn	2, 0x5a01
    168e:	0802                	.insn	2, 0x0802
    1690:	0120                	.insn	2, 0x0120
    1692:	5b01                	.insn	2, 0x5b01
    1694:	7902                	.insn	2, 0x7902
    1696:	0100                	.insn	2, 0x0100
    1698:	5c01                	.insn	2, 0x5c01
    169a:	8602                	.insn	2, 0x8602
    169c:	017f 5d01 8202 0000 	.insn	10, 0x82025d01017f
    16a4:	0000 
    16a6:	a11e                	.insn	2, 0xa11e
    16a8:	0009                	.insn	2, 0x0009
    16aa:	7400                	.insn	2, 0x7400
    16ac:	000c                	.insn	2, 0x000c
    16ae:	2c80                	.insn	2, 0x2c80
    16b0:	0004                	.insn	2, 0x0004
    16b2:	0100                	.insn	2, 0x0100
    16b4:	219c                	.insn	2, 0x219c
    16b6:	0018                	.insn	2, 0x0018
    16b8:	0200                	.insn	2, 0x0200
    16ba:	09b0                	.insn	2, 0x09b0
    16bc:	0000                	.insn	2, 0x
    16be:	2055                	.insn	2, 0x2055
    16c0:	0000                	.insn	2, 0x
    16c2:	bc02                	.insn	2, 0xbc02
    16c4:	0009                	.insn	2, 0x0009
    16c6:	a700                	.insn	2, 0xa700
    16c8:	0020                	.insn	2, 0x0020
    16ca:	0200                	.insn	2, 0x0200
    16cc:	09c8                	.insn	2, 0x09c8
    16ce:	0000                	.insn	2, 0x
    16d0:	000020eb          	.insn	4, 0x20eb
    16d4:	d402                	.insn	2, 0xd402
    16d6:	0009                	.insn	2, 0x0009
    16d8:	4b00                	.insn	2, 0x4b00
    16da:	0021                	.insn	2, 0x0021
    16dc:	0200                	.insn	2, 0x0200
    16de:	09e0                	.insn	2, 0x09e0
    16e0:	0000                	.insn	2, 0x
    16e2:	0000218f          	.insn	4, 0x218f
    16e6:	ec02                	.insn	2, 0xec02
    16e8:	0009                	.insn	2, 0x0009
    16ea:	d800                	.insn	2, 0xd800
    16ec:	0021                	.insn	2, 0x0021
    16ee:	0200                	.insn	2, 0x0200
    16f0:	09f8                	.insn	2, 0x09f8
    16f2:	0000                	.insn	2, 0x
    16f4:	221e                	.insn	2, 0x221e
    16f6:	0000                	.insn	2, 0x
    16f8:	0402                	.insn	2, 0x0402
    16fa:	000a                	.insn	2, 0x000a
    16fc:	7e00                	.insn	2, 0x7e00
    16fe:	0022                	.insn	2, 0x0022
    1700:	0600                	.insn	2, 0x0600
    1702:	0a10                	.insn	2, 0x0a10
    1704:	0000                	.insn	2, 0x
    1706:	3b06                	.insn	2, 0x3b06
    1708:	000a                	.insn	2, 0x000a
    170a:	0600                	.insn	2, 0x0600
    170c:	00000a47          	fmsub.s	fs4,ft0,ft0,ft0,rne
    1710:	5306                	.insn	2, 0x5306
    1712:	000a                	.insn	2, 0x000a
    1714:	0600                	.insn	2, 0x0600
    1716:	0a5f 0000 6906      	.insn	6, 0x690600000a5f
    171c:	000a                	.insn	2, 0x000a
    171e:	0600                	.insn	2, 0x0600
    1720:	0a74                	.insn	2, 0x0a74
    1722:	0000                	.insn	2, 0x
    1724:	8006                	.insn	2, 0x8006
    1726:	000a                	.insn	2, 0x000a
    1728:	0600                	.insn	2, 0x0600
    172a:	0a8c                	.insn	2, 0x0a8c
    172c:	0000                	.insn	2, 0x
    172e:	a126                	.insn	2, 0xa126
    1730:	0009                	.insn	2, 0x0009
    1732:	d800                	.insn	2, 0xd800
    1734:	000c                	.insn	2, 0x000c
    1736:	d480                	.insn	2, 0xd480
    1738:	0000                	.insn	2, 0x
    173a:	ff00                	.insn	2, 0xff00
    173c:	0f01                	.insn	2, 0x0f01
    173e:	b002                	.insn	2, 0xb002
    1740:	0009                	.insn	2, 0x0009
    1742:	ac00                	.insn	2, 0xac00
    1744:	0022                	.insn	2, 0x0022
    1746:	0200                	.insn	2, 0x0200
    1748:	09bc                	.insn	2, 0x09bc
    174a:	0000                	.insn	2, 0x
    174c:	000022e7          	.insn	4, 0x22e7
    1750:	c802                	.insn	2, 0xc802
    1752:	0009                	.insn	2, 0x0009
    1754:	1400                	.insn	2, 0x1400
    1756:	02000023          	sb	zero,32(zero) # 20 <main-0x7fffffe0>
    175a:	09d4                	.insn	2, 0x09d4
    175c:	0000                	.insn	2, 0x
    175e:	2369                	.insn	2, 0x2369
    1760:	0000                	.insn	2, 0x
    1762:	e002                	.insn	2, 0xe002
    1764:	0009                	.insn	2, 0x0009
    1766:	9600                	.insn	2, 0x9600
    1768:	02000023          	sb	zero,32(zero) # 20 <main-0x7fffffe0>
    176c:	09ec                	.insn	2, 0x09ec
    176e:	0000                	.insn	2, 0x
    1770:	000023ef          	jal	t2,3770 <main-0x7fffc890>
    1774:	f802                	.insn	2, 0xf802
    1776:	0009                	.insn	2, 0x0009
    1778:	1400                	.insn	2, 0x1400
    177a:	0024                	.insn	2, 0x0024
    177c:	0200                	.insn	2, 0x0200
    177e:	0a04                	.insn	2, 0x0a04
    1780:	0000                	.insn	2, 0x
    1782:	0000244f          	fnmadd.s	fs0,ft0,ft0,ft0,rdn
    1786:	d420                	.insn	2, 0xd420
    1788:	0000                	.insn	2, 0x
    178a:	0300                	.insn	2, 0x0300
    178c:	0a10                	.insn	2, 0x0a10
    178e:	0000                	.insn	2, 0x
    1790:	24a5                	.insn	2, 0x24a5
    1792:	0000                	.insn	2, 0x
    1794:	000a3b03          	.insn	4, 0x000a3b03
    1798:	fe00                	.insn	2, 0xfe00
    179a:	0024                	.insn	2, 0x0024
    179c:	0300                	.insn	2, 0x0300
    179e:	00000a47          	fmsub.s	fs4,ft0,ft0,ft0,rne
    17a2:	251d                	.insn	2, 0x251d
    17a4:	0000                	.insn	2, 0x
    17a6:	000a5303          	lhu	t1,0(s4)
    17aa:	2f00                	.insn	2, 0x2f00
    17ac:	0025                	.insn	2, 0x0025
    17ae:	3500                	.insn	2, 0x3500
    17b0:	0a5f 0000 9002      	.insn	6, 0x900200000a5f
    17b6:	032e                	.insn	2, 0x032e
    17b8:	0a69                	.insn	2, 0x0a69
    17ba:	0000                	.insn	2, 0x
    17bc:	255c                	.insn	2, 0x255c
    17be:	0000                	.insn	2, 0x
    17c0:	000a7403          	.insn	4, 0x000a7403
    17c4:	6500                	.insn	2, 0x6500
    17c6:	0025                	.insn	2, 0x0025
    17c8:	0300                	.insn	2, 0x0300
    17ca:	0a80                	.insn	2, 0x0a80
    17cc:	0000                	.insn	2, 0x
    17ce:	25b1                	.insn	2, 0x25b1
    17d0:	0000                	.insn	2, 0x
    17d2:	000a8c03          	lb	s8,0(s5)
    17d6:	f200                	.insn	2, 0xf200
    17d8:	0025                	.insn	2, 0x0025
    17da:	4f00                	.insn	2, 0x4f00
    17dc:	0ee8                	.insn	2, 0x0ee8
    17de:	8000                	.insn	2, 0x8000
    17e0:	0aaa                	.insn	2, 0x0aaa
    17e2:	0000                	.insn	2, 0x
    17e4:	441d                	.insn	2, 0x441d
    17e6:	aa80000f          	.insn	4, 0xaa80000f
    17ea:	000a                	.insn	2, 0x000a
    17ec:	7f00                	.insn	2, 0x7f00
    17ee:	01000017          	auipc	zero,0x1000
    17f2:	5a01                	.insn	2, 0x5a01
    17f4:	8502                	.insn	2, 0x8502
    17f6:	0100                	.insn	2, 0x0100
    17f8:	5b01                	.insn	2, 0x5b01
    17fa:	7802                	.insn	2, 0x7802
    17fc:	0100                	.insn	2, 0x0100
    17fe:	5c01                	.insn	2, 0x5c01
    1800:	8402                	.insn	2, 0x8402
    1802:	0100                	.insn	2, 0x0100
    1804:	5d01                	.insn	2, 0x5d01
    1806:	7902                	.insn	2, 0x7902
    1808:	0100                	.insn	2, 0x0100
    180a:	7202                	.insn	2, 0x7202
    180c:	0600                	.insn	2, 0x0600
    180e:	0082                	.insn	2, 0x0082
    1810:	1af7ff0b          	.insn	4, 0x1af7ff0b
    1814:	5000                	.insn	2, 0x5000
    1816:	0f64                	.insn	2, 0x0f64
    1818:	8000                	.insn	2, 0x8000
    181a:	8502                	.insn	2, 0x8502
    181c:	ab00                	.insn	2, 0xab00
    181e:	01000017          	auipc	zero,0x1000
    1822:	5a01                	.insn	2, 0x5a01
    1824:	9109                	.insn	2, 0x9109
    1826:	0600                	.insn	2, 0x0600
    1828:	0820                	.insn	2, 0x0820
    182a:	1a20                	.insn	2, 0x1a20
    182c:	01014523          	.insn	4, 0x01014523
    1830:	0078025b          	.insn	4, 0x0078025b
    1834:	0101                	.insn	2, 0x0101
    1836:	025c                	.insn	2, 0x025c
    1838:	7f82                	.insn	2, 0x7f82
    183a:	0101                	.insn	2, 0x0101
    183c:	025d                	.insn	2, 0x025d
    183e:	0079                	.insn	2, 0x0079
    1840:	1d00                	.insn	2, 0x1d00
    1842:	0fa0                	.insn	2, 0x0fa0
    1844:	8000                	.insn	2, 0x8000
    1846:	00000bb3          	add	s7,zero,zero
    184a:	1800                	.insn	2, 0x1800
    184c:	0000                	.insn	2, 0x
    184e:	0101                	.insn	2, 0x0101
    1850:	025a                	.insn	2, 0x025a
    1852:	0085                	.insn	2, 0x0085
    1854:	0101                	.insn	2, 0x0101
    1856:	0078025b          	.insn	4, 0x0078025b
    185a:	0101                	.insn	2, 0x0101
    185c:	025c                	.insn	2, 0x025c
    185e:	0082                	.insn	2, 0x0082
    1860:	0101                	.insn	2, 0x0101
    1862:	025d                	.insn	2, 0x025d
    1864:	0079                	.insn	2, 0x0079
    1866:	0101                	.insn	2, 0x0101
    1868:	0c5e                	.insn	2, 0x0c5e
    186a:	264f0087          	.insn	4, 0x264f0087
    186e:	87270087          	.insn	4, 0x87270087
    1872:	4f00                	.insn	2, 0x4f00
    1874:	1c26                	.insn	2, 0x1c26
    1876:	0101                	.insn	2, 0x0101
    1878:	045f 0087 254f      	.insn	6, 0x254f0087045f
    187e:	0101                	.insn	2, 0x0101
    1880:	0160                	.insn	2, 0x0160
    1882:	013a                	.insn	2, 0x013a
    1884:	6101                	.insn	2, 0x6101
    1886:	3001                	.insn	2, 0x3001
    1888:	0201                	.insn	2, 0x0201
    188a:	0072                	.insn	2, 0x0072
    188c:	8302                	.insn	2, 0x8302
    188e:	0100                	.insn	2, 0x0100
    1890:	7202                	.insn	2, 0x7202
    1892:	0104                	.insn	2, 0x0104
    1894:	0035                	.insn	2, 0x0035
    1896:	cc0a                	.insn	2, 0xcc0a
    1898:	0180000f          	fence	w,i
    189c:	5a01                	.insn	2, 0x5a01
    189e:	0802                	.insn	2, 0x0802
    18a0:	0120                	.insn	2, 0x0120
    18a2:	5b01                	.insn	2, 0x5b01
    18a4:	7802                	.insn	2, 0x7802
    18a6:	0100                	.insn	2, 0x0100
    18a8:	5c01                	.insn	2, 0x5c01
    18aa:	8202                	.insn	2, 0x8202
    18ac:	017f 5d01 7902 0000 	.insn	10, 0x79025d01017f
    18b4:	0000 
    18b6:	1e00                	.insn	2, 0x1e00
    18b8:	10fc                	.insn	2, 0x10fc
    18ba:	0000                	.insn	2, 0x
    18bc:	1a08                	.insn	2, 0x1a08
    18be:	8000                	.insn	2, 0x8000
    18c0:	0008                	.insn	2, 0x0008
    18c2:	0000                	.insn	2, 0x
    18c4:	9c01                	.insn	2, 0x9c01
    18c6:	183e                	.insn	2, 0x183e
    18c8:	0000                	.insn	2, 0x
    18ca:	0d02                	.insn	2, 0x0d02
    18cc:	0011                	.insn	2, 0x0011
    18ce:	1800                	.insn	2, 0x1800
    18d0:	0026                	.insn	2, 0x0026
    18d2:	0000                	.insn	2, 0x
    18d4:	ef51                	.insn	2, 0xef51
    18d6:	0010                	.insn	2, 0x0010
    18d8:	1000                	.insn	2, 0x1000
    18da:	001a                	.insn	2, 0x001a
    18dc:	2080                	.insn	2, 0x2080
    18de:	0000                	.insn	2, 0x
    18e0:	0100                	.insn	2, 0x0100
    18e2:	529c                	.insn	2, 0x529c
    18e4:	0ffe                	.insn	2, 0x0ffe
    18e6:	0000                	.insn	2, 0x
    18e8:	1b04                	.insn	2, 0x1b04
    18ea:	8000                	.insn	2, 0x8000
    18ec:	000c                	.insn	2, 0x000c
    18ee:	0000                	.insn	2, 0x
    18f0:	9c01                	.insn	2, 0x9c01
    18f2:	00100b53          	fadd.s	fs6,ft0,ft1,rne
    18f6:	0100                	.insn	2, 0x0100
    18f8:	005a                	.insn	2, 0x005a
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	2401                	.insn	2, 0x2401
   2:	0b00                	.insn	2, 0x0b00
   4:	030b3e0b          	.insn	4, 0x030b3e0b
   8:	000e                	.insn	2, 0x000e
   a:	0200                	.insn	2, 0x0200
   c:	0111                	.insn	2, 0x0111
   e:	0e25                	.insn	2, 0x0e25
  10:	1f030b13          	addi	s6,t1,496
  14:	17551f1b          	.insn	4, 0x17551f1b
  18:	0111                	.insn	2, 0x0111
  1a:	1710                	.insn	2, 0x1710
  1c:	0000                	.insn	2, 0x
  1e:	0b002403          	lw	s0,176(zero) # b0 <main-0x7fffff50>
  22:	030b3e0b          	.insn	4, 0x030b3e0b
  26:	0008                	.insn	2, 0x0008
  28:	0400                	.insn	2, 0x0400
  2a:	012e                	.insn	2, 0x012e
  2c:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
  34:	0b39                	.insn	2, 0x0b39
  36:	13491927          	.insn	4, 0x13491927
  3a:	193c                	.insn	2, 0x193c
  3c:	1301                	.insn	2, 0x1301
  3e:	0000                	.insn	2, 0x
  40:	0505                	.insn	2, 0x0505
  42:	4900                	.insn	2, 0x4900
  44:	06000013          	addi	zero,zero,96
  48:	0018                	.insn	2, 0x0018
  4a:	0000                	.insn	2, 0x
  4c:	0b000f07          	.insn	4, 0x0b000f07
  50:	0013490b          	.insn	4, 0x0013490b
  54:	0800                	.insn	2, 0x0800
  56:	0026                	.insn	2, 0x0026
  58:	1349                	.insn	2, 0x1349
  5a:	0000                	.insn	2, 0x
  5c:	2e09                	.insn	2, 0x2e09
  5e:	3f01                	.insn	2, 0x3f01
  60:	0319                	.insn	2, 0x0319
  62:	3a0e                	.insn	2, 0x3a0e
  64:	390b3b0b          	.insn	4, 0x390b3b0b
  68:	4919270b          	.insn	4, 0x4919270b
  6c:	12011113          	.insn	4, 0x12011113
  70:	4006                	.insn	2, 0x4006
  72:	7a18                	.insn	2, 0x7a18
  74:	0019                	.insn	2, 0x0019
  76:	0a00                	.insn	2, 0x0a00
  78:	0148                	.insn	2, 0x0148
  7a:	017d                	.insn	2, 0x017d
  7c:	0000137f 0200490b 	.insn	12, 0x00187e180200490b0000137f
  84:	00187e18 
  88:	0000                	.insn	2, 0x
  8a:	4901                	.insn	2, 0x4901
  8c:	0200                	.insn	2, 0x0200
  8e:	7e18                	.insn	2, 0x7e18
  90:	0018                	.insn	2, 0x0018
  92:	0200                	.insn	2, 0x0200
  94:	0005                	.insn	2, 0x0005
  96:	1331                	.insn	2, 0x1331
  98:	1702                	.insn	2, 0x1702
  9a:	0000                	.insn	2, 0x
  9c:	31003403          	.insn	4, 0x31003403
  a0:	00170213          	addi	tp,a4,1
  a4:	0400                	.insn	2, 0x0400
  a6:	0005                	.insn	2, 0x0005
  a8:	213a0e03          	lb	t3,531(s4)
  ac:	3b01                	.insn	2, 0x3b01
  ae:	3905                	.insn	2, 0x3905
  b0:	0213490b          	.insn	4, 0x0213490b
  b4:	05000017          	auipc	zero,0x5000
  b8:	0005                	.insn	2, 0x0005
  ba:	213a0e03          	lb	t3,531(s4)
  be:	3b01                	.insn	2, 0x3b01
  c0:	3905                	.insn	2, 0x3905
  c2:	0013490b          	.insn	4, 0x0013490b
  c6:	0600                	.insn	2, 0x0600
  c8:	0034                	.insn	2, 0x0034
  ca:	1331                	.insn	2, 0x1331
  cc:	0000                	.insn	2, 0x
  ce:	0b002407          	flw	fs0,176(zero) # b0 <main-0x7fffff50>
  d2:	030b3e0b          	.insn	4, 0x030b3e0b
  d6:	000e                	.insn	2, 0x000e
  d8:	0800                	.insn	2, 0x0800
  da:	0034                	.insn	2, 0x0034
  dc:	213a0e03          	lb	t3,531(s4)
  e0:	3b01                	.insn	2, 0x3b01
  e2:	3905                	.insn	2, 0x3905
  e4:	0013490b          	.insn	4, 0x0013490b
  e8:	0900                	.insn	2, 0x0900
  ea:	0148                	.insn	2, 0x0148
  ec:	017d                	.insn	2, 0x017d
  ee:	1301                	.insn	2, 0x1301
  f0:	0000                	.insn	2, 0x
  f2:	480a                	.insn	2, 0x480a
  f4:	7d01                	.insn	2, 0x7d01
  f6:	0001                	.insn	2, 0x0001
  f8:	0b00                	.insn	2, 0x0b00
  fa:	0005                	.insn	2, 0x0005
  fc:	1331                	.insn	2, 0x1331
  fe:	0000                	.insn	2, 0x
 100:	260c                	.insn	2, 0x260c
 102:	4900                	.insn	2, 0x4900
 104:	0d000013          	addi	zero,zero,208
 108:	0034                	.insn	2, 0x0034
 10a:	213a0803          	lb	a6,531(s4)
 10e:	3b01                	.insn	2, 0x3b01
 110:	3905                	.insn	2, 0x3905
 112:	0213490b          	.insn	4, 0x0213490b
 116:	0018                	.insn	2, 0x0018
 118:	0e00                	.insn	2, 0x0e00
 11a:	0005                	.insn	2, 0x0005
 11c:	213a0803          	lb	a6,531(s4)
 120:	3b01                	.insn	2, 0x3b01
 122:	490b390b          	.insn	4, 0x490b390b
 126:	0f000013          	addi	zero,zero,240
 12a:	0005                	.insn	2, 0x0005
 12c:	213a0e03          	lb	t3,531(s4)
 130:	3b01                	.insn	2, 0x3b01
 132:	490b390b          	.insn	4, 0x490b390b
 136:	10000013          	addi	zero,zero,256
 13a:	0005                	.insn	2, 0x0005
 13c:	213a0e03          	lb	t3,531(s4)
 140:	3b01                	.insn	2, 0x3b01
 142:	490b390b          	.insn	4, 0x490b390b
 146:	00180213          	addi	tp,a6,1
 14a:	1100                	.insn	2, 0x1100
 14c:	0016                	.insn	2, 0x0016
 14e:	0b3a0e03          	lb	t3,179(s4)
 152:	0b390b3b          	.insn	4, 0x0b390b3b
 156:	1349                	.insn	2, 0x1349
 158:	0000                	.insn	2, 0x
 15a:	0512                	.insn	2, 0x0512
 15c:	0300                	.insn	2, 0x0300
 15e:	3a08                	.insn	2, 0x3a08
 160:	0121                	.insn	2, 0x0121
 162:	0b39053b          	.insn	4, 0x0b39053b
 166:	1349                	.insn	2, 0x1349
 168:	1702                	.insn	2, 0x1702
 16a:	0000                	.insn	2, 0x
 16c:	03003413          	sltiu	s0,zero,48
 170:	3a0e                	.insn	2, 0x3a0e
 172:	0121                	.insn	2, 0x0121
 174:	0b39053b          	.insn	4, 0x0b39053b
 178:	1349                	.insn	2, 0x1349
 17a:	1702                	.insn	2, 0x1702
 17c:	0000                	.insn	2, 0x
 17e:	0b14                	.insn	2, 0x0b14
 180:	5501                	.insn	2, 0x5501
 182:	00130117          	auipc	sp,0x130
 186:	1500                	.insn	2, 0x1500
 188:	0005                	.insn	2, 0x0005
 18a:	213a0803          	lb	a6,531(s4)
 18e:	3b01                	.insn	2, 0x3b01
 190:	3905                	.insn	2, 0x3905
 192:	0013490b          	.insn	4, 0x0013490b
 196:	1600                	.insn	2, 0x1600
 198:	0148                	.insn	2, 0x0148
 19a:	017d                	.insn	2, 0x017d
 19c:	0000137f 49000517 	.insn	12, 0x18000013490005170000137f
 1a4:	18000013 
 1a8:	012e                	.insn	2, 0x012e
 1aa:	0e03193f 3b01213a 	.insn	8, 0x3b01213a0e03193f
 1b2:	3905                	.insn	2, 0x3905
 1b4:	0521                	.insn	2, 0x0521
 1b6:	13491927          	.insn	4, 0x13491927
 1ba:	0111                	.insn	2, 0x0111
 1bc:	0612                	.insn	2, 0x0612
 1be:	1840                	.insn	2, 0x1840
 1c0:	197a                	.insn	2, 0x197a
 1c2:	1301                	.insn	2, 0x1301
 1c4:	0000                	.insn	2, 0x
 1c6:	3419                	.insn	2, 0x3419
 1c8:	0300                	.insn	2, 0x0300
 1ca:	3a08                	.insn	2, 0x3a08
 1cc:	0121                	.insn	2, 0x0121
 1ce:	0b39053b          	.insn	4, 0x0b39053b
 1d2:	1349                	.insn	2, 0x1349
 1d4:	1702                	.insn	2, 0x1702
 1d6:	0000                	.insn	2, 0x
 1d8:	341a                	.insn	2, 0x341a
 1da:	0300                	.insn	2, 0x0300
 1dc:	3a08                	.insn	2, 0x3a08
 1de:	0121                	.insn	2, 0x0121
 1e0:	0b39053b          	.insn	4, 0x0b39053b
 1e4:	1349                	.insn	2, 0x1349
 1e6:	0000                	.insn	2, 0x
 1e8:	0b000f1b          	.insn	4, 0x0b000f1b
 1ec:	0421                	.insn	2, 0x0421
 1ee:	1349                	.insn	2, 0x1349
 1f0:	0000                	.insn	2, 0x
 1f2:	341c                	.insn	2, 0x341c
 1f4:	0300                	.insn	2, 0x0300
 1f6:	3a0e                	.insn	2, 0x3a0e
 1f8:	0121                	.insn	2, 0x0121
 1fa:	0b39053b          	.insn	4, 0x0b39053b
 1fe:	1349                	.insn	2, 0x1349
 200:	1802                	.insn	2, 0x1802
 202:	0000                	.insn	2, 0x
 204:	481d                	.insn	2, 0x481d
 206:	7d01                	.insn	2, 0x7d01
 208:	7f01                	.insn	2, 0x7f01
 20a:	00130113          	addi	sp,t1,1
 20e:	1e00                	.insn	2, 0x1e00
 210:	012e                	.insn	2, 0x012e
 212:	1331                	.insn	2, 0x1331
 214:	0111                	.insn	2, 0x0111
 216:	0612                	.insn	2, 0x0612
 218:	1840                	.insn	2, 0x1840
 21a:	197a                	.insn	2, 0x197a
 21c:	1301                	.insn	2, 0x1301
 21e:	0000                	.insn	2, 0x
 220:	181f 0000 2000      	.insn	6, 0x20000000181f
 226:	1755010b          	.insn	4, 0x1755010b
 22a:	0000                	.insn	2, 0x
 22c:	1d21                	.insn	2, 0x1d21
 22e:	3101                	.insn	2, 0x3101
 230:	12011113          	.insn	4, 0x12011113
 234:	5806                	.insn	2, 0x5806
 236:	0121                	.insn	2, 0x0121
 238:	0559                	.insn	2, 0x0559
 23a:	13010b57          	.insn	4, 0x13010b57
 23e:	0000                	.insn	2, 0x
 240:	1d22                	.insn	2, 0x1d22
 242:	3101                	.insn	2, 0x3101
 244:	12011113          	.insn	4, 0x12011113
 248:	5806                	.insn	2, 0x5806
 24a:	0121                	.insn	2, 0x0121
 24c:	0b59                	.insn	2, 0x0b59
 24e:	00000b57          	.insn	4, 0x0b57
 252:	03012e23          	sw	a6,60(sp) # 1301be <main-0x7fecfe42>
 256:	3a0e                	.insn	2, 0x3a0e
 258:	0121                	.insn	2, 0x0121
 25a:	0b390b3b          	.insn	4, 0x0b390b3b
 25e:	13491927          	.insn	4, 0x13491927
 262:	0b20                	.insn	2, 0x0b20
 264:	1301                	.insn	2, 0x1301
 266:	0000                	.insn	2, 0x
 268:	0124                	.insn	2, 0x0124
 26a:	4901                	.insn	2, 0x4901
 26c:	00130113          	addi	sp,t1,1
 270:	2500                	.insn	2, 0x2500
 272:	0021                	.insn	2, 0x0021
 274:	1349                	.insn	2, 0x1349
 276:	00000b2f          	.insn	4, 0x0b2f
 27a:	1d26                	.insn	2, 0x1d26
 27c:	3101                	.insn	2, 0x3101
 27e:	55015213          	.insn	4, 0x55015213
 282:	01215817          	auipc	a6,0x1215
 286:	0559                	.insn	2, 0x0559
 288:	00000b57          	.insn	4, 0x0b57
 28c:	31011d27          	.insn	4, 0x31011d27
 290:	55015213          	.insn	4, 0x55015213
 294:	01215817          	auipc	a6,0x1215
 298:	0559                	.insn	2, 0x0559
 29a:	13010b57          	.insn	4, 0x13010b57
 29e:	0000                	.insn	2, 0x
 2a0:	2e28                	.insn	2, 0x2e28
 2a2:	0301                	.insn	2, 0x0301
 2a4:	3a0e                	.insn	2, 0x3a0e
 2a6:	0121                	.insn	2, 0x0121
 2a8:	2139053b          	.insn	4, 0x2139053b
 2ac:	4919270f          	.insn	4, 0x4919270f
 2b0:	01212013          	slti	zero,sp,18
 2b4:	1301                	.insn	2, 0x1301
 2b6:	0000                	.insn	2, 0x
 2b8:	3429                	.insn	2, 0x3429
 2ba:	0300                	.insn	2, 0x0300
 2bc:	3a08                	.insn	2, 0x3a08
 2be:	0121                	.insn	2, 0x0121
 2c0:	0b390b3b          	.insn	4, 0x0b390b3b
 2c4:	1349                	.insn	2, 0x1349
 2c6:	0000                	.insn	2, 0x
 2c8:	2e2a                	.insn	2, 0x2e2a
 2ca:	0301                	.insn	2, 0x0301
 2cc:	3a0e                	.insn	2, 0x3a0e
 2ce:	0121                	.insn	2, 0x0121
 2d0:	0b390b3b          	.insn	4, 0x0b390b3b
 2d4:	01111927          	.insn	4, 0x01111927
 2d8:	0612                	.insn	2, 0x0612
 2da:	1840                	.insn	2, 0x1840
 2dc:	197a                	.insn	2, 0x197a
 2de:	1301                	.insn	2, 0x1301
 2e0:	0000                	.insn	2, 0x
 2e2:	0300052b          	.insn	4, 0x0300052b
 2e6:	3a08                	.insn	2, 0x3a08
 2e8:	0121                	.insn	2, 0x0121
 2ea:	0b390b3b          	.insn	4, 0x0b390b3b
 2ee:	1349                	.insn	2, 0x1349
 2f0:	1802                	.insn	2, 0x1802
 2f2:	0000                	.insn	2, 0x
 2f4:	052c                	.insn	2, 0x052c
 2f6:	0300                	.insn	2, 0x0300
 2f8:	3a0e                	.insn	2, 0x3a0e
 2fa:	0121                	.insn	2, 0x0121
 2fc:	0b390b3b          	.insn	4, 0x0b390b3b
 300:	1349                	.insn	2, 0x1349
 302:	1702                	.insn	2, 0x1702
 304:	0000                	.insn	2, 0x
 306:	342d                	.insn	2, 0x342d
 308:	0300                	.insn	2, 0x0300
 30a:	3a08                	.insn	2, 0x3a08
 30c:	0121                	.insn	2, 0x0121
 30e:	0b390b3b          	.insn	4, 0x0b390b3b
 312:	1349                	.insn	2, 0x1349
 314:	1702                	.insn	2, 0x1702
 316:	0000                	.insn	2, 0x
 318:	0b2e                	.insn	2, 0x0b2e
 31a:	3101                	.insn	2, 0x3101
 31c:	01175513          	srli	a0,a4,0x11
 320:	2f000013          	addi	zero,zero,752
 324:	0115                	.insn	2, 0x0115
 326:	13011927          	.insn	4, 0x13011927
 32a:	0000                	.insn	2, 0x
 32c:	0d30                	.insn	2, 0x0d30
 32e:	0300                	.insn	2, 0x0300
 330:	3a08                	.insn	2, 0x3a08
 332:	0121                	.insn	2, 0x0121
 334:	0b390b3b          	.insn	4, 0x0b390b3b
 338:	1349                	.insn	2, 0x1349
 33a:	0b38                	.insn	2, 0x0b38
 33c:	0000                	.insn	2, 0x
 33e:	2e31                	.insn	2, 0x2e31
 340:	0301                	.insn	2, 0x0301
 342:	3a0e                	.insn	2, 0x3a0e
 344:	0121                	.insn	2, 0x0121
 346:	0b39053b          	.insn	4, 0x0b39053b
 34a:	13491927          	.insn	4, 0x13491927
 34e:	0111                	.insn	2, 0x0111
 350:	0612                	.insn	2, 0x0612
 352:	1840                	.insn	2, 0x1840
 354:	197a                	.insn	2, 0x197a
 356:	1301                	.insn	2, 0x1301
 358:	0000                	.insn	2, 0x
 35a:	0d32                	.insn	2, 0x0d32
 35c:	0300                	.insn	2, 0x0300
 35e:	3a08                	.insn	2, 0x3a08
 360:	0121                	.insn	2, 0x0121
 362:	0b39053b          	.insn	4, 0x0b39053b
 366:	1349                	.insn	2, 0x1349
 368:	0000                	.insn	2, 0x
 36a:	00010b33          	add	s6,sp,zero
 36e:	3400                	.insn	2, 0x3400
 370:	001d                	.insn	2, 0x001d
 372:	1331                	.insn	2, 0x1331
 374:	0152                	.insn	2, 0x0152
 376:	1755                	.insn	2, 0x1755
 378:	2158                	.insn	2, 0x2158
 37a:	5901                	.insn	2, 0x5901
 37c:	000b570b          	.insn	4, 0x000b570b
 380:	3500                	.insn	2, 0x3500
 382:	0034                	.insn	2, 0x0034
 384:	1331                	.insn	2, 0x1331
 386:	1802                	.insn	2, 0x1802
 388:	0000                	.insn	2, 0x
 38a:	4836                	.insn	2, 0x4836
 38c:	7d01                	.insn	2, 0x7d01
 38e:	8201                	.insn	2, 0x8201
 390:	1901                	.insn	2, 0x1901
 392:	1301137f 11370000 	.insn	12, 0x130e2501113700001301137f
 39a:	130e2501 
 39e:	1b1f030b          	.insn	4, 0x1b1f030b
 3a2:	111f 1201 1006      	.insn	6, 0x10061201111f
 3a8:	38000017          	auipc	zero,0x38000
 3ac:	0024                	.insn	2, 0x0024
 3ae:	0b3e0b0b          	.insn	4, 0x0b3e0b0b
 3b2:	00000803          	lb	a6,0(zero) # 0 <main-0x80000000>
 3b6:	0f39                	.insn	2, 0x0f39
 3b8:	0b00                	.insn	2, 0x0b00
 3ba:	3a00000b          	.insn	4, 0x3a00000b
 3be:	0b0b000f          	.insn	4, 0x0b0b000f
 3c2:	00000e03          	lb	t3,0(zero) # 0 <main-0x80000000>
 3c6:	0b01133b          	.insn	4, 0x0b01133b
 3ca:	3b0b3a0b          	.insn	4, 0x3b0b3a0b
 3ce:	010b390b          	.insn	4, 0x010b390b
 3d2:	3c000013          	addi	zero,zero,960
 3d6:	0148                	.insn	2, 0x0148
 3d8:	017d                	.insn	2, 0x017d
 3da:	0182                	.insn	2, 0x0182
 3dc:	7f19                	.insn	2, 0x7f19
 3de:	3d000013          	addi	zero,zero,976
 3e2:	0111010b          	.insn	4, 0x0111010b
 3e6:	0612                	.insn	2, 0x0612
 3e8:	1301                	.insn	2, 0x1301
 3ea:	0000                	.insn	2, 0x
 3ec:	173e                	.insn	2, 0x173e
 3ee:	0b01                	.insn	2, 0x0b01
 3f0:	3b0b3a0b          	.insn	4, 0x3b0b3a0b
 3f4:	3905                	.insn	2, 0x3905
 3f6:	0013010b          	.insn	4, 0x0013010b
 3fa:	3f00                	.insn	2, 0x3f00
 3fc:	0048                	.insn	2, 0x0048
 3fe:	017d                	.insn	2, 0x017d
 400:	0000137f 03003440 	.insn	12, 0x3b0b3a0e030034400000137f
 408:	3b0b3a0e 
 40c:	490b390b          	.insn	4, 0x490b390b
 410:	41000013          	addi	zero,zero,1040
 414:	012e                	.insn	2, 0x012e
 416:	0b3a0e03          	lb	t3,179(s4)
 41a:	0b390b3b          	.insn	4, 0x0b390b3b
 41e:	0b201927          	.insn	4, 0x0b201927
 422:	1301                	.insn	2, 0x1301
 424:	0000                	.insn	2, 0x
 426:	2e42                	.insn	2, 0x2e42
 428:	3f01                	.insn	2, 0x3f01
 42a:	0319                	.insn	2, 0x0319
 42c:	3a0e                	.insn	2, 0x3a0e
 42e:	390b3b0b          	.insn	4, 0x390b3b0b
 432:	2019270b          	.insn	4, 0x2019270b
 436:	0013010b          	.insn	4, 0x0013010b
 43a:	4300                	.insn	2, 0x4300
 43c:	012e                	.insn	2, 0x012e
 43e:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 446:	0b39                	.insn	2, 0x0b39
 448:	13491927          	.insn	4, 0x13491927
 44c:	0111                	.insn	2, 0x0111
 44e:	0612                	.insn	2, 0x0612
 450:	1840                	.insn	2, 0x1840
 452:	197a                	.insn	2, 0x197a
 454:	1301                	.insn	2, 0x1301
 456:	0000                	.insn	2, 0x
 458:	0544                	.insn	2, 0x0544
 45a:	0300                	.insn	2, 0x0300
 45c:	3a08                	.insn	2, 0x3a08
 45e:	390b3b0b          	.insn	4, 0x390b3b0b
 462:	0213490b          	.insn	4, 0x0213490b
 466:	45000017          	auipc	zero,0x45000
 46a:	0034                	.insn	2, 0x0034
 46c:	0b3a0e03          	lb	t3,179(s4)
 470:	0b390b3b          	.insn	4, 0x0b390b3b
 474:	1349                	.insn	2, 0x1349
 476:	1702                	.insn	2, 0x1702
 478:	0000                	.insn	2, 0x
 47a:	1d46                	.insn	2, 0x1d46
 47c:	3101                	.insn	2, 0x3101
 47e:	55015213          	.insn	4, 0x55015213
 482:	590b5817          	auipc	a6,0x590b5
 486:	000b570b          	.insn	4, 0x000b570b
 48a:	4700                	.insn	2, 0x4700
 48c:	012e                	.insn	2, 0x012e
 48e:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 496:	0b39                	.insn	2, 0x0b39
 498:	01111927          	.insn	4, 0x01111927
 49c:	0612                	.insn	2, 0x0612
 49e:	1840                	.insn	2, 0x1840
 4a0:	197a                	.insn	2, 0x197a
 4a2:	1301                	.insn	2, 0x1301
 4a4:	0000                	.insn	2, 0x
 4a6:	2e48                	.insn	2, 0x2e48
 4a8:	3f00                	.insn	2, 0x3f00
 4aa:	0319                	.insn	2, 0x0319
 4ac:	3a0e                	.insn	2, 0x3a0e
 4ae:	390b3b0b          	.insn	4, 0x390b3b0b
 4b2:	4919270b          	.insn	4, 0x4919270b
 4b6:	000b2013          	slti	zero,s6,0
 4ba:	4900                	.insn	2, 0x4900
 4bc:	012e                	.insn	2, 0x012e
 4be:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 4c6:	0b39                	.insn	2, 0x0b39
 4c8:	13491927          	.insn	4, 0x13491927
 4cc:	0b20                	.insn	2, 0x0b20
 4ce:	1301                	.insn	2, 0x1301
 4d0:	0000                	.insn	2, 0x
 4d2:	0b4a                	.insn	2, 0x0b4a
 4d4:	3101                	.insn	2, 0x3101
 4d6:	12011113          	.insn	4, 0x12011113
 4da:	0106                	.insn	2, 0x0106
 4dc:	4b000013          	addi	zero,zero,1200
 4e0:	0148                	.insn	2, 0x0148
 4e2:	017d                	.insn	2, 0x017d
 4e4:	0182                	.insn	2, 0x0182
 4e6:	0019                	.insn	2, 0x0019
 4e8:	4c00                	.insn	2, 0x4c00
 4ea:	0034                	.insn	2, 0x0034
 4ec:	1331                	.insn	2, 0x1331
 4ee:	0b1c                	.insn	2, 0x0b1c
 4f0:	0000                	.insn	2, 0x
 4f2:	344d                	.insn	2, 0x344d
 4f4:	3100                	.insn	2, 0x3100
 4f6:	000a1c13          	slli	s8,s4,0x0
 4fa:	4e00                	.insn	2, 0x4e00
 4fc:	011d                	.insn	2, 0x011d
 4fe:	1331                	.insn	2, 0x1331
 500:	0111                	.insn	2, 0x0111
 502:	0612                	.insn	2, 0x0612
 504:	0b58                	.insn	2, 0x0b58
 506:	0559                	.insn	2, 0x0559
 508:	00000b57          	.insn	4, 0x0b57
 50c:	7d00484f          	.insn	4, 0x7d00484f
 510:	8201                	.insn	2, 0x8201
 512:	1901                	.insn	2, 0x1901
 514:	0000137f 7d014850 	.insn	12, 0x180183017d0148500000137f
 51c:	18018301 
 520:	1301                	.insn	2, 0x1301
 522:	0000                	.insn	2, 0x
 524:	2e51                	.insn	2, 0x2e51
 526:	3100                	.insn	2, 0x3100
 528:	12011113          	.insn	4, 0x12011113
 52c:	4006                	.insn	2, 0x4006
 52e:	7a18                	.insn	2, 0x7a18
 530:	0019                	.insn	2, 0x0019
 532:	5200                	.insn	2, 0x5200
 534:	012e                	.insn	2, 0x012e
 536:	1331                	.insn	2, 0x1331
 538:	0111                	.insn	2, 0x0111
 53a:	0612                	.insn	2, 0x0612
 53c:	1840                	.insn	2, 0x1840
 53e:	197a                	.insn	2, 0x197a
 540:	0000                	.insn	2, 0x
 542:	31000553          	.insn	4, 0x31000553
 546:	00180213          	addi	tp,a6,1 # 590b5483 <main-0x26f4ab7d>
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
       0:	0080                	.insn	2, 0x0080
       2:	0000                	.insn	2, 0x
       4:	0005                	.insn	2, 0x0005
       6:	0004                	.insn	2, 0x0004
       8:	0000002f          	.insn	4, 0x002f
       c:	0101                	.insn	2, 0x0101
       e:	fb01                	.insn	2, 0xfb01
      10:	0d0e                	.insn	2, 0x0d0e
      12:	0100                	.insn	2, 0x0100
      14:	0101                	.insn	2, 0x0101
      16:	0001                	.insn	2, 0x0001
      18:	0000                	.insn	2, 0x
      1a:	0001                	.insn	2, 0x0001
      1c:	0100                	.insn	2, 0x0100
      1e:	0101                	.insn	2, 0x0101
      20:	011f 000d 0000      	.insn	6, 0x000d011f
      26:	0102                	.insn	2, 0x0102
      28:	021f 030f 0000      	.insn	6, 0x030f021f
	...
      36:	0038                	.insn	2, 0x0038
      38:	0000                	.insn	2, 0x
      3a:	0500                	.insn	2, 0x0500
      3c:	0010                	.insn	2, 0x0010
      3e:	0205                	.insn	2, 0x0205
      40:	0000                	.insn	2, 0x
      42:	8000                	.insn	2, 0x8000
      44:	0515                	.insn	2, 0x0515
      46:	0305                	.insn	2, 0x0305
      48:	0901                	.insn	2, 0x0901
      4a:	0000                	.insn	2, 0x
      4c:	0501                	.insn	2, 0x0501
      4e:	0610                	.insn	2, 0x0610
      50:	10097f03          	.insn	4, 0x10097f03
      54:	0100                	.insn	2, 0x0100
      56:	0505                	.insn	2, 0x0505
      58:	04090103          	lb	sp,64(s2)
      5c:	0100                	.insn	2, 0x0100
      5e:	1005                	.insn	2, 0x1005
      60:	04097f03          	.insn	4, 0x04097f03
      64:	0100                	.insn	2, 0x0100
      66:	0505                	.insn	2, 0x0505
      68:	04090103          	lb	sp,64(s2)
      6c:	0100                	.insn	2, 0x0100
      6e:	0306                	.insn	2, 0x0306
      70:	0902                	.insn	2, 0x0902
      72:	0004                	.insn	2, 0x0004
      74:	0501                	.insn	2, 0x0501
      76:	0601                	.insn	2, 0x0601
      78:	00090103          	lb	sp,0(s2)
      7c:	0100                	.insn	2, 0x0100
      7e:	1009                	.insn	2, 0x1009
      80:	0000                	.insn	2, 0x
      82:	0101                	.insn	2, 0x0101
      84:	2f6d                	.insn	2, 0x2f6d
      86:	0000                	.insn	2, 0x
      88:	0005                	.insn	2, 0x0005
      8a:	0004                	.insn	2, 0x0004
      8c:	0000004f          	fnmadd.s	ft0,ft0,ft0,ft0,rne
      90:	0101                	.insn	2, 0x0101
      92:	fb01                	.insn	2, 0xfb01
      94:	0d0e                	.insn	2, 0x0d0e
      96:	0100                	.insn	2, 0x0100
      98:	0101                	.insn	2, 0x0101
      9a:	0001                	.insn	2, 0x0001
      9c:	0000                	.insn	2, 0x
      9e:	0001                	.insn	2, 0x0001
      a0:	0100                	.insn	2, 0x0100
      a2:	0101                	.insn	2, 0x0101
      a4:	041f 000d 0000      	.insn	6, 0x000d041f
      aa:	0048                	.insn	2, 0x0048
      ac:	0000                	.insn	2, 0x
      ae:	006c                	.insn	2, 0x006c
      b0:	0000                	.insn	2, 0x
      b2:	0000008b          	.insn	4, 0x008b
      b6:	0102                	.insn	2, 0x0102
      b8:	021f 070f 0040      	.insn	6, 0x0040070f021f
      be:	0000                	.insn	2, 0x
      c0:	4000                	.insn	2, 0x4000
      c2:	0000                	.insn	2, 0x
      c4:	0000                	.insn	2, 0x
      c6:	000000c7          	fmsub.s	ft1,ft0,ft0,ft0,rne
      ca:	cf01                	.insn	2, 0xcf01
      cc:	0000                	.insn	2, 0x
      ce:	0100                	.insn	2, 0x0100
      d0:	00de                	.insn	2, 0x00de
      d2:	0000                	.insn	2, 0x
      d4:	e702                	.insn	2, 0xe702
      d6:	0000                	.insn	2, 0x
      d8:	0300                	.insn	2, 0x0300
      da:	00f0                	.insn	2, 0x00f0
      dc:	0000                	.insn	2, 0x
      de:	002f0503          	lb	a0,2(t5)
      e2:	0205                	.insn	2, 0x0205
      e4:	0030                	.insn	2, 0x0030
      e6:	8000                	.insn	2, 0x8000
      e8:	0101a603          	lw	a2,16(gp) # 80005eae <__global_pointer$+0x26ae>
      ec:	0505                	.insn	2, 0x0505
      ee:	00090103          	lb	sp,0(s2)
      f2:	0100                	.insn	2, 0x0100
      f4:	0805                	.insn	2, 0x0805
      f6:	0306                	.insn	2, 0x0306
      f8:	0900                	.insn	2, 0x0900
      fa:	0000                	.insn	2, 0x
      fc:	0501                	.insn	2, 0x0501
      fe:	0609                	.insn	2, 0x0609
     100:	04090103          	lb	sp,64(s2)
     104:	0100                	.insn	2, 0x0100
     106:	1f05                	.insn	2, 0x1f05
     108:	0306                	.insn	2, 0x0306
     10a:	0900                	.insn	2, 0x0900
     10c:	0000                	.insn	2, 0x
     10e:	0501                	.insn	2, 0x0501
     110:	0301                	.insn	2, 0x0301
     112:	0902                	.insn	2, 0x0902
     114:	0008                	.insn	2, 0x0008
     116:	0501                	.insn	2, 0x0501
     118:	0649                	.insn	2, 0x0649
     11a:	04090403          	lb	s0,64(s2)
     11e:	0100                	.insn	2, 0x0100
     120:	0505                	.insn	2, 0x0505
     122:	00090103          	lb	sp,0(s2)
     126:	0100                	.insn	2, 0x0100
     128:	00090103          	lb	sp,0(s2)
     12c:	0100                	.insn	2, 0x0100
     12e:	00090103          	lb	sp,0(s2)
     132:	0100                	.insn	2, 0x0100
     134:	00090103          	lb	sp,0(s2)
     138:	0100                	.insn	2, 0x0100
     13a:	0105                	.insn	2, 0x0105
     13c:	0306                	.insn	2, 0x0306
     13e:	0901                	.insn	2, 0x0901
     140:	0000                	.insn	2, 0x
     142:	0501                	.insn	2, 0x0501
     144:	0649                	.insn	2, 0x0649
     146:	04090403          	lb	s0,64(s2)
     14a:	0100                	.insn	2, 0x0100
     14c:	0505                	.insn	2, 0x0505
     14e:	00090103          	lb	sp,0(s2)
     152:	0100                	.insn	2, 0x0100
     154:	00090103          	lb	sp,0(s2)
     158:	0100                	.insn	2, 0x0100
     15a:	00090103          	lb	sp,0(s2)
     15e:	0100                	.insn	2, 0x0100
     160:	00090103          	lb	sp,0(s2)
     164:	0100                	.insn	2, 0x0100
     166:	0805                	.insn	2, 0x0805
     168:	0306                	.insn	2, 0x0306
     16a:	0900                	.insn	2, 0x0900
     16c:	0000                	.insn	2, 0x
     16e:	0501                	.insn	2, 0x0501
     170:	0609                	.insn	2, 0x0609
     172:	04090103          	lb	sp,64(s2)
     176:	0100                	.insn	2, 0x0100
     178:	2105                	.insn	2, 0x2105
     17a:	00096003          	.insn	4, 0x00096003
     17e:	0100                	.insn	2, 0x0100
     180:	2905                	.insn	2, 0x2905
     182:	0306                	.insn	2, 0x0306
     184:	0900                	.insn	2, 0x0900
     186:	0000                	.insn	2, 0x
     188:	0501                	.insn	2, 0x0501
     18a:	0301                	.insn	2, 0x0301
     18c:	0922                	.insn	2, 0x0922
     18e:	0008                	.insn	2, 0x0008
     190:	0501                	.insn	2, 0x0501
     192:	0640                	.insn	2, 0x0640
     194:	04092803          	lw	a6,64(s2)
     198:	0100                	.insn	2, 0x0100
     19a:	1f05                	.insn	2, 0x1f05
     19c:	0306                	.insn	2, 0x0306
     19e:	0904                	.insn	2, 0x0904
     1a0:	0034                	.insn	2, 0x0034
     1a2:	0501                	.insn	2, 0x0501
     1a4:	0340                	.insn	2, 0x0340
     1a6:	097c                	.insn	2, 0x097c
     1a8:	0004                	.insn	2, 0x0004
     1aa:	0501                	.insn	2, 0x0501
     1ac:	0605                	.insn	2, 0x0605
     1ae:	14090103          	lb	sp,320(s2)
     1b2:	0100                	.insn	2, 0x0100
     1b4:	00090303          	lb	t1,0(s2)
     1b8:	0100                	.insn	2, 0x0100
     1ba:	4005                	.insn	2, 0x4005
     1bc:	0306                	.insn	2, 0x0306
     1be:	097c                	.insn	2, 0x097c
     1c0:	0000                	.insn	2, 0x
     1c2:	0501                	.insn	2, 0x0501
     1c4:	0308                	.insn	2, 0x0308
     1c6:	0904                	.insn	2, 0x0904
     1c8:	0008                	.insn	2, 0x0008
     1ca:	0501                	.insn	2, 0x0501
     1cc:	0020                	.insn	2, 0x0020
     1ce:	0402                	.insn	2, 0x0402
     1d0:	0601                	.insn	2, 0x0601
     1d2:	04090103          	lb	sp,64(s2)
     1d6:	0100                	.insn	2, 0x0100
     1d8:	0d05                	.insn	2, 0x0d05
     1da:	10090103          	lb	sp,256(s2)
     1de:	0100                	.insn	2, 0x0100
     1e0:	2a05                	.insn	2, 0x2a05
     1e2:	0200                	.insn	2, 0x0200
     1e4:	0304                	.insn	2, 0x0304
     1e6:	18097f03          	.insn	4, 0x18097f03
     1ea:	0100                	.insn	2, 0x0100
     1ec:	2005                	.insn	2, 0x2005
     1ee:	0200                	.insn	2, 0x0200
     1f0:	0104                	.insn	2, 0x0104
     1f2:	00090003          	lb	zero,0(s2)
     1f6:	0100                	.insn	2, 0x0100
     1f8:	0c05                	.insn	2, 0x0c05
     1fa:	04090603          	lb	a2,64(s2)
     1fe:	0100                	.insn	2, 0x0100
     200:	0905                	.insn	2, 0x0905
     202:	0c090103          	lb	sp,192(s2)
     206:	0100                	.insn	2, 0x0100
     208:	0c05                	.insn	2, 0x0c05
     20a:	1c097f03          	.insn	4, 0x1c097f03
     20e:	0100                	.insn	2, 0x0100
     210:	0505                	.insn	2, 0x0505
     212:	04090503          	lb	a0,64(s2)
     216:	0100                	.insn	2, 0x0100
     218:	0f05                	.insn	2, 0x0f05
     21a:	0306                	.insn	2, 0x0306
     21c:	0900                	.insn	2, 0x0900
     21e:	0000                	.insn	2, 0x
     220:	0501                	.insn	2, 0x0501
     222:	0308                	.insn	2, 0x0308
     224:	0900                	.insn	2, 0x0900
     226:	0004                	.insn	2, 0x0004
     228:	0501                	.insn	2, 0x0501
     22a:	0620                	.insn	2, 0x0620
     22c:	04090103          	lb	sp,64(s2)
     230:	0100                	.insn	2, 0x0100
     232:	1405                	.insn	2, 0x1405
     234:	0306                	.insn	2, 0x0306
     236:	0900                	.insn	2, 0x0900
     238:	0000                	.insn	2, 0x
     23a:	0501                	.insn	2, 0x0501
     23c:	0320                	.insn	2, 0x0320
     23e:	0900                	.insn	2, 0x0900
     240:	0004                	.insn	2, 0x0004
     242:	0501                	.insn	2, 0x0501
     244:	060d                	.insn	2, 0x060d
     246:	04090103          	lb	sp,64(s2)
     24a:	0100                	.insn	2, 0x0100
     24c:	2005                	.insn	2, 0x2005
     24e:	0306                	.insn	2, 0x0306
     250:	097f 0010 0501 030d 	.insn	10, 0x0901030d05010010097f
     258:	0901 
     25a:	0004                	.insn	2, 0x0004
     25c:	0501                	.insn	2, 0x0501
     25e:	0620                	.insn	2, 0x0620
     260:	08097f03          	.insn	4, 0x08097f03
     264:	0100                	.insn	2, 0x0100
     266:	0105                	.insn	2, 0x0105
     268:	0306                	.insn	2, 0x0306
     26a:	0906                	.insn	2, 0x0906
     26c:	0004                	.insn	2, 0x0004
     26e:	0501                	.insn	2, 0x0501
     270:	060c                	.insn	2, 0x060c
     272:	38097403          	.insn	4, 0x38097403
     276:	0100                	.insn	2, 0x0100
     278:	10090003          	lb	zero,256(s2)
     27c:	0100                	.insn	2, 0x0100
     27e:	4205                	.insn	2, 0x4205
     280:	0900ca03          	lbu	s4,144(ra)
     284:	000c                	.insn	2, 0x000c
     286:	0501                	.insn	2, 0x0501
     288:	0305                	.insn	2, 0x0305
     28a:	0901                	.insn	2, 0x0901
     28c:	0000                	.insn	2, 0x
     28e:	0301                	.insn	2, 0x0301
     290:	0901                	.insn	2, 0x0901
     292:	0000                	.insn	2, 0x
     294:	0301                	.insn	2, 0x0301
     296:	00000903          	lb	s2,0(zero) # 0 <main-0x80000000>
     29a:	0501                	.insn	2, 0x0501
     29c:	0642                	.insn	2, 0x0642
     29e:	00097b03          	.insn	4, 0x00097b03
     2a2:	0100                	.insn	2, 0x0100
     2a4:	1105                	.insn	2, 0x1105
     2a6:	34090a03          	lb	s4,832(s2)
     2aa:	0100                	.insn	2, 0x0100
     2ac:	0805                	.insn	2, 0x0805
     2ae:	04097b03          	.insn	4, 0x04097b03
     2b2:	0100                	.insn	2, 0x0100
     2b4:	0505                	.insn	2, 0x0505
     2b6:	0306                	.insn	2, 0x0306
     2b8:	0905                	.insn	2, 0x0905
     2ba:	000c                	.insn	2, 0x000c
     2bc:	0501                	.insn	2, 0x0501
     2be:	4f03060f          	.insn	4, 0x4f03060f
     2c2:	0409                	.insn	2, 0x0409
     2c4:	0100                	.insn	2, 0x0100
     2c6:	1805                	.insn	2, 0x1805
     2c8:	0200                	.insn	2, 0x0200
     2ca:	0304                	.insn	2, 0x0304
     2cc:	0c093403          	.insn	4, 0x0c093403
     2d0:	0100                	.insn	2, 0x0100
     2d2:	2505                	.insn	2, 0x2505
     2d4:	04090203          	lb	tp,64(s2)
     2d8:	0100                	.insn	2, 0x0100
     2da:	1805                	.insn	2, 0x1805
     2dc:	08097e03          	.insn	4, 0x08097e03
     2e0:	0100                	.insn	2, 0x0100
     2e2:	0200                	.insn	2, 0x0200
     2e4:	0104                	.insn	2, 0x0104
     2e6:	04090403          	lb	s0,64(s2)
     2ea:	0100                	.insn	2, 0x0100
     2ec:	1305                	.insn	2, 0x1305
     2ee:	0c097f03          	.insn	4, 0x0c097f03
     2f2:	0100                	.insn	2, 0x0100
     2f4:	0905                	.insn	2, 0x0905
     2f6:	0306                	.insn	2, 0x0306
     2f8:	0004097b          	.insn	4, 0x0004097b
     2fc:	0501                	.insn	2, 0x0501
     2fe:	030d                	.insn	2, 0x030d
     300:	0901                	.insn	2, 0x0901
     302:	0000                	.insn	2, 0x
     304:	0501                	.insn	2, 0x0501
     306:	062d                	.insn	2, 0x062d
     308:	00090003          	lb	zero,0(s2)
     30c:	0100                	.insn	2, 0x0100
     30e:	1805                	.insn	2, 0x1805
     310:	04090003          	lb	zero,64(s2)
     314:	0100                	.insn	2, 0x0100
     316:	0d05                	.insn	2, 0x0d05
     318:	0306                	.insn	2, 0x0306
     31a:	0901                	.insn	2, 0x0901
     31c:	0004                	.insn	2, 0x0004
     31e:	0501                	.insn	2, 0x0501
     320:	0018                	.insn	2, 0x0018
     322:	0402                	.insn	2, 0x0402
     324:	0601                	.insn	2, 0x0601
     326:	00090003          	lb	zero,0(s2)
     32a:	0100                	.insn	2, 0x0100
     32c:	0200                	.insn	2, 0x0200
     32e:	0304                	.insn	2, 0x0304
     330:	04090003          	lb	zero,64(s2)
     334:	0100                	.insn	2, 0x0100
     336:	08090003          	lb	zero,128(s2)
     33a:	0100                	.insn	2, 0x0100
     33c:	0200                	.insn	2, 0x0200
     33e:	0104                	.insn	2, 0x0104
     340:	04090003          	lb	zero,64(s2)
     344:	0100                	.insn	2, 0x0100
     346:	1405                	.insn	2, 0x1405
     348:	0200                	.insn	2, 0x0200
     34a:	0204                	.insn	2, 0x0204
     34c:	04090003          	lb	zero,64(s2)
     350:	0100                	.insn	2, 0x0100
     352:	1805                	.insn	2, 0x1805
     354:	0200                	.insn	2, 0x0200
     356:	0204                	.insn	2, 0x0204
     358:	04090003          	lb	zero,64(s2)
     35c:	0100                	.insn	2, 0x0100
     35e:	0d05                	.insn	2, 0x0d05
     360:	0306                	.insn	2, 0x0306
     362:	00080903          	lb	s2,0(a6)
     366:	0501                	.insn	2, 0x0501
     368:	00030613          	addi	a2,t1,0
     36c:	0009                	.insn	2, 0x0009
     36e:	0100                	.insn	2, 0x0100
     370:	1805                	.insn	2, 0x1805
     372:	0306                	.insn	2, 0x0306
     374:	0901                	.insn	2, 0x0901
     376:	0004                	.insn	2, 0x0004
     378:	0501                	.insn	2, 0x0501
     37a:	0305                	.insn	2, 0x0305
     37c:	00040903          	lb	s2,0(s0)
     380:	0301                	.insn	2, 0x0301
     382:	7fb6                	.insn	2, 0x7fb6
     384:	0009                	.insn	2, 0x0009
     386:	0100                	.insn	2, 0x0100
     388:	1105                	.insn	2, 0x1105
     38a:	0306                	.insn	2, 0x0306
     38c:	0900                	.insn	2, 0x0900
     38e:	0000                	.insn	2, 0x
     390:	0501                	.insn	2, 0x0501
     392:	0308                	.insn	2, 0x0308
     394:	0900                	.insn	2, 0x0900
     396:	0004                	.insn	2, 0x0004
     398:	0501                	.insn	2, 0x0501
     39a:	0609                	.insn	2, 0x0609
     39c:	04090103          	lb	sp,64(s2)
     3a0:	0100                	.insn	2, 0x0100
     3a2:	0c05                	.insn	2, 0x0c05
     3a4:	0306                	.insn	2, 0x0306
     3a6:	0900                	.insn	2, 0x0900
     3a8:	0000                	.insn	2, 0x
     3aa:	0501                	.insn	2, 0x0501
     3ac:	001d                	.insn	2, 0x001d
     3ae:	0402                	.insn	2, 0x0402
     3b0:	0301                	.insn	2, 0x0301
     3b2:	0900                	.insn	2, 0x0900
     3b4:	0004                	.insn	2, 0x0004
     3b6:	0501                	.insn	2, 0x0501
     3b8:	04020013          	addi	zero,tp,64 # 40 <main-0x7fffffc0>
     3bc:	0301                	.insn	2, 0x0301
     3be:	0900                	.insn	2, 0x0900
     3c0:	0004                	.insn	2, 0x0004
     3c2:	0501                	.insn	2, 0x0501
     3c4:	002e                	.insn	2, 0x002e
     3c6:	0402                	.insn	2, 0x0402
     3c8:	0302                	.insn	2, 0x0302
     3ca:	0900                	.insn	2, 0x0900
     3cc:	0004                	.insn	2, 0x0004
     3ce:	0501                	.insn	2, 0x0501
     3d0:	060d                	.insn	2, 0x060d
     3d2:	04090203          	lb	tp,64(s2)
     3d6:	0100                	.insn	2, 0x0100
     3d8:	1205                	.insn	2, 0x1205
     3da:	0306                	.insn	2, 0x0306
     3dc:	0900                	.insn	2, 0x0900
     3de:	0004                	.insn	2, 0x0004
     3e0:	0501                	.insn	2, 0x0501
     3e2:	061d                	.insn	2, 0x061d
     3e4:	04090203          	lb	tp,64(s2)
     3e8:	0100                	.insn	2, 0x0100
     3ea:	2805                	.insn	2, 0x2805
     3ec:	0200                	.insn	2, 0x0200
     3ee:	0104                	.insn	2, 0x0104
     3f0:	0306                	.insn	2, 0x0306
     3f2:	00040903          	lb	s2,0(s0)
     3f6:	0501                	.insn	2, 0x0501
     3f8:	0605                	.insn	2, 0x0605
     3fa:	0c090703          	lb	a4,192(s2)
     3fe:	0100                	.insn	2, 0x0100
     400:	0805                	.insn	2, 0x0805
     402:	0306                	.insn	2, 0x0306
     404:	0900                	.insn	2, 0x0900
     406:	0000                	.insn	2, 0x
     408:	0501                	.insn	2, 0x0501
     40a:	0609                	.insn	2, 0x0609
     40c:	04090103          	lb	sp,64(s2)
     410:	0100                	.insn	2, 0x0100
     412:	0c05                	.insn	2, 0x0c05
     414:	0306                	.insn	2, 0x0306
     416:	0900                	.insn	2, 0x0900
     418:	0000                	.insn	2, 0x
     41a:	0501                	.insn	2, 0x0501
     41c:	0028                	.insn	2, 0x0028
     41e:	0402                	.insn	2, 0x0402
     420:	0301                	.insn	2, 0x0301
     422:	0900                	.insn	2, 0x0900
     424:	0004                	.insn	2, 0x0004
     426:	0501                	.insn	2, 0x0501
     428:	0609                	.insn	2, 0x0609
     42a:	04090703          	lb	a4,64(s2)
     42e:	0100                	.insn	2, 0x0100
     430:	0c05                	.insn	2, 0x0c05
     432:	0306                	.insn	2, 0x0306
     434:	0900                	.insn	2, 0x0900
     436:	0000                	.insn	2, 0x
     438:	0501                	.insn	2, 0x0501
     43a:	0610                	.insn	2, 0x0610
     43c:	08090603          	lb	a2,128(s2)
     440:	0100                	.insn	2, 0x0100
     442:	1305                	.insn	2, 0x1305
     444:	0306                	.insn	2, 0x0306
     446:	0900                	.insn	2, 0x0900
     448:	0000                	.insn	2, 0x
     44a:	0501                	.insn	2, 0x0501
     44c:	060d                	.insn	2, 0x060d
     44e:	08090403          	lb	s0,128(s2)
     452:	0100                	.insn	2, 0x0100
     454:	1805                	.insn	2, 0x1805
     456:	0306                	.insn	2, 0x0306
     458:	0900                	.insn	2, 0x0900
     45a:	0000                	.insn	2, 0x
     45c:	0501                	.insn	2, 0x0501
     45e:	0605                	.insn	2, 0x0605
     460:	08090403          	lb	s0,128(s2)
     464:	0100                	.insn	2, 0x0100
     466:	1805                	.insn	2, 0x1805
     468:	0306                	.insn	2, 0x0306
     46a:	097c                	.insn	2, 0x097c
     46c:	0000                	.insn	2, 0x
     46e:	0501                	.insn	2, 0x0501
     470:	0314                	.insn	2, 0x0314
     472:	0900                	.insn	2, 0x0900
     474:	0008                	.insn	2, 0x0008
     476:	0501                	.insn	2, 0x0501
     478:	0609                	.insn	2, 0x0609
     47a:	04090503          	lb	a0,64(s2)
     47e:	0100                	.insn	2, 0x0100
     480:	0c05                	.insn	2, 0x0c05
     482:	0306                	.insn	2, 0x0306
     484:	0900                	.insn	2, 0x0900
     486:	0000                	.insn	2, 0x
     488:	0501                	.insn	2, 0x0501
     48a:	060d                	.insn	2, 0x060d
     48c:	04090103          	lb	sp,64(s2)
     490:	0100                	.insn	2, 0x0100
     492:	1805                	.insn	2, 0x1805
     494:	0306                	.insn	2, 0x0306
     496:	0900                	.insn	2, 0x0900
     498:	0000                	.insn	2, 0x
     49a:	0501                	.insn	2, 0x0501
     49c:	0609                	.insn	2, 0x0609
     49e:	14091503          	lh	a0,320(s2)
     4a2:	0100                	.insn	2, 0x0100
     4a4:	0f05                	.insn	2, 0x0f05
     4a6:	0306                	.insn	2, 0x0306
     4a8:	0900                	.insn	2, 0x0900
     4aa:	0000                	.insn	2, 0x
     4ac:	0501                	.insn	2, 0x0501
     4ae:	0605                	.insn	2, 0x0605
     4b0:	04090403          	lb	s0,64(s2)
     4b4:	0100                	.insn	2, 0x0100
     4b6:	0805                	.insn	2, 0x0805
     4b8:	0306                	.insn	2, 0x0306
     4ba:	0900                	.insn	2, 0x0900
     4bc:	0000                	.insn	2, 0x
     4be:	0501                	.insn	2, 0x0501
     4c0:	097c030f          	.insn	4, 0x097c030f
     4c4:	0004                	.insn	2, 0x0004
     4c6:	0501                	.insn	2, 0x0501
     4c8:	0308                	.insn	2, 0x0308
     4ca:	0904                	.insn	2, 0x0904
     4cc:	0010                	.insn	2, 0x0010
     4ce:	0501                	.insn	2, 0x0501
     4d0:	0605                	.insn	2, 0x0605
     4d2:	14090a03          	lb	s4,320(s2)
     4d6:	0100                	.insn	2, 0x0100
     4d8:	097fb603          	.insn	4, 0x097fb603
     4dc:	0000                	.insn	2, 0x
     4de:	0501                	.insn	2, 0x0501
     4e0:	0611                	.insn	2, 0x0611
     4e2:	00090003          	lb	zero,0(s2)
     4e6:	0100                	.insn	2, 0x0100
     4e8:	0805                	.insn	2, 0x0805
     4ea:	04090003          	lb	zero,64(s2)
     4ee:	0100                	.insn	2, 0x0100
     4f0:	0905                	.insn	2, 0x0905
     4f2:	0306                	.insn	2, 0x0306
     4f4:	0901                	.insn	2, 0x0901
     4f6:	0004                	.insn	2, 0x0004
     4f8:	0501                	.insn	2, 0x0501
     4fa:	060c                	.insn	2, 0x060c
     4fc:	00090003          	lb	zero,0(s2)
     500:	0100                	.insn	2, 0x0100
     502:	1d05                	.insn	2, 0x1d05
     504:	0200                	.insn	2, 0x0200
     506:	0104                	.insn	2, 0x0104
     508:	04090003          	lb	zero,64(s2)
     50c:	0100                	.insn	2, 0x0100
     50e:	1305                	.insn	2, 0x1305
     510:	0200                	.insn	2, 0x0200
     512:	0104                	.insn	2, 0x0104
     514:	04090003          	lb	zero,64(s2)
     518:	0100                	.insn	2, 0x0100
     51a:	2e05                	.insn	2, 0x2e05
     51c:	0200                	.insn	2, 0x0200
     51e:	0204                	.insn	2, 0x0204
     520:	04090003          	lb	zero,64(s2)
     524:	0100                	.insn	2, 0x0100
     526:	0d05                	.insn	2, 0x0d05
     528:	0306                	.insn	2, 0x0306
     52a:	0902                	.insn	2, 0x0902
     52c:	0004                	.insn	2, 0x0004
     52e:	0501                	.insn	2, 0x0501
     530:	0612                	.insn	2, 0x0612
     532:	00090003          	lb	zero,0(s2)
     536:	0100                	.insn	2, 0x0100
     538:	1d05                	.insn	2, 0x1d05
     53a:	0306                	.insn	2, 0x0306
     53c:	0902                	.insn	2, 0x0902
     53e:	0004                	.insn	2, 0x0004
     540:	0501                	.insn	2, 0x0501
     542:	0028                	.insn	2, 0x0028
     544:	0402                	.insn	2, 0x0402
     546:	0601                	.insn	2, 0x0601
     548:	08090303          	lb	t1,128(s2)
     54c:	0100                	.insn	2, 0x0100
     54e:	0f05                	.insn	2, 0x0f05
     550:	04093403          	.insn	4, 0x04093403
     554:	0100                	.insn	2, 0x0100
     556:	2805                	.insn	2, 0x2805
     558:	0200                	.insn	2, 0x0200
     55a:	0104                	.insn	2, 0x0104
     55c:	04094c03          	lbu	s8,64(s2)
     560:	0100                	.insn	2, 0x0100
     562:	1105                	.insn	2, 0x1105
     564:	04093803          	.insn	4, 0x04093803
     568:	0100                	.insn	2, 0x0100
     56a:	0505                	.insn	2, 0x0505
     56c:	0306                	.insn	2, 0x0306
     56e:	090a                	.insn	2, 0x090a
     570:	0008                	.insn	2, 0x0008
     572:	0301                	.insn	2, 0x0301
     574:	7fb6                	.insn	2, 0x7fb6
     576:	0009                	.insn	2, 0x0009
     578:	0100                	.insn	2, 0x0100
     57a:	1105                	.insn	2, 0x1105
     57c:	0306                	.insn	2, 0x0306
     57e:	0900                	.insn	2, 0x0900
     580:	0000                	.insn	2, 0x
     582:	0501                	.insn	2, 0x0501
     584:	0308                	.insn	2, 0x0308
     586:	0900                	.insn	2, 0x0900
     588:	0004                	.insn	2, 0x0004
     58a:	0501                	.insn	2, 0x0501
     58c:	0609                	.insn	2, 0x0609
     58e:	04090103          	lb	sp,64(s2)
     592:	0100                	.insn	2, 0x0100
     594:	0c05                	.insn	2, 0x0c05
     596:	0306                	.insn	2, 0x0306
     598:	0900                	.insn	2, 0x0900
     59a:	0000                	.insn	2, 0x
     59c:	0501                	.insn	2, 0x0501
     59e:	061d                	.insn	2, 0x061d
     5a0:	04090403          	lb	s0,64(s2)
     5a4:	0100                	.insn	2, 0x0100
     5a6:	0200                	.insn	2, 0x0200
     5a8:	0104                	.insn	2, 0x0104
     5aa:	0306                	.insn	2, 0x0306
     5ac:	097c                	.insn	2, 0x097c
     5ae:	0008                	.insn	2, 0x0008
     5b0:	0001                	.insn	2, 0x0001
     5b2:	0402                	.insn	2, 0x0402
     5b4:	0301                	.insn	2, 0x0301
     5b6:	0904                	.insn	2, 0x0904
     5b8:	0008                	.insn	2, 0x0008
     5ba:	0501                	.insn	2, 0x0501
     5bc:	0318                	.insn	2, 0x0318
     5be:	0901                	.insn	2, 0x0901
     5c0:	0004                	.insn	2, 0x0004
     5c2:	0501                	.insn	2, 0x0501
     5c4:	060d                	.insn	2, 0x060d
     5c6:	04090003          	lb	zero,64(s2)
     5ca:	0100                	.insn	2, 0x0100
     5cc:	1d05                	.insn	2, 0x1d05
     5ce:	0200                	.insn	2, 0x0200
     5d0:	0104                	.insn	2, 0x0104
     5d2:	0306                	.insn	2, 0x0306
     5d4:	097f 0000 0501 0314 	.insn	10, 0x0901031405010000097f
     5dc:	0901 
     5de:	0004                	.insn	2, 0x0004
     5e0:	0501                	.insn	2, 0x0501
     5e2:	0318                	.insn	2, 0x0318
     5e4:	0900                	.insn	2, 0x0900
     5e6:	0004                	.insn	2, 0x0004
     5e8:	0501                	.insn	2, 0x0501
     5ea:	061d                	.insn	2, 0x061d
     5ec:	08097f03          	.insn	4, 0x08097f03
     5f0:	0100                	.insn	2, 0x0100
     5f2:	3905                	.insn	2, 0x3905
     5f4:	04090303          	lb	t1,64(s2)
     5f8:	0100                	.insn	2, 0x0100
     5fa:	2805                	.insn	2, 0x2805
     5fc:	0200                	.insn	2, 0x0200
     5fe:	0104                	.insn	2, 0x0104
     600:	0306                	.insn	2, 0x0306
     602:	0900                	.insn	2, 0x0900
     604:	0004                	.insn	2, 0x0004
     606:	0501                	.insn	2, 0x0501
     608:	0039                	.insn	2, 0x0039
     60a:	0402                	.insn	2, 0x0402
     60c:	0302                	.insn	2, 0x0302
     60e:	0900                	.insn	2, 0x0900
     610:	0004                	.insn	2, 0x0004
     612:	0501                	.insn	2, 0x0501
     614:	0318                	.insn	2, 0x0318
     616:	0902                	.insn	2, 0x0902
     618:	0004                	.insn	2, 0x0004
     61a:	0501                	.insn	2, 0x0501
     61c:	060d                	.insn	2, 0x060d
     61e:	04090003          	lb	zero,64(s2)
     622:	0100                	.insn	2, 0x0100
     624:	3905                	.insn	2, 0x3905
     626:	0200                	.insn	2, 0x0200
     628:	0204                	.insn	2, 0x0204
     62a:	0306                	.insn	2, 0x0306
     62c:	097e                	.insn	2, 0x097e
     62e:	0000                	.insn	2, 0x
     630:	0501                	.insn	2, 0x0501
     632:	0314                	.insn	2, 0x0314
     634:	0902                	.insn	2, 0x0902
     636:	0004                	.insn	2, 0x0004
     638:	0501                	.insn	2, 0x0501
     63a:	0318                	.insn	2, 0x0318
     63c:	0900                	.insn	2, 0x0900
     63e:	0004                	.insn	2, 0x0004
     640:	0501                	.insn	2, 0x0501
     642:	0639                	.insn	2, 0x0639
     644:	08097e03          	.insn	4, 0x08097e03
     648:	0100                	.insn	2, 0x0100
     64a:	2805                	.insn	2, 0x2805
     64c:	0200                	.insn	2, 0x0200
     64e:	0104                	.insn	2, 0x0104
     650:	0306                	.insn	2, 0x0306
     652:	0900                	.insn	2, 0x0900
     654:	0000                	.insn	2, 0x
     656:	0501                	.insn	2, 0x0501
     658:	0605                	.insn	2, 0x0605
     65a:	08090703          	lb	a4,128(s2)
     65e:	0100                	.insn	2, 0x0100
     660:	0805                	.insn	2, 0x0805
     662:	0306                	.insn	2, 0x0306
     664:	0900                	.insn	2, 0x0900
     666:	0000                	.insn	2, 0x
     668:	0501                	.insn	2, 0x0501
     66a:	061d                	.insn	2, 0x061d
     66c:	08097603          	.insn	4, 0x08097603
     670:	0100                	.insn	2, 0x0100
     672:	0505                	.insn	2, 0x0505
     674:	04090a03          	lb	s4,64(s2)
     678:	0100                	.insn	2, 0x0100
     67a:	0805                	.insn	2, 0x0805
     67c:	0306                	.insn	2, 0x0306
     67e:	0900                	.insn	2, 0x0900
     680:	0000                	.insn	2, 0x
     682:	0501                	.insn	2, 0x0501
     684:	0609                	.insn	2, 0x0609
     686:	04090103          	lb	sp,64(s2)
     68a:	0100                	.insn	2, 0x0100
     68c:	0c05                	.insn	2, 0x0c05
     68e:	0306                	.insn	2, 0x0306
     690:	0900                	.insn	2, 0x0900
     692:	0000                	.insn	2, 0x
     694:	0501                	.insn	2, 0x0501
     696:	0402002f          	.insn	4, 0x0402002f
     69a:	0302                	.insn	2, 0x0302
     69c:	0900                	.insn	2, 0x0900
     69e:	0008                	.insn	2, 0x0008
     6a0:	0501                	.insn	2, 0x0501
     6a2:	031c                	.insn	2, 0x031c
     6a4:	0901                	.insn	2, 0x0901
     6a6:	0008                	.insn	2, 0x0008
     6a8:	0501                	.insn	2, 0x0501
     6aa:	0609                	.insn	2, 0x0609
     6ac:	04090603          	lb	a2,64(s2)
     6b0:	0100                	.insn	2, 0x0100
     6b2:	0c05                	.insn	2, 0x0c05
     6b4:	0306                	.insn	2, 0x0306
     6b6:	0900                	.insn	2, 0x0900
     6b8:	0000                	.insn	2, 0x
     6ba:	0501                	.insn	2, 0x0501
     6bc:	0610                	.insn	2, 0x0610
     6be:	08090603          	lb	a2,128(s2)
     6c2:	0100                	.insn	2, 0x0100
     6c4:	1305                	.insn	2, 0x1305
     6c6:	0306                	.insn	2, 0x0306
     6c8:	0900                	.insn	2, 0x0900
     6ca:	0000                	.insn	2, 0x
     6cc:	0501                	.insn	2, 0x0501
     6ce:	0609                	.insn	2, 0x0609
     6d0:	08090303          	lb	t1,128(s2)
     6d4:	0100                	.insn	2, 0x0100
     6d6:	0c05                	.insn	2, 0x0c05
     6d8:	0306                	.insn	2, 0x0306
     6da:	0900                	.insn	2, 0x0900
     6dc:	0000                	.insn	2, 0x
     6de:	0501                	.insn	2, 0x0501
     6e0:	0314                	.insn	2, 0x0314
     6e2:	0901                	.insn	2, 0x0901
     6e4:	0008                	.insn	2, 0x0008
     6e6:	0501                	.insn	2, 0x0501
     6e8:	060d                	.insn	2, 0x060d
     6ea:	08090003          	lb	zero,128(s2)
     6ee:	0100                	.insn	2, 0x0100
     6f0:	1805                	.insn	2, 0x1805
     6f2:	0306                	.insn	2, 0x0306
     6f4:	0900                	.insn	2, 0x0900
     6f6:	0000                	.insn	2, 0x
     6f8:	0501                	.insn	2, 0x0501
     6fa:	0605                	.insn	2, 0x0605
     6fc:	10096e03          	.insn	4, 0x10096e03
     700:	0100                	.insn	2, 0x0100
     702:	0805                	.insn	2, 0x0805
     704:	0306                	.insn	2, 0x0306
     706:	0900                	.insn	2, 0x0900
     708:	0000                	.insn	2, 0x
     70a:	0501                	.insn	2, 0x0501
     70c:	0609                	.insn	2, 0x0609
     70e:	08090103          	lb	sp,128(s2)
     712:	0100                	.insn	2, 0x0100
     714:	0c05                	.insn	2, 0x0c05
     716:	0306                	.insn	2, 0x0306
     718:	0900                	.insn	2, 0x0900
     71a:	0000                	.insn	2, 0x
     71c:	0501                	.insn	2, 0x0501
     71e:	0402002f          	.insn	4, 0x0402002f
     722:	0302                	.insn	2, 0x0302
     724:	0900                	.insn	2, 0x0900
     726:	0004                	.insn	2, 0x0004
     728:	0501                	.insn	2, 0x0501
     72a:	031c                	.insn	2, 0x031c
     72c:	0901                	.insn	2, 0x0901
     72e:	0004                	.insn	2, 0x0004
     730:	0501                	.insn	2, 0x0501
     732:	0308                	.insn	2, 0x0308
     734:	097e                	.insn	2, 0x097e
     736:	0010                	.insn	2, 0x0010
     738:	0501                	.insn	2, 0x0501
     73a:	0605                	.insn	2, 0x0605
     73c:	04091603          	lh	a2,64(s2)
     740:	0100                	.insn	2, 0x0100
     742:	0805                	.insn	2, 0x0805
     744:	0306                	.insn	2, 0x0306
     746:	0900                	.insn	2, 0x0900
     748:	0000                	.insn	2, 0x
     74a:	0501                	.insn	2, 0x0501
     74c:	0605                	.insn	2, 0x0605
     74e:	08090a03          	lb	s4,128(s2)
     752:	0100                	.insn	2, 0x0100
     754:	0c05                	.insn	2, 0x0c05
     756:	0306                	.insn	2, 0x0306
     758:	0900                	.insn	2, 0x0900
     75a:	0000                	.insn	2, 0x
     75c:	0501                	.insn	2, 0x0501
     75e:	0301                	.insn	2, 0x0301
     760:	091d                	.insn	2, 0x091d
     762:	0004                	.insn	2, 0x0004
     764:	0501                	.insn	2, 0x0501
     766:	030c                	.insn	2, 0x030c
     768:	096c                	.insn	2, 0x096c
     76a:	0020                	.insn	2, 0x0020
     76c:	0501                	.insn	2, 0x0501
     76e:	0609                	.insn	2, 0x0609
     770:	08096e03          	.insn	4, 0x08096e03
     774:	0100                	.insn	2, 0x0100
     776:	0c05                	.insn	2, 0x0c05
     778:	0306                	.insn	2, 0x0306
     77a:	0900                	.insn	2, 0x0900
     77c:	0000                	.insn	2, 0x
     77e:	0501                	.insn	2, 0x0501
     780:	0610                	.insn	2, 0x0610
     782:	04090203          	lb	tp,64(s2)
     786:	0100                	.insn	2, 0x0100
     788:	1a05                	.insn	2, 0x1a05
     78a:	0306                	.insn	2, 0x0306
     78c:	0900                	.insn	2, 0x0900
     78e:	0000                	.insn	2, 0x
     790:	0501                	.insn	2, 0x0501
     792:	09000313          	addi	t1,zero,144
     796:	0004                	.insn	2, 0x0004
     798:	0501                	.insn	2, 0x0501
     79a:	060d                	.insn	2, 0x060d
     79c:	04090103          	lb	sp,64(s2)
     7a0:	0100                	.insn	2, 0x0100
     7a2:	1805                	.insn	2, 0x1805
     7a4:	0306                	.insn	2, 0x0306
     7a6:	0900                	.insn	2, 0x0900
     7a8:	0000                	.insn	2, 0x
     7aa:	0501                	.insn	2, 0x0501
     7ac:	0605                	.insn	2, 0x0605
     7ae:	2c096603          	.insn	4, 0x2c096603
     7b2:	0100                	.insn	2, 0x0100
     7b4:	0805                	.insn	2, 0x0805
     7b6:	0306                	.insn	2, 0x0306
     7b8:	0900                	.insn	2, 0x0900
     7ba:	0000                	.insn	2, 0x
     7bc:	0501                	.insn	2, 0x0501
     7be:	0609                	.insn	2, 0x0609
     7c0:	04090103          	lb	sp,64(s2)
     7c4:	0100                	.insn	2, 0x0100
     7c6:	0c05                	.insn	2, 0x0c05
     7c8:	0306                	.insn	2, 0x0306
     7ca:	0900                	.insn	2, 0x0900
     7cc:	0000                	.insn	2, 0x
     7ce:	0501                	.insn	2, 0x0501
     7d0:	0605                	.insn	2, 0x0605
     7d2:	0c097f03          	.insn	4, 0x0c097f03
     7d6:	0100                	.insn	2, 0x0100
     7d8:	0805                	.insn	2, 0x0805
     7da:	0306                	.insn	2, 0x0306
     7dc:	0900                	.insn	2, 0x0900
     7de:	0000                	.insn	2, 0x
     7e0:	0501                	.insn	2, 0x0501
     7e2:	0609                	.insn	2, 0x0609
     7e4:	08090103          	lb	sp,128(s2)
     7e8:	0100                	.insn	2, 0x0100
     7ea:	0c05                	.insn	2, 0x0c05
     7ec:	0306                	.insn	2, 0x0306
     7ee:	0900                	.insn	2, 0x0900
     7f0:	0000                	.insn	2, 0x
     7f2:	0501                	.insn	2, 0x0501
     7f4:	0402002f          	.insn	4, 0x0402002f
     7f8:	0302                	.insn	2, 0x0302
     7fa:	0900                	.insn	2, 0x0900
     7fc:	0004                	.insn	2, 0x0004
     7fe:	0501                	.insn	2, 0x0501
     800:	0310                	.insn	2, 0x0310
     802:	0902                	.insn	2, 0x0902
     804:	0004                	.insn	2, 0x0004
     806:	0501                	.insn	2, 0x0501
     808:	0015                	.insn	2, 0x0015
     80a:	0402                	.insn	2, 0x0402
     80c:	0301                	.insn	2, 0x0301
     80e:	0901                	.insn	2, 0x0901
     810:	0004                	.insn	2, 0x0004
     812:	0501                	.insn	2, 0x0501
     814:	0610                	.insn	2, 0x0610
     816:	08090703          	lb	a4,128(s2)
     81a:	0100                	.insn	2, 0x0100
     81c:	00090303          	lb	t1,0(s2)
     820:	0100                	.insn	2, 0x0100
     822:	1305                	.insn	2, 0x1305
     824:	0306                	.insn	2, 0x0306
     826:	0900                	.insn	2, 0x0900
     828:	0000                	.insn	2, 0x
     82a:	0501                	.insn	2, 0x0501
     82c:	0314                	.insn	2, 0x0314
     82e:	0904                	.insn	2, 0x0904
     830:	0008                	.insn	2, 0x0008
     832:	0501                	.insn	2, 0x0501
     834:	061d                	.insn	2, 0x061d
     836:	08096403          	.insn	4, 0x08096403
     83a:	0100                	.insn	2, 0x0100
     83c:	1005                	.insn	2, 0x1005
     83e:	0c092503          	lw	a0,192(s2)
     842:	0100                	.insn	2, 0x0100
     844:	1a05                	.insn	2, 0x1a05
     846:	0306                	.insn	2, 0x0306
     848:	0900                	.insn	2, 0x0900
     84a:	0000                	.insn	2, 0x
     84c:	0501                	.insn	2, 0x0501
     84e:	09000313          	addi	t1,zero,144
     852:	0004                	.insn	2, 0x0004
     854:	0501                	.insn	2, 0x0501
     856:	060d                	.insn	2, 0x060d
     858:	04090103          	lb	sp,64(s2)
     85c:	0100                	.insn	2, 0x0100
     85e:	1805                	.insn	2, 0x1805
     860:	0306                	.insn	2, 0x0306
     862:	0900                	.insn	2, 0x0900
     864:	0000                	.insn	2, 0x
     866:	0501                	.insn	2, 0x0501
     868:	0026                	.insn	2, 0x0026
     86a:	0402                	.insn	2, 0x0402
     86c:	0301                	.insn	2, 0x0301
     86e:	096c                	.insn	2, 0x096c
     870:	0018                	.insn	2, 0x0018
     872:	0501                	.insn	2, 0x0501
     874:	0039                	.insn	2, 0x0039
     876:	0402                	.insn	2, 0x0402
     878:	0302                	.insn	2, 0x0302
     87a:	0900                	.insn	2, 0x0900
     87c:	0004                	.insn	2, 0x0004
     87e:	0501                	.insn	2, 0x0501
     880:	0402001b          	.insn	4, 0x0402001b
     884:	0301                	.insn	2, 0x0301
     886:	0900                	.insn	2, 0x0900
     888:	0004                	.insn	2, 0x0004
     88a:	0501                	.insn	2, 0x0501
     88c:	0039                	.insn	2, 0x0039
     88e:	0402                	.insn	2, 0x0402
     890:	0302                	.insn	2, 0x0302
     892:	0900                	.insn	2, 0x0900
     894:	0004                	.insn	2, 0x0004
     896:	0501                	.insn	2, 0x0501
     898:	060d                	.insn	2, 0x060d
     89a:	04090203          	lb	tp,64(s2)
     89e:	0100                	.insn	2, 0x0100
     8a0:	1805                	.insn	2, 0x1805
     8a2:	0306                	.insn	2, 0x0306
     8a4:	0900                	.insn	2, 0x0900
     8a6:	0000                	.insn	2, 0x
     8a8:	0501                	.insn	2, 0x0501
     8aa:	0308                	.insn	2, 0x0308
     8ac:	0976                	.insn	2, 0x0976
     8ae:	0018                	.insn	2, 0x0018
     8b0:	0501                	.insn	2, 0x0501
     8b2:	0021                	.insn	2, 0x0021
     8b4:	0402                	.insn	2, 0x0402
     8b6:	0301                	.insn	2, 0x0301
     8b8:	090e                	.insn	2, 0x090e
     8ba:	0008                	.insn	2, 0x0008
     8bc:	0501                	.insn	2, 0x0501
     8be:	0314                	.insn	2, 0x0314
     8c0:	097f 0008 0501 060d 	.insn	10, 0x0203060d05010008097f
     8c8:	0203 
     8ca:	0809                	.insn	2, 0x0809
     8cc:	0100                	.insn	2, 0x0100
     8ce:	1805                	.insn	2, 0x1805
     8d0:	0306                	.insn	2, 0x0306
     8d2:	0900                	.insn	2, 0x0900
     8d4:	0000                	.insn	2, 0x
     8d6:	0501                	.insn	2, 0x0501
     8d8:	061d                	.insn	2, 0x061d
     8da:	10096703          	.insn	4, 0x10096703
     8de:	0100                	.insn	2, 0x0100
     8e0:	0f05                	.insn	2, 0x0f05
     8e2:	0306                	.insn	2, 0x0306
     8e4:	00040937          	lui	s2,0x40
     8e8:	0501                	.insn	2, 0x0501
     8ea:	031d                	.insn	2, 0x031d
     8ec:	0949                	.insn	2, 0x0949
     8ee:	0004                	.insn	2, 0x0004
     8f0:	0501                	.insn	2, 0x0501
     8f2:	0311                	.insn	2, 0x0311
     8f4:	0004093b          	.insn	4, 0x0004093b
     8f8:	0501                	.insn	2, 0x0501
     8fa:	030c                	.insn	2, 0x030c
     8fc:	0950                	.insn	2, 0x0950
     8fe:	0010                	.insn	2, 0x0010
     900:	0501                	.insn	2, 0x0501
     902:	0321                	.insn	2, 0x0321
     904:	0972                	.insn	2, 0x0972
     906:	0008                	.insn	2, 0x0008
     908:	0501                	.insn	2, 0x0501
     90a:	09000317          	auipc	t1,0x9000
     90e:	0008                	.insn	2, 0x0008
     910:	0501                	.insn	2, 0x0501
     912:	060d                	.insn	2, 0x060d
     914:	04090103          	lb	sp,64(s2) # 40040 <main-0x7ffbffc0>
     918:	0100                	.insn	2, 0x0100
     91a:	1205                	.insn	2, 0x1205
     91c:	0306                	.insn	2, 0x0306
     91e:	0900                	.insn	2, 0x0900
     920:	0000                	.insn	2, 0x
     922:	0501                	.insn	2, 0x0501
     924:	061d                	.insn	2, 0x061d
     926:	04090203          	lb	tp,64(s2)
     92a:	0100                	.insn	2, 0x0100
     92c:	1005                	.insn	2, 0x1005
     92e:	0c091503          	lh	a0,192(s2)
     932:	0100                	.insn	2, 0x0100
     934:	3f05                	.insn	2, 0x3f05
     936:	0200                	.insn	2, 0x0200
     938:	0204                	.insn	2, 0x0204
     93a:	0306                	.insn	2, 0x0306
     93c:	0900                	.insn	2, 0x0900
     93e:	0000                	.insn	2, 0x
     940:	0501                	.insn	2, 0x0501
     942:	060d                	.insn	2, 0x060d
     944:	04090203          	lb	tp,64(s2)
     948:	0100                	.insn	2, 0x0100
     94a:	1805                	.insn	2, 0x1805
     94c:	0306                	.insn	2, 0x0306
     94e:	0900                	.insn	2, 0x0900
     950:	0000                	.insn	2, 0x
     952:	0501                	.insn	2, 0x0501
     954:	061d                	.insn	2, 0x061d
     956:	24096903          	.insn	4, 0x24096903
     95a:	0100                	.insn	2, 0x0100
     95c:	0f05                	.insn	2, 0x0f05
     95e:	0306                	.insn	2, 0x0306
     960:	00040937          	lui	s2,0x40
     964:	0501                	.insn	2, 0x0501
     966:	031d                	.insn	2, 0x031d
     968:	0949                	.insn	2, 0x0949
     96a:	0004                	.insn	2, 0x0004
     96c:	0501                	.insn	2, 0x0501
     96e:	0311                	.insn	2, 0x0311
     970:	0004093b          	.insn	4, 0x0004093b
     974:	0501                	.insn	2, 0x0501
     976:	060d                	.insn	2, 0x060d
     978:	0c095203          	lhu	tp,192(s2) # 400c0 <main-0x7ffbff40>
     97c:	0100                	.insn	2, 0x0100
     97e:	1005                	.insn	2, 0x1005
     980:	0306                	.insn	2, 0x0306
     982:	0900                	.insn	2, 0x0900
     984:	0000                	.insn	2, 0x
     986:	0501                	.insn	2, 0x0501
     988:	060d                	.insn	2, 0x060d
     98a:	04090103          	lb	sp,64(s2)
     98e:	0100                	.insn	2, 0x0100
     990:	1005                	.insn	2, 0x1005
     992:	0306                	.insn	2, 0x0306
     994:	0900                	.insn	2, 0x0900
     996:	0000                	.insn	2, 0x
     998:	0501                	.insn	2, 0x0501
     99a:	0609                	.insn	2, 0x0609
     99c:	04090403          	lb	s0,64(s2)
     9a0:	0100                	.insn	2, 0x0100
     9a2:	0c05                	.insn	2, 0x0c05
     9a4:	0306                	.insn	2, 0x0306
     9a6:	0900                	.insn	2, 0x0900
     9a8:	0000                	.insn	2, 0x
     9aa:	0501                	.insn	2, 0x0501
     9ac:	0610                	.insn	2, 0x0610
     9ae:	08090603          	lb	a2,128(s2)
     9b2:	0100                	.insn	2, 0x0100
     9b4:	1305                	.insn	2, 0x1305
     9b6:	0306                	.insn	2, 0x0306
     9b8:	0900                	.insn	2, 0x0900
     9ba:	0000                	.insn	2, 0x
     9bc:	0501                	.insn	2, 0x0501
     9be:	060d                	.insn	2, 0x060d
     9c0:	08090403          	lb	s0,128(s2)
     9c4:	0100                	.insn	2, 0x0100
     9c6:	1805                	.insn	2, 0x1805
     9c8:	0306                	.insn	2, 0x0306
     9ca:	0900                	.insn	2, 0x0900
     9cc:	0000                	.insn	2, 0x
     9ce:	0501                	.insn	2, 0x0501
     9d0:	0605                	.insn	2, 0x0605
     9d2:	08090403          	lb	s0,128(s2)
     9d6:	0100                	.insn	2, 0x0100
     9d8:	1805                	.insn	2, 0x1805
     9da:	0306                	.insn	2, 0x0306
     9dc:	097c                	.insn	2, 0x097c
     9de:	0000                	.insn	2, 0x
     9e0:	0501                	.insn	2, 0x0501
     9e2:	0314                	.insn	2, 0x0314
     9e4:	0900                	.insn	2, 0x0900
     9e6:	0004                	.insn	2, 0x0004
     9e8:	0501                	.insn	2, 0x0501
     9ea:	097c0313          	addi	t1,s8,151
     9ee:	0008                	.insn	2, 0x0008
     9f0:	0501                	.insn	2, 0x0501
     9f2:	0605                	.insn	2, 0x0605
     9f4:	08097203          	.insn	4, 0x08097203
     9f8:	0100                	.insn	2, 0x0100
     9fa:	0805                	.insn	2, 0x0805
     9fc:	0306                	.insn	2, 0x0306
     9fe:	0900                	.insn	2, 0x0900
     a00:	0000                	.insn	2, 0x
     a02:	0501                	.insn	2, 0x0501
     a04:	0402001b          	.insn	4, 0x0402001b
     a08:	0301                	.insn	2, 0x0301
     a0a:	0908                	.insn	2, 0x0908
     a0c:	0010                	.insn	2, 0x0010
     a0e:	0501                	.insn	2, 0x0501
     a10:	0318                	.insn	2, 0x0318
     a12:	090a                	.insn	2, 0x090a
     a14:	0010                	.insn	2, 0x0010
     a16:	0301                	.insn	2, 0x0301
     a18:	0004097b          	.insn	4, 0x0004097b
     a1c:	0501                	.insn	2, 0x0501
     a1e:	060d                	.insn	2, 0x060d
     a20:	04090503          	lb	a0,64(s2)
     a24:	0100                	.insn	2, 0x0100
     a26:	1805                	.insn	2, 0x1805
     a28:	0306                	.insn	2, 0x0306
     a2a:	0900                	.insn	2, 0x0900
     a2c:	0000                	.insn	2, 0x
     a2e:	0501                	.insn	2, 0x0501
     a30:	0605                	.insn	2, 0x0605
     a32:	04090403          	lb	s0,64(s2)
     a36:	0100                	.insn	2, 0x0100
     a38:	1405                	.insn	2, 0x1405
     a3a:	0306                	.insn	2, 0x0306
     a3c:	097c                	.insn	2, 0x097c
     a3e:	0000                	.insn	2, 0x
     a40:	0501                	.insn	2, 0x0501
     a42:	060d                	.insn	2, 0x060d
     a44:	10097d03          	.insn	4, 0x10097d03
     a48:	0100                	.insn	2, 0x0100
     a4a:	0905                	.insn	2, 0x0905
     a4c:	00090203          	lb	tp,0(s2)
     a50:	0100                	.insn	2, 0x0100
     a52:	0d05                	.insn	2, 0x0d05
     a54:	00090103          	lb	sp,0(s2)
     a58:	0100                	.insn	2, 0x0100
     a5a:	1805                	.insn	2, 0x1805
     a5c:	0306                	.insn	2, 0x0306
     a5e:	097d                	.insn	2, 0x097d
     a60:	0000                	.insn	2, 0x
     a62:	0501                	.insn	2, 0x0501
     a64:	0605                	.insn	2, 0x0605
     a66:	0c090703          	lb	a4,192(s2)
     a6a:	0100                	.insn	2, 0x0100
     a6c:	1005                	.insn	2, 0x1005
     a6e:	0306                	.insn	2, 0x0306
     a70:	096d                	.insn	2, 0x096d
     a72:	0008                	.insn	2, 0x0008
     a74:	0501                	.insn	2, 0x0501
     a76:	0321                	.insn	2, 0x0321
     a78:	0970                	.insn	2, 0x0970
     a7a:	0008                	.insn	2, 0x0008
     a7c:	0501                	.insn	2, 0x0501
     a7e:	093a030f          	.insn	4, 0x093a030f
     a82:	0004                	.insn	2, 0x0004
     a84:	0501                	.insn	2, 0x0501
     a86:	09460317          	auipc	t1,0x9460
     a8a:	0004                	.insn	2, 0x0004
     a8c:	0501                	.insn	2, 0x0501
     a8e:	061d                	.insn	2, 0x061d
     a90:	04090303          	lb	t1,64(s2)
     a94:	0100                	.insn	2, 0x0100
     a96:	1105                	.insn	2, 0x1105
     a98:	0306                	.insn	2, 0x0306
     a9a:	0000093b          	.insn	4, 0x093b
     a9e:	0501                	.insn	2, 0x0501
     aa0:	031d                	.insn	2, 0x031d
     aa2:	0945                	.insn	2, 0x0945
     aa4:	0008                	.insn	2, 0x0008
     aa6:	0501                	.insn	2, 0x0501
     aa8:	0026                	.insn	2, 0x0026
     aaa:	0402                	.insn	2, 0x0402
     aac:	0301                	.insn	2, 0x0301
     aae:	0912                	.insn	2, 0x0912
     ab0:	0008                	.insn	2, 0x0008
     ab2:	0501                	.insn	2, 0x0501
     ab4:	0402001b          	.insn	4, 0x0402001b
     ab8:	0301                	.insn	2, 0x0301
     aba:	0900                	.insn	2, 0x0900
     abc:	0004                	.insn	2, 0x0004
     abe:	0501                	.insn	2, 0x0501
     ac0:	060d                	.insn	2, 0x060d
     ac2:	04090203          	lb	tp,64(s2)
     ac6:	0100                	.insn	2, 0x0100
     ac8:	0905                	.insn	2, 0x0905
     aca:	00090703          	lb	a4,0(s2)
     ace:	0100                	.insn	2, 0x0100
     ad0:	0d05                	.insn	2, 0x0d05
     ad2:	00090103          	lb	sp,0(s2)
     ad6:	0100                	.insn	2, 0x0100
     ad8:	1805                	.insn	2, 0x1805
     ada:	0306                	.insn	2, 0x0306
     adc:	0978                	.insn	2, 0x0978
     ade:	0000                	.insn	2, 0x
     ae0:	0501                	.insn	2, 0x0501
     ae2:	0605                	.insn	2, 0x0605
     ae4:	0c090c03          	lb	s8,192(s2)
     ae8:	0100                	.insn	2, 0x0100
     aea:	1405                	.insn	2, 0x1405
     aec:	0306                	.insn	2, 0x0306
     aee:	097c                	.insn	2, 0x097c
     af0:	0000                	.insn	2, 0x
     af2:	0501                	.insn	2, 0x0501
     af4:	0611                	.insn	2, 0x0611
     af6:	0c097303          	.insn	4, 0x0c097303
     afa:	0100                	.insn	2, 0x0100
     afc:	0905                	.insn	2, 0x0905
     afe:	00090303          	lb	t1,0(s2)
     b02:	0100                	.insn	2, 0x0100
     b04:	1405                	.insn	2, 0x1405
     b06:	0306                	.insn	2, 0x0306
     b08:	097d                	.insn	2, 0x097d
     b0a:	0000                	.insn	2, 0x
     b0c:	0501                	.insn	2, 0x0501
     b0e:	0026                	.insn	2, 0x0026
     b10:	0402                	.insn	2, 0x0402
     b12:	0301                	.insn	2, 0x0301
     b14:	00040903          	lb	s2,0(s0)
     b18:	0501                	.insn	2, 0x0501
     b1a:	0310                	.insn	2, 0x0310
     b1c:	0902                	.insn	2, 0x0902
     b1e:	0004                	.insn	2, 0x0004
     b20:	0501                	.insn	2, 0x0501
     b22:	0402001b          	.insn	4, 0x0402001b
     b26:	0301                	.insn	2, 0x0301
     b28:	097e                	.insn	2, 0x097e
     b2a:	0004                	.insn	2, 0x0004
     b2c:	0501                	.insn	2, 0x0501
     b2e:	060d                	.insn	2, 0x060d
     b30:	04090203          	lb	tp,64(s2)
     b34:	0100                	.insn	2, 0x0100
     b36:	1805                	.insn	2, 0x1805
     b38:	0306                	.insn	2, 0x0306
     b3a:	0900                	.insn	2, 0x0900
     b3c:	0000                	.insn	2, 0x
     b3e:	0501                	.insn	2, 0x0501
     b40:	0609                	.insn	2, 0x0609
     b42:	08090703          	lb	a4,128(s2)
     b46:	0100                	.insn	2, 0x0100
     b48:	1405                	.insn	2, 0x1405
     b4a:	0306                	.insn	2, 0x0306
     b4c:	0901                	.insn	2, 0x0901
     b4e:	0000                	.insn	2, 0x
     b50:	0501                	.insn	2, 0x0501
     b52:	060d                	.insn	2, 0x060d
     b54:	08097d03          	.insn	4, 0x08097d03
     b58:	0100                	.insn	2, 0x0100
     b5a:	0905                	.insn	2, 0x0905
     b5c:	00090203          	lb	tp,0(s2)
     b60:	0100                	.insn	2, 0x0100
     b62:	0d05                	.insn	2, 0x0d05
     b64:	00090103          	lb	sp,0(s2)
     b68:	0100                	.insn	2, 0x0100
     b6a:	1805                	.insn	2, 0x1805
     b6c:	0306                	.insn	2, 0x0306
     b6e:	097d                	.insn	2, 0x097d
     b70:	0000                	.insn	2, 0x
     b72:	0501                	.insn	2, 0x0501
     b74:	0605                	.insn	2, 0x0605
     b76:	0c090703          	lb	a4,192(s2)
     b7a:	0100                	.insn	2, 0x0100
     b7c:	1705                	.insn	2, 0x1705
     b7e:	0306                	.insn	2, 0x0306
     b80:	095d                	.insn	2, 0x095d
     b82:	0004                	.insn	2, 0x0004
     b84:	0501                	.insn	2, 0x0501
     b86:	0311                	.insn	2, 0x0311
     b88:	093e                	.insn	2, 0x093e
     b8a:	0004                	.insn	2, 0x0004
     b8c:	0501                	.insn	2, 0x0501
     b8e:	060d                	.insn	2, 0x060d
     b90:	08094303          	lbu	t1,128(s2)
     b94:	0100                	.insn	2, 0x0100
     b96:	1205                	.insn	2, 0x1205
     b98:	0306                	.insn	2, 0x0306
     b9a:	0900                	.insn	2, 0x0900
     b9c:	0000                	.insn	2, 0x
     b9e:	0501                	.insn	2, 0x0501
     ba0:	060d                	.insn	2, 0x060d
     ba2:	08091903          	lh	s2,128(s2)
     ba6:	0100                	.insn	2, 0x0100
     ba8:	1805                	.insn	2, 0x1805
     baa:	0306                	.insn	2, 0x0306
     bac:	0900                	.insn	2, 0x0900
     bae:	0000                	.insn	2, 0x
     bb0:	0501                	.insn	2, 0x0501
     bb2:	0609                	.insn	2, 0x0609
     bb4:	08090403          	lb	s0,128(s2)
     bb8:	0100                	.insn	2, 0x0100
     bba:	1405                	.insn	2, 0x1405
     bbc:	0306                	.insn	2, 0x0306
     bbe:	0901                	.insn	2, 0x0901
     bc0:	0000                	.insn	2, 0x
     bc2:	0501                	.insn	2, 0x0501
     bc4:	0610                	.insn	2, 0x0610
     bc6:	08097903          	.insn	4, 0x08097903
     bca:	0100                	.insn	2, 0x0100
     bcc:	0d05                	.insn	2, 0x0d05
     bce:	00090203          	lb	tp,0(s2)
     bd2:	0100                	.insn	2, 0x0100
     bd4:	0905                	.insn	2, 0x0905
     bd6:	00090403          	lb	s0,0(s2)
     bda:	0100                	.insn	2, 0x0100
     bdc:	0d05                	.insn	2, 0x0d05
     bde:	00090103          	lb	sp,0(s2)
     be2:	0100                	.insn	2, 0x0100
     be4:	1805                	.insn	2, 0x1805
     be6:	0306                	.insn	2, 0x0306
     be8:	0000097b          	.insn	4, 0x097b
     bec:	0501                	.insn	2, 0x0501
     bee:	0605                	.insn	2, 0x0605
     bf0:	0c090903          	lb	s2,192(s2)
     bf4:	0100                	.insn	2, 0x0100
     bf6:	0805                	.insn	2, 0x0805
     bf8:	0306                	.insn	2, 0x0306
     bfa:	096a                	.insn	2, 0x096a
     bfc:	000c                	.insn	2, 0x000c
     bfe:	0501                	.insn	2, 0x0501
     c00:	0609                	.insn	2, 0x0609
     c02:	04090103          	lb	sp,64(s2)
     c06:	0100                	.insn	2, 0x0100
     c08:	0805                	.insn	2, 0x0805
     c0a:	0306                	.insn	2, 0x0306
     c0c:	097f 0000 0501 030c 	.insn	10, 0x0901030c05010000097f
     c14:	0901 
     c16:	0008                	.insn	2, 0x0008
     c18:	0501                	.insn	2, 0x0501
     c1a:	062c                	.insn	2, 0x062c
     c1c:	097fad03          	lw	s10,151(t6)
     c20:	0014                	.insn	2, 0x0014
     c22:	0501                	.insn	2, 0x0501
     c24:	0305                	.insn	2, 0x0305
     c26:	0901                	.insn	2, 0x0901
     c28:	0000                	.insn	2, 0x
     c2a:	0301                	.insn	2, 0x0301
     c2c:	0901                	.insn	2, 0x0901
     c2e:	0000                	.insn	2, 0x
     c30:	0301                	.insn	2, 0x0301
     c32:	0901                	.insn	2, 0x0901
     c34:	0000                	.insn	2, 0x
     c36:	0501                	.insn	2, 0x0501
     c38:	0608                	.insn	2, 0x0608
     c3a:	00090003          	lb	zero,0(s2)
     c3e:	0100                	.insn	2, 0x0100
     c40:	0905                	.insn	2, 0x0905
     c42:	0306                	.insn	2, 0x0306
     c44:	0902                	.insn	2, 0x0902
     c46:	0004                	.insn	2, 0x0004
     c48:	0501                	.insn	2, 0x0501
     c4a:	060a                	.insn	2, 0x060a
     c4c:	00090003          	lb	zero,0(s2)
     c50:	0100                	.insn	2, 0x0100
     c52:	0105                	.insn	2, 0x0105
     c54:	0c090303          	lb	t1,192(s2)
     c58:	0100                	.insn	2, 0x0100
     c5a:	2905                	.insn	2, 0x2905
     c5c:	0306                	.insn	2, 0x0306
     c5e:	01b5                	.insn	2, 0x01b5
     c60:	0409                	.insn	2, 0x0409
     c62:	0100                	.insn	2, 0x0100
     c64:	0505                	.insn	2, 0x0505
     c66:	00090103          	lb	sp,0(s2)
     c6a:	0100                	.insn	2, 0x0100
     c6c:	00090103          	lb	sp,0(s2)
     c70:	0100                	.insn	2, 0x0100
     c72:	00090103          	lb	sp,0(s2)
     c76:	0100                	.insn	2, 0x0100
     c78:	00090303          	lb	t1,0(s2)
     c7c:	0100                	.insn	2, 0x0100
     c7e:	00090503          	lb	a0,0(s2)
     c82:	0100                	.insn	2, 0x0100
     c84:	2905                	.insn	2, 0x2905
     c86:	0306                	.insn	2, 0x0306
     c88:	0975                	.insn	2, 0x0975
     c8a:	0000                	.insn	2, 0x
     c8c:	0501                	.insn	2, 0x0501
     c8e:	0308                	.insn	2, 0x0308
     c90:	0018090b          	.insn	4, 0x0018090b
     c94:	0501                	.insn	2, 0x0501
     c96:	0329                	.insn	2, 0x0329
     c98:	0975                	.insn	2, 0x0975
     c9a:	0004                	.insn	2, 0x0004
     c9c:	0501                	.insn	2, 0x0501
     c9e:	0308                	.insn	2, 0x0308
     ca0:	0030090b          	.insn	4, 0x0030090b
     ca4:	0501                	.insn	2, 0x0501
     ca6:	0605                	.insn	2, 0x0605
     ca8:	04090203          	lb	tp,64(s2)
     cac:	0100                	.insn	2, 0x0100
     cae:	0805                	.insn	2, 0x0805
     cb0:	0306                	.insn	2, 0x0306
     cb2:	0900                	.insn	2, 0x0900
     cb4:	0000                	.insn	2, 0x
     cb6:	0501                	.insn	2, 0x0501
     cb8:	0605                	.insn	2, 0x0605
     cba:	0c090203          	lb	tp,192(s2)
     cbe:	0100                	.insn	2, 0x0100
     cc0:	0805                	.insn	2, 0x0805
     cc2:	0306                	.insn	2, 0x0306
     cc4:	0900                	.insn	2, 0x0900
     cc6:	0000                	.insn	2, 0x
     cc8:	0501                	.insn	2, 0x0501
     cca:	0605                	.insn	2, 0x0605
     ccc:	0c090803          	lb	a6,192(s2)
     cd0:	0100                	.insn	2, 0x0100
     cd2:	0805                	.insn	2, 0x0805
     cd4:	0306                	.insn	2, 0x0306
     cd6:	0900                	.insn	2, 0x0900
     cd8:	0000                	.insn	2, 0x
     cda:	0501                	.insn	2, 0x0501
     cdc:	0024                	.insn	2, 0x0024
     cde:	0402                	.insn	2, 0x0402
     ce0:	0301                	.insn	2, 0x0301
     ce2:	0900                	.insn	2, 0x0900
     ce4:	000c                	.insn	2, 0x000c
     ce6:	0501                	.insn	2, 0x0501
     ce8:	0605                	.insn	2, 0x0605
     cea:	0c090903          	lb	s2,192(s2)
     cee:	0100                	.insn	2, 0x0100
     cf0:	00090103          	lb	sp,0(s2)
     cf4:	0100                	.insn	2, 0x0100
     cf6:	0805                	.insn	2, 0x0805
     cf8:	0306                	.insn	2, 0x0306
     cfa:	0900                	.insn	2, 0x0900
     cfc:	0000                	.insn	2, 0x
     cfe:	0501                	.insn	2, 0x0501
     d00:	030a                	.insn	2, 0x030a
     d02:	097f 0004 0501 0308 	.insn	10, 0x0901030805010004097f
     d0a:	0901 
     d0c:	0004                	.insn	2, 0x0004
     d0e:	0501                	.insn	2, 0x0501
     d10:	0605                	.insn	2, 0x0605
     d12:	08090603          	lb	a2,128(s2)
     d16:	0100                	.insn	2, 0x0100
     d18:	1105                	.insn	2, 0x1105
     d1a:	0306                	.insn	2, 0x0306
     d1c:	0900                	.insn	2, 0x0900
     d1e:	0000                	.insn	2, 0x
     d20:	0501                	.insn	2, 0x0501
     d22:	0308                	.insn	2, 0x0308
     d24:	0900                	.insn	2, 0x0900
     d26:	0004                	.insn	2, 0x0004
     d28:	0501                	.insn	2, 0x0501
     d2a:	030e                	.insn	2, 0x030e
     d2c:	0901                	.insn	2, 0x0901
     d2e:	0004                	.insn	2, 0x0004
     d30:	0501                	.insn	2, 0x0501
     d32:	062c                	.insn	2, 0x062c
     d34:	04090303          	lb	t1,64(s2)
     d38:	0100                	.insn	2, 0x0100
     d3a:	0e05                	.insn	2, 0x0e05
     d3c:	0306                	.insn	2, 0x0306
     d3e:	097d                	.insn	2, 0x097d
     d40:	000c                	.insn	2, 0x000c
     d42:	0501                	.insn	2, 0x0501
     d44:	002c                	.insn	2, 0x002c
     d46:	0402                	.insn	2, 0x0402
     d48:	0301                	.insn	2, 0x0301
     d4a:	00040903          	lb	s2,0(s0)
     d4e:	0501                	.insn	2, 0x0501
     d50:	0314                	.insn	2, 0x0314
     d52:	0901                	.insn	2, 0x0901
     d54:	0004                	.insn	2, 0x0004
     d56:	0501                	.insn	2, 0x0501
     d58:	0609                	.insn	2, 0x0609
     d5a:	04090003          	lb	zero,64(s2)
     d5e:	0100                	.insn	2, 0x0100
     d60:	2c05                	.insn	2, 0x2c05
     d62:	0200                	.insn	2, 0x0200
     d64:	0104                	.insn	2, 0x0104
     d66:	0306                	.insn	2, 0x0306
     d68:	097f 0000 0501 0314 	.insn	10, 0x0901031405010000097f
     d70:	0901 
     d72:	0004                	.insn	2, 0x0004
     d74:	0501                	.insn	2, 0x0501
     d76:	0609                	.insn	2, 0x0609
     d78:	04090103          	lb	sp,64(s2)
     d7c:	0100                	.insn	2, 0x0100
     d7e:	0d05                	.insn	2, 0x0d05
     d80:	0306                	.insn	2, 0x0306
     d82:	0900                	.insn	2, 0x0900
     d84:	0000                	.insn	2, 0x
     d86:	0501                	.insn	2, 0x0501
     d88:	062c                	.insn	2, 0x062c
     d8a:	04097e03          	.insn	4, 0x04097e03
     d8e:	0100                	.insn	2, 0x0100
     d90:	0505                	.insn	2, 0x0505
     d92:	0c090503          	lb	a0,192(s2)
     d96:	0100                	.insn	2, 0x0100
     d98:	0905                	.insn	2, 0x0905
     d9a:	0306                	.insn	2, 0x0306
     d9c:	0900                	.insn	2, 0x0900
     d9e:	0000                	.insn	2, 0x
     da0:	0501                	.insn	2, 0x0501
     da2:	0605                	.insn	2, 0x0605
     da4:	04090103          	lb	sp,64(s2)
     da8:	0100                	.insn	2, 0x0100
     daa:	2905                	.insn	2, 0x2905
     dac:	0306                	.insn	2, 0x0306
     dae:	0900                	.insn	2, 0x0900
     db0:	0000                	.insn	2, 0x
     db2:	0501                	.insn	2, 0x0501
     db4:	0319                	.insn	2, 0x0319
     db6:	0900                	.insn	2, 0x0900
     db8:	0008                	.insn	2, 0x0008
     dba:	0501                	.insn	2, 0x0501
     dbc:	0329                	.insn	2, 0x0329
     dbe:	0900                	.insn	2, 0x0900
     dc0:	0004                	.insn	2, 0x0004
     dc2:	0501                	.insn	2, 0x0501
     dc4:	0319                	.insn	2, 0x0319
     dc6:	0900                	.insn	2, 0x0900
     dc8:	0008                	.insn	2, 0x0008
     dca:	0501                	.insn	2, 0x0501
     dcc:	0329                	.insn	2, 0x0329
     dce:	0900                	.insn	2, 0x0900
     dd0:	0004                	.insn	2, 0x0004
     dd2:	0501                	.insn	2, 0x0501
     dd4:	0308                	.insn	2, 0x0308
     dd6:	0904                	.insn	2, 0x0904
     dd8:	0004                	.insn	2, 0x0004
     dda:	0501                	.insn	2, 0x0501
     ddc:	030c                	.insn	2, 0x030c
     dde:	097c                	.insn	2, 0x097c
     de0:	0004                	.insn	2, 0x0004
     de2:	0501                	.insn	2, 0x0501
     de4:	0605                	.insn	2, 0x0605
     de6:	04090103          	lb	sp,64(s2)
     dea:	0100                	.insn	2, 0x0100
     dec:	1305                	.insn	2, 0x1305
     dee:	0306                	.insn	2, 0x0306
     df0:	0900                	.insn	2, 0x0900
     df2:	0000                	.insn	2, 0x
     df4:	0501                	.insn	2, 0x0501
     df6:	0605                	.insn	2, 0x0605
     df8:	04090103          	lb	sp,64(s2)
     dfc:	0100                	.insn	2, 0x0100
     dfe:	1005                	.insn	2, 0x1005
     e00:	0306                	.insn	2, 0x0306
     e02:	0900                	.insn	2, 0x0900
     e04:	0000                	.insn	2, 0x
     e06:	0501                	.insn	2, 0x0501
     e08:	030a                	.insn	2, 0x030a
     e0a:	0900                	.insn	2, 0x0900
     e0c:	0004                	.insn	2, 0x0004
     e0e:	0501                	.insn	2, 0x0501
     e10:	0605                	.insn	2, 0x0605
     e12:	04090203          	lb	tp,64(s2)
     e16:	0100                	.insn	2, 0x0100
     e18:	0805                	.insn	2, 0x0805
     e1a:	0306                	.insn	2, 0x0306
     e1c:	0900                	.insn	2, 0x0900
     e1e:	0000                	.insn	2, 0x
     e20:	0501                	.insn	2, 0x0501
     e22:	0609                	.insn	2, 0x0609
     e24:	08090103          	lb	sp,128(s2)
     e28:	0100                	.insn	2, 0x0100
     e2a:	04090203          	lb	tp,64(s2)
     e2e:	0100                	.insn	2, 0x0100
     e30:	1205                	.insn	2, 0x1205
     e32:	0306                	.insn	2, 0x0306
     e34:	0900                	.insn	2, 0x0900
     e36:	0000                	.insn	2, 0x
     e38:	0501                	.insn	2, 0x0501
     e3a:	030c                	.insn	2, 0x030c
     e3c:	0900                	.insn	2, 0x0900
     e3e:	0004                	.insn	2, 0x0004
     e40:	0501                	.insn	2, 0x0501
     e42:	060d                	.insn	2, 0x060d
     e44:	08090103          	lb	sp,128(s2)
     e48:	0100                	.insn	2, 0x0100
     e4a:	00090103          	lb	sp,0(s2)
     e4e:	0100                	.insn	2, 0x0100
     e50:	1205                	.insn	2, 0x1205
     e52:	0306                	.insn	2, 0x0306
     e54:	097f 0004 0501 0605 	.insn	10, 0x0903060505010004097f
     e5c:	0903 
     e5e:	0409                	.insn	2, 0x0409
     e60:	0100                	.insn	2, 0x0100
     e62:	0805                	.insn	2, 0x0805
     e64:	0306                	.insn	2, 0x0306
     e66:	0900                	.insn	2, 0x0900
     e68:	0000                	.insn	2, 0x
     e6a:	0501                	.insn	2, 0x0501
     e6c:	032d                	.insn	2, 0x032d
     e6e:	090c                	.insn	2, 0x090c
     e70:	0004                	.insn	2, 0x0004
     e72:	0501                	.insn	2, 0x0501
     e74:	0314                	.insn	2, 0x0314
     e76:	097e                	.insn	2, 0x097e
     e78:	0008                	.insn	2, 0x0008
     e7a:	0501                	.insn	2, 0x0501
     e7c:	0310                	.insn	2, 0x0310
     e7e:	00040903          	lb	s2,0(s0)
     e82:	0501                	.insn	2, 0x0501
     e84:	060d                	.insn	2, 0x060d
     e86:	04097e03          	.insn	4, 0x04097e03
     e8a:	0100                	.insn	2, 0x0100
     e8c:	1405                	.insn	2, 0x1405
     e8e:	00097f03          	.insn	4, 0x00097f03
     e92:	0100                	.insn	2, 0x0100
     e94:	2d05                	.insn	2, 0x2d05
     e96:	0306                	.insn	2, 0x0306
     e98:	0902                	.insn	2, 0x0902
     e9a:	0004                	.insn	2, 0x0004
     e9c:	0501                	.insn	2, 0x0501
     e9e:	0314                	.insn	2, 0x0314
     ea0:	0900                	.insn	2, 0x0900
     ea2:	0004                	.insn	2, 0x0004
     ea4:	0501                	.insn	2, 0x0501
     ea6:	0318                	.insn	2, 0x0318
     ea8:	0900                	.insn	2, 0x0900
     eaa:	0004                	.insn	2, 0x0004
     eac:	0501                	.insn	2, 0x0501
     eae:	030d                	.insn	2, 0x030d
     eb0:	097f 0004 0601 0103 	.insn	10, 0x0409010306010004097f
     eb8:	0409 
     eba:	0100                	.insn	2, 0x0100
     ebc:	2d05                	.insn	2, 0x2d05
     ebe:	0306                	.insn	2, 0x0306
     ec0:	0900                	.insn	2, 0x0900
     ec2:	0000                	.insn	2, 0x
     ec4:	0501                	.insn	2, 0x0501
     ec6:	031a                	.insn	2, 0x031a
     ec8:	0900                	.insn	2, 0x0900
     eca:	0014                	.insn	2, 0x0014
     ecc:	0501                	.insn	2, 0x0501
     ece:	0318                	.insn	2, 0x0318
     ed0:	0900                	.insn	2, 0x0900
     ed2:	0004                	.insn	2, 0x0004
     ed4:	0501                	.insn	2, 0x0501
     ed6:	060d                	.insn	2, 0x060d
     ed8:	04090103          	lb	sp,64(s2)
     edc:	0100                	.insn	2, 0x0100
     ede:	1005                	.insn	2, 0x1005
     ee0:	0306                	.insn	2, 0x0306
     ee2:	0900                	.insn	2, 0x0900
     ee4:	0000                	.insn	2, 0x
     ee6:	0501                	.insn	2, 0x0501
     ee8:	0318                	.insn	2, 0x0318
     eea:	0900                	.insn	2, 0x0900
     eec:	0004                	.insn	2, 0x0004
     eee:	0501                	.insn	2, 0x0501
     ef0:	0609                	.insn	2, 0x0609
     ef2:	08094103          	lbu	sp,128(s2)
     ef6:	0100                	.insn	2, 0x0100
     ef8:	2005                	.insn	2, 0x2005
     efa:	0306                	.insn	2, 0x0306
     efc:	0901                	.insn	2, 0x0901
     efe:	0000                	.insn	2, 0x
     f00:	0501                	.insn	2, 0x0501
     f02:	0310                	.insn	2, 0x0310
     f04:	097f 0004 0001 0402 	.insn	10, 0x0302040200010004097f
     f0c:	0302 
     f0e:	0900                	.insn	2, 0x0900
     f10:	0004                	.insn	2, 0x0004
     f12:	0001                	.insn	2, 0x0001
     f14:	0402                	.insn	2, 0x0402
     f16:	0306                	.insn	2, 0x0306
     f18:	0900                	.insn	2, 0x0900
     f1a:	0008                	.insn	2, 0x0008
     f1c:	0001                	.insn	2, 0x0001
     f1e:	0402                	.insn	2, 0x0402
     f20:	0308                	.insn	2, 0x0308
     f22:	0900                	.insn	2, 0x0900
     f24:	0004                	.insn	2, 0x0004
     f26:	0501                	.insn	2, 0x0501
     f28:	0301                	.insn	2, 0x0301
     f2a:	00ea                	.insn	2, 0x00ea
     f2c:	0409                	.insn	2, 0x0409
     f2e:	0100                	.insn	2, 0x0100
     f30:	1005                	.insn	2, 0x1005
     f32:	0200                	.insn	2, 0x0200
     f34:	0804                	.insn	2, 0x0804
     f36:	097f9603          	lh	a2,151(t6)
     f3a:	000c                	.insn	2, 0x000c
     f3c:	0501                	.insn	2, 0x0501
     f3e:	0301                	.insn	2, 0x0301
     f40:	00ea                	.insn	2, 0x00ea
     f42:	0809                	.insn	2, 0x0809
     f44:	0100                	.insn	2, 0x0100
     f46:	1005                	.insn	2, 0x1005
     f48:	0200                	.insn	2, 0x0200
     f4a:	0804                	.insn	2, 0x0804
     f4c:	097f9603          	lh	a2,151(t6)
     f50:	0008                	.insn	2, 0x0008
     f52:	0501                	.insn	2, 0x0501
     f54:	0301                	.insn	2, 0x0301
     f56:	00ea                	.insn	2, 0x00ea
     f58:	0809                	.insn	2, 0x0809
     f5a:	0100                	.insn	2, 0x0100
     f5c:	1005                	.insn	2, 0x1005
     f5e:	0200                	.insn	2, 0x0200
     f60:	0804                	.insn	2, 0x0804
     f62:	097f9603          	lh	a2,151(t6)
     f66:	0008                	.insn	2, 0x0008
     f68:	0501                	.insn	2, 0x0501
     f6a:	0301                	.insn	2, 0x0301
     f6c:	00ea                	.insn	2, 0x00ea
     f6e:	0409                	.insn	2, 0x0409
     f70:	0100                	.insn	2, 0x0100
     f72:	1005                	.insn	2, 0x1005
     f74:	0200                	.insn	2, 0x0200
     f76:	0804                	.insn	2, 0x0804
     f78:	097f9603          	lh	a2,151(t6)
     f7c:	0008                	.insn	2, 0x0008
     f7e:	0501                	.insn	2, 0x0501
     f80:	0609                	.insn	2, 0x0609
     f82:	10097c03          	.insn	4, 0x10097c03
     f86:	0100                	.insn	2, 0x0100
     f88:	0505                	.insn	2, 0x0505
     f8a:	097edc03          	lhu	s8,151(t4)
     f8e:	0000                	.insn	2, 0x
     f90:	0301                	.insn	2, 0x0301
     f92:	00000903          	lb	s2,0(zero) # 0 <main-0x80000000>
     f96:	0501                	.insn	2, 0x0501
     f98:	061f 0003 0009      	.insn	6, 0x00090003061f
     f9e:	0100                	.insn	2, 0x0100
     fa0:	0805                	.insn	2, 0x0805
     fa2:	08090003          	lb	zero,128(s2)
     fa6:	0100                	.insn	2, 0x0100
     fa8:	2005                	.insn	2, 0x2005
     faa:	0200                	.insn	2, 0x0200
     fac:	0104                	.insn	2, 0x0104
     fae:	0306                	.insn	2, 0x0306
     fb0:	0901                	.insn	2, 0x0901
     fb2:	0004                	.insn	2, 0x0004
     fb4:	0501                	.insn	2, 0x0501
     fb6:	030d                	.insn	2, 0x030d
     fb8:	0901                	.insn	2, 0x0901
     fba:	0014                	.insn	2, 0x0014
     fbc:	0501                	.insn	2, 0x0501
     fbe:	002a                	.insn	2, 0x002a
     fc0:	0402                	.insn	2, 0x0402
     fc2:	097f0303          	lb	t1,151(t5)
     fc6:	0018                	.insn	2, 0x0018
     fc8:	0501                	.insn	2, 0x0501
     fca:	0020                	.insn	2, 0x0020
     fcc:	0402                	.insn	2, 0x0402
     fce:	0301                	.insn	2, 0x0301
     fd0:	0900                	.insn	2, 0x0900
     fd2:	0000                	.insn	2, 0x
     fd4:	0501                	.insn	2, 0x0501
     fd6:	030c                	.insn	2, 0x030c
     fd8:	0906                	.insn	2, 0x0906
     fda:	0004                	.insn	2, 0x0004
     fdc:	0501                	.insn	2, 0x0501
     fde:	0020                	.insn	2, 0x0020
     fe0:	0402                	.insn	2, 0x0402
     fe2:	0601                	.insn	2, 0x0601
     fe4:	0c097a03          	.insn	4, 0x0c097a03
     fe8:	0100                	.insn	2, 0x0100
     fea:	0905                	.insn	2, 0x0905
     fec:	0306                	.insn	2, 0x0306
     fee:	00040907          	.insn	4, 0x00040907
     ff2:	0501                	.insn	2, 0x0501
     ff4:	060c                	.insn	2, 0x060c
     ff6:	10097f03          	.insn	4, 0x10097f03
     ffa:	0100                	.insn	2, 0x0100
     ffc:	0905                	.insn	2, 0x0905
     ffe:	04090103          	lb	sp,64(s2)
    1002:	0100                	.insn	2, 0x0100
    1004:	0c05                	.insn	2, 0x0c05
    1006:	0306                	.insn	2, 0x0306
    1008:	097f 0008 0501 060f 	.insn	10, 0x0503060f05010008097f
    1010:	0503 
    1012:	0409                	.insn	2, 0x0409
    1014:	0100                	.insn	2, 0x0100
    1016:	0505                	.insn	2, 0x0505
    1018:	0306                	.insn	2, 0x0306
    101a:	0900                	.insn	2, 0x0900
    101c:	0008                	.insn	2, 0x0008
    101e:	0501                	.insn	2, 0x0501
    1020:	0608                	.insn	2, 0x0608
    1022:	00090003          	lb	zero,0(s2)
    1026:	0100                	.insn	2, 0x0100
    1028:	2005                	.insn	2, 0x2005
    102a:	0306                	.insn	2, 0x0306
    102c:	0901                	.insn	2, 0x0901
    102e:	0004                	.insn	2, 0x0004
    1030:	0501                	.insn	2, 0x0501
    1032:	0614                	.insn	2, 0x0614
    1034:	00090003          	lb	zero,0(s2)
    1038:	0100                	.insn	2, 0x0100
    103a:	2005                	.insn	2, 0x2005
    103c:	04090003          	lb	zero,64(s2)
    1040:	0100                	.insn	2, 0x0100
    1042:	0d05                	.insn	2, 0x0d05
    1044:	0306                	.insn	2, 0x0306
    1046:	0901                	.insn	2, 0x0901
    1048:	0004                	.insn	2, 0x0004
    104a:	0501                	.insn	2, 0x0501
    104c:	0320                	.insn	2, 0x0320
    104e:	097f 0018 0501 0601 	.insn	10, 0x8203060105010018097f
    1056:	8203 
    1058:	0902                	.insn	2, 0x0902
    105a:	0014                	.insn	2, 0x0014
    105c:	0501                	.insn	2, 0x0501
    105e:	0010                	.insn	2, 0x0010
    1060:	0402                	.insn	2, 0x0402
    1062:	0301                	.insn	2, 0x0301
    1064:	7f96                	.insn	2, 0x7f96
    1066:	2c09                	.insn	2, 0x2c09
    1068:	0100                	.insn	2, 0x0100
    106a:	0200                	.insn	2, 0x0200
    106c:	0504                	.insn	2, 0x0504
    106e:	08090003          	lb	zero,128(s2)
    1072:	0100                	.insn	2, 0x0100
    1074:	0905                	.insn	2, 0x0905
    1076:	0306                	.insn	2, 0x0306
    1078:	0912                	.insn	2, 0x0912
    107a:	0008                	.insn	2, 0x0008
    107c:	0301                	.insn	2, 0x0301
    107e:	0901                	.insn	2, 0x0901
    1080:	0000                	.insn	2, 0x
    1082:	0501                	.insn	2, 0x0501
    1084:	0003060f          	.insn	4, 0x0003060f
    1088:	0009                	.insn	2, 0x0009
    108a:	0100                	.insn	2, 0x0100
    108c:	1205                	.insn	2, 0x1205
    108e:	04097f03          	.insn	4, 0x04097f03
    1092:	0100                	.insn	2, 0x0100
    1094:	0905                	.insn	2, 0x0905
    1096:	0306                	.insn	2, 0x0306
    1098:	00080977          	.insn	4, 0x00080977
    109c:	0501                	.insn	2, 0x0501
    109e:	0610                	.insn	2, 0x0610
    10a0:	00090003          	lb	zero,0(s2)
    10a4:	0100                	.insn	2, 0x0100
    10a6:	0105                	.insn	2, 0x0105
    10a8:	0900e103          	.insn	4, 0x0900e103
    10ac:	0008                	.insn	2, 0x0008
    10ae:	0501                	.insn	2, 0x0501
    10b0:	0310                	.insn	2, 0x0310
    10b2:	7f9f 0409 0100      	.insn	6, 0x010004097f9f
    10b8:	0105                	.insn	2, 0x0105
    10ba:	0900e103          	.insn	4, 0x0900e103
    10be:	000c                	.insn	2, 0x000c
    10c0:	0501                	.insn	2, 0x0501
    10c2:	0310                	.insn	2, 0x0310
    10c4:	7f9f 0c09 0100      	.insn	6, 0x01000c097f9f
    10ca:	0105                	.insn	2, 0x0105
    10cc:	0900e103          	.insn	4, 0x0900e103
    10d0:	0008                	.insn	2, 0x0008
    10d2:	0501                	.insn	2, 0x0501
    10d4:	0310                	.insn	2, 0x0310
    10d6:	7f9f 0809 0100      	.insn	6, 0x010008097f9f
    10dc:	0105                	.insn	2, 0x0105
    10de:	0900e103          	.insn	4, 0x0900e103
    10e2:	0008                	.insn	2, 0x0008
    10e4:	0501                	.insn	2, 0x0501
    10e6:	0310                	.insn	2, 0x0310
    10e8:	7f9f 0c09 0100      	.insn	6, 0x01000c097f9f
    10ee:	0905                	.insn	2, 0x0905
    10f0:	0306                	.insn	2, 0x0306
    10f2:	0975                	.insn	2, 0x0975
    10f4:	0010                	.insn	2, 0x0010
    10f6:	0501                	.insn	2, 0x0501
    10f8:	0305                	.insn	2, 0x0305
    10fa:	7eda                	.insn	2, 0x7eda
    10fc:	0009                	.insn	2, 0x0009
    10fe:	0100                	.insn	2, 0x0100
    1100:	00090303          	lb	t1,0(s2)
    1104:	0100                	.insn	2, 0x0100
    1106:	1f05                	.insn	2, 0x1f05
    1108:	0306                	.insn	2, 0x0306
    110a:	0900                	.insn	2, 0x0900
    110c:	0000                	.insn	2, 0x
    110e:	0501                	.insn	2, 0x0501
    1110:	0308                	.insn	2, 0x0308
    1112:	0900                	.insn	2, 0x0900
    1114:	0008                	.insn	2, 0x0008
    1116:	0501                	.insn	2, 0x0501
    1118:	0020                	.insn	2, 0x0020
    111a:	0402                	.insn	2, 0x0402
    111c:	0601                	.insn	2, 0x0601
    111e:	04090103          	lb	sp,64(s2)
    1122:	0100                	.insn	2, 0x0100
    1124:	0d05                	.insn	2, 0x0d05
    1126:	14090103          	lb	sp,320(s2)
    112a:	0100                	.insn	2, 0x0100
    112c:	2a05                	.insn	2, 0x2a05
    112e:	0200                	.insn	2, 0x0200
    1130:	0304                	.insn	2, 0x0304
    1132:	18097f03          	.insn	4, 0x18097f03
    1136:	0100                	.insn	2, 0x0100
    1138:	2005                	.insn	2, 0x2005
    113a:	0200                	.insn	2, 0x0200
    113c:	0104                	.insn	2, 0x0104
    113e:	00090003          	lb	zero,0(s2)
    1142:	0100                	.insn	2, 0x0100
    1144:	0c05                	.insn	2, 0x0c05
    1146:	04090603          	lb	a2,64(s2)
    114a:	0100                	.insn	2, 0x0100
    114c:	2005                	.insn	2, 0x2005
    114e:	0200                	.insn	2, 0x0200
    1150:	0104                	.insn	2, 0x0104
    1152:	0306                	.insn	2, 0x0306
    1154:	097a                	.insn	2, 0x097a
    1156:	0008                	.insn	2, 0x0008
    1158:	0501                	.insn	2, 0x0501
    115a:	0609                	.insn	2, 0x0609
    115c:	0c090703          	lb	a4,192(s2)
    1160:	0100                	.insn	2, 0x0100
    1162:	0c05                	.insn	2, 0x0c05
    1164:	0306                	.insn	2, 0x0306
    1166:	097f 0010 0501 0309 	.insn	10, 0x0901030905010010097f
    116e:	0901 
    1170:	0004                	.insn	2, 0x0004
    1172:	0501                	.insn	2, 0x0501
    1174:	060c                	.insn	2, 0x060c
    1176:	04097f03          	.insn	4, 0x04097f03
    117a:	0100                	.insn	2, 0x0100
    117c:	0f05                	.insn	2, 0x0f05
    117e:	0306                	.insn	2, 0x0306
    1180:	0905                	.insn	2, 0x0905
    1182:	0004                	.insn	2, 0x0004
    1184:	0501                	.insn	2, 0x0501
    1186:	0605                	.insn	2, 0x0605
    1188:	08090003          	lb	zero,128(s2)
    118c:	0100                	.insn	2, 0x0100
    118e:	0805                	.insn	2, 0x0805
    1190:	0306                	.insn	2, 0x0306
    1192:	0900                	.insn	2, 0x0900
    1194:	0000                	.insn	2, 0x
    1196:	0501                	.insn	2, 0x0501
    1198:	0620                	.insn	2, 0x0620
    119a:	04090103          	lb	sp,64(s2)
    119e:	0100                	.insn	2, 0x0100
    11a0:	1405                	.insn	2, 0x1405
    11a2:	0306                	.insn	2, 0x0306
    11a4:	0900                	.insn	2, 0x0900
    11a6:	0000                	.insn	2, 0x
    11a8:	0501                	.insn	2, 0x0501
    11aa:	0320                	.insn	2, 0x0320
    11ac:	0900                	.insn	2, 0x0900
    11ae:	0004                	.insn	2, 0x0004
    11b0:	0501                	.insn	2, 0x0501
    11b2:	060d                	.insn	2, 0x060d
    11b4:	04090103          	lb	sp,64(s2)
    11b8:	0100                	.insn	2, 0x0100
    11ba:	2005                	.insn	2, 0x2005
    11bc:	18097f03          	.insn	4, 0x18097f03
    11c0:	0100                	.insn	2, 0x0100
    11c2:	2c05                	.insn	2, 0x2c05
    11c4:	0200                	.insn	2, 0x0200
    11c6:	0104                	.insn	2, 0x0104
    11c8:	0306                	.insn	2, 0x0306
    11ca:	100901b3          	.insn	4, 0x100901b3
    11ce:	0100                	.insn	2, 0x0100
    11d0:	0c05                	.insn	2, 0x0c05
    11d2:	0306                	.insn	2, 0x0306
    11d4:	0911                	.insn	2, 0x0911
    11d6:	0008                	.insn	2, 0x0008
    11d8:	0501                	.insn	2, 0x0501
    11da:	0003060f          	.insn	4, 0x0003060f
    11de:	0009                	.insn	2, 0x0009
    11e0:	0100                	.insn	2, 0x0100
    11e2:	0c05                	.insn	2, 0x0c05
    11e4:	0306                	.insn	2, 0x0306
    11e6:	0901                	.insn	2, 0x0901
    11e8:	0008                	.insn	2, 0x0008
    11ea:	0501                	.insn	2, 0x0501
    11ec:	0003060f          	.insn	4, 0x0003060f
    11f0:	0009                	.insn	2, 0x0009
    11f2:	0100                	.insn	2, 0x0100
    11f4:	0905                	.insn	2, 0x0905
    11f6:	0306                	.insn	2, 0x0306
    11f8:	0902                	.insn	2, 0x0902
    11fa:	0004                	.insn	2, 0x0004
    11fc:	0501                	.insn	2, 0x0501
    11fe:	0305                	.insn	2, 0x0305
    1200:	00040903          	lb	s2,0(s0)
    1204:	0501                	.insn	2, 0x0501
    1206:	0608                	.insn	2, 0x0608
    1208:	00090003          	lb	zero,0(s2)
    120c:	0100                	.insn	2, 0x0100
    120e:	0905                	.insn	2, 0x0905
    1210:	0306                	.insn	2, 0x0306
    1212:	0901                	.insn	2, 0x0901
    1214:	0004                	.insn	2, 0x0004
    1216:	0301                	.insn	2, 0x0301
    1218:	0901                	.insn	2, 0x0901
    121a:	0000                	.insn	2, 0x
    121c:	0501                	.insn	2, 0x0501
    121e:	0618                	.insn	2, 0x0618
    1220:	00097f03          	.insn	4, 0x00097f03
    1224:	0100                	.insn	2, 0x0100
    1226:	0c05                	.insn	2, 0x0c05
    1228:	04090103          	lb	sp,64(s2)
    122c:	0100                	.insn	2, 0x0100
    122e:	0e05                	.insn	2, 0x0e05
    1230:	04097f03          	.insn	4, 0x04097f03
    1234:	0100                	.insn	2, 0x0100
    1236:	0c05                	.insn	2, 0x0c05
    1238:	04090103          	lb	sp,64(s2)
    123c:	0100                	.insn	2, 0x0100
    123e:	2d05                	.insn	2, 0x2d05
    1240:	0200                	.insn	2, 0x0200
    1242:	0304                	.insn	2, 0x0304
    1244:	08090003          	lb	zero,128(s2)
    1248:	0100                	.insn	2, 0x0100
    124a:	2905                	.insn	2, 0x2905
    124c:	08091b03          	lh	s6,128(s2)
    1250:	0100                	.insn	2, 0x0100
    1252:	1005                	.insn	2, 0x1005
    1254:	08097f03          	.insn	4, 0x08097f03
    1258:	0100                	.insn	2, 0x0100
    125a:	2905                	.insn	2, 0x2905
    125c:	08090103          	lb	sp,128(s2)
    1260:	0100                	.insn	2, 0x0100
    1262:	1005                	.insn	2, 0x1005
    1264:	04090003          	lb	zero,64(s2)
    1268:	0100                	.insn	2, 0x0100
    126a:	1405                	.insn	2, 0x1405
    126c:	04090003          	lb	zero,64(s2)
    1270:	0100                	.insn	2, 0x0100
    1272:	2905                	.insn	2, 0x2905
    1274:	04090003          	lb	zero,64(s2)
    1278:	0100                	.insn	2, 0x0100
    127a:	1605                	.insn	2, 0x1605
    127c:	18090003          	lb	zero,384(s2)
    1280:	0100                	.insn	2, 0x0100
    1282:	1405                	.insn	2, 0x1405
    1284:	04090003          	lb	zero,64(s2)
    1288:	0100                	.insn	2, 0x0100
    128a:	0905                	.insn	2, 0x0905
    128c:	0306                	.insn	2, 0x0306
    128e:	0901                	.insn	2, 0x0901
    1290:	0004                	.insn	2, 0x0004
    1292:	0501                	.insn	2, 0x0501
    1294:	0615                	.insn	2, 0x0615
    1296:	00090003          	lb	zero,0(s2)
    129a:	0100                	.insn	2, 0x0100
    129c:	0c05                	.insn	2, 0x0c05
    129e:	04090003          	lb	zero,64(s2)
    12a2:	0100                	.insn	2, 0x0100
    12a4:	0905                	.insn	2, 0x0905
    12a6:	0306                	.insn	2, 0x0306
    12a8:	097f 0004 0501 0310 	.insn	10, 0x097f031005010004097f
    12b0:	097f 
    12b2:	0000                	.insn	2, 0x
    12b4:	0501                	.insn	2, 0x0501
    12b6:	0629                	.insn	2, 0x0629
    12b8:	00090103          	lb	sp,0(s2)
    12bc:	0100                	.insn	2, 0x0100
    12be:	1005                	.insn	2, 0x1005
    12c0:	04097f03          	.insn	4, 0x04097f03
    12c4:	0100                	.insn	2, 0x0100
    12c6:	0505                	.insn	2, 0x0505
    12c8:	0306                	.insn	2, 0x0306
    12ca:	0908                	.insn	2, 0x0908
    12cc:	0004                	.insn	2, 0x0004
    12ce:	0501                	.insn	2, 0x0501
    12d0:	061f 0003 0009      	.insn	6, 0x00090003061f
    12d6:	0100                	.insn	2, 0x0100
    12d8:	0805                	.insn	2, 0x0805
    12da:	04090003          	lb	zero,64(s2)
    12de:	0100                	.insn	2, 0x0100
    12e0:	0905                	.insn	2, 0x0905
    12e2:	0306                	.insn	2, 0x0306
    12e4:	0901                	.insn	2, 0x0901
    12e6:	0008                	.insn	2, 0x0008
    12e8:	0501                	.insn	2, 0x0501
    12ea:	060c                	.insn	2, 0x060c
    12ec:	00090003          	lb	zero,0(s2)
    12f0:	0100                	.insn	2, 0x0100
    12f2:	1305                	.insn	2, 0x1305
    12f4:	0200                	.insn	2, 0x0200
    12f6:	0104                	.insn	2, 0x0104
    12f8:	04090003          	lb	zero,64(s2)
    12fc:	0100                	.insn	2, 0x0100
    12fe:	0d05                	.insn	2, 0x0d05
    1300:	0306                	.insn	2, 0x0306
    1302:	0901                	.insn	2, 0x0901
    1304:	0004                	.insn	2, 0x0004
    1306:	0501                	.insn	2, 0x0501
    1308:	0612                	.insn	2, 0x0612
    130a:	00090003          	lb	zero,0(s2)
    130e:	0100                	.insn	2, 0x0100
    1310:	1e05                	.insn	2, 0x1e05
    1312:	0306                	.insn	2, 0x0306
    1314:	0902                	.insn	2, 0x0902
    1316:	0004                	.insn	2, 0x0004
    1318:	0001                	.insn	2, 0x0001
    131a:	0402                	.insn	2, 0x0402
    131c:	0601                	.insn	2, 0x0601
    131e:	04090003          	lb	zero,64(s2)
    1322:	0100                	.insn	2, 0x0100
    1324:	1805                	.insn	2, 0x1805
    1326:	04090103          	lb	sp,64(s2)
    132a:	0100                	.insn	2, 0x0100
    132c:	0d05                	.insn	2, 0x0d05
    132e:	0306                	.insn	2, 0x0306
    1330:	0900                	.insn	2, 0x0900
    1332:	0004                	.insn	2, 0x0004
    1334:	0501                	.insn	2, 0x0501
    1336:	001e                	.insn	2, 0x001e
    1338:	0402                	.insn	2, 0x0402
    133a:	0601                	.insn	2, 0x0601
    133c:	00097f03          	.insn	4, 0x00097f03
    1340:	0100                	.insn	2, 0x0100
    1342:	1405                	.insn	2, 0x1405
    1344:	04090103          	lb	sp,64(s2)
    1348:	0100                	.insn	2, 0x0100
    134a:	1805                	.insn	2, 0x1805
    134c:	04090003          	lb	zero,64(s2)
    1350:	0100                	.insn	2, 0x0100
    1352:	1e05                	.insn	2, 0x1e05
    1354:	0306                	.insn	2, 0x0306
    1356:	097f 0008 0501 0305 	.insn	10, 0x097c030505010008097f
    135e:	097c 
    1360:	0008                	.insn	2, 0x0008
    1362:	0501                	.insn	2, 0x0501
    1364:	061f 0003 0009      	.insn	6, 0x00090003061f
    136a:	0100                	.insn	2, 0x0100
    136c:	0805                	.insn	2, 0x0805
    136e:	04090003          	lb	zero,64(s2)
    1372:	0100                	.insn	2, 0x0100
    1374:	0505                	.insn	2, 0x0505
    1376:	0306                	.insn	2, 0x0306
    1378:	0909                	.insn	2, 0x0909
    137a:	0008                	.insn	2, 0x0008
    137c:	0501                	.insn	2, 0x0501
    137e:	0608                	.insn	2, 0x0608
    1380:	00090003          	lb	zero,0(s2)
    1384:	0100                	.insn	2, 0x0100
    1386:	0905                	.insn	2, 0x0905
    1388:	0306                	.insn	2, 0x0306
    138a:	0901                	.insn	2, 0x0901
    138c:	0008                	.insn	2, 0x0008
    138e:	0501                	.insn	2, 0x0501
    1390:	060c                	.insn	2, 0x060c
    1392:	00090003          	lb	zero,0(s2)
    1396:	0100                	.insn	2, 0x0100
    1398:	0d05                	.insn	2, 0x0d05
    139a:	0306                	.insn	2, 0x0306
    139c:	0901                	.insn	2, 0x0901
    139e:	0004                	.insn	2, 0x0004
    13a0:	0501                	.insn	2, 0x0501
    13a2:	0618                	.insn	2, 0x0618
    13a4:	00090003          	lb	zero,0(s2)
    13a8:	0100                	.insn	2, 0x0100
    13aa:	04090203          	lb	tp,64(s2)
    13ae:	0100                	.insn	2, 0x0100
    13b0:	0505                	.insn	2, 0x0505
    13b2:	0306                	.insn	2, 0x0306
    13b4:	0906                	.insn	2, 0x0906
    13b6:	000c                	.insn	2, 0x000c
    13b8:	0501                	.insn	2, 0x0501
    13ba:	060c                	.insn	2, 0x060c
    13bc:	00090003          	lb	zero,0(s2)
    13c0:	0100                	.insn	2, 0x0100
    13c2:	2a05                	.insn	2, 0x2a05
    13c4:	0200                	.insn	2, 0x0200
    13c6:	0204                	.insn	2, 0x0204
    13c8:	24096e03          	.insn	4, 0x24096e03
    13cc:	0100                	.insn	2, 0x0100
    13ce:	2005                	.insn	2, 0x2005
    13d0:	0200                	.insn	2, 0x0200
    13d2:	0204                	.insn	2, 0x0204
    13d4:	04090003          	lb	zero,64(s2)
    13d8:	0100                	.insn	2, 0x0100
    13da:	0d05                	.insn	2, 0x0d05
    13dc:	0306                	.insn	2, 0x0306
    13de:	0901                	.insn	2, 0x0901
    13e0:	0004                	.insn	2, 0x0004
    13e2:	0501                	.insn	2, 0x0501
    13e4:	0612                	.insn	2, 0x0612
    13e6:	00090003          	lb	zero,0(s2)
    13ea:	0100                	.insn	2, 0x0100
    13ec:	1e05                	.insn	2, 0x1e05
    13ee:	0306                	.insn	2, 0x0306
    13f0:	0902                	.insn	2, 0x0902
    13f2:	0004                	.insn	2, 0x0004
    13f4:	0501                	.insn	2, 0x0501
    13f6:	0305                	.insn	2, 0x0305
    13f8:	0905                	.insn	2, 0x0905
    13fa:	0004                	.insn	2, 0x0004
    13fc:	0501                	.insn	2, 0x0501
    13fe:	0608                	.insn	2, 0x0608
    1400:	00090003          	lb	zero,0(s2)
    1404:	0100                	.insn	2, 0x0100
    1406:	1005                	.insn	2, 0x1005
    1408:	0306                	.insn	2, 0x0306
    140a:	00080903          	lb	s2,0(a6)
    140e:	0501                	.insn	2, 0x0501
    1410:	061a                	.insn	2, 0x061a
    1412:	00090003          	lb	zero,0(s2)
    1416:	0100                	.insn	2, 0x0100
    1418:	1305                	.insn	2, 0x1305
    141a:	04090003          	lb	zero,64(s2)
    141e:	0100                	.insn	2, 0x0100
    1420:	0d05                	.insn	2, 0x0d05
    1422:	0306                	.insn	2, 0x0306
    1424:	0901                	.insn	2, 0x0901
    1426:	0004                	.insn	2, 0x0004
    1428:	0501                	.insn	2, 0x0501
    142a:	0618                	.insn	2, 0x0618
    142c:	00090003          	lb	zero,0(s2)
    1430:	0100                	.insn	2, 0x0100
    1432:	3005                	.insn	2, 0x3005
    1434:	0306                	.insn	2, 0x0306
    1436:	0961                	.insn	2, 0x0961
    1438:	0008                	.insn	2, 0x0008
    143a:	0501                	.insn	2, 0x0501
    143c:	0618                	.insn	2, 0x0618
    143e:	08090103          	lb	sp,128(s2)
    1442:	0100                	.insn	2, 0x0100
    1444:	3005                	.insn	2, 0x3005
    1446:	04097f03          	.insn	4, 0x04097f03
    144a:	0100                	.insn	2, 0x0100
    144c:	0d05                	.insn	2, 0x0d05
    144e:	0306                	.insn	2, 0x0306
    1450:	0901                	.insn	2, 0x0901
    1452:	0004                	.insn	2, 0x0004
    1454:	0501                	.insn	2, 0x0501
    1456:	0030                	.insn	2, 0x0030
    1458:	0402                	.insn	2, 0x0402
    145a:	0601                	.insn	2, 0x0601
    145c:	00097f03          	.insn	4, 0x00097f03
    1460:	0100                	.insn	2, 0x0100
    1462:	1405                	.insn	2, 0x1405
    1464:	04090103          	lb	sp,64(s2)
    1468:	0100                	.insn	2, 0x0100
    146a:	1805                	.insn	2, 0x1805
    146c:	04090003          	lb	zero,64(s2)
    1470:	0100                	.insn	2, 0x0100
    1472:	3005                	.insn	2, 0x3005
    1474:	0306                	.insn	2, 0x0306
    1476:	097f 0008 0501 0618 	.insn	10, 0x7b03061805010008097f
    147e:	7b03 
    1480:	0409                	.insn	2, 0x0409
    1482:	0100                	.insn	2, 0x0100
    1484:	0905                	.insn	2, 0x0905
    1486:	0306                	.insn	2, 0x0306
    1488:	0908                	.insn	2, 0x0908
    148a:	0008                	.insn	2, 0x0008
    148c:	0501                	.insn	2, 0x0501
    148e:	030d                	.insn	2, 0x030d
    1490:	0902                	.insn	2, 0x0902
    1492:	0000                	.insn	2, 0x
    1494:	0501                	.insn	2, 0x0501
    1496:	0618                	.insn	2, 0x0618
    1498:	00090003          	lb	zero,0(s2)
    149c:	0100                	.insn	2, 0x0100
    149e:	1405                	.insn	2, 0x1405
    14a0:	08090003          	lb	zero,128(s2)
    14a4:	0100                	.insn	2, 0x0100
    14a6:	1805                	.insn	2, 0x1805
    14a8:	04090003          	lb	zero,64(s2)
    14ac:	0100                	.insn	2, 0x0100
    14ae:	1005                	.insn	2, 0x1005
    14b0:	0306                	.insn	2, 0x0306
    14b2:	0008091b          	.insn	4, 0x0008091b
    14b6:	0501                	.insn	2, 0x0501
    14b8:	061a                	.insn	2, 0x061a
    14ba:	00090003          	lb	zero,0(s2)
    14be:	0100                	.insn	2, 0x0100
    14c0:	1305                	.insn	2, 0x1305
    14c2:	04090003          	lb	zero,64(s2)
    14c6:	0100                	.insn	2, 0x0100
    14c8:	0d05                	.insn	2, 0x0d05
    14ca:	0306                	.insn	2, 0x0306
    14cc:	0901                	.insn	2, 0x0901
    14ce:	0004                	.insn	2, 0x0004
    14d0:	0501                	.insn	2, 0x0501
    14d2:	0618                	.insn	2, 0x0618
    14d4:	00090003          	lb	zero,0(s2)
    14d8:	0100                	.insn	2, 0x0100
    14da:	2605                	.insn	2, 0x2605
    14dc:	0200                	.insn	2, 0x0200
    14de:	0104                	.insn	2, 0x0104
    14e0:	18094803          	lbu	a6,384(s2)
    14e4:	0100                	.insn	2, 0x0100
    14e6:	1d05                	.insn	2, 0x1d05
    14e8:	0200                	.insn	2, 0x0200
    14ea:	0104                	.insn	2, 0x0104
    14ec:	04090003          	lb	zero,64(s2)
    14f0:	0100                	.insn	2, 0x0100
    14f2:	0905                	.insn	2, 0x0905
    14f4:	0306                	.insn	2, 0x0306
    14f6:	0902                	.insn	2, 0x0902
    14f8:	0004                	.insn	2, 0x0004
    14fa:	0501                	.insn	2, 0x0501
    14fc:	031e                	.insn	2, 0x031e
    14fe:	0008092b          	.insn	4, 0x0008092b
    1502:	0501                	.insn	2, 0x0501
    1504:	0309                	.insn	2, 0x0309
    1506:	097d                	.insn	2, 0x097d
    1508:	0008                	.insn	2, 0x0008
    150a:	0501                	.insn	2, 0x0501
    150c:	060c                	.insn	2, 0x060c
    150e:	00090003          	lb	zero,0(s2)
    1512:	0100                	.insn	2, 0x0100
    1514:	1305                	.insn	2, 0x1305
    1516:	0200                	.insn	2, 0x0200
    1518:	0104                	.insn	2, 0x0104
    151a:	04090003          	lb	zero,64(s2)
    151e:	0100                	.insn	2, 0x0100
    1520:	0d05                	.insn	2, 0x0d05
    1522:	0306                	.insn	2, 0x0306
    1524:	0901                	.insn	2, 0x0901
    1526:	0004                	.insn	2, 0x0004
    1528:	0501                	.insn	2, 0x0501
    152a:	0612                	.insn	2, 0x0612
    152c:	00090003          	lb	zero,0(s2)
    1530:	0100                	.insn	2, 0x0100
    1532:	1e05                	.insn	2, 0x1e05
    1534:	0306                	.insn	2, 0x0306
    1536:	0902                	.insn	2, 0x0902
    1538:	0004                	.insn	2, 0x0004
    153a:	0501                	.insn	2, 0x0501
    153c:	0305                	.insn	2, 0x0305
    153e:	0905                	.insn	2, 0x0905
    1540:	0004                	.insn	2, 0x0004
    1542:	0501                	.insn	2, 0x0501
    1544:	0608                	.insn	2, 0x0608
    1546:	00090003          	lb	zero,0(s2)
    154a:	0100                	.insn	2, 0x0100
    154c:	2905                	.insn	2, 0x2905
    154e:	0306                	.insn	2, 0x0306
    1550:	0912                	.insn	2, 0x0912
    1552:	0008                	.insn	2, 0x0008
    1554:	0501                	.insn	2, 0x0501
    1556:	0305                	.insn	2, 0x0305
    1558:	0902                	.insn	2, 0x0902
    155a:	0000                	.insn	2, 0x
    155c:	0501                	.insn	2, 0x0501
    155e:	0629                	.insn	2, 0x0629
    1560:	00097e03          	.insn	4, 0x00097e03
    1564:	0100                	.insn	2, 0x0100
    1566:	0805                	.insn	2, 0x0805
    1568:	18090203          	lb	tp,384(s2)
    156c:	0100                	.insn	2, 0x0100
    156e:	2905                	.insn	2, 0x2905
    1570:	04097e03          	.insn	4, 0x04097e03
    1574:	0100                	.insn	2, 0x0100
    1576:	0805                	.insn	2, 0x0805
    1578:	2c090203          	lb	tp,704(s2)
    157c:	0100                	.insn	2, 0x0100
    157e:	1a05                	.insn	2, 0x1a05
    1580:	0200                	.insn	2, 0x0200
    1582:	0104                	.insn	2, 0x0104
    1584:	04090003          	lb	zero,64(s2)
    1588:	0100                	.insn	2, 0x0100
    158a:	2f05                	.insn	2, 0x2f05
    158c:	0200                	.insn	2, 0x0200
    158e:	0204                	.insn	2, 0x0204
    1590:	0c090003          	lb	zero,192(s2)
    1594:	0100                	.insn	2, 0x0100
    1596:	0805                	.insn	2, 0x0805
    1598:	0c090603          	lb	a2,192(s2)
    159c:	0100                	.insn	2, 0x0100
    159e:	0505                	.insn	2, 0x0505
    15a0:	0306                	.insn	2, 0x0306
    15a2:	097f 0014 0301 0901 	.insn	10, 0x090103010014097f
    15aa:	0000 
    15ac:	0501                	.insn	2, 0x0501
    15ae:	0608                	.insn	2, 0x0608
    15b0:	00090003          	lb	zero,0(s2)
    15b4:	0100                	.insn	2, 0x0100
    15b6:	0505                	.insn	2, 0x0505
    15b8:	0306                	.insn	2, 0x0306
    15ba:	0905                	.insn	2, 0x0905
    15bc:	0010                	.insn	2, 0x0010
    15be:	0501                	.insn	2, 0x0501
    15c0:	0611                	.insn	2, 0x0611
    15c2:	00090003          	lb	zero,0(s2)
    15c6:	0100                	.insn	2, 0x0100
    15c8:	0805                	.insn	2, 0x0805
    15ca:	04090003          	lb	zero,64(s2)
    15ce:	0100                	.insn	2, 0x0100
    15d0:	0e05                	.insn	2, 0x0e05
    15d2:	04090103          	lb	sp,64(s2)
    15d6:	0100                	.insn	2, 0x0100
    15d8:	0505                	.insn	2, 0x0505
    15da:	0306                	.insn	2, 0x0306
    15dc:	0906                	.insn	2, 0x0906
    15de:	0004                	.insn	2, 0x0004
    15e0:	0301                	.insn	2, 0x0301
    15e2:	0905                	.insn	2, 0x0905
    15e4:	0000                	.insn	2, 0x
    15e6:	0301                	.insn	2, 0x0301
    15e8:	0901                	.insn	2, 0x0901
    15ea:	0000                	.insn	2, 0x
    15ec:	0301                	.insn	2, 0x0301
    15ee:	0901                	.insn	2, 0x0901
    15f0:	0000                	.insn	2, 0x
    15f2:	0301                	.insn	2, 0x0301
    15f4:	0904                	.insn	2, 0x0904
    15f6:	0000                	.insn	2, 0x
    15f8:	0501                	.insn	2, 0x0501
    15fa:	061e                	.insn	2, 0x061e
    15fc:	00097b03          	.insn	4, 0x00097b03
    1600:	0100                	.insn	2, 0x0100
    1602:	1005                	.insn	2, 0x1005
    1604:	04090003          	lb	zero,64(s2)
    1608:	0100                	.insn	2, 0x0100
    160a:	0905                	.insn	2, 0x0905
    160c:	04090003          	lb	zero,64(s2)
    1610:	0100                	.insn	2, 0x0100
    1612:	2f05                	.insn	2, 0x2f05
    1614:	04090503          	lb	a0,64(s2)
    1618:	0100                	.insn	2, 0x0100
    161a:	2805                	.insn	2, 0x2805
    161c:	04090003          	lb	zero,64(s2)
    1620:	0100                	.insn	2, 0x0100
    1622:	2005                	.insn	2, 0x2005
    1624:	00090103          	lb	sp,0(s2)
    1628:	0100                	.insn	2, 0x0100
    162a:	2805                	.insn	2, 0x2805
    162c:	00097f03          	.insn	4, 0x00097f03
    1630:	0100                	.insn	2, 0x0100
    1632:	1605                	.insn	2, 0x1605
    1634:	00097c03          	.insn	4, 0x00097c03
    1638:	0100                	.insn	2, 0x0100
    163a:	2805                	.insn	2, 0x2805
    163c:	04090403          	lb	s0,64(s2)
    1640:	0100                	.insn	2, 0x0100
    1642:	2005                	.insn	2, 0x2005
    1644:	08090103          	lb	sp,128(s2)
    1648:	0100                	.insn	2, 0x0100
    164a:	1605                	.insn	2, 0x1605
    164c:	04097b03          	.insn	4, 0x04097b03
    1650:	0100                	.insn	2, 0x0100
    1652:	2e05                	.insn	2, 0x2e05
    1654:	04090003          	lb	zero,64(s2)
    1658:	0100                	.insn	2, 0x0100
    165a:	2005                	.insn	2, 0x2005
    165c:	08090503          	lb	a0,128(s2)
    1660:	0100                	.insn	2, 0x0100
    1662:	2805                	.insn	2, 0x2805
    1664:	08097f03          	.insn	4, 0x08097f03
    1668:	0100                	.insn	2, 0x0100
    166a:	2005                	.insn	2, 0x2005
    166c:	04090103          	lb	sp,64(s2)
    1670:	0100                	.insn	2, 0x0100
    1672:	4305                	.insn	2, 0x4305
    1674:	04097f03          	.insn	4, 0x04097f03
    1678:	0100                	.insn	2, 0x0100
    167a:	2005                	.insn	2, 0x2005
    167c:	04090103          	lb	sp,64(s2)
    1680:	0100                	.insn	2, 0x0100
    1682:	2d05                	.insn	2, 0x2d05
    1684:	04090203          	lb	tp,64(s2)
    1688:	0100                	.insn	2, 0x0100
    168a:	3805                	.insn	2, 0x3805
    168c:	08090103          	lb	sp,128(s2)
    1690:	0100                	.insn	2, 0x0100
    1692:	4305                	.insn	2, 0x4305
    1694:	04097c03          	.insn	4, 0x04097c03
    1698:	0100                	.insn	2, 0x0100
    169a:	1205                	.insn	2, 0x1205
    169c:	04090403          	lb	s0,64(s2)
    16a0:	0100                	.insn	2, 0x0100
    16a2:	3e05                	.insn	2, 0x3e05
    16a4:	04090503          	lb	a0,64(s2)
    16a8:	0100                	.insn	2, 0x0100
    16aa:	3905                	.insn	2, 0x3905
    16ac:	04090003          	lb	zero,64(s2)
    16b0:	0100                	.insn	2, 0x0100
    16b2:	0905                	.insn	2, 0x0905
    16b4:	04097703          	.insn	4, 0x04097703
    16b8:	0100                	.insn	2, 0x0100
    16ba:	0505                	.insn	2, 0x0505
    16bc:	0306                	.insn	2, 0x0306
    16be:	00040903          	lb	s2,0(s0)
    16c2:	0501                	.insn	2, 0x0501
    16c4:	062d                	.insn	2, 0x062d
    16c6:	00090603          	lb	a2,0(s2)
    16ca:	0100                	.insn	2, 0x0100
    16cc:	1905                	.insn	2, 0x1905
    16ce:	04097a03          	.insn	4, 0x04097a03
    16d2:	0100                	.insn	2, 0x0100
    16d4:	1e05                	.insn	2, 0x1e05
    16d6:	04090603          	lb	a2,64(s2)
    16da:	0100                	.insn	2, 0x0100
    16dc:	2605                	.insn	2, 0x2605
    16de:	00097d03          	.insn	4, 0x00097d03
    16e2:	0100                	.insn	2, 0x0100
    16e4:	2d05                	.insn	2, 0x2d05
    16e6:	04097d03          	.insn	4, 0x04097d03
    16ea:	0100                	.insn	2, 0x0100
    16ec:	1e05                	.insn	2, 0x1e05
    16ee:	04090603          	lb	a2,64(s2)
    16f2:	0100                	.insn	2, 0x0100
    16f4:	1105                	.insn	2, 0x1105
    16f6:	04090003          	lb	zero,64(s2)
    16fa:	0100                	.insn	2, 0x0100
    16fc:	0c05                	.insn	2, 0x0c05
    16fe:	04090003          	lb	zero,64(s2)
    1702:	0100                	.insn	2, 0x0100
    1704:	0a05                	.insn	2, 0x0a05
    1706:	04097a03          	.insn	4, 0x04097a03
    170a:	0100                	.insn	2, 0x0100
    170c:	0505                	.insn	2, 0x0505
    170e:	0306                	.insn	2, 0x0306
    1710:	0901                	.insn	2, 0x0901
    1712:	0004                	.insn	2, 0x0004
    1714:	0501                	.insn	2, 0x0501
    1716:	0638                	.insn	2, 0x0638
    1718:	00090003          	lb	zero,0(s2)
    171c:	0100                	.insn	2, 0x0100
    171e:	1e05                	.insn	2, 0x1e05
    1720:	04090203          	lb	tp,64(s2)
    1724:	0100                	.insn	2, 0x0100
    1726:	2605                	.insn	2, 0x2605
    1728:	04090003          	lb	zero,64(s2)
    172c:	0100                	.insn	2, 0x0100
    172e:	3805                	.insn	2, 0x3805
    1730:	04097e03          	.insn	4, 0x04097e03
    1734:	0100                	.insn	2, 0x0100
    1736:	0c05                	.insn	2, 0x0c05
    1738:	04090503          	lb	a0,64(s2)
    173c:	0100                	.insn	2, 0x0100
    173e:	1205                	.insn	2, 0x1205
    1740:	04097b03          	.insn	4, 0x04097b03
    1744:	0100                	.insn	2, 0x0100
    1746:	0505                	.insn	2, 0x0505
    1748:	0306                	.insn	2, 0x0306
    174a:	0901                	.insn	2, 0x0901
    174c:	0004                	.insn	2, 0x0004
    174e:	0501                	.insn	2, 0x0501
    1750:	0612                	.insn	2, 0x0612
    1752:	00090003          	lb	zero,0(s2)
    1756:	0100                	.insn	2, 0x0100
    1758:	0505                	.insn	2, 0x0505
    175a:	0306                	.insn	2, 0x0306
    175c:	0901                	.insn	2, 0x0901
    175e:	0004                	.insn	2, 0x0004
    1760:	0301                	.insn	2, 0x0301
    1762:	00000903          	lb	s2,0(zero) # 0 <main-0x80000000>
    1766:	0501                	.insn	2, 0x0501
    1768:	061e                	.insn	2, 0x061e
    176a:	00090003          	lb	zero,0(s2)
    176e:	0100                	.insn	2, 0x0100
    1770:	1505                	.insn	2, 0x1505
    1772:	04090003          	lb	zero,64(s2)
    1776:	0100                	.insn	2, 0x0100
    1778:	3e05                	.insn	2, 0x3e05
    177a:	04090003          	lb	zero,64(s2)
    177e:	0100                	.insn	2, 0x0100
    1780:	3905                	.insn	2, 0x3905
    1782:	04090003          	lb	zero,64(s2)
    1786:	0100                	.insn	2, 0x0100
    1788:	3305                	.insn	2, 0x3305
    178a:	04090003          	lb	zero,64(s2)
    178e:	0100                	.insn	2, 0x0100
    1790:	2d05                	.insn	2, 0x2d05
    1792:	04090003          	lb	zero,64(s2)
    1796:	0100                	.insn	2, 0x0100
    1798:	2805                	.insn	2, 0x2805
    179a:	04090003          	lb	zero,64(s2)
    179e:	0100                	.insn	2, 0x0100
    17a0:	0c05                	.insn	2, 0x0c05
    17a2:	04090003          	lb	zero,64(s2)
    17a6:	0100                	.insn	2, 0x0100
    17a8:	0805                	.insn	2, 0x0805
    17aa:	04090203          	lb	tp,64(s2)
    17ae:	0100                	.insn	2, 0x0100
    17b0:	2205                	.insn	2, 0x2205
    17b2:	08097e03          	.insn	4, 0x08097e03
    17b6:	0100                	.insn	2, 0x0100
    17b8:	1905                	.insn	2, 0x1905
    17ba:	04090003          	lb	zero,64(s2)
    17be:	0100                	.insn	2, 0x0100
    17c0:	1105                	.insn	2, 0x1105
    17c2:	04090003          	lb	zero,64(s2)
    17c6:	0100                	.insn	2, 0x0100
    17c8:	0c05                	.insn	2, 0x0c05
    17ca:	04090003          	lb	zero,64(s2)
    17ce:	0100                	.insn	2, 0x0100
    17d0:	0505                	.insn	2, 0x0505
    17d2:	0306                	.insn	2, 0x0306
    17d4:	0902                	.insn	2, 0x0902
    17d6:	0004                	.insn	2, 0x0004
    17d8:	0501                	.insn	2, 0x0501
    17da:	0608                	.insn	2, 0x0608
    17dc:	00090003          	lb	zero,0(s2)
    17e0:	0100                	.insn	2, 0x0100
    17e2:	0905                	.insn	2, 0x0905
    17e4:	0306                	.insn	2, 0x0306
    17e6:	0901                	.insn	2, 0x0901
    17e8:	000c                	.insn	2, 0x000c
    17ea:	0501                	.insn	2, 0x0501
    17ec:	0610                	.insn	2, 0x0610
    17ee:	00090103          	lb	sp,0(s2)
    17f2:	0100                	.insn	2, 0x0100
    17f4:	0f05                	.insn	2, 0x0f05
    17f6:	04097f03          	.insn	4, 0x04097f03
    17fa:	0100                	.insn	2, 0x0100
    17fc:	0905                	.insn	2, 0x0905
    17fe:	0306                	.insn	2, 0x0306
    1800:	0901                	.insn	2, 0x0901
    1802:	0004                	.insn	2, 0x0004
    1804:	0501                	.insn	2, 0x0501
    1806:	0305                	.insn	2, 0x0305
    1808:	0905                	.insn	2, 0x0905
    180a:	0000                	.insn	2, 0x
    180c:	0501                	.insn	2, 0x0501
    180e:	0303060f          	.insn	4, 0x0303060f
    1812:	0009                	.insn	2, 0x0009
    1814:	0100                	.insn	2, 0x0100
    1816:	2d05                	.insn	2, 0x2d05
    1818:	08097d03          	.insn	4, 0x08097d03
    181c:	0100                	.insn	2, 0x0100
    181e:	4605                	.insn	2, 0x4605
    1820:	04090003          	lb	zero,64(s2)
    1824:	0100                	.insn	2, 0x0100
    1826:	0200                	.insn	2, 0x0200
    1828:	0104                	.insn	2, 0x0104
    182a:	04090003          	lb	zero,64(s2)
    182e:	0100                	.insn	2, 0x0100
    1830:	0f05                	.insn	2, 0x0f05
    1832:	04090303          	lb	t1,64(s2)
    1836:	0100                	.insn	2, 0x0100
    1838:	4605                	.insn	2, 0x4605
    183a:	0200                	.insn	2, 0x0200
    183c:	0104                	.insn	2, 0x0104
    183e:	04097d03          	.insn	4, 0x04097d03
    1842:	0100                	.insn	2, 0x0100
    1844:	0505                	.insn	2, 0x0505
    1846:	0306                	.insn	2, 0x0306
    1848:	00040903          	lb	s2,0(s0)
    184c:	0501                	.insn	2, 0x0501
    184e:	0610                	.insn	2, 0x0610
    1850:	00091e03          	lh	t3,0(s2)
    1854:	0100                	.insn	2, 0x0100
    1856:	0805                	.insn	2, 0x0805
    1858:	04096203          	.insn	4, 0x04096203
    185c:	0100                	.insn	2, 0x0100
    185e:	0905                	.insn	2, 0x0905
    1860:	0306                	.insn	2, 0x0306
    1862:	0902                	.insn	2, 0x0902
    1864:	0004                	.insn	2, 0x0004
    1866:	0501                	.insn	2, 0x0501
    1868:	060c                	.insn	2, 0x060c
    186a:	00090003          	lb	zero,0(s2)
    186e:	0100                	.insn	2, 0x0100
    1870:	1d05                	.insn	2, 0x1d05
    1872:	0200                	.insn	2, 0x0200
    1874:	0104                	.insn	2, 0x0104
    1876:	18090003          	lb	zero,384(s2)
    187a:	0100                	.insn	2, 0x0100
    187c:	0d05                	.insn	2, 0x0d05
    187e:	0306                	.insn	2, 0x0306
    1880:	0901                	.insn	2, 0x0901
    1882:	0018                	.insn	2, 0x0018
    1884:	0501                	.insn	2, 0x0501
    1886:	0610                	.insn	2, 0x0610
    1888:	04090003          	lb	zero,64(s2)
    188c:	0100                	.insn	2, 0x0100
    188e:	1105                	.insn	2, 0x1105
    1890:	0306                	.insn	2, 0x0306
    1892:	0901                	.insn	2, 0x0901
    1894:	0004                	.insn	2, 0x0004
    1896:	0501                	.insn	2, 0x0501
    1898:	062d                	.insn	2, 0x062d
    189a:	00090003          	lb	zero,0(s2)
    189e:	0100                	.insn	2, 0x0100
    18a0:	3605                	.insn	2, 0x3605
    18a2:	04090003          	lb	zero,64(s2)
    18a6:	0100                	.insn	2, 0x0100
    18a8:	0d05                	.insn	2, 0x0d05
    18aa:	0306                	.insn	2, 0x0306
    18ac:	0904                	.insn	2, 0x0904
    18ae:	0004                	.insn	2, 0x0004
    18b0:	0301                	.insn	2, 0x0301
    18b2:	0902                	.insn	2, 0x0902
    18b4:	0000                	.insn	2, 0x
    18b6:	0301                	.insn	2, 0x0301
    18b8:	0901                	.insn	2, 0x0901
    18ba:	0000                	.insn	2, 0x
    18bc:	0501                	.insn	2, 0x0501
    18be:	0305                	.insn	2, 0x0305
    18c0:	090a                	.insn	2, 0x090a
    18c2:	0000                	.insn	2, 0x
    18c4:	0301                	.insn	2, 0x0301
    18c6:	0901                	.insn	2, 0x0901
    18c8:	0000                	.insn	2, 0x
    18ca:	0301                	.insn	2, 0x0301
    18cc:	0908                	.insn	2, 0x0908
    18ce:	0000                	.insn	2, 0x
    18d0:	0301                	.insn	2, 0x0301
    18d2:	0000090b          	.insn	4, 0x090b
    18d6:	0301                	.insn	2, 0x0301
    18d8:	0901                	.insn	2, 0x0901
    18da:	0000                	.insn	2, 0x
    18dc:	0501                	.insn	2, 0x0501
    18de:	0003060b          	.insn	4, 0x0003060b
    18e2:	0009                	.insn	2, 0x0009
    18e4:	0100                	.insn	2, 0x0100
    18e6:	0200                	.insn	2, 0x0200
    18e8:	0404                	.insn	2, 0x0404
    18ea:	0c090003          	lb	zero,192(s2)
    18ee:	0100                	.insn	2, 0x0100
    18f0:	0905                	.insn	2, 0x0905
    18f2:	0306                	.insn	2, 0x0306
    18f4:	7fa5                	.insn	2, 0x7fa5
    18f6:	3c09                	.insn	2, 0x3c09
    18f8:	0100                	.insn	2, 0x0100
    18fa:	1005                	.insn	2, 0x1005
    18fc:	0306                	.insn	2, 0x0306
    18fe:	0900                	.insn	2, 0x0900
    1900:	0000                	.insn	2, 0x
    1902:	0501                	.insn	2, 0x0501
    1904:	0301                	.insn	2, 0x0301
    1906:	00ed                	.insn	2, 0x00ed
    1908:	2409                	.insn	2, 0x2409
    190a:	0100                	.insn	2, 0x0100
    190c:	0b05                	.insn	2, 0x0b05
    190e:	0200                	.insn	2, 0x0200
    1910:	0404                	.insn	2, 0x0404
    1912:	20096e03          	.insn	4, 0x20096e03
    1916:	0100                	.insn	2, 0x0100
    1918:	0505                	.insn	2, 0x0505
    191a:	0306                	.insn	2, 0x0306
    191c:	0004096b          	.insn	4, 0x0004096b
    1920:	0301                	.insn	2, 0x0301
    1922:	0901                	.insn	2, 0x0901
    1924:	0000                	.insn	2, 0x
    1926:	0501                	.insn	2, 0x0501
    1928:	0608                	.insn	2, 0x0608
    192a:	00090003          	lb	zero,0(s2)
    192e:	0100                	.insn	2, 0x0100
    1930:	0905                	.insn	2, 0x0905
    1932:	0306                	.insn	2, 0x0306
    1934:	00040903          	lb	s2,0(s0)
    1938:	0501                	.insn	2, 0x0501
    193a:	0305                	.insn	2, 0x0305
    193c:	0905                	.insn	2, 0x0905
    193e:	0000                	.insn	2, 0x
    1940:	0501                	.insn	2, 0x0501
    1942:	0608                	.insn	2, 0x0608
    1944:	00090003          	lb	zero,0(s2)
    1948:	0100                	.insn	2, 0x0100
    194a:	1005                	.insn	2, 0x1005
    194c:	04090003          	lb	zero,64(s2)
    1950:	0100                	.insn	2, 0x0100
    1952:	0505                	.insn	2, 0x0505
    1954:	0306                	.insn	2, 0x0306
    1956:	0906                	.insn	2, 0x0906
    1958:	0004                	.insn	2, 0x0004
    195a:	0501                	.insn	2, 0x0501
    195c:	0608                	.insn	2, 0x0608
    195e:	00090003          	lb	zero,0(s2)
    1962:	0100                	.insn	2, 0x0100
    1964:	0905                	.insn	2, 0x0905
    1966:	0306                	.insn	2, 0x0306
    1968:	0901                	.insn	2, 0x0901
    196a:	0004                	.insn	2, 0x0004
    196c:	0501                	.insn	2, 0x0501
    196e:	0003060f          	.insn	4, 0x0003060f
    1972:	0009                	.insn	2, 0x0009
    1974:	0100                	.insn	2, 0x0100
    1976:	0505                	.insn	2, 0x0505
    1978:	0306                	.insn	2, 0x0306
    197a:	0904                	.insn	2, 0x0904
    197c:	001c                	.insn	2, 0x001c
    197e:	0301                	.insn	2, 0x0301
    1980:	0901                	.insn	2, 0x0901
    1982:	0000                	.insn	2, 0x
    1984:	0501                	.insn	2, 0x0501
    1986:	0003060b          	.insn	4, 0x0003060b
    198a:	0009                	.insn	2, 0x0009
    198c:	0100                	.insn	2, 0x0100
    198e:	0200                	.insn	2, 0x0200
    1990:	0404                	.insn	2, 0x0404
    1992:	0c090003          	lb	zero,192(s2)
    1996:	0100                	.insn	2, 0x0100
    1998:	0505                	.insn	2, 0x0505
    199a:	0306                	.insn	2, 0x0306
    199c:	0904                	.insn	2, 0x0904
    199e:	0028                	.insn	2, 0x0028
    19a0:	0501                	.insn	2, 0x0501
    19a2:	0309                	.insn	2, 0x0309
    19a4:	0902                	.insn	2, 0x0902
    19a6:	0000                	.insn	2, 0x
    19a8:	0001                	.insn	2, 0x0001
    19aa:	0402                	.insn	2, 0x0402
    19ac:	0601                	.insn	2, 0x0601
    19ae:	00090003          	lb	zero,0(s2)
    19b2:	0100                	.insn	2, 0x0100
    19b4:	0200                	.insn	2, 0x0200
    19b6:	0404                	.insn	2, 0x0404
    19b8:	08090003          	lb	zero,128(s2)
    19bc:	0100                	.insn	2, 0x0100
    19be:	0306                	.insn	2, 0x0306
    19c0:	0902                	.insn	2, 0x0902
    19c2:	0014                	.insn	2, 0x0014
    19c4:	0501                	.insn	2, 0x0501
    19c6:	0631                	.insn	2, 0x0631
    19c8:	00090103          	lb	sp,0(s2)
    19cc:	0100                	.insn	2, 0x0100
    19ce:	0f05                	.insn	2, 0x0f05
    19d0:	04097f03          	.insn	4, 0x04097f03
    19d4:	0100                	.insn	2, 0x0100
    19d6:	3105                	.insn	2, 0x3105
    19d8:	04090103          	lb	sp,64(s2)
    19dc:	0100                	.insn	2, 0x0100
    19de:	0f05                	.insn	2, 0x0f05
    19e0:	04097f03          	.insn	4, 0x04097f03
    19e4:	0100                	.insn	2, 0x0100
    19e6:	0905                	.insn	2, 0x0905
    19e8:	0306                	.insn	2, 0x0306
    19ea:	0904                	.insn	2, 0x0904
    19ec:	0034                	.insn	2, 0x0034
    19ee:	0501                	.insn	2, 0x0501
    19f0:	060c                	.insn	2, 0x060c
    19f2:	00090003          	lb	zero,0(s2)
    19f6:	0100                	.insn	2, 0x0100
    19f8:	2405                	.insn	2, 0x2405
    19fa:	0306                	.insn	2, 0x0306
    19fc:	0901                	.insn	2, 0x0901
    19fe:	0004                	.insn	2, 0x0004
    1a00:	0501                	.insn	2, 0x0501
    1a02:	0618                	.insn	2, 0x0618
    1a04:	00090003          	lb	zero,0(s2)
    1a08:	0100                	.insn	2, 0x0100
    1a0a:	2405                	.insn	2, 0x2405
    1a0c:	04090003          	lb	zero,64(s2)
    1a10:	0100                	.insn	2, 0x0100
    1a12:	1105                	.insn	2, 0x1105
    1a14:	0306                	.insn	2, 0x0306
    1a16:	0901                	.insn	2, 0x0901
    1a18:	0004                	.insn	2, 0x0004
    1a1a:	0501                	.insn	2, 0x0501
    1a1c:	0624                	.insn	2, 0x0624
    1a1e:	10097f03          	.insn	4, 0x10097f03
    1a22:	0100                	.insn	2, 0x0100
    1a24:	1105                	.insn	2, 0x1105
    1a26:	04090103          	lb	sp,64(s2)
    1a2a:	0100                	.insn	2, 0x0100
    1a2c:	2405                	.insn	2, 0x2405
    1a2e:	0306                	.insn	2, 0x0306
    1a30:	097f 0008 0501 0601 	.insn	10, 0x0503060105010008097f
    1a38:	0503 
    1a3a:	0409                	.insn	2, 0x0409
    1a3c:	0100                	.insn	2, 0x0100
    1a3e:	0d05                	.insn	2, 0x0d05
    1a40:	0306                	.insn	2, 0x0306
    1a42:	0952                	.insn	2, 0x0952
    1a44:	0034                	.insn	2, 0x0034
    1a46:	0501                	.insn	2, 0x0501
    1a48:	0610                	.insn	2, 0x0610
    1a4a:	00090003          	lb	zero,0(s2)
    1a4e:	0100                	.insn	2, 0x0100
    1a50:	1c05                	.insn	2, 0x1c05
    1a52:	0200                	.insn	2, 0x0200
    1a54:	0104                	.insn	2, 0x0104
    1a56:	04090003          	lb	zero,64(s2)
    1a5a:	0100                	.insn	2, 0x0100
    1a5c:	1105                	.insn	2, 0x1105
    1a5e:	0306                	.insn	2, 0x0306
    1a60:	0901                	.insn	2, 0x0901
    1a62:	0004                	.insn	2, 0x0004
    1a64:	0501                	.insn	2, 0x0501
    1a66:	0305                	.insn	2, 0x0305
    1a68:	0906                	.insn	2, 0x0906
    1a6a:	0004                	.insn	2, 0x0004
    1a6c:	0301                	.insn	2, 0x0301
    1a6e:	0901                	.insn	2, 0x0901
    1a70:	0000                	.insn	2, 0x
    1a72:	0501                	.insn	2, 0x0501
    1a74:	0608                	.insn	2, 0x0608
    1a76:	00090003          	lb	zero,0(s2)
    1a7a:	0100                	.insn	2, 0x0100
    1a7c:	0905                	.insn	2, 0x0905
    1a7e:	0306                	.insn	2, 0x0306
    1a80:	00040903          	lb	s2,0(s0)
    1a84:	0501                	.insn	2, 0x0501
    1a86:	0305                	.insn	2, 0x0305
    1a88:	0905                	.insn	2, 0x0905
    1a8a:	0000                	.insn	2, 0x
    1a8c:	0501                	.insn	2, 0x0501
    1a8e:	0608                	.insn	2, 0x0608
    1a90:	00090003          	lb	zero,0(s2)
    1a94:	0100                	.insn	2, 0x0100
    1a96:	1005                	.insn	2, 0x1005
    1a98:	04090003          	lb	zero,64(s2)
    1a9c:	0100                	.insn	2, 0x0100
    1a9e:	04090203          	lb	tp,64(s2)
    1aa2:	0100                	.insn	2, 0x0100
    1aa4:	08097903          	.insn	4, 0x08097903
    1aa8:	0100                	.insn	2, 0x0100
    1aaa:	0505                	.insn	2, 0x0505
    1aac:	0306                	.insn	2, 0x0306
    1aae:	097c                	.insn	2, 0x097c
    1ab0:	0008                	.insn	2, 0x0008
    1ab2:	0301                	.insn	2, 0x0301
    1ab4:	0901                	.insn	2, 0x0901
    1ab6:	0000                	.insn	2, 0x
    1ab8:	0501                	.insn	2, 0x0501
    1aba:	0608                	.insn	2, 0x0608
    1abc:	00090003          	lb	zero,0(s2)
    1ac0:	0100                	.insn	2, 0x0100
    1ac2:	0905                	.insn	2, 0x0905
    1ac4:	0306                	.insn	2, 0x0306
    1ac6:	00040903          	lb	s2,0(s0)
    1aca:	0501                	.insn	2, 0x0501
    1acc:	0305                	.insn	2, 0x0305
    1ace:	0905                	.insn	2, 0x0905
    1ad0:	0000                	.insn	2, 0x
    1ad2:	0501                	.insn	2, 0x0501
    1ad4:	0608                	.insn	2, 0x0608
    1ad6:	00090003          	lb	zero,0(s2)
    1ada:	0100                	.insn	2, 0x0100
    1adc:	1005                	.insn	2, 0x1005
    1ade:	04090203          	lb	tp,64(s2)
    1ae2:	0100                	.insn	2, 0x0100
    1ae4:	04097e03          	.insn	4, 0x04097e03
    1ae8:	0100                	.insn	2, 0x0100
    1aea:	0905                	.insn	2, 0x0905
    1aec:	0306                	.insn	2, 0x0306
    1aee:	08097fb7          	lui	t6,0x8097
    1af2:	0100                	.insn	2, 0x0100
    1af4:	0f05                	.insn	2, 0x0f05
    1af6:	0306                	.insn	2, 0x0306
    1af8:	0900                	.insn	2, 0x0900
    1afa:	0000                	.insn	2, 0x
    1afc:	0501                	.insn	2, 0x0501
    1afe:	0402000b          	.insn	4, 0x0402000b
    1b02:	0304                	.insn	2, 0x0304
    1b04:	00d5                	.insn	2, 0x00d5
    1b06:	1409                	.insn	2, 0x1409
    1b08:	0100                	.insn	2, 0x0100
    1b0a:	3705                	.insn	2, 0x3705
    1b0c:	0306                	.insn	2, 0x0306
    1b0e:	0920                	.insn	2, 0x0920
    1b10:	004c                	.insn	2, 0x004c
    1b12:	0501                	.insn	2, 0x0501
    1b14:	0305                	.insn	2, 0x0305
    1b16:	0901                	.insn	2, 0x0901
    1b18:	002c                	.insn	2, 0x002c
    1b1a:	0301                	.insn	2, 0x0301
    1b1c:	0901                	.insn	2, 0x0901
    1b1e:	0000                	.insn	2, 0x
    1b20:	0301                	.insn	2, 0x0301
    1b22:	0902                	.insn	2, 0x0902
    1b24:	0000                	.insn	2, 0x
    1b26:	0501                	.insn	2, 0x0501
    1b28:	7c030637          	lui	a2,0x7c030
    1b2c:	0009                	.insn	2, 0x0009
    1b2e:	0100                	.insn	2, 0x0100
    1b30:	0805                	.insn	2, 0x0805
    1b32:	0c090403          	lb	s0,192(s2)
    1b36:	0100                	.insn	2, 0x0100
    1b38:	0c05                	.insn	2, 0x0c05
    1b3a:	0306                	.insn	2, 0x0306
    1b3c:	0905                	.insn	2, 0x0905
    1b3e:	0004                	.insn	2, 0x0004
    1b40:	0601                	.insn	2, 0x0601
    1b42:	20090203          	lb	tp,512(s2)
    1b46:	0100                	.insn	2, 0x0100
    1b48:	0d05                	.insn	2, 0x0d05
    1b4a:	04090d03          	lb	s10,64(s2)
    1b4e:	0100                	.insn	2, 0x0100
    1b50:	0c05                	.insn	2, 0x0c05
    1b52:	0200                	.insn	2, 0x0200
    1b54:	0104                	.insn	2, 0x0104
    1b56:	08092203          	lw	tp,128(s2)
    1b5a:	0100                	.insn	2, 0x0100
    1b5c:	0d05                	.insn	2, 0x0d05
    1b5e:	0306                	.insn	2, 0x0306
    1b60:	0280                	.insn	2, 0x0280
    1b62:	0809                	.insn	2, 0x0809
    1b64:	0100                	.insn	2, 0x0100
    1b66:	14090103          	lb	sp,320(s2)
    1b6a:	0100                	.insn	2, 0x0100
    1b6c:	00090103          	lb	sp,0(s2)
    1b70:	0100                	.insn	2, 0x0100
    1b72:	0c05                	.insn	2, 0x0c05
    1b74:	097dcd03          	lbu	s10,151(s11)
    1b78:	0000                	.insn	2, 0x
    1b7a:	0501                	.insn	2, 0x0501
    1b7c:	0309                	.insn	2, 0x0309
    1b7e:	0902                	.insn	2, 0x0902
    1b80:	0008                	.insn	2, 0x0008
    1b82:	0501                	.insn	2, 0x0501
    1b84:	03030613          	addi	a2,t1,48 # 9460ab6 <main-0x76b9f54a>
    1b88:	0009                	.insn	2, 0x0009
    1b8a:	0100                	.insn	2, 0x0100
    1b8c:	0c05                	.insn	2, 0x0c05
    1b8e:	04097d03          	.insn	4, 0x04097d03
    1b92:	0100                	.insn	2, 0x0100
    1b94:	0f05                	.insn	2, 0x0f05
    1b96:	04090b03          	lb	s6,64(s2)
    1b9a:	0100                	.insn	2, 0x0100
    1b9c:	0905                	.insn	2, 0x0905
    1b9e:	0306                	.insn	2, 0x0306
    1ba0:	0901                	.insn	2, 0x0901
    1ba2:	0004                	.insn	2, 0x0004
    1ba4:	0501                	.insn	2, 0x0501
    1ba6:	030d                	.insn	2, 0x030d
    1ba8:	0901                	.insn	2, 0x0901
    1baa:	0000                	.insn	2, 0x
    1bac:	0501                	.insn	2, 0x0501
    1bae:	0615                	.insn	2, 0x0615
    1bb0:	00090003          	lb	zero,0(s2)
    1bb4:	0100                	.insn	2, 0x0100
    1bb6:	1305                	.insn	2, 0x1305
    1bb8:	04092c03          	lw	s8,64(s2)
    1bbc:	0100                	.insn	2, 0x0100
    1bbe:	0d05                	.insn	2, 0x0d05
    1bc0:	04095403          	lhu	s0,64(s2)
    1bc4:	0100                	.insn	2, 0x0100
    1bc6:	1205                	.insn	2, 0x1205
    1bc8:	0306                	.insn	2, 0x0306
    1bca:	091e                	.insn	2, 0x091e
    1bcc:	0020                	.insn	2, 0x0020
    1bce:	0501                	.insn	2, 0x0501
    1bd0:	0309                	.insn	2, 0x0309
    1bd2:	00000903          	lb	s2,0(zero) # 0 <main-0x80000000>
    1bd6:	0301                	.insn	2, 0x0301
    1bd8:	0901                	.insn	2, 0x0901
    1bda:	0000                	.insn	2, 0x
    1bdc:	0501                	.insn	2, 0x0501
    1bde:	0329                	.insn	2, 0x0329
    1be0:	7ca0                	.insn	2, 0x7ca0
    1be2:	0009                	.insn	2, 0x0009
    1be4:	0100                	.insn	2, 0x0100
    1be6:	3c05                	.insn	2, 0x3c05
    1be8:	0306                	.insn	2, 0x0306
    1bea:	0900                	.insn	2, 0x0900
    1bec:	0000                	.insn	2, 0x
    1bee:	0501                	.insn	2, 0x0501
    1bf0:	000c                	.insn	2, 0x000c
    1bf2:	0402                	.insn	2, 0x0402
    1bf4:	0301                	.insn	2, 0x0301
    1bf6:	03e0                	.insn	2, 0x03e0
    1bf8:	0409                	.insn	2, 0x0409
    1bfa:	0100                	.insn	2, 0x0100
    1bfc:	1005                	.insn	2, 0x1005
    1bfe:	0306                	.insn	2, 0x0306
    1c00:	0902                	.insn	2, 0x0902
    1c02:	0008                	.insn	2, 0x0008
    1c04:	0501                	.insn	2, 0x0501
    1c06:	00030613          	addi	a2,t1,0
    1c0a:	0009                	.insn	2, 0x0009
    1c0c:	0100                	.insn	2, 0x0100
    1c0e:	0f05                	.insn	2, 0x0f05
    1c10:	04097d03          	.insn	4, 0x04097d03
    1c14:	0100                	.insn	2, 0x0100
    1c16:	1305                	.insn	2, 0x1305
    1c18:	04090303          	lb	t1,64(s2)
    1c1c:	0100                	.insn	2, 0x0100
    1c1e:	0905                	.insn	2, 0x0905
    1c20:	0306                	.insn	2, 0x0306
    1c22:	090c                	.insn	2, 0x090c
    1c24:	0004                	.insn	2, 0x0004
    1c26:	0301                	.insn	2, 0x0301
    1c28:	0901                	.insn	2, 0x0901
    1c2a:	0000                	.insn	2, 0x
    1c2c:	0501                	.insn	2, 0x0501
    1c2e:	060c                	.insn	2, 0x060c
    1c30:	00090003          	lb	zero,0(s2)
    1c34:	0100                	.insn	2, 0x0100
    1c36:	1305                	.insn	2, 0x1305
    1c38:	04097f03          	.insn	4, 0x04097f03
    1c3c:	0100                	.insn	2, 0x0100
    1c3e:	0c05                	.insn	2, 0x0c05
    1c40:	04090103          	lb	sp,64(s2)
    1c44:	0100                	.insn	2, 0x0100
    1c46:	0905                	.insn	2, 0x0905
    1c48:	0306                	.insn	2, 0x0306
    1c4a:	090d                	.insn	2, 0x090d
    1c4c:	0004                	.insn	2, 0x0004
    1c4e:	0501                	.insn	2, 0x0501
    1c50:	03030613          	addi	a2,t1,48
    1c54:	0409                	.insn	2, 0x0409
    1c56:	0100                	.insn	2, 0x0100
    1c58:	0905                	.insn	2, 0x0905
    1c5a:	04097d03          	.insn	4, 0x04097d03
    1c5e:	0100                	.insn	2, 0x0100
    1c60:	0d05                	.insn	2, 0x0d05
    1c62:	0306                	.insn	2, 0x0306
    1c64:	091c                	.insn	2, 0x091c
    1c66:	0018                	.insn	2, 0x0018
    1c68:	0501                	.insn	2, 0x0501
    1c6a:	0611                	.insn	2, 0x0611
    1c6c:	00096803          	.insn	4, 0x00096803
    1c70:	0100                	.insn	2, 0x0100
    1c72:	1305                	.insn	2, 0x1305
    1c74:	04091803          	lh	a6,64(s2)
    1c78:	0100                	.insn	2, 0x0100
    1c7a:	0d05                	.insn	2, 0x0d05
    1c7c:	0306                	.insn	2, 0x0306
    1c7e:	0902                	.insn	2, 0x0902
    1c80:	0004                	.insn	2, 0x0004
    1c82:	0301                	.insn	2, 0x0301
    1c84:	0901                	.insn	2, 0x0901
    1c86:	0000                	.insn	2, 0x
    1c88:	0501                	.insn	2, 0x0501
    1c8a:	0309                	.insn	2, 0x0309
    1c8c:	0000090b          	.insn	4, 0x090b
    1c90:	0501                	.insn	2, 0x0501
    1c92:	d6030613          	addi	a2,t1,-672
    1c96:	0900                	.insn	2, 0x0900
    1c98:	0004                	.insn	2, 0x0004
    1c9a:	0501                	.insn	2, 0x0501
    1c9c:	0309                	.insn	2, 0x0309
    1c9e:	7faa                	.insn	2, 0x7faa
    1ca0:	0409                	.insn	2, 0x0409
    1ca2:	0100                	.insn	2, 0x0100
    1ca4:	1105                	.insn	2, 0x1105
    1ca6:	0306                	.insn	2, 0x0306
    1ca8:	7f9a                	.insn	2, 0x7f9a
    1caa:	3409                	.insn	2, 0x3409
    1cac:	0100                	.insn	2, 0x0100
    1cae:	1705                	.insn	2, 0x1705
    1cb0:	0306                	.insn	2, 0x0306
    1cb2:	0900                	.insn	2, 0x0900
    1cb4:	0000                	.insn	2, 0x
    1cb6:	0501                	.insn	2, 0x0501
    1cb8:	0611                	.insn	2, 0x0611
    1cba:	04090103          	lb	sp,64(s2)
    1cbe:	0100                	.insn	2, 0x0100
    1cc0:	00090103          	lb	sp,0(s2)
    1cc4:	0100                	.insn	2, 0x0100
    1cc6:	00090103          	lb	sp,0(s2)
    1cca:	0100                	.insn	2, 0x0100
    1ccc:	0c05                	.insn	2, 0x0c05
    1cce:	0306                	.insn	2, 0x0306
    1cd0:	096c                	.insn	2, 0x096c
    1cd2:	0000                	.insn	2, 0x
    1cd4:	0501                	.insn	2, 0x0501
    1cd6:	0611                	.insn	2, 0x0611
    1cd8:	08091603          	lh	a2,128(s2)
    1cdc:	0100                	.insn	2, 0x0100
    1cde:	1705                	.insn	2, 0x1705
    1ce0:	0306                	.insn	2, 0x0306
    1ce2:	0900                	.insn	2, 0x0900
    1ce4:	0000                	.insn	2, 0x
    1ce6:	0501                	.insn	2, 0x0501
    1ce8:	0611                	.insn	2, 0x0611
    1cea:	04090103          	lb	sp,64(s2)
    1cee:	0100                	.insn	2, 0x0100
    1cf0:	00090103          	lb	sp,0(s2)
    1cf4:	0100                	.insn	2, 0x0100
    1cf6:	00090103          	lb	sp,0(s2)
    1cfa:	0100                	.insn	2, 0x0100
    1cfc:	0c05                	.insn	2, 0x0c05
    1cfe:	0306                	.insn	2, 0x0306
    1d00:	00000967          	jalr	s2,0(zero) # 0 <main-0x80000000>
    1d04:	0501                	.insn	2, 0x0501
    1d06:	0611                	.insn	2, 0x0611
    1d08:	08091b03          	lh	s6,128(s2)
    1d0c:	0100                	.insn	2, 0x0100
    1d0e:	1705                	.insn	2, 0x1705
    1d10:	0306                	.insn	2, 0x0306
    1d12:	0900                	.insn	2, 0x0900
    1d14:	0000                	.insn	2, 0x
    1d16:	0501                	.insn	2, 0x0501
    1d18:	0611                	.insn	2, 0x0611
    1d1a:	04090103          	lb	sp,64(s2)
    1d1e:	0100                	.insn	2, 0x0100
    1d20:	00090103          	lb	sp,0(s2)
    1d24:	0100                	.insn	2, 0x0100
    1d26:	00090103          	lb	sp,0(s2)
    1d2a:	0100                	.insn	2, 0x0100
    1d2c:	0c05                	.insn	2, 0x0c05
    1d2e:	0306                	.insn	2, 0x0306
    1d30:	0962                	.insn	2, 0x0962
    1d32:	0000                	.insn	2, 0x
    1d34:	0501                	.insn	2, 0x0501
    1d36:	0611                	.insn	2, 0x0611
    1d38:	08092503          	lw	a0,128(s2)
    1d3c:	0100                	.insn	2, 0x0100
    1d3e:	1705                	.insn	2, 0x1705
    1d40:	0306                	.insn	2, 0x0306
    1d42:	0900                	.insn	2, 0x0900
    1d44:	0000                	.insn	2, 0x
    1d46:	0501                	.insn	2, 0x0501
    1d48:	0611                	.insn	2, 0x0611
    1d4a:	04090103          	lb	sp,64(s2)
    1d4e:	0100                	.insn	2, 0x0100
    1d50:	00090103          	lb	sp,0(s2)
    1d54:	0100                	.insn	2, 0x0100
    1d56:	00090103          	lb	sp,0(s2)
    1d5a:	0100                	.insn	2, 0x0100
    1d5c:	0c05                	.insn	2, 0x0c05
    1d5e:	0306                	.insn	2, 0x0306
    1d60:	0958                	.insn	2, 0x0958
    1d62:	0000                	.insn	2, 0x
    1d64:	0501                	.insn	2, 0x0501
    1d66:	0611                	.insn	2, 0x0611
    1d68:	08092003          	lw	zero,128(s2)
    1d6c:	0100                	.insn	2, 0x0100
    1d6e:	1705                	.insn	2, 0x1705
    1d70:	0306                	.insn	2, 0x0306
    1d72:	0900                	.insn	2, 0x0900
    1d74:	0000                	.insn	2, 0x
    1d76:	0501                	.insn	2, 0x0501
    1d78:	0611                	.insn	2, 0x0611
    1d7a:	04090103          	lb	sp,64(s2)
    1d7e:	0100                	.insn	2, 0x0100
    1d80:	00090103          	lb	sp,0(s2)
    1d84:	0100                	.insn	2, 0x0100
    1d86:	00090103          	lb	sp,0(s2)
    1d8a:	0100                	.insn	2, 0x0100
    1d8c:	0c05                	.insn	2, 0x0c05
    1d8e:	0306                	.insn	2, 0x0306
    1d90:	095d                	.insn	2, 0x095d
    1d92:	0000                	.insn	2, 0x
    1d94:	0501                	.insn	2, 0x0501
    1d96:	0312                	.insn	2, 0x0312
    1d98:	7cd5                	.insn	2, 0x7cd5
    1d9a:	0809                	.insn	2, 0x0809
    1d9c:	0100                	.insn	2, 0x0100
    1d9e:	0905                	.insn	2, 0x0905
    1da0:	0306                	.insn	2, 0x0306
    1da2:	0902                	.insn	2, 0x0902
    1da4:	0004                	.insn	2, 0x0004
    1da6:	0501                	.insn	2, 0x0501
    1da8:	0003060f          	.insn	4, 0x0003060f
    1dac:	0009                	.insn	2, 0x0009
    1dae:	0100                	.insn	2, 0x0100
    1db0:	1505                	.insn	2, 0x1505
    1db2:	0c090003          	lb	zero,192(s2)
    1db6:	0100                	.insn	2, 0x0100
    1db8:	0c05                	.insn	2, 0x0c05
    1dba:	04097f03          	.insn	4, 0x04097f03
    1dbe:	0100                	.insn	2, 0x0100
    1dc0:	0b05                	.insn	2, 0x0b05
    1dc2:	04090103          	lb	sp,64(s2)
    1dc6:	0100                	.insn	2, 0x0100
    1dc8:	2e05                	.insn	2, 0x2e05
    1dca:	04090003          	lb	zero,64(s2)
    1dce:	0100                	.insn	2, 0x0100
    1dd0:	0c05                	.insn	2, 0x0c05
    1dd2:	0306                	.insn	2, 0x0306
    1dd4:	097f 0004 0501 0329 	.insn	10, 0x097b032905010004097f
    1ddc:	097b 
    1dde:	0000                	.insn	2, 0x
    1de0:	0501                	.insn	2, 0x0501
    1de2:	063c                	.insn	2, 0x063c
    1de4:	00090003          	lb	zero,0(s2)
    1de8:	0100                	.insn	2, 0x0100
    1dea:	0c05                	.insn	2, 0x0c05
    1dec:	0200                	.insn	2, 0x0200
    1dee:	0104                	.insn	2, 0x0104
    1df0:	04090503          	lb	a0,64(s2)
    1df4:	0100                	.insn	2, 0x0100
    1df6:	0905                	.insn	2, 0x0905
    1df8:	0306                	.insn	2, 0x0306
    1dfa:	03e9                	.insn	2, 0x03e9
    1dfc:	0c09                	.insn	2, 0x0c09
    1dfe:	0100                	.insn	2, 0x0100
    1e00:	00090103          	lb	sp,0(s2)
    1e04:	0100                	.insn	2, 0x0100
    1e06:	0c05                	.insn	2, 0x0c05
    1e08:	0306                	.insn	2, 0x0306
    1e0a:	0900                	.insn	2, 0x0900
    1e0c:	0000                	.insn	2, 0x
    1e0e:	0501                	.insn	2, 0x0501
    1e10:	097f0313          	addi	t1,t5,151
    1e14:	0004                	.insn	2, 0x0004
    1e16:	0501                	.insn	2, 0x0501
    1e18:	030c                	.insn	2, 0x030c
    1e1a:	0901                	.insn	2, 0x0901
    1e1c:	0004                	.insn	2, 0x0004
    1e1e:	0501                	.insn	2, 0x0501
    1e20:	0311                	.insn	2, 0x0311
    1e22:	00040903          	lb	s2,0(s0)
    1e26:	0501                	.insn	2, 0x0501
    1e28:	0010                	.insn	2, 0x0010
    1e2a:	0402                	.insn	2, 0x0402
    1e2c:	0301                	.insn	2, 0x0301
    1e2e:	0900                	.insn	2, 0x0900
    1e30:	0004                	.insn	2, 0x0004
    1e32:	0501                	.insn	2, 0x0501
    1e34:	097e0313          	addi	t1,t3,151
    1e38:	0004                	.insn	2, 0x0004
    1e3a:	0501                	.insn	2, 0x0501
    1e3c:	033c                	.insn	2, 0x033c
    1e3e:	7c90                	.insn	2, 0x7c90
    1e40:	0409                	.insn	2, 0x0409
    1e42:	0100                	.insn	2, 0x0100
    1e44:	1005                	.insn	2, 0x1005
    1e46:	0200                	.insn	2, 0x0200
    1e48:	0104                	.insn	2, 0x0104
    1e4a:	0903f203          	.insn	4, 0x0903f203
    1e4e:	0004                	.insn	2, 0x0004
    1e50:	0501                	.insn	2, 0x0501
    1e52:	097f0313          	addi	t1,t5,151
    1e56:	0004                	.insn	2, 0x0004
    1e58:	0501                	.insn	2, 0x0501
    1e5a:	060d                	.insn	2, 0x060d
    1e5c:	04097f03          	.insn	4, 0x04097f03
    1e60:	0100                	.insn	2, 0x0100
    1e62:	00090103          	lb	sp,0(s2)
    1e66:	0100                	.insn	2, 0x0100
    1e68:	00090103          	lb	sp,0(s2)
    1e6c:	0100                	.insn	2, 0x0100
    1e6e:	2905                	.insn	2, 0x2905
    1e70:	097c8e03          	lb	t3,151(s9)
    1e74:	0000                	.insn	2, 0x
    1e76:	0501                	.insn	2, 0x0501
    1e78:	0010                	.insn	2, 0x0010
    1e7a:	0402                	.insn	2, 0x0402
    1e7c:	0601                	.insn	2, 0x0601
    1e7e:	0903f203          	.insn	4, 0x0903f203
    1e82:	0000                	.insn	2, 0x
    1e84:	0501                	.insn	2, 0x0501
    1e86:	0614                	.insn	2, 0x0614
    1e88:	04090203          	lb	tp,64(s2)
    1e8c:	0100                	.insn	2, 0x0100
    1e8e:	1705                	.insn	2, 0x1705
    1e90:	0306                	.insn	2, 0x0306
    1e92:	0900                	.insn	2, 0x0900
    1e94:	0000                	.insn	2, 0x
    1e96:	0501                	.insn	2, 0x0501
    1e98:	097d0313          	addi	t1,s10,151
    1e9c:	0008                	.insn	2, 0x0008
    1e9e:	0501                	.insn	2, 0x0501
    1ea0:	0309                	.insn	2, 0x0309
    1ea2:	0004090b          	.insn	4, 0x0004090b
    1ea6:	0601                	.insn	2, 0x0601
    1ea8:	08090003          	lb	zero,128(s2)
    1eac:	0100                	.insn	2, 0x0100
    1eae:	1305                	.insn	2, 0x1305
    1eb0:	0306                	.insn	2, 0x0306
    1eb2:	00000903          	lb	s2,0(zero) # 0 <main-0x80000000>
    1eb6:	0501                	.insn	2, 0x0501
    1eb8:	0309                	.insn	2, 0x0309
    1eba:	097d                	.insn	2, 0x097d
    1ebc:	0004                	.insn	2, 0x0004
    1ebe:	0501                	.insn	2, 0x0501
    1ec0:	060d                	.insn	2, 0x060d
    1ec2:	04090203          	lb	tp,64(s2)
    1ec6:	0100                	.insn	2, 0x0100
    1ec8:	1105                	.insn	2, 0x1105
    1eca:	0306                	.insn	2, 0x0306
    1ecc:	0902                	.insn	2, 0x0902
    1ece:	0000                	.insn	2, 0x
    1ed0:	0501                	.insn	2, 0x0501
    1ed2:	0310                	.insn	2, 0x0310
    1ed4:	0900                	.insn	2, 0x0900
    1ed6:	0004                	.insn	2, 0x0004
    1ed8:	0501                	.insn	2, 0x0501
    1eda:	097e0313          	addi	t1,t3,151
    1ede:	0004                	.insn	2, 0x0004
    1ee0:	0501                	.insn	2, 0x0501
    1ee2:	060d                	.insn	2, 0x060d
    1ee4:	04090103          	lb	sp,64(s2)
    1ee8:	0100                	.insn	2, 0x0100
    1eea:	00090103          	lb	sp,0(s2)
    1eee:	0100                	.insn	2, 0x0100
    1ef0:	1005                	.insn	2, 0x1005
    1ef2:	0306                	.insn	2, 0x0306
    1ef4:	0900                	.insn	2, 0x0900
    1ef6:	0000                	.insn	2, 0x
    1ef8:	0501                	.insn	2, 0x0501
    1efa:	0311                	.insn	2, 0x0311
    1efc:	0902                	.insn	2, 0x0902
    1efe:	0004                	.insn	2, 0x0004
    1f00:	0001                	.insn	2, 0x0001
    1f02:	0402                	.insn	2, 0x0402
    1f04:	0301                	.insn	2, 0x0301
    1f06:	0900                	.insn	2, 0x0900
    1f08:	0008                	.insn	2, 0x0008
    1f0a:	0501                	.insn	2, 0x0501
    1f0c:	0329                	.insn	2, 0x0329
    1f0e:	7bc2                	.insn	2, 0x7bc2
    1f10:	0409                	.insn	2, 0x0409
    1f12:	0100                	.insn	2, 0x0100
    1f14:	1105                	.insn	2, 0x1105
    1f16:	0200                	.insn	2, 0x0200
    1f18:	0304                	.insn	2, 0x0304
    1f1a:	0306                	.insn	2, 0x0306
    1f1c:	04be                	.insn	2, 0x04be
    1f1e:	0409                	.insn	2, 0x0409
    1f20:	0100                	.insn	2, 0x0100
    1f22:	2105                	.insn	2, 0x2105
    1f24:	097bc203          	lbu	tp,151(s7)
    1f28:	0004                	.insn	2, 0x0004
    1f2a:	0501                	.insn	2, 0x0501
    1f2c:	0629                	.insn	2, 0x0629
    1f2e:	00090003          	lb	zero,0(s2)
    1f32:	0100                	.insn	2, 0x0100
    1f34:	1105                	.insn	2, 0x1105
    1f36:	0200                	.insn	2, 0x0200
    1f38:	0104                	.insn	2, 0x0104
    1f3a:	0306                	.insn	2, 0x0306
    1f3c:	04be                	.insn	2, 0x04be
    1f3e:	0409                	.insn	2, 0x0409
    1f40:	0100                	.insn	2, 0x0100
    1f42:	3905                	.insn	2, 0x3905
    1f44:	0200                	.insn	2, 0x0200
    1f46:	0404                	.insn	2, 0x0404
    1f48:	08090003          	lb	zero,128(s2)
    1f4c:	0100                	.insn	2, 0x0100
    1f4e:	1105                	.insn	2, 0x1105
    1f50:	00090203          	lb	tp,0(s2)
    1f54:	0100                	.insn	2, 0x0100
    1f56:	0306                	.insn	2, 0x0306
    1f58:	0922                	.insn	2, 0x0922
    1f5a:	0000                	.insn	2, 0x
    1f5c:	0501                	.insn	2, 0x0501
    1f5e:	095e0317          	auipc	t1,0x95e0
    1f62:	0004                	.insn	2, 0x0004
    1f64:	0501                	.insn	2, 0x0501
    1f66:	0611                	.insn	2, 0x0611
    1f68:	04090103          	lb	sp,64(s2)
    1f6c:	0100                	.insn	2, 0x0100
    1f6e:	1705                	.insn	2, 0x1705
    1f70:	0306                	.insn	2, 0x0306
    1f72:	0900                	.insn	2, 0x0900
    1f74:	0000                	.insn	2, 0x
    1f76:	0501                	.insn	2, 0x0501
    1f78:	030c                	.insn	2, 0x030c
    1f7a:	01e5                	.insn	2, 0x01e5
    1f7c:	0809                	.insn	2, 0x0809
    1f7e:	0100                	.insn	2, 0x0100
    1f80:	0505                	.insn	2, 0x0505
    1f82:	0306                	.insn	2, 0x0306
    1f84:	097d                	.insn	2, 0x097d
    1f86:	0014                	.insn	2, 0x0014
    1f88:	0501                	.insn	2, 0x0501
    1f8a:	060c                	.insn	2, 0x060c
    1f8c:	00090303          	lb	t1,0(s2)
    1f90:	0100                	.insn	2, 0x0100
    1f92:	0505                	.insn	2, 0x0505
    1f94:	04097d03          	.insn	4, 0x04097d03
    1f98:	0100                	.insn	2, 0x0100
    1f9a:	0200                	.insn	2, 0x0200
    1f9c:	0104                	.insn	2, 0x0104
    1f9e:	04090003          	lb	zero,64(s2)
    1fa2:	0100                	.insn	2, 0x0100
    1fa4:	0200                	.insn	2, 0x0200
    1fa6:	0404                	.insn	2, 0x0404
    1fa8:	04090003          	lb	zero,64(s2)
    1fac:	0100                	.insn	2, 0x0100
    1fae:	0306                	.insn	2, 0x0306
    1fb0:	00140903          	lb	s2,1(s0)
    1fb4:	0501                	.insn	2, 0x0501
    1fb6:	0601                	.insn	2, 0x0601
    1fb8:	00090103          	lb	sp,0(s2)
    1fbc:	0100                	.insn	2, 0x0100
    1fbe:	0905                	.insn	2, 0x0905
    1fc0:	097e9103          	lh	sp,151(t4)
    1fc4:	002c                	.insn	2, 0x002c
    1fc6:	0501                	.insn	2, 0x0501
    1fc8:	060d                	.insn	2, 0x060d
    1fca:	08092103          	lw	sp,128(s2)
    1fce:	0100                	.insn	2, 0x0100
    1fd0:	1105                	.insn	2, 0x1105
    1fd2:	0306                	.insn	2, 0x0306
    1fd4:	00000963          	beq	zero,zero,1fe6 <main-0x7fffe01a>
    1fd8:	0501                	.insn	2, 0x0501
    1fda:	091d0313          	addi	t1,s10,145
    1fde:	0004                	.insn	2, 0x0004
    1fe0:	0501                	.insn	2, 0x0501
    1fe2:	060d                	.insn	2, 0x060d
    1fe4:	04090203          	lb	tp,64(s2)
    1fe8:	0100                	.insn	2, 0x0100
    1fea:	00090103          	lb	sp,0(s2)
    1fee:	0100                	.insn	2, 0x0100
    1ff0:	04094303          	lbu	t1,64(s2)
    1ff4:	0100                	.insn	2, 0x0100
    1ff6:	1705                	.insn	2, 0x1705
    1ff8:	0306                	.insn	2, 0x0306
    1ffa:	0900                	.insn	2, 0x0900
    1ffc:	0000                	.insn	2, 0x
    1ffe:	0501                	.insn	2, 0x0501
    2000:	060d                	.insn	2, 0x060d
    2002:	08090103          	lb	sp,128(s2)
    2006:	0100                	.insn	2, 0x0100
    2008:	1005                	.insn	2, 0x1005
    200a:	0306                	.insn	2, 0x0306
    200c:	0900                	.insn	2, 0x0900
    200e:	0000                	.insn	2, 0x
    2010:	0501                	.insn	2, 0x0501
    2012:	060d                	.insn	2, 0x060d
    2014:	04090603          	lb	a2,64(s2)
    2018:	0100                	.insn	2, 0x0100
    201a:	0306                	.insn	2, 0x0306
    201c:	0905                	.insn	2, 0x0905
    201e:	0000                	.insn	2, 0x
    2020:	0501                	.insn	2, 0x0501
    2022:	097b0313          	addi	t1,s6,151
    2026:	0004                	.insn	2, 0x0004
    2028:	0501                	.insn	2, 0x0501
    202a:	0611                	.insn	2, 0x0611
    202c:	0c097b03          	.insn	4, 0x0c097b03
    2030:	0100                	.insn	2, 0x0100
    2032:	0d05                	.insn	2, 0x0d05
    2034:	0306                	.insn	2, 0x0306
    2036:	090a                	.insn	2, 0x090a
    2038:	0000                	.insn	2, 0x
    203a:	0501                	.insn	2, 0x0501
    203c:	09760317          	auipc	t1,0x9760
    2040:	0004                	.insn	2, 0x0004
    2042:	0501                	.insn	2, 0x0501
    2044:	0611                	.insn	2, 0x0611
    2046:	04090103          	lb	sp,64(s2)
    204a:	0100                	.insn	2, 0x0100
    204c:	1305                	.insn	2, 0x1305
    204e:	0306                	.insn	2, 0x0306
    2050:	0904                	.insn	2, 0x0904
    2052:	0000                	.insn	2, 0x
    2054:	0501                	.insn	2, 0x0501
    2056:	097c0327          	.insn	4, 0x097c0327
    205a:	0004                	.insn	2, 0x0004
    205c:	0501                	.insn	2, 0x0501
    205e:	060d                	.insn	2, 0x060d
    2060:	04090403          	lb	s0,64(s2)
    2064:	0100                	.insn	2, 0x0100
    2066:	0905                	.insn	2, 0x0905
    2068:	08093c03          	.insn	4, 0x08093c03
    206c:	0100                	.insn	2, 0x0100
    206e:	1305                	.insn	2, 0x1305
    2070:	0306                	.insn	2, 0x0306
    2072:	00d6                	.insn	2, 0x00d6
    2074:	0409                	.insn	2, 0x0409
    2076:	0100                	.insn	2, 0x0100
    2078:	0905                	.insn	2, 0x0905
    207a:	097faa03          	lw	s4,151(t6) # 8097097 <main-0x77f68f69>
    207e:	0004                	.insn	2, 0x0004
    2080:	0501                	.insn	2, 0x0501
    2082:	00d60313          	addi	t1,a2,13 # 7c03000d <main-0x3fcfff3>
    2086:	1409                	.insn	2, 0x1409
    2088:	0100                	.insn	2, 0x0100
    208a:	0905                	.insn	2, 0x0905
    208c:	097f8003          	lb	zero,151(t6)
    2090:	0004                	.insn	2, 0x0004
    2092:	0301                	.insn	2, 0x0301
    2094:	092a                	.insn	2, 0x092a
    2096:	0004                	.insn	2, 0x0004
    2098:	0501                	.insn	2, 0x0501
    209a:	060d                	.insn	2, 0x060d
    209c:	0901a003          	lw	zero,144(gp) # 80003890 <__global_pointer$+0x90>
    20a0:	003c                	.insn	2, 0x003c
    20a2:	0301                	.insn	2, 0x0301
    20a4:	0901                	.insn	2, 0x0901
    20a6:	0000                	.insn	2, 0x
    20a8:	0501                	.insn	2, 0x0501
    20aa:	0311                	.insn	2, 0x0311
    20ac:	0909                	.insn	2, 0x0909
    20ae:	0000                	.insn	2, 0x
    20b0:	0501                	.insn	2, 0x0501
    20b2:	00030617          	auipc	a2,0x30
    20b6:	0009                	.insn	2, 0x0009
    20b8:	0100                	.insn	2, 0x0100
    20ba:	1305                	.insn	2, 0x1305
    20bc:	04097703          	.insn	4, 0x04097703
    20c0:	0100                	.insn	2, 0x0100
    20c2:	1705                	.insn	2, 0x1705
    20c4:	04090903          	lb	s2,64(s2)
    20c8:	0100                	.insn	2, 0x0100
    20ca:	3d05                	.insn	2, 0x3d05
    20cc:	2c090103          	lb	sp,704(s2)
    20d0:	0100                	.insn	2, 0x0100
    20d2:	1705                	.insn	2, 0x1705
    20d4:	04097f03          	.insn	4, 0x04097f03
    20d8:	0100                	.insn	2, 0x0100
    20da:	0d05                	.insn	2, 0x0d05
    20dc:	0306                	.insn	2, 0x0306
    20de:	0906                	.insn	2, 0x0906
    20e0:	0004                	.insn	2, 0x0004
    20e2:	0301                	.insn	2, 0x0301
    20e4:	0901                	.insn	2, 0x0901
    20e6:	0000                	.insn	2, 0x
    20e8:	0301                	.insn	2, 0x0301
    20ea:	7fb6                	.insn	2, 0x7fb6
    20ec:	0409                	.insn	2, 0x0409
    20ee:	0100                	.insn	2, 0x0100
    20f0:	1005                	.insn	2, 0x1005
    20f2:	0306                	.insn	2, 0x0306
    20f4:	0900                	.insn	2, 0x0900
    20f6:	0000                	.insn	2, 0x
    20f8:	0501                	.insn	2, 0x0501
    20fa:	0022                	.insn	2, 0x0022
    20fc:	0402                	.insn	2, 0x0402
    20fe:	0301                	.insn	2, 0x0301
    2100:	0900                	.insn	2, 0x0900
    2102:	0008                	.insn	2, 0x0008
    2104:	0501                	.insn	2, 0x0501
    2106:	060d                	.insn	2, 0x060d
    2108:	08090203          	lb	tp,128(s2)
    210c:	0100                	.insn	2, 0x0100
    210e:	1005                	.insn	2, 0x1005
    2110:	0306                	.insn	2, 0x0306
    2112:	0900                	.insn	2, 0x0900
    2114:	0000                	.insn	2, 0x
    2116:	0501                	.insn	2, 0x0501
    2118:	060d                	.insn	2, 0x060d
    211a:	08090203          	lb	tp,128(s2)
    211e:	0100                	.insn	2, 0x0100
    2120:	1305                	.insn	2, 0x1305
    2122:	0306                	.insn	2, 0x0306
    2124:	0900                	.insn	2, 0x0900
    2126:	0000                	.insn	2, 0x
    2128:	0001                	.insn	2, 0x0001
    212a:	0402                	.insn	2, 0x0402
    212c:	0301                	.insn	2, 0x0301
    212e:	0900                	.insn	2, 0x0900
    2130:	0008                	.insn	2, 0x0008
    2132:	0301                	.insn	2, 0x0301
    2134:	0900                	.insn	2, 0x0900
    2136:	0024                	.insn	2, 0x0024
    2138:	0001                	.insn	2, 0x0001
    213a:	0402                	.insn	2, 0x0402
    213c:	0301                	.insn	2, 0x0301
    213e:	0900                	.insn	2, 0x0900
    2140:	0004                	.insn	2, 0x0004
    2142:	0501                	.insn	2, 0x0501
    2144:	060d                	.insn	2, 0x060d
    2146:	04090203          	lb	tp,64(s2)
    214a:	0100                	.insn	2, 0x0100
    214c:	00090103          	lb	sp,0(s2)
    2150:	0100                	.insn	2, 0x0100
    2152:	04096e03          	.insn	4, 0x04096e03
    2156:	0100                	.insn	2, 0x0100
    2158:	1005                	.insn	2, 0x1005
    215a:	0306                	.insn	2, 0x0306
    215c:	0900                	.insn	2, 0x0900
    215e:	0000                	.insn	2, 0x
    2160:	0501                	.insn	2, 0x0501
    2162:	060d                	.insn	2, 0x060d
    2164:	08090203          	lb	tp,128(s2)
    2168:	0100                	.insn	2, 0x0100
    216a:	1305                	.insn	2, 0x1305
    216c:	0306                	.insn	2, 0x0306
    216e:	0900                	.insn	2, 0x0900
    2170:	0000                	.insn	2, 0x
    2172:	0001                	.insn	2, 0x0001
    2174:	0402                	.insn	2, 0x0402
    2176:	0301                	.insn	2, 0x0301
    2178:	0900                	.insn	2, 0x0900
    217a:	0008                	.insn	2, 0x0008
    217c:	0301                	.insn	2, 0x0301
    217e:	0900                	.insn	2, 0x0900
    2180:	0024                	.insn	2, 0x0024
    2182:	0001                	.insn	2, 0x0001
    2184:	0402                	.insn	2, 0x0402
    2186:	0301                	.insn	2, 0x0301
    2188:	0900                	.insn	2, 0x0900
    218a:	0004                	.insn	2, 0x0004
    218c:	0501                	.insn	2, 0x0501
    218e:	060d                	.insn	2, 0x060d
    2190:	04090203          	lb	tp,64(s2)
    2194:	0100                	.insn	2, 0x0100
    2196:	00090103          	lb	sp,0(s2)
    219a:	0100                	.insn	2, 0x0100
    219c:	0900d403          	lhu	s0,144(ra)
    21a0:	0004                	.insn	2, 0x0004
    21a2:	0301                	.insn	2, 0x0301
    21a4:	0901                	.insn	2, 0x0901
    21a6:	0018                	.insn	2, 0x0018
    21a8:	0301                	.insn	2, 0x0301
    21aa:	0901                	.insn	2, 0x0901
    21ac:	0000                	.insn	2, 0x
    21ae:	0301                	.insn	2, 0x0301
    21b0:	04097fbb          	.insn	4, 0x04097fbb
    21b4:	0100                	.insn	2, 0x0100
    21b6:	00090203          	lb	tp,0(s2)
    21ba:	0100                	.insn	2, 0x0100
    21bc:	2005                	.insn	2, 0x2005
    21be:	0306                	.insn	2, 0x0306
    21c0:	7fbc                	.insn	2, 0x7fbc
    21c2:	0009                	.insn	2, 0x0009
    21c4:	0100                	.insn	2, 0x0100
    21c6:	1905                	.insn	2, 0x1905
    21c8:	0900c403          	lbu	s0,144(ra)
    21cc:	0004                	.insn	2, 0x0004
    21ce:	0501                	.insn	2, 0x0501
    21d0:	0320                	.insn	2, 0x0320
    21d2:	7fbc                	.insn	2, 0x7fbc
    21d4:	0409                	.insn	2, 0x0409
    21d6:	0100                	.insn	2, 0x0100
    21d8:	0d05                	.insn	2, 0x0d05
    21da:	097edd03          	lhu	s10,151(t4)
    21de:	0004                	.insn	2, 0x0004
    21e0:	0501                	.insn	2, 0x0501
    21e2:	0310                	.insn	2, 0x0310
    21e4:	040901e7          	jalr	gp,64(s2)
    21e8:	0100                	.insn	2, 0x0100
    21ea:	0d05                	.insn	2, 0x0d05
    21ec:	0306                	.insn	2, 0x0306
    21ee:	0906                	.insn	2, 0x0906
    21f0:	0004                	.insn	2, 0x0004
    21f2:	0001                	.insn	2, 0x0001
    21f4:	0402                	.insn	2, 0x0402
    21f6:	0601                	.insn	2, 0x0601
    21f8:	00090003          	lb	zero,0(s2)
    21fc:	0100                	.insn	2, 0x0100
    21fe:	0306                	.insn	2, 0x0306
    2200:	0902                	.insn	2, 0x0902
    2202:	0014                	.insn	2, 0x0014
    2204:	0501                	.insn	2, 0x0501
    2206:	031c                	.insn	2, 0x031c
    2208:	0901                	.insn	2, 0x0901
    220a:	0000                	.insn	2, 0x
    220c:	0501                	.insn	2, 0x0501
    220e:	0315                	.insn	2, 0x0315
    2210:	0901                	.insn	2, 0x0901
    2212:	000c                	.insn	2, 0x000c
    2214:	0501                	.insn	2, 0x0501
    2216:	031c                	.insn	2, 0x031c
    2218:	097f 0018 0501 030d 	.insn	10, 0x0904030d05010018097f
    2220:	0904 
    2222:	0004                	.insn	2, 0x0004
    2224:	0301                	.insn	2, 0x0301
    2226:	0901                	.insn	2, 0x0901
    2228:	0000                	.insn	2, 0x
    222a:	0501                	.insn	2, 0x0501
    222c:	78030617          	auipc	a2,0x78030
    2230:	0009                	.insn	2, 0x0009
    2232:	0100                	.insn	2, 0x0100
    2234:	0d05                	.insn	2, 0x0d05
    2236:	04090803          	lb	a6,64(s2)
    223a:	0100                	.insn	2, 0x0100
    223c:	0306                	.insn	2, 0x0306
    223e:	7ee1                	.insn	2, 0x7ee1
    2240:	0409                	.insn	2, 0x0409
    2242:	0100                	.insn	2, 0x0100
    2244:	00090103          	lb	sp,0(s2)
    2248:	0100                	.insn	2, 0x0100
    224a:	00090103          	lb	sp,0(s2)
    224e:	0100                	.insn	2, 0x0100
    2250:	1105                	.insn	2, 0x1105
    2252:	0306                	.insn	2, 0x0306
    2254:	0900                	.insn	2, 0x0900
    2256:	0000                	.insn	2, 0x
    2258:	0501                	.insn	2, 0x0501
    225a:	097e0313          	addi	t1,t3,151
    225e:	0004                	.insn	2, 0x0004
    2260:	0501                	.insn	2, 0x0501
    2262:	0310                	.insn	2, 0x0310
    2264:	0902                	.insn	2, 0x0902
    2266:	0004                	.insn	2, 0x0004
    2268:	0501                	.insn	2, 0x0501
    226a:	0611                	.insn	2, 0x0611
    226c:	04090103          	lb	sp,64(s2)
    2270:	0100                	.insn	2, 0x0100
    2272:	0306                	.insn	2, 0x0306
    2274:	091a                	.insn	2, 0x091a
    2276:	0000                	.insn	2, 0x
    2278:	0501                	.insn	2, 0x0501
    227a:	09660317          	auipc	t1,0x9660
    227e:	0004                	.insn	2, 0x0004
    2280:	0501                	.insn	2, 0x0501
    2282:	0611                	.insn	2, 0x0611
    2284:	04090103          	lb	sp,64(s2)
    2288:	0100                	.insn	2, 0x0100
    228a:	1705                	.insn	2, 0x1705
    228c:	0306                	.insn	2, 0x0306
    228e:	0900                	.insn	2, 0x0900
    2290:	0000                	.insn	2, 0x
    2292:	0501                	.insn	2, 0x0501
    2294:	030c                	.insn	2, 0x030c
    2296:	7fa2                	.insn	2, 0x7fa2
    2298:	0809                	.insn	2, 0x0809
    229a:	0100                	.insn	2, 0x0100
    229c:	0d05                	.insn	2, 0x0d05
    229e:	04097d03          	.insn	4, 0x04097d03
    22a2:	0100                	.insn	2, 0x0100
    22a4:	0c05                	.insn	2, 0x0c05
    22a6:	0306                	.insn	2, 0x0306
    22a8:	00080903          	lb	s2,0(a6)
    22ac:	0501                	.insn	2, 0x0501
    22ae:	0305                	.insn	2, 0x0305
    22b0:	02b8                	.insn	2, 0x02b8
    22b2:	0c09                	.insn	2, 0x0c09
    22b4:	0100                	.insn	2, 0x0100
    22b6:	0d05                	.insn	2, 0x0d05
    22b8:	08094503          	lbu	a0,128(s2)
    22bc:	0100                	.insn	2, 0x0100
    22be:	1905                	.insn	2, 0x1905
    22c0:	0306                	.insn	2, 0x0306
    22c2:	0900                	.insn	2, 0x0900
    22c4:	0000                	.insn	2, 0x
    22c6:	0501                	.insn	2, 0x0501
    22c8:	060d                	.insn	2, 0x060d
    22ca:	0c090103          	lb	sp,192(s2)
    22ce:	0100                	.insn	2, 0x0100
    22d0:	1e05                	.insn	2, 0x1e05
    22d2:	0200                	.insn	2, 0x0200
    22d4:	0204                	.insn	2, 0x0204
    22d6:	0306                	.insn	2, 0x0306
    22d8:	0900                	.insn	2, 0x0900
    22da:	0000                	.insn	2, 0x
    22dc:	0301                	.insn	2, 0x0301
    22de:	0900                	.insn	2, 0x0900
    22e0:	0004                	.insn	2, 0x0004
    22e2:	0001                	.insn	2, 0x0001
    22e4:	0402                	.insn	2, 0x0402
    22e6:	0301                	.insn	2, 0x0301
    22e8:	0900                	.insn	2, 0x0900
    22ea:	0004                	.insn	2, 0x0004
    22ec:	0501                	.insn	2, 0x0501
    22ee:	0016                	.insn	2, 0x0016
    22f0:	0402                	.insn	2, 0x0402
    22f2:	0601                	.insn	2, 0x0601
    22f4:	097acc03          	lbu	s8,151(s5)
    22f8:	0004                	.insn	2, 0x0004
    22fa:	0501                	.insn	2, 0x0501
    22fc:	04020013          	addi	zero,tp,64 # 40 <main-0x7fffffc0>
    2300:	0601                	.insn	2, 0x0601
    2302:	00090003          	lb	zero,0(s2)
    2306:	0100                	.insn	2, 0x0100
    2308:	1605                	.insn	2, 0x1605
    230a:	0200                	.insn	2, 0x0200
    230c:	0104                	.insn	2, 0x0104
    230e:	08090003          	lb	zero,128(s2)
    2312:	0100                	.insn	2, 0x0100
    2314:	0200                	.insn	2, 0x0200
    2316:	0304                	.insn	2, 0x0304
    2318:	08090003          	lb	zero,128(s2)
    231c:	0100                	.insn	2, 0x0100
    231e:	2405                	.insn	2, 0x2405
    2320:	0200                	.insn	2, 0x0200
    2322:	0404                	.insn	2, 0x0404
    2324:	0306                	.insn	2, 0x0306
    2326:	0900                	.insn	2, 0x0900
    2328:	0004                	.insn	2, 0x0004
    232a:	0501                	.insn	2, 0x0501
    232c:	0016                	.insn	2, 0x0016
    232e:	0402                	.insn	2, 0x0402
    2330:	0601                	.insn	2, 0x0601
    2332:	00090003          	lb	zero,0(s2)
    2336:	0100                	.insn	2, 0x0100
    2338:	2405                	.insn	2, 0x2405
    233a:	0200                	.insn	2, 0x0200
    233c:	0404                	.insn	2, 0x0404
    233e:	04090003          	lb	zero,64(s2)
    2342:	0100                	.insn	2, 0x0100
    2344:	1605                	.insn	2, 0x1605
    2346:	0200                	.insn	2, 0x0200
    2348:	0104                	.insn	2, 0x0104
    234a:	0306                	.insn	2, 0x0306
    234c:	0900                	.insn	2, 0x0900
    234e:	0004                	.insn	2, 0x0004
    2350:	0501                	.insn	2, 0x0501
    2352:	061d                	.insn	2, 0x061d
    2354:	04090203          	lb	tp,64(s2)
    2358:	0100                	.insn	2, 0x0100
    235a:	1705                	.insn	2, 0x1705
    235c:	0905b403          	.insn	4, 0x0905b403
    2360:	0004                	.insn	2, 0x0004
    2362:	0501                	.insn	2, 0x0501
    2364:	031d                	.insn	2, 0x031d
    2366:	7acc                	.insn	2, 0x7acc
    2368:	0409                	.insn	2, 0x0409
    236a:	0100                	.insn	2, 0x0100
    236c:	0505                	.insn	2, 0x0505
    236e:	0306                	.insn	2, 0x0306
    2370:	0900                	.insn	2, 0x0900
    2372:	0004                	.insn	2, 0x0004
    2374:	0501                	.insn	2, 0x0501
    2376:	030d                	.insn	2, 0x030d
    2378:	05b4                	.insn	2, 0x05b4
    237a:	0009                	.insn	2, 0x0009
    237c:	0100                	.insn	2, 0x0100
    237e:	1005                	.insn	2, 0x1005
    2380:	0306                	.insn	2, 0x0306
    2382:	0900                	.insn	2, 0x0900
    2384:	0000                	.insn	2, 0x
    2386:	0501                	.insn	2, 0x0501
    2388:	0611                	.insn	2, 0x0611
    238a:	04090103          	lb	sp,64(s2)
    238e:	0100                	.insn	2, 0x0100
    2390:	1305                	.insn	2, 0x1305
    2392:	0306                	.insn	2, 0x0306
    2394:	0900                	.insn	2, 0x0900
    2396:	0000                	.insn	2, 0x
    2398:	0501                	.insn	2, 0x0501
    239a:	060d                	.insn	2, 0x060d
    239c:	0c090203          	lb	tp,192(s2)
    23a0:	0100                	.insn	2, 0x0100
    23a2:	1905                	.insn	2, 0x1905
    23a4:	0306                	.insn	2, 0x0306
    23a6:	0900                	.insn	2, 0x0900
    23a8:	0000                	.insn	2, 0x
    23aa:	0501                	.insn	2, 0x0501
    23ac:	0310                	.insn	2, 0x0310
    23ae:	0900                	.insn	2, 0x0900
    23b0:	0004                	.insn	2, 0x0004
    23b2:	0501                	.insn	2, 0x0501
    23b4:	0319                	.insn	2, 0x0319
    23b6:	0900                	.insn	2, 0x0900
    23b8:	0004                	.insn	2, 0x0004
    23ba:	0501                	.insn	2, 0x0501
    23bc:	0311                	.insn	2, 0x0311
    23be:	00040907          	.insn	4, 0x00040907
    23c2:	0501                	.insn	2, 0x0501
    23c4:	0319                	.insn	2, 0x0319
    23c6:	0979                	.insn	2, 0x0979
    23c8:	0004                	.insn	2, 0x0004
    23ca:	0301                	.insn	2, 0x0301
    23cc:	0901                	.insn	2, 0x0901
    23ce:	0008                	.insn	2, 0x0008
    23d0:	0501                	.insn	2, 0x0501
    23d2:	003d                	.insn	2, 0x003d
    23d4:	0402                	.insn	2, 0x0402
    23d6:	0302                	.insn	2, 0x0302
    23d8:	0905                	.insn	2, 0x0905
    23da:	0004                	.insn	2, 0x0004
    23dc:	0501                	.insn	2, 0x0501
    23de:	0611                	.insn	2, 0x0611
    23e0:	04090103          	lb	sp,64(s2)
    23e4:	0100                	.insn	2, 0x0100
    23e6:	1e05                	.insn	2, 0x1e05
    23e8:	18097f03          	.insn	4, 0x18097f03
    23ec:	0100                	.insn	2, 0x0100
    23ee:	1505                	.insn	2, 0x1505
    23f0:	0306                	.insn	2, 0x0306
    23f2:	0900                	.insn	2, 0x0900
    23f4:	0000                	.insn	2, 0x
    23f6:	0501                	.insn	2, 0x0501
    23f8:	031e                	.insn	2, 0x031e
    23fa:	0900                	.insn	2, 0x0900
    23fc:	0010                	.insn	2, 0x0010
    23fe:	0501                	.insn	2, 0x0501
    2400:	0311                	.insn	2, 0x0311
    2402:	0901                	.insn	2, 0x0901
    2404:	0004                	.insn	2, 0x0004
    2406:	0501                	.insn	2, 0x0501
    2408:	060d                	.insn	2, 0x060d
    240a:	04090303          	lb	t1,64(s2)
    240e:	0100                	.insn	2, 0x0100
    2410:	1005                	.insn	2, 0x1005
    2412:	0306                	.insn	2, 0x0306
    2414:	0900                	.insn	2, 0x0900
    2416:	0000                	.insn	2, 0x
    2418:	0501                	.insn	2, 0x0501
    241a:	060d                	.insn	2, 0x060d
    241c:	08090503          	lb	a0,128(s2)
    2420:	0100                	.insn	2, 0x0100
    2422:	00090103          	lb	sp,0(s2)
    2426:	0100                	.insn	2, 0x0100
    2428:	1905                	.insn	2, 0x1905
    242a:	0306                	.insn	2, 0x0306
    242c:	096a                	.insn	2, 0x096a
    242e:	0000                	.insn	2, 0x
    2430:	0501                	.insn	2, 0x0501
    2432:	030d                	.insn	2, 0x030d
    2434:	0916                	.insn	2, 0x0916
    2436:	0004                	.insn	2, 0x0004
    2438:	0601                	.insn	2, 0x0601
    243a:	097eed03          	.insn	4, 0x097eed03
    243e:	0004                	.insn	2, 0x0004
    2440:	0301                	.insn	2, 0x0301
    2442:	0901                	.insn	2, 0x0901
    2444:	0000                	.insn	2, 0x
    2446:	0501                	.insn	2, 0x0501
    2448:	0311                	.insn	2, 0x0311
    244a:	000c0907          	.insn	4, 0x000c0907
    244e:	0301                	.insn	2, 0x0301
    2450:	0901                	.insn	2, 0x0901
    2452:	0000                	.insn	2, 0x
    2454:	0501                	.insn	2, 0x0501
    2456:	0610                	.insn	2, 0x0610
    2458:	00090803          	lb	a6,0(s2)
    245c:	0100                	.insn	2, 0x0100
    245e:	1705                	.insn	2, 0x1705
    2460:	04097803          	.insn	4, 0x04097803
    2464:	0100                	.insn	2, 0x0100
    2466:	0d05                	.insn	2, 0x0d05
    2468:	0306                	.insn	2, 0x0306
    246a:	00040903          	lb	s2,0(s0)
    246e:	0301                	.insn	2, 0x0301
    2470:	0905                	.insn	2, 0x0905
    2472:	0000                	.insn	2, 0x
    2474:	0501                	.insn	2, 0x0501
    2476:	0610                	.insn	2, 0x0610
    2478:	00090003          	lb	zero,0(s2)
    247c:	0100                	.insn	2, 0x0100
    247e:	0d05                	.insn	2, 0x0d05
    2480:	0306                	.insn	2, 0x0306
    2482:	0905                	.insn	2, 0x0905
    2484:	0004                	.insn	2, 0x0004
    2486:	0501                	.insn	2, 0x0501
    2488:	00030617          	auipc	a2,0x30
    248c:	0009                	.insn	2, 0x0009
    248e:	0100                	.insn	2, 0x0100
    2490:	1005                	.insn	2, 0x1005
    2492:	04090003          	lb	zero,64(s2)
    2496:	0100                	.insn	2, 0x0100
    2498:	1105                	.insn	2, 0x1105
    249a:	0306                	.insn	2, 0x0306
    249c:	0908                	.insn	2, 0x0908
    249e:	0004                	.insn	2, 0x0004
    24a0:	0501                	.insn	2, 0x0501
    24a2:	0003061b          	.insn	4, 0x0003061b
    24a6:	0009                	.insn	2, 0x0009
    24a8:	0100                	.insn	2, 0x0100
    24aa:	1405                	.insn	2, 0x1405
    24ac:	04090003          	lb	zero,64(s2)
    24b0:	0100                	.insn	2, 0x0100
    24b2:	1805                	.insn	2, 0x1805
    24b4:	0306                	.insn	2, 0x0306
    24b6:	0908                	.insn	2, 0x0908
    24b8:	0004                	.insn	2, 0x0004
    24ba:	0501                	.insn	2, 0x0501
    24bc:	0622                	.insn	2, 0x0622
    24be:	00090003          	lb	zero,0(s2)
    24c2:	0100                	.insn	2, 0x0100
    24c4:	2005                	.insn	2, 0x2005
    24c6:	04090103          	lb	sp,64(s2)
    24ca:	0100                	.insn	2, 0x0100
    24cc:	1b05                	.insn	2, 0x1b05
    24ce:	04097f03          	.insn	4, 0x04097f03
    24d2:	0100                	.insn	2, 0x0100
    24d4:	1505                	.insn	2, 0x1505
    24d6:	0306                	.insn	2, 0x0306
    24d8:	00040907          	.insn	4, 0x00040907
    24dc:	0501                	.insn	2, 0x0501
    24de:	0620                	.insn	2, 0x0620
    24e0:	00090103          	lb	sp,0(s2)
    24e4:	0100                	.insn	2, 0x0100
    24e6:	1905                	.insn	2, 0x1905
    24e8:	04090103          	lb	sp,64(s2)
    24ec:	0100                	.insn	2, 0x0100
    24ee:	2205                	.insn	2, 0x2205
    24f0:	0200                	.insn	2, 0x0200
    24f2:	0204                	.insn	2, 0x0204
    24f4:	04090003          	lb	zero,64(s2)
    24f8:	0100                	.insn	2, 0x0100
    24fa:	3105                	.insn	2, 0x3105
    24fc:	04090103          	lb	sp,64(s2)
    2500:	0100                	.insn	2, 0x0100
    2502:	3305                	.insn	2, 0x3305
    2504:	0200                	.insn	2, 0x0200
    2506:	0104                	.insn	2, 0x0104
    2508:	04097f03          	.insn	4, 0x04097f03
    250c:	0100                	.insn	2, 0x0100
    250e:	1905                	.insn	2, 0x1905
    2510:	04090403          	lb	s0,64(s2)
    2514:	0100                	.insn	2, 0x0100
    2516:	1505                	.insn	2, 0x1505
    2518:	0306                	.insn	2, 0x0306
    251a:	097e                	.insn	2, 0x097e
    251c:	0014                	.insn	2, 0x0014
    251e:	0501                	.insn	2, 0x0501
    2520:	0003061b          	.insn	4, 0x0003061b
    2524:	0009                	.insn	2, 0x0009
    2526:	0100                	.insn	2, 0x0100
    2528:	0c05                	.insn	2, 0x0c05
    252a:	0200                	.insn	2, 0x0200
    252c:	0104                	.insn	2, 0x0104
    252e:	097ba503          	lw	a0,151(s7)
    2532:	001c                	.insn	2, 0x001c
    2534:	0501                	.insn	2, 0x0501
    2536:	0609                	.insn	2, 0x0609
    2538:	04090103          	lb	sp,64(s2)
    253c:	0100                	.insn	2, 0x0100
    253e:	0f05                	.insn	2, 0x0f05
    2540:	0306                	.insn	2, 0x0306
    2542:	0900                	.insn	2, 0x0900
    2544:	0000                	.insn	2, 0x
    2546:	0501                	.insn	2, 0x0501
    2548:	032e                	.insn	2, 0x032e
    254a:	0900                	.insn	2, 0x0900
    254c:	0008                	.insn	2, 0x0008
    254e:	0501                	.insn	2, 0x0501
    2550:	0900030f          	.insn	4, 0x0900030f
    2554:	0004                	.insn	2, 0x0004
    2556:	0501                	.insn	2, 0x0501
    2558:	0315                	.insn	2, 0x0315
    255a:	0900                	.insn	2, 0x0900
    255c:	0004                	.insn	2, 0x0004
    255e:	0501                	.insn	2, 0x0501
    2560:	030c                	.insn	2, 0x030c
    2562:	097f 0004 0501 030b 	.insn	10, 0x0901030b05010004097f
    256a:	0901 
    256c:	0004                	.insn	2, 0x0004
    256e:	0501                	.insn	2, 0x0501
    2570:	060c                	.insn	2, 0x060c
    2572:	04097f03          	.insn	4, 0x04097f03
    2576:	0100                	.insn	2, 0x0100
    2578:	2905                	.insn	2, 0x2905
    257a:	00097b03          	.insn	4, 0x00097b03
    257e:	0100                	.insn	2, 0x0100
    2580:	3c05                	.insn	2, 0x3c05
    2582:	0306                	.insn	2, 0x0306
    2584:	0900                	.insn	2, 0x0900
    2586:	0000                	.insn	2, 0x
    2588:	0501                	.insn	2, 0x0501
    258a:	000c                	.insn	2, 0x000c
    258c:	0402                	.insn	2, 0x0402
    258e:	0301                	.insn	2, 0x0301
    2590:	0905                	.insn	2, 0x0905
    2592:	0004                	.insn	2, 0x0004
    2594:	0501                	.insn	2, 0x0501
    2596:	0611                	.insn	2, 0x0611
    2598:	0903f003          	.insn	4, 0x0903f003
    259c:	0014                	.insn	2, 0x0014
    259e:	0301                	.insn	2, 0x0301
    25a0:	0901                	.insn	2, 0x0901
    25a2:	0000                	.insn	2, 0x
    25a4:	0501                	.insn	2, 0x0501
    25a6:	0003063b          	.insn	4, 0x0003063b
    25aa:	0009                	.insn	2, 0x0009
    25ac:	0100                	.insn	2, 0x0100
    25ae:	1105                	.insn	2, 0x1105
    25b0:	04090603          	lb	a2,64(s2)
    25b4:	0100                	.insn	2, 0x0100
    25b6:	1705                	.insn	2, 0x1705
    25b8:	04097b03          	.insn	4, 0x04097b03
    25bc:	0100                	.insn	2, 0x0100
    25be:	3b05                	.insn	2, 0x3b05
    25c0:	04097f03          	.insn	4, 0x04097f03
    25c4:	0100                	.insn	2, 0x0100
    25c6:	1b05                	.insn	2, 0x1b05
    25c8:	08097f03          	.insn	4, 0x08097f03
    25cc:	0100                	.insn	2, 0x0100
    25ce:	3b05                	.insn	2, 0x3b05
    25d0:	04090103          	lb	sp,64(s2)
    25d4:	0100                	.insn	2, 0x0100
    25d6:	1105                	.insn	2, 0x1105
    25d8:	0306                	.insn	2, 0x0306
    25da:	0901                	.insn	2, 0x0901
    25dc:	0004                	.insn	2, 0x0004
    25de:	0501                	.insn	2, 0x0501
    25e0:	030d                	.insn	2, 0x030d
    25e2:	080901bb          	.insn	4, 0x080901bb
    25e6:	0100                	.insn	2, 0x0100
    25e8:	1905                	.insn	2, 0x1905
    25ea:	0306                	.insn	2, 0x0306
    25ec:	0900                	.insn	2, 0x0900
    25ee:	0000                	.insn	2, 0x
    25f0:	0501                	.insn	2, 0x0501
    25f2:	0310                	.insn	2, 0x0310
    25f4:	0900                	.insn	2, 0x0900
    25f6:	0004                	.insn	2, 0x0004
    25f8:	0501                	.insn	2, 0x0501
    25fa:	0319                	.insn	2, 0x0319
    25fc:	0900                	.insn	2, 0x0900
    25fe:	0004                	.insn	2, 0x0004
    2600:	0501                	.insn	2, 0x0501
    2602:	031e                	.insn	2, 0x031e
    2604:	0906                	.insn	2, 0x0906
    2606:	0004                	.insn	2, 0x0004
    2608:	0501                	.insn	2, 0x0501
    260a:	0319                	.insn	2, 0x0319
    260c:	097a                	.insn	2, 0x097a
    260e:	0004                	.insn	2, 0x0004
    2610:	0301                	.insn	2, 0x0301
    2612:	0901                	.insn	2, 0x0901
    2614:	0004                	.insn	2, 0x0004
    2616:	0501                	.insn	2, 0x0501
    2618:	0611                	.insn	2, 0x0611
    261a:	04090603          	lb	a2,64(s2)
    261e:	0100                	.insn	2, 0x0100
    2620:	1e05                	.insn	2, 0x1e05
    2622:	14097f03          	.insn	4, 0x14097f03
    2626:	0100                	.insn	2, 0x0100
    2628:	1505                	.insn	2, 0x1505
    262a:	0306                	.insn	2, 0x0306
    262c:	0900                	.insn	2, 0x0900
    262e:	0000                	.insn	2, 0x
    2630:	0501                	.insn	2, 0x0501
    2632:	031e                	.insn	2, 0x031e
    2634:	0900                	.insn	2, 0x0900
    2636:	000c                	.insn	2, 0x000c
    2638:	0501                	.insn	2, 0x0501
    263a:	0611                	.insn	2, 0x0611
    263c:	08095603          	lhu	a2,128(s2)
    2640:	0100                	.insn	2, 0x0100
    2642:	1705                	.insn	2, 0x1705
    2644:	0306                	.insn	2, 0x0306
    2646:	0900                	.insn	2, 0x0900
    2648:	0000                	.insn	2, 0x
    264a:	0501                	.insn	2, 0x0501
    264c:	060d                	.insn	2, 0x060d
    264e:	0c090103          	lb	sp,192(s2)
    2652:	0100                	.insn	2, 0x0100
    2654:	1105                	.insn	2, 0x1105
    2656:	04097403          	.insn	4, 0x04097403
    265a:	0100                	.insn	2, 0x0100
    265c:	1705                	.insn	2, 0x1705
    265e:	0306                	.insn	2, 0x0306
    2660:	0900                	.insn	2, 0x0900
    2662:	0000                	.insn	2, 0x
    2664:	0501                	.insn	2, 0x0501
    2666:	061c                	.insn	2, 0x061c
    2668:	0c093a03          	.insn	4, 0x0c093a03
    266c:	0100                	.insn	2, 0x0100
    266e:	1505                	.insn	2, 0x1505
    2670:	10090103          	lb	sp,256(s2)
    2674:	0100                	.insn	2, 0x0100
    2676:	1c05                	.insn	2, 0x1c05
    2678:	18097f03          	.insn	4, 0x18097f03
    267c:	0100                	.insn	2, 0x0100
    267e:	0d05                	.insn	2, 0x0d05
    2680:	04090403          	lb	s0,64(s2)
    2684:	0100                	.insn	2, 0x0100
    2686:	00090103          	lb	sp,0(s2)
    268a:	0100                	.insn	2, 0x0100
    268c:	1905                	.insn	2, 0x1905
    268e:	0306                	.insn	2, 0x0306
    2690:	096a                	.insn	2, 0x096a
    2692:	0000                	.insn	2, 0x
    2694:	0501                	.insn	2, 0x0501
    2696:	0309                	.insn	2, 0x0309
    2698:	7efa                	.insn	2, 0x7efa
    269a:	0809                	.insn	2, 0x0809
    269c:	0100                	.insn	2, 0x0100
    269e:	1105                	.insn	2, 0x1105
    26a0:	0306                	.insn	2, 0x0306
    26a2:	0004091b          	.insn	4, 0x0004091b
    26a6:	0501                	.insn	2, 0x0501
    26a8:	030d                	.insn	2, 0x030d
    26aa:	0904                	.insn	2, 0x0904
    26ac:	0000                	.insn	2, 0x
    26ae:	0501                	.insn	2, 0x0501
    26b0:	00030617          	auipc	a2,0x30
    26b4:	0009                	.insn	2, 0x0009
    26b6:	0100                	.insn	2, 0x0100
    26b8:	04097c03          	.insn	4, 0x04097c03
    26bc:	0100                	.insn	2, 0x0100
    26be:	1005                	.insn	2, 0x1005
    26c0:	04090403          	lb	s0,64(s2)
    26c4:	0100                	.insn	2, 0x0100
    26c6:	1105                	.insn	2, 0x1105
    26c8:	0306                	.insn	2, 0x0306
    26ca:	0901                	.insn	2, 0x0901
    26cc:	0004                	.insn	2, 0x0004
    26ce:	0501                	.insn	2, 0x0501
    26d0:	00030617          	auipc	a2,0x30
    26d4:	0009                	.insn	2, 0x0009
    26d6:	0100                	.insn	2, 0x0100
    26d8:	0d05                	.insn	2, 0x0d05
    26da:	0306                	.insn	2, 0x0306
    26dc:	0904                	.insn	2, 0x0904
    26de:	0004                	.insn	2, 0x0004
    26e0:	0501                	.insn	2, 0x0501
    26e2:	0311                	.insn	2, 0x0311
    26e4:	091d                	.insn	2, 0x091d
    26e6:	0000                	.insn	2, 0x
    26e8:	0501                	.insn	2, 0x0501
    26ea:	0003061b          	.insn	4, 0x0003061b
    26ee:	0009                	.insn	2, 0x0009
    26f0:	0100                	.insn	2, 0x0100
    26f2:	1405                	.insn	2, 0x1405
    26f4:	04090003          	lb	zero,64(s2)
    26f8:	0100                	.insn	2, 0x0100
    26fa:	1805                	.insn	2, 0x1805
    26fc:	0306                	.insn	2, 0x0306
    26fe:	0906                	.insn	2, 0x0906
    2700:	0004                	.insn	2, 0x0004
    2702:	0501                	.insn	2, 0x0501
    2704:	0622                	.insn	2, 0x0622
    2706:	00090003          	lb	zero,0(s2)
    270a:	0100                	.insn	2, 0x0100
    270c:	2005                	.insn	2, 0x2005
    270e:	04096903          	.insn	4, 0x04096903
    2712:	0100                	.insn	2, 0x0100
    2714:	1b05                	.insn	2, 0x1b05
    2716:	04091703          	lh	a4,64(s2)
    271a:	0100                	.insn	2, 0x0100
    271c:	1505                	.insn	2, 0x1505
    271e:	0306                	.insn	2, 0x0306
    2720:	0905                	.insn	2, 0x0905
    2722:	0004                	.insn	2, 0x0004
    2724:	0501                	.insn	2, 0x0501
    2726:	0620                	.insn	2, 0x0620
    2728:	00090103          	lb	sp,0(s2)
    272c:	0100                	.insn	2, 0x0100
    272e:	1905                	.insn	2, 0x1905
    2730:	04090203          	lb	tp,64(s2)
    2734:	0100                	.insn	2, 0x0100
    2736:	1505                	.insn	2, 0x1505
    2738:	0306                	.insn	2, 0x0306
    273a:	00080903          	lb	s2,0(a6)
    273e:	0501                	.insn	2, 0x0501
    2740:	0003061b          	.insn	4, 0x0003061b
    2744:	0009                	.insn	2, 0x0009
    2746:	0100                	.insn	2, 0x0100
    2748:	0d05                	.insn	2, 0x0d05
    274a:	0306                	.insn	2, 0x0306
    274c:	0904                	.insn	2, 0x0904
    274e:	0030                	.insn	2, 0x0030
    2750:	0301                	.insn	2, 0x0301
    2752:	0901                	.insn	2, 0x0901
    2754:	0000                	.insn	2, 0x
    2756:	0301                	.insn	2, 0x0301
    2758:	7fb2                	.insn	2, 0x7fb2
    275a:	0409                	.insn	2, 0x0409
    275c:	0100                	.insn	2, 0x0100
    275e:	00090103          	lb	sp,0(s2)
    2762:	0100                	.insn	2, 0x0100
    2764:	0905                	.insn	2, 0x0905
    2766:	0306                	.insn	2, 0x0306
    2768:	0976                	.insn	2, 0x0976
    276a:	000c                	.insn	2, 0x000c
    276c:	0501                	.insn	2, 0x0501
    276e:	0611                	.insn	2, 0x0611
    2770:	08091103          	lh	sp,128(s2)
    2774:	0100                	.insn	2, 0x0100
    2776:	00090103          	lb	sp,0(s2)
    277a:	0100                	.insn	2, 0x0100
    277c:	0d05                	.insn	2, 0x0d05
    277e:	00090303          	lb	t1,0(s2)
    2782:	0100                	.insn	2, 0x0100
    2784:	00090503          	lb	a0,0(s2)
    2788:	0100                	.insn	2, 0x0100
    278a:	00090503          	lb	a0,0(s2)
    278e:	0100                	.insn	2, 0x0100
    2790:	1705                	.insn	2, 0x1705
    2792:	0306                	.insn	2, 0x0306
    2794:	0900                	.insn	2, 0x0900
    2796:	0000                	.insn	2, 0x
    2798:	0301                	.insn	2, 0x0301
    279a:	0901                	.insn	2, 0x0901
    279c:	0004                	.insn	2, 0x0004
    279e:	0501                	.insn	2, 0x0501
    27a0:	0310                	.insn	2, 0x0310
    27a2:	097f 0004 0501 0317 	.insn	10, 0x0973031705010004097f
    27aa:	0973 
    27ac:	0004                	.insn	2, 0x0004
    27ae:	0501                	.insn	2, 0x0501
    27b0:	0611                	.insn	2, 0x0611
    27b2:	0900d603          	lhu	a2,144(ra)
    27b6:	0008                	.insn	2, 0x0008
    27b8:	0501                	.insn	2, 0x0501
    27ba:	00030617          	auipc	a2,0x30
    27be:	0009                	.insn	2, 0x0009
    27c0:	0100                	.insn	2, 0x0100
    27c2:	0d05                	.insn	2, 0x0d05
    27c4:	0306                	.insn	2, 0x0306
    27c6:	0901                	.insn	2, 0x0901
    27c8:	000c                	.insn	2, 0x000c
    27ca:	0501                	.insn	2, 0x0501
    27cc:	0311                	.insn	2, 0x0311
    27ce:	0901                	.insn	2, 0x0901
    27d0:	0000                	.insn	2, 0x
    27d2:	0501                	.insn	2, 0x0501
    27d4:	00030617          	auipc	a2,0x30
    27d8:	0009                	.insn	2, 0x0009
    27da:	0100                	.insn	2, 0x0100
    27dc:	1105                	.insn	2, 0x1105
    27de:	0306                	.insn	2, 0x0306
    27e0:	7fac                	.insn	2, 0x7fac
    27e2:	0809                	.insn	2, 0x0809
    27e4:	0100                	.insn	2, 0x0100
    27e6:	1705                	.insn	2, 0x1705
    27e8:	0306                	.insn	2, 0x0306
    27ea:	0900                	.insn	2, 0x0900
    27ec:	0000                	.insn	2, 0x
    27ee:	0501                	.insn	2, 0x0501
    27f0:	060d                	.insn	2, 0x060d
    27f2:	04090403          	lb	s0,64(s2)
    27f6:	0100                	.insn	2, 0x0100
    27f8:	1705                	.insn	2, 0x1705
    27fa:	0306                	.insn	2, 0x0306
    27fc:	097c                	.insn	2, 0x097c
    27fe:	0000                	.insn	2, 0x
    2800:	0501                	.insn	2, 0x0501
    2802:	061c                	.insn	2, 0x061c
    2804:	0900df03          	lhu	t5,144(ra)
    2808:	0008                	.insn	2, 0x0008
    280a:	0501                	.insn	2, 0x0501
    280c:	0315                	.insn	2, 0x0315
    280e:	0901                	.insn	2, 0x0901
    2810:	0018                	.insn	2, 0x0018
    2812:	0501                	.insn	2, 0x0501
    2814:	061c                	.insn	2, 0x061c
    2816:	14097f03          	.insn	4, 0x14097f03
    281a:	0100                	.insn	2, 0x0100
    281c:	1505                	.insn	2, 0x1505
    281e:	04090103          	lb	sp,64(s2)
    2822:	0100                	.insn	2, 0x0100
    2824:	1c05                	.insn	2, 0x1c05
    2826:	0306                	.insn	2, 0x0306
    2828:	097f 0004 0501 030d 	.insn	10, 0x0905030d05010004097f
    2830:	0905 
    2832:	0004                	.insn	2, 0x0004
    2834:	0001                	.insn	2, 0x0001
    2836:	0402                	.insn	2, 0x0402
    2838:	0601                	.insn	2, 0x0601
    283a:	00090003          	lb	zero,0(s2)
    283e:	0100                	.insn	2, 0x0100
    2840:	0306                	.insn	2, 0x0306
    2842:	0902                	.insn	2, 0x0902
    2844:	0018                	.insn	2, 0x0018
    2846:	0301                	.insn	2, 0x0301
    2848:	0905                	.insn	2, 0x0905
    284a:	0000                	.insn	2, 0x
    284c:	0301                	.insn	2, 0x0301
    284e:	0901                	.insn	2, 0x0901
    2850:	0000                	.insn	2, 0x
    2852:	0501                	.insn	2, 0x0501
    2854:	78030617          	auipc	a2,0x78030
    2858:	0009                	.insn	2, 0x0009
    285a:	0100                	.insn	2, 0x0100
    285c:	0905                	.insn	2, 0x0905
    285e:	097f8603          	lb	a2,151(t6)
    2862:	000c                	.insn	2, 0x000c
    2864:	0501                	.insn	2, 0x0501
    2866:	0611                	.insn	2, 0x0611
    2868:	08091103          	lh	sp,128(s2)
    286c:	0100                	.insn	2, 0x0100
    286e:	00090103          	lb	sp,0(s2)
    2872:	0100                	.insn	2, 0x0100
    2874:	1705                	.insn	2, 0x1705
    2876:	0306                	.insn	2, 0x0306
    2878:	0900                	.insn	2, 0x0900
    287a:	0000                	.insn	2, 0x
    287c:	0501                	.insn	2, 0x0501
    287e:	060d                	.insn	2, 0x060d
    2880:	04090303          	lb	t1,64(s2)
    2884:	0100                	.insn	2, 0x0100
    2886:	00090503          	lb	a0,0(s2)
    288a:	0100                	.insn	2, 0x0100
    288c:	1705                	.insn	2, 0x1705
    288e:	0306                	.insn	2, 0x0306
    2890:	0978                	.insn	2, 0x0978
    2892:	0000                	.insn	2, 0x
    2894:	0501                	.insn	2, 0x0501
    2896:	0611                	.insn	2, 0x0611
    2898:	08090e03          	lb	t3,128(s2)
    289c:	0100                	.insn	2, 0x0100
    289e:	1705                	.insn	2, 0x1705
    28a0:	0306                	.insn	2, 0x0306
    28a2:	0900                	.insn	2, 0x0900
    28a4:	0000                	.insn	2, 0x
    28a6:	0501                	.insn	2, 0x0501
    28a8:	060d                	.insn	2, 0x060d
    28aa:	04090403          	lb	s0,64(s2)
    28ae:	0100                	.insn	2, 0x0100
    28b0:	1505                	.insn	2, 0x1505
    28b2:	10092403          	lw	s0,256(s2)
    28b6:	0100                	.insn	2, 0x0100
    28b8:	1b05                	.insn	2, 0x1b05
    28ba:	0200                	.insn	2, 0x0200
    28bc:	0104                	.insn	2, 0x0104
    28be:	0306                	.insn	2, 0x0306
    28c0:	0900                	.insn	2, 0x0900
    28c2:	0000                	.insn	2, 0x
    28c4:	0501                	.insn	2, 0x0501
    28c6:	0605                	.insn	2, 0x0605
    28c8:	097b8d03          	lb	s10,151(s7)
    28cc:	0014                	.insn	2, 0x0014
    28ce:	0501                	.insn	2, 0x0501
    28d0:	030d                	.insn	2, 0x030d
    28d2:	05b4                	.insn	2, 0x05b4
    28d4:	0009                	.insn	2, 0x0009
    28d6:	0100                	.insn	2, 0x0100
    28d8:	1705                	.insn	2, 0x1705
    28da:	0306                	.insn	2, 0x0306
    28dc:	0900                	.insn	2, 0x0900
    28de:	0000                	.insn	2, 0x
    28e0:	0501                	.insn	2, 0x0501
    28e2:	0310                	.insn	2, 0x0310
    28e4:	0900                	.insn	2, 0x0900
    28e6:	0008                	.insn	2, 0x0008
    28e8:	0501                	.insn	2, 0x0501
    28ea:	060d                	.insn	2, 0x060d
    28ec:	04090303          	lb	t1,64(s2)
    28f0:	0100                	.insn	2, 0x0100
    28f2:	1905                	.insn	2, 0x1905
    28f4:	0306                	.insn	2, 0x0306
    28f6:	0900                	.insn	2, 0x0900
    28f8:	0000                	.insn	2, 0x
    28fa:	0501                	.insn	2, 0x0501
    28fc:	0310                	.insn	2, 0x0310
    28fe:	0900                	.insn	2, 0x0900
    2900:	0004                	.insn	2, 0x0004
    2902:	0501                	.insn	2, 0x0501
    2904:	061c                	.insn	2, 0x061c
    2906:	04090103          	lb	sp,64(s2)
    290a:	0100                	.insn	2, 0x0100
    290c:	1505                	.insn	2, 0x1505
    290e:	1c090103          	lb	sp,448(s2)
    2912:	0100                	.insn	2, 0x0100
    2914:	1c05                	.insn	2, 0x1c05
    2916:	18097f03          	.insn	4, 0x18097f03
    291a:	0100                	.insn	2, 0x0100
    291c:	1505                	.insn	2, 0x1505
    291e:	0306                	.insn	2, 0x0306
    2920:	0905                	.insn	2, 0x0905
    2922:	0008                	.insn	2, 0x0008
    2924:	0501                	.insn	2, 0x0501
    2926:	061e                	.insn	2, 0x061e
    2928:	0c090003          	lb	zero,192(s2)
    292c:	0100                	.insn	2, 0x0100
    292e:	1705                	.insn	2, 0x1705
    2930:	0306                	.insn	2, 0x0306
    2932:	7f80                	.insn	2, 0x7f80
    2934:	1409                	.insn	2, 0x1409
    2936:	0100                	.insn	2, 0x0100
    2938:	1005                	.insn	2, 0x1005
    293a:	04090803          	lb	a6,64(s2)
    293e:	0100                	.insn	2, 0x0100
    2940:	0d05                	.insn	2, 0x0d05
    2942:	0306                	.insn	2, 0x0306
    2944:	00e0                	.insn	2, 0x00e0
    2946:	0809                	.insn	2, 0x0809
    2948:	0100                	.insn	2, 0x0100
    294a:	0200                	.insn	2, 0x0200
    294c:	0104                	.insn	2, 0x0104
    294e:	0306                	.insn	2, 0x0306
    2950:	0900                	.insn	2, 0x0900
    2952:	0000                	.insn	2, 0x
    2954:	0601                	.insn	2, 0x0601
    2956:	14090203          	lb	tp,320(s2)
    295a:	0100                	.insn	2, 0x0100
    295c:	1705                	.insn	2, 0x1705
    295e:	0306                	.insn	2, 0x0306
    2960:	097e                	.insn	2, 0x097e
    2962:	0000                	.insn	2, 0x
    2964:	0501                	.insn	2, 0x0501
    2966:	000d                	.insn	2, 0x000d
    2968:	0402                	.insn	2, 0x0402
    296a:	0301                	.insn	2, 0x0301
    296c:	0900                	.insn	2, 0x0900
    296e:	0004                	.insn	2, 0x0004
    2970:	0601                	.insn	2, 0x0601
    2972:	04090703          	lb	a4,64(s2)
    2976:	0100                	.insn	2, 0x0100
    2978:	00090103          	lb	sp,0(s2)
    297c:	0100                	.insn	2, 0x0100
    297e:	1c05                	.insn	2, 0x1c05
    2980:	04090b03          	lb	s6,64(s2)
    2984:	0100                	.insn	2, 0x0100
    2986:	1e05                	.insn	2, 0x1e05
    2988:	10090503          	lb	a0,256(s2)
    298c:	0100                	.insn	2, 0x0100
    298e:	1905                	.insn	2, 0x1905
    2990:	0306                	.insn	2, 0x0306
    2992:	0004097b          	.insn	4, 0x0004097b
    2996:	0501                	.insn	2, 0x0501
    2998:	0615                	.insn	2, 0x0615
    299a:	097fa303          	lw	t1,151(t6)
    299e:	0010                	.insn	2, 0x0010
    29a0:	0501                	.insn	2, 0x0501
    29a2:	0620                	.insn	2, 0x0620
    29a4:	00090003          	lb	zero,0(s2)
    29a8:	0100                	.insn	2, 0x0100
    29aa:	1505                	.insn	2, 0x1505
    29ac:	0306                	.insn	2, 0x0306
    29ae:	0901                	.insn	2, 0x0901
    29b0:	0004                	.insn	2, 0x0004
    29b2:	0501                	.insn	2, 0x0501
    29b4:	0003061b          	.insn	4, 0x0003061b
    29b8:	0009                	.insn	2, 0x0009
    29ba:	0100                	.insn	2, 0x0100
    29bc:	1905                	.insn	2, 0x1905
    29be:	08090203          	lb	tp,128(s2)
    29c2:	0100                	.insn	2, 0x0100
    29c4:	1b05                	.insn	2, 0x1b05
    29c6:	08097e03          	.insn	4, 0x08097e03
    29ca:	0100                	.insn	2, 0x0100
    29cc:	2205                	.insn	2, 0x2205
    29ce:	0200                	.insn	2, 0x0200
    29d0:	0204                	.insn	2, 0x0204
    29d2:	18091e03          	lh	t3,384(s2)
    29d6:	0100                	.insn	2, 0x0100
    29d8:	1d05                	.insn	2, 0x1d05
    29da:	04090203          	lb	tp,64(s2)
    29de:	0100                	.insn	2, 0x0100
    29e0:	3105                	.insn	2, 0x3105
    29e2:	0200                	.insn	2, 0x0200
    29e4:	0204                	.insn	2, 0x0204
    29e6:	0c096803          	.insn	4, 0x0c096803
    29ea:	0100                	.insn	2, 0x0100
    29ec:	1905                	.insn	2, 0x1905
    29ee:	04090303          	lb	t1,64(s2)
    29f2:	0100                	.insn	2, 0x0100
    29f4:	1d05                	.insn	2, 0x1d05
    29f6:	0200                	.insn	2, 0x0200
    29f8:	0204                	.insn	2, 0x0204
    29fa:	10091503          	lh	a0,256(s2)
    29fe:	0100                	.insn	2, 0x0100
    2a00:	1105                	.insn	2, 0x1105
    2a02:	0306                	.insn	2, 0x0306
    2a04:	0939                	.insn	2, 0x0939
    2a06:	0008                	.insn	2, 0x0008
    2a08:	0501                	.insn	2, 0x0501
    2a0a:	030d                	.insn	2, 0x030d
    2a0c:	0902                	.insn	2, 0x0902
    2a0e:	0000                	.insn	2, 0x
    2a10:	0501                	.insn	2, 0x0501
    2a12:	0619                	.insn	2, 0x0619
    2a14:	00090003          	lb	zero,0(s2)
    2a18:	0100                	.insn	2, 0x0100
    2a1a:	1005                	.insn	2, 0x1005
    2a1c:	08090003          	lb	zero,128(s2)
    2a20:	0100                	.insn	2, 0x0100
    2a22:	1e05                	.insn	2, 0x1e05
    2a24:	0200                	.insn	2, 0x0200
    2a26:	0404                	.insn	2, 0x0404
    2a28:	08097b03          	.insn	4, 0x08097b03
    2a2c:	0100                	.insn	2, 0x0100
    2a2e:	0306                	.insn	2, 0x0306
    2a30:	0008090b          	.insn	4, 0x0008090b
    2a34:	0501                	.insn	2, 0x0501
    2a36:	0619                	.insn	2, 0x0619
    2a38:	00097b03          	.insn	4, 0x00097b03
    2a3c:	0100                	.insn	2, 0x0100
    2a3e:	1e05                	.insn	2, 0x1e05
    2a40:	0c090503          	lb	a0,192(s2)
    2a44:	0100                	.insn	2, 0x0100
    2a46:	0d05                	.insn	2, 0x0d05
    2a48:	0306                	.insn	2, 0x0306
    2a4a:	0909                	.insn	2, 0x0909
    2a4c:	0004                	.insn	2, 0x0004
    2a4e:	0301                	.insn	2, 0x0301
    2a50:	0901                	.insn	2, 0x0901
    2a52:	0000                	.insn	2, 0x
    2a54:	0501                	.insn	2, 0x0501
    2a56:	0619                	.insn	2, 0x0619
    2a58:	00096a03          	.insn	4, 0x00096a03
    2a5c:	0100                	.insn	2, 0x0100
    2a5e:	1605                	.insn	2, 0x1605
    2a60:	0306                	.insn	2, 0x0306
    2a62:	79a6                	.insn	2, 0x79a6
    2a64:	0809                	.insn	2, 0x0809
    2a66:	0100                	.insn	2, 0x0100
    2a68:	1805                	.insn	2, 0x1805
    2a6a:	00090003          	lb	zero,0(s2)
    2a6e:	0100                	.insn	2, 0x0100
    2a70:	2805                	.insn	2, 0x2805
    2a72:	0306                	.insn	2, 0x0306
    2a74:	0900                	.insn	2, 0x0900
    2a76:	0000                	.insn	2, 0x
    2a78:	0501                	.insn	2, 0x0501
    2a7a:	0615                	.insn	2, 0x0615
    2a7c:	08090203          	lb	tp,128(s2)
    2a80:	0100                	.insn	2, 0x0100
    2a82:	0505                	.insn	2, 0x0505
    2a84:	00090103          	lb	sp,0(s2)
    2a88:	0100                	.insn	2, 0x0100
    2a8a:	0d05                	.insn	2, 0x0d05
    2a8c:	0200                	.insn	2, 0x0200
    2a8e:	0104                	.insn	2, 0x0104
    2a90:	0306                	.insn	2, 0x0306
    2a92:	0900                	.insn	2, 0x0900
    2a94:	0000                	.insn	2, 0x
    2a96:	0501                	.insn	2, 0x0501
    2a98:	001d                	.insn	2, 0x001d
    2a9a:	0402                	.insn	2, 0x0402
    2a9c:	0601                	.insn	2, 0x0601
    2a9e:	0c090003          	lb	zero,192(s2)
    2aa2:	0100                	.insn	2, 0x0100
    2aa4:	0d05                	.insn	2, 0x0d05
    2aa6:	0200                	.insn	2, 0x0200
    2aa8:	0104                	.insn	2, 0x0104
    2aaa:	0306                	.insn	2, 0x0306
    2aac:	0900                	.insn	2, 0x0900
    2aae:	0000                	.insn	2, 0x
    2ab0:	0501                	.insn	2, 0x0501
    2ab2:	001d                	.insn	2, 0x001d
    2ab4:	0402                	.insn	2, 0x0402
    2ab6:	0301                	.insn	2, 0x0301
    2ab8:	0900                	.insn	2, 0x0900
    2aba:	0004                	.insn	2, 0x0004
    2abc:	0501                	.insn	2, 0x0501
    2abe:	0605                	.insn	2, 0x0605
    2ac0:	08090203          	lb	tp,128(s2)
    2ac4:	0100                	.insn	2, 0x0100
    2ac6:	0c05                	.insn	2, 0x0c05
    2ac8:	0306                	.insn	2, 0x0306
    2aca:	0900                	.insn	2, 0x0900
    2acc:	0000                	.insn	2, 0x
    2ace:	0501                	.insn	2, 0x0501
    2ad0:	0301                	.insn	2, 0x0301
    2ad2:	0901                	.insn	2, 0x0901
    2ad4:	0004                	.insn	2, 0x0004
    2ad6:	0501                	.insn	2, 0x0501
    2ad8:	0629                	.insn	2, 0x0629
    2ada:	04090203          	lb	tp,64(s2)
    2ade:	0100                	.insn	2, 0x0100
    2ae0:	0505                	.insn	2, 0x0505
    2ae2:	00090103          	lb	sp,0(s2)
    2ae6:	0100                	.insn	2, 0x0100
    2ae8:	00090103          	lb	sp,0(s2)
    2aec:	0100                	.insn	2, 0x0100
    2aee:	00097903          	.insn	4, 0x00097903
    2af2:	0100                	.insn	2, 0x0100
    2af4:	0d05                	.insn	2, 0x0d05
    2af6:	0200                	.insn	2, 0x0200
    2af8:	0104                	.insn	2, 0x0104
    2afa:	0306                	.insn	2, 0x0306
    2afc:	0900                	.insn	2, 0x0900
    2afe:	0000                	.insn	2, 0x
    2b00:	0501                	.insn	2, 0x0501
    2b02:	001d                	.insn	2, 0x001d
    2b04:	0402                	.insn	2, 0x0402
    2b06:	0601                	.insn	2, 0x0601
    2b08:	0c090003          	lb	zero,192(s2)
    2b0c:	0100                	.insn	2, 0x0100
    2b0e:	0d05                	.insn	2, 0x0d05
    2b10:	0200                	.insn	2, 0x0200
    2b12:	0104                	.insn	2, 0x0104
    2b14:	0306                	.insn	2, 0x0306
    2b16:	0900                	.insn	2, 0x0900
    2b18:	0000                	.insn	2, 0x
    2b1a:	0501                	.insn	2, 0x0501
    2b1c:	001d                	.insn	2, 0x001d
    2b1e:	0402                	.insn	2, 0x0402
    2b20:	0301                	.insn	2, 0x0301
    2b22:	0900                	.insn	2, 0x0900
    2b24:	0004                	.insn	2, 0x0004
    2b26:	0501                	.insn	2, 0x0501
    2b28:	0605                	.insn	2, 0x0605
    2b2a:	08090203          	lb	tp,128(s2)
    2b2e:	0100                	.insn	2, 0x0100
    2b30:	0c05                	.insn	2, 0x0c05
    2b32:	0306                	.insn	2, 0x0306
    2b34:	0900                	.insn	2, 0x0900
    2b36:	0000                	.insn	2, 0x
    2b38:	0501                	.insn	2, 0x0501
    2b3a:	030e                	.insn	2, 0x030e
    2b3c:	0906                	.insn	2, 0x0906
    2b3e:	0004                	.insn	2, 0x0004
    2b40:	0501                	.insn	2, 0x0501
    2b42:	030c                	.insn	2, 0x030c
    2b44:	097a                	.insn	2, 0x097a
    2b46:	0004                	.insn	2, 0x0004
    2b48:	0501                	.insn	2, 0x0501
    2b4a:	0605                	.insn	2, 0x0605
    2b4c:	04090603          	lb	a2,64(s2)
    2b50:	0100                	.insn	2, 0x0100
    2b52:	0e05                	.insn	2, 0x0e05
    2b54:	00090003          	lb	zero,0(s2)
    2b58:	0100                	.insn	2, 0x0100
    2b5a:	0d05                	.insn	2, 0x0d05
    2b5c:	0200                	.insn	2, 0x0200
    2b5e:	0104                	.insn	2, 0x0104
    2b60:	0306                	.insn	2, 0x0306
    2b62:	0978                	.insn	2, 0x0978
    2b64:	0004                	.insn	2, 0x0004
    2b66:	0501                	.insn	2, 0x0501
    2b68:	0309                	.insn	2, 0x0309
    2b6a:	0906                	.insn	2, 0x0906
    2b6c:	0008                	.insn	2, 0x0008
    2b6e:	0501                	.insn	2, 0x0501
    2b70:	000d                	.insn	2, 0x000d
    2b72:	0402                	.insn	2, 0x0402
    2b74:	0301                	.insn	2, 0x0301
    2b76:	097a                	.insn	2, 0x097a
    2b78:	0004                	.insn	2, 0x0004
    2b7a:	0501                	.insn	2, 0x0501
    2b7c:	0609                	.insn	2, 0x0609
    2b7e:	04090903          	lb	s2,64(s2)
    2b82:	0100                	.insn	2, 0x0100
    2b84:	0c05                	.insn	2, 0x0c05
    2b86:	0306                	.insn	2, 0x0306
    2b88:	0900                	.insn	2, 0x0900
    2b8a:	0004                	.insn	2, 0x0004
    2b8c:	0501                	.insn	2, 0x0501
    2b8e:	060d                	.insn	2, 0x060d
    2b90:	04090103          	lb	sp,64(s2)
    2b94:	0100                	.insn	2, 0x0100
    2b96:	1705                	.insn	2, 0x1705
    2b98:	0306                	.insn	2, 0x0306
    2b9a:	0900                	.insn	2, 0x0900
    2b9c:	0000                	.insn	2, 0x
    2b9e:	0501                	.insn	2, 0x0501
    2ba0:	060d                	.insn	2, 0x060d
    2ba2:	08090103          	lb	sp,128(s2)
    2ba6:	0100                	.insn	2, 0x0100
    2ba8:	0e05                	.insn	2, 0x0e05
    2baa:	0306                	.insn	2, 0x0306
    2bac:	0900                	.insn	2, 0x0900
    2bae:	0000                	.insn	2, 0x
    2bb0:	0501                	.insn	2, 0x0501
    2bb2:	0609                	.insn	2, 0x0609
    2bb4:	04090203          	lb	tp,64(s2)
    2bb8:	0100                	.insn	2, 0x0100
    2bba:	0505                	.insn	2, 0x0505
    2bbc:	00097303          	.insn	4, 0x00097303
    2bc0:	0100                	.insn	2, 0x0100
    2bc2:	1d05                	.insn	2, 0x1d05
    2bc4:	0200                	.insn	2, 0x0200
    2bc6:	0104                	.insn	2, 0x0104
    2bc8:	00090003          	lb	zero,0(s2)
    2bcc:	0100                	.insn	2, 0x0100
    2bce:	0d05                	.insn	2, 0x0d05
    2bd0:	0200                	.insn	2, 0x0200
    2bd2:	0104                	.insn	2, 0x0104
    2bd4:	0306                	.insn	2, 0x0306
    2bd6:	0900                	.insn	2, 0x0900
    2bd8:	0000                	.insn	2, 0x
    2bda:	0501                	.insn	2, 0x0501
    2bdc:	001d                	.insn	2, 0x001d
    2bde:	0402                	.insn	2, 0x0402
    2be0:	0301                	.insn	2, 0x0301
    2be2:	0900                	.insn	2, 0x0900
    2be4:	0004                	.insn	2, 0x0004
    2be6:	0501                	.insn	2, 0x0501
    2be8:	0605                	.insn	2, 0x0605
    2bea:	08090203          	lb	tp,128(s2)
    2bee:	0100                	.insn	2, 0x0100
    2bf0:	0c05                	.insn	2, 0x0c05
    2bf2:	0306                	.insn	2, 0x0306
    2bf4:	0900                	.insn	2, 0x0900
    2bf6:	0000                	.insn	2, 0x
    2bf8:	0501                	.insn	2, 0x0501
    2bfa:	060e                	.insn	2, 0x060e
    2bfc:	08090603          	lb	a2,128(s2)
    2c00:	0100                	.insn	2, 0x0100
    2c02:	0d05                	.insn	2, 0x0d05
    2c04:	0200                	.insn	2, 0x0200
    2c06:	0104                	.insn	2, 0x0104
    2c08:	0306                	.insn	2, 0x0306
    2c0a:	0978                	.insn	2, 0x0978
    2c0c:	0008                	.insn	2, 0x0008
    2c0e:	0501                	.insn	2, 0x0501
    2c10:	030e                	.insn	2, 0x030e
    2c12:	0908                	.insn	2, 0x0908
    2c14:	000c                	.insn	2, 0x000c
    2c16:	0501                	.insn	2, 0x0501
    2c18:	001d                	.insn	2, 0x001d
    2c1a:	0402                	.insn	2, 0x0402
    2c1c:	0601                	.insn	2, 0x0601
    2c1e:	04097803          	.insn	4, 0x04097803
    2c22:	0100                	.insn	2, 0x0100
    2c24:	0d05                	.insn	2, 0x0d05
    2c26:	0200                	.insn	2, 0x0200
    2c28:	0104                	.insn	2, 0x0104
    2c2a:	0306                	.insn	2, 0x0306
    2c2c:	0900                	.insn	2, 0x0900
    2c2e:	0000                	.insn	2, 0x
    2c30:	0501                	.insn	2, 0x0501
    2c32:	001d                	.insn	2, 0x001d
    2c34:	0402                	.insn	2, 0x0402
    2c36:	0301                	.insn	2, 0x0301
    2c38:	0900                	.insn	2, 0x0900
    2c3a:	0004                	.insn	2, 0x0004
    2c3c:	0501                	.insn	2, 0x0501
    2c3e:	0605                	.insn	2, 0x0605
    2c40:	08090203          	lb	tp,128(s2)
    2c44:	0100                	.insn	2, 0x0100
    2c46:	0c05                	.insn	2, 0x0c05
    2c48:	0306                	.insn	2, 0x0306
    2c4a:	0900                	.insn	2, 0x0900
    2c4c:	0000                	.insn	2, 0x
    2c4e:	0501                	.insn	2, 0x0501
    2c50:	060e                	.insn	2, 0x060e
    2c52:	04090603          	lb	a2,64(s2)
    2c56:	0100                	.insn	2, 0x0100
    2c58:	0b05                	.insn	2, 0x0b05
    2c5a:	0306                	.insn	2, 0x0306
    2c5c:	00040907          	.insn	4, 0x00040907
    2c60:	0501                	.insn	2, 0x0501
    2c62:	0605                	.insn	2, 0x0605
    2c64:	04090003          	lb	zero,64(s2)
    2c68:	0100                	.insn	2, 0x0100
    2c6a:	0f05                	.insn	2, 0x0f05
    2c6c:	0306                	.insn	2, 0x0306
    2c6e:	0900                	.insn	2, 0x0900
    2c70:	0000                	.insn	2, 0x
    2c72:	0501                	.insn	2, 0x0501
    2c74:	0301                	.insn	2, 0x0301
    2c76:	0901                	.insn	2, 0x0901
    2c78:	0004                	.insn	2, 0x0004
    2c7a:	0501                	.insn	2, 0x0501
    2c7c:	030e                	.insn	2, 0x030e
    2c7e:	0978                	.insn	2, 0x0978
    2c80:	0004                	.insn	2, 0x0004
    2c82:	0501                	.insn	2, 0x0501
    2c84:	0628                	.insn	2, 0x0628
    2c86:	08090a03          	lb	s4,128(s2)
    2c8a:	0100                	.insn	2, 0x0100
    2c8c:	0505                	.insn	2, 0x0505
    2c8e:	00090103          	lb	sp,0(s2)
    2c92:	0100                	.insn	2, 0x0100
    2c94:	00090103          	lb	sp,0(s2)
    2c98:	0100                	.insn	2, 0x0100
    2c9a:	00090103          	lb	sp,0(s2)
    2c9e:	0100                	.insn	2, 0x0100
    2ca0:	1305                	.insn	2, 0x1305
    2ca2:	00090003          	lb	zero,0(s2)
    2ca6:	0100                	.insn	2, 0x0100
    2ca8:	0f05                	.insn	2, 0x0f05
    2caa:	0306                	.insn	2, 0x0306
    2cac:	0900                	.insn	2, 0x0900
    2cae:	0000                	.insn	2, 0x
    2cb0:	0501                	.insn	2, 0x0501
    2cb2:	09000313          	addi	t1,zero,144
    2cb6:	0004                	.insn	2, 0x0004
    2cb8:	0501                	.insn	2, 0x0501
    2cba:	0309                	.insn	2, 0x0309
    2cbc:	097e                	.insn	2, 0x097e
    2cbe:	0008                	.insn	2, 0x0008
    2cc0:	0601                	.insn	2, 0x0601
    2cc2:	04090303          	lb	t1,64(s2)
    2cc6:	0100                	.insn	2, 0x0100
    2cc8:	1905                	.insn	2, 0x1905
    2cca:	0306                	.insn	2, 0x0306
    2ccc:	0900                	.insn	2, 0x0900
    2cce:	0000                	.insn	2, 0x
    2cd0:	0501                	.insn	2, 0x0501
    2cd2:	0618                	.insn	2, 0x0618
    2cd4:	04096703          	.insn	4, 0x04096703
    2cd8:	0100                	.insn	2, 0x0100
    2cda:	1305                	.insn	2, 0x1305
    2cdc:	0306                	.insn	2, 0x0306
    2cde:	0918                	.insn	2, 0x0918
    2ce0:	0000                	.insn	2, 0x
    2ce2:	0501                	.insn	2, 0x0501
    2ce4:	0321                	.insn	2, 0x0321
    2ce6:	0968                	.insn	2, 0x0968
    2ce8:	0004                	.insn	2, 0x0004
    2cea:	0501                	.insn	2, 0x0501
    2cec:	0918030f          	.insn	4, 0x0918030f
    2cf0:	0004                	.insn	2, 0x0004
    2cf2:	0501                	.insn	2, 0x0501
    2cf4:	0010                	.insn	2, 0x0010
    2cf6:	0402                	.insn	2, 0x0402
    2cf8:	0301                	.insn	2, 0x0301
    2cfa:	0901                	.insn	2, 0x0901
    2cfc:	0004                	.insn	2, 0x0004
    2cfe:	0501                	.insn	2, 0x0501
    2d00:	0609                	.insn	2, 0x0609
    2d02:	04090103          	lb	sp,64(s2)
    2d06:	0100                	.insn	2, 0x0100
    2d08:	1305                	.insn	2, 0x1305
    2d0a:	00097e03          	.insn	4, 0x00097e03
    2d0e:	0100                	.insn	2, 0x0100
    2d10:	0905                	.insn	2, 0x0905
    2d12:	0306                	.insn	2, 0x0306
    2d14:	097e                	.insn	2, 0x097e
    2d16:	0008                	.insn	2, 0x0008
    2d18:	0501                	.insn	2, 0x0501
    2d1a:	0605                	.insn	2, 0x0605
    2d1c:	04090603          	lb	a2,64(s2)
    2d20:	0100                	.insn	2, 0x0100
    2d22:	0105                	.insn	2, 0x0105
    2d24:	0306                	.insn	2, 0x0306
    2d26:	0901                	.insn	2, 0x0901
    2d28:	0000                	.insn	2, 0x
    2d2a:	0501                	.insn	2, 0x0501
    2d2c:	061f d503 0900      	.insn	6, 0x0900d503061f
    2d32:	0004                	.insn	2, 0x0004
    2d34:	0501                	.insn	2, 0x0501
    2d36:	0321                	.insn	2, 0x0321
    2d38:	0900                	.insn	2, 0x0900
    2d3a:	0000                	.insn	2, 0x
    2d3c:	0501                	.insn	2, 0x0501
    2d3e:	0629                	.insn	2, 0x0629
    2d40:	00090003          	lb	zero,0(s2)
    2d44:	0100                	.insn	2, 0x0100
    2d46:	3605                	.insn	2, 0x3605
    2d48:	08090003          	lb	zero,128(s2)
    2d4c:	0100                	.insn	2, 0x0100
    2d4e:	2605                	.insn	2, 0x2605
    2d50:	0306                	.insn	2, 0x0306
    2d52:	040906ab          	.insn	4, 0x040906ab
    2d56:	0100                	.insn	2, 0x0100
    2d58:	0505                	.insn	2, 0x0505
    2d5a:	00090103          	lb	sp,0(s2)
    2d5e:	0100                	.insn	2, 0x0100
    2d60:	00090103          	lb	sp,0(s2)
    2d64:	0100                	.insn	2, 0x0100
    2d66:	2605                	.insn	2, 0x2605
    2d68:	0306                	.insn	2, 0x0306
    2d6a:	097e                	.insn	2, 0x097e
    2d6c:	0000                	.insn	2, 0x
    2d6e:	0501                	.insn	2, 0x0501
    2d70:	0305                	.insn	2, 0x0305
    2d72:	0902                	.insn	2, 0x0902
    2d74:	0004                	.insn	2, 0x0004
    2d76:	0501                	.insn	2, 0x0501
    2d78:	0315                	.insn	2, 0x0315
    2d7a:	0902                	.insn	2, 0x0902
    2d7c:	0004                	.insn	2, 0x0004
    2d7e:	0501                	.insn	2, 0x0501
    2d80:	0326                	.insn	2, 0x0326
    2d82:	097c                	.insn	2, 0x097c
    2d84:	0004                	.insn	2, 0x0004
    2d86:	0501                	.insn	2, 0x0501
    2d88:	0315                	.insn	2, 0x0315
    2d8a:	0904                	.insn	2, 0x0904
    2d8c:	0010                	.insn	2, 0x0010
    2d8e:	0501                	.insn	2, 0x0501
    2d90:	0326                	.insn	2, 0x0326
    2d92:	097c                	.insn	2, 0x097c
    2d94:	0014                	.insn	2, 0x0014
    2d96:	0301                	.insn	2, 0x0301
    2d98:	0900                	.insn	2, 0x0900
    2d9a:	0004                	.insn	2, 0x0004
    2d9c:	0501                	.insn	2, 0x0501
    2d9e:	0305                	.insn	2, 0x0305
    2da0:	0902                	.insn	2, 0x0902
    2da2:	000c                	.insn	2, 0x000c
    2da4:	0601                	.insn	2, 0x0601
    2da6:	04090103          	lb	sp,64(s2)
    2daa:	0100                	.insn	2, 0x0100
    2dac:	00090103          	lb	sp,0(s2)
    2db0:	0100                	.insn	2, 0x0100
    2db2:	1505                	.insn	2, 0x1505
    2db4:	0306                	.insn	2, 0x0306
    2db6:	0900                	.insn	2, 0x0900
    2db8:	0000                	.insn	2, 0x
    2dba:	0501                	.insn	2, 0x0501
    2dbc:	0605                	.insn	2, 0x0605
    2dbe:	04090103          	lb	sp,64(s2)
    2dc2:	0100                	.insn	2, 0x0100
    2dc4:	00090103          	lb	sp,0(s2)
    2dc8:	0100                	.insn	2, 0x0100
    2dca:	0105                	.insn	2, 0x0105
    2dcc:	0306                	.insn	2, 0x0306
    2dce:	0901                	.insn	2, 0x0901
    2dd0:	0000                	.insn	2, 0x
    2dd2:	0501                	.insn	2, 0x0501
    2dd4:	0635                	.insn	2, 0x0635
    2dd6:	0c090203          	lb	tp,192(s2)
    2dda:	0100                	.insn	2, 0x0100
    2ddc:	0505                	.insn	2, 0x0505
    2dde:	00090103          	lb	sp,0(s2)
    2de2:	0100                	.insn	2, 0x0100
    2de4:	00090103          	lb	sp,0(s2)
    2de8:	0100                	.insn	2, 0x0100
    2dea:	3505                	.insn	2, 0x3505
    2dec:	0306                	.insn	2, 0x0306
    2dee:	097e                	.insn	2, 0x097e
    2df0:	0000                	.insn	2, 0x
    2df2:	0501                	.insn	2, 0x0501
    2df4:	0305                	.insn	2, 0x0305
    2df6:	0902                	.insn	2, 0x0902
    2df8:	0004                	.insn	2, 0x0004
    2dfa:	0501                	.insn	2, 0x0501
    2dfc:	0335                	.insn	2, 0x0335
    2dfe:	097e                	.insn	2, 0x097e
    2e00:	0004                	.insn	2, 0x0004
    2e02:	0501                	.insn	2, 0x0501
    2e04:	0315                	.insn	2, 0x0315
    2e06:	00040903          	lb	s2,0(s0)
    2e0a:	0501                	.insn	2, 0x0501
    2e0c:	0335                	.insn	2, 0x0335
    2e0e:	097d                	.insn	2, 0x097d
    2e10:	0004                	.insn	2, 0x0004
    2e12:	0501                	.insn	2, 0x0501
    2e14:	0315                	.insn	2, 0x0315
    2e16:	000c0903          	lb	s2,0(s8)
    2e1a:	0501                	.insn	2, 0x0501
    2e1c:	0335                	.insn	2, 0x0335
    2e1e:	097d                	.insn	2, 0x097d
    2e20:	0014                	.insn	2, 0x0014
    2e22:	0301                	.insn	2, 0x0301
    2e24:	0900                	.insn	2, 0x0900
    2e26:	0004                	.insn	2, 0x0004
    2e28:	0501                	.insn	2, 0x0501
    2e2a:	0305                	.insn	2, 0x0305
    2e2c:	0902                	.insn	2, 0x0902
    2e2e:	000c                	.insn	2, 0x000c
    2e30:	0601                	.insn	2, 0x0601
    2e32:	04090103          	lb	sp,64(s2)
    2e36:	0100                	.insn	2, 0x0100
    2e38:	1505                	.insn	2, 0x1505
    2e3a:	0306                	.insn	2, 0x0306
    2e3c:	0900                	.insn	2, 0x0900
    2e3e:	0000                	.insn	2, 0x
    2e40:	0501                	.insn	2, 0x0501
    2e42:	0605                	.insn	2, 0x0605
    2e44:	04090103          	lb	sp,64(s2)
    2e48:	0100                	.insn	2, 0x0100
    2e4a:	00090103          	lb	sp,0(s2)
    2e4e:	0100                	.insn	2, 0x0100
    2e50:	0105                	.insn	2, 0x0105
    2e52:	0306                	.insn	2, 0x0306
    2e54:	0901                	.insn	2, 0x0901
    2e56:	0000                	.insn	2, 0x
    2e58:	0501                	.insn	2, 0x0501
    2e5a:	0644                	.insn	2, 0x0644
    2e5c:	0c090203          	lb	tp,192(s2)
    2e60:	0100                	.insn	2, 0x0100
    2e62:	0505                	.insn	2, 0x0505
    2e64:	00090103          	lb	sp,0(s2)
    2e68:	0100                	.insn	2, 0x0100
    2e6a:	00090103          	lb	sp,0(s2)
    2e6e:	0100                	.insn	2, 0x0100
    2e70:	4405                	.insn	2, 0x4405
    2e72:	0306                	.insn	2, 0x0306
    2e74:	097e                	.insn	2, 0x097e
    2e76:	0000                	.insn	2, 0x
    2e78:	0501                	.insn	2, 0x0501
    2e7a:	0305                	.insn	2, 0x0305
    2e7c:	0902                	.insn	2, 0x0902
    2e7e:	0004                	.insn	2, 0x0004
    2e80:	0501                	.insn	2, 0x0501
    2e82:	0344                	.insn	2, 0x0344
    2e84:	097e                	.insn	2, 0x097e
    2e86:	0004                	.insn	2, 0x0004
    2e88:	0501                	.insn	2, 0x0501
    2e8a:	0315                	.insn	2, 0x0315
    2e8c:	00080903          	lb	s2,0(a6)
    2e90:	0501                	.insn	2, 0x0501
    2e92:	0344                	.insn	2, 0x0344
    2e94:	097d                	.insn	2, 0x097d
    2e96:	0004                	.insn	2, 0x0004
    2e98:	0501                	.insn	2, 0x0501
    2e9a:	0315                	.insn	2, 0x0315
    2e9c:	00080903          	lb	s2,0(a6)
    2ea0:	0501                	.insn	2, 0x0501
    2ea2:	0344                	.insn	2, 0x0344
    2ea4:	097d                	.insn	2, 0x097d
    2ea6:	0014                	.insn	2, 0x0014
    2ea8:	0301                	.insn	2, 0x0301
    2eaa:	0900                	.insn	2, 0x0900
    2eac:	0004                	.insn	2, 0x0004
    2eae:	0501                	.insn	2, 0x0501
    2eb0:	0305                	.insn	2, 0x0305
    2eb2:	0902                	.insn	2, 0x0902
    2eb4:	000c                	.insn	2, 0x000c
    2eb6:	0601                	.insn	2, 0x0601
    2eb8:	04090103          	lb	sp,64(s2)
    2ebc:	0100                	.insn	2, 0x0100
    2ebe:	1505                	.insn	2, 0x1505
    2ec0:	0306                	.insn	2, 0x0306
    2ec2:	0900                	.insn	2, 0x0900
    2ec4:	0000                	.insn	2, 0x
    2ec6:	0501                	.insn	2, 0x0501
    2ec8:	0605                	.insn	2, 0x0605
    2eca:	04090103          	lb	sp,64(s2)
    2ece:	0100                	.insn	2, 0x0100
    2ed0:	00090103          	lb	sp,0(s2)
    2ed4:	0100                	.insn	2, 0x0100
    2ed6:	0105                	.insn	2, 0x0105
    2ed8:	0306                	.insn	2, 0x0306
    2eda:	0901                	.insn	2, 0x0901
    2edc:	0000                	.insn	2, 0x
    2ede:	0501                	.insn	2, 0x0501
    2ee0:	062e                	.insn	2, 0x062e
    2ee2:	0c090203          	lb	tp,192(s2)
    2ee6:	0100                	.insn	2, 0x0100
    2ee8:	0505                	.insn	2, 0x0505
    2eea:	00090103          	lb	sp,0(s2)
    2eee:	0100                	.insn	2, 0x0100
    2ef0:	00090103          	lb	sp,0(s2)
    2ef4:	0100                	.insn	2, 0x0100
    2ef6:	2e05                	.insn	2, 0x2e05
    2ef8:	0306                	.insn	2, 0x0306
    2efa:	097e                	.insn	2, 0x097e
    2efc:	0000                	.insn	2, 0x
    2efe:	0501                	.insn	2, 0x0501
    2f00:	030c                	.insn	2, 0x030c
    2f02:	0902                	.insn	2, 0x0902
    2f04:	0008                	.insn	2, 0x0008
    2f06:	0501                	.insn	2, 0x0501
    2f08:	032e                	.insn	2, 0x032e
    2f0a:	097e                	.insn	2, 0x097e
    2f0c:	0004                	.insn	2, 0x0004
    2f0e:	0501                	.insn	2, 0x0501
    2f10:	030c                	.insn	2, 0x030c
    2f12:	0902                	.insn	2, 0x0902
    2f14:	0004                	.insn	2, 0x0004
    2f16:	0501                	.insn	2, 0x0501
    2f18:	032e                	.insn	2, 0x032e
    2f1a:	097e                	.insn	2, 0x097e
    2f1c:	000c                	.insn	2, 0x000c
    2f1e:	0501                	.insn	2, 0x0501
    2f20:	030c                	.insn	2, 0x030c
    2f22:	0902                	.insn	2, 0x0902
    2f24:	0004                	.insn	2, 0x0004
    2f26:	0501                	.insn	2, 0x0501
    2f28:	0301                	.insn	2, 0x0301
    2f2a:	0901                	.insn	2, 0x0901
    2f2c:	0004                	.insn	2, 0x0004
    2f2e:	0501                	.insn	2, 0x0501
    2f30:	064c                	.insn	2, 0x064c
    2f32:	0c090203          	lb	tp,192(s2)
    2f36:	0100                	.insn	2, 0x0100
    2f38:	0505                	.insn	2, 0x0505
    2f3a:	00090103          	lb	sp,0(s2)
    2f3e:	0100                	.insn	2, 0x0100
    2f40:	4c05                	.insn	2, 0x4c05
    2f42:	0306                	.insn	2, 0x0306
    2f44:	097f 0000 0501 030c 	.insn	10, 0x0901030c05010000097f
    2f4c:	0901 
    2f4e:	0008                	.insn	2, 0x0008
    2f50:	0501                	.insn	2, 0x0501
    2f52:	034c                	.insn	2, 0x034c
    2f54:	097f 0004 0501 030c 	.insn	10, 0x0901030c05010004097f
    2f5c:	0901 
    2f5e:	0004                	.insn	2, 0x0004
    2f60:	0501                	.insn	2, 0x0501
    2f62:	0628                	.insn	2, 0x0628
    2f64:	14090403          	lb	s0,320(s2)
    2f68:	0100                	.insn	2, 0x0100
    2f6a:	0505                	.insn	2, 0x0505
    2f6c:	00090103          	lb	sp,0(s2)
    2f70:	0100                	.insn	2, 0x0100
    2f72:	00090103          	lb	sp,0(s2)
    2f76:	0100                	.insn	2, 0x0100
    2f78:	2805                	.insn	2, 0x2805
    2f7a:	0306                	.insn	2, 0x0306
    2f7c:	097e                	.insn	2, 0x097e
    2f7e:	0000                	.insn	2, 0x
    2f80:	0501                	.insn	2, 0x0501
    2f82:	0305                	.insn	2, 0x0305
    2f84:	0902                	.insn	2, 0x0902
    2f86:	0004                	.insn	2, 0x0004
    2f88:	0501                	.insn	2, 0x0501
    2f8a:	0315                	.insn	2, 0x0315
    2f8c:	0902                	.insn	2, 0x0902
    2f8e:	0004                	.insn	2, 0x0004
    2f90:	0501                	.insn	2, 0x0501
    2f92:	0328                	.insn	2, 0x0328
    2f94:	097c                	.insn	2, 0x097c
    2f96:	0004                	.insn	2, 0x0004
    2f98:	0501                	.insn	2, 0x0501
    2f9a:	0315                	.insn	2, 0x0315
    2f9c:	0904                	.insn	2, 0x0904
    2f9e:	0010                	.insn	2, 0x0010
    2fa0:	0501                	.insn	2, 0x0501
    2fa2:	0328                	.insn	2, 0x0328
    2fa4:	097c                	.insn	2, 0x097c
    2fa6:	0014                	.insn	2, 0x0014
    2fa8:	0501                	.insn	2, 0x0501
    2faa:	031d                	.insn	2, 0x031d
    2fac:	00040903          	lb	s2,0(s0)
    2fb0:	0501                	.insn	2, 0x0501
    2fb2:	0328                	.insn	2, 0x0328
    2fb4:	097d                	.insn	2, 0x097d
    2fb6:	0008                	.insn	2, 0x0008
    2fb8:	0501                	.insn	2, 0x0501
    2fba:	0305                	.insn	2, 0x0305
    2fbc:	0902                	.insn	2, 0x0902
    2fbe:	000c                	.insn	2, 0x000c
    2fc0:	0601                	.insn	2, 0x0601
    2fc2:	04090103          	lb	sp,64(s2)
    2fc6:	0100                	.insn	2, 0x0100
    2fc8:	00090103          	lb	sp,0(s2)
    2fcc:	0100                	.insn	2, 0x0100
    2fce:	1505                	.insn	2, 0x1505
    2fd0:	0306                	.insn	2, 0x0306
    2fd2:	0900                	.insn	2, 0x0900
    2fd4:	0000                	.insn	2, 0x
    2fd6:	0501                	.insn	2, 0x0501
    2fd8:	0605                	.insn	2, 0x0605
    2fda:	04090203          	lb	tp,64(s2)
    2fde:	0100                	.insn	2, 0x0100
    2fe0:	00090103          	lb	sp,0(s2)
    2fe4:	0100                	.insn	2, 0x0100
    2fe6:	0105                	.insn	2, 0x0105
    2fe8:	0306                	.insn	2, 0x0306
    2fea:	0901                	.insn	2, 0x0901
    2fec:	0000                	.insn	2, 0x
    2fee:	0901                	.insn	2, 0x0901
    2ff0:	000c                	.insn	2, 0x000c
    2ff2:	0100                	.insn	2, 0x0100
    2ff4:	Address 0x2ff4 is out of bounds.


Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	20554e47          	fmsub.s	ft8,fa0,ft5,ft4,rmm
   4:	20373143          	fmadd.s	ft2,fa4,ft3,ft4,rup
   8:	3431                	.insn	2, 0x3431
   a:	322e                	.insn	2, 0x322e
   c:	302e                	.insn	2, 0x302e
   e:	2d20                	.insn	2, 0x2d20
  10:	746d                	.insn	2, 0x746d
  12:	6e75                	.insn	2, 0x6e75
  14:	3d65                	.insn	2, 0x3d65
  16:	6f72                	.insn	2, 0x6f72
  18:	74656b63          	bltu	a0,t1,76e <main-0x7ffff892>
  1c:	2d20                	.insn	2, 0x2d20
  1e:	616d                	.insn	2, 0x616d
  20:	6962                	.insn	2, 0x6962
  22:	693d                	.insn	2, 0x693d
  24:	706c                	.insn	2, 0x706c
  26:	2d203233          	.insn	4, 0x2d203233
  2a:	696d                	.insn	2, 0x696d
  2c:	732d6173          	csrrsi	sp,mhpmevent18h,26
  30:	6570                	.insn	2, 0x6570
  32:	30323d63          	.insn	4, 0x30323d63
  36:	3931                	.insn	2, 0x3931
  38:	3231                	.insn	2, 0x3231
  3a:	3331                	.insn	2, 0x3331
  3c:	2d20                	.insn	2, 0x2d20
  3e:	746d                	.insn	2, 0x746d
  40:	736c                	.insn	2, 0x736c
  42:	642d                	.insn	2, 0x642d
  44:	6169                	.insn	2, 0x6169
  46:	656c                	.insn	2, 0x656c
  48:	743d7463          	bgeu	s10,gp,790 <main-0x7ffff870>
  4c:	6172                	.insn	2, 0x6172
  4e:	2064                	.insn	2, 0x2064
  50:	6d2d                	.insn	2, 0x6d2d
  52:	7261                	.insn	2, 0x7261
  54:	723d6863          	bltu	s10,gp,784 <main-0x7ffff87c>
  58:	3376                	.insn	2, 0x3376
  5a:	6932                	.insn	2, 0x6932
  5c:	616d                	.insn	2, 0x616d
  5e:	6466                	.insn	2, 0x6466
  60:	7a5f 6369 7273      	.insn	6, 0x727363697a5f
  66:	2d20                	.insn	2, 0x2d20
  68:	4f2d2067          	.insn	4, 0x4f2d2067
  6c:	6f6c0033          	.insn	4, 0x6f6c0033
  70:	676e                	.insn	2, 0x676e
  72:	6420                	.insn	2, 0x6420
  74:	6c62756f          	jal	a0,2773a <main-0x7ffd88c6>
  78:	0065                	.insn	2, 0x0065
  7a:	616d                	.insn	2, 0x616d
  7c:	6e69                	.insn	2, 0x6e69
  7e:	6c00                	.insn	2, 0x6c00
  80:	20676e6f          	jal	t3,76286 <main-0x7ff89d7a>
  84:	6f6c                	.insn	2, 0x6f6c
  86:	676e                	.insn	2, 0x676e
  88:	6920                	.insn	2, 0x6920
  8a:	746e                	.insn	2, 0x746e
  8c:	6300                	.insn	2, 0x6300
  8e:	746e756f          	jal	a0,e77d4 <main-0x7ff1882c>
  92:	7000                	.insn	2, 0x7000
  94:	6572                	.insn	2, 0x6572
  96:	69730063          	beq	t1,s7,716 <main-0x7ffff8ea>
  9a:	657a                	.insn	2, 0x657a
  9c:	745f 7500 6e69      	.insn	6, 0x6e697500745f
  a2:	7074                	.insn	2, 0x7074
  a4:	7274                	.insn	2, 0x7274
  a6:	745f 6700 7465      	.insn	6, 0x74656700745f
  ac:	735f 7274 6e69      	.insn	6, 0x6e697274735f
  b2:	705f0067          	jalr	zero,1797(t5)
  b6:	7475                	.insn	2, 0x7475
  b8:	72616863          	bltu	sp,t1,7e8 <main-0x7ffff818>
  bc:	5f00                	.insn	2, 0x5f00
  be:	7466                	.insn	2, 0x7466
  c0:	5f00616f          	jal	sp,66b0 <main-0x7fff9950>
  c4:	5f74756f          	jal	a0,47eba <main-0x7ffb8146>
  c8:	72616863          	bltu	sp,t1,7f8 <main-0x7ffff808>
  cc:	6c00                	.insn	2, 0x6c00
  ce:	20676e6f          	jal	t3,762d4 <main-0x7ff89d2c>
  d2:	6f6c                	.insn	2, 0x6f6c
  d4:	676e                	.insn	2, 0x676e
  d6:	7520                	.insn	2, 0x7520
  d8:	736e                	.insn	2, 0x736e
  da:	6769                	.insn	2, 0x6769
  dc:	656e                	.insn	2, 0x656e
  de:	2064                	.insn	2, 0x2064
  e0:	6e69                	.insn	2, 0x6e69
  e2:	0074                	.insn	2, 0x0074
  e4:	6964                	.insn	2, 0x6964
  e6:	6666                	.insn	2, 0x6666
  e8:	5f00                	.insn	2, 0x5f00
  ea:	7376                	.insn	2, 0x7376
  ec:	706e                	.insn	2, 0x706e
  ee:	6972                	.insn	2, 0x6972
  f0:	746e                	.insn	2, 0x746e
  f2:	0066                	.insn	2, 0x0066
  f4:	5f5f 7562 6c69      	.insn	6, 0x6c6975625f5f
  fa:	6974                	.insn	2, 0x6974
  fc:	5f6e                	.insn	2, 0x5f6e
  fe:	6176                	.insn	2, 0x6176
 100:	6c5f 7369 0074      	.insn	6, 0x007473696c5f
 106:	766e6f63          	bltu	t3,t1,884 <main-0x7ffff77c>
 10a:	6300                	.insn	2, 0x6300
 10c:	6168                	.insn	2, 0x6168
 10e:	6172                	.insn	2, 0x6172
 110:	72657463          	bgeu	a0,t1,838 <main-0x7ffff7c8>
 114:	7300                	.insn	2, 0x7300
 116:	7270                	.insn	2, 0x7270
 118:	6e69                	.insn	2, 0x6e69
 11a:	6674                	.insn	2, 0x6674
 11c:	005f 6176 756c      	.insn	6, 0x756c6176005f
 122:	0065                	.insn	2, 0x0065
 124:	32727473          	csrrci	s0,mhpmevent7,4
 128:	6e69                	.insn	2, 0x6e69
 12a:	0074                	.insn	2, 0x0074
 12c:	6f5f 7475 665f      	.insn	6, 0x665f74756f5f
 132:	5f007463          	bgeu	zero,a6,71a <main-0x7ffff8e6>
 136:	7461                	.insn	2, 0x7461
 138:	5f00696f          	jal	s2,6728 <main-0x7fff98d8>
 13c:	5f74756f          	jal	a0,47f32 <main-0x7ffb80ce>
 140:	7562                	.insn	2, 0x7562
 142:	6666                	.insn	2, 0x6666
 144:	7265                	.insn	2, 0x7265
 146:	6700                	.insn	2, 0x6700
 148:	7465                	.insn	2, 0x7465
 14a:	635f 6168 0072      	.insn	6, 0x00726168635f
 150:	7076                	.insn	2, 0x7076
 152:	6972                	.insn	2, 0x6972
 154:	746e                	.insn	2, 0x746e
 156:	5f66                	.insn	2, 0x5f66
 158:	5f00                	.insn	2, 0x5f00
 15a:	736d                	.insn	2, 0x736d
 15c:	68730067          	jalr	zero,1671(t1) # 9662901 <main-0x7699d6ff>
 160:	2074726f          	jal	tp,47b66 <main-0x7ffb849a>
 164:	6e75                	.insn	2, 0x6e75
 166:	6e676973          	csrrsi	s2,0x6e6,14
 16a:	6465                	.insn	2, 0x6465
 16c:	6920                	.insn	2, 0x6920
 16e:	746e                	.insn	2, 0x746e
 170:	6d00                	.insn	2, 0x6d00
 172:	7861                	.insn	2, 0x7861
 174:	656c                	.insn	2, 0x656c
 176:	006e                	.insn	2, 0x006e
 178:	6f5f 7475 725f      	.insn	6, 0x725f74756f5f
 17e:	7665                	.insn	2, 0x7665
 180:	7700                	.insn	2, 0x7700
 182:	6f68                	.insn	2, 0x6f68
 184:	656c                	.insn	2, 0x656c
 186:	6500                	.insn	2, 0x6500
 188:	7078                	.insn	2, 0x7078
 18a:	0032                	.insn	2, 0x0032
 18c:	6f5f 7475 6e5f      	.insn	6, 0x6e5f74756f5f
 192:	6c75                	.insn	2, 0x6c75
 194:	006c                	.insn	2, 0x006c
 196:	6162                	.insn	2, 0x6162
 198:	6d006573          	csrrsi	a0,0x6d0,0
 19c:	6e69                	.insn	2, 0x6e69
 19e:	74646977          	.insn	4, 0x74646977
 1a2:	0068                	.insn	2, 0x0068
 1a4:	5f5f 6e67 6375      	.insn	6, 0x63756e675f5f
 1aa:	765f 5f61 696c      	.insn	6, 0x696c5f61765f
 1b0:	5f007473          	csrrci	s0,0x5f0,0
 1b4:	746e                	.insn	2, 0x746e
 1b6:	6c5f616f          	jal	sp,f707a <main-0x7ff08f86>
 1ba:	00676e6f          	jal	t3,761c0 <main-0x7ff89e40>
 1be:	5f5f 6975 746e      	.insn	6, 0x746e69755f5f
 1c4:	3436                	.insn	2, 0x3436
 1c6:	745f 7300 6174      	.insn	6, 0x61747300745f
 1cc:	7472                	.insn	2, 0x7472
 1ce:	695f 7864 6600      	.insn	6, 0x66007864695f
 1d4:	6172                	.insn	2, 0x6172
 1d6:	756f0063          	beq	t5,s6,916 <main-0x7ffff6ea>
 1da:	5f74                	.insn	2, 0x5f74
 1dc:	6366                	.insn	2, 0x6366
 1de:	5f74                	.insn	2, 0x5f74
 1e0:	70617277          	.insn	4, 0x70617277
 1e4:	6f00                	.insn	2, 0x6f00
 1e6:	7475                	.insn	2, 0x7475
 1e8:	665f 7463 745f      	.insn	6, 0x745f7463665f
 1ee:	7079                	.insn	2, 0x7079
 1f0:	0065                	.insn	2, 0x0065
 1f2:	425f 6f6f 006c      	.insn	6, 0x006c6f6f425f
 1f8:	6e75                	.insn	2, 0x6e75
 1fa:	6e676973          	csrrsi	s2,0x6e6,14
 1fe:	6465                	.insn	2, 0x6465
 200:	6320                	.insn	2, 0x6320
 202:	6168                	.insn	2, 0x6168
 204:	0072                	.insn	2, 0x0072
 206:	6f70                	.insn	2, 0x6f70
 208:	00303177          	.insn	4, 0x00303177
 20c:	726f6873          	csrrsi	a6,mhpmevent6h,30
 210:	2074                	.insn	2, 0x2074
 212:	6e69                	.insn	2, 0x6e69
 214:	0074                	.insn	2, 0x0074
 216:	5f74756f          	jal	a0,4800c <main-0x7ffb7ff4>
 21a:	6366                	.insn	2, 0x6366
 21c:	5f74                	.insn	2, 0x5f74
 21e:	70617277          	.insn	4, 0x70617277
 222:	745f 7079 0065      	.insn	6, 0x00657079745f
 228:	6e5f 6f74 5f61      	.insn	6, 0x5f616f746e5f
 22e:	6f66                	.insn	2, 0x6f66
 230:	6d72                	.insn	2, 0x6d72
 232:	7461                	.insn	2, 0x7461
 234:	7000                	.insn	2, 0x7000
 236:	6572                	.insn	2, 0x6572
 238:	69736963          	bltu	t1,s7,8ca <main-0x7ffff736>
 23c:	76006e6f          	jal	t3,699c <main-0x7fff9664>
 240:	72706e73          	csrrsi	t3,mhpmevent7h,0
 244:	6e69                	.insn	2, 0x6e69
 246:	6674                	.insn	2, 0x6674
 248:	005f 7865 7670      	.insn	6, 0x76707865005f
 24e:	6c61                	.insn	2, 0x6c61
 250:	5f00                	.insn	2, 0x5f00
 252:	6e727473          	csrrci	s0,0x6e7,4
 256:	656c                	.insn	2, 0x656c
 258:	5f6e                	.insn	2, 0x5f6e
 25a:	77660073          	.insn	4, 0x77660073
 25e:	6469                	.insn	2, 0x6469
 260:	6874                	.insn	2, 0x6874
 262:	6600                	.insn	2, 0x6600
 264:	72707463          	bgeu	zero,t2,98c <main-0x7ffff674>
 268:	6e69                	.insn	2, 0x6e69
 26a:	6674                	.insn	2, 0x6674
 26c:	6300                	.insn	2, 0x6300
 26e:	6168                	.insn	2, 0x6168
 270:	3272                	.insn	2, 0x3272
 272:	6e69                	.insn	2, 0x6e69
 274:	0074                	.insn	2, 0x0074
 276:	655f 6f74 0061      	.insn	6, 0x00616f74655f
 27c:	6c66                	.insn	2, 0x6c66
 27e:	6761                	.insn	2, 0x6761
 280:	656e0073          	.insn	4, 0x656e0073
 284:	69746167          	.insn	4, 0x69746167
 288:	6576                	.insn	2, 0x6576
 28a:	5f00                	.insn	2, 0x5f00
 28c:	7369                	.insn	2, 0x7369
 28e:	645f 6769 7469      	.insn	6, 0x74696769645f
 294:	6d00                	.insn	2, 0x6d00
 296:	7861                	.insn	2, 0x7861
 298:	657a6973          	csrrsi	s2,hviprio2h,20
 29c:	7200                	.insn	2, 0x7200
 29e:	7365                	.insn	2, 0x7365
 2a0:	6c75                	.insn	2, 0x6c75
 2a2:	0074                	.insn	2, 0x0074

Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
   0:	6c66                	.insn	2, 0x6c66
   2:	5f74616f          	jal	sp,46df8 <main-0x7ffb9208>
   6:	6574                	.insn	2, 0x6574
   8:	632e7473          	csrrci	s0,0x632,28
   c:	2f00                	.insn	2, 0x2f00
   e:	6f68                	.insn	2, 0x6f68
  10:	656d                	.insn	2, 0x656d
  12:	6d61722f          	.insn	4, 0x6d61722f
  16:	6e65                	.insn	2, 0x6e65
  18:	776f442f          	.insn	4, 0x776f442f
  1c:	6c6e                	.insn	2, 0x6c6e
  1e:	7364616f          	jal	sp,46754 <main-0x7ffb98ac>
  22:	3376722f          	.insn	4, 0x3376722f
  26:	2d32                	.insn	2, 0x2d32
  28:	6d65                	.insn	2, 0x6d65
  2a:	6c75                	.insn	2, 0x6c75
  2c:	7461                	.insn	2, 0x7461
  2e:	632f726f          	jal	tp,f7660 <main-0x7ff089a0>
  32:	745f 7365 0074      	.insn	6, 0x00747365745f
  38:	6564                	.insn	2, 0x6564
  3a:	7562                	.insn	2, 0x7562
  3c:	00682e67          	.insn	4, 0x00682e67
  40:	6564                	.insn	2, 0x6564
  42:	7562                	.insn	2, 0x7562
  44:	00632e67          	.insn	4, 0x00632e67
  48:	74706f2f          	.insn	4, 0x74706f2f
  4c:	7369722f          	.insn	4, 0x7369722f
  50:	732f7663          	bgeu	t5,s2,77c <main-0x7ffff884>
  54:	7379                	.insn	2, 0x7379
  56:	6f72                	.insn	2, 0x6f72
  58:	752f746f          	jal	s0,f77aa <main-0x7ff08856>
  5c:	692f7273          	csrrci	tp,0x692,30
  60:	636e                	.insn	2, 0x636e
  62:	756c                	.insn	2, 0x756c
  64:	6564                	.insn	2, 0x6564
  66:	7469622f          	.insn	4, 0x7469622f
  6a:	6f2f0073          	.insn	4, 0x6f2f0073
  6e:	7470                	.insn	2, 0x7470
  70:	7369722f          	.insn	4, 0x7369722f
  74:	732f7663          	bgeu	t5,s2,7a0 <main-0x7ffff860>
  78:	7379                	.insn	2, 0x7379
  7a:	6f72                	.insn	2, 0x6f72
  7c:	752f746f          	jal	s0,f77ce <main-0x7ff08832>
  80:	692f7273          	csrrci	tp,0x692,30
  84:	636e                	.insn	2, 0x636e
  86:	756c                	.insn	2, 0x756c
  88:	6564                	.insn	2, 0x6564
  8a:	2f00                	.insn	2, 0x2f00
  8c:	2f74706f          	jal	zero,47b82 <main-0x7ffb847e>
  90:	6972                	.insn	2, 0x6972
  92:	2f766373          	csrrsi	t1,0x2f7,12
  96:	696c                	.insn	2, 0x696c
  98:	2f62                	.insn	2, 0x2f62
  9a:	2f636367          	.insn	4, 0x2f636367
  9e:	6972                	.insn	2, 0x6972
  a0:	33766373          	csrrsi	t1,mhpmevent23,12
  a4:	2d32                	.insn	2, 0x2d32
  a6:	6e75                	.insn	2, 0x6e75
  a8:	776f6e6b          	.insn	4, 0x776f6e6b
  ac:	2d6e                	.insn	2, 0x2d6e
  ae:	696c                	.insn	2, 0x696c
  b0:	756e                	.insn	2, 0x756e
  b2:	2d78                	.insn	2, 0x2d78
  b4:	2f756e67          	.insn	4, 0x2f756e67
  b8:	3431                	.insn	2, 0x3431
  ba:	322e                	.insn	2, 0x322e
  bc:	302e                	.insn	2, 0x302e
  be:	636e692f          	.insn	4, 0x636e692f
  c2:	756c                	.insn	2, 0x756c
  c4:	6564                	.insn	2, 0x6564
  c6:	7400                	.insn	2, 0x7400
  c8:	7079                	.insn	2, 0x7079
  ca:	7365                	.insn	2, 0x7365
  cc:	682e                	.insn	2, 0x682e
  ce:	7300                	.insn	2, 0x7300
  d0:	6474                	.insn	2, 0x6474
  d2:	6e69                	.insn	2, 0x6e69
  d4:	2d74                	.insn	2, 0x2d74
  d6:	6975                	.insn	2, 0x6975
  d8:	746e                	.insn	2, 0x746e
  da:	2e6e                	.insn	2, 0x2e6e
  dc:	0068                	.insn	2, 0x0068
  de:	69647473          	csrrci	s0,0x696,8
  e2:	746e                	.insn	2, 0x746e
  e4:	682e                	.insn	2, 0x682e
  e6:	7300                	.insn	2, 0x7300
  e8:	6474                	.insn	2, 0x6474
  ea:	7261                	.insn	2, 0x7261
  ec:	00682e67          	.insn	4, 0x00682e67
  f0:	64647473          	csrrci	s0,hviprio1,8
  f4:	6665                	.insn	2, 0x6665
  f6:	682e                	.insn	2, 0x682e
	...

Disassembly of section .debug_loclists:

00000000 <.debug_loclists>:
       0:	2625                	.insn	2, 0x2625
       2:	0000                	.insn	2, 0x
       4:	0005                	.insn	2, 0x0005
       6:	0004                	.insn	2, 0x0004
       8:	0000                	.insn	2, 0x
       a:	0000                	.insn	2, 0x
       c:	b004                	.insn	2, 0xb004
       e:	dc38                	.insn	2, 0xdc38
      10:	0138                	.insn	2, 0x0138
      12:	045a                	.insn	2, 0x045a
      14:	38dc                	.insn	2, 0x38dc
      16:	6d0138ff 8c38ff04 	.insn	16, 0xa8260aa503a30a398c38ff046d0138ff
      1e:	03a30a39 a8260aa5 
      26:	a82d                	.insn	2, 0xa82d
      28:	9f00                	.insn	2, 0x9f00
      2a:	0400                	.insn	2, 0x0400
      2c:	38b0                	.insn	2, 0x38b0
      2e:	38d4                	.insn	2, 0x38d4
      30:	5b01                	.insn	2, 0x5b01
      32:	d404                	.insn	2, 0xd404
      34:	ff38                	.insn	2, 0xff38
      36:	0138                	.insn	2, 0x0138
      38:	046c                	.insn	2, 0x046c
      3a:	398c38ff a503a30a 	.insn	16, 0x009f00a82da8260ba503a30a398c38ff
      42:	2da8260b 009f00a8 
      4a:	b004                	.insn	2, 0xb004
      4c:	e038                	.insn	2, 0xe038
      4e:	0138                	.insn	2, 0x0138
      50:	045c                	.insn	2, 0x045c
      52:	38e0                	.insn	2, 0x38e0
      54:	5d0138ff 8c38ff04 	.insn	16, 0xa8260ca503a30a398c38ff045d0138ff
      5c:	03a30a39 a8260ca5 
      64:	a82d                	.insn	2, 0xa82d
      66:	9f00                	.insn	2, 0x9f00
      68:	0400                	.insn	2, 0x0400
      6a:	388c                	.insn	2, 0x388c
      6c:	38ac                	.insn	2, 0x38ac
      6e:	5a01                	.insn	2, 0x5a01
      70:	ac04                	.insn	2, 0xac04
      72:	af38                	.insn	2, 0xaf38
      74:	0138                	.insn	2, 0x0138
      76:	38af045b          	.insn	4, 0x38af045b
      7a:	38b0                	.insn	2, 0x38b0
      7c:	a30a                	.insn	2, 0xa30a
      7e:	260aa503          	lw	a0,608(s5)
      82:	2da8                	.insn	2, 0x2da8
      84:	00a8                	.insn	2, 0x00a8
      86:	009f 8c04 a038      	.insn	6, 0xa0388c04009f
      8c:	0138                	.insn	2, 0x0138
      8e:	38a0045b          	.insn	4, 0x38a0045b
      92:	610138af          	.insn	4, 0x610138af
      96:	af04                	.insn	2, 0xaf04
      98:	b038                	.insn	2, 0xb038
      9a:	0a38                	.insn	2, 0x0a38
      9c:	0ba503a3          	sb	s10,167(a0)
      a0:	a826                	.insn	2, 0xa826
      a2:	a82d                	.insn	2, 0xa82d
      a4:	9f00                	.insn	2, 0x9f00
      a6:	0400                	.insn	2, 0x0400
      a8:	388c                	.insn	2, 0x388c
      aa:	38a4                	.insn	2, 0x38a4
      ac:	5c01                	.insn	2, 0x5c01
      ae:	a404                	.insn	2, 0xa404
      b0:	af38                	.insn	2, 0xaf38
      b2:	0138                	.insn	2, 0x0138
      b4:	0460                	.insn	2, 0x0460
      b6:	38b038af          	.insn	4, 0x38b038af
      ba:	a30a                	.insn	2, 0xa30a
      bc:	260ca503          	lw	a0,608(s9)
      c0:	2da8                	.insn	2, 0x2da8
      c2:	00a8                	.insn	2, 0x00a8
      c4:	009f 8c04 a838      	.insn	6, 0xa8388c04009f
      ca:	0138                	.insn	2, 0x0138
      cc:	045d                	.insn	2, 0x045d
      ce:	38a8                	.insn	2, 0x38a8
      d0:	5e0138af          	.insn	4, 0x5e0138af
      d4:	af04                	.insn	2, 0xaf04
      d6:	b038                	.insn	2, 0xb038
      d8:	0a38                	.insn	2, 0x0a38
      da:	0da503a3          	sb	s10,199(a0)
      de:	a826                	.insn	2, 0xa826
      e0:	a82d                	.insn	2, 0xa82d
      e2:	9f00                	.insn	2, 0x9f00
      e4:	0400                	.insn	2, 0x0400
      e6:	37dc                	.insn	2, 0x37dc
      e8:	37e8                	.insn	2, 0x37e8
      ea:	5a01                	.insn	2, 0x5a01
      ec:	e804                	.insn	2, 0xe804
      ee:	0137ff37          	lui	t5,0x137f
      f2:	045d                	.insn	2, 0x045d
      f4:	388c37ff a503a30a 	.insn	16, 0x009f00a82da8260aa503a30a388c37ff
      fc:	2da8260a 009f00a8 
     104:	dc04                	.insn	2, 0xdc04
     106:	0137f437          	lui	s0,0x137f
     10a:	37f4045b          	.insn	4, 0x37f4045b
     10e:	5e0137ff 8c37ff04 	.insn	16, 0xa8260ba503a30a388c37ff045e0137ff
     116:	03a30a38 a8260ba5 
     11e:	a82d                	.insn	2, 0xa82d
     120:	9f00                	.insn	2, 0x9f00
     122:	0400                	.insn	2, 0x0400
     124:	3788                	.insn	2, 0x3788
     126:	37b8                	.insn	2, 0x37b8
     128:	5a01                	.insn	2, 0x5a01
     12a:	b804                	.insn	2, 0xb804
     12c:	0137cf37          	lui	t5,0x137c
     130:	37cf045b          	.insn	4, 0x37cf045b
     134:	37dc                	.insn	2, 0x37dc
     136:	a30a                	.insn	2, 0xa30a
     138:	260aa503          	lw	a0,608(s5)
     13c:	2da8                	.insn	2, 0x2da8
     13e:	00a8                	.insn	2, 0x00a8
     140:	009f 8804 a837      	.insn	6, 0xa8378804009f
     146:	045b0137          	lui	sp,0x45b0
     14a:	37a8                	.insn	2, 0x37a8
     14c:	6e0137cf          	.insn	4, 0x6e0137cf
     150:	cf04                	.insn	2, 0xcf04
     152:	0a37dc37          	lui	s8,0xa37d
     156:	0ba503a3          	sb	s10,167(a0)
     15a:	a826                	.insn	2, 0xa826
     15c:	a82d                	.insn	2, 0xa82d
     15e:	9f00                	.insn	2, 0x9f00
     160:	0400                	.insn	2, 0x0400
     162:	3788                	.insn	2, 0x3788
     164:	37ac                	.insn	2, 0x37ac
     166:	5c01                	.insn	2, 0x5c01
     168:	ac04                	.insn	2, 0xac04
     16a:	0137cf37          	lui	t5,0x137c
     16e:	046d                	.insn	2, 0x046d
     170:	37dc37cf          	.insn	4, 0x37dc37cf
     174:	a30a                	.insn	2, 0xa30a
     176:	260ca503          	lw	a0,608(s9)
     17a:	2da8                	.insn	2, 0x2da8
     17c:	00a8                	.insn	2, 0x00a8
     17e:	009f b404 e036      	.insn	6, 0xe036b404009f
     184:	0136                	.insn	2, 0x0136
     186:	045a                	.insn	2, 0x045a
     188:	36e0                	.insn	2, 0x36e0
     18a:	5b0136fb          	.insn	4, 0x5b0136fb
     18e:	fb04                	.insn	2, 0xfb04
     190:	8836                	.insn	2, 0x8836
     192:	03a30a37          	lui	s4,0x3a30
     196:	0aa5                	.insn	2, 0x0aa5
     198:	a826                	.insn	2, 0xa826
     19a:	a82d                	.insn	2, 0xa82d
     19c:	9f00                	.insn	2, 0x9f00
     19e:	0400                	.insn	2, 0x0400
     1a0:	36b4                	.insn	2, 0x36b4
     1a2:	36d4                	.insn	2, 0x36d4
     1a4:	5b01                	.insn	2, 0x5b01
     1a6:	d404                	.insn	2, 0xd404
     1a8:	fb36                	.insn	2, 0xfb36
     1aa:	0136                	.insn	2, 0x0136
     1ac:	046d                	.insn	2, 0x046d
     1ae:	378836fb          	.insn	4, 0x378836fb
     1b2:	a30a                	.insn	2, 0xa30a
     1b4:	260ba503          	lw	a0,608(s7)
     1b8:	2da8                	.insn	2, 0x2da8
     1ba:	00a8                	.insn	2, 0x00a8
     1bc:	009f e004 8c35      	.insn	6, 0x8c35e004009f
     1c2:	0136                	.insn	2, 0x0136
     1c4:	045a                	.insn	2, 0x045a
     1c6:	368c                	.insn	2, 0x368c
     1c8:	5d0136a7          	fsd	fa6,1485(sp) # 45b05cd <main-0x7ba4fa33>
     1cc:	a704                	.insn	2, 0xa704
     1ce:	b436                	.insn	2, 0xb436
     1d0:	0a36                	.insn	2, 0x0a36
     1d2:	0aa503a3          	sb	a0,167(a0)
     1d6:	a826                	.insn	2, 0xa826
     1d8:	a82d                	.insn	2, 0xa82d
     1da:	9f00                	.insn	2, 0x9f00
     1dc:	0400                	.insn	2, 0x0400
     1de:	20f0                	.insn	2, 0x20f0
     1e0:	21b0                	.insn	2, 0x21b0
     1e2:	5a01                	.insn	2, 0x5a01
     1e4:	b004                	.insn	2, 0xb004
     1e6:	f421                	.insn	2, 0xf421
     1e8:	0125                	.insn	2, 0x0125
     1ea:	26880463          	beq	a6,s0,452 <main-0x7ffffbae>
     1ee:	2a90                	.insn	2, 0x2a90
     1f0:	6301                	.insn	2, 0x6301
     1f2:	9004                	.insn	2, 0x9004
     1f4:	942a                	.insn	2, 0x942a
     1f6:	012a                	.insn	2, 0x012a
     1f8:	045a                	.insn	2, 0x045a
     1fa:	2a94                	.insn	2, 0x2a94
     1fc:	2a98                	.insn	2, 0x2a98
     1fe:	6301                	.insn	2, 0x6301
     200:	9804                	.insn	2, 0x9804
     202:	9c2a                	.insn	2, 0x9c2a
     204:	0a2a                	.insn	2, 0x0a2a
     206:	0aa503a3          	sb	a0,167(a0)
     20a:	a826                	.insn	2, 0xa826
     20c:	a82d                	.insn	2, 0xa82d
     20e:	9f00                	.insn	2, 0x9f00
     210:	9c04                	.insn	2, 0x9c04
     212:	d82a                	.insn	2, 0xd82a
     214:	00630133          	add	sp,t1,t1
     218:	f004                	.insn	2, 0xf004
     21a:	e020                	.insn	2, 0xe020
     21c:	0121                	.insn	2, 0x0121
     21e:	21e0045b          	.insn	4, 0x21e0045b
     222:	25f0                	.insn	2, 0x25f0
     224:	6201                	.insn	2, 0x6201
     226:	f004                	.insn	2, 0xf004
     228:	8825                	.insn	2, 0x8825
     22a:	0a26                	.insn	2, 0x0a26
     22c:	0ba503a3          	sb	s10,167(a0)
     230:	a826                	.insn	2, 0xa826
     232:	a82d                	.insn	2, 0xa82d
     234:	9f00                	.insn	2, 0x9f00
     236:	8804                	.insn	2, 0x8804
     238:	9026                	.insn	2, 0x9026
     23a:	012a                	.insn	2, 0x012a
     23c:	0462                	.insn	2, 0x0462
     23e:	2a90                	.insn	2, 0x2a90
     240:	2ab0                	.insn	2, 0x2ab0
     242:	5b01                	.insn	2, 0x5b01
     244:	b004                	.insn	2, 0xb004
     246:	d82a                	.insn	2, 0xd82a
     248:	00620133          	add	sp,tp,t1
     24c:	f004                	.insn	2, 0xf004
     24e:	e020                	.insn	2, 0xe020
     250:	0121                	.insn	2, 0x0121
     252:	045c                	.insn	2, 0x045c
     254:	21e0                	.insn	2, 0x21e0
     256:	25ec                	.insn	2, 0x25ec
     258:	5901                	.insn	2, 0x5901
     25a:	ec04                	.insn	2, 0xec04
     25c:	8825                	.insn	2, 0x8825
     25e:	0a26                	.insn	2, 0x0a26
     260:	0ca503a3          	sb	a0,199(a0)
     264:	a826                	.insn	2, 0xa826
     266:	a82d                	.insn	2, 0xa82d
     268:	9f00                	.insn	2, 0x9f00
     26a:	8804                	.insn	2, 0x8804
     26c:	d826                	.insn	2, 0xd826
     26e:	00590133          	add	sp,s2,t0
     272:	f004                	.insn	2, 0xf004
     274:	e020                	.insn	2, 0xe020
     276:	0121                	.insn	2, 0x0121
     278:	045d                	.insn	2, 0x045d
     27a:	21fc                	.insn	2, 0x21fc
     27c:	2280                	.insn	2, 0x2280
     27e:	9f038a03          	lb	s4,-1552(t2)
     282:	8004                	.insn	2, 0x8004
     284:	8822                	.insn	2, 0x8822
     286:	0322                	.insn	2, 0x0322
     288:	028a                	.insn	2, 0x028a
     28a:	049f 22fc 2388      	.insn	6, 0x238822fc049f
     290:	5f01                	.insn	2, 0x5f01
     292:	bc04                	.insn	2, 0xbc04
     294:	0323c423          	.insn	4, 0x0323c423
     298:	017e                	.insn	2, 0x017e
     29a:	049f 23c8 23d0      	.insn	6, 0x23d023c8049f
     2a0:	9f017e03          	.insn	4, 0x9f017e03
     2a4:	d404                	.insn	2, 0xd404
     2a6:	0323dc23          	.insn	4, 0x0323dc23
     2aa:	017e                	.insn	2, 0x017e
     2ac:	049f 23e0 23e8      	.insn	6, 0x23e823e0049f
     2b2:	9f017e03          	.insn	4, 0x9f017e03
     2b6:	ec04                	.insn	2, 0xec04
     2b8:	0323f423          	.insn	4, 0x0323f423
     2bc:	017e                	.insn	2, 0x017e
     2be:	049f 23f8 24a0      	.insn	6, 0x24a023f8049f
     2c4:	9f027e03          	.insn	4, 0x9f027e03
     2c8:	a004                	.insn	2, 0xa004
     2ca:	b024                	.insn	2, 0xb024
     2cc:	0324                	.insn	2, 0x0324
     2ce:	028a                	.insn	2, 0x028a
     2d0:	049f 24d4 24dc      	.insn	6, 0x24dc24d4049f
     2d6:	9f017c03          	.insn	4, 0x9f017c03
     2da:	dc04                	.insn	2, 0xdc04
     2dc:	e024                	.insn	2, 0xe024
     2de:	0324                	.insn	2, 0x0324
     2e0:	017e                	.insn	2, 0x017e
     2e2:	049f 24e0 24e8      	.insn	6, 0x24e824e0049f
     2e8:	6a01                	.insn	2, 0x6a01
     2ea:	a404                	.insn	2, 0xa404
     2ec:	a825                	.insn	2, 0xa825
     2ee:	0125                	.insn	2, 0x0125
     2f0:	045f 26ac 26b4      	.insn	6, 0x26b426ac045f
     2f6:	9f017e03          	.insn	4, 0x9f017e03
     2fa:	b404                	.insn	2, 0xb404
     2fc:	b826                	.insn	2, 0xb826
     2fe:	0326                	.insn	2, 0x0326
     300:	018a                	.insn	2, 0x018a
     302:	049f 26c8 26d0      	.insn	6, 0x26d026c8049f
     308:	9f018a03          	lb	s4,-1552(gp) # 800031f0 <__BSS_END__+0x150>
     30c:	d004                	.insn	2, 0xd004
     30e:	ec26                	.insn	2, 0xec26
     310:	0326                	.insn	2, 0x0326
     312:	017e                	.insn	2, 0x017e
     314:	049f 26ec 26f4      	.insn	6, 0x26f426ec049f
     31a:	5e01                	.insn	2, 0x5e01
     31c:	8c04                	.insn	2, 0x8c04
     31e:	902a                	.insn	2, 0x902a
     320:	012a                	.insn	2, 0x012a
     322:	045f 2a90 2ab0      	.insn	6, 0x2ab02a90045f
     328:	5d01                	.insn	2, 0x5d01
     32a:	e004                	.insn	2, 0xe004
     32c:	942c                	.insn	2, 0x942c
     32e:	012d                	.insn	2, 0x012d
     330:	005c                	.insn	2, 0x005c
     332:	f004                	.insn	2, 0xf004
     334:	e020                	.insn	2, 0xe020
     336:	0121                	.insn	2, 0x0121
     338:	045e                	.insn	2, 0x045e
     33a:	21e0                	.insn	2, 0x21e0
     33c:	25f8                	.insn	2, 0x25f8
     33e:	6901                	.insn	2, 0x6901
     340:	8804                	.insn	2, 0x8804
     342:	8c26                	.insn	2, 0x8c26
     344:	0128                	.insn	2, 0x0128
     346:	0469                	.insn	2, 0x0469
     348:	288c                	.insn	2, 0x288c
     34a:	2890                	.insn	2, 0x2890
     34c:	9f798903          	lb	s2,-1545(s3) # 8a981bfd <__global_pointer$+0xa97e3fd>
     350:	b804                	.insn	2, 0xb804
     352:	cc28                	.insn	2, 0xcc28
     354:	0128                	.insn	2, 0x0128
     356:	0469                	.insn	2, 0x0469
     358:	28cc                	.insn	2, 0x28cc
     35a:	28d0                	.insn	2, 0x28d0
     35c:	9f798903          	lb	s2,-1545(s3)
     360:	f804                	.insn	2, 0xf804
     362:	b028                	.insn	2, 0xb028
     364:	0129                	.insn	2, 0x0129
     366:	0469                	.insn	2, 0x0469
     368:	29b0                	.insn	2, 0x29b0
     36a:	5f0129c3          	.insn	4, 0x5f0129c3
     36e:	c304                	.insn	2, 0xc304
     370:	c429                	.insn	2, 0xc429
     372:	0329                	.insn	2, 0x0329
     374:	b091                	.insn	2, 0xb091
     376:	047f 29f4 2a90 6901 	.insn	10, 0x900469012a9029f4047f
     37e:	9004 
     380:	b02a                	.insn	2, 0xb02a
     382:	012a                	.insn	2, 0x012a
     384:	045e                	.insn	2, 0x045e
     386:	2ab0                	.insn	2, 0x2ab0
     388:	2ab8                	.insn	2, 0x2ab8
     38a:	6901                	.insn	2, 0x6901
     38c:	b804                	.insn	2, 0xb804
     38e:	d42a                	.insn	2, 0xd42a
     390:	012a                	.insn	2, 0x012a
     392:	045f 2ad4 2be4      	.insn	6, 0x2be42ad4045f
     398:	7fb89103          	lh	sp,2043(a7)
     39c:	e404                	.insn	2, 0xe404
     39e:	012ca82b          	.insn	4, 0x012ca82b
     3a2:	0469                	.insn	2, 0x0469
     3a4:	2ca8                	.insn	2, 0x2ca8
     3a6:	2cdc                	.insn	2, 0x2cdc
     3a8:	6801                	.insn	2, 0x6801
     3aa:	dc04                	.insn	2, 0xdc04
     3ac:	942c                	.insn	2, 0x942c
     3ae:	012d                	.insn	2, 0x012d
     3b0:	0469                	.insn	2, 0x0469
     3b2:	2d94                	.insn	2, 0x2d94
     3b4:	2dac                	.insn	2, 0x2dac
     3b6:	9f048903          	lb	s2,-1552(s1) # 8e39f0 <main-0x7f71c610>
     3ba:	ac04                	.insn	2, 0xac04
     3bc:	b82d                	.insn	2, 0xb82d
     3be:	012d                	.insn	2, 0x012d
     3c0:	0469                	.insn	2, 0x0469
     3c2:	2db8                	.insn	2, 0x2db8
     3c4:	2df8                	.insn	2, 0x2df8
     3c6:	7fb89103          	lh	sp,2043(a7)
     3ca:	f804                	.insn	2, 0xf804
     3cc:	902d                	.insn	2, 0x902d
     3ce:	012e                	.insn	2, 0x012e
     3d0:	0469                	.insn	2, 0x0469
     3d2:	2e90                	.insn	2, 0x2e90
     3d4:	2ec8                	.insn	2, 0x2ec8
     3d6:	7fb89103          	lh	sp,2043(a7)
     3da:	c804                	.insn	2, 0xc804
     3dc:	f82e                	.insn	2, 0xf82e
     3de:	012e                	.insn	2, 0x012e
     3e0:	0469                	.insn	2, 0x0469
     3e2:	2ef8                	.insn	2, 0x2ef8
     3e4:	2f88                	.insn	2, 0x2f88
     3e6:	6801                	.insn	2, 0x6801
     3e8:	b004                	.insn	2, 0xb004
     3ea:	0130b02f          	.insn	4, 0x0130b02f
     3ee:	0469                	.insn	2, 0x0469
     3f0:	30b0                	.insn	2, 0x30b0
     3f2:	30cc                	.insn	2, 0x30cc
     3f4:	9f048903          	lb	s2,-1552(s1)
     3f8:	cc04                	.insn	2, 0xcc04
     3fa:	d030                	.insn	2, 0xd030
     3fc:	0330                	.insn	2, 0x0330
     3fe:	b091                	.insn	2, 0xb091
     400:	047f 30d0 30f0 6901 	.insn	10, 0xf004690130f030d0047f
     408:	f004 
     40a:	9030                	.insn	2, 0x9030
     40c:	0331                	.insn	2, 0x0331
     40e:	0489                	.insn	2, 0x0489
     410:	049f 3190 3280      	.insn	6, 0x32803190049f
     416:	7fb89103          	lh	sp,2043(a7)
     41a:	8004                	.insn	2, 0x8004
     41c:	8c32                	.insn	2, 0x8c32
     41e:	0132                	.insn	2, 0x0132
     420:	0469                	.insn	2, 0x0469
     422:	328c                	.insn	2, 0x328c
     424:	32a0                	.insn	2, 0x32a0
     426:	9f048903          	lb	s2,-1552(s1)
     42a:	ac04                	.insn	2, 0xac04
     42c:	d032                	.insn	2, 0xd032
     42e:	0332                	.insn	2, 0x0332
     430:	b891                	.insn	2, 0xb891
     432:	047f 32d0 32fc 8903 	.insn	10, 0x9f04890332fc32d0047f
     43a:	9f04 
     43c:	fc04                	.insn	2, 0xfc04
     43e:	8432                	.insn	2, 0x8432
     440:	04690133          	.insn	4, 0x04690133
     444:	3384                	.insn	2, 0x3384
     446:	33a8                	.insn	2, 0x33a8
     448:	9f048903          	lb	s2,-1552(s1)
     44c:	a804                	.insn	2, 0xa804
     44e:	0333d833          	divu	a6,t2,s3
     452:	b891                	.insn	2, 0xb891
     454:	007f 8804 fc22 0122 	.insn	10, 0x045d0122fc228804007f
     45c:	045d 
     45e:	22fc                	.insn	2, 0x22fc
     460:	23b8                	.insn	2, 0x23b8
     462:	5b01                	.insn	2, 0x5b01
     464:	b804                	.insn	2, 0xb804
     466:	0124bc23          	.insn	4, 0x0124bc23
     46a:	045d                	.insn	2, 0x045d
     46c:	24c8                	.insn	2, 0x24c8
     46e:	24f4                	.insn	2, 0x24f4
     470:	5d01                	.insn	2, 0x5d01
     472:	f404                	.insn	2, 0xf404
     474:	a824                	.insn	2, 0xa824
     476:	0125                	.insn	2, 0x0125
     478:	2688045b          	.insn	4, 0x2688045b
     47c:	2698                	.insn	2, 0x2698
     47e:	5d01                	.insn	2, 0x5d01
     480:	9804                	.insn	2, 0x9804
     482:	9c26                	.insn	2, 0x9c26
     484:	0126                	.insn	2, 0x0126
     486:	269c045b          	.insn	4, 0x269c045b
     48a:	26e0                	.insn	2, 0x26e0
     48c:	5d01                	.insn	2, 0x5d01
     48e:	e004                	.insn	2, 0xe004
     490:	ec26                	.insn	2, 0xec26
     492:	0126                	.insn	2, 0x0126
     494:	26ec045b          	.insn	4, 0x26ec045b
     498:	26f4                	.insn	2, 0x26f4
     49a:	5d01                	.insn	2, 0x5d01
     49c:	b004                	.insn	2, 0xb004
     49e:	0627b827          	fsd	ft2,112(a5)
     4a2:	2108007b          	.insn	4, 0x2108007b
     4a6:	9f21                	.insn	2, 0x9f21
     4a8:	b804                	.insn	2, 0xb804
     4aa:	0127dc27          	.insn	4, 0x0127dc27
     4ae:	27dc045b          	.insn	4, 0x27dc045b
     4b2:	910327e3          	.insn	4, 0x910327e3
     4b6:	7f94                	.insn	2, 0x7f94
     4b8:	f004                	.insn	2, 0xf004
     4ba:	0128ac27          	fsw	fs2,24(a7)
     4be:	28ac045b          	.insn	4, 0x28ac045b
     4c2:	720228b3          	.insn	4, 0x720228b3
     4c6:	0400                	.insn	2, 0x0400
     4c8:	28c0                	.insn	2, 0x28c0
     4ca:	28ec                	.insn	2, 0x28ec
     4cc:	5b01                	.insn	2, 0x5b01
     4ce:	ec04                	.insn	2, 0xec04
     4d0:	f328                	.insn	2, 0xf328
     4d2:	0228                	.insn	2, 0x0228
     4d4:	0072                	.insn	2, 0x0072
     4d6:	8004                	.insn	2, 0x8004
     4d8:	8c29                	.insn	2, 0x8c29
     4da:	0129                	.insn	2, 0x0129
     4dc:	299c045b          	.insn	4, 0x299c045b
     4e0:	29a4                	.insn	2, 0x29a4
     4e2:	5b01                	.insn	2, 0x5b01
     4e4:	f404                	.insn	2, 0xf404
     4e6:	fc29                	.insn	2, 0xfc29
     4e8:	0629                	.insn	2, 0x0629
     4ea:	007d                	.insn	2, 0x007d
     4ec:	8008                	.insn	2, 0x8008
     4ee:	9f21                	.insn	2, 0x9f21
     4f0:	fc04                	.insn	2, 0xfc04
     4f2:	9029                	.insn	2, 0x9029
     4f4:	012a                	.insn	2, 0x012a
     4f6:	2bf8045b          	.insn	4, 0x2bf8045b
     4fa:	2c84                	.insn	2, 0x2c84
     4fc:	5d01                	.insn	2, 0x5d01
     4fe:	dc04                	.insn	2, 0xdc04
     500:	b82c                	.insn	2, 0xb82c
     502:	012d                	.insn	2, 0x012d
     504:	045d                	.insn	2, 0x045d
     506:	2df8                	.insn	2, 0x2df8
     508:	2e8c                	.insn	2, 0x2e8c
     50a:	5b01                	.insn	2, 0x5b01
     50c:	cc04                	.insn	2, 0xcc04
     50e:	d42e                	.insn	2, 0xd42e
     510:	062e                	.insn	2, 0x062e
     512:	f309007b          	.insn	4, 0xf309007b
     516:	9f1a                	.insn	2, 0x9f1a
     518:	d404                	.insn	2, 0xd404
     51a:	dc2e                	.insn	2, 0xdc2e
     51c:	012e                	.insn	2, 0x012e
     51e:	045f 2fb0 2fc4      	.insn	6, 0x2fc42fb0045f
     524:	5b01                	.insn	2, 0x5b01
     526:	c404                	.insn	2, 0xc404
     528:	062fd42f          	.insn	4, 0x062fd42f
     52c:	ef09007b          	.insn	4, 0xef09007b
     530:	9f1a                	.insn	2, 0x9f1a
     532:	d404                	.insn	2, 0xd404
     534:	012fd82f          	.insn	4, 0x012fd82f
     538:	045d                	.insn	2, 0x045d
     53a:	2fd8                	.insn	2, 0x2fd8
     53c:	2fe8                	.insn	2, 0x2fe8
     53e:	5b01                	.insn	2, 0x5b01
     540:	f004                	.insn	2, 0xf004
     542:	012ff82f          	.insn	4, 0x012ff82f
     546:	30e0045b          	.insn	4, 0x30e0045b
     54a:	30e8                	.insn	2, 0x30e8
     54c:	5b01                	.insn	2, 0x5b01
     54e:	e804                	.insn	2, 0xe804
     550:	f030                	.insn	2, 0xf030
     552:	0130                	.insn	2, 0x0130
     554:	045d                	.insn	2, 0x045d
     556:	3280                	.insn	2, 0x3280
     558:	3288                	.insn	2, 0x3288
     55a:	5d01                	.insn	2, 0x5d01
     55c:	8804                	.insn	2, 0x8804
     55e:	8c32                	.insn	2, 0x8c32
     560:	0132                	.insn	2, 0x0132
     562:	b004005b          	.insn	4, 0xb004005b
     566:	c822                	.insn	2, 0xc822
     568:	0222                	.insn	2, 0x0222
     56a:	9f30                	.insn	2, 0x9f30
     56c:	c804                	.insn	2, 0xc804
     56e:	b822                	.insn	2, 0xb822
     570:	04670123          	sb	t1,66(a4)
     574:	23f4                	.insn	2, 0x23f4
     576:	24a4                	.insn	2, 0x24a4
     578:	3002                	.insn	2, 0x3002
     57a:	049f 24a4 25a8      	.insn	6, 0x25a824a4049f
     580:	6701                	.insn	2, 0x6701
     582:	8804                	.insn	2, 0x8804
     584:	9c26                	.insn	2, 0x9c26
     586:	0126                	.insn	2, 0x0126
     588:	269c0467          	jalr	s0,617(s8) # a37d269 <main-0x75c82d97>
     58c:	26a8                	.insn	2, 0x26a8
     58e:	3002                	.insn	2, 0x3002
     590:	049f 26a8 26b8      	.insn	6, 0x26b826a8049f
     596:	6701                	.insn	2, 0x6701
     598:	b804                	.insn	2, 0xb804
     59a:	c826                	.insn	2, 0xc826
     59c:	0226                	.insn	2, 0x0226
     59e:	9f30                	.insn	2, 0x9f30
     5a0:	c804                	.insn	2, 0xc804
     5a2:	b026                	.insn	2, 0xb026
     5a4:	04670127          	.insn	4, 0x04670127
     5a8:	27b0                	.insn	2, 0x27b0
     5aa:	27f0                	.insn	2, 0x27f0
     5ac:	3802                	.insn	2, 0x3802
     5ae:	049f 27f0 2a90      	.insn	6, 0x2a9027f0049f
     5b4:	6701                	.insn	2, 0x6701
     5b6:	b004                	.insn	2, 0xb004
     5b8:	d82a                	.insn	2, 0xd82a
     5ba:	00670133          	add	sp,a4,t1
     5be:	c804                	.insn	2, 0xc804
     5c0:	d422                	.insn	2, 0xd422
     5c2:	0222                	.insn	2, 0x0222
     5c4:	9f30                	.insn	2, 0x9f30
     5c6:	a404                	.insn	2, 0xa404
     5c8:	e824                	.insn	2, 0xe824
     5ca:	0224                	.insn	2, 0x0224
     5cc:	9f30                	.insn	2, 0x9f30
     5ce:	dc04                	.insn	2, 0xdc04
     5d0:	b02c                	.insn	2, 0xb02c
     5d2:	022d                	.insn	2, 0x022d
     5d4:	9f30                	.insn	2, 0x9f30
     5d6:	b004                	.insn	2, 0xb004
     5d8:	b82d                	.insn	2, 0xb82d
     5da:	022d                	.insn	2, 0x022d
     5dc:	7c89                	.insn	2, 0x7c89
     5de:	0400                	.insn	2, 0x0400
     5e0:	22b0                	.insn	2, 0x22b0
     5e2:	23b8                	.insn	2, 0x23b8
     5e4:	3002                	.insn	2, 0x3002
     5e6:	049f 23bc 23c4      	.insn	6, 0x23c423bc049f
     5ec:	3102                	.insn	2, 0x3102
     5ee:	049f 23c8 23d0      	.insn	6, 0x23d023c8049f
     5f4:	3102                	.insn	2, 0x3102
     5f6:	049f 23d4 23dc      	.insn	6, 0x23dc23d4049f
     5fc:	3102                	.insn	2, 0x3102
     5fe:	049f 23e0 23e8      	.insn	6, 0x23e823e0049f
     604:	3102                	.insn	2, 0x3102
     606:	049f 23ec 23f4      	.insn	6, 0x23f423ec049f
     60c:	3102                	.insn	2, 0x3102
     60e:	049f 23f4 25a8      	.insn	6, 0x25a823f4049f
     614:	3002                	.insn	2, 0x3002
     616:	049f 2688 2a90      	.insn	6, 0x2a902688049f
     61c:	3002                	.insn	2, 0x3002
     61e:	049f 2ab0 33d8      	.insn	6, 0x33d82ab0049f
     624:	3002                	.insn	2, 0x3002
     626:	009f 9c04 e021      	.insn	6, 0xe0219c04009f
     62c:	0221                	.insn	2, 0x0221
     62e:	9f30                	.insn	2, 0x9f30
     630:	e004                	.insn	2, 0xe004
     632:	c421                	.insn	2, 0xc421
     634:	0125                	.insn	2, 0x0125
     636:	2688046b          	.insn	4, 0x2688046b
     63a:	27ec                	.insn	2, 0x27ec
     63c:	6b01                	.insn	2, 0x6b01
     63e:	ec04                	.insn	2, 0xec04
     640:	0127f027          	.insn	4, 0x0127f027
     644:	045a                	.insn	2, 0x045a
     646:	27f0                	.insn	2, 0x27f0
     648:	28bc                	.insn	2, 0x28bc
     64a:	6b01                	.insn	2, 0x6b01
     64c:	bc04                	.insn	2, 0xbc04
     64e:	c028                	.insn	2, 0xc028
     650:	0128                	.insn	2, 0x0128
     652:	045a                	.insn	2, 0x045a
     654:	28c0                	.insn	2, 0x28c0
     656:	28fc                	.insn	2, 0x28fc
     658:	6b01                	.insn	2, 0x6b01
     65a:	fc04                	.insn	2, 0xfc04
     65c:	8028                	.insn	2, 0x8028
     65e:	0129                	.insn	2, 0x0129
     660:	045a                	.insn	2, 0x045a
     662:	2980                	.insn	2, 0x2980
     664:	29b0                	.insn	2, 0x29b0
     666:	6b01                	.insn	2, 0x6b01
     668:	b004                	.insn	2, 0xb004
     66a:	c429                	.insn	2, 0xc429
     66c:	0129                	.insn	2, 0x0129
     66e:	0468                	.insn	2, 0x0468
     670:	29d0                	.insn	2, 0x29d0
     672:	29ec                	.insn	2, 0x29ec
     674:	6801                	.insn	2, 0x6801
     676:	ec04                	.insn	2, 0xec04
     678:	9029                	.insn	2, 0x9029
     67a:	012a                	.insn	2, 0x012a
     67c:	2a90046b          	.insn	4, 0x2a90046b
     680:	2ab0                	.insn	2, 0x2ab0
     682:	3002                	.insn	2, 0x3002
     684:	049f 2ab0 2b8c      	.insn	6, 0x2b8c2ab0049f
     68a:	6b01                	.insn	2, 0x6b01
     68c:	a004                	.insn	2, 0xa004
     68e:	012bac2b          	.insn	4, 0x012bac2b
     692:	045f 2bac 2bb0      	.insn	6, 0x2bb02bac045f
     698:	5c01                	.insn	2, 0x5c01
     69a:	b004                	.insn	2, 0xb004
     69c:	012bbb2b          	.insn	4, 0x012bbb2b
     6a0:	045f 2bbb 2bd4      	.insn	6, 0x2bd42bbb045f
     6a6:	7fac9103          	lh	sp,2042(s9)
     6aa:	dc04                	.insn	2, 0xdc04
     6ac:	012dc02b          	.insn	4, 0x012dc02b
     6b0:	2dd0046b          	.insn	4, 0x2dd0046b
     6b4:	2e90                	.insn	2, 0x2e90
     6b6:	6b01                	.insn	2, 0x6b01
     6b8:	9404                	.insn	2, 0x9404
     6ba:	a42e                	.insn	2, 0xa42e
     6bc:	012e                	.insn	2, 0x012e
     6be:	2ea4046b          	.insn	4, 0x2ea4046b
     6c2:	2ec0                	.insn	2, 0x2ec0
     6c4:	6801                	.insn	2, 0x6801
     6c6:	c004                	.insn	2, 0xc004
     6c8:	942e                	.insn	2, 0x942e
     6ca:	046b012f          	.insn	4, 0x046b012f
     6ce:	2f94                	.insn	2, 0x2f94
     6d0:	5c012fa3          	sw	zero,1503(sp)
     6d4:	a304                	.insn	2, 0xa304
     6d6:	012fac2f          	amoadd.w	s8,s2,(t6)
     6da:	2fac046b          	.insn	4, 0x2fac046b
     6de:	2fb0                	.insn	2, 0x2fb0
     6e0:	5a01                	.insn	2, 0x5a01
     6e2:	b004                	.insn	2, 0xb004
     6e4:	0130902f          	.insn	4, 0x0130902f
     6e8:	3090046b          	.insn	4, 0x3090046b
     6ec:	30c8                	.insn	2, 0x30c8
     6ee:	6801                	.insn	2, 0x6801
     6f0:	c804                	.insn	2, 0xc804
     6f2:	ec30                	.insn	2, 0xec30
     6f4:	0131                	.insn	2, 0x0131
     6f6:	31ec046b          	.insn	4, 0x31ec046b
     6fa:	3280                	.insn	2, 0x3280
     6fc:	6901                	.insn	2, 0x6901
     6fe:	8004                	.insn	2, 0x8004
     700:	8c32                	.insn	2, 0x8c32
     702:	0132                	.insn	2, 0x0132
     704:	328c046b          	.insn	4, 0x328c046b
     708:	32a0                	.insn	2, 0x32a0
     70a:	9f018b03          	lb	s6,-1552(gp) # 800031f0 <__BSS_END__+0x150>
     70e:	a804                	.insn	2, 0xa804
     710:	d032                	.insn	2, 0xd032
     712:	046b0133          	.insn	4, 0x046b0133
     716:	33d0                	.insn	2, 0x33d0
     718:	33d4                	.insn	2, 0x33d4
     71a:	6901                	.insn	2, 0x6901
     71c:	d404                	.insn	2, 0xd404
     71e:	0133d833          	srl	a6,t2,s3
     722:	8804006b          	.insn	4, 0x8804006b
     726:	a425                	.insn	2, 0xa425
     728:	0125                	.insn	2, 0x0125
     72a:	005f 8c04 9025      	.insn	6, 0x90258c04005f
     730:	0125                	.insn	2, 0x0125
     732:	005e                	.insn	2, 0x005e
     734:	f004                	.insn	2, 0xf004
     736:	022c842b          	.insn	4, 0x022c842b
     73a:	9f3a                	.insn	2, 0x9f3a
     73c:	dc04                	.insn	2, 0xdc04
     73e:	f030                	.insn	2, 0xf030
     740:	0230                	.insn	2, 0x0230
     742:	9f3a                	.insn	2, 0x9f3a
     744:	8004                	.insn	2, 0x8004
     746:	8c32                	.insn	2, 0x8c32
     748:	0232                	.insn	2, 0x0232
     74a:	9f3a                	.insn	2, 0x9f3a
     74c:	0400                	.insn	2, 0x0400
     74e:	2cc0                	.insn	2, 0x2cc0
     750:	2cd0                	.insn	2, 0x2cd0
     752:	5f01                	.insn	2, 0x5f01
     754:	0400                	.insn	2, 0x0400
     756:	2efc                	.insn	2, 0x2efc
     758:	2f88                	.insn	2, 0x2f88
     75a:	5e01                	.insn	2, 0x5e01
     75c:	0400                	.insn	2, 0x0400
     75e:	299c                	.insn	2, 0x299c
     760:	29c4                	.insn	2, 0x29c4
     762:	3102                	.insn	2, 0x3102
     764:	049f 29c4 29d0      	.insn	6, 0x29d029c4049f
     76a:	3202                	.insn	2, 0x3202
     76c:	049f 29d0 29dc      	.insn	6, 0x29dc29d0049f
     772:	8808                	.insn	2, 0x8808
     774:	8b00                	.insn	2, 0x8b00
     776:	1c00                	.insn	2, 0x1c00
     778:	049f0123          	sb	s1,66(t5) # 137c042 <main-0x7ec83fbe>
     77c:	29dc                	.insn	2, 0x29dc
     77e:	7c0829e7          	.insn	4, 0x7c0829e7
     782:	8b00                	.insn	2, 0x8b00
     784:	1c00                	.insn	2, 0x1c00
     786:	049f0123          	sb	s1,66(t5)
     78a:	29e829e7          	.insn	4, 0x29e829e7
     78e:	8806                	.insn	2, 0x8806
     790:	8b00                	.insn	2, 0x8b00
     792:	1c00                	.insn	2, 0x1c00
     794:	049f 29e8 29f4      	.insn	6, 0x29f429e8049f
     79a:	8808                	.insn	2, 0x8808
     79c:	8b00                	.insn	2, 0x8b00
     79e:	1c00                	.insn	2, 0x1c00
     7a0:	049f0123          	sb	s1,66(t5)
     7a4:	2ff8                	.insn	2, 0x2ff8
     7a6:	3090                	.insn	2, 0x3090
     7a8:	3202                	.insn	2, 0x3202
     7aa:	049f 3090 30c8      	.insn	6, 0x30c83090049f
     7b0:	8808                	.insn	2, 0x8808
     7b2:	8b00                	.insn	2, 0x8b00
     7b4:	1c00                	.insn	2, 0x1c00
     7b6:	049f0223          	sb	s1,68(t5)
     7ba:	328c                	.insn	2, 0x328c
     7bc:	32ac                	.insn	2, 0x32ac
     7be:	3202                	.insn	2, 0x3202
     7c0:	009f a004 a42b      	.insn	6, 0xa42ba004009f
     7c6:	0088092b          	.insn	4, 0x0088092b
     7ca:	0089                	.insn	2, 0x0089
     7cc:	7f1c                	.insn	2, 0x7f1c
     7ce:	2200                	.insn	2, 0x2200
     7d0:	049f 2ba4 2bac      	.insn	6, 0x2bac2ba4049f
     7d6:	7f00880b          	.insn	4, 0x7f00880b
     7da:	2200                	.insn	2, 0x2200
     7dc:	0089                	.insn	2, 0x0089
     7de:	231c                	.insn	2, 0x231c
     7e0:	9f01                	.insn	2, 0x9f01
     7e2:	ac04                	.insn	2, 0xac04
     7e4:	0b2bbb2b          	.insn	4, 0x0b2bbb2b
     7e8:	0088                	.insn	2, 0x0088
     7ea:	007c                	.insn	2, 0x007c
     7ec:	8922                	.insn	2, 0x8922
     7ee:	1c00                	.insn	2, 0x1c00
     7f0:	049f0123          	sb	s1,66(t5)
     7f4:	2bd42bbb          	.insn	4, 0x2bd42bbb
     7f8:	8900880b          	.insn	4, 0x8900880b
     7fc:	1c00                	.insn	2, 0x1c00
     7fe:	ac91                	.insn	2, 0xac91
     800:	067f 9f22 d004 e42d 	.insn	10, 0x0b2de42dd0049f22067f
     808:	0b2d 
     80a:	0088                	.insn	2, 0x0088
     80c:	0089                	.insn	2, 0x0089
     80e:	8b1c                	.insn	2, 0x8b1c
     810:	2200                	.insn	2, 0x2200
     812:	049f0123          	sb	s1,66(t5)
     816:	2de4                	.insn	2, 0x2de4
     818:	2df8                	.insn	2, 0x2df8
     81a:	8809                	.insn	2, 0x8809
     81c:	8900                	.insn	2, 0x8900
     81e:	1c00                	.insn	2, 0x1c00
     820:	9f22008b          	.insn	4, 0x9f22008b
     824:	ec04                	.insn	2, 0xec04
     826:	8031                	.insn	2, 0x8031
     828:	0132                	.insn	2, 0x0132
     82a:	0468                	.insn	2, 0x0468
     82c:	32bc                	.insn	2, 0x32bc
     82e:	32d0                	.insn	2, 0x32d0
     830:	6801                	.insn	2, 0x6801
     832:	c004                	.insn	2, 0xc004
     834:	0133d833          	srl	a6,t2,s3
     838:	0068                	.insn	2, 0x0068
     83a:	b804                	.insn	2, 0xb804
     83c:	c02d                	.insn	2, 0xc02d
     83e:	012d                	.insn	2, 0x012d
     840:	045f 319c 31a4      	.insn	6, 0x31a4319c045f
     846:	3002                	.insn	2, 0x3002
     848:	049f 31a4 31a8      	.insn	6, 0x31a831a4049f
     84e:	9f017f03          	.insn	4, 0x9f017f03
     852:	a804                	.insn	2, 0xa804
     854:	b031                	.insn	2, 0xb031
     856:	0731                	.insn	2, 0x0731
     858:	b491                	.insn	2, 0xb491
     85a:	067f 0123 049f 31e0 	.insn	10, 0x31e831e0049f0123067f
     862:	31e8 
     864:	9f028703          	lb	a4,-1552(t0)
     868:	e804                	.insn	2, 0xe804
     86a:	ec31                	.insn	2, 0xec31
     86c:	0331                	.insn	2, 0x0331
     86e:	017f 049f 31ec 31f4 	.insn	10, 0x5f0131f431ec049f017f
     876:	5f01 
     878:	f404                	.insn	2, 0xf404
     87a:	8031                	.insn	2, 0x8031
     87c:	0332                	.insn	2, 0x0332
     87e:	b491                	.insn	2, 0xb491
     880:	047f 32c0 32c4 7f03 	.insn	10, 0x9f027f0332c432c0047f
     888:	9f02 
     88a:	c404                	.insn	2, 0xc404
     88c:	d032                	.insn	2, 0xd032
     88e:	0332                	.insn	2, 0x0332
     890:	017f 049f 33a8 33c0 	.insn	10, 0x300233c033a8049f017f
     898:	3002 
     89a:	049f 33c0 33c8      	.insn	6, 0x33c833c0049f
     8a0:	7fb49107          	.insn	4, 0x7fb49107
     8a4:	2306                	.insn	2, 0x2306
     8a6:	9f01                	.insn	2, 0x9f01
     8a8:	0400                	.insn	2, 0x0400
     8aa:	2ac8                	.insn	2, 0x2ac8
     8ac:	2ad8                	.insn	2, 0x2ad8
     8ae:	6801                	.insn	2, 0x6801
     8b0:	d804                	.insn	2, 0xd804
     8b2:	ec2a                	.insn	2, 0xec2a
     8b4:	012a                	.insn	2, 0x012a
     8b6:	005f f804 9023      	.insn	6, 0x9023f804005f
     8bc:	0124                	.insn	2, 0x0124
     8be:	24940467          	jalr	s0,585(s0) # 137f249 <main-0x7ec80db7>
     8c2:	24a4                	.insn	2, 0x24a4
     8c4:	6701                	.insn	2, 0x6701
     8c6:	0400                	.insn	2, 0x0400
     8c8:	2cf4                	.insn	2, 0x2cf4
     8ca:	2cfc                	.insn	2, 0x2cfc
     8cc:	9f507f03          	.insn	4, 0x9f507f03
     8d0:	fc04                	.insn	2, 0xfc04
     8d2:	942c                	.insn	2, 0x942c
     8d4:	012d                	.insn	2, 0x012d
     8d6:	0060                	.insn	2, 0x0060
     8d8:	d804                	.insn	2, 0xd804
     8da:	bb02                	.insn	2, 0xbb02
     8dc:	045a0107          	.insn	4, 0x045a0107
     8e0:	07dc07bb          	.insn	4, 0x07dc07bb
     8e4:	a30a                	.insn	2, 0xa30a
     8e6:	260aa503          	lw	a0,608(s5)
     8ea:	2da8                	.insn	2, 0x2da8
     8ec:	00a8                	.insn	2, 0x00a8
     8ee:	049f 07dc 0da8      	.insn	6, 0x0da807dc049f
     8f4:	5a01                	.insn	2, 0x5a01
     8f6:	0400                	.insn	2, 0x0400
     8f8:	02d8                	.insn	2, 0x02d8
     8fa:	5b0107bb          	.insn	4, 0x5b0107bb
     8fe:	bb04                	.insn	2, 0xbb04
     900:	0a07dc07          	.insn	4, 0x0a07dc07
     904:	0ba503a3          	sb	s10,167(a0)
     908:	a826                	.insn	2, 0xa826
     90a:	a82d                	.insn	2, 0xa82d
     90c:	9f00                	.insn	2, 0x9f00
     90e:	dc04                	.insn	2, 0xdc04
     910:	010da807          	flw	fa6,16(s11)
     914:	d804005b          	.insn	4, 0xd804005b
     918:	bb02                	.insn	2, 0xbb02
     91a:	045c0107          	.insn	4, 0x045c0107
     91e:	07dc07bb          	.insn	4, 0x07dc07bb
     922:	a30a                	.insn	2, 0xa30a
     924:	260ca503          	lw	a0,608(s9)
     928:	2da8                	.insn	2, 0x2da8
     92a:	00a8                	.insn	2, 0x00a8
     92c:	049f 07dc 0da8      	.insn	6, 0x0da807dc049f
     932:	5c01                	.insn	2, 0x5c01
     934:	0400                	.insn	2, 0x0400
     936:	02d8                	.insn	2, 0x02d8
     938:	5d0107bb          	.insn	4, 0x5d0107bb
     93c:	bb04                	.insn	2, 0xbb04
     93e:	0a07dc07          	.insn	4, 0x0a07dc07
     942:	0da503a3          	sb	s10,199(a0)
     946:	a826                	.insn	2, 0xa826
     948:	a82d                	.insn	2, 0xa82d
     94a:	9f00                	.insn	2, 0x9f00
     94c:	dc04                	.insn	2, 0xdc04
     94e:	010da807          	flw	fa6,16(s11)
     952:	005d                	.insn	2, 0x005d
     954:	d804                	.insn	2, 0xd804
     956:	b802                	.insn	2, 0xb802
     958:	045e0103          	lb	sp,69(t3)
     95c:	03b8                	.insn	2, 0x03b8
     95e:	03c4                	.insn	2, 0x03c4
     960:	6c01                	.insn	2, 0x6c01
     962:	c404                	.insn	2, 0xc404
     964:	0103cc03          	lbu	s8,16(t2)
     968:	0456                	.insn	2, 0x0456
     96a:	03cc                	.insn	2, 0x03cc
     96c:	03f8                	.insn	2, 0x03f8
     96e:	6c01                	.insn	2, 0x6c01
     970:	f804                	.insn	2, 0xf804
     972:	0104a003          	lw	zero,16(s1)
     976:	0456                	.insn	2, 0x0456
     978:	04f4                	.insn	2, 0x04f4
     97a:	05c4                	.insn	2, 0x05c4
     97c:	5e01                	.insn	2, 0x5e01
     97e:	c404                	.insn	2, 0xc404
     980:	d805                	.insn	2, 0xd805
     982:	0105                	.insn	2, 0x0105
     984:	046c                	.insn	2, 0x046c
     986:	05d8                	.insn	2, 0x05d8
     988:	05ec                	.insn	2, 0x05ec
     98a:	5601                	.insn	2, 0x5601
     98c:	c004                	.insn	2, 0xc004
     98e:	d006                	.insn	2, 0xd006
     990:	0106                	.insn	2, 0x0106
     992:	0456                	.insn	2, 0x0456
     994:	078c                	.insn	2, 0x078c
     996:	07b0                	.insn	2, 0x07b0
     998:	5601                	.insn	2, 0x5601
     99a:	dc04                	.insn	2, 0xdc04
     99c:	0107e407          	.insn	4, 0x0107e407
     9a0:	045e                	.insn	2, 0x045e
     9a2:	07e4                	.insn	2, 0x07e4
     9a4:	07e8                	.insn	2, 0x07e8
     9a6:	6c01                	.insn	2, 0x6c01
     9a8:	9404                	.insn	2, 0x9404
     9aa:	9c08                	.insn	2, 0x9c08
     9ac:	0108                	.insn	2, 0x0108
     9ae:	0456                	.insn	2, 0x0456
     9b0:	08d8                	.insn	2, 0x08d8
     9b2:	08e4                	.insn	2, 0x08e4
     9b4:	5601                	.insn	2, 0x5601
     9b6:	d404                	.insn	2, 0xd404
     9b8:	e809                	.insn	2, 0xe809
     9ba:	0109                	.insn	2, 0x0109
     9bc:	045e                	.insn	2, 0x045e
     9be:	09e8                	.insn	2, 0x09e8
     9c0:	09ec                	.insn	2, 0x09ec
     9c2:	6c01                	.insn	2, 0x6c01
     9c4:	ec04                	.insn	2, 0xec04
     9c6:	8809                	.insn	2, 0x8809
     9c8:	010a                	.insn	2, 0x010a
     9ca:	0456                	.insn	2, 0x0456
     9cc:	0abc                	.insn	2, 0x0abc
     9ce:	0ad0                	.insn	2, 0x0ad0
     9d0:	5e01                	.insn	2, 0x5e01
     9d2:	d004                	.insn	2, 0xd004
     9d4:	d40a                	.insn	2, 0xd40a
     9d6:	010a                	.insn	2, 0x010a
     9d8:	046c                	.insn	2, 0x046c
     9da:	0b88                	.insn	2, 0x0b88
     9dc:	0b98                	.insn	2, 0x0b98
     9de:	5601                	.insn	2, 0x5601
     9e0:	d404                	.insn	2, 0xd404
     9e2:	010bdc0b          	.insn	4, 0x010bdc0b
     9e6:	0456                	.insn	2, 0x0456
     9e8:	0bdc                	.insn	2, 0x0bdc
     9ea:	0be0                	.insn	2, 0x0be0
     9ec:	8c0c                	.insn	2, 0x8c0c
     9ee:	a800                	.insn	2, 0xa800
     9f0:	8d2d                	.insn	2, 0x8d2d
     9f2:	a800                	.insn	2, 0xa800
     9f4:	1b2d                	.insn	2, 0x1b2d
     9f6:	00a8                	.insn	2, 0x00a8
     9f8:	049f 0be0 0bf4      	.insn	6, 0x0bf40be0049f
     9fe:	5e01                	.insn	2, 0x5e01
     a00:	f404                	.insn	2, 0xf404
     a02:	010bfc0b          	.insn	4, 0x010bfc0b
     a06:	046c                	.insn	2, 0x046c
     a08:	0ccc                	.insn	2, 0x0ccc
     a0a:	0cd8                	.insn	2, 0x0cd8
     a0c:	5e01                	.insn	2, 0x5e01
     a0e:	d804                	.insn	2, 0xd804
     a10:	e00c                	.insn	2, 0xe00c
     a12:	010c                	.insn	2, 0x010c
     a14:	046c                	.insn	2, 0x046c
     a16:	0d80                	.insn	2, 0x0d80
     a18:	0d84                	.insn	2, 0x0d84
     a1a:	5e01                	.insn	2, 0x5e01
     a1c:	8404                	.insn	2, 0x8404
     a1e:	880d                	.insn	2, 0x880d
     a20:	010d                	.insn	2, 0x010d
     a22:	046c                	.insn	2, 0x046c
     a24:	0d88                	.insn	2, 0x0d88
     a26:	0d94                	.insn	2, 0x0d94
     a28:	5601                	.insn	2, 0x5601
     a2a:	9404                	.insn	2, 0x9404
     a2c:	9c0d                	.insn	2, 0x9c0d
     a2e:	0c0d                	.insn	2, 0x0c0d
     a30:	008c                	.insn	2, 0x008c
     a32:	2da8                	.insn	2, 0x2da8
     a34:	008d                	.insn	2, 0x008d
     a36:	2da8                	.insn	2, 0x2da8
     a38:	9f00a81b          	.insn	4, 0x9f00a81b
     a3c:	0400                	.insn	2, 0x0400
     a3e:	02d8                	.insn	2, 0x02d8
     a40:	0398                	.insn	2, 0x0398
     a42:	5f01                	.insn	2, 0x5f01
     a44:	9804                	.insn	2, 0x9804
     a46:	0104f403          	.insn	4, 0x0104f403
     a4a:	04f40463          	beq	s0,a5,a92 <main-0x7ffff56e>
     a4e:	0584                	.insn	2, 0x0584
     a50:	5f01                	.insn	2, 0x5f01
     a52:	8404                	.insn	2, 0x8404
     a54:	a005                	.insn	2, 0xa005
     a56:	0105                	.insn	2, 0x0105
     a58:	05a00463          	beq	zero,s10,aa0 <main-0x7ffff560>
     a5c:	05a4                	.insn	2, 0x05a4
     a5e:	5f01                	.insn	2, 0x5f01
     a60:	a404                	.insn	2, 0xa404
     a62:	cc05                	.insn	2, 0xcc05
     a64:	04630107          	.insn	4, 0x04630107
     a68:	07cc                	.insn	2, 0x07cc
     a6a:	0da8                	.insn	2, 0x0da8
     a6c:	a30a                	.insn	2, 0xa30a
     a6e:	260fa503          	lw	a0,608(t6)
     a72:	42a8                	.insn	2, 0x42a8
     a74:	00a8                	.insn	2, 0x00a8
     a76:	009f d804 8402      	.insn	6, 0x8402d804009f
     a7c:	04600103          	lb	sp,70(zero) # 46 <main-0x7fffffba>
     a80:	0384                	.insn	2, 0x0384
     a82:	6d0107bb          	.insn	4, 0x6d0107bb
     a86:	bb04                	.insn	2, 0xbb04
     a88:	0a07dc07          	.insn	4, 0x0a07dc07
     a8c:	10a503a3          	sb	a0,263(a0)
     a90:	a826                	.insn	2, 0xa826
     a92:	a82d                	.insn	2, 0xa82d
     a94:	9f00                	.insn	2, 0x9f00
     a96:	dc04                	.insn	2, 0xdc04
     a98:	010da807          	flw	fa6,16(s11)
     a9c:	006d                	.insn	2, 0x006d
     a9e:	d804                	.insn	2, 0xd804
     aa0:	ac02                	.insn	2, 0xac02
     aa2:	04610103          	lb	sp,70(sp)
     aa6:	03ac                	.insn	2, 0x03ac
     aa8:	04f4                	.insn	2, 0x04f4
     aaa:	6201                	.insn	2, 0x6201
     aac:	f404                	.insn	2, 0xf404
     aae:	f804                	.insn	2, 0xf804
     ab0:	0104                	.insn	2, 0x0104
     ab2:	0461                	.insn	2, 0x0461
     ab4:	04f8                	.insn	2, 0x04f8
     ab6:	07c8                	.insn	2, 0x07c8
     ab8:	6201                	.insn	2, 0x6201
     aba:	c804                	.insn	2, 0xc804
     abc:	0a07dc07          	.insn	4, 0x0a07dc07
     ac0:	11a503a3          	sb	s10,263(a0)
     ac4:	a826                	.insn	2, 0xa826
     ac6:	a82d                	.insn	2, 0xa82d
     ac8:	9f00                	.insn	2, 0x9f00
     aca:	dc04                	.insn	2, 0xdc04
     acc:	010da807          	flw	fa6,16(s11)
     ad0:	0062                	.insn	2, 0x0062
     ad2:	d804                	.insn	2, 0xd804
     ad4:	8802                	.insn	2, 0x8802
     ad6:	0204                	.insn	2, 0x0204
     ad8:	0091                	.insn	2, 0x0091
     ada:	8804                	.insn	2, 0x8804
     adc:	9c04                	.insn	2, 0x9c04
     ade:	0104                	.insn	2, 0x0104
     ae0:	0460                	.insn	2, 0x0460
     ae2:	049c                	.insn	2, 0x049c
     ae4:	04dc                	.insn	2, 0x04dc
     ae6:	9102                	.insn	2, 0x9102
     ae8:	0400                	.insn	2, 0x0400
     aea:	04f4                	.insn	2, 0x04f4
     aec:	05bc                	.insn	2, 0x05bc
     aee:	6001                	.insn	2, 0x6001
     af0:	bc04                	.insn	2, 0xbc04
     af2:	d805                	.insn	2, 0xd805
     af4:	0205                	.insn	2, 0x0205
     af6:	0091                	.insn	2, 0x0091
     af8:	d804                	.insn	2, 0xd804
     afa:	f405                	.insn	2, 0xf405
     afc:	0105                	.insn	2, 0x0105
     afe:	0460                	.insn	2, 0x0460
     b00:	05f4                	.insn	2, 0x05f4
     b02:	06c0                	.insn	2, 0x06c0
     b04:	9102                	.insn	2, 0x9102
     b06:	0400                	.insn	2, 0x0400
     b08:	06c0                	.insn	2, 0x06c0
     b0a:	06d0                	.insn	2, 0x06d0
     b0c:	6001                	.insn	2, 0x6001
     b0e:	d004                	.insn	2, 0xd004
     b10:	ec06                	.insn	2, 0xec06
     b12:	0206                	.insn	2, 0x0206
     b14:	0091                	.insn	2, 0x0091
     b16:	8c04                	.insn	2, 0x8c04
     b18:	0107b007          	fld	ft0,16(a5)
     b1c:	0460                	.insn	2, 0x0460
     b1e:	07dc                	.insn	2, 0x07dc
     b20:	07e8                	.insn	2, 0x07e8
     b22:	6001                	.insn	2, 0x6001
     b24:	8404                	.insn	2, 0x8404
     b26:	9408                	.insn	2, 0x9408
     b28:	0208                	.insn	2, 0x0208
     b2a:	0091                	.insn	2, 0x0091
     b2c:	9404                	.insn	2, 0x9404
     b2e:	9c08                	.insn	2, 0x9c08
     b30:	0108                	.insn	2, 0x0108
     b32:	0460                	.insn	2, 0x0460
     b34:	089c                	.insn	2, 0x089c
     b36:	08d8                	.insn	2, 0x08d8
     b38:	9102                	.insn	2, 0x9102
     b3a:	0400                	.insn	2, 0x0400
     b3c:	08d8                	.insn	2, 0x08d8
     b3e:	08e4                	.insn	2, 0x08e4
     b40:	6001                	.insn	2, 0x6001
     b42:	8404                	.insn	2, 0x8404
     b44:	a409                	.insn	2, 0xa409
     b46:	0209                	.insn	2, 0x0209
     b48:	0091                	.insn	2, 0x0091
     b4a:	ac04                	.insn	2, 0xac04
     b4c:	d409                	.insn	2, 0xd409
     b4e:	0209                	.insn	2, 0x0209
     b50:	0091                	.insn	2, 0x0091
     b52:	d404                	.insn	2, 0xd404
     b54:	8809                	.insn	2, 0x8809
     b56:	010a                	.insn	2, 0x010a
     b58:	0460                	.insn	2, 0x0460
     b5a:	0a88                	.insn	2, 0x0a88
     b5c:	0aa4                	.insn	2, 0x0aa4
     b5e:	9102                	.insn	2, 0x9102
     b60:	0400                	.insn	2, 0x0400
     b62:	0aac                	.insn	2, 0x0aac
     b64:	0abc                	.insn	2, 0x0abc
     b66:	9102                	.insn	2, 0x9102
     b68:	0400                	.insn	2, 0x0400
     b6a:	0abc                	.insn	2, 0x0abc
     b6c:	0ac0                	.insn	2, 0x0ac0
     b6e:	6001                	.insn	2, 0x6001
     b70:	c004                	.insn	2, 0xc004
     b72:	880a                	.insn	2, 0x880a
     b74:	0091020b          	.insn	4, 0x0091020b
     b78:	8804                	.insn	2, 0x8804
     b7a:	010b980b          	.insn	4, 0x010b980b
     b7e:	0460                	.insn	2, 0x0460
     b80:	0b98                	.insn	2, 0x0b98
     b82:	0bd4                	.insn	2, 0x0bd4
     b84:	9102                	.insn	2, 0x9102
     b86:	0400                	.insn	2, 0x0400
     b88:	0bd4                	.insn	2, 0x0bd4
     b8a:	0bfc                	.insn	2, 0x0bfc
     b8c:	6001                	.insn	2, 0x6001
     b8e:	fc04                	.insn	2, 0xfc04
     b90:	020ccc0b          	.insn	4, 0x020ccc0b
     b94:	0091                	.insn	2, 0x0091
     b96:	cc04                	.insn	2, 0xcc04
     b98:	dc0c                	.insn	2, 0xdc0c
     b9a:	010c                	.insn	2, 0x010c
     b9c:	0460                	.insn	2, 0x0460
     b9e:	0cdc                	.insn	2, 0x0cdc
     ba0:	0d80                	.insn	2, 0x0d80
     ba2:	9102                	.insn	2, 0x9102
     ba4:	0400                	.insn	2, 0x0400
     ba6:	0d80                	.insn	2, 0x0d80
     ba8:	0d90                	.insn	2, 0x0d90
     baa:	6001                	.insn	2, 0x6001
     bac:	9004                	.insn	2, 0x9004
     bae:	a80d                	.insn	2, 0xa80d
     bb0:	020d                	.insn	2, 0x020d
     bb2:	0091                	.insn	2, 0x0091
     bb4:	0400                	.insn	2, 0x0400
     bb6:	02d8                	.insn	2, 0x02d8
     bb8:	03ac                	.insn	2, 0x03ac
     bba:	9102                	.insn	2, 0x9102
     bbc:	0404                	.insn	2, 0x0404
     bbe:	03ac                	.insn	2, 0x03ac
     bc0:	04dc                	.insn	2, 0x04dc
     bc2:	5901                	.insn	2, 0x5901
     bc4:	dc04                	.insn	2, 0xdc04
     bc6:	f404                	.insn	2, 0xf404
     bc8:	0104                	.insn	2, 0x0104
     bca:	0461                	.insn	2, 0x0461
     bcc:	04f4                	.insn	2, 0x04f4
     bce:	04f8                	.insn	2, 0x04f8
     bd0:	5901                	.insn	2, 0x5901
     bd2:	f804                	.insn	2, 0xf804
     bd4:	9804                	.insn	2, 0x9804
     bd6:	0105                	.insn	2, 0x0105
     bd8:	0461                	.insn	2, 0x0461
     bda:	0598                	.insn	2, 0x0598
     bdc:	05a0                	.insn	2, 0x05a0
     bde:	5901                	.insn	2, 0x5901
     be0:	a004                	.insn	2, 0xa004
     be2:	d805                	.insn	2, 0xd805
     be4:	0105                	.insn	2, 0x0105
     be6:	0461                	.insn	2, 0x0461
     be8:	05d8                	.insn	2, 0x05d8
     bea:	06ec                	.insn	2, 0x06ec
     bec:	5901                	.insn	2, 0x5901
     bee:	ec04                	.insn	2, 0xec04
     bf0:	8c06                	.insn	2, 0x8c06
     bf2:	04610107          	.insn	4, 0x04610107
     bf6:	078c                	.insn	2, 0x078c
     bf8:	07b0                	.insn	2, 0x07b0
     bfa:	5901                	.insn	2, 0x5901
     bfc:	b004                	.insn	2, 0xb004
     bfe:	0107bb07          	fld	fs6,16(a5)
     c02:	0461                	.insn	2, 0x0461
     c04:	07dc                	.insn	2, 0x07dc
     c06:	0884                	.insn	2, 0x0884
     c08:	6101                	.insn	2, 0x6101
     c0a:	8404                	.insn	2, 0x8404
     c0c:	e408                	.insn	2, 0xe408
     c0e:	0108                	.insn	2, 0x0108
     c10:	0459                	.insn	2, 0x0459
     c12:	08e4                	.insn	2, 0x08e4
     c14:	0984                	.insn	2, 0x0984
     c16:	6101                	.insn	2, 0x6101
     c18:	8404                	.insn	2, 0x8404
     c1a:	8809                	.insn	2, 0x8809
     c1c:	0109                	.insn	2, 0x0109
     c1e:	0459                	.insn	2, 0x0459
     c20:	0988                	.insn	2, 0x0988
     c22:	09ac                	.insn	2, 0x09ac
     c24:	6101                	.insn	2, 0x6101
     c26:	ac04                	.insn	2, 0xac04
     c28:	d409                	.insn	2, 0xd409
     c2a:	0109                	.insn	2, 0x0109
     c2c:	0459                	.insn	2, 0x0459
     c2e:	09d4                	.insn	2, 0x09d4
     c30:	09ec                	.insn	2, 0x09ec
     c32:	6101                	.insn	2, 0x6101
     c34:	ec04                	.insn	2, 0xec04
     c36:	9409                	.insn	2, 0x9409
     c38:	010a                	.insn	2, 0x010a
     c3a:	0459                	.insn	2, 0x0459
     c3c:	0a94                	.insn	2, 0x0a94
     c3e:	0aac                	.insn	2, 0x0aac
     c40:	6101                	.insn	2, 0x6101
     c42:	ac04                	.insn	2, 0xac04
     c44:	bc0a                	.insn	2, 0xbc0a
     c46:	010a                	.insn	2, 0x010a
     c48:	0459                	.insn	2, 0x0459
     c4a:	0abc                	.insn	2, 0x0abc
     c4c:	0ad4                	.insn	2, 0x0ad4
     c4e:	6101                	.insn	2, 0x6101
     c50:	d404                	.insn	2, 0xd404
     c52:	e00a                	.insn	2, 0xe00a
     c54:	0459010b          	.insn	4, 0x0459010b
     c58:	0be0                	.insn	2, 0x0be0
     c5a:	0bec                	.insn	2, 0x0bec
     c5c:	6101                	.insn	2, 0x6101
     c5e:	ec04                	.insn	2, 0xec04
     c60:	010d800b          	.insn	4, 0x010d800b
     c64:	0459                	.insn	2, 0x0459
     c66:	0d80                	.insn	2, 0x0d80
     c68:	0d88                	.insn	2, 0x0d88
     c6a:	6101                	.insn	2, 0x6101
     c6c:	8804                	.insn	2, 0x8804
     c6e:	a80d                	.insn	2, 0xa80d
     c70:	010d                	.insn	2, 0x010d
     c72:	0059                	.insn	2, 0x0059
     c74:	d804                	.insn	2, 0xd804
     c76:	c402                	.insn	2, 0xc402
     c78:	9f300203          	lb	tp,-1549(zero) # fffff9f3 <__global_pointer$+0x7fffc1f3>
     c7c:	c404                	.insn	2, 0xc404
     c7e:	01048803          	lb	a6,16(s1)
     c82:	045f 04f4 05d8      	.insn	6, 0x05d804f4045f
     c88:	3002                	.insn	2, 0x3002
     c8a:	049f 05d8 05e8      	.insn	6, 0x05e805d8049f
     c90:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
     c94:	c004                	.insn	2, 0xc004
     c96:	c406                	.insn	2, 0xc406
     c98:	0106                	.insn	2, 0x0106
     c9a:	045f 078c 07a8      	.insn	6, 0x07a8078c045f
     ca0:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
     ca4:	dc04                	.insn	2, 0xdc04
     ca6:	0207e807          	.insn	4, 0x0207e807
     caa:	9f30                	.insn	2, 0x9f30
     cac:	9404                	.insn	2, 0x9404
     cae:	9c08                	.insn	2, 0x9c08
     cb0:	0308                	.insn	2, 0x0308
     cb2:	2008                	.insn	2, 0x2008
     cb4:	049f 09d4 09ec      	.insn	6, 0x09ec09d4049f
     cba:	3002                	.insn	2, 0x3002
     cbc:	049f 0abc 0ad4      	.insn	6, 0x0ad40abc049f
     cc2:	3002                	.insn	2, 0x3002
     cc4:	049f 0b88 0b98      	.insn	6, 0x0b980b88049f
     cca:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
     cce:	d404                	.insn	2, 0xd404
     cd0:	030be00b          	.insn	4, 0x030be00b
     cd4:	2008                	.insn	2, 0x2008
     cd6:	049f 0be0 0bfc      	.insn	6, 0x0bfc0be0049f
     cdc:	3002                	.insn	2, 0x3002
     cde:	049f 0ccc 0ce0      	.insn	6, 0x0ce00ccc049f
     ce4:	3002                	.insn	2, 0x3002
     ce6:	049f 0d80 0d88      	.insn	6, 0x0d880d80049f
     cec:	3002                	.insn	2, 0x3002
     cee:	049f 0d88 0d9c      	.insn	6, 0x0d9c0d88049f
     cf4:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
     cf8:	0400                	.insn	2, 0x0400
     cfa:	03c4                	.insn	2, 0x03c4
     cfc:	03cc                	.insn	2, 0x03cc
     cfe:	9f508f03          	lb	t5,-1547(ra)
     d02:	d404                	.insn	2, 0xd404
     d04:	0103dc03          	lhu	s8,16(t2)
     d08:	0456                	.insn	2, 0x0456
     d0a:	03dc                	.insn	2, 0x03dc
     d0c:	04a0                	.insn	2, 0x04a0
     d0e:	9f508f03          	lb	t5,-1547(ra)
     d12:	d804                	.insn	2, 0xd804
     d14:	ec05                	.insn	2, 0xec05
     d16:	0305                	.insn	2, 0x0305
     d18:	049f508f          	.insn	4, 0x049f508f
     d1c:	06c0                	.insn	2, 0x06c0
     d1e:	06d0                	.insn	2, 0x06d0
     d20:	9f508f03          	lb	t5,-1547(ra)
     d24:	8c04                	.insn	2, 0x8c04
     d26:	0307b007          	fld	ft0,48(a5)
     d2a:	049f508f          	.insn	4, 0x049f508f
     d2e:	0894                	.insn	2, 0x0894
     d30:	089c                	.insn	2, 0x089c
     d32:	9f508f03          	lb	t5,-1547(ra)
     d36:	d804                	.insn	2, 0xd804
     d38:	e408                	.insn	2, 0xe408
     d3a:	0308                	.insn	2, 0x0308
     d3c:	049f508f          	.insn	4, 0x049f508f
     d40:	09ec                	.insn	2, 0x09ec
     d42:	0a88                	.insn	2, 0x0a88
     d44:	9f508f03          	lb	t5,-1547(ra)
     d48:	8804                	.insn	2, 0x8804
     d4a:	030b980b          	.insn	4, 0x030b980b
     d4e:	049f508f          	.insn	4, 0x049f508f
     d52:	0bd4                	.insn	2, 0x0bd4
     d54:	0be0                	.insn	2, 0x0be0
     d56:	9f508f03          	lb	t5,-1547(ra)
     d5a:	8804                	.insn	2, 0x8804
     d5c:	9c0d                	.insn	2, 0x9c0d
     d5e:	030d                	.insn	2, 0x030d
     d60:	009f508f          	.insn	4, 0x009f508f
     d64:	fc04                	.insn	2, 0xfc04
     d66:	0104f403          	.insn	4, 0x0104f403
     d6a:	045a                	.insn	2, 0x045a
     d6c:	05a0                	.insn	2, 0x05a0
     d6e:	5a0107bb          	.insn	4, 0x5a0107bb
     d72:	bb04                	.insn	2, 0xbb04
     d74:	0a07bc07          	fld	fs8,160(a5)
     d78:	0aa503a3          	sb	a0,167(a0)
     d7c:	a826                	.insn	2, 0xa826
     d7e:	a82d                	.insn	2, 0xa82d
     d80:	9f00                	.insn	2, 0x9f00
     d82:	dc04                	.insn	2, 0xdc04
     d84:	010da807          	flw	fa6,16(s11)
     d88:	005a                	.insn	2, 0x005a
     d8a:	fc04                	.insn	2, 0xfc04
     d8c:	0104f403          	.insn	4, 0x0104f403
     d90:	05a0045b          	.insn	4, 0x05a0045b
     d94:	5b0107bb          	.insn	4, 0x5b0107bb
     d98:	bb04                	.insn	2, 0xbb04
     d9a:	0a07bc07          	fld	fs8,160(a5)
     d9e:	0ba503a3          	sb	s10,167(a0)
     da2:	a826                	.insn	2, 0xa826
     da4:	a82d                	.insn	2, 0xa82d
     da6:	9f00                	.insn	2, 0x9f00
     da8:	dc04                	.insn	2, 0xdc04
     daa:	010da807          	flw	fa6,16(s11)
     dae:	fc04005b          	.insn	4, 0xfc04005b
     db2:	0104f403          	.insn	4, 0x0104f403
     db6:	045c                	.insn	2, 0x045c
     db8:	05a0                	.insn	2, 0x05a0
     dba:	5c0107bb          	.insn	4, 0x5c0107bb
     dbe:	bb04                	.insn	2, 0xbb04
     dc0:	0a07bc07          	fld	fs8,160(a5)
     dc4:	0ca503a3          	sb	a0,199(a0)
     dc8:	a826                	.insn	2, 0xa826
     dca:	a82d                	.insn	2, 0xa82d
     dcc:	9f00                	.insn	2, 0x9f00
     dce:	dc04                	.insn	2, 0xdc04
     dd0:	010da807          	flw	fa6,16(s11)
     dd4:	005c                	.insn	2, 0x005c
     dd6:	fc04                	.insn	2, 0xfc04
     dd8:	0104f403          	.insn	4, 0x0104f403
     ddc:	045d                	.insn	2, 0x045d
     dde:	05a0                	.insn	2, 0x05a0
     de0:	5d0107bb          	.insn	4, 0x5d0107bb
     de4:	bb04                	.insn	2, 0xbb04
     de6:	0a07bc07          	fld	fs8,160(a5)
     dea:	0da503a3          	sb	s10,199(a0)
     dee:	a826                	.insn	2, 0xa826
     df0:	a82d                	.insn	2, 0xa82d
     df2:	9f00                	.insn	2, 0x9f00
     df4:	dc04                	.insn	2, 0xdc04
     df6:	010da807          	flw	fa6,16(s11)
     dfa:	005d                	.insn	2, 0x005d
     dfc:	fc04                	.insn	2, 0xfc04
     dfe:	0104f403          	.insn	4, 0x0104f403
     e02:	0452                	.insn	2, 0x0452
     e04:	05a0                	.insn	2, 0x05a0
     e06:	07bc                	.insn	2, 0x07bc
     e08:	5201                	.insn	2, 0x5201
     e0a:	dc04                	.insn	2, 0xdc04
     e0c:	010da807          	flw	fa6,16(s11)
     e10:	0052                	.insn	2, 0x0052
     e12:	fc04                	.insn	2, 0xfc04
     e14:	01048803          	lb	a6,16(s1)
     e18:	045f 049c 04a0      	.insn	6, 0x04a0049c045f
     e1e:	5f01                	.insn	2, 0x5f01
     e20:	ac04                	.insn	2, 0xac04
     e22:	b404                	.insn	2, 0xb404
     e24:	0104                	.insn	2, 0x0104
     e26:	0460                	.insn	2, 0x0460
     e28:	04b8                	.insn	2, 0x04b8
     e2a:	04c8                	.insn	2, 0x04c8
     e2c:	3002                	.insn	2, 0x3002
     e2e:	049f 04c8 04dc      	.insn	6, 0x04dc04c8049f
     e34:	3102                	.insn	2, 0x3102
     e36:	049f 04e0 04f0      	.insn	6, 0x04f004e0049f
     e3c:	9f017f03          	.insn	4, 0x9f017f03
     e40:	f004                	.insn	2, 0xf004
     e42:	f404                	.insn	2, 0xf404
     e44:	0104                	.insn	2, 0x0104
     e46:	045f 05a0 05c0      	.insn	6, 0x05c005a0045f
     e4c:	3002                	.insn	2, 0x3002
     e4e:	049f 05d8 05e8      	.insn	6, 0x05e805d8049f
     e54:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
     e58:	fc04                	.insn	2, 0xfc04
     e5a:	9405                	.insn	2, 0x9405
     e5c:	0106                	.insn	2, 0x0106
     e5e:	045f 06a0 06b8      	.insn	6, 0x06b806a0045f
     e64:	5f01                	.insn	2, 0x5f01
     e66:	b804                	.insn	2, 0xb804
     e68:	c006                	.insn	2, 0xc006
     e6a:	0106                	.insn	2, 0x0106
     e6c:	0456                	.insn	2, 0x0456
     e6e:	06c0                	.insn	2, 0x06c0
     e70:	06d0                	.insn	2, 0x06d0
     e72:	5f01                	.insn	2, 0x5f01
     e74:	dc04                	.insn	2, 0xdc04
     e76:	fc06                	.insn	2, 0xfc06
     e78:	0106                	.insn	2, 0x0106
     e7a:	045f 06fc 0780      	.insn	6, 0x078006fc045f
     e80:	9f017603          	.insn	4, 0x9f017603
     e84:	8c04                	.insn	2, 0x8c04
     e86:	0307a807          	flw	fa6,48(a5)
     e8a:	2008                	.insn	2, 0x2008
     e8c:	049f 07a8 07bb      	.insn	6, 0x07bb07a8049f
     e92:	5f01                	.insn	2, 0x5f01
     e94:	dc04                	.insn	2, 0xdc04
     e96:	0207e407          	.insn	4, 0x0207e407
     e9a:	9f30                	.insn	2, 0x9f30
     e9c:	f004                	.insn	2, 0xf004
     e9e:	03088007          	.insn	4, 0x03088007
     ea2:	017f 049f 0880 0884 	.insn	10, 0x5f0108840880049f017f
     eaa:	5f01 
     eac:	8404                	.insn	2, 0x8404
     eae:	9008                	.insn	2, 0x9008
     eb0:	0108                	.insn	2, 0x0108
     eb2:	0460                	.insn	2, 0x0460
     eb4:	0890                	.insn	2, 0x0890
     eb6:	0894                	.insn	2, 0x0894
     eb8:	5f01                	.insn	2, 0x5f01
     eba:	9404                	.insn	2, 0x9404
     ebc:	9c08                	.insn	2, 0x9c08
     ebe:	0308                	.insn	2, 0x0308
     ec0:	2008                	.insn	2, 0x2008
     ec2:	049f 089c 08ac      	.insn	6, 0x08ac089c049f
     ec8:	5f01                	.insn	2, 0x5f01
     eca:	ac04                	.insn	2, 0xac04
     ecc:	c008                	.insn	2, 0xc008
     ece:	0308                	.insn	2, 0x0308
     ed0:	2008                	.insn	2, 0x2008
     ed2:	049f 08d8 08e4      	.insn	6, 0x08e408d8049f
     ed8:	5f01                	.insn	2, 0x5f01
     eda:	ec04                	.insn	2, 0xec04
     edc:	8008                	.insn	2, 0x8008
     ede:	0309                	.insn	2, 0x0309
     ee0:	017f 049f 0980 0994 	.insn	10, 0x5f0109940980049f017f
     ee8:	5f01 
     eea:	9404                	.insn	2, 0x9404
     eec:	a809                	.insn	2, 0xa809
     eee:	0309                	.insn	2, 0x0309
     ef0:	017f 049f 09a8 09c4 	.insn	10, 0x5f0109c409a8049f017f
     ef8:	5f01 
     efa:	c404                	.insn	2, 0xc404
     efc:	c809                	.insn	2, 0xc809
     efe:	0309                	.insn	2, 0x0309
     f00:	0176                	.insn	2, 0x0176
     f02:	049f 09d4 09ec      	.insn	6, 0x09ec09d4049f
     f08:	3002                	.insn	2, 0x3002
     f0a:	049f 09ec 09f8      	.insn	6, 0x09f809ec049f
     f10:	5f01                	.insn	2, 0x5f01
     f12:	8804                	.insn	2, 0x8804
     f14:	940a                	.insn	2, 0x940a
     f16:	010a                	.insn	2, 0x010a
     f18:	045f 0a98 0aa8      	.insn	6, 0x0aa80a98045f
     f1e:	9f017f03          	.insn	4, 0x9f017f03
     f22:	a804                	.insn	2, 0xa804
     f24:	ac0a                	.insn	2, 0xac0a
     f26:	010a                	.insn	2, 0x010a
     f28:	045f 0abc 0ad4      	.insn	6, 0x0ad40abc045f
     f2e:	3002                	.insn	2, 0x3002
     f30:	049f 0ad8 0adc      	.insn	6, 0x0adc0ad8049f
     f36:	5601                	.insn	2, 0x5601
     f38:	dc04                	.insn	2, 0xdc04
     f3a:	ec0a                	.insn	2, 0xec0a
     f3c:	020a                	.insn	2, 0x020a
     f3e:	9f30                	.insn	2, 0x9f30
     f40:	ec04                	.insn	2, 0xec04
     f42:	800a                	.insn	2, 0x800a
     f44:	9f31020b          	.insn	4, 0x9f31020b
     f48:	8804                	.insn	2, 0x8804
     f4a:	030b980b          	.insn	4, 0x030b980b
     f4e:	2008                	.insn	2, 0x2008
     f50:	049f 0b98 0ba8      	.insn	6, 0x0ba80b98049f
     f56:	3002                	.insn	2, 0x3002
     f58:	049f 0bb0 0bd4      	.insn	6, 0x0bd40bb0049f
     f5e:	3202                	.insn	2, 0x3202
     f60:	049f 0bd4 0be0      	.insn	6, 0x0be00bd4049f
     f66:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
     f6a:	e004                	.insn	2, 0xe004
     f6c:	020c840b          	.insn	4, 0x020c840b
     f70:	9f30                	.insn	2, 0x9f30
     f72:	8404                	.insn	2, 0x8404
     f74:	9c0c                	.insn	2, 0x9c0c
     f76:	020c                	.insn	2, 0x020c
     f78:	9f32                	.insn	2, 0x9f32
     f7a:	9c04                	.insn	2, 0x9c04
     f7c:	a00c                	.insn	2, 0xa00c
     f7e:	030c                	.insn	2, 0x030c
     f80:	7e7f                	.insn	2, 0x7e7f
     f82:	049f 0ca0 0ca8      	.insn	6, 0x0ca80ca0049f
     f88:	6101                	.insn	2, 0x6101
     f8a:	a804                	.insn	2, 0xa804
     f8c:	ac0c                	.insn	2, 0xac0c
     f8e:	030c                	.insn	2, 0x030c
     f90:	7e7f                	.insn	2, 0x7e7f
     f92:	049f 0cac 0cbc      	.insn	6, 0x0cbc0cac049f
     f98:	5601                	.insn	2, 0x5601
     f9a:	bc04                	.insn	2, 0xbc04
     f9c:	cc0c                	.insn	2, 0xcc0c
     f9e:	020c                	.insn	2, 0x020c
     fa0:	9f32                	.insn	2, 0x9f32
     fa2:	cc04                	.insn	2, 0xcc04
     fa4:	e00c                	.insn	2, 0xe00c
     fa6:	020c                	.insn	2, 0x020c
     fa8:	9f30                	.insn	2, 0x9f30
     faa:	e004                	.insn	2, 0xe004
     fac:	f00c                	.insn	2, 0xf00c
     fae:	010c                	.insn	2, 0x010c
     fb0:	0456                	.insn	2, 0x0456
     fb2:	0cf0                	.insn	2, 0x0cf0
     fb4:	0d80                	.insn	2, 0x0d80
     fb6:	3202                	.insn	2, 0x3202
     fb8:	049f 0d80 0d88      	.insn	6, 0x0d880d80049f
     fbe:	3002                	.insn	2, 0x3002
     fc0:	049f 0d88 0d9c      	.insn	6, 0x0d9c0d88049f
     fc6:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
     fca:	0400                	.insn	2, 0x0400
     fcc:	03fc                	.insn	2, 0x03fc
     fce:	04f4                	.insn	2, 0x04f4
     fd0:	6301                	.insn	2, 0x6301
     fd2:	a004                	.insn	2, 0xa004
     fd4:	bc05                	.insn	2, 0xbc05
     fd6:	04630107          	.insn	4, 0x04630107
     fda:	07dc                	.insn	2, 0x07dc
     fdc:	0da8                	.insn	2, 0x0da8
     fde:	6301                	.insn	2, 0x6301
     fe0:	0400                	.insn	2, 0x0400
     fe2:	03fc                	.insn	2, 0x03fc
     fe4:	04f4                	.insn	2, 0x04f4
     fe6:	6d01                	.insn	2, 0x6d01
     fe8:	a004                	.insn	2, 0xa004
     fea:	bb05                	.insn	2, 0xbb05
     fec:	046d0107          	.insn	4, 0x046d0107
     ff0:	07bc07bb          	.insn	4, 0x07bc07bb
     ff4:	a30a                	.insn	2, 0xa30a
     ff6:	2610a503          	lw	a0,609(ra)
     ffa:	2da8                	.insn	2, 0x2da8
     ffc:	00a8                	.insn	2, 0x00a8
     ffe:	049f 07dc 0da8      	.insn	6, 0x0da807dc049f
    1004:	6d01                	.insn	2, 0x6d01
    1006:	0400                	.insn	2, 0x0400
    1008:	03fc                	.insn	2, 0x03fc
    100a:	04f4                	.insn	2, 0x04f4
    100c:	6201                	.insn	2, 0x6201
    100e:	a004                	.insn	2, 0xa004
    1010:	bc05                	.insn	2, 0xbc05
    1012:	04620107          	.insn	4, 0x04620107
    1016:	07dc                	.insn	2, 0x07dc
    1018:	0da8                	.insn	2, 0x0da8
    101a:	6201                	.insn	2, 0x6201
    101c:	0400                	.insn	2, 0x0400
    101e:	03fc                	.insn	2, 0x03fc
    1020:	0488                	.insn	2, 0x0488
    1022:	9102                	.insn	2, 0x9102
    1024:	0400                	.insn	2, 0x0400
    1026:	0488                	.insn	2, 0x0488
    1028:	04ac                	.insn	2, 0x04ac
    102a:	6001                	.insn	2, 0x6001
    102c:	ac04                	.insn	2, 0xac04
    102e:	b404                	.insn	2, 0xb404
    1030:	0104                	.insn	2, 0x0104
    1032:	0456                	.insn	2, 0x0456
    1034:	05a0                	.insn	2, 0x05a0
    1036:	05e4                	.insn	2, 0x05e4
    1038:	6001                	.insn	2, 0x6001
    103a:	e404                	.insn	2, 0xe404
    103c:	f405                	.insn	2, 0xf405
    103e:	0205                	.insn	2, 0x0205
    1040:	9f30                	.insn	2, 0x9f30
    1042:	fc04                	.insn	2, 0xfc04
    1044:	b805                	.insn	2, 0xb805
    1046:	0106                	.insn	2, 0x0106
    1048:	0460                	.insn	2, 0x0460
    104a:	06b8                	.insn	2, 0x06b8
    104c:	06c0                	.insn	2, 0x06c0
    104e:	5601                	.insn	2, 0x5601
    1050:	c004                	.insn	2, 0xc004
    1052:	c406                	.insn	2, 0xc406
    1054:	0206                	.insn	2, 0x0206
    1056:	9f30                	.insn	2, 0x9f30
    1058:	c404                	.insn	2, 0xc404
    105a:	d006                	.insn	2, 0xd006
    105c:	0106                	.insn	2, 0x0106
    105e:	0460                	.insn	2, 0x0460
    1060:	078c                	.insn	2, 0x078c
    1062:	07b0                	.insn	2, 0x07b0
    1064:	6001                	.insn	2, 0x6001
    1066:	dc04                	.insn	2, 0xdc04
    1068:	0107e407          	.insn	4, 0x0107e407
    106c:	0460                	.insn	2, 0x0460
    106e:	0884                	.insn	2, 0x0884
    1070:	0894                	.insn	2, 0x0894
    1072:	5601                	.insn	2, 0x5601
    1074:	9404                	.insn	2, 0x9404
    1076:	c008                	.insn	2, 0xc008
    1078:	0108                	.insn	2, 0x0108
    107a:	0460                	.insn	2, 0x0460
    107c:	08d8                	.insn	2, 0x08d8
    107e:	08e4                	.insn	2, 0x08e4
    1080:	6001                	.insn	2, 0x6001
    1082:	ac04                	.insn	2, 0xac04
    1084:	b409                	.insn	2, 0xb409
    1086:	0109                	.insn	2, 0x0109
    1088:	0460                	.insn	2, 0x0460
    108a:	09d4                	.insn	2, 0x09d4
    108c:	09ec                	.insn	2, 0x09ec
    108e:	3002                	.insn	2, 0x3002
    1090:	049f 09ec 0a94      	.insn	6, 0x0a9409ec049f
    1096:	6001                	.insn	2, 0x6001
    1098:	bc04                	.insn	2, 0xbc04
    109a:	d40a                	.insn	2, 0xd40a
    109c:	010a                	.insn	2, 0x010a
    109e:	0460                	.insn	2, 0x0460
    10a0:	0b88                	.insn	2, 0x0b88
    10a2:	0b98                	.insn	2, 0x0b98
    10a4:	3002                	.insn	2, 0x3002
    10a6:	049f 0bd4 0bfc      	.insn	6, 0x0bfc0bd4049f
    10ac:	6001                	.insn	2, 0x6001
    10ae:	cc04                	.insn	2, 0xcc04
    10b0:	dc0c                	.insn	2, 0xdc0c
    10b2:	010c                	.insn	2, 0x010c
    10b4:	0460                	.insn	2, 0x0460
    10b6:	0cdc                	.insn	2, 0x0cdc
    10b8:	0ce0                	.insn	2, 0x0ce0
    10ba:	9102                	.insn	2, 0x9102
    10bc:	0400                	.insn	2, 0x0400
    10be:	0d88                	.insn	2, 0x0d88
    10c0:	0d9c                	.insn	2, 0x0d9c
    10c2:	3002                	.insn	2, 0x3002
    10c4:	009f fc04 dc03      	.insn	6, 0xdc03fc04009f
    10ca:	0104                	.insn	2, 0x0104
    10cc:	0459                	.insn	2, 0x0459
    10ce:	04dc                	.insn	2, 0x04dc
    10d0:	04f4                	.insn	2, 0x04f4
    10d2:	6101                	.insn	2, 0x6101
    10d4:	a004                	.insn	2, 0xa004
    10d6:	d805                	.insn	2, 0xd805
    10d8:	0105                	.insn	2, 0x0105
    10da:	0461                	.insn	2, 0x0461
    10dc:	05d8                	.insn	2, 0x05d8
    10de:	06ec                	.insn	2, 0x06ec
    10e0:	5901                	.insn	2, 0x5901
    10e2:	ec04                	.insn	2, 0xec04
    10e4:	8c06                	.insn	2, 0x8c06
    10e6:	04610107          	.insn	4, 0x04610107
    10ea:	078c                	.insn	2, 0x078c
    10ec:	07b0                	.insn	2, 0x07b0
    10ee:	5901                	.insn	2, 0x5901
    10f0:	b004                	.insn	2, 0xb004
    10f2:	0107bb07          	fld	fs6,16(a5)
    10f6:	0461                	.insn	2, 0x0461
    10f8:	07dc                	.insn	2, 0x07dc
    10fa:	0884                	.insn	2, 0x0884
    10fc:	6101                	.insn	2, 0x6101
    10fe:	8404                	.insn	2, 0x8404
    1100:	e408                	.insn	2, 0xe408
    1102:	0108                	.insn	2, 0x0108
    1104:	0459                	.insn	2, 0x0459
    1106:	08e4                	.insn	2, 0x08e4
    1108:	0984                	.insn	2, 0x0984
    110a:	6101                	.insn	2, 0x6101
    110c:	8404                	.insn	2, 0x8404
    110e:	8809                	.insn	2, 0x8809
    1110:	0109                	.insn	2, 0x0109
    1112:	0459                	.insn	2, 0x0459
    1114:	0988                	.insn	2, 0x0988
    1116:	09ac                	.insn	2, 0x09ac
    1118:	6101                	.insn	2, 0x6101
    111a:	ac04                	.insn	2, 0xac04
    111c:	d409                	.insn	2, 0xd409
    111e:	0109                	.insn	2, 0x0109
    1120:	0459                	.insn	2, 0x0459
    1122:	09d4                	.insn	2, 0x09d4
    1124:	09ec                	.insn	2, 0x09ec
    1126:	6101                	.insn	2, 0x6101
    1128:	ec04                	.insn	2, 0xec04
    112a:	9409                	.insn	2, 0x9409
    112c:	010a                	.insn	2, 0x010a
    112e:	0459                	.insn	2, 0x0459
    1130:	0a94                	.insn	2, 0x0a94
    1132:	0aac                	.insn	2, 0x0aac
    1134:	6101                	.insn	2, 0x6101
    1136:	ac04                	.insn	2, 0xac04
    1138:	bc0a                	.insn	2, 0xbc0a
    113a:	010a                	.insn	2, 0x010a
    113c:	0459                	.insn	2, 0x0459
    113e:	0abc                	.insn	2, 0x0abc
    1140:	0ad4                	.insn	2, 0x0ad4
    1142:	6101                	.insn	2, 0x6101
    1144:	d404                	.insn	2, 0xd404
    1146:	e00a                	.insn	2, 0xe00a
    1148:	0459010b          	.insn	4, 0x0459010b
    114c:	0be0                	.insn	2, 0x0be0
    114e:	0bec                	.insn	2, 0x0bec
    1150:	6101                	.insn	2, 0x6101
    1152:	ec04                	.insn	2, 0xec04
    1154:	010d800b          	.insn	4, 0x010d800b
    1158:	0459                	.insn	2, 0x0459
    115a:	0d80                	.insn	2, 0x0d80
    115c:	0d88                	.insn	2, 0x0d88
    115e:	6101                	.insn	2, 0x6101
    1160:	8804                	.insn	2, 0x8804
    1162:	a80d                	.insn	2, 0xa80d
    1164:	010d                	.insn	2, 0x010d
    1166:	0059                	.insn	2, 0x0059
    1168:	1804                	.insn	2, 0x1804
    116a:	0120                	.insn	2, 0x0120
    116c:	005a                	.insn	2, 0x005a
    116e:	0004                	.insn	2, 0x0004
    1170:	0108                	.insn	2, 0x0108
    1172:	1008045b          	.insn	4, 0x1008045b
    1176:	a30a                	.insn	2, 0xa30a
    1178:	260ba503          	lw	a0,608(s7)
    117c:	2da8                	.insn	2, 0x2da8
    117e:	00a8                	.insn	2, 0x00a8
    1180:	009f a004 b035      	.insn	6, 0xb035a004009f
    1186:	0135                	.insn	2, 0x0135
    1188:	045a                	.insn	2, 0x045a
    118a:	35b0                	.insn	2, 0x35b0
    118c:	35cc                	.insn	2, 0x35cc
    118e:	a30a                	.insn	2, 0xa30a
    1190:	260aa503          	lw	a0,608(s5)
    1194:	2da8                	.insn	2, 0x2da8
    1196:	00a8                	.insn	2, 0x00a8
    1198:	049f 35cc 35d0      	.insn	6, 0x35d035cc049f
    119e:	5a01                	.insn	2, 0x5a01
    11a0:	d004                	.insn	2, 0xd004
    11a2:	d435                	.insn	2, 0xd435
    11a4:	0a35                	.insn	2, 0x0a35
    11a6:	0aa503a3          	sb	a0,167(a0)
    11aa:	a826                	.insn	2, 0xa826
    11ac:	a82d                	.insn	2, 0xa82d
    11ae:	9f00                	.insn	2, 0x9f00
    11b0:	0400                	.insn	2, 0x0400
    11b2:	35a0                	.insn	2, 0x35a0
    11b4:	35b0                	.insn	2, 0x35b0
    11b6:	3002                	.insn	2, 0x3002
    11b8:	049f 35b0 35b4      	.insn	6, 0x35b435b0049f
    11be:	5a01                	.insn	2, 0x5a01
    11c0:	c404                	.insn	2, 0xc404
    11c2:	cc35                	.insn	2, 0xcc35
    11c4:	0135                	.insn	2, 0x0135
    11c6:	045a                	.insn	2, 0x045a
    11c8:	35cc                	.insn	2, 0x35cc
    11ca:	35d4                	.insn	2, 0x35d4
    11cc:	3002                	.insn	2, 0x3002
    11ce:	009f a004 b035      	.insn	6, 0xb035a004009f
    11d4:	0235                	.insn	2, 0x0235
    11d6:	9f30                	.insn	2, 0x9f30
    11d8:	b004                	.insn	2, 0xb004
    11da:	b835                	.insn	2, 0xb835
    11dc:	0e35                	.insn	2, 0x0e35
    11de:	0aa503a3          	sb	a0,167(a0)
    11e2:	a826                	.insn	2, 0xa826
    11e4:	a82d                	.insn	2, 0xa82d
    11e6:	2000                	.insn	2, 0x2000
    11e8:	007f 9f22 b804 c435 	.insn	10, 0x0f35c435b8049f22007f
    11f0:	0f35 
    11f2:	007f 03a3 0aa5 a826 	.insn	10, 0xa82da8260aa503a3007f
    11fa:	a82d 
    11fc:	1c00                	.insn	2, 0x1c00
    11fe:	1c32                	.insn	2, 0x1c32
    1200:	049f 35cc 35d4      	.insn	6, 0x35d435cc049f
    1206:	3002                	.insn	2, 0x3002
    1208:	009f 8004 9034      	.insn	6, 0x90348004009f
    120e:	0135                	.insn	2, 0x0135
    1210:	045a                	.insn	2, 0x045a
    1212:	3590                	.insn	2, 0x3590
    1214:	3598                	.insn	2, 0x3598
    1216:	a30a                	.insn	2, 0xa30a
    1218:	260aa503          	lw	a0,608(s5)
    121c:	2da8                	.insn	2, 0x2da8
    121e:	00a8                	.insn	2, 0x00a8
    1220:	049f 3598 35a0      	.insn	6, 0x35a03598049f
    1226:	5a01                	.insn	2, 0x5a01
    1228:	0400                	.insn	2, 0x0400
    122a:	3480                	.insn	2, 0x3480
    122c:	34f4                	.insn	2, 0x34f4
    122e:	5b01                	.insn	2, 0x5b01
    1230:	f404                	.insn	2, 0xf404
    1232:	9834                	.insn	2, 0x9834
    1234:	0a35                	.insn	2, 0x0a35
    1236:	0ba503a3          	sb	s10,167(a0)
    123a:	a826                	.insn	2, 0xa826
    123c:	a82d                	.insn	2, 0xa82d
    123e:	9f00                	.insn	2, 0x9f00
    1240:	9804                	.insn	2, 0x9804
    1242:	a035                	.insn	2, 0xa035
    1244:	0135                	.insn	2, 0x0135
    1246:	8004005b          	.insn	4, 0x8004005b
    124a:	b834                	.insn	2, 0xb834
    124c:	0234                	.insn	2, 0x0234
    124e:	9f30                	.insn	2, 0x9f30
    1250:	b804                	.insn	2, 0xb804
    1252:	cc34                	.insn	2, 0xcc34
    1254:	0134                	.insn	2, 0x0134
    1256:	045d                	.insn	2, 0x045d
    1258:	34cc                	.insn	2, 0x34cc
    125a:	3590                	.insn	2, 0x3590
    125c:	5c01                	.insn	2, 0x5c01
    125e:	9804                	.insn	2, 0x9804
    1260:	a035                	.insn	2, 0xa035
    1262:	0135                	.insn	2, 0x0135
    1264:	005c                	.insn	2, 0x005c
    1266:	a404                	.insn	2, 0xa404
    1268:	f834                	.insn	2, 0xf834
    126a:	0134                	.insn	2, 0x0134
    126c:	0460                	.insn	2, 0x0460
    126e:	3588                	.insn	2, 0x3588
    1270:	358c                	.insn	2, 0x358c
    1272:	5f01                	.insn	2, 0x5f01
    1274:	9804                	.insn	2, 0x9804
    1276:	a035                	.insn	2, 0xa035
    1278:	0135                	.insn	2, 0x0135
    127a:	0060                	.insn	2, 0x0060
    127c:	2404                	.insn	2, 0x2404
    127e:	018c                	.insn	2, 0x018c
    1280:	5a01                	.insn	2, 0x5a01
    1282:	8c04                	.insn	2, 0x8c04
    1284:	9401                	.insn	2, 0x9401
    1286:	0102                	.insn	2, 0x0102
    1288:	02940463          	beq	s0,s1,12b0 <main-0x7fffed50>
    128c:	02bc                	.insn	2, 0x02bc
    128e:	a30a                	.insn	2, 0xa30a
    1290:	260aa503          	lw	a0,608(s5)
    1294:	2da8                	.insn	2, 0x2da8
    1296:	00a8                	.insn	2, 0x00a8
    1298:	049f 02bc 02d8      	.insn	6, 0x02d802bc049f
    129e:	5a01                	.insn	2, 0x5a01
    12a0:	0400                	.insn	2, 0x0400
    12a2:	8c24                	.insn	2, 0x8c24
    12a4:	0101                	.insn	2, 0x0101
    12a6:	018c045b          	.insn	4, 0x018c045b
    12aa:	0298                	.insn	2, 0x0298
    12ac:	6401                	.insn	2, 0x6401
    12ae:	9804                	.insn	2, 0x9804
    12b0:	bc02                	.insn	2, 0xbc02
    12b2:	0a02                	.insn	2, 0x0a02
    12b4:	0ba503a3          	sb	s10,167(a0)
    12b8:	a826                	.insn	2, 0xa826
    12ba:	a82d                	.insn	2, 0xa82d
    12bc:	9f00                	.insn	2, 0x9f00
    12be:	bc04                	.insn	2, 0xbc04
    12c0:	d802                	.insn	2, 0xd802
    12c2:	0102                	.insn	2, 0x0102
    12c4:	2404005b          	.insn	4, 0x2404005b
    12c8:	018c                	.insn	2, 0x018c
    12ca:	5c01                	.insn	2, 0x5c01
    12cc:	8c04                	.insn	2, 0x8c04
    12ce:	9001                	.insn	2, 0x9001
    12d0:	0101                	.insn	2, 0x0101
    12d2:	0459                	.insn	2, 0x0459
    12d4:	0190                	.insn	2, 0x0190
    12d6:	0198                	.insn	2, 0x0198
    12d8:	9f017c03          	.insn	4, 0x9f017c03
    12dc:	9804                	.insn	2, 0x9804
    12de:	ac01                	.insn	2, 0xac01
    12e0:	0101                	.insn	2, 0x0101
    12e2:	0459                	.insn	2, 0x0459
    12e4:	01b4                	.insn	2, 0x01b4
    12e6:	01b8                	.insn	2, 0x01b8
    12e8:	5c01                	.insn	2, 0x5c01
    12ea:	dc04                	.insn	2, 0xdc04
    12ec:	8401                	.insn	2, 0x8401
    12ee:	0102                	.insn	2, 0x0102
    12f0:	0459                	.insn	2, 0x0459
    12f2:	02bc                	.insn	2, 0x02bc
    12f4:	02c8                	.insn	2, 0x02c8
    12f6:	5c01                	.insn	2, 0x5c01
    12f8:	c804                	.insn	2, 0xc804
    12fa:	d802                	.insn	2, 0xd802
    12fc:	0102                	.insn	2, 0x0102
    12fe:	0059                	.insn	2, 0x0059
    1300:	2404                	.insn	2, 0x2404
    1302:	018c                	.insn	2, 0x018c
    1304:	5d01                	.insn	2, 0x5d01
    1306:	8c04                	.insn	2, 0x8c04
    1308:	9c01                	.insn	2, 0x9c01
    130a:	0102                	.insn	2, 0x0102
    130c:	0465                	.insn	2, 0x0465
    130e:	029c                	.insn	2, 0x029c
    1310:	02bc                	.insn	2, 0x02bc
    1312:	a30a                	.insn	2, 0xa30a
    1314:	260da503          	lw	a0,608(s11)
    1318:	2da8                	.insn	2, 0x2da8
    131a:	00a8                	.insn	2, 0x00a8
    131c:	049f 02bc 02d8      	.insn	6, 0x02d802bc049f
    1322:	5d01                	.insn	2, 0x5d01
    1324:	0400                	.insn	2, 0x0400
    1326:	8c24                	.insn	2, 0x8c24
    1328:	0101                	.insn	2, 0x0101
    132a:	045e                	.insn	2, 0x045e
    132c:	018c                	.insn	2, 0x018c
    132e:	02a4                	.insn	2, 0x02a4
    1330:	6701                	.insn	2, 0x6701
    1332:	a404                	.insn	2, 0xa404
    1334:	bc02                	.insn	2, 0xbc02
    1336:	0a02                	.insn	2, 0x0a02
    1338:	0ea503a3          	sb	a0,231(a0)
    133c:	a826                	.insn	2, 0xa826
    133e:	a82d                	.insn	2, 0xa82d
    1340:	9f00                	.insn	2, 0x9f00
    1342:	bc04                	.insn	2, 0xbc04
    1344:	d802                	.insn	2, 0xd802
    1346:	0102                	.insn	2, 0x0102
    1348:	005e                	.insn	2, 0x005e
    134a:	2404                	.insn	2, 0x2404
    134c:	018c                	.insn	2, 0x018c
    134e:	5f01                	.insn	2, 0x5f01
    1350:	8c04                	.insn	2, 0x8c04
    1352:	b001                	.insn	2, 0xb001
    1354:	0101                	.insn	2, 0x0101
    1356:	0458                	.insn	2, 0x0458
    1358:	01b4                	.insn	2, 0x01b4
    135a:	01d4                	.insn	2, 0x01d4
    135c:	5801                	.insn	2, 0x5801
    135e:	bc04                	.insn	2, 0xbc04
    1360:	d802                	.insn	2, 0xd802
    1362:	0102                	.insn	2, 0x0102
    1364:	0058                	.insn	2, 0x0058
    1366:	2404                	.insn	2, 0x2404
    1368:	018c                	.insn	2, 0x018c
    136a:	6001                	.insn	2, 0x6001
    136c:	8c04                	.insn	2, 0x8c04
    136e:	a801                	.insn	2, 0xa801
    1370:	0102                	.insn	2, 0x0102
    1372:	0468                	.insn	2, 0x0468
    1374:	02a8                	.insn	2, 0x02a8
    1376:	02bc                	.insn	2, 0x02bc
    1378:	a30a                	.insn	2, 0xa30a
    137a:	2610a503          	lw	a0,609(ra)
    137e:	2da8                	.insn	2, 0x2da8
    1380:	00a8                	.insn	2, 0x00a8
    1382:	049f 02bc 02d8      	.insn	6, 0x02d802bc049f
    1388:	6001                	.insn	2, 0x6001
    138a:	0400                	.insn	2, 0x0400
    138c:	5c24                	.insn	2, 0x5c24
    138e:	6101                	.insn	2, 0x6101
    1390:	5c04                	.insn	2, 0x5c04
    1392:	01d8                	.insn	2, 0x01d8
    1394:	6901                	.insn	2, 0x6901
    1396:	d804                	.insn	2, 0xd804
    1398:	bc01                	.insn	2, 0xbc01
    139a:	0a02                	.insn	2, 0x0a02
    139c:	11a503a3          	sb	s10,263(a0)
    13a0:	a826                	.insn	2, 0xa826
    13a2:	a82d                	.insn	2, 0xa82d
    13a4:	9f00                	.insn	2, 0x9f00
    13a6:	bc04                	.insn	2, 0xbc04
    13a8:	d802                	.insn	2, 0xd802
    13aa:	0102                	.insn	2, 0x0102
    13ac:	0069                	.insn	2, 0x0069
    13ae:	7004                	.insn	2, 0x7004
    13b0:	018c                	.insn	2, 0x018c
    13b2:	5c01                	.insn	2, 0x5c01
    13b4:	8c04                	.insn	2, 0x8c04
    13b6:	e001                	.insn	2, 0xe001
    13b8:	0101                	.insn	2, 0x0101
    13ba:	0466                	.insn	2, 0x0466
    13bc:	01e0                	.insn	2, 0x01e0
    13be:	02bc                	.insn	2, 0x02bc
    13c0:	a30a                	.insn	2, 0xa30a
    13c2:	260ca503          	lw	a0,608(s9)
    13c6:	2da8                	.insn	2, 0x2da8
    13c8:	00a8                	.insn	2, 0x00a8
    13ca:	049f 02bc 02c8      	.insn	6, 0x02c802bc049f
    13d0:	5c01                	.insn	2, 0x5c01
    13d2:	c804                	.insn	2, 0xc804
    13d4:	d802                	.insn	2, 0xd802
    13d6:	0102                	.insn	2, 0x0102
    13d8:	0059                	.insn	2, 0x0059
    13da:	7c04                	.insn	2, 0x7c04
    13dc:	018c                	.insn	2, 0x018c
    13de:	5f01                	.insn	2, 0x5f01
    13e0:	8c04                	.insn	2, 0x8c04
    13e2:	9001                	.insn	2, 0x9001
    13e4:	0901                	.insn	2, 0x0901
    13e6:	0078                	.insn	2, 0x0078
    13e8:	0086                	.insn	2, 0x0086
    13ea:	791c                	.insn	2, 0x791c
    13ec:	2200                	.insn	2, 0x2200
    13ee:	049f 0190 0198      	.insn	6, 0x01980190049f
    13f4:	7c00780b          	.insn	4, 0x7c00780b
    13f8:	2200                	.insn	2, 0x2200
    13fa:	0086                	.insn	2, 0x0086
    13fc:	231c                	.insn	2, 0x231c
    13fe:	9f01                	.insn	2, 0x9f01
    1400:	9804                	.insn	2, 0x9804
    1402:	ac01                	.insn	2, 0xac01
    1404:	0901                	.insn	2, 0x0901
    1406:	0078                	.insn	2, 0x0078
    1408:	0086                	.insn	2, 0x0086
    140a:	791c                	.insn	2, 0x791c
    140c:	2200                	.insn	2, 0x2200
    140e:	049f 02cc 02d8      	.insn	6, 0x02d802cc049f
    1414:	5801                	.insn	2, 0x5801
    1416:	0400                	.insn	2, 0x0400
    1418:	0da8                	.insn	2, 0x0da8
    141a:	5a010db7          	lui	s11,0x5a010
    141e:	b704                	.insn	2, 0xb704
    1420:	b80d                	.insn	2, 0xb80d
    1422:	0a0d                	.insn	2, 0x0a0d
    1424:	0aa503a3          	sb	a0,167(a0)
    1428:	a826                	.insn	2, 0xa826
    142a:	a842                	.insn	2, 0xa842
    142c:	9f00                	.insn	2, 0x9f00
    142e:	b804                	.insn	2, 0xb804
    1430:	bc0d                	.insn	2, 0xbc0d
    1432:	010d                	.insn	2, 0x010d
    1434:	005a                	.insn	2, 0x005a
    1436:	a804                	.insn	2, 0xa804
    1438:	b40d                	.insn	2, 0xb40d
    143a:	010d                	.insn	2, 0x010d
    143c:	0db4045b          	.insn	4, 0x0db4045b
    1440:	0db8                	.insn	2, 0x0db8
    1442:	a30a                	.insn	2, 0xa30a
    1444:	260ba503          	lw	a0,608(s7)
    1448:	2da8                	.insn	2, 0x2da8
    144a:	00a8                	.insn	2, 0x00a8
    144c:	049f 0db8 0dbc      	.insn	6, 0x0dbc0db8049f
    1452:	5b01                	.insn	2, 0x5b01
    1454:	0400                	.insn	2, 0x0400
    1456:	0da8                	.insn	2, 0x0da8
    1458:	5c010db7          	lui	s11,0x5c010
    145c:	b704                	.insn	2, 0xb704
    145e:	b80d                	.insn	2, 0xb80d
    1460:	0a0d                	.insn	2, 0x0a0d
    1462:	0ca503a3          	sb	a0,199(a0)
    1466:	a826                	.insn	2, 0xa826
    1468:	a82d                	.insn	2, 0xa82d
    146a:	9f00                	.insn	2, 0x9f00
    146c:	b804                	.insn	2, 0xb804
    146e:	bc0d                	.insn	2, 0xbc0d
    1470:	010d                	.insn	2, 0x010d
    1472:	005c                	.insn	2, 0x005c
    1474:	a804                	.insn	2, 0xa804
    1476:	b70d                	.insn	2, 0xb70d
    1478:	010d                	.insn	2, 0x010d
    147a:	045d                	.insn	2, 0x045d
    147c:	0db80db7          	lui	s11,0xdb80
    1480:	a30a                	.insn	2, 0xa30a
    1482:	260da503          	lw	a0,608(s11) # db80260 <main-0x7247fda0>
    1486:	2da8                	.insn	2, 0x2da8
    1488:	00a8                	.insn	2, 0x00a8
    148a:	049f 0db8 0dbc      	.insn	6, 0x0dbc0db8049f
    1490:	5d01                	.insn	2, 0x5d01
    1492:	0400                	.insn	2, 0x0400
    1494:	0dac                	.insn	2, 0x0dac
    1496:	5c010db7          	lui	s11,0x5c010
    149a:	b704                	.insn	2, 0xb704
    149c:	b80d                	.insn	2, 0xb80d
    149e:	0a0d                	.insn	2, 0x0a0d
    14a0:	0ca503a3          	sb	a0,199(a0)
    14a4:	a826                	.insn	2, 0xa826
    14a6:	a82d                	.insn	2, 0xa82d
    14a8:	9f00                	.insn	2, 0x9f00
    14aa:	0400                	.insn	2, 0x0400
    14ac:	0dac                	.insn	2, 0x0dac
    14ae:	5d010db7          	lui	s11,0x5d010
    14b2:	b704                	.insn	2, 0xb704
    14b4:	b80d                	.insn	2, 0xb80d
    14b6:	0a0d                	.insn	2, 0x0a0d
    14b8:	0da503a3          	sb	s10,199(a0)
    14bc:	a826                	.insn	2, 0xa826
    14be:	a82d                	.insn	2, 0xa82d
    14c0:	9f00                	.insn	2, 0x9f00
    14c2:	0400                	.insn	2, 0x0400
    14c4:	0dac                	.insn	2, 0x0dac
    14c6:	0db4                	.insn	2, 0x0db4
    14c8:	5b01                	.insn	2, 0x5b01
    14ca:	b404                	.insn	2, 0xb404
    14cc:	b80d                	.insn	2, 0xb80d
    14ce:	0a0d                	.insn	2, 0x0a0d
    14d0:	0ba503a3          	sb	s10,167(a0)
    14d4:	a826                	.insn	2, 0xa826
    14d6:	a82d                	.insn	2, 0xa82d
    14d8:	9f00                	.insn	2, 0x9f00
    14da:	0400                	.insn	2, 0x0400
    14dc:	0dbc                	.insn	2, 0x0dbc
    14de:	0ec4                	.insn	2, 0x0ec4
    14e0:	5a01                	.insn	2, 0x5a01
    14e2:	c404                	.insn	2, 0xc404
    14e4:	c80e                	.insn	2, 0xc80e
    14e6:	0110                	.insn	2, 0x0110
    14e8:	0458                	.insn	2, 0x0458
    14ea:	10c8                	.insn	2, 0x10c8
    14ec:	5a0110ff 8010ff04 	.insn	12, 0x03a30a118010ff045a0110ff
    14f4:	03a30a11 
    14f8:	0aa5                	.insn	2, 0x0aa5
    14fa:	a826                	.insn	2, 0xa826
    14fc:	a82d                	.insn	2, 0xa82d
    14fe:	9f00                	.insn	2, 0x9f00
    1500:	8004                	.insn	2, 0x8004
    1502:	c011                	.insn	2, 0xc011
    1504:	0112                	.insn	2, 0x0112
    1506:	0458                	.insn	2, 0x0458
    1508:	12c0                	.insn	2, 0x12c0
    150a:	12e4                	.insn	2, 0x12e4
    150c:	a30a                	.insn	2, 0xa30a
    150e:	260aa503          	lw	a0,608(s5)
    1512:	2da8                	.insn	2, 0x2da8
    1514:	00a8                	.insn	2, 0x00a8
    1516:	049f 12e4 138c      	.insn	6, 0x138c12e4049f
    151c:	5801                	.insn	2, 0x5801
    151e:	8c04                	.insn	2, 0x8c04
    1520:	0113cb13          	xori	s6,t2,17
    1524:	045a                	.insn	2, 0x045a
    1526:	13cc13cb          	fnmsub.d	ft7,fs8,ft8,ft2,rtz
    152a:	a30a                	.insn	2, 0xa30a
    152c:	260aa503          	lw	a0,608(s5)
    1530:	2da8                	.insn	2, 0x2da8
    1532:	00a8                	.insn	2, 0x00a8
    1534:	049f 13cc 18c4      	.insn	6, 0x18c413cc049f
    153a:	5801                	.insn	2, 0x5801
    153c:	0400                	.insn	2, 0x0400
    153e:	0dbc                	.insn	2, 0x0dbc
    1540:	0ee4                	.insn	2, 0x0ee4
    1542:	5b01                	.insn	2, 0x5b01
    1544:	e404                	.insn	2, 0xe404
    1546:	f80e                	.insn	2, 0xf80e
    1548:	0110                	.insn	2, 0x0110
    154a:	0459                	.insn	2, 0x0459
    154c:	10f8                	.insn	2, 0x10f8
    154e:	5b0110ff 8010ff04 	.insn	12, 0x03a30a118010ff045b0110ff
    1556:	03a30a11 
    155a:	0ba5                	.insn	2, 0x0ba5
    155c:	a826                	.insn	2, 0xa826
    155e:	a82d                	.insn	2, 0xa82d
    1560:	9f00                	.insn	2, 0x9f00
    1562:	8004                	.insn	2, 0x8004
    1564:	c411                	.insn	2, 0xc411
    1566:	0112                	.insn	2, 0x0112
    1568:	0459                	.insn	2, 0x0459
    156a:	12c4                	.insn	2, 0x12c4
    156c:	12e4                	.insn	2, 0x12e4
    156e:	a30a                	.insn	2, 0xa30a
    1570:	260ba503          	lw	a0,608(s7)
    1574:	2da8                	.insn	2, 0x2da8
    1576:	00a8                	.insn	2, 0x00a8
    1578:	049f 12e4 13c4      	.insn	6, 0x13c412e4049f
    157e:	5901                	.insn	2, 0x5901
    1580:	c404                	.insn	2, 0xc404
    1582:	0113cb13          	xori	s6,t2,17
    1586:	13cb045b          	.insn	4, 0x13cb045b
    158a:	13cc                	.insn	2, 0x13cc
    158c:	a30a                	.insn	2, 0xa30a
    158e:	260ba503          	lw	a0,608(s7)
    1592:	2da8                	.insn	2, 0x2da8
    1594:	00a8                	.insn	2, 0x00a8
    1596:	049f 13cc 18c4      	.insn	6, 0x18c413cc049f
    159c:	5901                	.insn	2, 0x5901
    159e:	0400                	.insn	2, 0x0400
    15a0:	0dbc                	.insn	2, 0x0dbc
    15a2:	0ee0                	.insn	2, 0x0ee0
    15a4:	5c01                	.insn	2, 0x5c01
    15a6:	e004                	.insn	2, 0xe004
    15a8:	ac0e                	.insn	2, 0xac0e
    15aa:	0110                	.insn	2, 0x0110
    15ac:	0464                	.insn	2, 0x0464
    15ae:	10ac                	.insn	2, 0x10ac
    15b0:	10e8                	.insn	2, 0x10e8
    15b2:	5c01                	.insn	2, 0x5c01
    15b4:	e804                	.insn	2, 0xe804
    15b6:	f010                	.insn	2, 0xf010
    15b8:	0110                	.insn	2, 0x0110
    15ba:	0464                	.insn	2, 0x0464
    15bc:	10f0                	.insn	2, 0x10f0
    15be:	5c0110ff 8010ff04 	.insn	12, 0x03a30a118010ff045c0110ff
    15c6:	03a30a11 
    15ca:	0ca5                	.insn	2, 0x0ca5
    15cc:	a826                	.insn	2, 0xa826
    15ce:	a82d                	.insn	2, 0xa82d
    15d0:	9f00                	.insn	2, 0x9f00
    15d2:	8004                	.insn	2, 0x8004
    15d4:	ac11                	.insn	2, 0xac11
    15d6:	0111                	.insn	2, 0x0111
    15d8:	045c                	.insn	2, 0x045c
    15da:	11ac                	.insn	2, 0x11ac
    15dc:	12d0                	.insn	2, 0x12d0
    15de:	6401                	.insn	2, 0x6401
    15e0:	d004                	.insn	2, 0xd004
    15e2:	e412                	.insn	2, 0xe412
    15e4:	0a12                	.insn	2, 0x0a12
    15e6:	0ca503a3          	sb	a0,199(a0)
    15ea:	a826                	.insn	2, 0xa826
    15ec:	a82d                	.insn	2, 0xa82d
    15ee:	9f00                	.insn	2, 0x9f00
    15f0:	e404                	.insn	2, 0xe404
    15f2:	b812                	.insn	2, 0xb812
    15f4:	045c0113          	addi	sp,s8,69
    15f8:	13b8                	.insn	2, 0x13b8
    15fa:	13c0                	.insn	2, 0x13c0
    15fc:	6401                	.insn	2, 0x6401
    15fe:	c004                	.insn	2, 0xc004
    1600:	0113cb13          	xori	s6,t2,17
    1604:	045c                	.insn	2, 0x045c
    1606:	13cc13cb          	fnmsub.d	ft7,fs8,ft8,ft2,rtz
    160a:	a30a                	.insn	2, 0xa30a
    160c:	260ca503          	lw	a0,608(s9)
    1610:	2da8                	.insn	2, 0x2da8
    1612:	00a8                	.insn	2, 0x00a8
    1614:	049f 13cc 13f8      	.insn	6, 0x13f813cc049f
    161a:	5c01                	.insn	2, 0x5c01
    161c:	f804                	.insn	2, 0xf804
    161e:	0118c413          	xori	s0,a7,17
    1622:	0064                	.insn	2, 0x0064
    1624:	bc04                	.insn	2, 0xbc04
    1626:	e80d                	.insn	2, 0xe80d
    1628:	010e                	.insn	2, 0x010e
    162a:	045d                	.insn	2, 0x045d
    162c:	0ee8                	.insn	2, 0x0ee8
    162e:	10ac                	.insn	2, 0x10ac
    1630:	6201                	.insn	2, 0x6201
    1632:	ac04                	.insn	2, 0xac04
    1634:	e410                	.insn	2, 0xe410
    1636:	0110                	.insn	2, 0x0110
    1638:	045d                	.insn	2, 0x045d
    163a:	10e4                	.insn	2, 0x10e4
    163c:	10ec                	.insn	2, 0x10ec
    163e:	6201                	.insn	2, 0x6201
    1640:	ec04                	.insn	2, 0xec04
    1642:	ff10                	.insn	2, 0xff10
    1644:	0110                	.insn	2, 0x0110
    1646:	045d                	.insn	2, 0x045d
    1648:	118010ff a503a30a 	.insn	12, 0x2da8260da503a30a118010ff
    1650:	2da8260d 
    1654:	00a8                	.insn	2, 0x00a8
    1656:	049f 1180 11ac      	.insn	6, 0x11ac1180049f
    165c:	5d01                	.insn	2, 0x5d01
    165e:	ac04                	.insn	2, 0xac04
    1660:	c811                	.insn	2, 0xc811
    1662:	0112                	.insn	2, 0x0112
    1664:	0462                	.insn	2, 0x0462
    1666:	12c8                	.insn	2, 0x12c8
    1668:	12e4                	.insn	2, 0x12e4
    166a:	a30a                	.insn	2, 0xa30a
    166c:	260da503          	lw	a0,608(s11) # 5d010260 <main-0x22fefda0>
    1670:	2da8                	.insn	2, 0x2da8
    1672:	00a8                	.insn	2, 0x00a8
    1674:	049f 12e4 13ac      	.insn	6, 0x13ac12e4049f
    167a:	5d01                	.insn	2, 0x5d01
    167c:	ac04                	.insn	2, 0xac04
    167e:	0113b413          	sltiu	s0,t2,17
    1682:	0462                	.insn	2, 0x0462
    1684:	13b4                	.insn	2, 0x13b4
    1686:	5d0113cb          	.insn	4, 0x5d0113cb
    168a:	cb04                	.insn	2, 0xcb04
    168c:	0a13cc13          	xori	s8,t2,161
    1690:	0da503a3          	sb	s10,199(a0)
    1694:	a826                	.insn	2, 0xa826
    1696:	a82d                	.insn	2, 0xa82d
    1698:	9f00                	.insn	2, 0x9f00
    169a:	cc04                	.insn	2, 0xcc04
    169c:	0113f813          	andi	a6,t2,17
    16a0:	045d                	.insn	2, 0x045d
    16a2:	13f8                	.insn	2, 0x13f8
    16a4:	18c4                	.insn	2, 0x18c4
    16a6:	6201                	.insn	2, 0x6201
    16a8:	0400                	.insn	2, 0x0400
    16aa:	0dbc                	.insn	2, 0x0dbc
    16ac:	0edc                	.insn	2, 0x0edc
    16ae:	5e06                	.insn	2, 0x5e06
    16b0:	935f0493          	addi	s1,t5,-1739
    16b4:	0404                	.insn	2, 0x0404
    16b6:	0edc                	.insn	2, 0x0edc
    16b8:	10ac                	.insn	2, 0x10ac
    16ba:	a306                	.insn	2, 0xa306
    16bc:	340ea503          	lw	a0,832(t4)
    16c0:	049f 10ac 10b8      	.insn	6, 0x10b810ac049f
    16c6:	5e06                	.insn	2, 0x5e06
    16c8:	935f0493          	addi	s1,t5,-1739
    16cc:	0404                	.insn	2, 0x0404
    16ce:	10b8                	.insn	2, 0x10b8
    16d0:	1180                	.insn	2, 0x1180
    16d2:	a306                	.insn	2, 0xa306
    16d4:	340ea503          	lw	a0,832(t4)
    16d8:	049f 1180 11ac      	.insn	6, 0x11ac1180049f
    16de:	5e06                	.insn	2, 0x5e06
    16e0:	935f0493          	addi	s1,t5,-1739
    16e4:	0404                	.insn	2, 0x0404
    16e6:	11ac                	.insn	2, 0x11ac
    16e8:	12e4                	.insn	2, 0x12e4
    16ea:	a306                	.insn	2, 0xa306
    16ec:	340ea503          	lw	a0,832(t4)
    16f0:	049f 12e4 12e8      	.insn	6, 0x12e812e4049f
    16f6:	5e06                	.insn	2, 0x5e06
    16f8:	935f0493          	addi	s1,t5,-1739
    16fc:	0404                	.insn	2, 0x0404
    16fe:	12e8                	.insn	2, 0x12e8
    1700:	12f4                	.insn	2, 0x12f4
    1702:	a306                	.insn	2, 0xa306
    1704:	340ea503          	lw	a0,832(t4)
    1708:	049f 12f4 1394      	.insn	6, 0x139412f4049f
    170e:	5e06                	.insn	2, 0x5e06
    1710:	935f0493          	addi	s1,t5,-1739
    1714:	0404                	.insn	2, 0x0404
    1716:	1394                	.insn	2, 0x1394
    1718:	13cc                	.insn	2, 0x13cc
    171a:	a306                	.insn	2, 0xa306
    171c:	340ea503          	lw	a0,832(t4)
    1720:	049f 13cc 13f8      	.insn	6, 0x13f813cc049f
    1726:	5e06                	.insn	2, 0x5e06
    1728:	935f0493          	addi	s1,t5,-1739
    172c:	0404                	.insn	2, 0x0404
    172e:	13f8                	.insn	2, 0x13f8
    1730:	18c4                	.insn	2, 0x18c4
    1732:	a306                	.insn	2, 0xa306
    1734:	340ea503          	lw	a0,832(t4)
    1738:	009f bc04 d80d      	.insn	6, 0xd80dbc04009f
    173e:	010e                	.insn	2, 0x010e
    1740:	0460                	.insn	2, 0x0460
    1742:	0ed8                	.insn	2, 0x0ed8
    1744:	10ac                	.insn	2, 0x10ac
    1746:	a30a                	.insn	2, 0xa30a
    1748:	2610a503          	lw	a0,609(ra)
    174c:	2da8                	.insn	2, 0x2da8
    174e:	00a8                	.insn	2, 0x00a8
    1750:	049f 10ac 10d8      	.insn	6, 0x10d810ac049f
    1756:	6001                	.insn	2, 0x6001
    1758:	d804                	.insn	2, 0xd804
    175a:	8010                	.insn	2, 0x8010
    175c:	0a11                	.insn	2, 0x0a11
    175e:	10a503a3          	sb	a0,263(a0)
    1762:	a826                	.insn	2, 0xa826
    1764:	a82d                	.insn	2, 0xa82d
    1766:	9f00                	.insn	2, 0x9f00
    1768:	8004                	.insn	2, 0x8004
    176a:	ac11                	.insn	2, 0xac11
    176c:	0111                	.insn	2, 0x0111
    176e:	0460                	.insn	2, 0x0460
    1770:	11ac                	.insn	2, 0x11ac
    1772:	12e4                	.insn	2, 0x12e4
    1774:	a30a                	.insn	2, 0xa30a
    1776:	2610a503          	lw	a0,609(ra)
    177a:	2da8                	.insn	2, 0x2da8
    177c:	00a8                	.insn	2, 0x00a8
    177e:	049f 12e4 13cb      	.insn	6, 0x13cb12e4049f
    1784:	6001                	.insn	2, 0x6001
    1786:	cb04                	.insn	2, 0xcb04
    1788:	0a13cc13          	xori	s8,t2,161
    178c:	10a503a3          	sb	a0,263(a0)
    1790:	a826                	.insn	2, 0xa826
    1792:	a82d                	.insn	2, 0xa82d
    1794:	9f00                	.insn	2, 0x9f00
    1796:	cc04                	.insn	2, 0xcc04
    1798:	0113f813          	andi	a6,t2,17
    179c:	0460                	.insn	2, 0x0460
    179e:	13f8                	.insn	2, 0x13f8
    17a0:	18c4                	.insn	2, 0x18c4
    17a2:	a30a                	.insn	2, 0xa30a
    17a4:	2610a503          	lw	a0,609(ra)
    17a8:	2da8                	.insn	2, 0x2da8
    17aa:	00a8                	.insn	2, 0x00a8
    17ac:	009f bc04 f00d      	.insn	6, 0xf00dbc04009f
    17b2:	010e                	.insn	2, 0x010e
    17b4:	0461                	.insn	2, 0x0461
    17b6:	0ef0                	.insn	2, 0x0ef0
    17b8:	10ac                	.insn	2, 0x10ac
    17ba:	6301                	.insn	2, 0x6301
    17bc:	ac04                	.insn	2, 0xac04
    17be:	d410                	.insn	2, 0xd410
    17c0:	0110                	.insn	2, 0x0110
    17c2:	0461                	.insn	2, 0x0461
    17c4:	10d4                	.insn	2, 0x10d4
    17c6:	10e0                	.insn	2, 0x10e0
    17c8:	6301                	.insn	2, 0x6301
    17ca:	e004                	.insn	2, 0xe004
    17cc:	ff10                	.insn	2, 0xff10
    17ce:	0110                	.insn	2, 0x0110
    17d0:	0460                	.insn	2, 0x0460
    17d2:	118010ff a503a30a 	.insn	12, 0x2da82611a503a30a118010ff
    17da:	2da82611 
    17de:	00a8                	.insn	2, 0x00a8
    17e0:	049f 1180 11ac      	.insn	6, 0x11ac1180049f
    17e6:	6101                	.insn	2, 0x6101
    17e8:	ac04                	.insn	2, 0xac04
    17ea:	b811                	.insn	2, 0xb811
    17ec:	0112                	.insn	2, 0x0112
    17ee:	12b80463          	beq	a6,a1,1916 <main-0x7fffe6ea>
    17f2:	12e4                	.insn	2, 0x12e4
    17f4:	a30a                	.insn	2, 0xa30a
    17f6:	2611a503          	lw	a0,609(gp) # 80003a61 <__global_pointer$+0x261>
    17fa:	2da8                	.insn	2, 0x2da8
    17fc:	00a8                	.insn	2, 0x00a8
    17fe:	049f 12e4 13a8      	.insn	6, 0x13a812e4049f
    1804:	6101                	.insn	2, 0x6101
    1806:	a804                	.insn	2, 0xa804
    1808:	0113b013          	sltiu	zero,t2,17
    180c:	13b00463          	beq	zero,s11,1934 <main-0x7fffe6cc>
    1810:	610113cb          	fnmsub.s	ft7,ft2,fa6,fa2,rtz
    1814:	cb04                	.insn	2, 0xcb04
    1816:	0a13cc13          	xori	s8,t2,161
    181a:	11a503a3          	sb	s10,263(a0)
    181e:	a826                	.insn	2, 0xa826
    1820:	a82d                	.insn	2, 0xa82d
    1822:	9f00                	.insn	2, 0x9f00
    1824:	cc04                	.insn	2, 0xcc04
    1826:	0113f813          	andi	a6,t2,17
    182a:	0461                	.insn	2, 0x0461
    182c:	13f8                	.insn	2, 0x13f8
    182e:	169c                	.insn	2, 0x169c
    1830:	6301                	.insn	2, 0x6301
    1832:	9c04                	.insn	2, 0x9c04
    1834:	a016                	.insn	2, 0xa016
    1836:	0316                	.insn	2, 0x0316
    1838:	049f0183          	lb	gp,73(t5)
    183c:	16a0                	.insn	2, 0x16a0
    183e:	16c0                	.insn	2, 0x16c0
    1840:	a30a                	.insn	2, 0xa30a
    1842:	2611a503          	lw	a0,609(gp) # 80003a61 <__global_pointer$+0x261>
    1846:	2da8                	.insn	2, 0x2da8
    1848:	00a8                	.insn	2, 0x00a8
    184a:	049f 16c0 16cc      	.insn	6, 0x16cc16c0049f
    1850:	6301                	.insn	2, 0x6301
    1852:	cc04                	.insn	2, 0xcc04
    1854:	8c16                	.insn	2, 0x8c16
    1856:	03a30a17          	auipc	s4,0x3a30
    185a:	11a5                	.insn	2, 0x11a5
    185c:	a826                	.insn	2, 0xa826
    185e:	a82d                	.insn	2, 0xa82d
    1860:	9f00                	.insn	2, 0x9f00
    1862:	8c04                	.insn	2, 0x8c04
    1864:	01179817          	auipc	a6,0x1179
    1868:	17980463          	beq	a6,s9,19d0 <main-0x7fffe630>
    186c:	17a4                	.insn	2, 0x17a4
    186e:	9f018303          	lb	t1,-1552(gp) # 800031f0 <__BSS_END__+0x150>
    1872:	a404                	.insn	2, 0xa404
    1874:	0a17b417          	auipc	s0,0xa17b
    1878:	11a503a3          	sb	s10,263(a0)
    187c:	a826                	.insn	2, 0xa826
    187e:	a82d                	.insn	2, 0xa82d
    1880:	9f00                	.insn	2, 0x9f00
    1882:	b404                	.insn	2, 0xb404
    1884:	0117f417          	auipc	s0,0x117f
    1888:	17f40463          	beq	s0,t6,19f0 <main-0x7fffe610>
    188c:	1894                	.insn	2, 0x1894
    188e:	a30a                	.insn	2, 0xa30a
    1890:	2611a503          	lw	a0,609(gp) # 80003a61 <__global_pointer$+0x261>
    1894:	2da8                	.insn	2, 0x2da8
    1896:	00a8                	.insn	2, 0x00a8
    1898:	049f 1894 18b8      	.insn	6, 0x18b81894049f
    189e:	6301                	.insn	2, 0x6301
    18a0:	b804                	.insn	2, 0xb804
    18a2:	c418                	.insn	2, 0xc418
    18a4:	0318                	.insn	2, 0x0318
    18a6:	009f0183          	lb	gp,9(t5)
    18aa:	bc04                	.insn	2, 0xbc04
    18ac:	ac0d                	.insn	2, 0xac0d
    18ae:	0210                	.insn	2, 0x0210
    18b0:	0091                	.insn	2, 0x0091
    18b2:	ac04                	.insn	2, 0xac04
    18b4:	dc10                	.insn	2, 0xdc10
    18b6:	0110                	.insn	2, 0x0110
    18b8:	0465                	.insn	2, 0x0465
    18ba:	10dc                	.insn	2, 0x10dc
    18bc:	10fc                	.insn	2, 0x10fc
    18be:	9102                	.insn	2, 0x9102
    18c0:	0400                	.insn	2, 0x0400
    18c2:	10fc                	.insn	2, 0x10fc
    18c4:	1180                	.insn	2, 0x1180
    18c6:	7202                	.insn	2, 0x7202
    18c8:	0400                	.insn	2, 0x0400
    18ca:	1180                	.insn	2, 0x1180
    18cc:	11ac                	.insn	2, 0x11ac
    18ce:	6501                	.insn	2, 0x6501
    18d0:	ac04                	.insn	2, 0xac04
    18d2:	b811                	.insn	2, 0xb811
    18d4:	0212                	.insn	2, 0x0212
    18d6:	0091                	.insn	2, 0x0091
    18d8:	e404                	.insn	2, 0xe404
    18da:	a012                	.insn	2, 0xa012
    18dc:	04650113          	addi	sp,a0,70
    18e0:	13a0                	.insn	2, 0x13a0
    18e2:	13c8                	.insn	2, 0x13c8
    18e4:	9102                	.insn	2, 0x9102
    18e6:	0400                	.insn	2, 0x0400
    18e8:	13c8                	.insn	2, 0x13c8
    18ea:	720213cb          	fnmsub.d	ft7,ft4,ft0,fa4,rtz
    18ee:	0400                	.insn	2, 0x0400
    18f0:	13cc                	.insn	2, 0x13cc
    18f2:	13f8                	.insn	2, 0x13f8
    18f4:	6501                	.insn	2, 0x6501
    18f6:	f804                	.insn	2, 0xf804
    18f8:	0214fc13          	andi	s8,s1,33
    18fc:	0091                	.insn	2, 0x0091
    18fe:	fc04                	.insn	2, 0xfc04
    1900:	c414                	.insn	2, 0xc414
    1902:	0118                	.insn	2, 0x0118
    1904:	0065                	.insn	2, 0x0065
    1906:	9804                	.insn	2, 0x9804
    1908:	c40e                	.insn	2, 0xc40e
    190a:	010e                	.insn	2, 0x010e
    190c:	045a                	.insn	2, 0x045a
    190e:	0ec4                	.insn	2, 0x0ec4
    1910:	10c8                	.insn	2, 0x10c8
    1912:	5801                	.insn	2, 0x5801
    1914:	c804                	.insn	2, 0xc804
    1916:	ff10                	.insn	2, 0xff10
    1918:	0110                	.insn	2, 0x0110
    191a:	045a                	.insn	2, 0x045a
    191c:	118010ff a503a30a 	.insn	12, 0x2da8260aa503a30a118010ff
    1924:	2da8260a 
    1928:	00a8                	.insn	2, 0x00a8
    192a:	049f 12e4 138c      	.insn	6, 0x138c12e4049f
    1930:	5801                	.insn	2, 0x5801
    1932:	8c04                	.insn	2, 0x8c04
    1934:	0113cb13          	xori	s6,t2,17
    1938:	045a                	.insn	2, 0x045a
    193a:	13cc13cb          	fnmsub.d	ft7,fs8,ft8,ft2,rtz
    193e:	a30a                	.insn	2, 0xa30a
    1940:	260aa503          	lw	a0,608(s5)
    1944:	2da8                	.insn	2, 0x2da8
    1946:	00a8                	.insn	2, 0x00a8
    1948:	049f 14fc 1788      	.insn	6, 0x178814fc049f
    194e:	5801                	.insn	2, 0x5801
    1950:	8c04                	.insn	2, 0x8c04
    1952:	0118c417          	auipc	s0,0x118c
    1956:	0058                	.insn	2, 0x0058
    1958:	9804                	.insn	2, 0x9804
    195a:	e40e                	.insn	2, 0xe40e
    195c:	010e                	.insn	2, 0x010e
    195e:	0ee4045b          	.insn	4, 0x0ee4045b
    1962:	10f8                	.insn	2, 0x10f8
    1964:	5901                	.insn	2, 0x5901
    1966:	f804                	.insn	2, 0xf804
    1968:	ff10                	.insn	2, 0xff10
    196a:	0110                	.insn	2, 0x0110
    196c:	10ff045b          	.insn	4, 0x10ff045b
    1970:	1180                	.insn	2, 0x1180
    1972:	a30a                	.insn	2, 0xa30a
    1974:	260ba503          	lw	a0,608(s7)
    1978:	2da8                	.insn	2, 0x2da8
    197a:	00a8                	.insn	2, 0x00a8
    197c:	049f 12e4 13c4      	.insn	6, 0x13c412e4049f
    1982:	5901                	.insn	2, 0x5901
    1984:	c404                	.insn	2, 0xc404
    1986:	0113cb13          	xori	s6,t2,17
    198a:	13cb045b          	.insn	4, 0x13cb045b
    198e:	13cc                	.insn	2, 0x13cc
    1990:	a30a                	.insn	2, 0xa30a
    1992:	260ba503          	lw	a0,608(s7)
    1996:	2da8                	.insn	2, 0x2da8
    1998:	00a8                	.insn	2, 0x00a8
    199a:	049f 14fc 1788      	.insn	6, 0x178814fc049f
    19a0:	5901                	.insn	2, 0x5901
    19a2:	8c04                	.insn	2, 0x8c04
    19a4:	0118c417          	auipc	s0,0x118c
    19a8:	0059                	.insn	2, 0x0059
    19aa:	9804                	.insn	2, 0x9804
    19ac:	e00e                	.insn	2, 0xe00e
    19ae:	010e                	.insn	2, 0x010e
    19b0:	045c                	.insn	2, 0x045c
    19b2:	0ee0                	.insn	2, 0x0ee0
    19b4:	10ac                	.insn	2, 0x10ac
    19b6:	6401                	.insn	2, 0x6401
    19b8:	ac04                	.insn	2, 0xac04
    19ba:	e810                	.insn	2, 0xe810
    19bc:	0110                	.insn	2, 0x0110
    19be:	045c                	.insn	2, 0x045c
    19c0:	10e8                	.insn	2, 0x10e8
    19c2:	10f0                	.insn	2, 0x10f0
    19c4:	6401                	.insn	2, 0x6401
    19c6:	f004                	.insn	2, 0xf004
    19c8:	ff10                	.insn	2, 0xff10
    19ca:	0110                	.insn	2, 0x0110
    19cc:	045c                	.insn	2, 0x045c
    19ce:	118010ff a503a30a 	.insn	12, 0x2da8260ca503a30a118010ff
    19d6:	2da8260c 
    19da:	00a8                	.insn	2, 0x00a8
    19dc:	049f 12e4 13b8      	.insn	6, 0x13b812e4049f
    19e2:	5c01                	.insn	2, 0x5c01
    19e4:	b804                	.insn	2, 0xb804
    19e6:	0113c013          	xori	zero,t2,17
    19ea:	0464                	.insn	2, 0x0464
    19ec:	13c0                	.insn	2, 0x13c0
    19ee:	5c0113cb          	.insn	4, 0x5c0113cb
    19f2:	cb04                	.insn	2, 0xcb04
    19f4:	0a13cc13          	xori	s8,t2,161
    19f8:	0ca503a3          	sb	a0,199(a0)
    19fc:	a826                	.insn	2, 0xa826
    19fe:	a82d                	.insn	2, 0xa82d
    1a00:	9f00                	.insn	2, 0x9f00
    1a02:	fc04                	.insn	2, 0xfc04
    1a04:	8814                	.insn	2, 0x8814
    1a06:	04640117          	auipc	sp,0x4640
    1a0a:	178c                	.insn	2, 0x178c
    1a0c:	18c4                	.insn	2, 0x18c4
    1a0e:	6401                	.insn	2, 0x6401
    1a10:	0400                	.insn	2, 0x0400
    1a12:	0e98                	.insn	2, 0x0e98
    1a14:	0ee8                	.insn	2, 0x0ee8
    1a16:	5d01                	.insn	2, 0x5d01
    1a18:	e804                	.insn	2, 0xe804
    1a1a:	ac0e                	.insn	2, 0xac0e
    1a1c:	0110                	.insn	2, 0x0110
    1a1e:	0462                	.insn	2, 0x0462
    1a20:	10ac                	.insn	2, 0x10ac
    1a22:	10e4                	.insn	2, 0x10e4
    1a24:	5d01                	.insn	2, 0x5d01
    1a26:	e404                	.insn	2, 0xe404
    1a28:	ec10                	.insn	2, 0xec10
    1a2a:	0110                	.insn	2, 0x0110
    1a2c:	0462                	.insn	2, 0x0462
    1a2e:	10ec                	.insn	2, 0x10ec
    1a30:	5d0110ff 8010ff04 	.insn	12, 0x03a30a118010ff045d0110ff
    1a38:	03a30a11 
    1a3c:	0da5                	.insn	2, 0x0da5
    1a3e:	a826                	.insn	2, 0xa826
    1a40:	a82d                	.insn	2, 0xa82d
    1a42:	9f00                	.insn	2, 0x9f00
    1a44:	e404                	.insn	2, 0xe404
    1a46:	ac12                	.insn	2, 0xac12
    1a48:	045d0113          	addi	sp,s10,69
    1a4c:	13ac                	.insn	2, 0x13ac
    1a4e:	13b4                	.insn	2, 0x13b4
    1a50:	6201                	.insn	2, 0x6201
    1a52:	b404                	.insn	2, 0xb404
    1a54:	0113cb13          	xori	s6,t2,17
    1a58:	045d                	.insn	2, 0x045d
    1a5a:	13cc13cb          	fnmsub.d	ft7,fs8,ft8,ft2,rtz
    1a5e:	a30a                	.insn	2, 0xa30a
    1a60:	260da503          	lw	a0,608(s11)
    1a64:	2da8                	.insn	2, 0x2da8
    1a66:	00a8                	.insn	2, 0x00a8
    1a68:	049f 14fc 1788      	.insn	6, 0x178814fc049f
    1a6e:	6201                	.insn	2, 0x6201
    1a70:	8c04                	.insn	2, 0x8c04
    1a72:	0118c417          	auipc	s0,0x118c
    1a76:	0062                	.insn	2, 0x0062
    1a78:	9804                	.insn	2, 0x9804
    1a7a:	ff0e                	.insn	2, 0xff0e
    1a7c:	0210                	.insn	2, 0x0210
    1a7e:	2f90                	.insn	2, 0x2f90
    1a80:	ff04                	.insn	2, 0xff04
    1a82:	8010                	.insn	2, 0x8010
    1a84:	0311                	.insn	2, 0x0311
    1a86:	a872                	.insn	2, 0xa872
    1a88:	047f 12e4 13cb 9002 	.insn	10, 0x042f900213cb12e4047f
    1a90:	042f 
    1a92:	13cc13cb          	fnmsub.d	ft7,fs8,ft8,ft2,rtz
    1a96:	7fa87203          	.insn	4, 0x7fa87203
    1a9a:	fc04                	.insn	2, 0xfc04
    1a9c:	a814                	.insn	2, 0xa814
    1a9e:	0215                	.insn	2, 0x0215
    1aa0:	2f90                	.insn	2, 0x2f90
    1aa2:	b404                	.insn	2, 0xb404
    1aa4:	0217f417          	auipc	s0,0x217f
    1aa8:	2f90                	.insn	2, 0x2f90
    1aaa:	9404                	.insn	2, 0x9404
    1aac:	a418                	.insn	2, 0xa418
    1aae:	0218                	.insn	2, 0x0218
    1ab0:	2f90                	.insn	2, 0x2f90
    1ab2:	0400                	.insn	2, 0x0400
    1ab4:	0e98                	.insn	2, 0x0e98
    1ab6:	0ef0                	.insn	2, 0x0ef0
    1ab8:	6001                	.insn	2, 0x6001
    1aba:	f004                	.insn	2, 0xf004
    1abc:	900e                	.insn	2, 0x900e
    1abe:	045d010f          	.insn	4, 0x045d010f
    1ac2:	10ac                	.insn	2, 0x10ac
    1ac4:	10d8                	.insn	2, 0x10d8
    1ac6:	6001                	.insn	2, 0x6001
    1ac8:	d804                	.insn	2, 0xd804
    1aca:	8010                	.insn	2, 0x8010
    1acc:	0a11                	.insn	2, 0x0a11
    1ace:	10a503a3          	sb	a0,263(a0)
    1ad2:	a826                	.insn	2, 0xa826
    1ad4:	a82d                	.insn	2, 0xa82d
    1ad6:	9f00                	.insn	2, 0x9f00
    1ad8:	e404                	.insn	2, 0xe404
    1ada:	cb12                	.insn	2, 0xcb12
    1adc:	04600113          	addi	sp,zero,70
    1ae0:	13cc13cb          	fnmsub.d	ft7,fs8,ft8,ft2,rtz
    1ae4:	a30a                	.insn	2, 0xa30a
    1ae6:	2610a503          	lw	a0,609(ra)
    1aea:	2da8                	.insn	2, 0x2da8
    1aec:	00a8                	.insn	2, 0x00a8
    1aee:	049f 14fc 1588      	.insn	6, 0x158814fc049f
    1af4:	5d01                	.insn	2, 0x5d01
    1af6:	0400                	.insn	2, 0x0400
    1af8:	0e98                	.insn	2, 0x0e98
    1afa:	0ef0                	.insn	2, 0x0ef0
    1afc:	6101                	.insn	2, 0x6101
    1afe:	f004                	.insn	2, 0xf004
    1b00:	ac0e                	.insn	2, 0xac0e
    1b02:	0110                	.insn	2, 0x0110
    1b04:	10ac0463          	beq	s8,a0,1c0c <main-0x7fffe3f4>
    1b08:	10d4                	.insn	2, 0x10d4
    1b0a:	6101                	.insn	2, 0x6101
    1b0c:	d404                	.insn	2, 0xd404
    1b0e:	e010                	.insn	2, 0xe010
    1b10:	0110                	.insn	2, 0x0110
    1b12:	10e00463          	beq	zero,a4,1c1a <main-0x7fffe3e6>
    1b16:	600110ff 8010ff04 	.insn	12, 0x03a30a118010ff04600110ff
    1b1e:	03a30a11 
    1b22:	11a5                	.insn	2, 0x11a5
    1b24:	a826                	.insn	2, 0xa826
    1b26:	a82d                	.insn	2, 0xa82d
    1b28:	9f00                	.insn	2, 0x9f00
    1b2a:	e404                	.insn	2, 0xe404
    1b2c:	a812                	.insn	2, 0xa812
    1b2e:	04610113          	addi	sp,sp,70 # 4641a4c <main-0x7b9be5b4>
    1b32:	13a8                	.insn	2, 0x13a8
    1b34:	13b0                	.insn	2, 0x13b0
    1b36:	6301                	.insn	2, 0x6301
    1b38:	b004                	.insn	2, 0xb004
    1b3a:	0113cb13          	xori	s6,t2,17
    1b3e:	0461                	.insn	2, 0x0461
    1b40:	13cc13cb          	fnmsub.d	ft7,fs8,ft8,ft2,rtz
    1b44:	a30a                	.insn	2, 0xa30a
    1b46:	2611a503          	lw	a0,609(gp) # 80003a61 <__global_pointer$+0x261>
    1b4a:	2da8                	.insn	2, 0x2da8
    1b4c:	00a8                	.insn	2, 0x00a8
    1b4e:	049f 14fc 16e8      	.insn	6, 0x16e814fc049f
    1b54:	6301                	.insn	2, 0x6301
    1b56:	8c04                	.insn	2, 0x8c04
    1b58:	0118c417          	auipc	s0,0x118c
    1b5c:	98040063          	beq	s0,zero,cdc <main-0x7ffff324>
    1b60:	ac0e                	.insn	2, 0xac0e
    1b62:	0210                	.insn	2, 0x0210
    1b64:	0091                	.insn	2, 0x0091
    1b66:	ac04                	.insn	2, 0xac04
    1b68:	dc10                	.insn	2, 0xdc10
    1b6a:	0110                	.insn	2, 0x0110
    1b6c:	0465                	.insn	2, 0x0465
    1b6e:	10dc                	.insn	2, 0x10dc
    1b70:	10fc                	.insn	2, 0x10fc
    1b72:	9102                	.insn	2, 0x9102
    1b74:	0400                	.insn	2, 0x0400
    1b76:	10fc                	.insn	2, 0x10fc
    1b78:	1180                	.insn	2, 0x1180
    1b7a:	7202                	.insn	2, 0x7202
    1b7c:	0400                	.insn	2, 0x0400
    1b7e:	12e4                	.insn	2, 0x12e4
    1b80:	13a0                	.insn	2, 0x13a0
    1b82:	6501                	.insn	2, 0x6501
    1b84:	a004                	.insn	2, 0xa004
    1b86:	0213c813          	xori	a6,t2,33
    1b8a:	0091                	.insn	2, 0x0091
    1b8c:	c804                	.insn	2, 0xc804
    1b8e:	0213cb13          	xori	s6,t2,33
    1b92:	0072                	.insn	2, 0x0072
    1b94:	fc04                	.insn	2, 0xfc04
    1b96:	8814                	.insn	2, 0x8814
    1b98:	04650117          	auipc	sp,0x4650
    1b9c:	178c                	.insn	2, 0x178c
    1b9e:	18c4                	.insn	2, 0x18c4
    1ba0:	6501                	.insn	2, 0x6501
    1ba2:	0400                	.insn	2, 0x0400
    1ba4:	0ed8                	.insn	2, 0x0ed8
    1ba6:	0ef0                	.insn	2, 0x0ef0
    1ba8:	3002                	.insn	2, 0x3002
    1baa:	049f 0ef0 0efc      	.insn	6, 0x0efc0ef0049f
    1bb0:	8006                	.insn	2, 0x8006
    1bb2:	7d00                	.insn	2, 0x7d00
    1bb4:	1c00                	.insn	2, 0x1c00
    1bb6:	049f 0efc 0f80      	.insn	6, 0x0f800efc049f
    1bbc:	7c08                	.insn	2, 0x7c08
    1bbe:	9100                	.insn	2, 0x9100
    1bc0:	1c00                	.insn	2, 0x1c00
    1bc2:	049f5123          	.insn	4, 0x049f5123
    1bc6:	0f80                	.insn	2, 0x0f80
    1bc8:	0f88                	.insn	2, 0x0f88
    1bca:	7c08                	.insn	2, 0x7c08
    1bcc:	9100                	.insn	2, 0x9100
    1bce:	1c00                	.insn	2, 0x1c00
    1bd0:	049f5023          	.insn	4, 0x049f5023
    1bd4:	0ff0                	.insn	2, 0x0ff0
    1bd6:	0ffc                	.insn	2, 0x0ffc
    1bd8:	5f01                	.insn	2, 0x5f01
    1bda:	fc04                	.insn	2, 0xfc04
    1bdc:	0310840f          	.insn	4, 0x0310840f
    1be0:	7f7f                	.insn	2, 0x7f7f
    1be2:	049f 1084 10ac      	.insn	6, 0x10ac1084049f
    1be8:	5f01                	.insn	2, 0x5f01
    1bea:	fc04                	.insn	2, 0xfc04
    1bec:	8814                	.insn	2, 0x8814
    1bee:	0615                	.insn	2, 0x0615
    1bf0:	0080                	.insn	2, 0x0080
    1bf2:	007d                	.insn	2, 0x007d
    1bf4:	9f1c                	.insn	2, 0x9f1c
    1bf6:	c804                	.insn	2, 0xc804
    1bf8:	8415                	.insn	2, 0x8415
    1bfa:	0116                	.insn	2, 0x0116
    1bfc:	045f 1684 16a0      	.insn	6, 0x16a01684045f
    1c02:	9f200803          	lb	a6,-1550(zero) # fffff9f2 <__global_pointer$+0x7fffc1f2>
    1c06:	a804                	.insn	2, 0xa804
    1c08:	d816                	.insn	2, 0xd816
    1c0a:	0116                	.insn	2, 0x0116
    1c0c:	045f 16d8 16dc      	.insn	6, 0x16dc16d8045f
    1c12:	9f017f03          	.insn	4, 0x9f017f03
    1c16:	e804                	.insn	2, 0xe804
    1c18:	8316                	.insn	2, 0x8316
    1c1a:	045f0117          	auipc	sp,0x45f0
    1c1e:	1798                	.insn	2, 0x1798
    1c20:	17ac                	.insn	2, 0x17ac
    1c22:	5f01                	.insn	2, 0x5f01
    1c24:	ac04                	.insn	2, 0xac04
    1c26:	0317b417          	auipc	s0,0x317b
    1c2a:	017f 049f 17b4 17d8 	.insn	10, 0x5f0117d817b4049f017f
    1c32:	5f01 
    1c34:	e004                	.insn	2, 0xe004
    1c36:	0117fc17          	auipc	s8,0x117f
    1c3a:	045f 17fc 1890      	.insn	6, 0x189017fc045f
    1c40:	9f017f03          	.insn	4, 0x9f017f03
    1c44:	9004                	.insn	2, 0x9004
    1c46:	9418                	.insn	2, 0x9418
    1c48:	0118                	.insn	2, 0x0118
    1c4a:	045f 18a4 18c4      	.insn	6, 0x18c418a4045f
    1c50:	5f01                	.insn	2, 0x5f01
    1c52:	0400                	.insn	2, 0x0400
    1c54:	0fbc                	.insn	2, 0x0fbc
    1c56:	0fcc                	.insn	2, 0x0fcc
    1c58:	9002                	.insn	2, 0x9002
    1c5a:	042e                	.insn	2, 0x042e
    1c5c:	0fcc                	.insn	2, 0x0fcc
    1c5e:	0fd8                	.insn	2, 0x0fd8
    1c60:	342fa513          	slti	a0,t6,834
    1c64:	007c                	.insn	2, 0x007c
    1c66:	3ba8                	.insn	2, 0x3ba8
    1c68:	34a8                	.insn	2, 0x34a8
    1c6a:	a51c                	.insn	2, 0xa51c
    1c6c:	342c                	.insn	2, 0x342c
    1c6e:	a51e                	.insn	2, 0xa51e
    1c70:	9f1c342b          	.insn	4, 0x9f1c342b
    1c74:	d804                	.insn	2, 0xd804
    1c76:	130fdc0f          	.insn	4, 0x130fdc0f
    1c7a:	2fa5                	.insn	2, 0x2fa5
    1c7c:	7c34                	.insn	2, 0x7c34
    1c7e:	a87f a83b 1c34 2ca5 	.insn	14, 0x1c342ba51e342ca51c34a83ba87f
    1c86:	1e34 2ba5 1c34 
    1c8c:	049f 0fdc 10ac      	.insn	6, 0x10ac0fdc049f
    1c92:	a518                	.insn	2, 0xa518
    1c94:	2fa5342f          	.insn	4, 0x2fa5342f
    1c98:	a834                	.insn	2, 0xa834
    1c9a:	a800a83b          	.insn	4, 0xa800a83b
    1c9e:	1c34a83b          	.insn	4, 0x1c34a83b
    1ca2:	2ca5                	.insn	2, 0x2ca5
    1ca4:	1e34                	.insn	2, 0x1e34
    1ca6:	2ba5                	.insn	2, 0x2ba5
    1ca8:	1c34                	.insn	2, 0x1c34
    1caa:	049f 1588 159c      	.insn	6, 0x159c1588049f
    1cb0:	9002                	.insn	2, 0x9002
    1cb2:	042e                	.insn	2, 0x042e
    1cb4:	159c                	.insn	2, 0x159c
    1cb6:	15a8                	.insn	2, 0x15a8
    1cb8:	342fa50b          	.insn	4, 0x342fa50b
    1cbc:	007c                	.insn	2, 0x007c
    1cbe:	3ba8                	.insn	2, 0x3ba8
    1cc0:	34a8                	.insn	2, 0x34a8
    1cc2:	9f1c                	.insn	2, 0x9f1c
    1cc4:	a804                	.insn	2, 0xa804
    1cc6:	b815                	.insn	2, 0xb815
    1cc8:	0215                	.insn	2, 0x0215
    1cca:	2f90                	.insn	2, 0x2f90
    1ccc:	b404                	.insn	2, 0xb404
    1cce:	1817f417          	auipc	s0,0x1817f
    1cd2:	2fa5                	.insn	2, 0x2fa5
    1cd4:	a534                	.insn	2, 0xa534
    1cd6:	3ba8342f          	.insn	4, 0x3ba8342f
    1cda:	00a8                	.insn	2, 0x00a8
    1cdc:	3ba8                	.insn	2, 0x3ba8
    1cde:	34a8                	.insn	2, 0x34a8
    1ce0:	a51c                	.insn	2, 0xa51c
    1ce2:	342c                	.insn	2, 0x342c
    1ce4:	a51e                	.insn	2, 0xa51e
    1ce6:	9f1c342b          	.insn	4, 0x9f1c342b
    1cea:	9404                	.insn	2, 0x9404
    1cec:	a418                	.insn	2, 0xa418
    1cee:	0218                	.insn	2, 0x0218
    1cf0:	2e90                	.insn	2, 0x2e90
    1cf2:	0400                	.insn	2, 0x0400
    1cf4:	0ebc                	.insn	2, 0x0ebc
    1cf6:	0ecc                	.insn	2, 0x0ecc
    1cf8:	3002                	.insn	2, 0x3002
    1cfa:	049f 0ecc 10ac      	.insn	6, 0x10ac0ecc049f
    1d00:	5a01                	.insn	2, 0x5a01
    1d02:	f404                	.insn	2, 0xf404
    1d04:	8012                	.insn	2, 0x8012
    1d06:	9f310213          	addi	tp,sp,-1549 # 45f160d <main-0x7ba0e9f3>
    1d0a:	fc04                	.insn	2, 0xfc04
    1d0c:	8014                	.insn	2, 0x8014
    1d0e:	045a0117          	auipc	sp,0x45a0
    1d12:	178c                	.insn	2, 0x178c
    1d14:	18c4                	.insn	2, 0x18c4
    1d16:	5a01                	.insn	2, 0x5a01
    1d18:	0400                	.insn	2, 0x0400
    1d1a:	0f8c                	.insn	2, 0x0f8c
    1d1c:	10ac                	.insn	2, 0x10ac
    1d1e:	5c01                	.insn	2, 0x5c01
    1d20:	8804                	.insn	2, 0x8804
    1d22:	b415                	.insn	2, 0xb415
    1d24:	0115                	.insn	2, 0x0115
    1d26:	045c                	.insn	2, 0x045c
    1d28:	15b4                	.insn	2, 0x15b4
    1d2a:	15b8                	.insn	2, 0x15b8
    1d2c:	9f7f7c03          	.insn	4, 0x9f7f7c03
    1d30:	c804                	.insn	2, 0xc804
    1d32:	f415                	.insn	2, 0xf415
    1d34:	0115                	.insn	2, 0x0115
    1d36:	045c                	.insn	2, 0x045c
    1d38:	15f4                	.insn	2, 0x15f4
    1d3a:	15fc                	.insn	2, 0x15fc
    1d3c:	5d01                	.insn	2, 0x5d01
    1d3e:	fc04                	.insn	2, 0xfc04
    1d40:	8c15                	.insn	2, 0x8c15
    1d42:	0116                	.insn	2, 0x0116
    1d44:	045c                	.insn	2, 0x045c
    1d46:	16c0                	.insn	2, 0x16c0
    1d48:	16c8                	.insn	2, 0x16c8
    1d4a:	5c01                	.insn	2, 0x5c01
    1d4c:	b404                	.insn	2, 0xb404
    1d4e:	0117f417          	auipc	s0,0x117f
    1d52:	045c                	.insn	2, 0x045c
    1d54:	1894                	.insn	2, 0x1894
    1d56:	18a4                	.insn	2, 0x18a4
    1d58:	5c01                	.insn	2, 0x5c01
    1d5a:	0400                	.insn	2, 0x0400
    1d5c:	0fb0                	.insn	2, 0x0fb0
    1d5e:	0fbc                	.insn	2, 0x0fbc
    1d60:	9002                	.insn	2, 0x9002
    1d62:	042e                	.insn	2, 0x042e
    1d64:	0fbc                	.insn	2, 0x0fbc
    1d66:	0fd8                	.insn	2, 0x0fd8
    1d68:	342fa50f          	.insn	4, 0x342fa50f
    1d6c:	007c                	.insn	2, 0x007c
    1d6e:	3ba8                	.insn	2, 0x3ba8
    1d70:	34a8                	.insn	2, 0x34a8
    1d72:	a51c                	.insn	2, 0xa51c
    1d74:	342c                	.insn	2, 0x342c
    1d76:	9f1e                	.insn	2, 0x9f1e
    1d78:	d804                	.insn	2, 0xd804
    1d7a:	0f0fdc0f          	.insn	4, 0x0f0fdc0f
    1d7e:	2fa5                	.insn	2, 0x2fa5
    1d80:	7c34                	.insn	2, 0x7c34
    1d82:	a87f a83b 1c34 2ca5 	.insn	14, 0x0fdc049f1e342ca51c34a83ba87f
    1d8a:	1e34 049f 0fdc 
    1d90:	10ac                	.insn	2, 0x10ac
    1d92:	a514                	.insn	2, 0xa514
    1d94:	2fa5342f          	.insn	4, 0x2fa5342f
    1d98:	a834                	.insn	2, 0xa834
    1d9a:	a800a83b          	.insn	4, 0xa800a83b
    1d9e:	1c34a83b          	.insn	4, 0x1c34a83b
    1da2:	2ca5                	.insn	2, 0x2ca5
    1da4:	1e34                	.insn	2, 0x1e34
    1da6:	049f 1588 159c      	.insn	6, 0x159c1588049f
    1dac:	342fa50f          	.insn	4, 0x342fa50f
    1db0:	007c                	.insn	2, 0x007c
    1db2:	3ba8                	.insn	2, 0x3ba8
    1db4:	34a8                	.insn	2, 0x34a8
    1db6:	a51c                	.insn	2, 0xa51c
    1db8:	342c                	.insn	2, 0x342c
    1dba:	9f1e                	.insn	2, 0x9f1e
    1dbc:	9c04                	.insn	2, 0x9c04
    1dbe:	a815                	.insn	2, 0xa815
    1dc0:	1415                	.insn	2, 0x1415
    1dc2:	2fa5                	.insn	2, 0x2fa5
    1dc4:	a534                	.insn	2, 0xa534
    1dc6:	3ba8342f          	.insn	4, 0x3ba8342f
    1dca:	00a8                	.insn	2, 0x00a8
    1dcc:	3ba8                	.insn	2, 0x3ba8
    1dce:	34a8                	.insn	2, 0x34a8
    1dd0:	a51c                	.insn	2, 0xa51c
    1dd2:	342c                	.insn	2, 0x342c
    1dd4:	9f1e                	.insn	2, 0x9f1e
    1dd6:	b404                	.insn	2, 0xb404
    1dd8:	1417f417          	auipc	s0,0x1417f
    1ddc:	2fa5                	.insn	2, 0x2fa5
    1dde:	a534                	.insn	2, 0xa534
    1de0:	3ba8342f          	.insn	4, 0x3ba8342f
    1de4:	00a8                	.insn	2, 0x00a8
    1de6:	3ba8                	.insn	2, 0x3ba8
    1de8:	34a8                	.insn	2, 0x34a8
    1dea:	a51c                	.insn	2, 0xa51c
    1dec:	342c                	.insn	2, 0x342c
    1dee:	9f1e                	.insn	2, 0x9f1e
    1df0:	9404                	.insn	2, 0x9404
    1df2:	a418                	.insn	2, 0xa418
    1df4:	0f18                	.insn	2, 0x0f18
    1df6:	2fa5                	.insn	2, 0x2fa5
    1df8:	7c34                	.insn	2, 0x7c34
    1dfa:	a800                	.insn	2, 0xa800
    1dfc:	1c34a83b          	.insn	4, 0x1c34a83b
    1e00:	2ca5                	.insn	2, 0x2ca5
    1e02:	1e34                	.insn	2, 0x1e34
    1e04:	009f b404 d40f      	.insn	6, 0xd40fb404009f
    1e0a:	0461010f          	.insn	4, 0x0461010f
    1e0e:	0fd4                	.insn	2, 0x0fd4
    1e10:	0fdc                	.insn	2, 0x0fdc
    1e12:	3002                	.insn	2, 0x3002
    1e14:	049f 0fdc 10a0      	.insn	6, 0x10a00fdc049f
    1e1a:	6101                	.insn	2, 0x6101
    1e1c:	a004                	.insn	2, 0xa004
    1e1e:	ac10                	.insn	2, 0xac10
    1e20:	0110                	.insn	2, 0x0110
    1e22:	0460                	.insn	2, 0x0460
    1e24:	1588                	.insn	2, 0x1588
    1e26:	15b8                	.insn	2, 0x15b8
    1e28:	6101                	.insn	2, 0x6101
    1e2a:	b404                	.insn	2, 0xb404
    1e2c:	0117c417          	auipc	s0,0x117c
    1e30:	0460                	.insn	2, 0x0460
    1e32:	1894                	.insn	2, 0x1894
    1e34:	18a0                	.insn	2, 0x18a0
    1e36:	6101                	.insn	2, 0x6101
    1e38:	a004                	.insn	2, 0xa004
    1e3a:	a418                	.insn	2, 0xa418
    1e3c:	0318                	.insn	2, 0x0318
    1e3e:	7f81                	.insn	2, 0x7f81
    1e40:	009f f004 840f      	.insn	6, 0x840ff004009f
    1e46:	0310                	.insn	2, 0x0310
    1e48:	049f7f7b          	.insn	4, 0x049f7f7b
    1e4c:	1084                	.insn	2, 0x1084
    1e4e:	10ac                	.insn	2, 0x10ac
    1e50:	5b01                	.insn	2, 0x5b01
    1e52:	b404                	.insn	2, 0xb404
    1e54:	0117bc17          	auipc	s8,0x117b
    1e58:	8c04005b          	.insn	4, 0x8c04005b
    1e5c:	ac11                	.insn	2, 0xac11
    1e5e:	0612                	.insn	2, 0x0612
    1e60:	001cdc03          	lhu	s8,1(s9)
    1e64:	9f80                	.insn	2, 0x9f80
    1e66:	0400                	.insn	2, 0x0400
    1e68:	118c                	.insn	2, 0x118c
    1e6a:	11d8                	.insn	2, 0x11d8
    1e6c:	3302                	.insn	2, 0x3302
    1e6e:	049f 11d8 11ec      	.insn	6, 0x11ec11d8049f
    1e74:	8709                	.insn	2, 0x8709
    1e76:	0300                	.insn	2, 0x0300
    1e78:	1cda                	.insn	2, 0x1cda
    1e7a:	8000                	.insn	2, 0x8000
    1e7c:	9f1c                	.insn	2, 0x9f1c
    1e7e:	ec04                	.insn	2, 0xec04
    1e80:	ac11                	.insn	2, 0xac11
    1e82:	0912                	.insn	2, 0x0912
    1e84:	d9030087          	.insn	4, 0xd9030087
    1e88:	001c                	.insn	2, 0x001c
    1e8a:	1c80                	.insn	2, 0x1c80
    1e8c:	009f 8c04 ac11      	.insn	6, 0xac118c04009f
    1e92:	0112                	.insn	2, 0x0112
    1e94:	0058                	.insn	2, 0x0058
    1e96:	8c04                	.insn	2, 0x8c04
    1e98:	ac11                	.insn	2, 0xac11
    1e9a:	0112                	.insn	2, 0x0112
    1e9c:	0059                	.insn	2, 0x0059
    1e9e:	8c04                	.insn	2, 0x8c04
    1ea0:	ac11                	.insn	2, 0xac11
    1ea2:	0111                	.insn	2, 0x0111
    1ea4:	045c                	.insn	2, 0x045c
    1ea6:	11ac                	.insn	2, 0x11ac
    1ea8:	11c8                	.insn	2, 0x11c8
    1eaa:	6701                	.insn	2, 0x6701
    1eac:	c804                	.insn	2, 0xc804
    1eae:	d811                	.insn	2, 0xd811
    1eb0:	0111                	.insn	2, 0x0111
    1eb2:	0466                	.insn	2, 0x0466
    1eb4:	11d8                	.insn	2, 0x11d8
    1eb6:	1284                	.insn	2, 0x1284
    1eb8:	6801                	.insn	2, 0x6801
    1eba:	8404                	.insn	2, 0x8404
    1ebc:	ac12                	.insn	2, 0xac12
    1ebe:	0112                	.insn	2, 0x0112
    1ec0:	0066                	.insn	2, 0x0066
    1ec2:	8c04                	.insn	2, 0x8c04
    1ec4:	ac11                	.insn	2, 0xac11
    1ec6:	0111                	.insn	2, 0x0111
    1ec8:	045d                	.insn	2, 0x045d
    1eca:	11ac                	.insn	2, 0x11ac
    1ecc:	12ac                	.insn	2, 0x12ac
    1ece:	6201                	.insn	2, 0x6201
    1ed0:	0400                	.insn	2, 0x0400
    1ed2:	118c                	.insn	2, 0x118c
    1ed4:	11ac                	.insn	2, 0x11ac
    1ed6:	6101                	.insn	2, 0x6101
    1ed8:	ac04                	.insn	2, 0xac04
    1eda:	ac11                	.insn	2, 0xac11
    1edc:	0112                	.insn	2, 0x0112
    1ede:	8c040063          	beq	s0,zero,f9e <main-0x7ffff062>
    1ee2:	fc11                	.insn	2, 0xfc11
    1ee4:	0111                	.insn	2, 0x0111
    1ee6:	0465                	.insn	2, 0x0465
    1ee8:	11fc                	.insn	2, 0x11fc
    1eea:	12ac                	.insn	2, 0x12ac
    1eec:	9102                	.insn	2, 0x9102
    1eee:	0000                	.insn	2, 0x
    1ef0:	8c04                	.insn	2, 0x8c04
    1ef2:	ac11                	.insn	2, 0xac11
    1ef4:	0111                	.insn	2, 0x0111
    1ef6:	045c                	.insn	2, 0x045c
    1ef8:	11ac                	.insn	2, 0x11ac
    1efa:	12ac                	.insn	2, 0x12ac
    1efc:	6401                	.insn	2, 0x6401
    1efe:	0400                	.insn	2, 0x0400
    1f00:	1198                	.insn	2, 0x1198
    1f02:	11ac                	.insn	2, 0x11ac
    1f04:	3302                	.insn	2, 0x3302
    1f06:	049f 11ac 11b8      	.insn	6, 0x11b811ac049f
    1f0c:	8708                	.insn	2, 0x8708
    1f0e:	8400                	.insn	2, 0x8400
    1f10:	1c00                	.insn	2, 0x1c00
    1f12:	049f0323          	sb	s1,70(t5)
    1f16:	11b8                	.insn	2, 0x11b8
    1f18:	7c0811c3          	.insn	4, 0x7c0811c3
    1f1c:	8400                	.insn	2, 0x8400
    1f1e:	1c00                	.insn	2, 0x1c00
    1f20:	049f0323          	sb	s1,70(t5)
    1f24:	11c411c3          	fmadd.s	ft3,fs0,ft8,ft2,rtz
    1f28:	8708                	.insn	2, 0x8708
    1f2a:	8400                	.insn	2, 0x8400
    1f2c:	1c00                	.insn	2, 0x1c00
    1f2e:	049f0223          	sb	s1,68(t5)
    1f32:	11c4                	.insn	2, 0x11c4
    1f34:	11c8                	.insn	2, 0x11c8
    1f36:	8708                	.insn	2, 0x8708
    1f38:	8400                	.insn	2, 0x8400
    1f3a:	1c00                	.insn	2, 0x1c00
    1f3c:	009f0323          	sb	s1,6(t5)
    1f40:	d804                	.insn	2, 0xd804
    1f42:	0114fc13          	andi	s8,s1,17
    1f46:	0058                	.insn	2, 0x0058
    1f48:	d804                	.insn	2, 0xd804
    1f4a:	0114fc13          	andi	s8,s1,17
    1f4e:	0059                	.insn	2, 0x0059
    1f50:	d804                	.insn	2, 0xd804
    1f52:	0113f813          	andi	a6,t2,17
    1f56:	045c                	.insn	2, 0x045c
    1f58:	13f8                	.insn	2, 0x13f8
    1f5a:	1494                	.insn	2, 0x1494
    1f5c:	6701                	.insn	2, 0x6701
    1f5e:	9404                	.insn	2, 0x9404
    1f60:	a814                	.insn	2, 0xa814
    1f62:	0114                	.insn	2, 0x0114
    1f64:	0466                	.insn	2, 0x0466
    1f66:	14a8                	.insn	2, 0x14a8
    1f68:	14bc                	.insn	2, 0x14bc
    1f6a:	860c                	.insn	2, 0x860c
    1f6c:	8700                	.insn	2, 0x8700
    1f6e:	1c00                	.insn	2, 0x1c00
    1f70:	001ce103          	.insn	4, 0x001ce103
    1f74:	2280                	.insn	2, 0x2280
    1f76:	049f 14bc 14cc      	.insn	6, 0x14cc14bc049f
    1f7c:	860c                	.insn	2, 0x860c
    1f7e:	8700                	.insn	2, 0x8700
    1f80:	1c00                	.insn	2, 0x1c00
    1f82:	001ce003          	.insn	4, 0x001ce003
    1f86:	2280                	.insn	2, 0x2280
    1f88:	049f 14cc 14d0      	.insn	6, 0x14d014cc049f
    1f8e:	860c                	.insn	2, 0x860c
    1f90:	8700                	.insn	2, 0x8700
    1f92:	1c00                	.insn	2, 0x1c00
    1f94:	001cdc03          	lhu	s8,1(s9)
    1f98:	2280                	.insn	2, 0x2280
    1f9a:	049f 14d0 14fc      	.insn	6, 0x14fc14d0049f
    1fa0:	6601                	.insn	2, 0x6601
    1fa2:	0400                	.insn	2, 0x0400
    1fa4:	13d8                	.insn	2, 0x13d8
    1fa6:	13f8                	.insn	2, 0x13f8
    1fa8:	5d01                	.insn	2, 0x5d01
    1faa:	f804                	.insn	2, 0xf804
    1fac:	0114fc13          	andi	s8,s1,17
    1fb0:	0062                	.insn	2, 0x0062
    1fb2:	d804                	.insn	2, 0xd804
    1fb4:	0614fc13          	andi	s8,s1,97
    1fb8:	001ce003          	.insn	4, 0x001ce003
    1fbc:	9f80                	.insn	2, 0x9f80
    1fbe:	0400                	.insn	2, 0x0400
    1fc0:	13d8                	.insn	2, 0x13d8
    1fc2:	14a8                	.insn	2, 0x14a8
    1fc4:	3402                	.insn	2, 0x3402
    1fc6:	049f 14a8 14bc      	.insn	6, 0x14bc14a8049f
    1fcc:	8709                	.insn	2, 0x8709
    1fce:	0300                	.insn	2, 0x0300
    1fd0:	1cdd                	.insn	2, 0x1cdd
    1fd2:	8000                	.insn	2, 0x8000
    1fd4:	9f1c                	.insn	2, 0x9f1c
    1fd6:	bc04                	.insn	2, 0xbc04
    1fd8:	fc14                	.insn	2, 0xfc14
    1fda:	0914                	.insn	2, 0x0914
    1fdc:	dc030087          	.insn	4, 0xdc030087
    1fe0:	001c                	.insn	2, 0x001c
    1fe2:	1c80                	.insn	2, 0x1c80
    1fe4:	009f d804 f813      	.insn	6, 0xf813d804009f
    1fea:	04610113          	addi	sp,sp,70 # 45a1d54 <main-0x7ba5e2ac>
    1fee:	13f8                	.insn	2, 0x13f8
    1ff0:	14fc                	.insn	2, 0x14fc
    1ff2:	6301                	.insn	2, 0x6301
    1ff4:	0400                	.insn	2, 0x0400
    1ff6:	13d8                	.insn	2, 0x13d8
    1ff8:	14c8                	.insn	2, 0x14c8
    1ffa:	6501                	.insn	2, 0x6501
    1ffc:	c804                	.insn	2, 0xc804
    1ffe:	fc14                	.insn	2, 0xfc14
    2000:	0214                	.insn	2, 0x0214
    2002:	0091                	.insn	2, 0x0091
    2004:	0400                	.insn	2, 0x0400
    2006:	13d8                	.insn	2, 0x13d8
    2008:	13f8                	.insn	2, 0x13f8
    200a:	5c01                	.insn	2, 0x5c01
    200c:	f804                	.insn	2, 0xf804
    200e:	0114fc13          	andi	s8,s1,17
    2012:	0064                	.insn	2, 0x0064
    2014:	e404                	.insn	2, 0xe404
    2016:	0213f813          	andi	a6,t2,33
    201a:	9f34                	.insn	2, 0x9f34
    201c:	f804                	.insn	2, 0xf804
    201e:	08148413          	addi	s0,s1,129
    2022:	00840087          	.insn	4, 0x00840087
    2026:	231c                	.insn	2, 0x231c
    2028:	9f04                	.insn	2, 0x9f04
    202a:	8404                	.insn	2, 0x8404
    202c:	8f14                	.insn	2, 0x8f14
    202e:	0814                	.insn	2, 0x0814
    2030:	007c                	.insn	2, 0x007c
    2032:	0084                	.insn	2, 0x0084
    2034:	231c                	.insn	2, 0x231c
    2036:	9f04                	.insn	2, 0x9f04
    2038:	8f04                	.insn	2, 0x8f04
    203a:	9014                	.insn	2, 0x9014
    203c:	0814                	.insn	2, 0x0814
    203e:	00840087          	.insn	4, 0x00840087
    2042:	231c                	.insn	2, 0x231c
    2044:	90049f03          	lh	t5,-1792(s1)
    2048:	9414                	.insn	2, 0x9414
    204a:	0814                	.insn	2, 0x0814
    204c:	00840087          	.insn	4, 0x00840087
    2050:	231c                	.insn	2, 0x231c
    2052:	9f04                	.insn	2, 0x9f04
    2054:	0400                	.insn	2, 0x0400
    2056:	18c4                	.insn	2, 0x18c4
    2058:	19e8                	.insn	2, 0x19e8
    205a:	5a01                	.insn	2, 0x5a01
    205c:	e804                	.insn	2, 0xe804
    205e:	f019                	.insn	2, 0xf019
    2060:	011c                	.insn	2, 0x011c
    2062:	0465                	.insn	2, 0x0465
    2064:	1cf0                	.insn	2, 0x1cf0
    2066:	5a011db7          	lui	s11,0x5a011
    206a:	b704                	.insn	2, 0xb704
    206c:	b81d                	.insn	2, 0xb81d
    206e:	0a1d                	.insn	2, 0x0a1d
    2070:	0aa503a3          	sb	a0,167(a0)
    2074:	a826                	.insn	2, 0xa826
    2076:	a82d                	.insn	2, 0xa82d
    2078:	9f00                	.insn	2, 0x9f00
    207a:	b804                	.insn	2, 0xb804
    207c:	c01d                	.insn	2, 0xc01d
    207e:	011f 0465 1fc0      	.insn	6, 0x1fc00465011f
    2084:	1fd4                	.insn	2, 0x1fd4
    2086:	a30a                	.insn	2, 0xa30a
    2088:	260aa503          	lw	a0,608(s5)
    208c:	2da8                	.insn	2, 0x2da8
    208e:	00a8                	.insn	2, 0x00a8
    2090:	049f 1fd4 2090      	.insn	6, 0x20901fd4049f
    2096:	6501                	.insn	2, 0x6501
    2098:	9004                	.insn	2, 0x9004
    209a:	a420                	.insn	2, 0xa420
    209c:	0120                	.insn	2, 0x0120
    209e:	045a                	.insn	2, 0x045a
    20a0:	20a4                	.insn	2, 0x20a4
    20a2:	20f0                	.insn	2, 0x20f0
    20a4:	6501                	.insn	2, 0x6501
    20a6:	0400                	.insn	2, 0x0400
    20a8:	18c4                	.insn	2, 0x18c4
    20aa:	19e8                	.insn	2, 0x19e8
    20ac:	5b01                	.insn	2, 0x5b01
    20ae:	e804                	.insn	2, 0xe804
    20b0:	9819                	.insn	2, 0x9819
    20b2:	011d                	.insn	2, 0x011d
    20b4:	0458                	.insn	2, 0x0458
    20b6:	1d98                	.insn	2, 0x1d98
    20b8:	5b011db7          	lui	s11,0x5b011
    20bc:	b704                	.insn	2, 0xb704
    20be:	b81d                	.insn	2, 0xb81d
    20c0:	0a1d                	.insn	2, 0x0a1d
    20c2:	0ba503a3          	sb	s10,167(a0)
    20c6:	a826                	.insn	2, 0xa826
    20c8:	a82d                	.insn	2, 0xa82d
    20ca:	9f00                	.insn	2, 0x9f00
    20cc:	b804                	.insn	2, 0xb804
    20ce:	a81d                	.insn	2, 0xa81d
    20d0:	011f 0458 1fa8      	.insn	6, 0x1fa80458011f
    20d6:	1fd4                	.insn	2, 0x1fd4
    20d8:	a30a                	.insn	2, 0xa30a
    20da:	260ba503          	lw	a0,608(s7)
    20de:	2da8                	.insn	2, 0x2da8
    20e0:	00a8                	.insn	2, 0x00a8
    20e2:	049f 1fd4 20f0      	.insn	6, 0x20f01fd4049f
    20e8:	5801                	.insn	2, 0x5801
    20ea:	0400                	.insn	2, 0x0400
    20ec:	18c4                	.insn	2, 0x18c4
    20ee:	19d0                	.insn	2, 0x19d0
    20f0:	5c01                	.insn	2, 0x5c01
    20f2:	d004                	.insn	2, 0xd004
    20f4:	f019                	.insn	2, 0xf019
    20f6:	011c                	.insn	2, 0x011c
    20f8:	0464                	.insn	2, 0x0464
    20fa:	1cf0                	.insn	2, 0x1cf0
    20fc:	1d8c                	.insn	2, 0x1d8c
    20fe:	5c01                	.insn	2, 0x5c01
    2100:	8c04                	.insn	2, 0x8c04
    2102:	941d                	.insn	2, 0x941d
    2104:	011d                	.insn	2, 0x011d
    2106:	0464                	.insn	2, 0x0464
    2108:	1d94                	.insn	2, 0x1d94
    210a:	5c011db7          	lui	s11,0x5c011
    210e:	b704                	.insn	2, 0xb704
    2110:	b81d                	.insn	2, 0xb81d
    2112:	0a1d                	.insn	2, 0x0a1d
    2114:	0ca503a3          	sb	a0,199(a0)
    2118:	a826                	.insn	2, 0xa826
    211a:	a82d                	.insn	2, 0xa82d
    211c:	9f00                	.insn	2, 0x9f00
    211e:	b804                	.insn	2, 0xb804
    2120:	fc1d                	.insn	2, 0xfc1d
    2122:	011e                	.insn	2, 0x011e
    2124:	0464                	.insn	2, 0x0464
    2126:	1efc                	.insn	2, 0x1efc
    2128:	1fd4                	.insn	2, 0x1fd4
    212a:	a30a                	.insn	2, 0xa30a
    212c:	260ca503          	lw	a0,608(s9)
    2130:	2da8                	.insn	2, 0x2da8
    2132:	00a8                	.insn	2, 0x00a8
    2134:	049f 1fd4 2090      	.insn	6, 0x20901fd4049f
    213a:	6401                	.insn	2, 0x6401
    213c:	9004                	.insn	2, 0x9004
    213e:	a420                	.insn	2, 0xa420
    2140:	0120                	.insn	2, 0x0120
    2142:	045c                	.insn	2, 0x045c
    2144:	20a4                	.insn	2, 0x20a4
    2146:	20f0                	.insn	2, 0x20f0
    2148:	6401                	.insn	2, 0x6401
    214a:	0400                	.insn	2, 0x0400
    214c:	18c4                	.insn	2, 0x18c4
    214e:	19dc                	.insn	2, 0x19dc
    2150:	5d01                	.insn	2, 0x5d01
    2152:	dc04                	.insn	2, 0xdc04
    2154:	a019                	.insn	2, 0xa019
    2156:	011d                	.insn	2, 0x011d
    2158:	0459                	.insn	2, 0x0459
    215a:	1da0                	.insn	2, 0x1da0
    215c:	5d011db7          	lui	s11,0x5d011
    2160:	b704                	.insn	2, 0xb704
    2162:	b81d                	.insn	2, 0xb81d
    2164:	0a1d                	.insn	2, 0x0a1d
    2166:	0da503a3          	sb	s10,199(a0)
    216a:	a826                	.insn	2, 0xa826
    216c:	a82d                	.insn	2, 0xa82d
    216e:	9f00                	.insn	2, 0x9f00
    2170:	b804                	.insn	2, 0xb804
    2172:	b81d                	.insn	2, 0xb81d
    2174:	011f 0459 1fb8      	.insn	6, 0x1fb80459011f
    217a:	1fd4                	.insn	2, 0x1fd4
    217c:	a30a                	.insn	2, 0xa30a
    217e:	260da503          	lw	a0,608(s11) # 5d011260 <main-0x22feeda0>
    2182:	2da8                	.insn	2, 0x2da8
    2184:	00a8                	.insn	2, 0x00a8
    2186:	049f 1fd4 20f0      	.insn	6, 0x20f01fd4049f
    218c:	5901                	.insn	2, 0x5901
    218e:	0400                	.insn	2, 0x0400
    2190:	18c4                	.insn	2, 0x18c4
    2192:	19c8                	.insn	2, 0x19c8
    2194:	5e06                	.insn	2, 0x5e06
    2196:	935f0493          	addi	s1,t5,-1739
    219a:	0404                	.insn	2, 0x0404
    219c:	19c8                	.insn	2, 0x19c8
    219e:	1cf0                	.insn	2, 0x1cf0
    21a0:	a306                	.insn	2, 0xa306
    21a2:	340ea503          	lw	a0,832(t4)
    21a6:	049f 1cf0 1cf8      	.insn	6, 0x1cf81cf0049f
    21ac:	5e06                	.insn	2, 0x5e06
    21ae:	935f0493          	addi	s1,t5,-1739
    21b2:	0404                	.insn	2, 0x0404
    21b4:	1cf8                	.insn	2, 0x1cf8
    21b6:	2090                	.insn	2, 0x2090
    21b8:	a306                	.insn	2, 0xa306
    21ba:	340ea503          	lw	a0,832(t4)
    21be:	049f 2090 209c      	.insn	6, 0x209c2090049f
    21c4:	5e06                	.insn	2, 0x5e06
    21c6:	935f0493          	addi	s1,t5,-1739
    21ca:	0404                	.insn	2, 0x0404
    21cc:	209c                	.insn	2, 0x209c
    21ce:	20f0                	.insn	2, 0x20f0
    21d0:	a306                	.insn	2, 0xa306
    21d2:	340ea503          	lw	a0,832(t4)
    21d6:	009f c404 d818      	.insn	6, 0xd818c404009f
    21dc:	0119                	.insn	2, 0x0119
    21de:	0460                	.insn	2, 0x0460
    21e0:	19d8                	.insn	2, 0x19d8
    21e2:	1cf0                	.insn	2, 0x1cf0
    21e4:	a30a                	.insn	2, 0xa30a
    21e6:	2610a503          	lw	a0,609(ra)
    21ea:	2da8                	.insn	2, 0x2da8
    21ec:	00a8                	.insn	2, 0x00a8
    21ee:	049f 1cf0 1d94      	.insn	6, 0x1d941cf0049f
    21f4:	6001                	.insn	2, 0x6001
    21f6:	9404                	.insn	2, 0x9404
    21f8:	901d                	.insn	2, 0x901d
    21fa:	0a20                	.insn	2, 0x0a20
    21fc:	10a503a3          	sb	a0,263(a0)
    2200:	a826                	.insn	2, 0xa826
    2202:	a82d                	.insn	2, 0xa82d
    2204:	9f00                	.insn	2, 0x9f00
    2206:	9004                	.insn	2, 0x9004
    2208:	a420                	.insn	2, 0xa420
    220a:	0120                	.insn	2, 0x0120
    220c:	0460                	.insn	2, 0x0460
    220e:	20a4                	.insn	2, 0x20a4
    2210:	20f0                	.insn	2, 0x20f0
    2212:	a30a                	.insn	2, 0xa30a
    2214:	2610a503          	lw	a0,609(ra)
    2218:	2da8                	.insn	2, 0x2da8
    221a:	00a8                	.insn	2, 0x00a8
    221c:	009f c404 e818      	.insn	6, 0xe818c404009f
    2222:	0119                	.insn	2, 0x0119
    2224:	0461                	.insn	2, 0x0461
    2226:	19e8                	.insn	2, 0x19e8
    2228:	1cf0                	.insn	2, 0x1cf0
    222a:	6601                	.insn	2, 0x6601
    222c:	f004                	.insn	2, 0xf004
    222e:	841c                	.insn	2, 0x841c
    2230:	011d                	.insn	2, 0x011d
    2232:	0461                	.insn	2, 0x0461
    2234:	1d84                	.insn	2, 0x1d84
    2236:	1d94                	.insn	2, 0x1d94
    2238:	6601                	.insn	2, 0x6601
    223a:	9404                	.insn	2, 0x9404
    223c:	b71d                	.insn	2, 0xb71d
    223e:	011d                	.insn	2, 0x011d
    2240:	0461                	.insn	2, 0x0461
    2242:	1db81db7          	lui	s11,0x1db81
    2246:	a30a                	.insn	2, 0xa30a
    2248:	2611a503          	lw	a0,609(gp) # 80003a61 <__global_pointer$+0x261>
    224c:	2da8                	.insn	2, 0x2da8
    224e:	00a8                	.insn	2, 0x00a8
    2250:	049f 1db8 1fc4      	.insn	6, 0x1fc41db8049f
    2256:	6601                	.insn	2, 0x6601
    2258:	c404                	.insn	2, 0xc404
    225a:	d41f 0a1f 03a3      	.insn	6, 0x03a30a1fd41f
    2260:	11a5                	.insn	2, 0x11a5
    2262:	a826                	.insn	2, 0xa826
    2264:	a82d                	.insn	2, 0xa82d
    2266:	9f00                	.insn	2, 0x9f00
    2268:	d404                	.insn	2, 0xd404
    226a:	901f 0120 0466      	.insn	6, 0x04660120901f
    2270:	2090                	.insn	2, 0x2090
    2272:	20a4                	.insn	2, 0x20a4
    2274:	6101                	.insn	2, 0x6101
    2276:	a404                	.insn	2, 0xa404
    2278:	f020                	.insn	2, 0xf020
    227a:	0120                	.insn	2, 0x0120
    227c:	0066                	.insn	2, 0x0066
    227e:	c404                	.insn	2, 0xc404
    2280:	ec18                	.insn	2, 0xec18
    2282:	021c                	.insn	2, 0x021c
    2284:	0091                	.insn	2, 0x0091
    2286:	ec04                	.insn	2, 0xec04
    2288:	a41c                	.insn	2, 0xa41c
    228a:	011d                	.insn	2, 0x011d
    228c:	0462                	.insn	2, 0x0462
    228e:	1db8                	.insn	2, 0x1db8
    2290:	1eb0                	.insn	2, 0x1eb0
    2292:	6201                	.insn	2, 0x6201
    2294:	b004                	.insn	2, 0xb004
    2296:	d01e                	.insn	2, 0xd01e
    2298:	021f 0091 d004      	.insn	6, 0xd0040091021f
    229e:	d41f 021f 0072      	.insn	6, 0x0072021fd41f
    22a4:	d404                	.insn	2, 0xd404
    22a6:	f01f 0120 0062      	.insn	6, 0x00620120f01f
    22ac:	bc04                	.insn	2, 0xbc04
    22ae:	e819                	.insn	2, 0xe819
    22b0:	0119                	.insn	2, 0x0119
    22b2:	045a                	.insn	2, 0x045a
    22b4:	19e8                	.insn	2, 0x19e8
    22b6:	1cf0                	.insn	2, 0x1cf0
    22b8:	6501                	.insn	2, 0x6501
    22ba:	b804                	.insn	2, 0xb804
    22bc:	c01d                	.insn	2, 0xc01d
    22be:	011f 0465 1fc0      	.insn	6, 0x1fc00465011f
    22c4:	1fd4                	.insn	2, 0x1fd4
    22c6:	a30a                	.insn	2, 0xa30a
    22c8:	260aa503          	lw	a0,608(s5)
    22cc:	2da8                	.insn	2, 0x2da8
    22ce:	00a8                	.insn	2, 0x00a8
    22d0:	049f 1fd4 2090      	.insn	6, 0x20901fd4049f
    22d6:	6501                	.insn	2, 0x6501
    22d8:	9004                	.insn	2, 0x9004
    22da:	a420                	.insn	2, 0xa420
    22dc:	0120                	.insn	2, 0x0120
    22de:	045a                	.insn	2, 0x045a
    22e0:	20a4                	.insn	2, 0x20a4
    22e2:	20f0                	.insn	2, 0x20f0
    22e4:	6501                	.insn	2, 0x6501
    22e6:	0400                	.insn	2, 0x0400
    22e8:	19bc                	.insn	2, 0x19bc
    22ea:	19e8                	.insn	2, 0x19e8
    22ec:	5b01                	.insn	2, 0x5b01
    22ee:	e804                	.insn	2, 0xe804
    22f0:	f019                	.insn	2, 0xf019
    22f2:	011c                	.insn	2, 0x011c
    22f4:	0458                	.insn	2, 0x0458
    22f6:	1db8                	.insn	2, 0x1db8
    22f8:	1fa8                	.insn	2, 0x1fa8
    22fa:	5801                	.insn	2, 0x5801
    22fc:	a804                	.insn	2, 0xa804
    22fe:	d41f 0a1f 03a3      	.insn	6, 0x03a30a1fd41f
    2304:	0ba5                	.insn	2, 0x0ba5
    2306:	a826                	.insn	2, 0xa826
    2308:	a82d                	.insn	2, 0xa82d
    230a:	9f00                	.insn	2, 0x9f00
    230c:	d404                	.insn	2, 0xd404
    230e:	f01f 0120 0058      	.insn	6, 0x00580120f01f
    2314:	bc04                	.insn	2, 0xbc04
    2316:	d019                	.insn	2, 0xd019
    2318:	0119                	.insn	2, 0x0119
    231a:	045c                	.insn	2, 0x045c
    231c:	19d0                	.insn	2, 0x19d0
    231e:	1cf0                	.insn	2, 0x1cf0
    2320:	6401                	.insn	2, 0x6401
    2322:	b804                	.insn	2, 0xb804
    2324:	981d                	.insn	2, 0x981d
    2326:	011e                	.insn	2, 0x011e
    2328:	0464                	.insn	2, 0x0464
    232a:	1e98                	.insn	2, 0x1e98
    232c:	1e9c                	.insn	2, 0x1e9c
    232e:	5a01                	.insn	2, 0x5a01
    2330:	9c04                	.insn	2, 0x9c04
    2332:	b01e                	.insn	2, 0xb01e
    2334:	011e                	.insn	2, 0x011e
    2336:	045c                	.insn	2, 0x045c
    2338:	1eb0                	.insn	2, 0x1eb0
    233a:	1ef4                	.insn	2, 0x1ef4
    233c:	6201                	.insn	2, 0x6201
    233e:	f404                	.insn	2, 0xf404
    2340:	801e                	.insn	2, 0x801e
    2342:	011f 045a 1f80      	.insn	6, 0x1f80045a011f
    2348:	1fcc                	.insn	2, 0x1fcc
    234a:	6201                	.insn	2, 0x6201
    234c:	cc04                	.insn	2, 0xcc04
    234e:	d41f 011f 045a      	.insn	6, 0x045a011fd41f
    2354:	1fd4                	.insn	2, 0x1fd4
    2356:	2090                	.insn	2, 0x2090
    2358:	6401                	.insn	2, 0x6401
    235a:	9004                	.insn	2, 0x9004
    235c:	a420                	.insn	2, 0xa420
    235e:	0120                	.insn	2, 0x0120
    2360:	045c                	.insn	2, 0x045c
    2362:	20a4                	.insn	2, 0x20a4
    2364:	20f0                	.insn	2, 0x20f0
    2366:	6401                	.insn	2, 0x6401
    2368:	0400                	.insn	2, 0x0400
    236a:	19bc                	.insn	2, 0x19bc
    236c:	19dc                	.insn	2, 0x19dc
    236e:	5d01                	.insn	2, 0x5d01
    2370:	dc04                	.insn	2, 0xdc04
    2372:	f019                	.insn	2, 0xf019
    2374:	011c                	.insn	2, 0x011c
    2376:	0459                	.insn	2, 0x0459
    2378:	1db8                	.insn	2, 0x1db8
    237a:	1fb8                	.insn	2, 0x1fb8
    237c:	5901                	.insn	2, 0x5901
    237e:	b804                	.insn	2, 0xb804
    2380:	d41f 0a1f 03a3      	.insn	6, 0x03a30a1fd41f
    2386:	0da5                	.insn	2, 0x0da5
    2388:	a826                	.insn	2, 0xa826
    238a:	a82d                	.insn	2, 0xa82d
    238c:	9f00                	.insn	2, 0x9f00
    238e:	d404                	.insn	2, 0xd404
    2390:	f01f 0120 0059      	.insn	6, 0x00590120f01f
    2396:	bc04                	.insn	2, 0xbc04
    2398:	cc19                	.insn	2, 0xcc19
    239a:	0219                	.insn	2, 0x0219
    239c:	2f90                	.insn	2, 0x2f90
    239e:	cc04                	.insn	2, 0xcc04
    23a0:	bc19                	.insn	2, 0xbc19
    23a2:	061c                	.insn	2, 0x061c
    23a4:	935e                	.insn	2, 0x935e
    23a6:	5f04                	.insn	2, 0x5f04
    23a8:	b8040493          	addi	s1,s0,-1152 # 117d9ac <main-0x7ee82654>
    23ac:	e01d                	.insn	2, 0xe01d
    23ae:	061d                	.insn	2, 0x061d
    23b0:	935e                	.insn	2, 0x935e
    23b2:	5f04                	.insn	2, 0x5f04
    23b4:	e4040493          	addi	s1,s0,-448
    23b8:	f41d                	.insn	2, 0xf41d
    23ba:	061d                	.insn	2, 0x061d
    23bc:	935e                	.insn	2, 0x935e
    23be:	5f04                	.insn	2, 0x5f04
    23c0:	d4040493          	addi	s1,s0,-704
    23c4:	901f 0620 935e      	.insn	6, 0x935e0620901f
    23ca:	5f04                	.insn	2, 0x5f04
    23cc:	90040493          	addi	s1,s0,-1792
    23d0:	a020                	.insn	2, 0xa020
    23d2:	0220                	.insn	2, 0x0220
    23d4:	2f90                	.insn	2, 0x2f90
    23d6:	a004                	.insn	2, 0xa004
    23d8:	c420                	.insn	2, 0xc420
    23da:	0620                	.insn	2, 0x0620
    23dc:	935e                	.insn	2, 0x935e
    23de:	5f04                	.insn	2, 0x5f04
    23e0:	cc040493          	addi	s1,s0,-832
    23e4:	e820                	.insn	2, 0xe820
    23e6:	0620                	.insn	2, 0x0620
    23e8:	935e                	.insn	2, 0x935e
    23ea:	5f04                	.insn	2, 0x5f04
    23ec:	04000493          	addi	s1,zero,64
    23f0:	19bc                	.insn	2, 0x19bc
    23f2:	1ca8                	.insn	2, 0x1ca8
    23f4:	6001                	.insn	2, 0x6001
    23f6:	b804                	.insn	2, 0xb804
    23f8:	c41d                	.insn	2, 0xc41d
    23fa:	011d                	.insn	2, 0x011d
    23fc:	0460                	.insn	2, 0x0460
    23fe:	1fd4                	.insn	2, 0x1fd4
    2400:	1fec                	.insn	2, 0x1fec
    2402:	6001                	.insn	2, 0x6001
    2404:	fc04                	.insn	2, 0xfc04
    2406:	901f 0220 9f30      	.insn	6, 0x9f300220901f
    240c:	9004                	.insn	2, 0x9004
    240e:	a420                	.insn	2, 0xa420
    2410:	0120                	.insn	2, 0x0120
    2412:	0060                	.insn	2, 0x0060
    2414:	bc04                	.insn	2, 0xbc04
    2416:	e819                	.insn	2, 0xe819
    2418:	0119                	.insn	2, 0x0119
    241a:	0461                	.insn	2, 0x0461
    241c:	19e8                	.insn	2, 0x19e8
    241e:	1cf0                	.insn	2, 0x1cf0
    2420:	6601                	.insn	2, 0x6601
    2422:	b804                	.insn	2, 0xb804
    2424:	c41d                	.insn	2, 0xc41d
    2426:	011f 0466 1fc4      	.insn	6, 0x1fc40466011f
    242c:	1fd4                	.insn	2, 0x1fd4
    242e:	a30a                	.insn	2, 0xa30a
    2430:	2611a503          	lw	a0,609(gp) # 80003a61 <__global_pointer$+0x261>
    2434:	2da8                	.insn	2, 0x2da8
    2436:	00a8                	.insn	2, 0x00a8
    2438:	049f 1fd4 2090      	.insn	6, 0x20901fd4049f
    243e:	6601                	.insn	2, 0x6601
    2440:	9004                	.insn	2, 0x9004
    2442:	a420                	.insn	2, 0xa420
    2444:	0120                	.insn	2, 0x0120
    2446:	0461                	.insn	2, 0x0461
    2448:	20a4                	.insn	2, 0x20a4
    244a:	20f0                	.insn	2, 0x20f0
    244c:	6601                	.insn	2, 0x6601
    244e:	0400                	.insn	2, 0x0400
    2450:	19bc                	.insn	2, 0x19bc
    2452:	1ca8                	.insn	2, 0x1ca8
    2454:	9102                	.insn	2, 0x9102
    2456:	0400                	.insn	2, 0x0400
    2458:	1ca8                	.insn	2, 0x1ca8
    245a:	1cec                	.insn	2, 0x1cec
    245c:	9108                	.insn	2, 0x9108
    245e:	0600                	.insn	2, 0x0600
    2460:	000a                	.insn	2, 0x000a
    2462:	2104                	.insn	2, 0x2104
    2464:	049f 1cec 1cf0      	.insn	6, 0x1cf01cec049f
    246a:	0a008207          	.insn	4, 0x0a008207
    246e:	0400                	.insn	2, 0x0400
    2470:	9f21                	.insn	2, 0x9f21
    2472:	b804                	.insn	2, 0xb804
    2474:	b01d                	.insn	2, 0xb01d
    2476:	011e                	.insn	2, 0x011e
    2478:	0462                	.insn	2, 0x0462
    247a:	1eb0                	.insn	2, 0x1eb0
    247c:	1fd0                	.insn	2, 0x1fd0
    247e:	9102                	.insn	2, 0x9102
    2480:	0400                	.insn	2, 0x0400
    2482:	1fd0                	.insn	2, 0x1fd0
    2484:	1fd4                	.insn	2, 0x1fd4
    2486:	7202                	.insn	2, 0x7202
    2488:	0400                	.insn	2, 0x0400
    248a:	1fd4                	.insn	2, 0x1fd4
    248c:	20a4                	.insn	2, 0x20a4
    248e:	6201                	.insn	2, 0x6201
    2490:	a404                	.insn	2, 0xa404
    2492:	cc20                	.insn	2, 0xcc20
    2494:	0720                	.insn	2, 0x0720
    2496:	0082                	.insn	2, 0x0082
    2498:	000a                	.insn	2, 0x000a
    249a:	2104                	.insn	2, 0x2104
    249c:	049f 20cc 20f0      	.insn	6, 0x20f020cc049f
    24a2:	6201                	.insn	2, 0x6201
    24a4:	0400                	.insn	2, 0x0400
    24a6:	19bc                	.insn	2, 0x19bc
    24a8:	1cbc                	.insn	2, 0x1cbc
    24aa:	a510                	.insn	2, 0xa510
    24ac:	34a4342f          	.insn	4, 0x34a4342f
    24b0:	0008                	.insn	2, 0x0008
    24b2:	0000                	.insn	2, 0x
    24b4:	0000                	.insn	2, 0x
    24b6:	0000                	.insn	2, 0x
    24b8:	2d00                	.insn	2, 0x2d00
    24ba:	049f 1db8 1df4      	.insn	6, 0x1df41db8049f
    24c0:	a510                	.insn	2, 0xa510
    24c2:	34a4342f          	.insn	4, 0x34a4342f
    24c6:	0008                	.insn	2, 0x0008
    24c8:	0000                	.insn	2, 0x
    24ca:	0000                	.insn	2, 0x
    24cc:	0000                	.insn	2, 0x
    24ce:	2d00                	.insn	2, 0x2d00
    24d0:	049f 1fd4 20b0      	.insn	6, 0x20b01fd4049f
    24d6:	a510                	.insn	2, 0xa510
    24d8:	34a4342f          	.insn	4, 0x34a4342f
    24dc:	0008                	.insn	2, 0x0008
    24de:	0000                	.insn	2, 0x
    24e0:	0000                	.insn	2, 0x
    24e2:	0000                	.insn	2, 0x
    24e4:	2d00                	.insn	2, 0x2d00
    24e6:	049f 20cc 20d8      	.insn	6, 0x20d820cc049f
    24ec:	a510                	.insn	2, 0xa510
    24ee:	34a4342f          	.insn	4, 0x34a4342f
    24f2:	0008                	.insn	2, 0x0008
    24f4:	0000                	.insn	2, 0x
    24f6:	0000                	.insn	2, 0x
    24f8:	0000                	.insn	2, 0x
    24fa:	2d00                	.insn	2, 0x2d00
    24fc:	009f f804 b01a      	.insn	6, 0xb01af804009f
    2502:	007d0e1b          	.insn	4, 0x007d0e1b
    2506:	3ba8                	.insn	2, 0x3ba8
    2508:	26a8                	.insn	2, 0x26a8
    250a:	3408                	.insn	2, 0x3408
    250c:	26a8                	.insn	2, 0x26a8
    250e:	9f24                	.insn	2, 0x9f24
    2510:	b0040893          	addi	a7,s0,-1280
    2514:	041bc01b          	.insn	4, 0x041bc01b
    2518:	2e90                	.insn	2, 0x2e90
    251a:	04000893          	addi	a7,zero,64
    251e:	1adc                	.insn	2, 0x1adc
    2520:	1ae4                	.insn	2, 0x1ae4
    2522:	5d01                	.insn	2, 0x5d01
    2524:	e404                	.insn	2, 0xe404
    2526:	b81a                	.insn	2, 0xb81a
    2528:	817d041b          	.insn	4, 0x817d041b
    252c:	9f78                	.insn	2, 0x9f78
    252e:	0400                	.insn	2, 0x0400
    2530:	1abc                	.insn	2, 0x1abc
    2532:	1ca8                	.insn	2, 0x1ca8
    2534:	6701                	.insn	2, 0x6701
    2536:	a804                	.insn	2, 0xa804
    2538:	f01c                	.insn	2, 0xf01c
    253a:	021c                	.insn	2, 0x021c
    253c:	9f30                	.insn	2, 0x9f30
    253e:	b804                	.insn	2, 0xb804
    2540:	b01d                	.insn	2, 0xb01d
    2542:	011f 0467 1fd4      	.insn	6, 0x1fd40467011f
    2548:	2090                	.insn	2, 0x2090
    254a:	6701                	.insn	2, 0x6701
    254c:	a404                	.insn	2, 0xa404
    254e:	cc20                	.insn	2, 0xcc20
    2550:	0220                	.insn	2, 0x0220
    2552:	9f30                	.insn	2, 0x9f30
    2554:	cc04                	.insn	2, 0xcc04
    2556:	f020                	.insn	2, 0xf020
    2558:	0120                	.insn	2, 0x0120
    255a:	f8040067          	jalr	zero,-128(s0)
    255e:	941a                	.insn	2, 0x941a
    2560:	2c90021b          	.insn	4, 0x2c90021b
    2564:	0400                	.insn	2, 0x0400
    2566:	1be0                	.insn	2, 0x1be0
    2568:	1ca8                	.insn	2, 0x1ca8
    256a:	6301                	.insn	2, 0x6301
    256c:	a804                	.insn	2, 0xa804
    256e:	f01c                	.insn	2, 0xf01c
    2570:	021c                	.insn	2, 0x021c
    2572:	9f30                	.insn	2, 0x9f30
    2574:	b804                	.insn	2, 0xb804
    2576:	c41d                	.insn	2, 0xc41d
    2578:	011e                	.insn	2, 0x011e
    257a:	1ec40463          	beq	s0,a2,2762 <main-0x7fffd89e>
    257e:	1fac                	.insn	2, 0x1fac
    2580:	9f018303          	lb	t1,-1552(gp) # 800031f0 <__BSS_END__+0x150>
    2584:	ac04                	.insn	2, 0xac04
    2586:	b01f 101f e387      	.insn	6, 0xe387101fb01f
    258c:	4000                	.insn	2, 0x4000
    258e:	0c22244b          	.insn	4, 0x0c22244b
    2592:	00c6                	.insn	2, 0x00c6
    2594:	8000                	.insn	2, 0x8000
    2596:	9f04232b          	.insn	4, 0x9f04232b
    259a:	d404                	.insn	2, 0xd404
    259c:	901f 0120 0463      	.insn	6, 0x04630120901f
    25a2:	20a4                	.insn	2, 0x20a4
    25a4:	20cc                	.insn	2, 0x20cc
    25a6:	3002                	.insn	2, 0x3002
    25a8:	049f 20cc 20f0      	.insn	6, 0x20f020cc049f
    25ae:	6301                	.insn	2, 0x6301
    25b0:	0400                	.insn	2, 0x0400
    25b2:	1db8                	.insn	2, 0x1db8
    25b4:	1dbc                	.insn	2, 0x1dbc
    25b6:	6601                	.insn	2, 0x6601
    25b8:	bc04                	.insn	2, 0xbc04
    25ba:	c41d                	.insn	2, 0xc41d
    25bc:	061d                	.insn	2, 0x061d
    25be:	0086                	.insn	2, 0x0086
    25c0:	9f1c0083          	lb	ra,-1551(s8) # 117c845 <main-0x7ee837bb>
    25c4:	c404                	.insn	2, 0xc404
    25c6:	e41d                	.insn	2, 0xe41d
    25c8:	011d                	.insn	2, 0x011d
    25ca:	0461                	.insn	2, 0x0461
    25cc:	1fe0                	.insn	2, 0x1fe0
    25ce:	1fe4                	.insn	2, 0x1fe4
    25d0:	6601                	.insn	2, 0x6601
    25d2:	e404                	.insn	2, 0xe404
    25d4:	ec1f 061f 0086      	.insn	6, 0x0086061fec1f
    25da:	9f1c0083          	lb	ra,-1551(s8)
    25de:	fc04                	.insn	2, 0xfc04
    25e0:	801f 0120 0466      	.insn	6, 0x04660120801f
    25e6:	2080                	.insn	2, 0x2080
    25e8:	2090                	.insn	2, 0x2090
    25ea:	8606                	.insn	2, 0x8606
    25ec:	8300                	.insn	2, 0x8300
    25ee:	1c00                	.insn	2, 0x1c00
    25f0:	009f a804 f01c      	.insn	6, 0xf01ca804009f
    25f6:	011c                	.insn	2, 0x011c
    25f8:	0464                	.insn	2, 0x0464
    25fa:	1de4                	.insn	2, 0x1de4
    25fc:	1efc                	.insn	2, 0x1efc
    25fe:	6401                	.insn	2, 0x6401
    2600:	fc04                	.insn	2, 0xfc04
    2602:	d41e                	.insn	2, 0xd41e
    2604:	0a1f 03a3 0ca5      	.insn	6, 0x0ca503a30a1f
    260a:	a826                	.insn	2, 0xa826
    260c:	a82d                	.insn	2, 0xa82d
    260e:	9f00                	.insn	2, 0x9f00
    2610:	a404                	.insn	2, 0xa404
    2612:	f020                	.insn	2, 0xf020
    2614:	0120                	.insn	2, 0x0120
    2616:	0064                	.insn	2, 0x0064
    2618:	d804                	.insn	2, 0xd804
    261a:	0133dc33          	srl	s8,t2,s3
    261e:	045a                	.insn	2, 0x045a
    2620:	33dc                	.insn	2, 0x33dc
    2622:	33e0                	.insn	2, 0x33e0
    2624:	9f307a03          	.insn	4, 0x9f307a03
	...

Disassembly of section .debug_rnglists:

00000000 <.debug_rnglists>:
   0:	0000000f          	fence	unknown,unknown
   4:	0005                	.insn	2, 0x0005
   6:	0004                	.insn	2, 0x0004
   8:	0000                	.insn	2, 0x
   a:	0000                	.insn	2, 0x
   c:	00000007          	.insn	4, 0x0007
  10:	3080                	.insn	2, 0x3080
  12:	f300                	.insn	2, 0xf300
  14:	0001                	.insn	2, 0x0001
  16:	0500                	.insn	2, 0x0500
  18:	0400                	.insn	2, 0x0400
  1a:	0000                	.insn	2, 0x
  1c:	0000                	.insn	2, 0x
  1e:	0400                	.insn	2, 0x0400
  20:	03a0                	.insn	2, 0x03a0
  22:	03ac                	.insn	2, 0x03ac
  24:	fc04                	.insn	2, 0xfc04
  26:	0404f403          	.insn	4, 0x0404f403
  2a:	05a0                	.insn	2, 0x05a0
  2c:	05c8                	.insn	2, 0x05c8
  2e:	cc04                	.insn	2, 0xcc04
  30:	d005                	.insn	2, 0xd005
  32:	0405                	.insn	2, 0x0405
  34:	05d8                	.insn	2, 0x05d8
  36:	07bc                	.insn	2, 0x07bc
  38:	e404                	.insn	2, 0xe404
  3a:	0409d807          	.insn	4, 0x0409d807
  3e:	09dc                	.insn	2, 0x09dc
  40:	09e0                	.insn	2, 0x09e0
  42:	f004                	.insn	2, 0xf004
  44:	c009                	.insn	2, 0xc009
  46:	040a                	.insn	2, 0x040a
  48:	0ac4                	.insn	2, 0x0ac4
  4a:	0ac8                	.insn	2, 0x0ac8
  4c:	d404                	.insn	2, 0xd404
  4e:	e40a                	.insn	2, 0xe40a
  50:	0be8040b          	.insn	4, 0x0be8040b
  54:	0bec                	.insn	2, 0x0bec
  56:	f404                	.insn	2, 0xf404
  58:	040cd00b          	.insn	4, 0x040cd00b
  5c:	0cd8                	.insn	2, 0x0cd8
  5e:	0da8                	.insn	2, 0x0da8
  60:	0400                	.insn	2, 0x0400
  62:	03ac                	.insn	2, 0x03ac
  64:	03bc                	.insn	2, 0x03bc
  66:	c804                	.insn	2, 0xc804
  68:	0403cc03          	lbu	s8,64(t2)
  6c:	03cc                	.insn	2, 0x03cc
  6e:	03f8                	.insn	2, 0x03f8
  70:	0400                	.insn	2, 0x0400
  72:	0e98                	.insn	2, 0x0e98
  74:	10c4                	.insn	2, 0x10c4
  76:	d004                	.insn	2, 0xd004
  78:	d810                	.insn	2, 0xd810
  7a:	0410                	.insn	2, 0x0410
  7c:	10e0                	.insn	2, 0x10e0
  7e:	10e8                	.insn	2, 0x10e8
  80:	f004                	.insn	2, 0xf004
  82:	f410                	.insn	2, 0xf410
  84:	0410                	.insn	2, 0x0410
  86:	10fc                	.insn	2, 0x10fc
  88:	118c                	.insn	2, 0x118c
  8a:	e404                	.insn	2, 0xe404
  8c:	8812                	.insn	2, 0x8812
  8e:	138c0413          	addi	s0,s8,312
  92:	1398                	.insn	2, 0x1398
  94:	a404                	.insn	2, 0xa404
  96:	0413ac13          	slti	s8,t2,65
  9a:	13b4                	.insn	2, 0x13b4
  9c:	13bc                	.insn	2, 0x13bc
  9e:	c804                	.insn	2, 0xc804
  a0:	0413d813          	.insn	4, 0x0413d813
  a4:	1580                	.insn	2, 0x1580
  a6:	18c4                	.insn	2, 0x18c4
  a8:	0400                	.insn	2, 0x0400
  aa:	0fe0                	.insn	2, 0x0fe0
  ac:	10ac                	.insn	2, 0x10ac
  ae:	b404                	.insn	2, 0xb404
  b0:	0017f417          	auipc	s0,0x17f
  b4:	9004                	.insn	2, 0x9004
  b6:	9411                	.insn	2, 0x9411
  b8:	0411                	.insn	2, 0x0411
  ba:	1198                	.insn	2, 0x1198
  bc:	11c8                	.insn	2, 0x11c8
  be:	d404                	.insn	2, 0xd404
  c0:	d811                	.insn	2, 0xd811
  c2:	0011                	.insn	2, 0x0011
  c4:	dc04                	.insn	2, 0xdc04
  c6:	0413e013          	ori	zero,t2,65
  ca:	13e4                	.insn	2, 0x13e4
  cc:	1494                	.insn	2, 0x1494
  ce:	9c04                	.insn	2, 0x9c04
  d0:	a814                	.insn	2, 0xa814
  d2:	0014                	.insn	2, 0x0014
  d4:	a804                	.insn	2, 0xa804
  d6:	f019                	.insn	2, 0xf019
  d8:	041c                	.insn	2, 0x041c
  da:	1db4                	.insn	2, 0x1db4
  dc:	1fa0                	.insn	2, 0x1fa0
  de:	d404                	.insn	2, 0xd404
  e0:	f01f 0020 8c04      	.insn	6, 0x8c040020f01f
  e6:	9022                	.insn	2, 0x9022
  e8:	0422                	.insn	2, 0x0422
  ea:	269c                	.insn	2, 0x269c
  ec:	26a8                	.insn	2, 0x26a8
  ee:	ac04                	.insn	2, 0xac04
  f0:	b826                	.insn	2, 0xb826
  f2:	0426                	.insn	2, 0x0426
  f4:	26bc                	.insn	2, 0x26bc
  f6:	26d0                	.insn	2, 0x26d0
  f8:	0400                	.insn	2, 0x0400
  fa:	2380                	.insn	2, 0x2380
  fc:	2384                	.insn	2, 0x2384
  fe:	d404                	.insn	2, 0xd404
 100:	d826                	.insn	2, 0xd826
 102:	0426                	.insn	2, 0x0426
 104:	26ec                	.insn	2, 0x26ec
 106:	26f0                	.insn	2, 0x26f0
 108:	9c04                	.insn	2, 0x9c04
 10a:	a029                	.insn	2, 0xa029
 10c:	0429                	.insn	2, 0x0429
 10e:	29a4                	.insn	2, 0x29a4
 110:	29a8                	.insn	2, 0x29a8
 112:	e404                	.insn	2, 0xe404
 114:	042cdc2b          	.insn	4, 0x042cdc2b
 118:	2ecc                	.insn	2, 0x2ecc
 11a:	2fbc                	.insn	2, 0x2fbc
 11c:	c404                	.insn	2, 0xc404
 11e:	042fd82f          	.insn	4, 0x042fd82f
 122:	2fec                	.insn	2, 0x2fec
 124:	2ff8                	.insn	2, 0x2ff8
 126:	dc04                	.insn	2, 0xdc04
 128:	9030                	.insn	2, 0x9030
 12a:	0431                	.insn	2, 0x0431
 12c:	3280                	.insn	2, 0x3280
 12e:	328c                	.insn	2, 0x328c
 130:	d004                	.insn	2, 0xd004
 132:	a832                	.insn	2, 0xa832
 134:	9c040033          	.insn	4, 0x9c040033
 138:	a029                	.insn	2, 0xa029
 13a:	0429                	.insn	2, 0x0429
 13c:	29a4                	.insn	2, 0x29a4
 13e:	29a8                	.insn	2, 0x29a8
 140:	9004                	.insn	2, 0x9004
 142:	942c                	.insn	2, 0x942c
 144:	042c                	.insn	2, 0x042c
 146:	2ee8                	.insn	2, 0x2ee8
 148:	2eec                	.insn	2, 0x2eec
 14a:	d004                	.insn	2, 0xd004
 14c:	fc32                	.insn	2, 0xfc32
 14e:	0032                	.insn	2, 0x0032
 150:	9804                	.insn	2, 0x9804
 152:	dc2c                	.insn	2, 0xdc2c
 154:	042c                	.insn	2, 0x042c
 156:	30f4                	.insn	2, 0x30f4
 158:	30fc                	.insn	2, 0x30fc
 15a:	8c04                	.insn	2, 0x8c04
 15c:	0033a033          	slt	zero,t2,gp
 160:	f004                	.insn	2, 0xf004
 162:	ac2e                	.insn	2, 0xac2e
 164:	32fc042f          	.insn	4, 0x32fc042f
 168:	338c                	.insn	2, 0x338c
 16a:	a004                	.insn	2, 0xa004
 16c:	0033a833          	slt	a6,t2,gp
 170:	bc04                	.insn	2, 0xbc04
 172:	c024                	.insn	2, 0xc024
 174:	0424                	.insn	2, 0x0424
 176:	24c8                	.insn	2, 0x24c8
 178:	24c8                	.insn	2, 0x24c8
 17a:	0400                	.insn	2, 0x0400
 17c:	2584                	.insn	2, 0x2584
 17e:	2588                	.insn	2, 0x2588
 180:	8c04                	.insn	2, 0x8c04
 182:	9025                	.insn	2, 0x9025
 184:	0025                	.insn	2, 0x0025
 186:	9c04                	.insn	2, 0x9c04
 188:	9c29                	.insn	2, 0x9c29
 18a:	0429                	.insn	2, 0x0429
 18c:	29a0                	.insn	2, 0x29a0
 18e:	29a4                	.insn	2, 0x29a4
 190:	ac04                	.insn	2, 0xac04
 192:	f429                	.insn	2, 0xf429
 194:	0429                	.insn	2, 0x0429
 196:	2ff8                	.insn	2, 0x2ff8
 198:	30d4                	.insn	2, 0x30d4
 19a:	8c04                	.insn	2, 0x8c04
 19c:	ac32                	.insn	2, 0xac32
 19e:	0032                	.insn	2, 0x0032
 1a0:	b004                	.insn	2, 0xb004
 1a2:	e42a                	.insn	2, 0xe42a
 1a4:	2db8042b          	.insn	4, 0x2db8042b
 1a8:	2df8                	.insn	2, 0x2df8
 1aa:	9004                	.insn	2, 0x9004
 1ac:	c82e                	.insn	2, 0xc82e
 1ae:	042e                	.insn	2, 0x042e
 1b0:	3190                	.insn	2, 0x3190
 1b2:	3280                	.insn	2, 0x3280
 1b4:	ac04                	.insn	2, 0xac04
 1b6:	d032                	.insn	2, 0xd032
 1b8:	0432                	.insn	2, 0x0432
 1ba:	33a8                	.insn	2, 0x33a8
 1bc:	33d8                	.insn	2, 0x33d8
 1be:	0400                	.insn	2, 0x0400
 1c0:	2ac8                	.insn	2, 0x2ac8
 1c2:	2aec                	.insn	2, 0x2aec
 1c4:	f004                	.insn	2, 0xf004
 1c6:	f42a                	.insn	2, 0xf42a
 1c8:	042a                	.insn	2, 0x042a
 1ca:	3190                	.insn	2, 0x3190
 1cc:	3190                	.insn	2, 0x3190
 1ce:	0400                	.insn	2, 0x0400
 1d0:	2d94                	.insn	2, 0x2d94
 1d2:	2d98                	.insn	2, 0x2d98
 1d4:	9c04                	.insn	2, 0x9c04
 1d6:	b82d                	.insn	2, 0xb82d
 1d8:	002d                	.insn	2, 0x002d
 1da:	8004                	.insn	2, 0x8004
 1dc:	9c34                	.insn	2, 0x9c34
 1de:	0434                	.insn	2, 0x0434
 1e0:	34a0                	.insn	2, 0x34a0
 1e2:	34a4                	.insn	2, 0x34a4
 1e4:	0400                	.insn	2, 0x0400
 1e6:	34a8                	.insn	2, 0x34a8
 1e8:	34b0                	.insn	2, 0x34b0
 1ea:	b404                	.insn	2, 0xb404
 1ec:	b834                	.insn	2, 0xb834
 1ee:	0434                	.insn	2, 0x0434
 1f0:	34cc                	.insn	2, 0x34cc
 1f2:	34e0                	.insn	2, 0x34e0
 1f4:	e804                	.insn	2, 0xe804
 1f6:	f434                	.insn	2, 0xf434
 1f8:	0434                	.insn	2, 0x0434
 1fa:	34f8                	.insn	2, 0x34f8
 1fc:	3588                	.insn	2, 0x3588
 1fe:	0400                	.insn	2, 0x0400
 200:	35b4                	.insn	2, 0x35b4
 202:	35b4                	.insn	2, 0x35b4
 204:	b804                	.insn	2, 0xb804
 206:	bc35                	.insn	2, 0xbc35
 208:	0035                	.insn	2, 0x0035
