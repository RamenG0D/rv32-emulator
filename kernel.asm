
kernel/kernel:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <_entry>:
80000000:	0000d117          	auipc	sp,0xd
80000004:	40010113          	addi	sp,sp,1024 # 8000d400 <stack0>
80000008:	00001537          	lui	a0,0x1
8000000c:	f14025f3          	csrr	a1,mhartid
80000010:	00158593          	addi	a1,a1,1
80000014:	02b50533          	mul	a0,a0,a1
80000018:	00a10133          	add	sp,sp,a0
8000001c:	094000ef          	jal	800000b0 <start>

80000020 <junk>:
80000020:	0000006f          	j	80000020 <junk>

80000024 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
80000024:	ff010113          	addi	sp,sp,-16
80000028:	00112623          	sw	ra,12(sp)
8000002c:	00812423          	sw	s0,8(sp)
80000030:	01010413          	addi	s0,sp,16
// which hart (core) is this?
static inline uint32
r_mhartid()
{
  uint32 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
80000034:	f1402773          	csrr	a4,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  uint32 interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint32*)CLINT_MTIMECMP(id) = *(uint32*)CLINT_MTIME + interval;
80000038:	004017b7          	lui	a5,0x401
8000003c:	80078793          	addi	a5,a5,-2048 # 400800 <_entry-0x7fbff800>
80000040:	00f707b3          	add	a5,a4,a5
80000044:	00379793          	slli	a5,a5,0x3
80000048:	0200c6b7          	lui	a3,0x200c
8000004c:	ff86a603          	lw	a2,-8(a3) # 200bff8 <_entry-0x7dff4008>
80000050:	000f46b7          	lui	a3,0xf4
80000054:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
80000058:	00d60633          	add	a2,a2,a3
8000005c:	00c7a023          	sw	a2,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint32 *scratch = &mscratch0[32 * id];
80000060:	00771613          	slli	a2,a4,0x7
80000064:	0000d717          	auipc	a4,0xd
80000068:	f9c70713          	addi	a4,a4,-100 # 8000d000 <mscratch0>
8000006c:	00c70733          	add	a4,a4,a2
  scratch[4] = CLINT_MTIMECMP(id);
80000070:	00f72823          	sw	a5,16(a4)
  scratch[5] = interval;
80000074:	00d72a23          	sw	a3,20(a4)
}

static inline void 
w_mscratch(uint32 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
80000078:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
8000007c:	00008797          	auipc	a5,0x8
80000080:	cc478793          	addi	a5,a5,-828 # 80007d40 <timervec>
80000084:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
80000088:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint32)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
8000008c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
80000090:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
80000094:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
80000098:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
8000009c:	30479073          	csrw	mie,a5
}
800000a0:	00c12083          	lw	ra,12(sp)
800000a4:	00812403          	lw	s0,8(sp)
800000a8:	01010113          	addi	sp,sp,16
800000ac:	00008067          	ret

800000b0 <start>:
{
800000b0:	ff010113          	addi	sp,sp,-16
800000b4:	00112623          	sw	ra,12(sp)
800000b8:	00812423          	sw	s0,8(sp)
800000bc:	01010413          	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
800000c0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
800000c4:	ffffe737          	lui	a4,0xffffe
800000c8:	7ff70713          	addi	a4,a4,2047 # ffffe7ff <end+0x7ffd87eb>
800000cc:	00e7f7b3          	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
800000d0:	00001737          	lui	a4,0x1
800000d4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
800000d8:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
800000dc:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
800000e0:	00001797          	auipc	a5,0x1
800000e4:	16078793          	addi	a5,a5,352 # 80001240 <main>
800000e8:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
800000ec:	00000793          	li	a5,0
800000f0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
800000f4:	000107b7          	lui	a5,0x10
800000f8:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
800000fc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
80000100:	30379073          	csrw	mideleg,a5
  timerinit();
80000104:	00000097          	auipc	ra,0x0
80000108:	f20080e7          	jalr	-224(ra) # 80000024 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
8000010c:	f14027f3          	csrr	a5,mhartid
}

static inline void 
w_tp(uint32 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
80000110:	00078213          	mv	tp,a5
  asm volatile("mret");
80000114:	30200073          	mret
}
80000118:	00c12083          	lw	ra,12(sp)
8000011c:	00812403          	lw	s0,8(sp)
80000120:	01010113          	addi	sp,sp,16
80000124:	00008067          	ret

80000128 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint32 dst, int n)
{
80000128:	fc010113          	addi	sp,sp,-64
8000012c:	02112e23          	sw	ra,60(sp)
80000130:	02812c23          	sw	s0,56(sp)
80000134:	02912a23          	sw	s1,52(sp)
80000138:	03212823          	sw	s2,48(sp)
8000013c:	03312623          	sw	s3,44(sp)
80000140:	03412423          	sw	s4,40(sp)
80000144:	03512223          	sw	s5,36(sp)
80000148:	03612023          	sw	s6,32(sp)
8000014c:	04010413          	addi	s0,sp,64
80000150:	00050b13          	mv	s6,a0
80000154:	00058a93          	mv	s5,a1
80000158:	00060993          	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
8000015c:	00060a13          	mv	s4,a2
  acquire(&cons.lock);
80000160:	00015517          	auipc	a0,0x15
80000164:	2a050513          	addi	a0,a0,672 # 80015400 <cons>
80000168:	00001097          	auipc	ra,0x1
8000016c:	d8c080e7          	jalr	-628(ra) # 80000ef4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
80000170:	00015497          	auipc	s1,0x15
80000174:	29048493          	addi	s1,s1,656 # 80015400 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
80000178:	00015917          	auipc	s2,0x15
8000017c:	31490913          	addi	s2,s2,788 # 8001548c <cons+0x8c>
  while(n > 0){
80000180:	11305463          	blez	s3,80000288 <consoleread+0x160>
    while(cons.r == cons.w){
80000184:	08c4a783          	lw	a5,140(s1)
80000188:	0904a703          	lw	a4,144(s1)
8000018c:	0ee79463          	bne	a5,a4,80000274 <consoleread+0x14c>
      if(myproc()->killed){
80000190:	00002097          	auipc	ra,0x2
80000194:	14c080e7          	jalr	332(ra) # 800022dc <myproc>
80000198:	01852783          	lw	a5,24(a0)
8000019c:	08079463          	bnez	a5,80000224 <consoleread+0xfc>
      sleep(&cons.r, &cons.lock);
800001a0:	00048593          	mv	a1,s1
800001a4:	00090513          	mv	a0,s2
800001a8:	00003097          	auipc	ra,0x3
800001ac:	b78080e7          	jalr	-1160(ra) # 80002d20 <sleep>
    while(cons.r == cons.w){
800001b0:	08c4a783          	lw	a5,140(s1)
800001b4:	0904a703          	lw	a4,144(s1)
800001b8:	fce78ce3          	beq	a5,a4,80000190 <consoleread+0x68>
800001bc:	01712e23          	sw	s7,28(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
800001c0:	00015717          	auipc	a4,0x15
800001c4:	24070713          	addi	a4,a4,576 # 80015400 <cons>
800001c8:	00178693          	addi	a3,a5,1
800001cc:	08d72623          	sw	a3,140(a4)
800001d0:	07f7f693          	andi	a3,a5,127
800001d4:	00d70733          	add	a4,a4,a3
800001d8:	00c74703          	lbu	a4,12(a4)
800001dc:	00070b93          	mv	s7,a4

    if(c == C('D')){  // end-of-file
800001e0:	00400693          	li	a3,4
800001e4:	06d70e63          	beq	a4,a3,80000260 <consoleread+0x138>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
800001e8:	fce407a3          	sb	a4,-49(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
800001ec:	015a05b3          	add	a1,s4,s5
800001f0:	00100693          	li	a3,1
800001f4:	fcf40613          	addi	a2,s0,-49
800001f8:	413585b3          	sub	a1,a1,s3
800001fc:	000b0513          	mv	a0,s6
80000200:	00003097          	auipc	ra,0x3
80000204:	e78080e7          	jalr	-392(ra) # 80003078 <either_copyout>
80000208:	fff00793          	li	a5,-1
8000020c:	06f50c63          	beq	a0,a5,80000284 <consoleread+0x15c>
      break;

    dst++;
    --n;
80000210:	00f989b3          	add	s3,s3,a5

    if(c == '\n'){
80000214:	00a00793          	li	a5,10
80000218:	08fb8463          	beq	s7,a5,800002a0 <consoleread+0x178>
8000021c:	01c12b83          	lw	s7,28(sp)
80000220:	f61ff06f          	j	80000180 <consoleread+0x58>
        release(&cons.lock);
80000224:	00015517          	auipc	a0,0x15
80000228:	1dc50513          	addi	a0,a0,476 # 80015400 <cons>
8000022c:	00001097          	auipc	ra,0x1
80000230:	d3c080e7          	jalr	-708(ra) # 80000f68 <release>
        return -1;
80000234:	fff00513          	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
80000238:	03c12083          	lw	ra,60(sp)
8000023c:	03812403          	lw	s0,56(sp)
80000240:	03412483          	lw	s1,52(sp)
80000244:	03012903          	lw	s2,48(sp)
80000248:	02c12983          	lw	s3,44(sp)
8000024c:	02812a03          	lw	s4,40(sp)
80000250:	02412a83          	lw	s5,36(sp)
80000254:	02012b03          	lw	s6,32(sp)
80000258:	04010113          	addi	sp,sp,64
8000025c:	00008067          	ret
      if(n < target){
80000260:	0149fe63          	bgeu	s3,s4,8000027c <consoleread+0x154>
        cons.r--;
80000264:	00015717          	auipc	a4,0x15
80000268:	22f72423          	sw	a5,552(a4) # 8001548c <cons+0x8c>
8000026c:	01c12b83          	lw	s7,28(sp)
80000270:	0180006f          	j	80000288 <consoleread+0x160>
80000274:	01712e23          	sw	s7,28(sp)
80000278:	f49ff06f          	j	800001c0 <consoleread+0x98>
8000027c:	01c12b83          	lw	s7,28(sp)
80000280:	0080006f          	j	80000288 <consoleread+0x160>
80000284:	01c12b83          	lw	s7,28(sp)
  release(&cons.lock);
80000288:	00015517          	auipc	a0,0x15
8000028c:	17850513          	addi	a0,a0,376 # 80015400 <cons>
80000290:	00001097          	auipc	ra,0x1
80000294:	cd8080e7          	jalr	-808(ra) # 80000f68 <release>
  return target - n;
80000298:	413a0533          	sub	a0,s4,s3
8000029c:	f9dff06f          	j	80000238 <consoleread+0x110>
800002a0:	01c12b83          	lw	s7,28(sp)
800002a4:	fe5ff06f          	j	80000288 <consoleread+0x160>

800002a8 <consputc>:
  if(panicked){
800002a8:	00026797          	auipc	a5,0x26
800002ac:	d587a783          	lw	a5,-680(a5) # 80026000 <panicked>
800002b0:	00078463          	beqz	a5,800002b8 <consputc+0x10>
    for(;;)
800002b4:	0000006f          	j	800002b4 <consputc+0xc>
{
800002b8:	ff010113          	addi	sp,sp,-16
800002bc:	00112623          	sw	ra,12(sp)
800002c0:	00812423          	sw	s0,8(sp)
800002c4:	01010413          	addi	s0,sp,16
  if(c == BACKSPACE){
800002c8:	10000793          	li	a5,256
800002cc:	00f50e63          	beq	a0,a5,800002e8 <consputc+0x40>
    uartputc(c);
800002d0:	00000097          	auipc	ra,0x0
800002d4:	7e4080e7          	jalr	2020(ra) # 80000ab4 <uartputc>
}
800002d8:	00c12083          	lw	ra,12(sp)
800002dc:	00812403          	lw	s0,8(sp)
800002e0:	01010113          	addi	sp,sp,16
800002e4:	00008067          	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
800002e8:	00800513          	li	a0,8
800002ec:	00000097          	auipc	ra,0x0
800002f0:	7c8080e7          	jalr	1992(ra) # 80000ab4 <uartputc>
800002f4:	02000513          	li	a0,32
800002f8:	00000097          	auipc	ra,0x0
800002fc:	7bc080e7          	jalr	1980(ra) # 80000ab4 <uartputc>
80000300:	00800513          	li	a0,8
80000304:	00000097          	auipc	ra,0x0
80000308:	7b0080e7          	jalr	1968(ra) # 80000ab4 <uartputc>
8000030c:	fcdff06f          	j	800002d8 <consputc+0x30>

80000310 <consolewrite>:
{
80000310:	fc010113          	addi	sp,sp,-64
80000314:	02112e23          	sw	ra,60(sp)
80000318:	02812c23          	sw	s0,56(sp)
8000031c:	02912a23          	sw	s1,52(sp)
80000320:	03212823          	sw	s2,48(sp)
80000324:	01712e23          	sw	s7,28(sp)
80000328:	04010413          	addi	s0,sp,64
8000032c:	00050913          	mv	s2,a0
80000330:	00058493          	mv	s1,a1
80000334:	00060b93          	mv	s7,a2
  acquire(&cons.lock);
80000338:	00015517          	auipc	a0,0x15
8000033c:	0c850513          	addi	a0,a0,200 # 80015400 <cons>
80000340:	00001097          	auipc	ra,0x1
80000344:	bb4080e7          	jalr	-1100(ra) # 80000ef4 <acquire>
  for(i = 0; i < n; i++){
80000348:	07705c63          	blez	s7,800003c0 <consolewrite+0xb0>
8000034c:	03312623          	sw	s3,44(sp)
80000350:	03412423          	sw	s4,40(sp)
80000354:	03512223          	sw	s5,36(sp)
80000358:	03612023          	sw	s6,32(sp)
8000035c:	009b8b33          	add	s6,s7,s1
    if(either_copyin(&c, user_src, src+i, 1) == -1)
80000360:	fcf40a93          	addi	s5,s0,-49
80000364:	00100a13          	li	s4,1
80000368:	fff00993          	li	s3,-1
8000036c:	000a0693          	mv	a3,s4
80000370:	00048613          	mv	a2,s1
80000374:	00090593          	mv	a1,s2
80000378:	000a8513          	mv	a0,s5
8000037c:	00003097          	auipc	ra,0x3
80000380:	d8c080e7          	jalr	-628(ra) # 80003108 <either_copyin>
80000384:	03350663          	beq	a0,s3,800003b0 <consolewrite+0xa0>
    consputc(c);
80000388:	fcf44503          	lbu	a0,-49(s0)
8000038c:	00000097          	auipc	ra,0x0
80000390:	f1c080e7          	jalr	-228(ra) # 800002a8 <consputc>
  for(i = 0; i < n; i++){
80000394:	00148493          	addi	s1,s1,1
80000398:	fd649ae3          	bne	s1,s6,8000036c <consolewrite+0x5c>
8000039c:	02c12983          	lw	s3,44(sp)
800003a0:	02812a03          	lw	s4,40(sp)
800003a4:	02412a83          	lw	s5,36(sp)
800003a8:	02012b03          	lw	s6,32(sp)
800003ac:	0140006f          	j	800003c0 <consolewrite+0xb0>
800003b0:	02c12983          	lw	s3,44(sp)
800003b4:	02812a03          	lw	s4,40(sp)
800003b8:	02412a83          	lw	s5,36(sp)
800003bc:	02012b03          	lw	s6,32(sp)
  release(&cons.lock);
800003c0:	00015517          	auipc	a0,0x15
800003c4:	04050513          	addi	a0,a0,64 # 80015400 <cons>
800003c8:	00001097          	auipc	ra,0x1
800003cc:	ba0080e7          	jalr	-1120(ra) # 80000f68 <release>
}
800003d0:	000b8513          	mv	a0,s7
800003d4:	03c12083          	lw	ra,60(sp)
800003d8:	03812403          	lw	s0,56(sp)
800003dc:	03412483          	lw	s1,52(sp)
800003e0:	03012903          	lw	s2,48(sp)
800003e4:	01c12b83          	lw	s7,28(sp)
800003e8:	04010113          	addi	sp,sp,64
800003ec:	00008067          	ret

800003f0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
800003f0:	fe010113          	addi	sp,sp,-32
800003f4:	00112e23          	sw	ra,28(sp)
800003f8:	00812c23          	sw	s0,24(sp)
800003fc:	00912a23          	sw	s1,20(sp)
80000400:	02010413          	addi	s0,sp,32
80000404:	00050493          	mv	s1,a0
  acquire(&cons.lock);
80000408:	00015517          	auipc	a0,0x15
8000040c:	ff850513          	addi	a0,a0,-8 # 80015400 <cons>
80000410:	00001097          	auipc	ra,0x1
80000414:	ae4080e7          	jalr	-1308(ra) # 80000ef4 <acquire>

  switch(c){
80000418:	01500793          	li	a5,21
8000041c:	0cf48263          	beq	s1,a5,800004e0 <consoleintr+0xf0>
80000420:	0497c063          	blt	a5,s1,80000460 <consoleintr+0x70>
80000424:	00800793          	li	a5,8
80000428:	12f48c63          	beq	s1,a5,80000560 <consoleintr+0x170>
8000042c:	01000793          	li	a5,16
80000430:	16f49063          	bne	s1,a5,80000590 <consoleintr+0x1a0>
  case C('P'):  // Print process list.
    procdump();
80000434:	00003097          	auipc	ra,0x3
80000438:	d64080e7          	jalr	-668(ra) # 80003198 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
8000043c:	00015517          	auipc	a0,0x15
80000440:	fc450513          	addi	a0,a0,-60 # 80015400 <cons>
80000444:	00001097          	auipc	ra,0x1
80000448:	b24080e7          	jalr	-1244(ra) # 80000f68 <release>
}
8000044c:	01c12083          	lw	ra,28(sp)
80000450:	01812403          	lw	s0,24(sp)
80000454:	01412483          	lw	s1,20(sp)
80000458:	02010113          	addi	sp,sp,32
8000045c:	00008067          	ret
  switch(c){
80000460:	07f00793          	li	a5,127
80000464:	0ef48e63          	beq	s1,a5,80000560 <consoleintr+0x170>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
80000468:	00015717          	auipc	a4,0x15
8000046c:	f9870713          	addi	a4,a4,-104 # 80015400 <cons>
80000470:	09472783          	lw	a5,148(a4)
80000474:	08c72703          	lw	a4,140(a4)
80000478:	40e787b3          	sub	a5,a5,a4
8000047c:	07f00713          	li	a4,127
80000480:	faf76ee3          	bltu	a4,a5,8000043c <consoleintr+0x4c>
      c = (c == '\r') ? '\n' : c;
80000484:	00d00793          	li	a5,13
80000488:	10f48863          	beq	s1,a5,80000598 <consoleintr+0x1a8>
      consputc(c);
8000048c:	00048513          	mv	a0,s1
80000490:	00000097          	auipc	ra,0x0
80000494:	e18080e7          	jalr	-488(ra) # 800002a8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
80000498:	00015797          	auipc	a5,0x15
8000049c:	f6878793          	addi	a5,a5,-152 # 80015400 <cons>
800004a0:	0947a703          	lw	a4,148(a5)
800004a4:	00170693          	addi	a3,a4,1
800004a8:	08d7aa23          	sw	a3,148(a5)
800004ac:	07f77713          	andi	a4,a4,127
800004b0:	00e787b3          	add	a5,a5,a4
800004b4:	00978623          	sb	s1,12(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
800004b8:	00a00793          	li	a5,10
800004bc:	10f48663          	beq	s1,a5,800005c8 <consoleintr+0x1d8>
800004c0:	00400793          	li	a5,4
800004c4:	10f48263          	beq	s1,a5,800005c8 <consoleintr+0x1d8>
800004c8:	00015797          	auipc	a5,0x15
800004cc:	fc47a783          	lw	a5,-60(a5) # 8001548c <cons+0x8c>
800004d0:	08078793          	addi	a5,a5,128
800004d4:	f6f694e3          	bne	a3,a5,8000043c <consoleintr+0x4c>
800004d8:	00078693          	mv	a3,a5
800004dc:	0ec0006f          	j	800005c8 <consoleintr+0x1d8>
800004e0:	01212823          	sw	s2,16(sp)
800004e4:	01312623          	sw	s3,12(sp)
    while(cons.e != cons.w &&
800004e8:	00015717          	auipc	a4,0x15
800004ec:	f1870713          	addi	a4,a4,-232 # 80015400 <cons>
800004f0:	09472783          	lw	a5,148(a4)
800004f4:	09072703          	lw	a4,144(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
800004f8:	00015497          	auipc	s1,0x15
800004fc:	f0848493          	addi	s1,s1,-248 # 80015400 <cons>
    while(cons.e != cons.w &&
80000500:	00a00913          	li	s2,10
      consputc(BACKSPACE);
80000504:	10000993          	li	s3,256
    while(cons.e != cons.w &&
80000508:	04e78063          	beq	a5,a4,80000548 <consoleintr+0x158>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
8000050c:	fff78793          	addi	a5,a5,-1
80000510:	07f7f713          	andi	a4,a5,127
80000514:	00e48733          	add	a4,s1,a4
    while(cons.e != cons.w &&
80000518:	00c74703          	lbu	a4,12(a4)
8000051c:	03270c63          	beq	a4,s2,80000554 <consoleintr+0x164>
      cons.e--;
80000520:	08f4aa23          	sw	a5,148(s1)
      consputc(BACKSPACE);
80000524:	00098513          	mv	a0,s3
80000528:	00000097          	auipc	ra,0x0
8000052c:	d80080e7          	jalr	-640(ra) # 800002a8 <consputc>
    while(cons.e != cons.w &&
80000530:	0944a783          	lw	a5,148(s1)
80000534:	0904a703          	lw	a4,144(s1)
80000538:	fce79ae3          	bne	a5,a4,8000050c <consoleintr+0x11c>
8000053c:	01012903          	lw	s2,16(sp)
80000540:	00c12983          	lw	s3,12(sp)
80000544:	ef9ff06f          	j	8000043c <consoleintr+0x4c>
80000548:	01012903          	lw	s2,16(sp)
8000054c:	00c12983          	lw	s3,12(sp)
80000550:	eedff06f          	j	8000043c <consoleintr+0x4c>
80000554:	01012903          	lw	s2,16(sp)
80000558:	00c12983          	lw	s3,12(sp)
8000055c:	ee1ff06f          	j	8000043c <consoleintr+0x4c>
    if(cons.e != cons.w){
80000560:	00015717          	auipc	a4,0x15
80000564:	ea070713          	addi	a4,a4,-352 # 80015400 <cons>
80000568:	09472783          	lw	a5,148(a4)
8000056c:	09072703          	lw	a4,144(a4)
80000570:	ece786e3          	beq	a5,a4,8000043c <consoleintr+0x4c>
      cons.e--;
80000574:	fff78793          	addi	a5,a5,-1
80000578:	00015717          	auipc	a4,0x15
8000057c:	f0f72e23          	sw	a5,-228(a4) # 80015494 <cons+0x94>
      consputc(BACKSPACE);
80000580:	10000513          	li	a0,256
80000584:	00000097          	auipc	ra,0x0
80000588:	d24080e7          	jalr	-732(ra) # 800002a8 <consputc>
8000058c:	eb1ff06f          	j	8000043c <consoleintr+0x4c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
80000590:	ea0486e3          	beqz	s1,8000043c <consoleintr+0x4c>
80000594:	ed5ff06f          	j	80000468 <consoleintr+0x78>
      consputc(c);
80000598:	00a00513          	li	a0,10
8000059c:	00000097          	auipc	ra,0x0
800005a0:	d0c080e7          	jalr	-756(ra) # 800002a8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
800005a4:	00015797          	auipc	a5,0x15
800005a8:	e5c78793          	addi	a5,a5,-420 # 80015400 <cons>
800005ac:	0947a703          	lw	a4,148(a5)
800005b0:	00170693          	addi	a3,a4,1
800005b4:	08d7aa23          	sw	a3,148(a5)
800005b8:	07f77713          	andi	a4,a4,127
800005bc:	00e787b3          	add	a5,a5,a4
800005c0:	00a00713          	li	a4,10
800005c4:	00e78623          	sb	a4,12(a5)
        cons.w = cons.e;
800005c8:	00015797          	auipc	a5,0x15
800005cc:	ecd7a423          	sw	a3,-312(a5) # 80015490 <cons+0x90>
        wakeup(&cons.r);
800005d0:	00015517          	auipc	a0,0x15
800005d4:	ebc50513          	addi	a0,a0,-324 # 8001548c <cons+0x8c>
800005d8:	00003097          	auipc	ra,0x3
800005dc:	958080e7          	jalr	-1704(ra) # 80002f30 <wakeup>
800005e0:	e5dff06f          	j	8000043c <consoleintr+0x4c>

800005e4 <consoleinit>:

void
consoleinit(void)
{
800005e4:	ff010113          	addi	sp,sp,-16
800005e8:	00112623          	sw	ra,12(sp)
800005ec:	00812423          	sw	s0,8(sp)
800005f0:	01010413          	addi	s0,sp,16
  initlock(&cons.lock, "cons");
800005f4:	0000b597          	auipc	a1,0xb
800005f8:	2dc58593          	addi	a1,a1,732 # 8000b8d0 <userret+0x2830>
800005fc:	00015517          	auipc	a0,0x15
80000600:	e0450513          	addi	a0,a0,-508 # 80015400 <cons>
80000604:	00000097          	auipc	ra,0x0
80000608:	764080e7          	jalr	1892(ra) # 80000d68 <initlock>

  uartinit();
8000060c:	00000097          	auipc	ra,0x0
80000610:	450080e7          	jalr	1104(ra) # 80000a5c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
80000614:	00022797          	auipc	a5,0x22
80000618:	8c878793          	addi	a5,a5,-1848 # 80021edc <devsw>
8000061c:	00000717          	auipc	a4,0x0
80000620:	b0c70713          	addi	a4,a4,-1268 # 80000128 <consoleread>
80000624:	00e7a423          	sw	a4,8(a5)
  devsw[CONSOLE].write = consolewrite;
80000628:	00000717          	auipc	a4,0x0
8000062c:	ce870713          	addi	a4,a4,-792 # 80000310 <consolewrite>
80000630:	00e7a623          	sw	a4,12(a5)
}
80000634:	00c12083          	lw	ra,12(sp)
80000638:	00812403          	lw	s0,8(sp)
8000063c:	01010113          	addi	sp,sp,16
80000640:	00008067          	ret

80000644 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
80000644:	fe010113          	addi	sp,sp,-32
80000648:	00112e23          	sw	ra,28(sp)
8000064c:	00812c23          	sw	s0,24(sp)
80000650:	00912a23          	sw	s1,20(sp)
80000654:	01212823          	sw	s2,16(sp)
80000658:	02010413          	addi	s0,sp,32
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8000065c:	00060463          	beqz	a2,80000664 <printint+0x20>
80000660:	08054a63          	bltz	a0,800006f4 <printint+0xb0>
    x = -xx;
  else
    x = xx;
80000664:	00000313          	li	t1,0

  i = 0;
80000668:	00000793          	li	a5,0
  do {
    buf[i++] = digits[x % base];
8000066c:	fe040813          	addi	a6,s0,-32
80000670:	0000c617          	auipc	a2,0xc
80000674:	8b060613          	addi	a2,a2,-1872 # 8000bf20 <digits>
80000678:	00078893          	mv	a7,a5
8000067c:	00178793          	addi	a5,a5,1
80000680:	00f806b3          	add	a3,a6,a5
80000684:	02b57733          	remu	a4,a0,a1
80000688:	00e60733          	add	a4,a2,a4
8000068c:	00074703          	lbu	a4,0(a4)
80000690:	fee68fa3          	sb	a4,-1(a3)
  } while((x /= base) != 0);
80000694:	00050713          	mv	a4,a0
80000698:	02b55533          	divu	a0,a0,a1
8000069c:	fcb77ee3          	bgeu	a4,a1,80000678 <printint+0x34>

  if(sign)
800006a0:	00030c63          	beqz	t1,800006b8 <printint+0x74>
    buf[i++] = '-';
800006a4:	ff078793          	addi	a5,a5,-16
800006a8:	008787b3          	add	a5,a5,s0
800006ac:	02d00713          	li	a4,45
800006b0:	fee78823          	sb	a4,-16(a5)
800006b4:	00288793          	addi	a5,a7,2

  while(--i >= 0)
800006b8:	fe040913          	addi	s2,s0,-32
800006bc:	012784b3          	add	s1,a5,s2
    consputc(buf[i]);
800006c0:	fff4c503          	lbu	a0,-1(s1)
800006c4:	00000097          	auipc	ra,0x0
800006c8:	be4080e7          	jalr	-1052(ra) # 800002a8 <consputc>
  while(--i >= 0)
800006cc:	fff48493          	addi	s1,s1,-1
800006d0:	412487b3          	sub	a5,s1,s2
800006d4:	fff78793          	addi	a5,a5,-1
800006d8:	fe07d4e3          	bgez	a5,800006c0 <printint+0x7c>
}
800006dc:	01c12083          	lw	ra,28(sp)
800006e0:	01812403          	lw	s0,24(sp)
800006e4:	01412483          	lw	s1,20(sp)
800006e8:	01012903          	lw	s2,16(sp)
800006ec:	02010113          	addi	sp,sp,32
800006f0:	00008067          	ret
    x = -xx;
800006f4:	40a00533          	neg	a0,a0
  if(sign && (sign = xx < 0))
800006f8:	00100313          	li	t1,1
    x = -xx;
800006fc:	f6dff06f          	j	80000668 <printint+0x24>

80000700 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
80000700:	ff010113          	addi	sp,sp,-16
80000704:	00112623          	sw	ra,12(sp)
80000708:	00812423          	sw	s0,8(sp)
8000070c:	00912223          	sw	s1,4(sp)
80000710:	01010413          	addi	s0,sp,16
80000714:	00050493          	mv	s1,a0
  pr.locking = 0;
80000718:	00015797          	auipc	a5,0x15
8000071c:	d807a623          	sw	zero,-628(a5) # 800154a4 <pr+0xc>
  printf("panic: ");
80000720:	0000b517          	auipc	a0,0xb
80000724:	1b850513          	addi	a0,a0,440 # 8000b8d8 <userret+0x2838>
80000728:	00000097          	auipc	ra,0x0
8000072c:	034080e7          	jalr	52(ra) # 8000075c <printf>
  printf(s);
80000730:	00048513          	mv	a0,s1
80000734:	00000097          	auipc	ra,0x0
80000738:	028080e7          	jalr	40(ra) # 8000075c <printf>
  printf("\n");
8000073c:	0000b517          	auipc	a0,0xb
80000740:	1a450513          	addi	a0,a0,420 # 8000b8e0 <userret+0x2840>
80000744:	00000097          	auipc	ra,0x0
80000748:	018080e7          	jalr	24(ra) # 8000075c <printf>
  panicked = 1; // freeze other CPUs
8000074c:	00100793          	li	a5,1
80000750:	00026717          	auipc	a4,0x26
80000754:	8af72823          	sw	a5,-1872(a4) # 80026000 <panicked>
  for(;;)
80000758:	0000006f          	j	80000758 <panic+0x58>

8000075c <printf>:
{
8000075c:	f9010113          	addi	sp,sp,-112
80000760:	04112623          	sw	ra,76(sp)
80000764:	04812423          	sw	s0,72(sp)
80000768:	03412c23          	sw	s4,56(sp)
8000076c:	01b12e23          	sw	s11,28(sp)
80000770:	05010413          	addi	s0,sp,80
80000774:	00050a13          	mv	s4,a0
80000778:	00b42223          	sw	a1,4(s0)
8000077c:	00c42423          	sw	a2,8(s0)
80000780:	00d42623          	sw	a3,12(s0)
80000784:	00e42823          	sw	a4,16(s0)
80000788:	00f42a23          	sw	a5,20(s0)
8000078c:	01042c23          	sw	a6,24(s0)
80000790:	01142e23          	sw	a7,28(s0)
  locking = pr.locking;
80000794:	00015d97          	auipc	s11,0x15
80000798:	d10dad83          	lw	s11,-752(s11) # 800154a4 <pr+0xc>
  if(locking)
8000079c:	060d9063          	bnez	s11,800007fc <printf+0xa0>
  if (fmt == 0)
800007a0:	060a0863          	beqz	s4,80000810 <printf+0xb4>
  va_start(ap, fmt);
800007a4:	00440793          	addi	a5,s0,4
800007a8:	faf42e23          	sw	a5,-68(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
800007ac:	000a4503          	lbu	a0,0(s4)
800007b0:	20050463          	beqz	a0,800009b8 <printf+0x25c>
800007b4:	04912223          	sw	s1,68(sp)
800007b8:	05212023          	sw	s2,64(sp)
800007bc:	03312e23          	sw	s3,60(sp)
800007c0:	03512a23          	sw	s5,52(sp)
800007c4:	03612823          	sw	s6,48(sp)
800007c8:	03712623          	sw	s7,44(sp)
800007cc:	03812423          	sw	s8,40(sp)
800007d0:	03912223          	sw	s9,36(sp)
800007d4:	03a12023          	sw	s10,32(sp)
800007d8:	00000493          	li	s1,0
    if(c != '%'){
800007dc:	02500a93          	li	s5,37
    switch(c){
800007e0:	07000b13          	li	s6,112
  consputc('x');
800007e4:	07800c93          	li	s9,120
    consputc(digits[x >> (sizeof(uint32) * 8 - 4)]);
800007e8:	0000bb97          	auipc	s7,0xb
800007ec:	738b8b93          	addi	s7,s7,1848 # 8000bf20 <digits>
    switch(c){
800007f0:	07300c13          	li	s8,115
      printint(va_arg(ap, int), 16, 1);
800007f4:	00100d13          	li	s10,1
800007f8:	0640006f          	j	8000085c <printf+0x100>
    acquire(&pr.lock);
800007fc:	00015517          	auipc	a0,0x15
80000800:	c9c50513          	addi	a0,a0,-868 # 80015498 <pr>
80000804:	00000097          	auipc	ra,0x0
80000808:	6f0080e7          	jalr	1776(ra) # 80000ef4 <acquire>
8000080c:	f95ff06f          	j	800007a0 <printf+0x44>
80000810:	04912223          	sw	s1,68(sp)
80000814:	05212023          	sw	s2,64(sp)
80000818:	03312e23          	sw	s3,60(sp)
8000081c:	03512a23          	sw	s5,52(sp)
80000820:	03612823          	sw	s6,48(sp)
80000824:	03712623          	sw	s7,44(sp)
80000828:	03812423          	sw	s8,40(sp)
8000082c:	03912223          	sw	s9,36(sp)
80000830:	03a12023          	sw	s10,32(sp)
    panic("null fmt");
80000834:	0000b517          	auipc	a0,0xb
80000838:	0b850513          	addi	a0,a0,184 # 8000b8ec <userret+0x284c>
8000083c:	00000097          	auipc	ra,0x0
80000840:	ec4080e7          	jalr	-316(ra) # 80000700 <panic>
      consputc(c);
80000844:	00000097          	auipc	ra,0x0
80000848:	a64080e7          	jalr	-1436(ra) # 800002a8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8000084c:	00148493          	addi	s1,s1,1
80000850:	009a07b3          	add	a5,s4,s1
80000854:	0007c503          	lbu	a0,0(a5)
80000858:	12050e63          	beqz	a0,80000994 <printf+0x238>
    if(c != '%'){
8000085c:	ff5514e3          	bne	a0,s5,80000844 <printf+0xe8>
    c = fmt[++i] & 0xff;
80000860:	00148493          	addi	s1,s1,1
80000864:	009a07b3          	add	a5,s4,s1
80000868:	0007c903          	lbu	s2,0(a5)
    if(c == 0)
8000086c:	16090463          	beqz	s2,800009d4 <printf+0x278>
    switch(c){
80000870:	07690263          	beq	s2,s6,800008d4 <printf+0x178>
80000874:	032b7863          	bgeu	s6,s2,800008a4 <printf+0x148>
80000878:	0b890663          	beq	s2,s8,80000924 <printf+0x1c8>
8000087c:	0f991e63          	bne	s2,s9,80000978 <printf+0x21c>
      printint(va_arg(ap, int), 16, 1);
80000880:	fbc42783          	lw	a5,-68(s0)
80000884:	00478713          	addi	a4,a5,4
80000888:	fae42e23          	sw	a4,-68(s0)
8000088c:	000d0613          	mv	a2,s10
80000890:	01000593          	li	a1,16
80000894:	0007a503          	lw	a0,0(a5)
80000898:	00000097          	auipc	ra,0x0
8000089c:	dac080e7          	jalr	-596(ra) # 80000644 <printint>
      break;
800008a0:	fadff06f          	j	8000084c <printf+0xf0>
    switch(c){
800008a4:	0d590263          	beq	s2,s5,80000968 <printf+0x20c>
800008a8:	06400793          	li	a5,100
800008ac:	0cf91663          	bne	s2,a5,80000978 <printf+0x21c>
      printint(va_arg(ap, int), 10, 1);
800008b0:	fbc42783          	lw	a5,-68(s0)
800008b4:	00478713          	addi	a4,a5,4
800008b8:	fae42e23          	sw	a4,-68(s0)
800008bc:	000d0613          	mv	a2,s10
800008c0:	00a00593          	li	a1,10
800008c4:	0007a503          	lw	a0,0(a5)
800008c8:	00000097          	auipc	ra,0x0
800008cc:	d7c080e7          	jalr	-644(ra) # 80000644 <printint>
      break;
800008d0:	f7dff06f          	j	8000084c <printf+0xf0>
      printptr(va_arg(ap, uint32));
800008d4:	fbc42783          	lw	a5,-68(s0)
800008d8:	00478713          	addi	a4,a5,4
800008dc:	fae42e23          	sw	a4,-68(s0)
800008e0:	0007a983          	lw	s3,0(a5)
  consputc('0');
800008e4:	03000513          	li	a0,48
800008e8:	00000097          	auipc	ra,0x0
800008ec:	9c0080e7          	jalr	-1600(ra) # 800002a8 <consputc>
  consputc('x');
800008f0:	000c8513          	mv	a0,s9
800008f4:	00000097          	auipc	ra,0x0
800008f8:	9b4080e7          	jalr	-1612(ra) # 800002a8 <consputc>
800008fc:	00800913          	li	s2,8
    consputc(digits[x >> (sizeof(uint32) * 8 - 4)]);
80000900:	01c9d793          	srli	a5,s3,0x1c
80000904:	00fb87b3          	add	a5,s7,a5
80000908:	0007c503          	lbu	a0,0(a5)
8000090c:	00000097          	auipc	ra,0x0
80000910:	99c080e7          	jalr	-1636(ra) # 800002a8 <consputc>
  for (i = 0; i < (sizeof(uint32) * 2); i++, x <<= 4)
80000914:	00499993          	slli	s3,s3,0x4
80000918:	fff90913          	addi	s2,s2,-1
8000091c:	fe0912e3          	bnez	s2,80000900 <printf+0x1a4>
80000920:	f2dff06f          	j	8000084c <printf+0xf0>
      if((s = va_arg(ap, char*)) == 0)
80000924:	fbc42783          	lw	a5,-68(s0)
80000928:	00478713          	addi	a4,a5,4
8000092c:	fae42e23          	sw	a4,-68(s0)
80000930:	0007a903          	lw	s2,0(a5)
80000934:	02090263          	beqz	s2,80000958 <printf+0x1fc>
      for(; *s; s++)
80000938:	00094503          	lbu	a0,0(s2)
8000093c:	f00508e3          	beqz	a0,8000084c <printf+0xf0>
        consputc(*s);
80000940:	00000097          	auipc	ra,0x0
80000944:	968080e7          	jalr	-1688(ra) # 800002a8 <consputc>
      for(; *s; s++)
80000948:	00190913          	addi	s2,s2,1
8000094c:	00094503          	lbu	a0,0(s2)
80000950:	fe0518e3          	bnez	a0,80000940 <printf+0x1e4>
80000954:	ef9ff06f          	j	8000084c <printf+0xf0>
        s = "(null)";
80000958:	0000b917          	auipc	s2,0xb
8000095c:	f8c90913          	addi	s2,s2,-116 # 8000b8e4 <userret+0x2844>
      for(; *s; s++)
80000960:	02800513          	li	a0,40
80000964:	fddff06f          	j	80000940 <printf+0x1e4>
      consputc('%');
80000968:	000a8513          	mv	a0,s5
8000096c:	00000097          	auipc	ra,0x0
80000970:	93c080e7          	jalr	-1732(ra) # 800002a8 <consputc>
      break;
80000974:	ed9ff06f          	j	8000084c <printf+0xf0>
      consputc('%');
80000978:	000a8513          	mv	a0,s5
8000097c:	00000097          	auipc	ra,0x0
80000980:	92c080e7          	jalr	-1748(ra) # 800002a8 <consputc>
      consputc(c);
80000984:	00090513          	mv	a0,s2
80000988:	00000097          	auipc	ra,0x0
8000098c:	920080e7          	jalr	-1760(ra) # 800002a8 <consputc>
      break;
80000990:	ebdff06f          	j	8000084c <printf+0xf0>
80000994:	04412483          	lw	s1,68(sp)
80000998:	04012903          	lw	s2,64(sp)
8000099c:	03c12983          	lw	s3,60(sp)
800009a0:	03412a83          	lw	s5,52(sp)
800009a4:	03012b03          	lw	s6,48(sp)
800009a8:	02c12b83          	lw	s7,44(sp)
800009ac:	02812c03          	lw	s8,40(sp)
800009b0:	02412c83          	lw	s9,36(sp)
800009b4:	02012d03          	lw	s10,32(sp)
  if(locking)
800009b8:	040d9263          	bnez	s11,800009fc <printf+0x2a0>
}
800009bc:	04c12083          	lw	ra,76(sp)
800009c0:	04812403          	lw	s0,72(sp)
800009c4:	03812a03          	lw	s4,56(sp)
800009c8:	01c12d83          	lw	s11,28(sp)
800009cc:	07010113          	addi	sp,sp,112
800009d0:	00008067          	ret
800009d4:	04412483          	lw	s1,68(sp)
800009d8:	04012903          	lw	s2,64(sp)
800009dc:	03c12983          	lw	s3,60(sp)
800009e0:	03412a83          	lw	s5,52(sp)
800009e4:	03012b03          	lw	s6,48(sp)
800009e8:	02c12b83          	lw	s7,44(sp)
800009ec:	02812c03          	lw	s8,40(sp)
800009f0:	02412c83          	lw	s9,36(sp)
800009f4:	02012d03          	lw	s10,32(sp)
800009f8:	fc1ff06f          	j	800009b8 <printf+0x25c>
    release(&pr.lock);
800009fc:	00015517          	auipc	a0,0x15
80000a00:	a9c50513          	addi	a0,a0,-1380 # 80015498 <pr>
80000a04:	00000097          	auipc	ra,0x0
80000a08:	564080e7          	jalr	1380(ra) # 80000f68 <release>
}
80000a0c:	fb1ff06f          	j	800009bc <printf+0x260>

80000a10 <printfinit>:
    ;
}

void
printfinit(void)
{
80000a10:	ff010113          	addi	sp,sp,-16
80000a14:	00112623          	sw	ra,12(sp)
80000a18:	00812423          	sw	s0,8(sp)
80000a1c:	00912223          	sw	s1,4(sp)
80000a20:	01010413          	addi	s0,sp,16
  initlock(&pr.lock, "pr");
80000a24:	00015497          	auipc	s1,0x15
80000a28:	a7448493          	addi	s1,s1,-1420 # 80015498 <pr>
80000a2c:	0000b597          	auipc	a1,0xb
80000a30:	ecc58593          	addi	a1,a1,-308 # 8000b8f8 <userret+0x2858>
80000a34:	00048513          	mv	a0,s1
80000a38:	00000097          	auipc	ra,0x0
80000a3c:	330080e7          	jalr	816(ra) # 80000d68 <initlock>
  pr.locking = 1;
80000a40:	00100793          	li	a5,1
80000a44:	00f4a623          	sw	a5,12(s1)
}
80000a48:	00c12083          	lw	ra,12(sp)
80000a4c:	00812403          	lw	s0,8(sp)
80000a50:	00412483          	lw	s1,4(sp)
80000a54:	01010113          	addi	sp,sp,16
80000a58:	00008067          	ret

80000a5c <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
80000a5c:	ff010113          	addi	sp,sp,-16
80000a60:	00112623          	sw	ra,12(sp)
80000a64:	00812423          	sw	s0,8(sp)
80000a68:	01010413          	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
80000a6c:	100007b7          	lui	a5,0x10000
80000a70:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
80000a74:	10000737          	lui	a4,0x10000
80000a78:	f8000693          	li	a3,-128
80000a7c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
80000a80:	00300693          	li	a3,3
80000a84:	10000637          	lui	a2,0x10000
80000a88:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
80000a8c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
80000a90:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
80000a94:	00700693          	li	a3,7
80000a98:	00d60123          	sb	a3,2(a2)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
80000a9c:	00100713          	li	a4,1
80000aa0:	00e780a3          	sb	a4,1(a5)
}
80000aa4:	00c12083          	lw	ra,12(sp)
80000aa8:	00812403          	lw	s0,8(sp)
80000aac:	01010113          	addi	sp,sp,16
80000ab0:	00008067          	ret

80000ab4 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
80000ab4:	ff010113          	addi	sp,sp,-16
80000ab8:	00112623          	sw	ra,12(sp)
80000abc:	00812423          	sw	s0,8(sp)
80000ac0:	01010413          	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
80000ac4:	10000737          	lui	a4,0x10000
80000ac8:	00570713          	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
80000acc:	00074783          	lbu	a5,0(a4)
80000ad0:	0207f793          	andi	a5,a5,32
80000ad4:	fe078ce3          	beqz	a5,80000acc <uartputc+0x18>
    ;
  WriteReg(THR, c);
80000ad8:	0ff57513          	zext.b	a0,a0
80000adc:	100007b7          	lui	a5,0x10000
80000ae0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
80000ae4:	00c12083          	lw	ra,12(sp)
80000ae8:	00812403          	lw	s0,8(sp)
80000aec:	01010113          	addi	sp,sp,16
80000af0:	00008067          	ret

80000af4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
80000af4:	ff010113          	addi	sp,sp,-16
80000af8:	00112623          	sw	ra,12(sp)
80000afc:	00812423          	sw	s0,8(sp)
80000b00:	01010413          	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
80000b04:	100007b7          	lui	a5,0x10000
80000b08:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
80000b0c:	0017f793          	andi	a5,a5,1
80000b10:	02078063          	beqz	a5,80000b30 <uartgetc+0x3c>
    // input data is ready.
    return ReadReg(RHR);
80000b14:	100007b7          	lui	a5,0x10000
80000b18:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
80000b1c:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
80000b20:	00c12083          	lw	ra,12(sp)
80000b24:	00812403          	lw	s0,8(sp)
80000b28:	01010113          	addi	sp,sp,16
80000b2c:	00008067          	ret
    return -1;
80000b30:	fff00513          	li	a0,-1
80000b34:	fedff06f          	j	80000b20 <uartgetc+0x2c>

80000b38 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
80000b38:	ff010113          	addi	sp,sp,-16
80000b3c:	00112623          	sw	ra,12(sp)
80000b40:	00812423          	sw	s0,8(sp)
80000b44:	00912223          	sw	s1,4(sp)
80000b48:	01010413          	addi	s0,sp,16
  while(1){
    int c = uartgetc();
    if(c == -1)
80000b4c:	fff00493          	li	s1,-1
    int c = uartgetc();
80000b50:	00000097          	auipc	ra,0x0
80000b54:	fa4080e7          	jalr	-92(ra) # 80000af4 <uartgetc>
    if(c == -1)
80000b58:	00950863          	beq	a0,s1,80000b68 <uartintr+0x30>
      break;
    consoleintr(c);
80000b5c:	00000097          	auipc	ra,0x0
80000b60:	894080e7          	jalr	-1900(ra) # 800003f0 <consoleintr>
  while(1){
80000b64:	fedff06f          	j	80000b50 <uartintr+0x18>
  }
}
80000b68:	00c12083          	lw	ra,12(sp)
80000b6c:	00812403          	lw	s0,8(sp)
80000b70:	00412483          	lw	s1,4(sp)
80000b74:	01010113          	addi	sp,sp,16
80000b78:	00008067          	ret

80000b7c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
80000b7c:	ff010113          	addi	sp,sp,-16
80000b80:	00112623          	sw	ra,12(sp)
80000b84:	00812423          	sw	s0,8(sp)
80000b88:	00912223          	sw	s1,4(sp)
80000b8c:	01212023          	sw	s2,0(sp)
80000b90:	01010413          	addi	s0,sp,16
  struct run *r;

  if(((uint32)pa % PGSIZE) != 0 || (char*)pa < end || (uint32)pa >= PHYSTOP)
80000b94:	01451793          	slli	a5,a0,0x14
80000b98:	06079863          	bnez	a5,80000c08 <kfree+0x8c>
80000b9c:	00050493          	mv	s1,a0
80000ba0:	00025797          	auipc	a5,0x25
80000ba4:	47478793          	addi	a5,a5,1140 # 80026014 <end>
80000ba8:	06f56063          	bltu	a0,a5,80000c08 <kfree+0x8c>
80000bac:	880007b7          	lui	a5,0x88000
80000bb0:	04f57c63          	bgeu	a0,a5,80000c08 <kfree+0x8c>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
80000bb4:	00001637          	lui	a2,0x1
80000bb8:	00100593          	li	a1,1
80000bbc:	00000097          	auipc	ra,0x0
80000bc0:	40c080e7          	jalr	1036(ra) # 80000fc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
80000bc4:	00015917          	auipc	s2,0x15
80000bc8:	8e490913          	addi	s2,s2,-1820 # 800154a8 <kmem>
80000bcc:	00090513          	mv	a0,s2
80000bd0:	00000097          	auipc	ra,0x0
80000bd4:	324080e7          	jalr	804(ra) # 80000ef4 <acquire>
  r->next = kmem.freelist;
80000bd8:	00c92783          	lw	a5,12(s2)
80000bdc:	00f4a023          	sw	a5,0(s1)
  kmem.freelist = r;
80000be0:	00992623          	sw	s1,12(s2)
  release(&kmem.lock);
80000be4:	00090513          	mv	a0,s2
80000be8:	00000097          	auipc	ra,0x0
80000bec:	380080e7          	jalr	896(ra) # 80000f68 <release>
}
80000bf0:	00c12083          	lw	ra,12(sp)
80000bf4:	00812403          	lw	s0,8(sp)
80000bf8:	00412483          	lw	s1,4(sp)
80000bfc:	00012903          	lw	s2,0(sp)
80000c00:	01010113          	addi	sp,sp,16
80000c04:	00008067          	ret
    panic("kfree");
80000c08:	0000b517          	auipc	a0,0xb
80000c0c:	cf450513          	addi	a0,a0,-780 # 8000b8fc <userret+0x285c>
80000c10:	00000097          	auipc	ra,0x0
80000c14:	af0080e7          	jalr	-1296(ra) # 80000700 <panic>

80000c18 <freerange>:
{
80000c18:	fe010113          	addi	sp,sp,-32
80000c1c:	00112e23          	sw	ra,28(sp)
80000c20:	00812c23          	sw	s0,24(sp)
80000c24:	00912a23          	sw	s1,20(sp)
80000c28:	02010413          	addi	s0,sp,32
  p = (char*)PGROUNDUP((uint32)pa_start);
80000c2c:	000017b7          	lui	a5,0x1
80000c30:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
80000c34:	00e504b3          	add	s1,a0,a4
80000c38:	fffff737          	lui	a4,0xfffff
80000c3c:	00e4f4b3          	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
80000c40:	00f484b3          	add	s1,s1,a5
80000c44:	0295ee63          	bltu	a1,s1,80000c80 <freerange+0x68>
80000c48:	01212823          	sw	s2,16(sp)
80000c4c:	01312623          	sw	s3,12(sp)
80000c50:	01412423          	sw	s4,8(sp)
80000c54:	00058913          	mv	s2,a1
    kfree(p);
80000c58:	00070a13          	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
80000c5c:	00078993          	mv	s3,a5
    kfree(p);
80000c60:	01448533          	add	a0,s1,s4
80000c64:	00000097          	auipc	ra,0x0
80000c68:	f18080e7          	jalr	-232(ra) # 80000b7c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
80000c6c:	013484b3          	add	s1,s1,s3
80000c70:	fe9978e3          	bgeu	s2,s1,80000c60 <freerange+0x48>
80000c74:	01012903          	lw	s2,16(sp)
80000c78:	00c12983          	lw	s3,12(sp)
80000c7c:	00812a03          	lw	s4,8(sp)
}
80000c80:	01c12083          	lw	ra,28(sp)
80000c84:	01812403          	lw	s0,24(sp)
80000c88:	01412483          	lw	s1,20(sp)
80000c8c:	02010113          	addi	sp,sp,32
80000c90:	00008067          	ret

80000c94 <kinit>:
{
80000c94:	ff010113          	addi	sp,sp,-16
80000c98:	00112623          	sw	ra,12(sp)
80000c9c:	00812423          	sw	s0,8(sp)
80000ca0:	01010413          	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
80000ca4:	0000b597          	auipc	a1,0xb
80000ca8:	c6058593          	addi	a1,a1,-928 # 8000b904 <userret+0x2864>
80000cac:	00014517          	auipc	a0,0x14
80000cb0:	7fc50513          	addi	a0,a0,2044 # 800154a8 <kmem>
80000cb4:	00000097          	auipc	ra,0x0
80000cb8:	0b4080e7          	jalr	180(ra) # 80000d68 <initlock>
  freerange(end, (void*)PHYSTOP);
80000cbc:	880005b7          	lui	a1,0x88000
80000cc0:	00025517          	auipc	a0,0x25
80000cc4:	35450513          	addi	a0,a0,852 # 80026014 <end>
80000cc8:	00000097          	auipc	ra,0x0
80000ccc:	f50080e7          	jalr	-176(ra) # 80000c18 <freerange>
}
80000cd0:	00c12083          	lw	ra,12(sp)
80000cd4:	00812403          	lw	s0,8(sp)
80000cd8:	01010113          	addi	sp,sp,16
80000cdc:	00008067          	ret

80000ce0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
80000ce0:	ff010113          	addi	sp,sp,-16
80000ce4:	00112623          	sw	ra,12(sp)
80000ce8:	00812423          	sw	s0,8(sp)
80000cec:	00912223          	sw	s1,4(sp)
80000cf0:	01010413          	addi	s0,sp,16
  struct run *r;

  acquire(&kmem.lock);
80000cf4:	00014497          	auipc	s1,0x14
80000cf8:	7b448493          	addi	s1,s1,1972 # 800154a8 <kmem>
80000cfc:	00048513          	mv	a0,s1
80000d00:	00000097          	auipc	ra,0x0
80000d04:	1f4080e7          	jalr	500(ra) # 80000ef4 <acquire>
  r = kmem.freelist;
80000d08:	00c4a483          	lw	s1,12(s1)
  if(r)
80000d0c:	04048463          	beqz	s1,80000d54 <kalloc+0x74>
    kmem.freelist = r->next;
80000d10:	0004a783          	lw	a5,0(s1)
80000d14:	00014517          	auipc	a0,0x14
80000d18:	79450513          	addi	a0,a0,1940 # 800154a8 <kmem>
80000d1c:	00f52623          	sw	a5,12(a0)
  release(&kmem.lock);
80000d20:	00000097          	auipc	ra,0x0
80000d24:	248080e7          	jalr	584(ra) # 80000f68 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
80000d28:	00001637          	lui	a2,0x1
80000d2c:	00500593          	li	a1,5
80000d30:	00048513          	mv	a0,s1
80000d34:	00000097          	auipc	ra,0x0
80000d38:	294080e7          	jalr	660(ra) # 80000fc8 <memset>
  return (void*)r;
}
80000d3c:	00048513          	mv	a0,s1
80000d40:	00c12083          	lw	ra,12(sp)
80000d44:	00812403          	lw	s0,8(sp)
80000d48:	00412483          	lw	s1,4(sp)
80000d4c:	01010113          	addi	sp,sp,16
80000d50:	00008067          	ret
  release(&kmem.lock);
80000d54:	00014517          	auipc	a0,0x14
80000d58:	75450513          	addi	a0,a0,1876 # 800154a8 <kmem>
80000d5c:	00000097          	auipc	ra,0x0
80000d60:	20c080e7          	jalr	524(ra) # 80000f68 <release>
  if(r)
80000d64:	fd9ff06f          	j	80000d3c <kalloc+0x5c>

80000d68 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
80000d68:	ff010113          	addi	sp,sp,-16
80000d6c:	00112623          	sw	ra,12(sp)
80000d70:	00812423          	sw	s0,8(sp)
80000d74:	01010413          	addi	s0,sp,16
  lk->name = name;
80000d78:	00b52223          	sw	a1,4(a0)
  lk->locked = 0;
80000d7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
80000d80:	00052423          	sw	zero,8(a0)
}
80000d84:	00c12083          	lw	ra,12(sp)
80000d88:	00812403          	lw	s0,8(sp)
80000d8c:	01010113          	addi	sp,sp,16
80000d90:	00008067          	ret

80000d94 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
80000d94:	ff010113          	addi	sp,sp,-16
80000d98:	00112623          	sw	ra,12(sp)
80000d9c:	00812423          	sw	s0,8(sp)
80000da0:	00912223          	sw	s1,4(sp)
80000da4:	01010413          	addi	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r" (x) );
80000da8:	100024f3          	csrr	s1,sstatus
80000dac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
80000db0:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
80000db4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
80000db8:	00001097          	auipc	ra,0x1
80000dbc:	4e8080e7          	jalr	1256(ra) # 800022a0 <mycpu>
80000dc0:	03c52783          	lw	a5,60(a0)
80000dc4:	02078663          	beqz	a5,80000df0 <push_off+0x5c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
80000dc8:	00001097          	auipc	ra,0x1
80000dcc:	4d8080e7          	jalr	1240(ra) # 800022a0 <mycpu>
80000dd0:	03c52783          	lw	a5,60(a0)
80000dd4:	00178793          	addi	a5,a5,1
80000dd8:	02f52e23          	sw	a5,60(a0)
}
80000ddc:	00c12083          	lw	ra,12(sp)
80000de0:	00812403          	lw	s0,8(sp)
80000de4:	00412483          	lw	s1,4(sp)
80000de8:	01010113          	addi	sp,sp,16
80000dec:	00008067          	ret
    mycpu()->intena = old;
80000df0:	00001097          	auipc	ra,0x1
80000df4:	4b0080e7          	jalr	1200(ra) # 800022a0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
80000df8:	0014d493          	srli	s1,s1,0x1
80000dfc:	0014f493          	andi	s1,s1,1
80000e00:	04952023          	sw	s1,64(a0)
80000e04:	fc5ff06f          	j	80000dc8 <push_off+0x34>

80000e08 <pop_off>:

void
pop_off(void)
{
80000e08:	ff010113          	addi	sp,sp,-16
80000e0c:	00112623          	sw	ra,12(sp)
80000e10:	00812423          	sw	s0,8(sp)
80000e14:	01010413          	addi	s0,sp,16
  struct cpu *c = mycpu();
80000e18:	00001097          	auipc	ra,0x1
80000e1c:	488080e7          	jalr	1160(ra) # 800022a0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
80000e20:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
80000e24:	0027f793          	andi	a5,a5,2
  if(intr_get())
80000e28:	04079463          	bnez	a5,80000e70 <pop_off+0x68>
    panic("pop_off - interruptible");
  c->noff -= 1;
80000e2c:	03c52783          	lw	a5,60(a0)
80000e30:	fff78793          	addi	a5,a5,-1
80000e34:	02f52e23          	sw	a5,60(a0)
  if(c->noff < 0)
80000e38:	0407c463          	bltz	a5,80000e80 <pop_off+0x78>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
80000e3c:	02079263          	bnez	a5,80000e60 <pop_off+0x58>
80000e40:	04052783          	lw	a5,64(a0)
80000e44:	00078e63          	beqz	a5,80000e60 <pop_off+0x58>
  asm volatile("csrr %0, sie" : "=r" (x) );
80000e48:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
80000e4c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
80000e50:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
80000e54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
80000e58:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
80000e5c:	10079073          	csrw	sstatus,a5
    intr_on();
}
80000e60:	00c12083          	lw	ra,12(sp)
80000e64:	00812403          	lw	s0,8(sp)
80000e68:	01010113          	addi	sp,sp,16
80000e6c:	00008067          	ret
    panic("pop_off - interruptible");
80000e70:	0000b517          	auipc	a0,0xb
80000e74:	a9c50513          	addi	a0,a0,-1380 # 8000b90c <userret+0x286c>
80000e78:	00000097          	auipc	ra,0x0
80000e7c:	888080e7          	jalr	-1912(ra) # 80000700 <panic>
    panic("pop_off");
80000e80:	0000b517          	auipc	a0,0xb
80000e84:	aa450513          	addi	a0,a0,-1372 # 8000b924 <userret+0x2884>
80000e88:	00000097          	auipc	ra,0x0
80000e8c:	878080e7          	jalr	-1928(ra) # 80000700 <panic>

80000e90 <holding>:
{
80000e90:	ff010113          	addi	sp,sp,-16
80000e94:	00112623          	sw	ra,12(sp)
80000e98:	00812423          	sw	s0,8(sp)
80000e9c:	00912223          	sw	s1,4(sp)
80000ea0:	01010413          	addi	s0,sp,16
80000ea4:	00050493          	mv	s1,a0
  push_off();
80000ea8:	00000097          	auipc	ra,0x0
80000eac:	eec080e7          	jalr	-276(ra) # 80000d94 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
80000eb0:	0004a783          	lw	a5,0(s1)
80000eb4:	02079463          	bnez	a5,80000edc <holding+0x4c>
80000eb8:	00000493          	li	s1,0
  pop_off();
80000ebc:	00000097          	auipc	ra,0x0
80000ec0:	f4c080e7          	jalr	-180(ra) # 80000e08 <pop_off>
}
80000ec4:	00048513          	mv	a0,s1
80000ec8:	00c12083          	lw	ra,12(sp)
80000ecc:	00812403          	lw	s0,8(sp)
80000ed0:	00412483          	lw	s1,4(sp)
80000ed4:	01010113          	addi	sp,sp,16
80000ed8:	00008067          	ret
  r = (lk->locked && lk->cpu == mycpu());
80000edc:	0084a483          	lw	s1,8(s1)
80000ee0:	00001097          	auipc	ra,0x1
80000ee4:	3c0080e7          	jalr	960(ra) # 800022a0 <mycpu>
80000ee8:	40a484b3          	sub	s1,s1,a0
80000eec:	0014b493          	seqz	s1,s1
80000ef0:	fcdff06f          	j	80000ebc <holding+0x2c>

80000ef4 <acquire>:
{
80000ef4:	ff010113          	addi	sp,sp,-16
80000ef8:	00112623          	sw	ra,12(sp)
80000efc:	00812423          	sw	s0,8(sp)
80000f00:	00912223          	sw	s1,4(sp)
80000f04:	01010413          	addi	s0,sp,16
80000f08:	00050493          	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
80000f0c:	00000097          	auipc	ra,0x0
80000f10:	e88080e7          	jalr	-376(ra) # 80000d94 <push_off>
  if(holding(lk))
80000f14:	00048513          	mv	a0,s1
80000f18:	00000097          	auipc	ra,0x0
80000f1c:	f78080e7          	jalr	-136(ra) # 80000e90 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
80000f20:	00100713          	li	a4,1
  if(holding(lk))
80000f24:	02051a63          	bnez	a0,80000f58 <acquire+0x64>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
80000f28:	00070793          	mv	a5,a4
80000f2c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
80000f30:	fe079ce3          	bnez	a5,80000f28 <acquire+0x34>
  __sync_synchronize();
80000f34:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
80000f38:	00001097          	auipc	ra,0x1
80000f3c:	368080e7          	jalr	872(ra) # 800022a0 <mycpu>
80000f40:	00a4a423          	sw	a0,8(s1)
}
80000f44:	00c12083          	lw	ra,12(sp)
80000f48:	00812403          	lw	s0,8(sp)
80000f4c:	00412483          	lw	s1,4(sp)
80000f50:	01010113          	addi	sp,sp,16
80000f54:	00008067          	ret
    panic("acquire");
80000f58:	0000b517          	auipc	a0,0xb
80000f5c:	9d450513          	addi	a0,a0,-1580 # 8000b92c <userret+0x288c>
80000f60:	fffff097          	auipc	ra,0xfffff
80000f64:	7a0080e7          	jalr	1952(ra) # 80000700 <panic>

80000f68 <release>:
{
80000f68:	ff010113          	addi	sp,sp,-16
80000f6c:	00112623          	sw	ra,12(sp)
80000f70:	00812423          	sw	s0,8(sp)
80000f74:	00912223          	sw	s1,4(sp)
80000f78:	01010413          	addi	s0,sp,16
80000f7c:	00050493          	mv	s1,a0
  if(!holding(lk))
80000f80:	00000097          	auipc	ra,0x0
80000f84:	f10080e7          	jalr	-240(ra) # 80000e90 <holding>
80000f88:	02050863          	beqz	a0,80000fb8 <release+0x50>
  lk->cpu = 0;
80000f8c:	0004a423          	sw	zero,8(s1)
  __sync_synchronize();
80000f90:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
80000f94:	0310000f          	fence	rw,w
80000f98:	0004a023          	sw	zero,0(s1)
  pop_off();
80000f9c:	00000097          	auipc	ra,0x0
80000fa0:	e6c080e7          	jalr	-404(ra) # 80000e08 <pop_off>
}
80000fa4:	00c12083          	lw	ra,12(sp)
80000fa8:	00812403          	lw	s0,8(sp)
80000fac:	00412483          	lw	s1,4(sp)
80000fb0:	01010113          	addi	sp,sp,16
80000fb4:	00008067          	ret
    panic("release");
80000fb8:	0000b517          	auipc	a0,0xb
80000fbc:	97c50513          	addi	a0,a0,-1668 # 8000b934 <userret+0x2894>
80000fc0:	fffff097          	auipc	ra,0xfffff
80000fc4:	740080e7          	jalr	1856(ra) # 80000700 <panic>

80000fc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
80000fc8:	ff010113          	addi	sp,sp,-16
80000fcc:	00112623          	sw	ra,12(sp)
80000fd0:	00812423          	sw	s0,8(sp)
80000fd4:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
80000fd8:	00060c63          	beqz	a2,80000ff0 <memset+0x28>
80000fdc:	00050793          	mv	a5,a0
80000fe0:	00a60633          	add	a2,a2,a0
    cdst[i] = c;
80000fe4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
80000fe8:	00178793          	addi	a5,a5,1
80000fec:	fec79ce3          	bne	a5,a2,80000fe4 <memset+0x1c>
  }
  return dst;
}
80000ff0:	00c12083          	lw	ra,12(sp)
80000ff4:	00812403          	lw	s0,8(sp)
80000ff8:	01010113          	addi	sp,sp,16
80000ffc:	00008067          	ret

80001000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80001000:	ff010113          	addi	sp,sp,-16
80001004:	00112623          	sw	ra,12(sp)
80001008:	00812423          	sw	s0,8(sp)
8000100c:	01010413          	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80001010:	02060e63          	beqz	a2,8000104c <memcmp+0x4c>
80001014:	00c50633          	add	a2,a0,a2
    if(*s1 != *s2)
80001018:	00054783          	lbu	a5,0(a0)
8000101c:	0005c703          	lbu	a4,0(a1) # 88000000 <end+0x7fd9fec>
80001020:	00e79c63          	bne	a5,a4,80001038 <memcmp+0x38>
      return *s1 - *s2;
    s1++, s2++;
80001024:	00150513          	addi	a0,a0,1
80001028:	00158593          	addi	a1,a1,1
  while(n-- > 0){
8000102c:	fea616e3          	bne	a2,a0,80001018 <memcmp+0x18>
  }

  return 0;
80001030:	00000513          	li	a0,0
80001034:	0080006f          	j	8000103c <memcmp+0x3c>
      return *s1 - *s2;
80001038:	40e78533          	sub	a0,a5,a4
}
8000103c:	00c12083          	lw	ra,12(sp)
80001040:	00812403          	lw	s0,8(sp)
80001044:	01010113          	addi	sp,sp,16
80001048:	00008067          	ret
  return 0;
8000104c:	00000513          	li	a0,0
80001050:	fedff06f          	j	8000103c <memcmp+0x3c>

80001054 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80001054:	ff010113          	addi	sp,sp,-16
80001058:	00112623          	sw	ra,12(sp)
8000105c:	00812423          	sw	s0,8(sp)
80001060:	01010413          	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80001064:	02a5ea63          	bltu	a1,a0,80001098 <memmove+0x44>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80001068:	00c586b3          	add	a3,a1,a2
8000106c:	00050793          	mv	a5,a0
80001070:	00060c63          	beqz	a2,80001088 <memmove+0x34>
      *d++ = *s++;
80001074:	00158593          	addi	a1,a1,1
80001078:	00178793          	addi	a5,a5,1
8000107c:	fff5c703          	lbu	a4,-1(a1)
80001080:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
80001084:	fed598e3          	bne	a1,a3,80001074 <memmove+0x20>

  return dst;
}
80001088:	00c12083          	lw	ra,12(sp)
8000108c:	00812403          	lw	s0,8(sp)
80001090:	01010113          	addi	sp,sp,16
80001094:	00008067          	ret
  if(s < d && s + n > d){
80001098:	00c587b3          	add	a5,a1,a2
8000109c:	fcf576e3          	bgeu	a0,a5,80001068 <memmove+0x14>
    d += n;
800010a0:	00c50733          	add	a4,a0,a2
    while(n-- > 0)
800010a4:	fe0602e3          	beqz	a2,80001088 <memmove+0x34>
      *--d = *--s;
800010a8:	fff78793          	addi	a5,a5,-1
800010ac:	fff70713          	addi	a4,a4,-1 # ffffefff <end+0x7ffd8feb>
800010b0:	0007c683          	lbu	a3,0(a5)
800010b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
800010b8:	fef598e3          	bne	a1,a5,800010a8 <memmove+0x54>
800010bc:	fcdff06f          	j	80001088 <memmove+0x34>

800010c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
800010c0:	ff010113          	addi	sp,sp,-16
800010c4:	00112623          	sw	ra,12(sp)
800010c8:	00812423          	sw	s0,8(sp)
800010cc:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
800010d0:	00000097          	auipc	ra,0x0
800010d4:	f84080e7          	jalr	-124(ra) # 80001054 <memmove>
}
800010d8:	00c12083          	lw	ra,12(sp)
800010dc:	00812403          	lw	s0,8(sp)
800010e0:	01010113          	addi	sp,sp,16
800010e4:	00008067          	ret

800010e8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
800010e8:	ff010113          	addi	sp,sp,-16
800010ec:	00112623          	sw	ra,12(sp)
800010f0:	00812423          	sw	s0,8(sp)
800010f4:	01010413          	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
800010f8:	02060663          	beqz	a2,80001124 <strncmp+0x3c>
800010fc:	00054783          	lbu	a5,0(a0)
80001100:	02078663          	beqz	a5,8000112c <strncmp+0x44>
80001104:	0005c703          	lbu	a4,0(a1)
80001108:	02f71263          	bne	a4,a5,8000112c <strncmp+0x44>
    n--, p++, q++;
8000110c:	fff60613          	addi	a2,a2,-1 # fff <_entry-0x7ffff001>
80001110:	00150513          	addi	a0,a0,1
80001114:	00158593          	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
80001118:	fe0612e3          	bnez	a2,800010fc <strncmp+0x14>
  if(n == 0)
    return 0;
8000111c:	00000513          	li	a0,0
80001120:	0180006f          	j	80001138 <strncmp+0x50>
80001124:	00000513          	li	a0,0
80001128:	0100006f          	j	80001138 <strncmp+0x50>
  return (uchar)*p - (uchar)*q;
8000112c:	00054503          	lbu	a0,0(a0)
80001130:	0005c783          	lbu	a5,0(a1)
80001134:	40f50533          	sub	a0,a0,a5
}
80001138:	00c12083          	lw	ra,12(sp)
8000113c:	00812403          	lw	s0,8(sp)
80001140:	01010113          	addi	sp,sp,16
80001144:	00008067          	ret

80001148 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80001148:	ff010113          	addi	sp,sp,-16
8000114c:	00112623          	sw	ra,12(sp)
80001150:	00812423          	sw	s0,8(sp)
80001154:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80001158:	00050793          	mv	a5,a0
8000115c:	00060693          	mv	a3,a2
80001160:	fff60613          	addi	a2,a2,-1
80001164:	02d05c63          	blez	a3,8000119c <strncpy+0x54>
80001168:	00158593          	addi	a1,a1,1
8000116c:	00178793          	addi	a5,a5,1
80001170:	fff5c703          	lbu	a4,-1(a1)
80001174:	fee78fa3          	sb	a4,-1(a5)
80001178:	fe0712e3          	bnez	a4,8000115c <strncpy+0x14>
    ;
  while(n-- > 0)
8000117c:	00078713          	mv	a4,a5
80001180:	00d787b3          	add	a5,a5,a3
80001184:	fff78793          	addi	a5,a5,-1
80001188:	00c05a63          	blez	a2,8000119c <strncpy+0x54>
    *s++ = 0;
8000118c:	00170713          	addi	a4,a4,1
80001190:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
80001194:	40e786b3          	sub	a3,a5,a4
80001198:	fed04ae3          	bgtz	a3,8000118c <strncpy+0x44>
  return os;
}
8000119c:	00c12083          	lw	ra,12(sp)
800011a0:	00812403          	lw	s0,8(sp)
800011a4:	01010113          	addi	sp,sp,16
800011a8:	00008067          	ret

800011ac <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
800011ac:	ff010113          	addi	sp,sp,-16
800011b0:	00112623          	sw	ra,12(sp)
800011b4:	00812423          	sw	s0,8(sp)
800011b8:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
800011bc:	02c05663          	blez	a2,800011e8 <safestrcpy+0x3c>
800011c0:	fff60613          	addi	a2,a2,-1
800011c4:	00c586b3          	add	a3,a1,a2
800011c8:	00050793          	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
800011cc:	00d58c63          	beq	a1,a3,800011e4 <safestrcpy+0x38>
800011d0:	00158593          	addi	a1,a1,1
800011d4:	00178793          	addi	a5,a5,1
800011d8:	fff5c703          	lbu	a4,-1(a1)
800011dc:	fee78fa3          	sb	a4,-1(a5)
800011e0:	fe0716e3          	bnez	a4,800011cc <safestrcpy+0x20>
    ;
  *s = 0;
800011e4:	00078023          	sb	zero,0(a5)
  return os;
}
800011e8:	00c12083          	lw	ra,12(sp)
800011ec:	00812403          	lw	s0,8(sp)
800011f0:	01010113          	addi	sp,sp,16
800011f4:	00008067          	ret

800011f8 <strlen>:

int
strlen(const char *s)
{
800011f8:	ff010113          	addi	sp,sp,-16
800011fc:	00112623          	sw	ra,12(sp)
80001200:	00812423          	sw	s0,8(sp)
80001204:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
80001208:	00054783          	lbu	a5,0(a0)
8000120c:	02078663          	beqz	a5,80001238 <strlen+0x40>
80001210:	00050713          	mv	a4,a0
80001214:	00000513          	li	a0,0
80001218:	00150513          	addi	a0,a0,1
8000121c:	00a707b3          	add	a5,a4,a0
80001220:	0007c783          	lbu	a5,0(a5)
80001224:	fe079ae3          	bnez	a5,80001218 <strlen+0x20>
    ;
  return n;
}
80001228:	00c12083          	lw	ra,12(sp)
8000122c:	00812403          	lw	s0,8(sp)
80001230:	01010113          	addi	sp,sp,16
80001234:	00008067          	ret
  for(n = 0; s[n]; n++)
80001238:	00000513          	li	a0,0
  return n;
8000123c:	fedff06f          	j	80001228 <strlen+0x30>

80001240 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
80001240:	ff010113          	addi	sp,sp,-16
80001244:	00112623          	sw	ra,12(sp)
80001248:	00812423          	sw	s0,8(sp)
8000124c:	01010413          	addi	s0,sp,16
  if(cpuid() == 0){
80001250:	00001097          	auipc	ra,0x1
80001254:	02c080e7          	jalr	44(ra) # 8000227c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
80001258:	00025717          	auipc	a4,0x25
8000125c:	dac70713          	addi	a4,a4,-596 # 80026004 <started>
  if(cpuid() == 0){
80001260:	04050663          	beqz	a0,800012ac <main+0x6c>
    while(started == 0)
80001264:	00072783          	lw	a5,0(a4)
80001268:	fe078ee3          	beqz	a5,80001264 <main+0x24>
      ;
    __sync_synchronize();
8000126c:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
80001270:	00001097          	auipc	ra,0x1
80001274:	00c080e7          	jalr	12(ra) # 8000227c <cpuid>
80001278:	00050593          	mv	a1,a0
8000127c:	0000a517          	auipc	a0,0xa
80001280:	6d850513          	addi	a0,a0,1752 # 8000b954 <userret+0x28b4>
80001284:	fffff097          	auipc	ra,0xfffff
80001288:	4d8080e7          	jalr	1240(ra) # 8000075c <printf>
    kvminithart();    // turn on paging
8000128c:	00000097          	auipc	ra,0x0
80001290:	24c080e7          	jalr	588(ra) # 800014d8 <kvminithart>
    trapinithart();   // install kernel trap vector
80001294:	00002097          	auipc	ra,0x2
80001298:	0a0080e7          	jalr	160(ra) # 80003334 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
8000129c:	00007097          	auipc	ra,0x7
800012a0:	b34080e7          	jalr	-1228(ra) # 80007dd0 <plicinithart>
  }

  scheduler();        
800012a4:	00001097          	auipc	ra,0x1
800012a8:	6e8080e7          	jalr	1768(ra) # 8000298c <scheduler>
    consoleinit();
800012ac:	fffff097          	auipc	ra,0xfffff
800012b0:	338080e7          	jalr	824(ra) # 800005e4 <consoleinit>
    printfinit();
800012b4:	fffff097          	auipc	ra,0xfffff
800012b8:	75c080e7          	jalr	1884(ra) # 80000a10 <printfinit>
    printf("\n");
800012bc:	0000a517          	auipc	a0,0xa
800012c0:	62450513          	addi	a0,a0,1572 # 8000b8e0 <userret+0x2840>
800012c4:	fffff097          	auipc	ra,0xfffff
800012c8:	498080e7          	jalr	1176(ra) # 8000075c <printf>
    printf("xv6 kernel is booting\n");
800012cc:	0000a517          	auipc	a0,0xa
800012d0:	67050513          	addi	a0,a0,1648 # 8000b93c <userret+0x289c>
800012d4:	fffff097          	auipc	ra,0xfffff
800012d8:	488080e7          	jalr	1160(ra) # 8000075c <printf>
    printf("\n");
800012dc:	0000a517          	auipc	a0,0xa
800012e0:	60450513          	addi	a0,a0,1540 # 8000b8e0 <userret+0x2840>
800012e4:	fffff097          	auipc	ra,0xfffff
800012e8:	478080e7          	jalr	1144(ra) # 8000075c <printf>
    kinit();         // physical page allocator
800012ec:	00000097          	auipc	ra,0x0
800012f0:	9a8080e7          	jalr	-1624(ra) # 80000c94 <kinit>
    kvminit();       // create kernel page table
800012f4:	00000097          	auipc	ra,0x0
800012f8:	44c080e7          	jalr	1100(ra) # 80001740 <kvminit>
    kvminithart();   // turn on paging
800012fc:	00000097          	auipc	ra,0x0
80001300:	1dc080e7          	jalr	476(ra) # 800014d8 <kvminithart>
    procinit();      // process table
80001304:	00001097          	auipc	ra,0x1
80001308:	e58080e7          	jalr	-424(ra) # 8000215c <procinit>
    trapinit();      // trap vectors
8000130c:	00002097          	auipc	ra,0x2
80001310:	ff0080e7          	jalr	-16(ra) # 800032fc <trapinit>
    trapinithart();  // install kernel trap vector
80001314:	00002097          	auipc	ra,0x2
80001318:	020080e7          	jalr	32(ra) # 80003334 <trapinithart>
    plicinit();      // set up interrupt controller
8000131c:	00007097          	auipc	ra,0x7
80001320:	a84080e7          	jalr	-1404(ra) # 80007da0 <plicinit>
    plicinithart();  // ask PLIC for device interrupts
80001324:	00007097          	auipc	ra,0x7
80001328:	aac080e7          	jalr	-1364(ra) # 80007dd0 <plicinithart>
    binit();         // buffer cache
8000132c:	00003097          	auipc	ra,0x3
80001330:	a58080e7          	jalr	-1448(ra) # 80003d84 <binit>
    iinit();         // inode cache
80001334:	00003097          	auipc	ra,0x3
80001338:	304080e7          	jalr	772(ra) # 80004638 <iinit>
    fileinit();      // file table
8000133c:	00005097          	auipc	ra,0x5
80001340:	8c8080e7          	jalr	-1848(ra) # 80005c04 <fileinit>
    virtio_disk_init(); // emulated hard disk
80001344:	00007097          	auipc	ra,0x7
80001348:	c2c080e7          	jalr	-980(ra) # 80007f70 <virtio_disk_init>
    userinit();      // first user process
8000134c:	00001097          	auipc	ra,0x1
80001350:	308080e7          	jalr	776(ra) # 80002654 <userinit>
    __sync_synchronize();
80001354:	0330000f          	fence	rw,rw
    started = 1;
80001358:	00100793          	li	a5,1
8000135c:	00025717          	auipc	a4,0x25
80001360:	caf72423          	sw	a5,-856(a4) # 80026004 <started>
80001364:	f41ff06f          	j	800012a4 <main+0x64>

80001368 <walk>:
//    0.. 7 -- flags: Valid/Read/Write/Execute/User/Global/Accessed/Dirty
// 

static pte_t *
walk(pagetable_t pagetable, uint32 va, int alloc)
{
80001368:	fe010113          	addi	sp,sp,-32
8000136c:	00112e23          	sw	ra,28(sp)
80001370:	00812c23          	sw	s0,24(sp)
80001374:	00912a23          	sw	s1,20(sp)
80001378:	01212823          	sw	s2,16(sp)
8000137c:	01312623          	sw	s3,12(sp)
80001380:	02010413          	addi	s0,sp,32
  if(va >= MAXVA)
80001384:	fff00793          	li	a5,-1
80001388:	04f58c63          	beq	a1,a5,800013e0 <walk+0x78>
8000138c:	00058493          	mv	s1,a1
    panic("walk");

  for(int level = 1; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
80001390:	0165d793          	srli	a5,a1,0x16
80001394:	00279793          	slli	a5,a5,0x2
80001398:	00f509b3          	add	s3,a0,a5
    if(*pte & PTE_V) {
8000139c:	0009a903          	lw	s2,0(s3)
800013a0:	00197793          	andi	a5,s2,1
800013a4:	04078663          	beqz	a5,800013f0 <walk+0x88>
      pagetable = (pagetable_t)PTE2PA(*pte);
800013a8:	00a95913          	srli	s2,s2,0xa
800013ac:	00c91913          	slli	s2,s2,0xc
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
800013b0:	00c4d493          	srli	s1,s1,0xc
800013b4:	3ff4f493          	andi	s1,s1,1023
800013b8:	00249493          	slli	s1,s1,0x2
800013bc:	00990933          	add	s2,s2,s1
}
800013c0:	00090513          	mv	a0,s2
800013c4:	01c12083          	lw	ra,28(sp)
800013c8:	01812403          	lw	s0,24(sp)
800013cc:	01412483          	lw	s1,20(sp)
800013d0:	01012903          	lw	s2,16(sp)
800013d4:	00c12983          	lw	s3,12(sp)
800013d8:	02010113          	addi	sp,sp,32
800013dc:	00008067          	ret
    panic("walk");
800013e0:	0000a517          	auipc	a0,0xa
800013e4:	58850513          	addi	a0,a0,1416 # 8000b968 <userret+0x28c8>
800013e8:	fffff097          	auipc	ra,0xfffff
800013ec:	318080e7          	jalr	792(ra) # 80000700 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
800013f0:	02060c63          	beqz	a2,80001428 <walk+0xc0>
800013f4:	00000097          	auipc	ra,0x0
800013f8:	8ec080e7          	jalr	-1812(ra) # 80000ce0 <kalloc>
800013fc:	00050913          	mv	s2,a0
80001400:	fc0500e3          	beqz	a0,800013c0 <walk+0x58>
      memset(pagetable, 0, PGSIZE);
80001404:	00001637          	lui	a2,0x1
80001408:	00000593          	li	a1,0
8000140c:	00000097          	auipc	ra,0x0
80001410:	bbc080e7          	jalr	-1092(ra) # 80000fc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
80001414:	00c95793          	srli	a5,s2,0xc
80001418:	00a79793          	slli	a5,a5,0xa
8000141c:	0017e793          	ori	a5,a5,1
80001420:	00f9a023          	sw	a5,0(s3)
80001424:	f8dff06f          	j	800013b0 <walk+0x48>
        return 0;
80001428:	00000913          	li	s2,0
8000142c:	f95ff06f          	j	800013c0 <walk+0x58>

80001430 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
80001430:	fe010113          	addi	sp,sp,-32
80001434:	00112e23          	sw	ra,28(sp)
80001438:	00812c23          	sw	s0,24(sp)
8000143c:	00912a23          	sw	s1,20(sp)
80001440:	01212823          	sw	s2,16(sp)
80001444:	01312623          	sw	s3,12(sp)
80001448:	01412423          	sw	s4,8(sp)
8000144c:	02010413          	addi	s0,sp,32
80001450:	00050a13          	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
80001454:	00050493          	mv	s1,a0
80001458:	00001937          	lui	s2,0x1
8000145c:	80090913          	addi	s2,s2,-2048 # 800 <_entry-0x7ffff800>
80001460:	01250933          	add	s2,a0,s2
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
80001464:	00100993          	li	s3,1
80001468:	0200006f          	j	80001488 <freewalk+0x58>
      // this PTE points to a lower-level page table.
      uint32 child = PTE2PA(pte);
8000146c:	00a7d793          	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
80001470:	00c79513          	slli	a0,a5,0xc
80001474:	00000097          	auipc	ra,0x0
80001478:	fbc080e7          	jalr	-68(ra) # 80001430 <freewalk>
      pagetable[i] = 0;
8000147c:	0004a023          	sw	zero,0(s1)
  for(int i = 0; i < 512; i++){
80001480:	00448493          	addi	s1,s1,4
80001484:	03248463          	beq	s1,s2,800014ac <freewalk+0x7c>
    pte_t pte = pagetable[i];
80001488:	0004a783          	lw	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
8000148c:	00f7f713          	andi	a4,a5,15
80001490:	fd370ee3          	beq	a4,s3,8000146c <freewalk+0x3c>
    } else if(pte & PTE_V){
80001494:	0017f793          	andi	a5,a5,1
80001498:	fe0784e3          	beqz	a5,80001480 <freewalk+0x50>
      panic("freewalk: leaf");
8000149c:	0000a517          	auipc	a0,0xa
800014a0:	4d450513          	addi	a0,a0,1236 # 8000b970 <userret+0x28d0>
800014a4:	fffff097          	auipc	ra,0xfffff
800014a8:	25c080e7          	jalr	604(ra) # 80000700 <panic>
    }
  }
  kfree((void*)pagetable);
800014ac:	000a0513          	mv	a0,s4
800014b0:	fffff097          	auipc	ra,0xfffff
800014b4:	6cc080e7          	jalr	1740(ra) # 80000b7c <kfree>
}
800014b8:	01c12083          	lw	ra,28(sp)
800014bc:	01812403          	lw	s0,24(sp)
800014c0:	01412483          	lw	s1,20(sp)
800014c4:	01012903          	lw	s2,16(sp)
800014c8:	00c12983          	lw	s3,12(sp)
800014cc:	00812a03          	lw	s4,8(sp)
800014d0:	02010113          	addi	sp,sp,32
800014d4:	00008067          	ret

800014d8 <kvminithart>:
{
800014d8:	ff010113          	addi	sp,sp,-16
800014dc:	00112623          	sw	ra,12(sp)
800014e0:	00812423          	sw	s0,8(sp)
800014e4:	01010413          	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
800014e8:	00025797          	auipc	a5,0x25
800014ec:	b207a783          	lw	a5,-1248(a5) # 80026008 <kernel_pagetable>
800014f0:	00c7d793          	srli	a5,a5,0xc
800014f4:	80000737          	lui	a4,0x80000
800014f8:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
800014fc:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
80001500:	12000073          	sfence.vma
}
80001504:	00c12083          	lw	ra,12(sp)
80001508:	00812403          	lw	s0,8(sp)
8000150c:	01010113          	addi	sp,sp,16
80001510:	00008067          	ret

80001514 <walkaddr>:
  if(va >= MAXVA)
80001514:	fff00793          	li	a5,-1
80001518:	04f58a63          	beq	a1,a5,8000156c <walkaddr+0x58>
{
8000151c:	ff010113          	addi	sp,sp,-16
80001520:	00112623          	sw	ra,12(sp)
80001524:	00812423          	sw	s0,8(sp)
80001528:	01010413          	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
8000152c:	00000613          	li	a2,0
80001530:	00000097          	auipc	ra,0x0
80001534:	e38080e7          	jalr	-456(ra) # 80001368 <walk>
  if(pte == 0)
80001538:	02050e63          	beqz	a0,80001574 <walkaddr+0x60>
  if((*pte & PTE_V) == 0)
8000153c:	00052783          	lw	a5,0(a0)
  if((*pte & PTE_U) == 0)
80001540:	0117f693          	andi	a3,a5,17
80001544:	01100713          	li	a4,17
    return 0;
80001548:	00000513          	li	a0,0
  if((*pte & PTE_U) == 0)
8000154c:	00e68a63          	beq	a3,a4,80001560 <walkaddr+0x4c>
}
80001550:	00c12083          	lw	ra,12(sp)
80001554:	00812403          	lw	s0,8(sp)
80001558:	01010113          	addi	sp,sp,16
8000155c:	00008067          	ret
  pa = PTE2PA(*pte);
80001560:	00a7d793          	srli	a5,a5,0xa
80001564:	00c79513          	slli	a0,a5,0xc
  return pa;
80001568:	fe9ff06f          	j	80001550 <walkaddr+0x3c>
    return 0;
8000156c:	00000513          	li	a0,0
}
80001570:	00008067          	ret
    return 0;
80001574:	00000513          	li	a0,0
80001578:	fd9ff06f          	j	80001550 <walkaddr+0x3c>

8000157c <kvmpa>:
{
8000157c:	ff010113          	addi	sp,sp,-16
80001580:	00112623          	sw	ra,12(sp)
80001584:	00812423          	sw	s0,8(sp)
80001588:	00912223          	sw	s1,4(sp)
8000158c:	01010413          	addi	s0,sp,16
80001590:	00050593          	mv	a1,a0
  uint32 off = va % PGSIZE;
80001594:	01451513          	slli	a0,a0,0x14
80001598:	01455493          	srli	s1,a0,0x14
  pte = walk(kernel_pagetable, va, 0);
8000159c:	00000613          	li	a2,0
800015a0:	00025517          	auipc	a0,0x25
800015a4:	a6852503          	lw	a0,-1432(a0) # 80026008 <kernel_pagetable>
800015a8:	00000097          	auipc	ra,0x0
800015ac:	dc0080e7          	jalr	-576(ra) # 80001368 <walk>
  if(pte == 0)
800015b0:	02050863          	beqz	a0,800015e0 <kvmpa+0x64>
  if((*pte & PTE_V) == 0)
800015b4:	00052503          	lw	a0,0(a0)
800015b8:	00157793          	andi	a5,a0,1
800015bc:	02078a63          	beqz	a5,800015f0 <kvmpa+0x74>
  pa = PTE2PA(*pte);
800015c0:	00a55513          	srli	a0,a0,0xa
800015c4:	00c51513          	slli	a0,a0,0xc
}
800015c8:	00950533          	add	a0,a0,s1
800015cc:	00c12083          	lw	ra,12(sp)
800015d0:	00812403          	lw	s0,8(sp)
800015d4:	00412483          	lw	s1,4(sp)
800015d8:	01010113          	addi	sp,sp,16
800015dc:	00008067          	ret
    panic("kvmpa");
800015e0:	0000a517          	auipc	a0,0xa
800015e4:	3a050513          	addi	a0,a0,928 # 8000b980 <userret+0x28e0>
800015e8:	fffff097          	auipc	ra,0xfffff
800015ec:	118080e7          	jalr	280(ra) # 80000700 <panic>
    panic("kvmpa");
800015f0:	0000a517          	auipc	a0,0xa
800015f4:	39050513          	addi	a0,a0,912 # 8000b980 <userret+0x28e0>
800015f8:	fffff097          	auipc	ra,0xfffff
800015fc:	108080e7          	jalr	264(ra) # 80000700 <panic>

80001600 <mappages>:
{
80001600:	fd010113          	addi	sp,sp,-48
80001604:	02112623          	sw	ra,44(sp)
80001608:	02812423          	sw	s0,40(sp)
8000160c:	02912223          	sw	s1,36(sp)
80001610:	03212023          	sw	s2,32(sp)
80001614:	01312e23          	sw	s3,28(sp)
80001618:	01412c23          	sw	s4,24(sp)
8000161c:	01512a23          	sw	s5,20(sp)
80001620:	01612823          	sw	s6,16(sp)
80001624:	01712623          	sw	s7,12(sp)
80001628:	01812423          	sw	s8,8(sp)
8000162c:	03010413          	addi	s0,sp,48
80001630:	00050a93          	mv	s5,a0
80001634:	00070b13          	mv	s6,a4
  a = PGROUNDDOWN(va);
80001638:	fffff737          	lui	a4,0xfffff
8000163c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
80001640:	fff60993          	addi	s3,a2,-1 # fff <_entry-0x7ffff001>
80001644:	00b989b3          	add	s3,s3,a1
80001648:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
8000164c:	00078913          	mv	s2,a5
80001650:	40f68a33          	sub	s4,a3,a5
    if((pte = walk(pagetable, a, 1)) == 0)
80001654:	00100b93          	li	s7,1
    a += PGSIZE;
80001658:	00001c37          	lui	s8,0x1
8000165c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
80001660:	000b8613          	mv	a2,s7
80001664:	00090593          	mv	a1,s2
80001668:	000a8513          	mv	a0,s5
8000166c:	00000097          	auipc	ra,0x0
80001670:	cfc080e7          	jalr	-772(ra) # 80001368 <walk>
80001674:	04050063          	beqz	a0,800016b4 <mappages+0xb4>
    if(*pte & PTE_V)
80001678:	00052783          	lw	a5,0(a0)
8000167c:	0017f793          	andi	a5,a5,1
80001680:	02079263          	bnez	a5,800016a4 <mappages+0xa4>
    *pte = PA2PTE(pa) | perm | PTE_V;
80001684:	00c4d493          	srli	s1,s1,0xc
80001688:	00a49493          	slli	s1,s1,0xa
8000168c:	0164e4b3          	or	s1,s1,s6
80001690:	0014e493          	ori	s1,s1,1
80001694:	00952023          	sw	s1,0(a0)
    if(a == last)
80001698:	05390863          	beq	s2,s3,800016e8 <mappages+0xe8>
    a += PGSIZE;
8000169c:	01890933          	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
800016a0:	fbdff06f          	j	8000165c <mappages+0x5c>
      panic("remap");
800016a4:	0000a517          	auipc	a0,0xa
800016a8:	2e450513          	addi	a0,a0,740 # 8000b988 <userret+0x28e8>
800016ac:	fffff097          	auipc	ra,0xfffff
800016b0:	054080e7          	jalr	84(ra) # 80000700 <panic>
      return -1;
800016b4:	fff00513          	li	a0,-1
}
800016b8:	02c12083          	lw	ra,44(sp)
800016bc:	02812403          	lw	s0,40(sp)
800016c0:	02412483          	lw	s1,36(sp)
800016c4:	02012903          	lw	s2,32(sp)
800016c8:	01c12983          	lw	s3,28(sp)
800016cc:	01812a03          	lw	s4,24(sp)
800016d0:	01412a83          	lw	s5,20(sp)
800016d4:	01012b03          	lw	s6,16(sp)
800016d8:	00c12b83          	lw	s7,12(sp)
800016dc:	00812c03          	lw	s8,8(sp)
800016e0:	03010113          	addi	sp,sp,48
800016e4:	00008067          	ret
  return 0;
800016e8:	00000513          	li	a0,0
800016ec:	fcdff06f          	j	800016b8 <mappages+0xb8>

800016f0 <kvmmap>:
{
800016f0:	ff010113          	addi	sp,sp,-16
800016f4:	00112623          	sw	ra,12(sp)
800016f8:	00812423          	sw	s0,8(sp)
800016fc:	01010413          	addi	s0,sp,16
80001700:	00068713          	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
80001704:	00058693          	mv	a3,a1
80001708:	00050593          	mv	a1,a0
8000170c:	00025517          	auipc	a0,0x25
80001710:	8fc52503          	lw	a0,-1796(a0) # 80026008 <kernel_pagetable>
80001714:	00000097          	auipc	ra,0x0
80001718:	eec080e7          	jalr	-276(ra) # 80001600 <mappages>
8000171c:	00051a63          	bnez	a0,80001730 <kvmmap+0x40>
}
80001720:	00c12083          	lw	ra,12(sp)
80001724:	00812403          	lw	s0,8(sp)
80001728:	01010113          	addi	sp,sp,16
8000172c:	00008067          	ret
    panic("kvmmap");
80001730:	0000a517          	auipc	a0,0xa
80001734:	26050513          	addi	a0,a0,608 # 8000b990 <userret+0x28f0>
80001738:	fffff097          	auipc	ra,0xfffff
8000173c:	fc8080e7          	jalr	-56(ra) # 80000700 <panic>

80001740 <kvminit>:
{
80001740:	ff010113          	addi	sp,sp,-16
80001744:	00112623          	sw	ra,12(sp)
80001748:	00812423          	sw	s0,8(sp)
8000174c:	00912223          	sw	s1,4(sp)
80001750:	01010413          	addi	s0,sp,16
  kernel_pagetable = (pagetable_t) kalloc();
80001754:	fffff097          	auipc	ra,0xfffff
80001758:	58c080e7          	jalr	1420(ra) # 80000ce0 <kalloc>
8000175c:	00025797          	auipc	a5,0x25
80001760:	8aa7a623          	sw	a0,-1876(a5) # 80026008 <kernel_pagetable>
  if (kernel_pagetable == 0) { 
80001764:	0e050663          	beqz	a0,80001850 <kvminit+0x110>
  memset(kernel_pagetable, 0, PGSIZE);
80001768:	00001637          	lui	a2,0x1
8000176c:	00000593          	li	a1,0
80001770:	00025517          	auipc	a0,0x25
80001774:	89852503          	lw	a0,-1896(a0) # 80026008 <kernel_pagetable>
80001778:	00000097          	auipc	ra,0x0
8000177c:	850080e7          	jalr	-1968(ra) # 80000fc8 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
80001780:	00600693          	li	a3,6
80001784:	00001637          	lui	a2,0x1
80001788:	100005b7          	lui	a1,0x10000
8000178c:	00058513          	mv	a0,a1
80001790:	00000097          	auipc	ra,0x0
80001794:	f60080e7          	jalr	-160(ra) # 800016f0 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
80001798:	00600693          	li	a3,6
8000179c:	00001637          	lui	a2,0x1
800017a0:	100015b7          	lui	a1,0x10001
800017a4:	00058513          	mv	a0,a1
800017a8:	00000097          	auipc	ra,0x0
800017ac:	f48080e7          	jalr	-184(ra) # 800016f0 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
800017b0:	00600693          	li	a3,6
800017b4:	00010637          	lui	a2,0x10
800017b8:	020005b7          	lui	a1,0x2000
800017bc:	00058513          	mv	a0,a1
800017c0:	00000097          	auipc	ra,0x0
800017c4:	f30080e7          	jalr	-208(ra) # 800016f0 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
800017c8:	00600693          	li	a3,6
800017cc:	00400637          	lui	a2,0x400
800017d0:	0c0005b7          	lui	a1,0xc000
800017d4:	00058513          	mv	a0,a1
800017d8:	00000097          	auipc	ra,0x0
800017dc:	f18080e7          	jalr	-232(ra) # 800016f0 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint32)etext-KERNBASE, PTE_R | PTE_X);
800017e0:	0000b497          	auipc	s1,0xb
800017e4:	82048493          	addi	s1,s1,-2016 # 8000c000 <initcode>
800017e8:	80000537          	lui	a0,0x80000
800017ec:	00a00693          	li	a3,10
800017f0:	8000b617          	auipc	a2,0x8000b
800017f4:	81060613          	addi	a2,a2,-2032 # c000 <_entry-0x7fff4000>
800017f8:	00050593          	mv	a1,a0
800017fc:	00000097          	auipc	ra,0x0
80001800:	ef4080e7          	jalr	-268(ra) # 800016f0 <kvmmap>
  kvmmap((uint32)etext, (uint32)etext, PHYSTOP-(uint32)etext, PTE_R | PTE_W);
80001804:	00600693          	li	a3,6
80001808:	88000637          	lui	a2,0x88000
8000180c:	40960633          	sub	a2,a2,s1
80001810:	00048593          	mv	a1,s1
80001814:	00048513          	mv	a0,s1
80001818:	00000097          	auipc	ra,0x0
8000181c:	ed8080e7          	jalr	-296(ra) # 800016f0 <kvmmap>
  kvmmap(TRAMPOLINE, (uint32)trampoline, PGSIZE, PTE_R | PTE_X);
80001820:	00a00693          	li	a3,10
80001824:	00001637          	lui	a2,0x1
80001828:	00007597          	auipc	a1,0x7
8000182c:	7d858593          	addi	a1,a1,2008 # 80009000 <trampoline>
80001830:	fffff537          	lui	a0,0xfffff
80001834:	00000097          	auipc	ra,0x0
80001838:	ebc080e7          	jalr	-324(ra) # 800016f0 <kvmmap>
}
8000183c:	00c12083          	lw	ra,12(sp)
80001840:	00812403          	lw	s0,8(sp)
80001844:	00412483          	lw	s1,4(sp)
80001848:	01010113          	addi	sp,sp,16
8000184c:	00008067          	ret
    printf("kalloc failed\n");
80001850:	0000a517          	auipc	a0,0xa
80001854:	14850513          	addi	a0,a0,328 # 8000b998 <userret+0x28f8>
80001858:	fffff097          	auipc	ra,0xfffff
8000185c:	f04080e7          	jalr	-252(ra) # 8000075c <printf>
80001860:	f09ff06f          	j	80001768 <kvminit+0x28>

80001864 <uvmunmap>:
{
80001864:	fd010113          	addi	sp,sp,-48
80001868:	02112623          	sw	ra,44(sp)
8000186c:	02812423          	sw	s0,40(sp)
80001870:	02912223          	sw	s1,36(sp)
80001874:	03212023          	sw	s2,32(sp)
80001878:	01312e23          	sw	s3,28(sp)
8000187c:	01412c23          	sw	s4,24(sp)
80001880:	01512a23          	sw	s5,20(sp)
80001884:	01612823          	sw	s6,16(sp)
80001888:	01712623          	sw	s7,12(sp)
8000188c:	03010413          	addi	s0,sp,48
80001890:	00050a13          	mv	s4,a0
80001894:	00068a93          	mv	s5,a3
  a = PGROUNDDOWN(va);
80001898:	fffff7b7          	lui	a5,0xfffff
8000189c:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
800018a0:	fff60993          	addi	s3,a2,-1 # fff <_entry-0x7ffff001>
800018a4:	00b989b3          	add	s3,s3,a1
800018a8:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
800018ac:	00100b13          	li	s6,1
    a += PGSIZE;
800018b0:	00001bb7          	lui	s7,0x1
800018b4:	0540006f          	j	80001908 <uvmunmap+0xa4>
      panic("uvmunmap: walk");
800018b8:	0000a517          	auipc	a0,0xa
800018bc:	0f050513          	addi	a0,a0,240 # 8000b9a8 <userret+0x2908>
800018c0:	fffff097          	auipc	ra,0xfffff
800018c4:	e40080e7          	jalr	-448(ra) # 80000700 <panic>
      printf("va=%p pte=%p\n", a, *pte);
800018c8:	00090593          	mv	a1,s2
800018cc:	0000a517          	auipc	a0,0xa
800018d0:	0ec50513          	addi	a0,a0,236 # 8000b9b8 <userret+0x2918>
800018d4:	fffff097          	auipc	ra,0xfffff
800018d8:	e88080e7          	jalr	-376(ra) # 8000075c <printf>
      panic("uvmunmap: not mapped");
800018dc:	0000a517          	auipc	a0,0xa
800018e0:	0ec50513          	addi	a0,a0,236 # 8000b9c8 <userret+0x2928>
800018e4:	fffff097          	auipc	ra,0xfffff
800018e8:	e1c080e7          	jalr	-484(ra) # 80000700 <panic>
      panic("uvmunmap: not a leaf");
800018ec:	0000a517          	auipc	a0,0xa
800018f0:	0f450513          	addi	a0,a0,244 # 8000b9e0 <userret+0x2940>
800018f4:	fffff097          	auipc	ra,0xfffff
800018f8:	e0c080e7          	jalr	-500(ra) # 80000700 <panic>
    *pte = 0;
800018fc:	0004a023          	sw	zero,0(s1)
    if(a == last)
80001900:	05390863          	beq	s2,s3,80001950 <uvmunmap+0xec>
    a += PGSIZE;
80001904:	01790933          	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
80001908:	00000613          	li	a2,0
8000190c:	00090593          	mv	a1,s2
80001910:	000a0513          	mv	a0,s4
80001914:	00000097          	auipc	ra,0x0
80001918:	a54080e7          	jalr	-1452(ra) # 80001368 <walk>
8000191c:	00050493          	mv	s1,a0
80001920:	f8050ce3          	beqz	a0,800018b8 <uvmunmap+0x54>
    if((*pte & PTE_V) == 0){
80001924:	00052603          	lw	a2,0(a0)
80001928:	00167793          	andi	a5,a2,1
8000192c:	f8078ee3          	beqz	a5,800018c8 <uvmunmap+0x64>
    if(PTE_FLAGS(*pte) == PTE_V)
80001930:	3ff67793          	andi	a5,a2,1023
80001934:	fb678ce3          	beq	a5,s6,800018ec <uvmunmap+0x88>
    if(do_free){
80001938:	fc0a82e3          	beqz	s5,800018fc <uvmunmap+0x98>
      pa = PTE2PA(*pte);
8000193c:	00a65613          	srli	a2,a2,0xa
      kfree((void*)pa);
80001940:	00c61513          	slli	a0,a2,0xc
80001944:	fffff097          	auipc	ra,0xfffff
80001948:	238080e7          	jalr	568(ra) # 80000b7c <kfree>
8000194c:	fb1ff06f          	j	800018fc <uvmunmap+0x98>
}
80001950:	02c12083          	lw	ra,44(sp)
80001954:	02812403          	lw	s0,40(sp)
80001958:	02412483          	lw	s1,36(sp)
8000195c:	02012903          	lw	s2,32(sp)
80001960:	01c12983          	lw	s3,28(sp)
80001964:	01812a03          	lw	s4,24(sp)
80001968:	01412a83          	lw	s5,20(sp)
8000196c:	01012b03          	lw	s6,16(sp)
80001970:	00c12b83          	lw	s7,12(sp)
80001974:	03010113          	addi	sp,sp,48
80001978:	00008067          	ret

8000197c <uvmcreate>:
{
8000197c:	ff010113          	addi	sp,sp,-16
80001980:	00112623          	sw	ra,12(sp)
80001984:	00812423          	sw	s0,8(sp)
80001988:	00912223          	sw	s1,4(sp)
8000198c:	01010413          	addi	s0,sp,16
  pagetable = (pagetable_t) kalloc();
80001990:	fffff097          	auipc	ra,0xfffff
80001994:	350080e7          	jalr	848(ra) # 80000ce0 <kalloc>
  if(pagetable == 0)
80001998:	02050863          	beqz	a0,800019c8 <uvmcreate+0x4c>
8000199c:	00050493          	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
800019a0:	00001637          	lui	a2,0x1
800019a4:	00000593          	li	a1,0
800019a8:	fffff097          	auipc	ra,0xfffff
800019ac:	620080e7          	jalr	1568(ra) # 80000fc8 <memset>
}
800019b0:	00048513          	mv	a0,s1
800019b4:	00c12083          	lw	ra,12(sp)
800019b8:	00812403          	lw	s0,8(sp)
800019bc:	00412483          	lw	s1,4(sp)
800019c0:	01010113          	addi	sp,sp,16
800019c4:	00008067          	ret
    panic("uvmcreate: out of memory");
800019c8:	0000a517          	auipc	a0,0xa
800019cc:	03050513          	addi	a0,a0,48 # 8000b9f8 <userret+0x2958>
800019d0:	fffff097          	auipc	ra,0xfffff
800019d4:	d30080e7          	jalr	-720(ra) # 80000700 <panic>

800019d8 <uvminit>:
{
800019d8:	fe010113          	addi	sp,sp,-32
800019dc:	00112e23          	sw	ra,28(sp)
800019e0:	00812c23          	sw	s0,24(sp)
800019e4:	00912a23          	sw	s1,20(sp)
800019e8:	01212823          	sw	s2,16(sp)
800019ec:	01312623          	sw	s3,12(sp)
800019f0:	01412423          	sw	s4,8(sp)
800019f4:	02010413          	addi	s0,sp,32
  if(sz >= PGSIZE)
800019f8:	000017b7          	lui	a5,0x1
800019fc:	06f67e63          	bgeu	a2,a5,80001a78 <uvminit+0xa0>
80001a00:	00050a13          	mv	s4,a0
80001a04:	00058993          	mv	s3,a1
80001a08:	00060493          	mv	s1,a2
  mem = kalloc();
80001a0c:	fffff097          	auipc	ra,0xfffff
80001a10:	2d4080e7          	jalr	724(ra) # 80000ce0 <kalloc>
80001a14:	00050913          	mv	s2,a0
  memset(mem, 0, PGSIZE);
80001a18:	00001637          	lui	a2,0x1
80001a1c:	00000593          	li	a1,0
80001a20:	fffff097          	auipc	ra,0xfffff
80001a24:	5a8080e7          	jalr	1448(ra) # 80000fc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint32)mem, PTE_W|PTE_R|PTE_X|PTE_U);
80001a28:	01e00713          	li	a4,30
80001a2c:	00090693          	mv	a3,s2
80001a30:	00001637          	lui	a2,0x1
80001a34:	00000593          	li	a1,0
80001a38:	000a0513          	mv	a0,s4
80001a3c:	00000097          	auipc	ra,0x0
80001a40:	bc4080e7          	jalr	-1084(ra) # 80001600 <mappages>
  memmove(mem, src, sz);
80001a44:	00048613          	mv	a2,s1
80001a48:	00098593          	mv	a1,s3
80001a4c:	00090513          	mv	a0,s2
80001a50:	fffff097          	auipc	ra,0xfffff
80001a54:	604080e7          	jalr	1540(ra) # 80001054 <memmove>
}
80001a58:	01c12083          	lw	ra,28(sp)
80001a5c:	01812403          	lw	s0,24(sp)
80001a60:	01412483          	lw	s1,20(sp)
80001a64:	01012903          	lw	s2,16(sp)
80001a68:	00c12983          	lw	s3,12(sp)
80001a6c:	00812a03          	lw	s4,8(sp)
80001a70:	02010113          	addi	sp,sp,32
80001a74:	00008067          	ret
    panic("inituvm: more than a page");
80001a78:	0000a517          	auipc	a0,0xa
80001a7c:	f9c50513          	addi	a0,a0,-100 # 8000ba14 <userret+0x2974>
80001a80:	fffff097          	auipc	ra,0xfffff
80001a84:	c80080e7          	jalr	-896(ra) # 80000700 <panic>

80001a88 <uvmdealloc>:
{
80001a88:	ff010113          	addi	sp,sp,-16
80001a8c:	00112623          	sw	ra,12(sp)
80001a90:	00812423          	sw	s0,8(sp)
80001a94:	00912223          	sw	s1,4(sp)
80001a98:	01010413          	addi	s0,sp,16
    return oldsz;
80001a9c:	00058493          	mv	s1,a1
  if(newsz >= oldsz)
80001aa0:	02b67463          	bgeu	a2,a1,80001ac8 <uvmdealloc+0x40>
80001aa4:	00060493          	mv	s1,a2
  uint32 newup = PGROUNDUP(newsz);
80001aa8:	000017b7          	lui	a5,0x1
80001aac:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
80001ab0:	00f60733          	add	a4,a2,a5
80001ab4:	fffff6b7          	lui	a3,0xfffff
80001ab8:	00d77733          	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
80001abc:	00f587b3          	add	a5,a1,a5
80001ac0:	00d7f7b3          	and	a5,a5,a3
80001ac4:	00f76e63          	bltu	a4,a5,80001ae0 <uvmdealloc+0x58>
}
80001ac8:	00048513          	mv	a0,s1
80001acc:	00c12083          	lw	ra,12(sp)
80001ad0:	00812403          	lw	s0,8(sp)
80001ad4:	00412483          	lw	s1,4(sp)
80001ad8:	01010113          	addi	sp,sp,16
80001adc:	00008067          	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
80001ae0:	00100693          	li	a3,1
80001ae4:	40e58633          	sub	a2,a1,a4
80001ae8:	00070593          	mv	a1,a4
80001aec:	00000097          	auipc	ra,0x0
80001af0:	d78080e7          	jalr	-648(ra) # 80001864 <uvmunmap>
80001af4:	fd5ff06f          	j	80001ac8 <uvmdealloc+0x40>

80001af8 <uvmalloc>:
  if(newsz < oldsz)
80001af8:	12b66c63          	bltu	a2,a1,80001c30 <uvmalloc+0x138>
{
80001afc:	fd010113          	addi	sp,sp,-48
80001b00:	02112623          	sw	ra,44(sp)
80001b04:	02812423          	sw	s0,40(sp)
80001b08:	01412c23          	sw	s4,24(sp)
80001b0c:	01512a23          	sw	s5,20(sp)
80001b10:	01612823          	sw	s6,16(sp)
80001b14:	03010413          	addi	s0,sp,48
80001b18:	00050b13          	mv	s6,a0
80001b1c:	00060a93          	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
80001b20:	000017b7          	lui	a5,0x1
80001b24:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
80001b28:	00f585b3          	add	a1,a1,a5
80001b2c:	fffff7b7          	lui	a5,0xfffff
80001b30:	00f5fa33          	and	s4,a1,a5
  for(; a < newsz; a += PGSIZE){
80001b34:	10ca7263          	bgeu	s4,a2,80001c38 <uvmalloc+0x140>
80001b38:	02912223          	sw	s1,36(sp)
80001b3c:	03212023          	sw	s2,32(sp)
80001b40:	01312e23          	sw	s3,28(sp)
80001b44:	01712623          	sw	s7,12(sp)
  a = oldsz;
80001b48:	000a0913          	mv	s2,s4
    memset(mem, 0, PGSIZE);
80001b4c:	000019b7          	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint32)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
80001b50:	01e00b93          	li	s7,30
    mem = kalloc();
80001b54:	fffff097          	auipc	ra,0xfffff
80001b58:	18c080e7          	jalr	396(ra) # 80000ce0 <kalloc>
80001b5c:	00050493          	mv	s1,a0
    if(mem == 0){
80001b60:	04050a63          	beqz	a0,80001bb4 <uvmalloc+0xbc>
    memset(mem, 0, PGSIZE);
80001b64:	00098613          	mv	a2,s3
80001b68:	00000593          	li	a1,0
80001b6c:	fffff097          	auipc	ra,0xfffff
80001b70:	45c080e7          	jalr	1116(ra) # 80000fc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint32)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
80001b74:	000b8713          	mv	a4,s7
80001b78:	00048693          	mv	a3,s1
80001b7c:	00098613          	mv	a2,s3
80001b80:	00090593          	mv	a1,s2
80001b84:	000b0513          	mv	a0,s6
80001b88:	00000097          	auipc	ra,0x0
80001b8c:	a78080e7          	jalr	-1416(ra) # 80001600 <mappages>
80001b90:	06051463          	bnez	a0,80001bf8 <uvmalloc+0x100>
  for(; a < newsz; a += PGSIZE){
80001b94:	01390933          	add	s2,s2,s3
80001b98:	fb596ee3          	bltu	s2,s5,80001b54 <uvmalloc+0x5c>
  return newsz;
80001b9c:	000a8513          	mv	a0,s5
80001ba0:	02412483          	lw	s1,36(sp)
80001ba4:	02012903          	lw	s2,32(sp)
80001ba8:	01c12983          	lw	s3,28(sp)
80001bac:	00c12b83          	lw	s7,12(sp)
80001bb0:	02c0006f          	j	80001bdc <uvmalloc+0xe4>
      uvmdealloc(pagetable, a, oldsz);
80001bb4:	000a0613          	mv	a2,s4
80001bb8:	00090593          	mv	a1,s2
80001bbc:	000b0513          	mv	a0,s6
80001bc0:	00000097          	auipc	ra,0x0
80001bc4:	ec8080e7          	jalr	-312(ra) # 80001a88 <uvmdealloc>
      return 0;
80001bc8:	00000513          	li	a0,0
80001bcc:	02412483          	lw	s1,36(sp)
80001bd0:	02012903          	lw	s2,32(sp)
80001bd4:	01c12983          	lw	s3,28(sp)
80001bd8:	00c12b83          	lw	s7,12(sp)
}
80001bdc:	02c12083          	lw	ra,44(sp)
80001be0:	02812403          	lw	s0,40(sp)
80001be4:	01812a03          	lw	s4,24(sp)
80001be8:	01412a83          	lw	s5,20(sp)
80001bec:	01012b03          	lw	s6,16(sp)
80001bf0:	03010113          	addi	sp,sp,48
80001bf4:	00008067          	ret
      kfree(mem);
80001bf8:	00048513          	mv	a0,s1
80001bfc:	fffff097          	auipc	ra,0xfffff
80001c00:	f80080e7          	jalr	-128(ra) # 80000b7c <kfree>
      uvmdealloc(pagetable, a, oldsz);
80001c04:	000a0613          	mv	a2,s4
80001c08:	00090593          	mv	a1,s2
80001c0c:	000b0513          	mv	a0,s6
80001c10:	00000097          	auipc	ra,0x0
80001c14:	e78080e7          	jalr	-392(ra) # 80001a88 <uvmdealloc>
      return 0;
80001c18:	00000513          	li	a0,0
80001c1c:	02412483          	lw	s1,36(sp)
80001c20:	02012903          	lw	s2,32(sp)
80001c24:	01c12983          	lw	s3,28(sp)
80001c28:	00c12b83          	lw	s7,12(sp)
80001c2c:	fb1ff06f          	j	80001bdc <uvmalloc+0xe4>
    return oldsz;
80001c30:	00058513          	mv	a0,a1
}
80001c34:	00008067          	ret
  return newsz;
80001c38:	00060513          	mv	a0,a2
80001c3c:	fa1ff06f          	j	80001bdc <uvmalloc+0xe4>

80001c40 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint32 sz)
{
80001c40:	ff010113          	addi	sp,sp,-16
80001c44:	00112623          	sw	ra,12(sp)
80001c48:	00812423          	sw	s0,8(sp)
80001c4c:	00912223          	sw	s1,4(sp)
80001c50:	01010413          	addi	s0,sp,16
80001c54:	00050493          	mv	s1,a0
80001c58:	00058613          	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
80001c5c:	00100693          	li	a3,1
80001c60:	00000593          	li	a1,0
80001c64:	00000097          	auipc	ra,0x0
80001c68:	c00080e7          	jalr	-1024(ra) # 80001864 <uvmunmap>
  freewalk(pagetable);
80001c6c:	00048513          	mv	a0,s1
80001c70:	fffff097          	auipc	ra,0xfffff
80001c74:	7c0080e7          	jalr	1984(ra) # 80001430 <freewalk>
}
80001c78:	00c12083          	lw	ra,12(sp)
80001c7c:	00812403          	lw	s0,8(sp)
80001c80:	00412483          	lw	s1,4(sp)
80001c84:	01010113          	addi	sp,sp,16
80001c88:	00008067          	ret

80001c8c <uvmcopy>:
  pte_t *pte;
  uint32 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
80001c8c:	12060e63          	beqz	a2,80001dc8 <uvmcopy+0x13c>
{
80001c90:	fd010113          	addi	sp,sp,-48
80001c94:	02112623          	sw	ra,44(sp)
80001c98:	02812423          	sw	s0,40(sp)
80001c9c:	02912223          	sw	s1,36(sp)
80001ca0:	03212023          	sw	s2,32(sp)
80001ca4:	01312e23          	sw	s3,28(sp)
80001ca8:	01412c23          	sw	s4,24(sp)
80001cac:	01512a23          	sw	s5,20(sp)
80001cb0:	01612823          	sw	s6,16(sp)
80001cb4:	01712623          	sw	s7,12(sp)
80001cb8:	01812423          	sw	s8,8(sp)
80001cbc:	03010413          	addi	s0,sp,48
80001cc0:	00050b93          	mv	s7,a0
80001cc4:	00058b13          	mv	s6,a1
80001cc8:	00060a93          	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
80001ccc:	00000993          	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
80001cd0:	00001a37          	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
80001cd4:	00000613          	li	a2,0
80001cd8:	00098593          	mv	a1,s3
80001cdc:	000b8513          	mv	a0,s7
80001ce0:	fffff097          	auipc	ra,0xfffff
80001ce4:	688080e7          	jalr	1672(ra) # 80001368 <walk>
80001ce8:	06050463          	beqz	a0,80001d50 <uvmcopy+0xc4>
    if((*pte & PTE_V) == 0)
80001cec:	00052703          	lw	a4,0(a0)
80001cf0:	00177793          	andi	a5,a4,1
80001cf4:	06078663          	beqz	a5,80001d60 <uvmcopy+0xd4>
    pa = PTE2PA(*pte);
80001cf8:	00a75593          	srli	a1,a4,0xa
80001cfc:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
80001d00:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
80001d04:	fffff097          	auipc	ra,0xfffff
80001d08:	fdc080e7          	jalr	-36(ra) # 80000ce0 <kalloc>
80001d0c:	00050913          	mv	s2,a0
80001d10:	06050663          	beqz	a0,80001d7c <uvmcopy+0xf0>
    memmove(mem, (char*)pa, PGSIZE);
80001d14:	000a0613          	mv	a2,s4
80001d18:	000c0593          	mv	a1,s8
80001d1c:	fffff097          	auipc	ra,0xfffff
80001d20:	338080e7          	jalr	824(ra) # 80001054 <memmove>
    if(mappages(new, i, PGSIZE, (uint32)mem, flags) != 0){
80001d24:	00048713          	mv	a4,s1
80001d28:	00090693          	mv	a3,s2
80001d2c:	000a0613          	mv	a2,s4
80001d30:	00098593          	mv	a1,s3
80001d34:	000b0513          	mv	a0,s6
80001d38:	00000097          	auipc	ra,0x0
80001d3c:	8c8080e7          	jalr	-1848(ra) # 80001600 <mappages>
80001d40:	02051863          	bnez	a0,80001d70 <uvmcopy+0xe4>
  for(i = 0; i < sz; i += PGSIZE){
80001d44:	014989b3          	add	s3,s3,s4
80001d48:	f959e6e3          	bltu	s3,s5,80001cd4 <uvmcopy+0x48>
80001d4c:	04c0006f          	j	80001d98 <uvmcopy+0x10c>
      panic("uvmcopy: pte should exist");
80001d50:	0000a517          	auipc	a0,0xa
80001d54:	ce050513          	addi	a0,a0,-800 # 8000ba30 <userret+0x2990>
80001d58:	fffff097          	auipc	ra,0xfffff
80001d5c:	9a8080e7          	jalr	-1624(ra) # 80000700 <panic>
      panic("uvmcopy: page not present");
80001d60:	0000a517          	auipc	a0,0xa
80001d64:	cec50513          	addi	a0,a0,-788 # 8000ba4c <userret+0x29ac>
80001d68:	fffff097          	auipc	ra,0xfffff
80001d6c:	998080e7          	jalr	-1640(ra) # 80000700 <panic>
      kfree(mem);
80001d70:	00090513          	mv	a0,s2
80001d74:	fffff097          	auipc	ra,0xfffff
80001d78:	e08080e7          	jalr	-504(ra) # 80000b7c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
80001d7c:	00100693          	li	a3,1
80001d80:	00098613          	mv	a2,s3
80001d84:	00000593          	li	a1,0
80001d88:	000b0513          	mv	a0,s6
80001d8c:	00000097          	auipc	ra,0x0
80001d90:	ad8080e7          	jalr	-1320(ra) # 80001864 <uvmunmap>
  return -1;
80001d94:	fff00513          	li	a0,-1
}
80001d98:	02c12083          	lw	ra,44(sp)
80001d9c:	02812403          	lw	s0,40(sp)
80001da0:	02412483          	lw	s1,36(sp)
80001da4:	02012903          	lw	s2,32(sp)
80001da8:	01c12983          	lw	s3,28(sp)
80001dac:	01812a03          	lw	s4,24(sp)
80001db0:	01412a83          	lw	s5,20(sp)
80001db4:	01012b03          	lw	s6,16(sp)
80001db8:	00c12b83          	lw	s7,12(sp)
80001dbc:	00812c03          	lw	s8,8(sp)
80001dc0:	03010113          	addi	sp,sp,48
80001dc4:	00008067          	ret
  return 0;
80001dc8:	00000513          	li	a0,0
}
80001dcc:	00008067          	ret

80001dd0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint32 va)
{
80001dd0:	ff010113          	addi	sp,sp,-16
80001dd4:	00112623          	sw	ra,12(sp)
80001dd8:	00812423          	sw	s0,8(sp)
80001ddc:	01010413          	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
80001de0:	00000613          	li	a2,0
80001de4:	fffff097          	auipc	ra,0xfffff
80001de8:	584080e7          	jalr	1412(ra) # 80001368 <walk>
  if(pte == 0)
80001dec:	02050063          	beqz	a0,80001e0c <uvmclear+0x3c>
    panic("uvmclear");
  *pte &= ~PTE_U;
80001df0:	00052783          	lw	a5,0(a0)
80001df4:	fef7f793          	andi	a5,a5,-17
80001df8:	00f52023          	sw	a5,0(a0)
}
80001dfc:	00c12083          	lw	ra,12(sp)
80001e00:	00812403          	lw	s0,8(sp)
80001e04:	01010113          	addi	sp,sp,16
80001e08:	00008067          	ret
    panic("uvmclear");
80001e0c:	0000a517          	auipc	a0,0xa
80001e10:	c5c50513          	addi	a0,a0,-932 # 8000ba68 <userret+0x29c8>
80001e14:	fffff097          	auipc	ra,0xfffff
80001e18:	8ec080e7          	jalr	-1812(ra) # 80000700 <panic>

80001e1c <copyout>:
int
copyout(pagetable_t pagetable, uint32 dstva, char *src, uint32 len)
{
  uint32 n, va0, pa0;

  while(len > 0){
80001e1c:	0a068663          	beqz	a3,80001ec8 <copyout+0xac>
{
80001e20:	fd010113          	addi	sp,sp,-48
80001e24:	02112623          	sw	ra,44(sp)
80001e28:	02812423          	sw	s0,40(sp)
80001e2c:	02912223          	sw	s1,36(sp)
80001e30:	03212023          	sw	s2,32(sp)
80001e34:	01312e23          	sw	s3,28(sp)
80001e38:	01412c23          	sw	s4,24(sp)
80001e3c:	01512a23          	sw	s5,20(sp)
80001e40:	01612823          	sw	s6,16(sp)
80001e44:	01712623          	sw	s7,12(sp)
80001e48:	01812423          	sw	s8,8(sp)
80001e4c:	03010413          	addi	s0,sp,48
80001e50:	00050b13          	mv	s6,a0
80001e54:	00058c13          	mv	s8,a1
80001e58:	00060a13          	mv	s4,a2
80001e5c:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
80001e60:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
80001e64:	00001ab7          	lui	s5,0x1
80001e68:	02c0006f          	j	80001e94 <copyout+0x78>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
80001e6c:	01850533          	add	a0,a0,s8
80001e70:	00048613          	mv	a2,s1
80001e74:	000a0593          	mv	a1,s4
80001e78:	41250533          	sub	a0,a0,s2
80001e7c:	fffff097          	auipc	ra,0xfffff
80001e80:	1d8080e7          	jalr	472(ra) # 80001054 <memmove>

    len -= n;
80001e84:	409989b3          	sub	s3,s3,s1
    src += n;
80001e88:	009a0a33          	add	s4,s4,s1
    dstva = va0 + PGSIZE;
80001e8c:	01590c33          	add	s8,s2,s5
  while(len > 0){
80001e90:	02098863          	beqz	s3,80001ec0 <copyout+0xa4>
    va0 = PGROUNDDOWN(dstva);
80001e94:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
80001e98:	00090593          	mv	a1,s2
80001e9c:	000b0513          	mv	a0,s6
80001ea0:	fffff097          	auipc	ra,0xfffff
80001ea4:	674080e7          	jalr	1652(ra) # 80001514 <walkaddr>
    if(pa0 == 0)
80001ea8:	02050463          	beqz	a0,80001ed0 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
80001eac:	418904b3          	sub	s1,s2,s8
80001eb0:	015484b3          	add	s1,s1,s5
    if(n > len)
80001eb4:	fa99fce3          	bgeu	s3,s1,80001e6c <copyout+0x50>
80001eb8:	00098493          	mv	s1,s3
80001ebc:	fb1ff06f          	j	80001e6c <copyout+0x50>
  }
  return 0;
80001ec0:	00000513          	li	a0,0
80001ec4:	0100006f          	j	80001ed4 <copyout+0xb8>
80001ec8:	00000513          	li	a0,0
}
80001ecc:	00008067          	ret
      return -1;
80001ed0:	fff00513          	li	a0,-1
}
80001ed4:	02c12083          	lw	ra,44(sp)
80001ed8:	02812403          	lw	s0,40(sp)
80001edc:	02412483          	lw	s1,36(sp)
80001ee0:	02012903          	lw	s2,32(sp)
80001ee4:	01c12983          	lw	s3,28(sp)
80001ee8:	01812a03          	lw	s4,24(sp)
80001eec:	01412a83          	lw	s5,20(sp)
80001ef0:	01012b03          	lw	s6,16(sp)
80001ef4:	00c12b83          	lw	s7,12(sp)
80001ef8:	00812c03          	lw	s8,8(sp)
80001efc:	03010113          	addi	sp,sp,48
80001f00:	00008067          	ret

80001f04 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint32 srcva, uint32 len)
{
  uint32 n, va0, pa0;

  while(len > 0){
80001f04:	0a068663          	beqz	a3,80001fb0 <copyin+0xac>
{
80001f08:	fd010113          	addi	sp,sp,-48
80001f0c:	02112623          	sw	ra,44(sp)
80001f10:	02812423          	sw	s0,40(sp)
80001f14:	02912223          	sw	s1,36(sp)
80001f18:	03212023          	sw	s2,32(sp)
80001f1c:	01312e23          	sw	s3,28(sp)
80001f20:	01412c23          	sw	s4,24(sp)
80001f24:	01512a23          	sw	s5,20(sp)
80001f28:	01612823          	sw	s6,16(sp)
80001f2c:	01712623          	sw	s7,12(sp)
80001f30:	01812423          	sw	s8,8(sp)
80001f34:	03010413          	addi	s0,sp,48
80001f38:	00050b13          	mv	s6,a0
80001f3c:	00058a13          	mv	s4,a1
80001f40:	00060c13          	mv	s8,a2
80001f44:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
80001f48:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
80001f4c:	00001ab7          	lui	s5,0x1
80001f50:	02c0006f          	j	80001f7c <copyin+0x78>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
80001f54:	018505b3          	add	a1,a0,s8
80001f58:	00048613          	mv	a2,s1
80001f5c:	412585b3          	sub	a1,a1,s2
80001f60:	000a0513          	mv	a0,s4
80001f64:	fffff097          	auipc	ra,0xfffff
80001f68:	0f0080e7          	jalr	240(ra) # 80001054 <memmove>

    len -= n;
80001f6c:	409989b3          	sub	s3,s3,s1
    dst += n;
80001f70:	009a0a33          	add	s4,s4,s1
    srcva = va0 + PGSIZE;
80001f74:	01590c33          	add	s8,s2,s5
  while(len > 0){
80001f78:	02098863          	beqz	s3,80001fa8 <copyin+0xa4>
    va0 = PGROUNDDOWN(srcva);
80001f7c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
80001f80:	00090593          	mv	a1,s2
80001f84:	000b0513          	mv	a0,s6
80001f88:	fffff097          	auipc	ra,0xfffff
80001f8c:	58c080e7          	jalr	1420(ra) # 80001514 <walkaddr>
    if(pa0 == 0)
80001f90:	02050463          	beqz	a0,80001fb8 <copyin+0xb4>
    n = PGSIZE - (srcva - va0);
80001f94:	418904b3          	sub	s1,s2,s8
80001f98:	015484b3          	add	s1,s1,s5
    if(n > len)
80001f9c:	fa99fce3          	bgeu	s3,s1,80001f54 <copyin+0x50>
80001fa0:	00098493          	mv	s1,s3
80001fa4:	fb1ff06f          	j	80001f54 <copyin+0x50>
  }
  return 0;
80001fa8:	00000513          	li	a0,0
80001fac:	0100006f          	j	80001fbc <copyin+0xb8>
80001fb0:	00000513          	li	a0,0
}
80001fb4:	00008067          	ret
      return -1;
80001fb8:	fff00513          	li	a0,-1
}
80001fbc:	02c12083          	lw	ra,44(sp)
80001fc0:	02812403          	lw	s0,40(sp)
80001fc4:	02412483          	lw	s1,36(sp)
80001fc8:	02012903          	lw	s2,32(sp)
80001fcc:	01c12983          	lw	s3,28(sp)
80001fd0:	01812a03          	lw	s4,24(sp)
80001fd4:	01412a83          	lw	s5,20(sp)
80001fd8:	01012b03          	lw	s6,16(sp)
80001fdc:	00c12b83          	lw	s7,12(sp)
80001fe0:	00812c03          	lw	s8,8(sp)
80001fe4:	03010113          	addi	sp,sp,48
80001fe8:	00008067          	ret

80001fec <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint32 srcva, uint32 max)
{
80001fec:	fd010113          	addi	sp,sp,-48
80001ff0:	02112623          	sw	ra,44(sp)
80001ff4:	02812423          	sw	s0,40(sp)
80001ff8:	02912223          	sw	s1,36(sp)
80001ffc:	03212023          	sw	s2,32(sp)
80002000:	01312e23          	sw	s3,28(sp)
80002004:	01412c23          	sw	s4,24(sp)
80002008:	01512a23          	sw	s5,20(sp)
8000200c:	01612823          	sw	s6,16(sp)
80002010:	01712623          	sw	s7,12(sp)
80002014:	03010413          	addi	s0,sp,48
80002018:	00050a93          	mv	s5,a0
8000201c:	00058993          	mv	s3,a1
80002020:	00060b93          	mv	s7,a2
80002024:	00068493          	mv	s1,a3
  uint32 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
80002028:	fffffb37          	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
8000202c:	00001a37          	lui	s4,0x1
80002030:	0400006f          	j	80002070 <copyinstr+0x84>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
80002034:	00078023          	sb	zero,0(a5) # fffff000 <end+0x7ffd8fec>
80002038:	00100793          	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
8000203c:	fff78513          	addi	a0,a5,-1
    return 0;
  } else {
    return -1;
  }
}
80002040:	02c12083          	lw	ra,44(sp)
80002044:	02812403          	lw	s0,40(sp)
80002048:	02412483          	lw	s1,36(sp)
8000204c:	02012903          	lw	s2,32(sp)
80002050:	01c12983          	lw	s3,28(sp)
80002054:	01812a03          	lw	s4,24(sp)
80002058:	01412a83          	lw	s5,20(sp)
8000205c:	01012b03          	lw	s6,16(sp)
80002060:	00c12b83          	lw	s7,12(sp)
80002064:	03010113          	addi	sp,sp,48
80002068:	00008067          	ret
    srcva = va0 + PGSIZE;
8000206c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
80002070:	06048a63          	beqz	s1,800020e4 <copyinstr+0xf8>
    va0 = PGROUNDDOWN(srcva);
80002074:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
80002078:	00090593          	mv	a1,s2
8000207c:	000a8513          	mv	a0,s5
80002080:	fffff097          	auipc	ra,0xfffff
80002084:	494080e7          	jalr	1172(ra) # 80001514 <walkaddr>
    if(pa0 == 0)
80002088:	06050263          	beqz	a0,800020ec <copyinstr+0x100>
    n = PGSIZE - (srcva - va0);
8000208c:	41790633          	sub	a2,s2,s7
80002090:	01460633          	add	a2,a2,s4
    if(n > max)
80002094:	00c4f463          	bgeu	s1,a2,8000209c <copyinstr+0xb0>
80002098:	00048613          	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
8000209c:	412b8bb3          	sub	s7,s7,s2
800020a0:	00ab8bb3          	add	s7,s7,a0
    while(n > 0){
800020a4:	fc0604e3          	beqz	a2,8000206c <copyinstr+0x80>
800020a8:	00098793          	mv	a5,s3
      if(*p == '\0'){
800020ac:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
800020b0:	00c98633          	add	a2,s3,a2
800020b4:	00078593          	mv	a1,a5
      if(*p == '\0'){
800020b8:	00f68733          	add	a4,a3,a5
800020bc:	00074703          	lbu	a4,0(a4) # fffff000 <end+0x7ffd8fec>
800020c0:	f6070ae3          	beqz	a4,80002034 <copyinstr+0x48>
        *dst = *p;
800020c4:	00e78023          	sb	a4,0(a5)
      dst++;
800020c8:	00178793          	addi	a5,a5,1
    while(n > 0){
800020cc:	fec794e3          	bne	a5,a2,800020b4 <copyinstr+0xc8>
800020d0:	fff48493          	addi	s1,s1,-1
800020d4:	009984b3          	add	s1,s3,s1
      --max;
800020d8:	40b484b3          	sub	s1,s1,a1
800020dc:	00078993          	mv	s3,a5
800020e0:	f8dff06f          	j	8000206c <copyinstr+0x80>
800020e4:	00000793          	li	a5,0
800020e8:	f55ff06f          	j	8000203c <copyinstr+0x50>
      return -1;
800020ec:	fff00513          	li	a0,-1
800020f0:	f51ff06f          	j	80002040 <copyinstr+0x54>

800020f4 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
800020f4:	ff010113          	addi	sp,sp,-16
800020f8:	00112623          	sw	ra,12(sp)
800020fc:	00812423          	sw	s0,8(sp)
80002100:	00912223          	sw	s1,4(sp)
80002104:	01010413          	addi	s0,sp,16
80002108:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
8000210c:	fffff097          	auipc	ra,0xfffff
80002110:	d84080e7          	jalr	-636(ra) # 80000e90 <holding>
80002114:	02050063          	beqz	a0,80002134 <wakeup1+0x40>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
80002118:	0144a783          	lw	a5,20(s1)
8000211c:	02978463          	beq	a5,s1,80002144 <wakeup1+0x50>
    p->state = RUNNABLE;
  }
}
80002120:	00c12083          	lw	ra,12(sp)
80002124:	00812403          	lw	s0,8(sp)
80002128:	00412483          	lw	s1,4(sp)
8000212c:	01010113          	addi	sp,sp,16
80002130:	00008067          	ret
    panic("wakeup1");
80002134:	0000a517          	auipc	a0,0xa
80002138:	94050513          	addi	a0,a0,-1728 # 8000ba74 <userret+0x29d4>
8000213c:	ffffe097          	auipc	ra,0xffffe
80002140:	5c4080e7          	jalr	1476(ra) # 80000700 <panic>
  if(p->chan == p && p->state == SLEEPING) {
80002144:	00c4a703          	lw	a4,12(s1)
80002148:	00100793          	li	a5,1
8000214c:	fcf71ae3          	bne	a4,a5,80002120 <wakeup1+0x2c>
    p->state = RUNNABLE;
80002150:	00200793          	li	a5,2
80002154:	00f4a623          	sw	a5,12(s1)
}
80002158:	fc9ff06f          	j	80002120 <wakeup1+0x2c>

8000215c <procinit>:
{
8000215c:	fd010113          	addi	sp,sp,-48
80002160:	02112623          	sw	ra,44(sp)
80002164:	02812423          	sw	s0,40(sp)
80002168:	02912223          	sw	s1,36(sp)
8000216c:	03212023          	sw	s2,32(sp)
80002170:	01312e23          	sw	s3,28(sp)
80002174:	01412c23          	sw	s4,24(sp)
80002178:	01512a23          	sw	s5,20(sp)
8000217c:	01612823          	sw	s6,16(sp)
80002180:	01712623          	sw	s7,12(sp)
80002184:	01812423          	sw	s8,8(sp)
80002188:	01912223          	sw	s9,4(sp)
8000218c:	03010413          	addi	s0,sp,48
  initlock(&pid_lock, "nextpid");
80002190:	0000a597          	auipc	a1,0xa
80002194:	8ec58593          	addi	a1,a1,-1812 # 8000ba7c <userret+0x29dc>
80002198:	00013517          	auipc	a0,0x13
8000219c:	32050513          	addi	a0,a0,800 # 800154b8 <pid_lock>
800021a0:	fffff097          	auipc	ra,0xfffff
800021a4:	bc8080e7          	jalr	-1080(ra) # 80000d68 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
800021a8:	00013917          	auipc	s2,0x13
800021ac:	53c90913          	addi	s2,s2,1340 # 800156e4 <proc>
      initlock(&p->lock, "proc");
800021b0:	0000ac97          	auipc	s9,0xa
800021b4:	8d4c8c93          	addi	s9,s9,-1836 # 8000ba84 <userret+0x29e4>
      uint32 va = KSTACK((int) (p - proc));
800021b8:	00090c13          	mv	s8,s2
800021bc:	aaaab9b7          	lui	s3,0xaaaab
800021c0:	aab98993          	addi	s3,s3,-1365 # aaaaaaab <end+0x2aa84a97>
800021c4:	fffffbb7          	lui	s7,0xfffff
      kvmmap(va, (uint32)pa, PGSIZE, PTE_R | PTE_W);
800021c8:	00600b13          	li	s6,6
800021cc:	00001ab7          	lui	s5,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
800021d0:	00016a17          	auipc	s4,0x16
800021d4:	514a0a13          	addi	s4,s4,1300 # 800186e4 <tickslock>
      initlock(&p->lock, "proc");
800021d8:	000c8593          	mv	a1,s9
800021dc:	00090513          	mv	a0,s2
800021e0:	fffff097          	auipc	ra,0xfffff
800021e4:	b88080e7          	jalr	-1144(ra) # 80000d68 <initlock>
      char *pa = kalloc();
800021e8:	fffff097          	auipc	ra,0xfffff
800021ec:	af8080e7          	jalr	-1288(ra) # 80000ce0 <kalloc>
800021f0:	00050593          	mv	a1,a0
      if(pa == 0)
800021f4:	06050c63          	beqz	a0,8000226c <procinit+0x110>
      uint32 va = KSTACK((int) (p - proc));
800021f8:	418904b3          	sub	s1,s2,s8
800021fc:	4064d493          	srai	s1,s1,0x6
80002200:	033484b3          	mul	s1,s1,s3
80002204:	00148493          	addi	s1,s1,1
80002208:	00d49493          	slli	s1,s1,0xd
8000220c:	409b84b3          	sub	s1,s7,s1
      kvmmap(va, (uint32)pa, PGSIZE, PTE_R | PTE_W);
80002210:	000b0693          	mv	a3,s6
80002214:	000a8613          	mv	a2,s5
80002218:	00048513          	mv	a0,s1
8000221c:	fffff097          	auipc	ra,0xfffff
80002220:	4d4080e7          	jalr	1236(ra) # 800016f0 <kvmmap>
      p->kstack = va;
80002224:	02992223          	sw	s1,36(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
80002228:	0c090913          	addi	s2,s2,192
8000222c:	fb4916e3          	bne	s2,s4,800021d8 <procinit+0x7c>
  kvminithart();
80002230:	fffff097          	auipc	ra,0xfffff
80002234:	2a8080e7          	jalr	680(ra) # 800014d8 <kvminithart>
}
80002238:	02c12083          	lw	ra,44(sp)
8000223c:	02812403          	lw	s0,40(sp)
80002240:	02412483          	lw	s1,36(sp)
80002244:	02012903          	lw	s2,32(sp)
80002248:	01c12983          	lw	s3,28(sp)
8000224c:	01812a03          	lw	s4,24(sp)
80002250:	01412a83          	lw	s5,20(sp)
80002254:	01012b03          	lw	s6,16(sp)
80002258:	00c12b83          	lw	s7,12(sp)
8000225c:	00812c03          	lw	s8,8(sp)
80002260:	00412c83          	lw	s9,4(sp)
80002264:	03010113          	addi	sp,sp,48
80002268:	00008067          	ret
        panic("kalloc");
8000226c:	0000a517          	auipc	a0,0xa
80002270:	82050513          	addi	a0,a0,-2016 # 8000ba8c <userret+0x29ec>
80002274:	ffffe097          	auipc	ra,0xffffe
80002278:	48c080e7          	jalr	1164(ra) # 80000700 <panic>

8000227c <cpuid>:
{
8000227c:	ff010113          	addi	sp,sp,-16
80002280:	00112623          	sw	ra,12(sp)
80002284:	00812423          	sw	s0,8(sp)
80002288:	01010413          	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
8000228c:	00020513          	mv	a0,tp
}
80002290:	00c12083          	lw	ra,12(sp)
80002294:	00812403          	lw	s0,8(sp)
80002298:	01010113          	addi	sp,sp,16
8000229c:	00008067          	ret

800022a0 <mycpu>:
mycpu(void) {
800022a0:	ff010113          	addi	sp,sp,-16
800022a4:	00112623          	sw	ra,12(sp)
800022a8:	00812423          	sw	s0,8(sp)
800022ac:	01010413          	addi	s0,sp,16
800022b0:	00020713          	mv	a4,tp
  struct cpu *c = &cpus[id];
800022b4:	00471793          	slli	a5,a4,0x4
800022b8:	00e787b3          	add	a5,a5,a4
800022bc:	00279793          	slli	a5,a5,0x2
}
800022c0:	00013517          	auipc	a0,0x13
800022c4:	20450513          	addi	a0,a0,516 # 800154c4 <cpus>
800022c8:	00f50533          	add	a0,a0,a5
800022cc:	00c12083          	lw	ra,12(sp)
800022d0:	00812403          	lw	s0,8(sp)
800022d4:	01010113          	addi	sp,sp,16
800022d8:	00008067          	ret

800022dc <myproc>:
myproc(void) {
800022dc:	ff010113          	addi	sp,sp,-16
800022e0:	00112623          	sw	ra,12(sp)
800022e4:	00812423          	sw	s0,8(sp)
800022e8:	00912223          	sw	s1,4(sp)
800022ec:	01010413          	addi	s0,sp,16
  push_off();
800022f0:	fffff097          	auipc	ra,0xfffff
800022f4:	aa4080e7          	jalr	-1372(ra) # 80000d94 <push_off>
800022f8:	00020713          	mv	a4,tp
  struct proc *p = c->proc;
800022fc:	00471793          	slli	a5,a4,0x4
80002300:	00e787b3          	add	a5,a5,a4
80002304:	00279793          	slli	a5,a5,0x2
80002308:	00013717          	auipc	a4,0x13
8000230c:	1b070713          	addi	a4,a4,432 # 800154b8 <pid_lock>
80002310:	00f707b3          	add	a5,a4,a5
80002314:	00c7a483          	lw	s1,12(a5)
  pop_off();
80002318:	fffff097          	auipc	ra,0xfffff
8000231c:	af0080e7          	jalr	-1296(ra) # 80000e08 <pop_off>
}
80002320:	00048513          	mv	a0,s1
80002324:	00c12083          	lw	ra,12(sp)
80002328:	00812403          	lw	s0,8(sp)
8000232c:	00412483          	lw	s1,4(sp)
80002330:	01010113          	addi	sp,sp,16
80002334:	00008067          	ret

80002338 <forkret>:
{
80002338:	ff010113          	addi	sp,sp,-16
8000233c:	00112623          	sw	ra,12(sp)
80002340:	00812423          	sw	s0,8(sp)
80002344:	01010413          	addi	s0,sp,16
  release(&myproc()->lock);
80002348:	00000097          	auipc	ra,0x0
8000234c:	f94080e7          	jalr	-108(ra) # 800022dc <myproc>
80002350:	fffff097          	auipc	ra,0xfffff
80002354:	c18080e7          	jalr	-1000(ra) # 80000f68 <release>
  if (first) {
80002358:	0000a797          	auipc	a5,0xa
8000235c:	cdc7a783          	lw	a5,-804(a5) # 8000c034 <first.1>
80002360:	00079e63          	bnez	a5,8000237c <forkret+0x44>
  usertrapret();
80002364:	00001097          	auipc	ra,0x1
80002368:	ffc080e7          	jalr	-4(ra) # 80003360 <usertrapret>
}
8000236c:	00c12083          	lw	ra,12(sp)
80002370:	00812403          	lw	s0,8(sp)
80002374:	01010113          	addi	sp,sp,16
80002378:	00008067          	ret
    first = 0;
8000237c:	0000a797          	auipc	a5,0xa
80002380:	ca07ac23          	sw	zero,-840(a5) # 8000c034 <first.1>
    fsinit(ROOTDEV);
80002384:	00100513          	li	a0,1
80002388:	00002097          	auipc	ra,0x2
8000238c:	208080e7          	jalr	520(ra) # 80004590 <fsinit>
80002390:	fd5ff06f          	j	80002364 <forkret+0x2c>

80002394 <allocpid>:
allocpid() {
80002394:	ff010113          	addi	sp,sp,-16
80002398:	00112623          	sw	ra,12(sp)
8000239c:	00812423          	sw	s0,8(sp)
800023a0:	00912223          	sw	s1,4(sp)
800023a4:	01212023          	sw	s2,0(sp)
800023a8:	01010413          	addi	s0,sp,16
  acquire(&pid_lock);
800023ac:	00013917          	auipc	s2,0x13
800023b0:	10c90913          	addi	s2,s2,268 # 800154b8 <pid_lock>
800023b4:	00090513          	mv	a0,s2
800023b8:	fffff097          	auipc	ra,0xfffff
800023bc:	b3c080e7          	jalr	-1220(ra) # 80000ef4 <acquire>
  pid = nextpid;
800023c0:	0000a797          	auipc	a5,0xa
800023c4:	c7878793          	addi	a5,a5,-904 # 8000c038 <nextpid>
800023c8:	0007a483          	lw	s1,0(a5)
  nextpid = nextpid + 1;
800023cc:	00148713          	addi	a4,s1,1
800023d0:	00e7a023          	sw	a4,0(a5)
  release(&pid_lock);
800023d4:	00090513          	mv	a0,s2
800023d8:	fffff097          	auipc	ra,0xfffff
800023dc:	b90080e7          	jalr	-1136(ra) # 80000f68 <release>
}
800023e0:	00048513          	mv	a0,s1
800023e4:	00c12083          	lw	ra,12(sp)
800023e8:	00812403          	lw	s0,8(sp)
800023ec:	00412483          	lw	s1,4(sp)
800023f0:	00012903          	lw	s2,0(sp)
800023f4:	01010113          	addi	sp,sp,16
800023f8:	00008067          	ret

800023fc <proc_pagetable>:
{
800023fc:	ff010113          	addi	sp,sp,-16
80002400:	00112623          	sw	ra,12(sp)
80002404:	00812423          	sw	s0,8(sp)
80002408:	00912223          	sw	s1,4(sp)
8000240c:	01212023          	sw	s2,0(sp)
80002410:	01010413          	addi	s0,sp,16
80002414:	00050913          	mv	s2,a0
  pagetable = uvmcreate();
80002418:	fffff097          	auipc	ra,0xfffff
8000241c:	564080e7          	jalr	1380(ra) # 8000197c <uvmcreate>
80002420:	00050493          	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
80002424:	00a00713          	li	a4,10
80002428:	00007697          	auipc	a3,0x7
8000242c:	bd868693          	addi	a3,a3,-1064 # 80009000 <trampoline>
80002430:	00001637          	lui	a2,0x1
80002434:	fffff5b7          	lui	a1,0xfffff
80002438:	fffff097          	auipc	ra,0xfffff
8000243c:	1c8080e7          	jalr	456(ra) # 80001600 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
80002440:	00600713          	li	a4,6
80002444:	03092683          	lw	a3,48(s2)
80002448:	00001637          	lui	a2,0x1
8000244c:	ffffe5b7          	lui	a1,0xffffe
80002450:	00048513          	mv	a0,s1
80002454:	fffff097          	auipc	ra,0xfffff
80002458:	1ac080e7          	jalr	428(ra) # 80001600 <mappages>
}
8000245c:	00048513          	mv	a0,s1
80002460:	00c12083          	lw	ra,12(sp)
80002464:	00812403          	lw	s0,8(sp)
80002468:	00412483          	lw	s1,4(sp)
8000246c:	00012903          	lw	s2,0(sp)
80002470:	01010113          	addi	sp,sp,16
80002474:	00008067          	ret

80002478 <allocproc>:
{
80002478:	ff010113          	addi	sp,sp,-16
8000247c:	00112623          	sw	ra,12(sp)
80002480:	00812423          	sw	s0,8(sp)
80002484:	00912223          	sw	s1,4(sp)
80002488:	01212023          	sw	s2,0(sp)
8000248c:	01010413          	addi	s0,sp,16
  for(p = proc; p < &proc[NPROC]; p++) {
80002490:	00013497          	auipc	s1,0x13
80002494:	25448493          	addi	s1,s1,596 # 800156e4 <proc>
80002498:	00016917          	auipc	s2,0x16
8000249c:	24c90913          	addi	s2,s2,588 # 800186e4 <tickslock>
    acquire(&p->lock);
800024a0:	00048513          	mv	a0,s1
800024a4:	fffff097          	auipc	ra,0xfffff
800024a8:	a50080e7          	jalr	-1456(ra) # 80000ef4 <acquire>
    if(p->state == UNUSED) {
800024ac:	00c4a783          	lw	a5,12(s1)
800024b0:	02078063          	beqz	a5,800024d0 <allocproc+0x58>
      release(&p->lock);
800024b4:	00048513          	mv	a0,s1
800024b8:	fffff097          	auipc	ra,0xfffff
800024bc:	ab0080e7          	jalr	-1360(ra) # 80000f68 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
800024c0:	0c048493          	addi	s1,s1,192
800024c4:	fd249ee3          	bne	s1,s2,800024a0 <allocproc+0x28>
  return 0;
800024c8:	00000493          	li	s1,0
800024cc:	0640006f          	j	80002530 <allocproc+0xb8>
  p->pid = allocpid();
800024d0:	00000097          	auipc	ra,0x0
800024d4:	ec4080e7          	jalr	-316(ra) # 80002394 <allocpid>
800024d8:	02a4a023          	sw	a0,32(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
800024dc:	fffff097          	auipc	ra,0xfffff
800024e0:	804080e7          	jalr	-2044(ra) # 80000ce0 <kalloc>
800024e4:	00050913          	mv	s2,a0
800024e8:	02a4a823          	sw	a0,48(s1)
800024ec:	06050063          	beqz	a0,8000254c <allocproc+0xd4>
  p->pagetable = proc_pagetable(p);
800024f0:	00048513          	mv	a0,s1
800024f4:	00000097          	auipc	ra,0x0
800024f8:	f08080e7          	jalr	-248(ra) # 800023fc <proc_pagetable>
800024fc:	02a4a623          	sw	a0,44(s1)
  memset(&p->context, 0, sizeof p->context);
80002500:	03800613          	li	a2,56
80002504:	00000593          	li	a1,0
80002508:	03448513          	addi	a0,s1,52
8000250c:	fffff097          	auipc	ra,0xfffff
80002510:	abc080e7          	jalr	-1348(ra) # 80000fc8 <memset>
  p->context.ra = (uint32)forkret;
80002514:	00000797          	auipc	a5,0x0
80002518:	e2478793          	addi	a5,a5,-476 # 80002338 <forkret>
8000251c:	02f4aa23          	sw	a5,52(s1)
  p->context.sp = p->kstack + PGSIZE;
80002520:	0244a783          	lw	a5,36(s1)
80002524:	00001737          	lui	a4,0x1
80002528:	00e787b3          	add	a5,a5,a4
8000252c:	02f4ac23          	sw	a5,56(s1)
}
80002530:	00048513          	mv	a0,s1
80002534:	00c12083          	lw	ra,12(sp)
80002538:	00812403          	lw	s0,8(sp)
8000253c:	00412483          	lw	s1,4(sp)
80002540:	00012903          	lw	s2,0(sp)
80002544:	01010113          	addi	sp,sp,16
80002548:	00008067          	ret
    release(&p->lock);
8000254c:	00048513          	mv	a0,s1
80002550:	fffff097          	auipc	ra,0xfffff
80002554:	a18080e7          	jalr	-1512(ra) # 80000f68 <release>
    return 0;
80002558:	00090493          	mv	s1,s2
8000255c:	fd5ff06f          	j	80002530 <allocproc+0xb8>

80002560 <proc_freepagetable>:
{
80002560:	ff010113          	addi	sp,sp,-16
80002564:	00112623          	sw	ra,12(sp)
80002568:	00812423          	sw	s0,8(sp)
8000256c:	00912223          	sw	s1,4(sp)
80002570:	01212023          	sw	s2,0(sp)
80002574:	01010413          	addi	s0,sp,16
80002578:	00050493          	mv	s1,a0
8000257c:	00058913          	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
80002580:	00000693          	li	a3,0
80002584:	00001637          	lui	a2,0x1
80002588:	fffff5b7          	lui	a1,0xfffff
8000258c:	fffff097          	auipc	ra,0xfffff
80002590:	2d8080e7          	jalr	728(ra) # 80001864 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
80002594:	00000693          	li	a3,0
80002598:	00001637          	lui	a2,0x1
8000259c:	ffffe5b7          	lui	a1,0xffffe
800025a0:	00048513          	mv	a0,s1
800025a4:	fffff097          	auipc	ra,0xfffff
800025a8:	2c0080e7          	jalr	704(ra) # 80001864 <uvmunmap>
  if(sz > 0)
800025ac:	00091e63          	bnez	s2,800025c8 <proc_freepagetable+0x68>
}
800025b0:	00c12083          	lw	ra,12(sp)
800025b4:	00812403          	lw	s0,8(sp)
800025b8:	00412483          	lw	s1,4(sp)
800025bc:	00012903          	lw	s2,0(sp)
800025c0:	01010113          	addi	sp,sp,16
800025c4:	00008067          	ret
    uvmfree(pagetable, sz);
800025c8:	00090593          	mv	a1,s2
800025cc:	00048513          	mv	a0,s1
800025d0:	fffff097          	auipc	ra,0xfffff
800025d4:	670080e7          	jalr	1648(ra) # 80001c40 <uvmfree>
}
800025d8:	fd9ff06f          	j	800025b0 <proc_freepagetable+0x50>

800025dc <freeproc>:
{
800025dc:	ff010113          	addi	sp,sp,-16
800025e0:	00112623          	sw	ra,12(sp)
800025e4:	00812423          	sw	s0,8(sp)
800025e8:	00912223          	sw	s1,4(sp)
800025ec:	01010413          	addi	s0,sp,16
800025f0:	00050493          	mv	s1,a0
  if(p->tf)
800025f4:	03052503          	lw	a0,48(a0)
800025f8:	00050663          	beqz	a0,80002604 <freeproc+0x28>
    kfree((void*)p->tf);
800025fc:	ffffe097          	auipc	ra,0xffffe
80002600:	580080e7          	jalr	1408(ra) # 80000b7c <kfree>
  p->tf = 0;
80002604:	0204a823          	sw	zero,48(s1)
  if(p->pagetable)
80002608:	02c4a503          	lw	a0,44(s1)
8000260c:	00050863          	beqz	a0,8000261c <freeproc+0x40>
    proc_freepagetable(p->pagetable, p->sz);
80002610:	0284a583          	lw	a1,40(s1)
80002614:	00000097          	auipc	ra,0x0
80002618:	f4c080e7          	jalr	-180(ra) # 80002560 <proc_freepagetable>
  p->pagetable = 0;
8000261c:	0204a623          	sw	zero,44(s1)
  p->sz = 0;
80002620:	0204a423          	sw	zero,40(s1)
  p->pid = 0;
80002624:	0204a023          	sw	zero,32(s1)
  p->parent = 0;
80002628:	0004a823          	sw	zero,16(s1)
  p->name[0] = 0;
8000262c:	0a048823          	sb	zero,176(s1)
  p->chan = 0;
80002630:	0004aa23          	sw	zero,20(s1)
  p->killed = 0;
80002634:	0004ac23          	sw	zero,24(s1)
  p->xstate = 0;
80002638:	0004ae23          	sw	zero,28(s1)
  p->state = UNUSED;
8000263c:	0004a623          	sw	zero,12(s1)
}
80002640:	00c12083          	lw	ra,12(sp)
80002644:	00812403          	lw	s0,8(sp)
80002648:	00412483          	lw	s1,4(sp)
8000264c:	01010113          	addi	sp,sp,16
80002650:	00008067          	ret

80002654 <userinit>:
{
80002654:	ff010113          	addi	sp,sp,-16
80002658:	00112623          	sw	ra,12(sp)
8000265c:	00812423          	sw	s0,8(sp)
80002660:	00912223          	sw	s1,4(sp)
80002664:	01010413          	addi	s0,sp,16
  p = allocproc();
80002668:	00000097          	auipc	ra,0x0
8000266c:	e10080e7          	jalr	-496(ra) # 80002478 <allocproc>
80002670:	00050493          	mv	s1,a0
  initproc = p;
80002674:	00024797          	auipc	a5,0x24
80002678:	98a7ac23          	sw	a0,-1640(a5) # 8002600c <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
8000267c:	03300613          	li	a2,51
80002680:	0000a597          	auipc	a1,0xa
80002684:	98058593          	addi	a1,a1,-1664 # 8000c000 <initcode>
80002688:	02c52503          	lw	a0,44(a0)
8000268c:	fffff097          	auipc	ra,0xfffff
80002690:	34c080e7          	jalr	844(ra) # 800019d8 <uvminit>
  p->sz = PGSIZE;
80002694:	000017b7          	lui	a5,0x1
80002698:	02f4a423          	sw	a5,40(s1)
  p->tf->epc = 0;      // user program counter
8000269c:	0304a703          	lw	a4,48(s1)
800026a0:	00072623          	sw	zero,12(a4) # 100c <_entry-0x7fffeff4>
  p->tf->sp = PGSIZE;  // user stack pointer
800026a4:	0304a703          	lw	a4,48(s1)
800026a8:	00f72c23          	sw	a5,24(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
800026ac:	01000613          	li	a2,16
800026b0:	00009597          	auipc	a1,0x9
800026b4:	3e458593          	addi	a1,a1,996 # 8000ba94 <userret+0x29f4>
800026b8:	0b048513          	addi	a0,s1,176
800026bc:	fffff097          	auipc	ra,0xfffff
800026c0:	af0080e7          	jalr	-1296(ra) # 800011ac <safestrcpy>
  p->cwd = namei("/");
800026c4:	00009517          	auipc	a0,0x9
800026c8:	3dc50513          	addi	a0,a0,988 # 8000baa0 <userret+0x2a00>
800026cc:	00003097          	auipc	ra,0x3
800026d0:	d04080e7          	jalr	-764(ra) # 800053d0 <namei>
800026d4:	0aa4a623          	sw	a0,172(s1)
  p->state = RUNNABLE;
800026d8:	00200793          	li	a5,2
800026dc:	00f4a623          	sw	a5,12(s1)
  release(&p->lock);
800026e0:	00048513          	mv	a0,s1
800026e4:	fffff097          	auipc	ra,0xfffff
800026e8:	884080e7          	jalr	-1916(ra) # 80000f68 <release>
}
800026ec:	00c12083          	lw	ra,12(sp)
800026f0:	00812403          	lw	s0,8(sp)
800026f4:	00412483          	lw	s1,4(sp)
800026f8:	01010113          	addi	sp,sp,16
800026fc:	00008067          	ret

80002700 <growproc>:
{
80002700:	ff010113          	addi	sp,sp,-16
80002704:	00112623          	sw	ra,12(sp)
80002708:	00812423          	sw	s0,8(sp)
8000270c:	00912223          	sw	s1,4(sp)
80002710:	01212023          	sw	s2,0(sp)
80002714:	01010413          	addi	s0,sp,16
80002718:	00050913          	mv	s2,a0
  struct proc *p = myproc();
8000271c:	00000097          	auipc	ra,0x0
80002720:	bc0080e7          	jalr	-1088(ra) # 800022dc <myproc>
80002724:	00050493          	mv	s1,a0
  sz = p->sz;
80002728:	02852583          	lw	a1,40(a0)
  if(n > 0){
8000272c:	03204463          	bgtz	s2,80002754 <growproc+0x54>
  } else if(n < 0){
80002730:	04094263          	bltz	s2,80002774 <growproc+0x74>
  p->sz = sz;
80002734:	02b4a423          	sw	a1,40(s1)
  return 0;
80002738:	00000513          	li	a0,0
}
8000273c:	00c12083          	lw	ra,12(sp)
80002740:	00812403          	lw	s0,8(sp)
80002744:	00412483          	lw	s1,4(sp)
80002748:	00012903          	lw	s2,0(sp)
8000274c:	01010113          	addi	sp,sp,16
80002750:	00008067          	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
80002754:	00b90633          	add	a2,s2,a1
80002758:	02c52503          	lw	a0,44(a0)
8000275c:	fffff097          	auipc	ra,0xfffff
80002760:	39c080e7          	jalr	924(ra) # 80001af8 <uvmalloc>
80002764:	00050593          	mv	a1,a0
80002768:	fc0516e3          	bnez	a0,80002734 <growproc+0x34>
      return -1;
8000276c:	fff00513          	li	a0,-1
80002770:	fcdff06f          	j	8000273c <growproc+0x3c>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
80002774:	00b90633          	add	a2,s2,a1
80002778:	02c52503          	lw	a0,44(a0)
8000277c:	fffff097          	auipc	ra,0xfffff
80002780:	30c080e7          	jalr	780(ra) # 80001a88 <uvmdealloc>
80002784:	00050593          	mv	a1,a0
80002788:	fadff06f          	j	80002734 <growproc+0x34>

8000278c <fork>:
{
8000278c:	fe010113          	addi	sp,sp,-32
80002790:	00112e23          	sw	ra,28(sp)
80002794:	00812c23          	sw	s0,24(sp)
80002798:	00912a23          	sw	s1,20(sp)
8000279c:	01512223          	sw	s5,4(sp)
800027a0:	02010413          	addi	s0,sp,32
  struct proc *p = myproc();
800027a4:	00000097          	auipc	ra,0x0
800027a8:	b38080e7          	jalr	-1224(ra) # 800022dc <myproc>
800027ac:	00050a93          	mv	s5,a0
  if((np = allocproc()) == 0){
800027b0:	00000097          	auipc	ra,0x0
800027b4:	cc8080e7          	jalr	-824(ra) # 80002478 <allocproc>
800027b8:	12050c63          	beqz	a0,800028f0 <fork+0x164>
800027bc:	01412423          	sw	s4,8(sp)
800027c0:	00050a13          	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
800027c4:	028aa603          	lw	a2,40(s5) # 1028 <_entry-0x7fffefd8>
800027c8:	02c52583          	lw	a1,44(a0)
800027cc:	02caa503          	lw	a0,44(s5)
800027d0:	fffff097          	auipc	ra,0xfffff
800027d4:	4bc080e7          	jalr	1212(ra) # 80001c8c <uvmcopy>
800027d8:	06054663          	bltz	a0,80002844 <fork+0xb8>
800027dc:	01212823          	sw	s2,16(sp)
800027e0:	01312623          	sw	s3,12(sp)
  np->sz = p->sz;
800027e4:	028aa783          	lw	a5,40(s5)
800027e8:	02fa2423          	sw	a5,40(s4)
  np->parent = p;
800027ec:	015a2823          	sw	s5,16(s4)
  *(np->tf) = *(p->tf);
800027f0:	030aa683          	lw	a3,48(s5)
800027f4:	00068793          	mv	a5,a3
800027f8:	030a2703          	lw	a4,48(s4)
800027fc:	09068693          	addi	a3,a3,144
80002800:	0007a803          	lw	a6,0(a5) # 1000 <_entry-0x7ffff000>
80002804:	0047a503          	lw	a0,4(a5)
80002808:	0087a583          	lw	a1,8(a5)
8000280c:	00c7a603          	lw	a2,12(a5)
80002810:	01072023          	sw	a6,0(a4)
80002814:	00a72223          	sw	a0,4(a4)
80002818:	00b72423          	sw	a1,8(a4)
8000281c:	00c72623          	sw	a2,12(a4)
80002820:	01078793          	addi	a5,a5,16
80002824:	01070713          	addi	a4,a4,16
80002828:	fcd79ce3          	bne	a5,a3,80002800 <fork+0x74>
  np->tf->a0 = 0;
8000282c:	030a2783          	lw	a5,48(s4)
80002830:	0207ac23          	sw	zero,56(a5)
  for(i = 0; i < NOFILE; i++)
80002834:	06ca8493          	addi	s1,s5,108
80002838:	06ca0913          	addi	s2,s4,108
8000283c:	0aca8993          	addi	s3,s5,172
80002840:	0340006f          	j	80002874 <fork+0xe8>
    freeproc(np);
80002844:	000a0513          	mv	a0,s4
80002848:	00000097          	auipc	ra,0x0
8000284c:	d94080e7          	jalr	-620(ra) # 800025dc <freeproc>
    release(&np->lock);
80002850:	000a0513          	mv	a0,s4
80002854:	ffffe097          	auipc	ra,0xffffe
80002858:	714080e7          	jalr	1812(ra) # 80000f68 <release>
    return -1;
8000285c:	fff00493          	li	s1,-1
80002860:	00812a03          	lw	s4,8(sp)
80002864:	0700006f          	j	800028d4 <fork+0x148>
  for(i = 0; i < NOFILE; i++)
80002868:	00448493          	addi	s1,s1,4
8000286c:	00490913          	addi	s2,s2,4
80002870:	01348e63          	beq	s1,s3,8000288c <fork+0x100>
    if(p->ofile[i])
80002874:	0004a503          	lw	a0,0(s1)
80002878:	fe0508e3          	beqz	a0,80002868 <fork+0xdc>
      np->ofile[i] = filedup(p->ofile[i]);
8000287c:	00003097          	auipc	ra,0x3
80002880:	44c080e7          	jalr	1100(ra) # 80005cc8 <filedup>
80002884:	00a92023          	sw	a0,0(s2)
80002888:	fe1ff06f          	j	80002868 <fork+0xdc>
  np->cwd = idup(p->cwd);
8000288c:	0acaa503          	lw	a0,172(s5)
80002890:	00002097          	auipc	ra,0x2
80002894:	ff4080e7          	jalr	-12(ra) # 80004884 <idup>
80002898:	0aaa2623          	sw	a0,172(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
8000289c:	01000613          	li	a2,16
800028a0:	0b0a8593          	addi	a1,s5,176
800028a4:	0b0a0513          	addi	a0,s4,176
800028a8:	fffff097          	auipc	ra,0xfffff
800028ac:	904080e7          	jalr	-1788(ra) # 800011ac <safestrcpy>
  pid = np->pid;
800028b0:	020a2483          	lw	s1,32(s4)
  np->state = RUNNABLE;
800028b4:	00200793          	li	a5,2
800028b8:	00fa2623          	sw	a5,12(s4)
  release(&np->lock);
800028bc:	000a0513          	mv	a0,s4
800028c0:	ffffe097          	auipc	ra,0xffffe
800028c4:	6a8080e7          	jalr	1704(ra) # 80000f68 <release>
  return pid;
800028c8:	01012903          	lw	s2,16(sp)
800028cc:	00c12983          	lw	s3,12(sp)
800028d0:	00812a03          	lw	s4,8(sp)
}
800028d4:	00048513          	mv	a0,s1
800028d8:	01c12083          	lw	ra,28(sp)
800028dc:	01812403          	lw	s0,24(sp)
800028e0:	01412483          	lw	s1,20(sp)
800028e4:	00412a83          	lw	s5,4(sp)
800028e8:	02010113          	addi	sp,sp,32
800028ec:	00008067          	ret
    return -1;
800028f0:	fff00493          	li	s1,-1
800028f4:	fe1ff06f          	j	800028d4 <fork+0x148>

800028f8 <reparent>:
{
800028f8:	fe010113          	addi	sp,sp,-32
800028fc:	00112e23          	sw	ra,28(sp)
80002900:	00812c23          	sw	s0,24(sp)
80002904:	00912a23          	sw	s1,20(sp)
80002908:	01212823          	sw	s2,16(sp)
8000290c:	01312623          	sw	s3,12(sp)
80002910:	01412423          	sw	s4,8(sp)
80002914:	02010413          	addi	s0,sp,32
80002918:	00050913          	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
8000291c:	00013497          	auipc	s1,0x13
80002920:	dc848493          	addi	s1,s1,-568 # 800156e4 <proc>
      pp->parent = initproc;
80002924:	00023a17          	auipc	s4,0x23
80002928:	6e8a0a13          	addi	s4,s4,1768 # 8002600c <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
8000292c:	00016997          	auipc	s3,0x16
80002930:	db898993          	addi	s3,s3,-584 # 800186e4 <tickslock>
80002934:	00c0006f          	j	80002940 <reparent+0x48>
80002938:	0c048493          	addi	s1,s1,192
8000293c:	03348863          	beq	s1,s3,8000296c <reparent+0x74>
    if(pp->parent == p){
80002940:	0104a783          	lw	a5,16(s1)
80002944:	ff279ae3          	bne	a5,s2,80002938 <reparent+0x40>
      acquire(&pp->lock);
80002948:	00048513          	mv	a0,s1
8000294c:	ffffe097          	auipc	ra,0xffffe
80002950:	5a8080e7          	jalr	1448(ra) # 80000ef4 <acquire>
      pp->parent = initproc;
80002954:	000a2783          	lw	a5,0(s4)
80002958:	00f4a823          	sw	a5,16(s1)
      release(&pp->lock);
8000295c:	00048513          	mv	a0,s1
80002960:	ffffe097          	auipc	ra,0xffffe
80002964:	608080e7          	jalr	1544(ra) # 80000f68 <release>
80002968:	fd1ff06f          	j	80002938 <reparent+0x40>
}
8000296c:	01c12083          	lw	ra,28(sp)
80002970:	01812403          	lw	s0,24(sp)
80002974:	01412483          	lw	s1,20(sp)
80002978:	01012903          	lw	s2,16(sp)
8000297c:	00c12983          	lw	s3,12(sp)
80002980:	00812a03          	lw	s4,8(sp)
80002984:	02010113          	addi	sp,sp,32
80002988:	00008067          	ret

8000298c <scheduler>:
{
8000298c:	fe010113          	addi	sp,sp,-32
80002990:	00112e23          	sw	ra,28(sp)
80002994:	00812c23          	sw	s0,24(sp)
80002998:	00912a23          	sw	s1,20(sp)
8000299c:	01212823          	sw	s2,16(sp)
800029a0:	01312623          	sw	s3,12(sp)
800029a4:	01412423          	sw	s4,8(sp)
800029a8:	01512223          	sw	s5,4(sp)
800029ac:	02010413          	addi	s0,sp,32
800029b0:	00020713          	mv	a4,tp
  c->proc = 0;
800029b4:	00471793          	slli	a5,a4,0x4
800029b8:	00e78633          	add	a2,a5,a4
800029bc:	00261613          	slli	a2,a2,0x2
800029c0:	00013697          	auipc	a3,0x13
800029c4:	af868693          	addi	a3,a3,-1288 # 800154b8 <pid_lock>
800029c8:	00c686b3          	add	a3,a3,a2
800029cc:	0006a623          	sw	zero,12(a3)
        swtch(&c->scheduler, &p->context);
800029d0:	00013797          	auipc	a5,0x13
800029d4:	af878793          	addi	a5,a5,-1288 # 800154c8 <cpus+0x4>
800029d8:	00f60ab3          	add	s5,a2,a5
      if(p->state == RUNNABLE) {
800029dc:	00200913          	li	s2,2
        c->proc = p;
800029e0:	00068993          	mv	s3,a3
  asm volatile("csrr %0, sie" : "=r" (x) );
800029e4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
800029e8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
800029ec:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
800029f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
800029f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
800029f8:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
800029fc:	00013497          	auipc	s1,0x13
80002a00:	ce848493          	addi	s1,s1,-792 # 800156e4 <proc>
        p->state = RUNNING;
80002a04:	00300a13          	li	s4,3
80002a08:	0200006f          	j	80002a28 <scheduler+0x9c>
      release(&p->lock);
80002a0c:	00048513          	mv	a0,s1
80002a10:	ffffe097          	auipc	ra,0xffffe
80002a14:	558080e7          	jalr	1368(ra) # 80000f68 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
80002a18:	0c048493          	addi	s1,s1,192
80002a1c:	00016797          	auipc	a5,0x16
80002a20:	cc878793          	addi	a5,a5,-824 # 800186e4 <tickslock>
80002a24:	fcf480e3          	beq	s1,a5,800029e4 <scheduler+0x58>
      acquire(&p->lock);
80002a28:	00048513          	mv	a0,s1
80002a2c:	ffffe097          	auipc	ra,0xffffe
80002a30:	4c8080e7          	jalr	1224(ra) # 80000ef4 <acquire>
      if(p->state == RUNNABLE) {
80002a34:	00c4a783          	lw	a5,12(s1)
80002a38:	fd279ae3          	bne	a5,s2,80002a0c <scheduler+0x80>
        p->state = RUNNING;
80002a3c:	0144a623          	sw	s4,12(s1)
        c->proc = p;
80002a40:	0099a623          	sw	s1,12(s3)
        swtch(&c->scheduler, &p->context);
80002a44:	03448593          	addi	a1,s1,52
80002a48:	000a8513          	mv	a0,s5
80002a4c:	00001097          	auipc	ra,0x1
80002a50:	83c080e7          	jalr	-1988(ra) # 80003288 <swtch>
        c->proc = 0;
80002a54:	0009a623          	sw	zero,12(s3)
80002a58:	fb5ff06f          	j	80002a0c <scheduler+0x80>

80002a5c <sched>:
{
80002a5c:	fe010113          	addi	sp,sp,-32
80002a60:	00112e23          	sw	ra,28(sp)
80002a64:	00812c23          	sw	s0,24(sp)
80002a68:	00912a23          	sw	s1,20(sp)
80002a6c:	01212823          	sw	s2,16(sp)
80002a70:	01312623          	sw	s3,12(sp)
80002a74:	02010413          	addi	s0,sp,32
  struct proc *p = myproc();
80002a78:	00000097          	auipc	ra,0x0
80002a7c:	864080e7          	jalr	-1948(ra) # 800022dc <myproc>
80002a80:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
80002a84:	ffffe097          	auipc	ra,0xffffe
80002a88:	40c080e7          	jalr	1036(ra) # 80000e90 <holding>
80002a8c:	0c050063          	beqz	a0,80002b4c <sched+0xf0>
  asm volatile("mv %0, tp" : "=r" (x) );
80002a90:	00020713          	mv	a4,tp
  if(mycpu()->noff != 1)
80002a94:	00471793          	slli	a5,a4,0x4
80002a98:	00e787b3          	add	a5,a5,a4
80002a9c:	00279793          	slli	a5,a5,0x2
80002aa0:	00013717          	auipc	a4,0x13
80002aa4:	a1870713          	addi	a4,a4,-1512 # 800154b8 <pid_lock>
80002aa8:	00f707b3          	add	a5,a4,a5
80002aac:	0487a703          	lw	a4,72(a5)
80002ab0:	00100793          	li	a5,1
80002ab4:	0af71463          	bne	a4,a5,80002b5c <sched+0x100>
  if(p->state == RUNNING)
80002ab8:	00c4a703          	lw	a4,12(s1)
80002abc:	00300793          	li	a5,3
80002ac0:	0af70663          	beq	a4,a5,80002b6c <sched+0x110>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
80002ac4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
80002ac8:	0027f793          	andi	a5,a5,2
  if(intr_get())
80002acc:	0a079863          	bnez	a5,80002b7c <sched+0x120>
  asm volatile("mv %0, tp" : "=r" (x) );
80002ad0:	00020713          	mv	a4,tp
  intena = mycpu()->intena;
80002ad4:	00013917          	auipc	s2,0x13
80002ad8:	9e490913          	addi	s2,s2,-1564 # 800154b8 <pid_lock>
80002adc:	00471793          	slli	a5,a4,0x4
80002ae0:	00e787b3          	add	a5,a5,a4
80002ae4:	00279793          	slli	a5,a5,0x2
80002ae8:	00f907b3          	add	a5,s2,a5
80002aec:	04c7a983          	lw	s3,76(a5)
80002af0:	00020713          	mv	a4,tp
  swtch(&p->context, &mycpu()->scheduler);
80002af4:	00471793          	slli	a5,a4,0x4
80002af8:	00e787b3          	add	a5,a5,a4
80002afc:	00279793          	slli	a5,a5,0x2
80002b00:	00013597          	auipc	a1,0x13
80002b04:	9c858593          	addi	a1,a1,-1592 # 800154c8 <cpus+0x4>
80002b08:	00b785b3          	add	a1,a5,a1
80002b0c:	03448513          	addi	a0,s1,52
80002b10:	00000097          	auipc	ra,0x0
80002b14:	778080e7          	jalr	1912(ra) # 80003288 <swtch>
80002b18:	00020713          	mv	a4,tp
  mycpu()->intena = intena;
80002b1c:	00471793          	slli	a5,a4,0x4
80002b20:	00e787b3          	add	a5,a5,a4
80002b24:	00279793          	slli	a5,a5,0x2
80002b28:	00f90933          	add	s2,s2,a5
80002b2c:	05392623          	sw	s3,76(s2)
}
80002b30:	01c12083          	lw	ra,28(sp)
80002b34:	01812403          	lw	s0,24(sp)
80002b38:	01412483          	lw	s1,20(sp)
80002b3c:	01012903          	lw	s2,16(sp)
80002b40:	00c12983          	lw	s3,12(sp)
80002b44:	02010113          	addi	sp,sp,32
80002b48:	00008067          	ret
    panic("sched p->lock");
80002b4c:	00009517          	auipc	a0,0x9
80002b50:	f5850513          	addi	a0,a0,-168 # 8000baa4 <userret+0x2a04>
80002b54:	ffffe097          	auipc	ra,0xffffe
80002b58:	bac080e7          	jalr	-1108(ra) # 80000700 <panic>
    panic("sched locks");
80002b5c:	00009517          	auipc	a0,0x9
80002b60:	f5850513          	addi	a0,a0,-168 # 8000bab4 <userret+0x2a14>
80002b64:	ffffe097          	auipc	ra,0xffffe
80002b68:	b9c080e7          	jalr	-1124(ra) # 80000700 <panic>
    panic("sched running");
80002b6c:	00009517          	auipc	a0,0x9
80002b70:	f5450513          	addi	a0,a0,-172 # 8000bac0 <userret+0x2a20>
80002b74:	ffffe097          	auipc	ra,0xffffe
80002b78:	b8c080e7          	jalr	-1140(ra) # 80000700 <panic>
    panic("sched interruptible");
80002b7c:	00009517          	auipc	a0,0x9
80002b80:	f5450513          	addi	a0,a0,-172 # 8000bad0 <userret+0x2a30>
80002b84:	ffffe097          	auipc	ra,0xffffe
80002b88:	b7c080e7          	jalr	-1156(ra) # 80000700 <panic>

80002b8c <exit>:
{
80002b8c:	fe010113          	addi	sp,sp,-32
80002b90:	00112e23          	sw	ra,28(sp)
80002b94:	00812c23          	sw	s0,24(sp)
80002b98:	00912a23          	sw	s1,20(sp)
80002b9c:	01212823          	sw	s2,16(sp)
80002ba0:	01312623          	sw	s3,12(sp)
80002ba4:	01412423          	sw	s4,8(sp)
80002ba8:	02010413          	addi	s0,sp,32
80002bac:	00050a13          	mv	s4,a0
  struct proc *p = myproc();
80002bb0:	fffff097          	auipc	ra,0xfffff
80002bb4:	72c080e7          	jalr	1836(ra) # 800022dc <myproc>
80002bb8:	00050993          	mv	s3,a0
  if(p == initproc)
80002bbc:	00023797          	auipc	a5,0x23
80002bc0:	4507a783          	lw	a5,1104(a5) # 8002600c <initproc>
80002bc4:	06c50493          	addi	s1,a0,108
80002bc8:	0ac50913          	addi	s2,a0,172
80002bcc:	00a79e63          	bne	a5,a0,80002be8 <exit+0x5c>
    panic("init exiting");
80002bd0:	00009517          	auipc	a0,0x9
80002bd4:	f1450513          	addi	a0,a0,-236 # 8000bae4 <userret+0x2a44>
80002bd8:	ffffe097          	auipc	ra,0xffffe
80002bdc:	b28080e7          	jalr	-1240(ra) # 80000700 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
80002be0:	00448493          	addi	s1,s1,4
80002be4:	01248e63          	beq	s1,s2,80002c00 <exit+0x74>
    if(p->ofile[fd]){
80002be8:	0004a503          	lw	a0,0(s1)
80002bec:	fe050ae3          	beqz	a0,80002be0 <exit+0x54>
      fileclose(f);
80002bf0:	00003097          	auipc	ra,0x3
80002bf4:	148080e7          	jalr	328(ra) # 80005d38 <fileclose>
      p->ofile[fd] = 0;
80002bf8:	0004a023          	sw	zero,0(s1)
80002bfc:	fe5ff06f          	j	80002be0 <exit+0x54>
  begin_op();
80002c00:	00003097          	auipc	ra,0x3
80002c04:	a94080e7          	jalr	-1388(ra) # 80005694 <begin_op>
  iput(p->cwd);
80002c08:	0ac9a503          	lw	a0,172(s3)
80002c0c:	00002097          	auipc	ra,0x2
80002c10:	e50080e7          	jalr	-432(ra) # 80004a5c <iput>
  end_op();
80002c14:	00003097          	auipc	ra,0x3
80002c18:	b30080e7          	jalr	-1232(ra) # 80005744 <end_op>
  p->cwd = 0;
80002c1c:	0a09a623          	sw	zero,172(s3)
  acquire(&initproc->lock);
80002c20:	00023497          	auipc	s1,0x23
80002c24:	3ec48493          	addi	s1,s1,1004 # 8002600c <initproc>
80002c28:	0004a503          	lw	a0,0(s1)
80002c2c:	ffffe097          	auipc	ra,0xffffe
80002c30:	2c8080e7          	jalr	712(ra) # 80000ef4 <acquire>
  wakeup1(initproc);
80002c34:	0004a503          	lw	a0,0(s1)
80002c38:	fffff097          	auipc	ra,0xfffff
80002c3c:	4bc080e7          	jalr	1212(ra) # 800020f4 <wakeup1>
  release(&initproc->lock);
80002c40:	0004a503          	lw	a0,0(s1)
80002c44:	ffffe097          	auipc	ra,0xffffe
80002c48:	324080e7          	jalr	804(ra) # 80000f68 <release>
  acquire(&p->lock);
80002c4c:	00098513          	mv	a0,s3
80002c50:	ffffe097          	auipc	ra,0xffffe
80002c54:	2a4080e7          	jalr	676(ra) # 80000ef4 <acquire>
  struct proc *original_parent = p->parent;
80002c58:	0109a483          	lw	s1,16(s3)
  release(&p->lock);
80002c5c:	00098513          	mv	a0,s3
80002c60:	ffffe097          	auipc	ra,0xffffe
80002c64:	308080e7          	jalr	776(ra) # 80000f68 <release>
  acquire(&original_parent->lock);
80002c68:	00048513          	mv	a0,s1
80002c6c:	ffffe097          	auipc	ra,0xffffe
80002c70:	288080e7          	jalr	648(ra) # 80000ef4 <acquire>
  acquire(&p->lock);
80002c74:	00098513          	mv	a0,s3
80002c78:	ffffe097          	auipc	ra,0xffffe
80002c7c:	27c080e7          	jalr	636(ra) # 80000ef4 <acquire>
  reparent(p);
80002c80:	00098513          	mv	a0,s3
80002c84:	00000097          	auipc	ra,0x0
80002c88:	c74080e7          	jalr	-908(ra) # 800028f8 <reparent>
  wakeup1(original_parent);
80002c8c:	00048513          	mv	a0,s1
80002c90:	fffff097          	auipc	ra,0xfffff
80002c94:	464080e7          	jalr	1124(ra) # 800020f4 <wakeup1>
  p->xstate = status;
80002c98:	0149ae23          	sw	s4,28(s3)
  p->state = ZOMBIE;
80002c9c:	00400793          	li	a5,4
80002ca0:	00f9a623          	sw	a5,12(s3)
  release(&original_parent->lock);
80002ca4:	00048513          	mv	a0,s1
80002ca8:	ffffe097          	auipc	ra,0xffffe
80002cac:	2c0080e7          	jalr	704(ra) # 80000f68 <release>
  sched();
80002cb0:	00000097          	auipc	ra,0x0
80002cb4:	dac080e7          	jalr	-596(ra) # 80002a5c <sched>
  panic("zombie exit");
80002cb8:	00009517          	auipc	a0,0x9
80002cbc:	e3c50513          	addi	a0,a0,-452 # 8000baf4 <userret+0x2a54>
80002cc0:	ffffe097          	auipc	ra,0xffffe
80002cc4:	a40080e7          	jalr	-1472(ra) # 80000700 <panic>

80002cc8 <yield>:
{
80002cc8:	ff010113          	addi	sp,sp,-16
80002ccc:	00112623          	sw	ra,12(sp)
80002cd0:	00812423          	sw	s0,8(sp)
80002cd4:	00912223          	sw	s1,4(sp)
80002cd8:	01010413          	addi	s0,sp,16
  struct proc *p = myproc();
80002cdc:	fffff097          	auipc	ra,0xfffff
80002ce0:	600080e7          	jalr	1536(ra) # 800022dc <myproc>
80002ce4:	00050493          	mv	s1,a0
  acquire(&p->lock);
80002ce8:	ffffe097          	auipc	ra,0xffffe
80002cec:	20c080e7          	jalr	524(ra) # 80000ef4 <acquire>
  p->state = RUNNABLE;
80002cf0:	00200793          	li	a5,2
80002cf4:	00f4a623          	sw	a5,12(s1)
  sched();
80002cf8:	00000097          	auipc	ra,0x0
80002cfc:	d64080e7          	jalr	-668(ra) # 80002a5c <sched>
  release(&p->lock);
80002d00:	00048513          	mv	a0,s1
80002d04:	ffffe097          	auipc	ra,0xffffe
80002d08:	264080e7          	jalr	612(ra) # 80000f68 <release>
}
80002d0c:	00c12083          	lw	ra,12(sp)
80002d10:	00812403          	lw	s0,8(sp)
80002d14:	00412483          	lw	s1,4(sp)
80002d18:	01010113          	addi	sp,sp,16
80002d1c:	00008067          	ret

80002d20 <sleep>:
{
80002d20:	fe010113          	addi	sp,sp,-32
80002d24:	00112e23          	sw	ra,28(sp)
80002d28:	00812c23          	sw	s0,24(sp)
80002d2c:	00912a23          	sw	s1,20(sp)
80002d30:	01212823          	sw	s2,16(sp)
80002d34:	01312623          	sw	s3,12(sp)
80002d38:	02010413          	addi	s0,sp,32
80002d3c:	00050993          	mv	s3,a0
80002d40:	00058913          	mv	s2,a1
  struct proc *p = myproc();
80002d44:	fffff097          	auipc	ra,0xfffff
80002d48:	598080e7          	jalr	1432(ra) # 800022dc <myproc>
80002d4c:	00050493          	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
80002d50:	07250263          	beq	a0,s2,80002db4 <sleep+0x94>
    acquire(&p->lock);  //DOC: sleeplock1
80002d54:	ffffe097          	auipc	ra,0xffffe
80002d58:	1a0080e7          	jalr	416(ra) # 80000ef4 <acquire>
    release(lk);
80002d5c:	00090513          	mv	a0,s2
80002d60:	ffffe097          	auipc	ra,0xffffe
80002d64:	208080e7          	jalr	520(ra) # 80000f68 <release>
  p->chan = chan;
80002d68:	0134aa23          	sw	s3,20(s1)
  p->state = SLEEPING;
80002d6c:	00100793          	li	a5,1
80002d70:	00f4a623          	sw	a5,12(s1)
  sched();
80002d74:	00000097          	auipc	ra,0x0
80002d78:	ce8080e7          	jalr	-792(ra) # 80002a5c <sched>
  p->chan = 0;
80002d7c:	0004aa23          	sw	zero,20(s1)
    release(&p->lock);
80002d80:	00048513          	mv	a0,s1
80002d84:	ffffe097          	auipc	ra,0xffffe
80002d88:	1e4080e7          	jalr	484(ra) # 80000f68 <release>
    acquire(lk);
80002d8c:	00090513          	mv	a0,s2
80002d90:	ffffe097          	auipc	ra,0xffffe
80002d94:	164080e7          	jalr	356(ra) # 80000ef4 <acquire>
}
80002d98:	01c12083          	lw	ra,28(sp)
80002d9c:	01812403          	lw	s0,24(sp)
80002da0:	01412483          	lw	s1,20(sp)
80002da4:	01012903          	lw	s2,16(sp)
80002da8:	00c12983          	lw	s3,12(sp)
80002dac:	02010113          	addi	sp,sp,32
80002db0:	00008067          	ret
  p->chan = chan;
80002db4:	01352a23          	sw	s3,20(a0)
  p->state = SLEEPING;
80002db8:	00100793          	li	a5,1
80002dbc:	00f52623          	sw	a5,12(a0)
  sched();
80002dc0:	00000097          	auipc	ra,0x0
80002dc4:	c9c080e7          	jalr	-868(ra) # 80002a5c <sched>
  p->chan = 0;
80002dc8:	0004aa23          	sw	zero,20(s1)
  if(lk != &p->lock){
80002dcc:	fcdff06f          	j	80002d98 <sleep+0x78>

80002dd0 <wait>:
{
80002dd0:	fe010113          	addi	sp,sp,-32
80002dd4:	00112e23          	sw	ra,28(sp)
80002dd8:	00812c23          	sw	s0,24(sp)
80002ddc:	00912a23          	sw	s1,20(sp)
80002de0:	01212823          	sw	s2,16(sp)
80002de4:	01312623          	sw	s3,12(sp)
80002de8:	01412423          	sw	s4,8(sp)
80002dec:	01512223          	sw	s5,4(sp)
80002df0:	01612023          	sw	s6,0(sp)
80002df4:	02010413          	addi	s0,sp,32
80002df8:	00050b13          	mv	s6,a0
  struct proc *p = myproc();
80002dfc:	fffff097          	auipc	ra,0xfffff
80002e00:	4e0080e7          	jalr	1248(ra) # 800022dc <myproc>
80002e04:	00050913          	mv	s2,a0
  acquire(&p->lock);
80002e08:	ffffe097          	auipc	ra,0xffffe
80002e0c:	0ec080e7          	jalr	236(ra) # 80000ef4 <acquire>
        if(np->state == ZOMBIE){
80002e10:	00400a13          	li	s4,4
        havekids = 1;
80002e14:	00100a93          	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
80002e18:	00016997          	auipc	s3,0x16
80002e1c:	8cc98993          	addi	s3,s3,-1844 # 800186e4 <tickslock>
80002e20:	0ec0006f          	j	80002f0c <wait+0x13c>
          pid = np->pid;
80002e24:	0204a983          	lw	s3,32(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
80002e28:	020b0063          	beqz	s6,80002e48 <wait+0x78>
80002e2c:	00400693          	li	a3,4
80002e30:	01c48613          	addi	a2,s1,28
80002e34:	000b0593          	mv	a1,s6
80002e38:	02c92503          	lw	a0,44(s2)
80002e3c:	fffff097          	auipc	ra,0xfffff
80002e40:	fe0080e7          	jalr	-32(ra) # 80001e1c <copyout>
80002e44:	04054a63          	bltz	a0,80002e98 <wait+0xc8>
          freeproc(np);
80002e48:	00048513          	mv	a0,s1
80002e4c:	fffff097          	auipc	ra,0xfffff
80002e50:	790080e7          	jalr	1936(ra) # 800025dc <freeproc>
          release(&np->lock);
80002e54:	00048513          	mv	a0,s1
80002e58:	ffffe097          	auipc	ra,0xffffe
80002e5c:	110080e7          	jalr	272(ra) # 80000f68 <release>
          release(&p->lock);
80002e60:	00090513          	mv	a0,s2
80002e64:	ffffe097          	auipc	ra,0xffffe
80002e68:	104080e7          	jalr	260(ra) # 80000f68 <release>
}
80002e6c:	00098513          	mv	a0,s3
80002e70:	01c12083          	lw	ra,28(sp)
80002e74:	01812403          	lw	s0,24(sp)
80002e78:	01412483          	lw	s1,20(sp)
80002e7c:	01012903          	lw	s2,16(sp)
80002e80:	00c12983          	lw	s3,12(sp)
80002e84:	00812a03          	lw	s4,8(sp)
80002e88:	00412a83          	lw	s5,4(sp)
80002e8c:	00012b03          	lw	s6,0(sp)
80002e90:	02010113          	addi	sp,sp,32
80002e94:	00008067          	ret
            release(&np->lock);
80002e98:	00048513          	mv	a0,s1
80002e9c:	ffffe097          	auipc	ra,0xffffe
80002ea0:	0cc080e7          	jalr	204(ra) # 80000f68 <release>
            release(&p->lock);
80002ea4:	00090513          	mv	a0,s2
80002ea8:	ffffe097          	auipc	ra,0xffffe
80002eac:	0c0080e7          	jalr	192(ra) # 80000f68 <release>
            return -1;
80002eb0:	fff00993          	li	s3,-1
80002eb4:	fb9ff06f          	j	80002e6c <wait+0x9c>
    for(np = proc; np < &proc[NPROC]; np++){
80002eb8:	0c048493          	addi	s1,s1,192
80002ebc:	03348a63          	beq	s1,s3,80002ef0 <wait+0x120>
      if(np->parent == p){
80002ec0:	0104a783          	lw	a5,16(s1)
80002ec4:	ff279ae3          	bne	a5,s2,80002eb8 <wait+0xe8>
        acquire(&np->lock);
80002ec8:	00048513          	mv	a0,s1
80002ecc:	ffffe097          	auipc	ra,0xffffe
80002ed0:	028080e7          	jalr	40(ra) # 80000ef4 <acquire>
        if(np->state == ZOMBIE){
80002ed4:	00c4a783          	lw	a5,12(s1)
80002ed8:	f54786e3          	beq	a5,s4,80002e24 <wait+0x54>
        release(&np->lock);
80002edc:	00048513          	mv	a0,s1
80002ee0:	ffffe097          	auipc	ra,0xffffe
80002ee4:	088080e7          	jalr	136(ra) # 80000f68 <release>
        havekids = 1;
80002ee8:	000a8713          	mv	a4,s5
80002eec:	fcdff06f          	j	80002eb8 <wait+0xe8>
    if(!havekids || p->killed){
80002ef0:	02070663          	beqz	a4,80002f1c <wait+0x14c>
80002ef4:	01892783          	lw	a5,24(s2)
80002ef8:	02079263          	bnez	a5,80002f1c <wait+0x14c>
    sleep(p, &p->lock);  //DOC: wait-sleep
80002efc:	00090593          	mv	a1,s2
80002f00:	00090513          	mv	a0,s2
80002f04:	00000097          	auipc	ra,0x0
80002f08:	e1c080e7          	jalr	-484(ra) # 80002d20 <sleep>
    havekids = 0;
80002f0c:	00000713          	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
80002f10:	00012497          	auipc	s1,0x12
80002f14:	7d448493          	addi	s1,s1,2004 # 800156e4 <proc>
80002f18:	fa9ff06f          	j	80002ec0 <wait+0xf0>
      release(&p->lock);
80002f1c:	00090513          	mv	a0,s2
80002f20:	ffffe097          	auipc	ra,0xffffe
80002f24:	048080e7          	jalr	72(ra) # 80000f68 <release>
      return -1;
80002f28:	fff00993          	li	s3,-1
80002f2c:	f41ff06f          	j	80002e6c <wait+0x9c>

80002f30 <wakeup>:
{
80002f30:	fe010113          	addi	sp,sp,-32
80002f34:	00112e23          	sw	ra,28(sp)
80002f38:	00812c23          	sw	s0,24(sp)
80002f3c:	00912a23          	sw	s1,20(sp)
80002f40:	01212823          	sw	s2,16(sp)
80002f44:	01312623          	sw	s3,12(sp)
80002f48:	01412423          	sw	s4,8(sp)
80002f4c:	01512223          	sw	s5,4(sp)
80002f50:	02010413          	addi	s0,sp,32
80002f54:	00050a13          	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
80002f58:	00012497          	auipc	s1,0x12
80002f5c:	78c48493          	addi	s1,s1,1932 # 800156e4 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
80002f60:	00100993          	li	s3,1
      p->state = RUNNABLE;
80002f64:	00200a93          	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
80002f68:	00015917          	auipc	s2,0x15
80002f6c:	77c90913          	addi	s2,s2,1916 # 800186e4 <tickslock>
80002f70:	0180006f          	j	80002f88 <wakeup+0x58>
    release(&p->lock);
80002f74:	00048513          	mv	a0,s1
80002f78:	ffffe097          	auipc	ra,0xffffe
80002f7c:	ff0080e7          	jalr	-16(ra) # 80000f68 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
80002f80:	0c048493          	addi	s1,s1,192
80002f84:	03248463          	beq	s1,s2,80002fac <wakeup+0x7c>
    acquire(&p->lock);
80002f88:	00048513          	mv	a0,s1
80002f8c:	ffffe097          	auipc	ra,0xffffe
80002f90:	f68080e7          	jalr	-152(ra) # 80000ef4 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
80002f94:	00c4a783          	lw	a5,12(s1)
80002f98:	fd379ee3          	bne	a5,s3,80002f74 <wakeup+0x44>
80002f9c:	0144a783          	lw	a5,20(s1)
80002fa0:	fd479ae3          	bne	a5,s4,80002f74 <wakeup+0x44>
      p->state = RUNNABLE;
80002fa4:	0154a623          	sw	s5,12(s1)
80002fa8:	fcdff06f          	j	80002f74 <wakeup+0x44>
}
80002fac:	01c12083          	lw	ra,28(sp)
80002fb0:	01812403          	lw	s0,24(sp)
80002fb4:	01412483          	lw	s1,20(sp)
80002fb8:	01012903          	lw	s2,16(sp)
80002fbc:	00c12983          	lw	s3,12(sp)
80002fc0:	00812a03          	lw	s4,8(sp)
80002fc4:	00412a83          	lw	s5,4(sp)
80002fc8:	02010113          	addi	sp,sp,32
80002fcc:	00008067          	ret

80002fd0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
80002fd0:	fe010113          	addi	sp,sp,-32
80002fd4:	00112e23          	sw	ra,28(sp)
80002fd8:	00812c23          	sw	s0,24(sp)
80002fdc:	00912a23          	sw	s1,20(sp)
80002fe0:	01212823          	sw	s2,16(sp)
80002fe4:	01312623          	sw	s3,12(sp)
80002fe8:	02010413          	addi	s0,sp,32
80002fec:	00050913          	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
80002ff0:	00012497          	auipc	s1,0x12
80002ff4:	6f448493          	addi	s1,s1,1780 # 800156e4 <proc>
80002ff8:	00015997          	auipc	s3,0x15
80002ffc:	6ec98993          	addi	s3,s3,1772 # 800186e4 <tickslock>
    acquire(&p->lock);
80003000:	00048513          	mv	a0,s1
80003004:	ffffe097          	auipc	ra,0xffffe
80003008:	ef0080e7          	jalr	-272(ra) # 80000ef4 <acquire>
    if(p->pid == pid){
8000300c:	0204a783          	lw	a5,32(s1)
80003010:	03278063          	beq	a5,s2,80003030 <kill+0x60>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
80003014:	00048513          	mv	a0,s1
80003018:	ffffe097          	auipc	ra,0xffffe
8000301c:	f50080e7          	jalr	-176(ra) # 80000f68 <release>
  for(p = proc; p < &proc[NPROC]; p++){
80003020:	0c048493          	addi	s1,s1,192
80003024:	fd349ee3          	bne	s1,s3,80003000 <kill+0x30>
  }
  return -1;
80003028:	fff00513          	li	a0,-1
8000302c:	0240006f          	j	80003050 <kill+0x80>
      p->killed = 1;
80003030:	00100793          	li	a5,1
80003034:	00f4ac23          	sw	a5,24(s1)
      if(p->state == SLEEPING){
80003038:	00c4a703          	lw	a4,12(s1)
8000303c:	02f70863          	beq	a4,a5,8000306c <kill+0x9c>
      release(&p->lock);
80003040:	00048513          	mv	a0,s1
80003044:	ffffe097          	auipc	ra,0xffffe
80003048:	f24080e7          	jalr	-220(ra) # 80000f68 <release>
      return 0;
8000304c:	00000513          	li	a0,0
}
80003050:	01c12083          	lw	ra,28(sp)
80003054:	01812403          	lw	s0,24(sp)
80003058:	01412483          	lw	s1,20(sp)
8000305c:	01012903          	lw	s2,16(sp)
80003060:	00c12983          	lw	s3,12(sp)
80003064:	02010113          	addi	sp,sp,32
80003068:	00008067          	ret
        p->state = RUNNABLE;
8000306c:	00200793          	li	a5,2
80003070:	00f4a623          	sw	a5,12(s1)
80003074:	fcdff06f          	j	80003040 <kill+0x70>

80003078 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint32 dst, void *src, uint32 len)
{
80003078:	fe010113          	addi	sp,sp,-32
8000307c:	00112e23          	sw	ra,28(sp)
80003080:	00812c23          	sw	s0,24(sp)
80003084:	00912a23          	sw	s1,20(sp)
80003088:	01212823          	sw	s2,16(sp)
8000308c:	01312623          	sw	s3,12(sp)
80003090:	01412423          	sw	s4,8(sp)
80003094:	02010413          	addi	s0,sp,32
80003098:	00050493          	mv	s1,a0
8000309c:	00058913          	mv	s2,a1
800030a0:	00060993          	mv	s3,a2
800030a4:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
800030a8:	fffff097          	auipc	ra,0xfffff
800030ac:	234080e7          	jalr	564(ra) # 800022dc <myproc>
  if(user_dst){
800030b0:	02048e63          	beqz	s1,800030ec <either_copyout+0x74>
    return copyout(p->pagetable, dst, src, len);
800030b4:	000a0693          	mv	a3,s4
800030b8:	00098613          	mv	a2,s3
800030bc:	00090593          	mv	a1,s2
800030c0:	02c52503          	lw	a0,44(a0)
800030c4:	fffff097          	auipc	ra,0xfffff
800030c8:	d58080e7          	jalr	-680(ra) # 80001e1c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
800030cc:	01c12083          	lw	ra,28(sp)
800030d0:	01812403          	lw	s0,24(sp)
800030d4:	01412483          	lw	s1,20(sp)
800030d8:	01012903          	lw	s2,16(sp)
800030dc:	00c12983          	lw	s3,12(sp)
800030e0:	00812a03          	lw	s4,8(sp)
800030e4:	02010113          	addi	sp,sp,32
800030e8:	00008067          	ret
    memmove((char *)dst, src, len);
800030ec:	000a0613          	mv	a2,s4
800030f0:	00098593          	mv	a1,s3
800030f4:	00090513          	mv	a0,s2
800030f8:	ffffe097          	auipc	ra,0xffffe
800030fc:	f5c080e7          	jalr	-164(ra) # 80001054 <memmove>
    return 0;
80003100:	00048513          	mv	a0,s1
80003104:	fc9ff06f          	j	800030cc <either_copyout+0x54>

80003108 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint32 src, uint32 len)
{
80003108:	fe010113          	addi	sp,sp,-32
8000310c:	00112e23          	sw	ra,28(sp)
80003110:	00812c23          	sw	s0,24(sp)
80003114:	00912a23          	sw	s1,20(sp)
80003118:	01212823          	sw	s2,16(sp)
8000311c:	01312623          	sw	s3,12(sp)
80003120:	01412423          	sw	s4,8(sp)
80003124:	02010413          	addi	s0,sp,32
80003128:	00050913          	mv	s2,a0
8000312c:	00058493          	mv	s1,a1
80003130:	00060993          	mv	s3,a2
80003134:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
80003138:	fffff097          	auipc	ra,0xfffff
8000313c:	1a4080e7          	jalr	420(ra) # 800022dc <myproc>
  if(user_src){
80003140:	02048e63          	beqz	s1,8000317c <either_copyin+0x74>
    return copyin(p->pagetable, dst, src, len);
80003144:	000a0693          	mv	a3,s4
80003148:	00098613          	mv	a2,s3
8000314c:	00090593          	mv	a1,s2
80003150:	02c52503          	lw	a0,44(a0)
80003154:	fffff097          	auipc	ra,0xfffff
80003158:	db0080e7          	jalr	-592(ra) # 80001f04 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
8000315c:	01c12083          	lw	ra,28(sp)
80003160:	01812403          	lw	s0,24(sp)
80003164:	01412483          	lw	s1,20(sp)
80003168:	01012903          	lw	s2,16(sp)
8000316c:	00c12983          	lw	s3,12(sp)
80003170:	00812a03          	lw	s4,8(sp)
80003174:	02010113          	addi	sp,sp,32
80003178:	00008067          	ret
    memmove(dst, (char*)src, len);
8000317c:	000a0613          	mv	a2,s4
80003180:	00098593          	mv	a1,s3
80003184:	00090513          	mv	a0,s2
80003188:	ffffe097          	auipc	ra,0xffffe
8000318c:	ecc080e7          	jalr	-308(ra) # 80001054 <memmove>
    return 0;
80003190:	00048513          	mv	a0,s1
80003194:	fc9ff06f          	j	8000315c <either_copyin+0x54>

80003198 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80003198:	fd010113          	addi	sp,sp,-48
8000319c:	02112623          	sw	ra,44(sp)
800031a0:	02812423          	sw	s0,40(sp)
800031a4:	02912223          	sw	s1,36(sp)
800031a8:	03212023          	sw	s2,32(sp)
800031ac:	01312e23          	sw	s3,28(sp)
800031b0:	01412c23          	sw	s4,24(sp)
800031b4:	01512a23          	sw	s5,20(sp)
800031b8:	01612823          	sw	s6,16(sp)
800031bc:	01712623          	sw	s7,12(sp)
800031c0:	03010413          	addi	s0,sp,48
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
800031c4:	00008517          	auipc	a0,0x8
800031c8:	71c50513          	addi	a0,a0,1820 # 8000b8e0 <userret+0x2840>
800031cc:	ffffd097          	auipc	ra,0xffffd
800031d0:	590080e7          	jalr	1424(ra) # 8000075c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
800031d4:	00012497          	auipc	s1,0x12
800031d8:	5c048493          	addi	s1,s1,1472 # 80015794 <proc+0xb0>
800031dc:	00015917          	auipc	s2,0x15
800031e0:	5b890913          	addi	s2,s2,1464 # 80018794 <bcache+0xa4>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
800031e4:	00400b13          	li	s6,4
      state = states[p->state];
    else
      state = "???";
800031e8:	00009997          	auipc	s3,0x9
800031ec:	91898993          	addi	s3,s3,-1768 # 8000bb00 <userret+0x2a60>
    printf("%d %s %s", p->pid, state, p->name);
800031f0:	00009a97          	auipc	s5,0x9
800031f4:	914a8a93          	addi	s5,s5,-1772 # 8000bb04 <userret+0x2a64>
    printf("\n");
800031f8:	00008a17          	auipc	s4,0x8
800031fc:	6e8a0a13          	addi	s4,s4,1768 # 8000b8e0 <userret+0x2840>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80003200:	00009b97          	auipc	s7,0x9
80003204:	d34b8b93          	addi	s7,s7,-716 # 8000bf34 <states.0>
80003208:	0280006f          	j	80003230 <procdump+0x98>
    printf("%d %s %s", p->pid, state, p->name);
8000320c:	f706a583          	lw	a1,-144(a3)
80003210:	000a8513          	mv	a0,s5
80003214:	ffffd097          	auipc	ra,0xffffd
80003218:	548080e7          	jalr	1352(ra) # 8000075c <printf>
    printf("\n");
8000321c:	000a0513          	mv	a0,s4
80003220:	ffffd097          	auipc	ra,0xffffd
80003224:	53c080e7          	jalr	1340(ra) # 8000075c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
80003228:	0c048493          	addi	s1,s1,192
8000322c:	03248863          	beq	s1,s2,8000325c <procdump+0xc4>
    if(p->state == UNUSED)
80003230:	00048693          	mv	a3,s1
80003234:	f5c4a783          	lw	a5,-164(s1)
80003238:	fe0788e3          	beqz	a5,80003228 <procdump+0x90>
      state = "???";
8000323c:	00098613          	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80003240:	fcfb66e3          	bltu	s6,a5,8000320c <procdump+0x74>
80003244:	00279793          	slli	a5,a5,0x2
80003248:	00fb87b3          	add	a5,s7,a5
8000324c:	0007a603          	lw	a2,0(a5)
80003250:	fa061ee3          	bnez	a2,8000320c <procdump+0x74>
      state = "???";
80003254:	00098613          	mv	a2,s3
80003258:	fb5ff06f          	j	8000320c <procdump+0x74>
  }
}
8000325c:	02c12083          	lw	ra,44(sp)
80003260:	02812403          	lw	s0,40(sp)
80003264:	02412483          	lw	s1,36(sp)
80003268:	02012903          	lw	s2,32(sp)
8000326c:	01c12983          	lw	s3,28(sp)
80003270:	01812a03          	lw	s4,24(sp)
80003274:	01412a83          	lw	s5,20(sp)
80003278:	01012b03          	lw	s6,16(sp)
8000327c:	00c12b83          	lw	s7,12(sp)
80003280:	03010113          	addi	sp,sp,48
80003284:	00008067          	ret

80003288 <swtch>:
80003288:	00152023          	sw	ra,0(a0)
8000328c:	00252223          	sw	sp,4(a0)
80003290:	00852423          	sw	s0,8(a0)
80003294:	00952623          	sw	s1,12(a0)
80003298:	01252823          	sw	s2,16(a0)
8000329c:	01352a23          	sw	s3,20(a0)
800032a0:	01452c23          	sw	s4,24(a0)
800032a4:	01552e23          	sw	s5,28(a0)
800032a8:	03652023          	sw	s6,32(a0)
800032ac:	03752223          	sw	s7,36(a0)
800032b0:	03852423          	sw	s8,40(a0)
800032b4:	03952623          	sw	s9,44(a0)
800032b8:	03a52823          	sw	s10,48(a0)
800032bc:	03b52a23          	sw	s11,52(a0)
800032c0:	0005a083          	lw	ra,0(a1)
800032c4:	0045a103          	lw	sp,4(a1)
800032c8:	0085a403          	lw	s0,8(a1)
800032cc:	00c5a483          	lw	s1,12(a1)
800032d0:	0105a903          	lw	s2,16(a1)
800032d4:	0145a983          	lw	s3,20(a1)
800032d8:	0185aa03          	lw	s4,24(a1)
800032dc:	01c5aa83          	lw	s5,28(a1)
800032e0:	0205ab03          	lw	s6,32(a1)
800032e4:	0245ab83          	lw	s7,36(a1)
800032e8:	0285ac03          	lw	s8,40(a1)
800032ec:	02c5ac83          	lw	s9,44(a1)
800032f0:	0305ad03          	lw	s10,48(a1)
800032f4:	0345ad83          	lw	s11,52(a1)
800032f8:	00008067          	ret

800032fc <trapinit>:

extern int devintr();

void
trapinit(void)
{
800032fc:	ff010113          	addi	sp,sp,-16
80003300:	00112623          	sw	ra,12(sp)
80003304:	00812423          	sw	s0,8(sp)
80003308:	01010413          	addi	s0,sp,16
  initlock(&tickslock, "time");
8000330c:	00009597          	auipc	a1,0x9
80003310:	82c58593          	addi	a1,a1,-2004 # 8000bb38 <userret+0x2a98>
80003314:	00015517          	auipc	a0,0x15
80003318:	3d050513          	addi	a0,a0,976 # 800186e4 <tickslock>
8000331c:	ffffe097          	auipc	ra,0xffffe
80003320:	a4c080e7          	jalr	-1460(ra) # 80000d68 <initlock>
}
80003324:	00c12083          	lw	ra,12(sp)
80003328:	00812403          	lw	s0,8(sp)
8000332c:	01010113          	addi	sp,sp,16
80003330:	00008067          	ret

80003334 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
80003334:	ff010113          	addi	sp,sp,-16
80003338:	00112623          	sw	ra,12(sp)
8000333c:	00812423          	sw	s0,8(sp)
80003340:	01010413          	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
80003344:	00005797          	auipc	a5,0x5
80003348:	8ec78793          	addi	a5,a5,-1812 # 80007c30 <kernelvec>
8000334c:	10579073          	csrw	stvec,a5
  w_stvec((uint32)kernelvec);
}
80003350:	00c12083          	lw	ra,12(sp)
80003354:	00812403          	lw	s0,8(sp)
80003358:	01010113          	addi	sp,sp,16
8000335c:	00008067          	ret

80003360 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
80003360:	ff010113          	addi	sp,sp,-16
80003364:	00112623          	sw	ra,12(sp)
80003368:	00812423          	sw	s0,8(sp)
8000336c:	01010413          	addi	s0,sp,16
  struct proc *p = myproc();
80003370:	fffff097          	auipc	ra,0xfffff
80003374:	f6c080e7          	jalr	-148(ra) # 800022dc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
80003378:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
8000337c:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
80003380:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
80003384:	00006617          	auipc	a2,0x6
80003388:	c7c60613          	addi	a2,a2,-900 # 80009000 <trampoline>
8000338c:	00006797          	auipc	a5,0x6
80003390:	c7478793          	addi	a5,a5,-908 # 80009000 <trampoline>
80003394:	40c787b3          	sub	a5,a5,a2
80003398:	fffff737          	lui	a4,0xfffff
8000339c:	00e787b3          	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
800033a0:	10579073          	csrw	stvec,a5

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
800033a4:	03052783          	lw	a5,48(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
800033a8:	18002773          	csrr	a4,satp
800033ac:	00e7a023          	sw	a4,0(a5)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
800033b0:	03052703          	lw	a4,48(a0)
800033b4:	02452783          	lw	a5,36(a0)
800033b8:	000016b7          	lui	a3,0x1
800033bc:	00d787b3          	add	a5,a5,a3
800033c0:	00f72223          	sw	a5,4(a4) # fffff004 <end+0x7ffd8ff0>
  p->tf->kernel_trap = (uint32)usertrap;
800033c4:	03052783          	lw	a5,48(a0)
800033c8:	00000717          	auipc	a4,0x0
800033cc:	19870713          	addi	a4,a4,408 # 80003560 <usertrap>
800033d0:	00e7a423          	sw	a4,8(a5)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
800033d4:	03052783          	lw	a5,48(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
800033d8:	00020713          	mv	a4,tp
800033dc:	00e7a823          	sw	a4,16(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
800033e0:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
800033e4:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
800033e8:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
800033ec:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
800033f0:	03052783          	lw	a5,48(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
800033f4:	00c7a783          	lw	a5,12(a5)
800033f8:	14179073          	csrw	sepc,a5

  // tell trampoline.S the user page table to switch to.
  uint32 satp = MAKE_SATP(p->pagetable);
800033fc:	02c52703          	lw	a4,44(a0)
80003400:	00c75713          	srli	a4,a4,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint32 fn = TRAMPOLINE + (userret - trampoline);
80003404:	00006797          	auipc	a5,0x6
80003408:	c9c78793          	addi	a5,a5,-868 # 800090a0 <userret>
8000340c:	40c787b3          	sub	a5,a5,a2
80003410:	40d787b3          	sub	a5,a5,a3
  ((void (*)(uint32,uint32))fn)(TRAPFRAME, satp);
80003414:	800005b7          	lui	a1,0x80000
80003418:	00b765b3          	or	a1,a4,a1
8000341c:	ffffe537          	lui	a0,0xffffe
80003420:	000780e7          	jalr	a5
}
80003424:	00c12083          	lw	ra,12(sp)
80003428:	00812403          	lw	s0,8(sp)
8000342c:	01010113          	addi	sp,sp,16
80003430:	00008067          	ret

80003434 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
80003434:	ff010113          	addi	sp,sp,-16
80003438:	00112623          	sw	ra,12(sp)
8000343c:	00812423          	sw	s0,8(sp)
80003440:	00912223          	sw	s1,4(sp)
80003444:	01010413          	addi	s0,sp,16
  acquire(&tickslock);
80003448:	00015497          	auipc	s1,0x15
8000344c:	29c48493          	addi	s1,s1,668 # 800186e4 <tickslock>
80003450:	00048513          	mv	a0,s1
80003454:	ffffe097          	auipc	ra,0xffffe
80003458:	aa0080e7          	jalr	-1376(ra) # 80000ef4 <acquire>
  ticks++;
8000345c:	00023517          	auipc	a0,0x23
80003460:	bb450513          	addi	a0,a0,-1100 # 80026010 <ticks>
80003464:	00052783          	lw	a5,0(a0)
80003468:	00178793          	addi	a5,a5,1
8000346c:	00f52023          	sw	a5,0(a0)
  wakeup(&ticks);
80003470:	00000097          	auipc	ra,0x0
80003474:	ac0080e7          	jalr	-1344(ra) # 80002f30 <wakeup>
  release(&tickslock);
80003478:	00048513          	mv	a0,s1
8000347c:	ffffe097          	auipc	ra,0xffffe
80003480:	aec080e7          	jalr	-1300(ra) # 80000f68 <release>
}
80003484:	00c12083          	lw	ra,12(sp)
80003488:	00812403          	lw	s0,8(sp)
8000348c:	00412483          	lw	s1,4(sp)
80003490:	01010113          	addi	sp,sp,16
80003494:	00008067          	ret

80003498 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
80003498:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
8000349c:	00000513          	li	a0,0
  if((scause & 0x80000000L) &&
800034a0:	0a07de63          	bgez	a5,8000355c <devintr+0xc4>
{
800034a4:	ff010113          	addi	sp,sp,-16
800034a8:	00112623          	sw	ra,12(sp)
800034ac:	00812423          	sw	s0,8(sp)
800034b0:	01010413          	addi	s0,sp,16
     (scause & 0xff) == 9){
800034b4:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x80000000L) &&
800034b8:	00900693          	li	a3,9
800034bc:	02d70263          	beq	a4,a3,800034e0 <devintr+0x48>
  } else if(scause == 0x80000001L){
800034c0:	80000737          	lui	a4,0x80000
800034c4:	00170713          	addi	a4,a4,1 # 80000001 <_entry+0x1>
    return 0;
800034c8:	00000513          	li	a0,0
  } else if(scause == 0x80000001L){
800034cc:	06e78263          	beq	a5,a4,80003530 <devintr+0x98>
  }
}
800034d0:	00c12083          	lw	ra,12(sp)
800034d4:	00812403          	lw	s0,8(sp)
800034d8:	01010113          	addi	sp,sp,16
800034dc:	00008067          	ret
800034e0:	00912223          	sw	s1,4(sp)
    int irq = plic_claim();
800034e4:	00005097          	auipc	ra,0x5
800034e8:	960080e7          	jalr	-1696(ra) # 80007e44 <plic_claim>
800034ec:	00050493          	mv	s1,a0
    if(irq == UART0_IRQ){
800034f0:	00a00793          	li	a5,10
800034f4:	02f50263          	beq	a0,a5,80003518 <devintr+0x80>
    } else if(irq == VIRTIO0_IRQ){
800034f8:	00100793          	li	a5,1
800034fc:	02f50463          	beq	a0,a5,80003524 <devintr+0x8c>
    plic_complete(irq);
80003500:	00048513          	mv	a0,s1
80003504:	00005097          	auipc	ra,0x5
80003508:	978080e7          	jalr	-1672(ra) # 80007e7c <plic_complete>
    return 1;
8000350c:	00100513          	li	a0,1
80003510:	00412483          	lw	s1,4(sp)
80003514:	fbdff06f          	j	800034d0 <devintr+0x38>
      uartintr();
80003518:	ffffd097          	auipc	ra,0xffffd
8000351c:	620080e7          	jalr	1568(ra) # 80000b38 <uartintr>
80003520:	fe1ff06f          	j	80003500 <devintr+0x68>
      virtio_disk_intr();
80003524:	00005097          	auipc	ra,0x5
80003528:	f30080e7          	jalr	-208(ra) # 80008454 <virtio_disk_intr>
8000352c:	fd5ff06f          	j	80003500 <devintr+0x68>
    if(cpuid() == 0){
80003530:	fffff097          	auipc	ra,0xfffff
80003534:	d4c080e7          	jalr	-692(ra) # 8000227c <cpuid>
80003538:	00050c63          	beqz	a0,80003550 <devintr+0xb8>
  asm volatile("csrr %0, sip" : "=r" (x) );
8000353c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
80003540:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
80003544:	14479073          	csrw	sip,a5
    return 2;
80003548:	00200513          	li	a0,2
8000354c:	f85ff06f          	j	800034d0 <devintr+0x38>
      clockintr();
80003550:	00000097          	auipc	ra,0x0
80003554:	ee4080e7          	jalr	-284(ra) # 80003434 <clockintr>
80003558:	fe5ff06f          	j	8000353c <devintr+0xa4>
}
8000355c:	00008067          	ret

80003560 <usertrap>:
{
80003560:	ff010113          	addi	sp,sp,-16
80003564:	00112623          	sw	ra,12(sp)
80003568:	00812423          	sw	s0,8(sp)
8000356c:	00912223          	sw	s1,4(sp)
80003570:	01212023          	sw	s2,0(sp)
80003574:	01010413          	addi	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r" (x) );
80003578:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
8000357c:	1007f793          	andi	a5,a5,256
80003580:	08079a63          	bnez	a5,80003614 <usertrap+0xb4>
  asm volatile("csrw stvec, %0" : : "r" (x));
80003584:	00004797          	auipc	a5,0x4
80003588:	6ac78793          	addi	a5,a5,1708 # 80007c30 <kernelvec>
8000358c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
80003590:	fffff097          	auipc	ra,0xfffff
80003594:	d4c080e7          	jalr	-692(ra) # 800022dc <myproc>
80003598:	00050493          	mv	s1,a0
  p->tf->epc = r_sepc();
8000359c:	03052783          	lw	a5,48(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
800035a0:	14102773          	csrr	a4,sepc
800035a4:	00e7a623          	sw	a4,12(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
800035a8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
800035ac:	00800793          	li	a5,8
800035b0:	08f71263          	bne	a4,a5,80003634 <usertrap+0xd4>
    if(p->killed)
800035b4:	01852783          	lw	a5,24(a0)
800035b8:	06079663          	bnez	a5,80003624 <usertrap+0xc4>
    p->tf->epc += 4;
800035bc:	0304a703          	lw	a4,48(s1)
800035c0:	00c72783          	lw	a5,12(a4)
800035c4:	00478793          	addi	a5,a5,4
800035c8:	00f72623          	sw	a5,12(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
800035cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
800035d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
800035d4:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
800035d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
800035dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
800035e0:	10079073          	csrw	sstatus,a5
    syscall();
800035e4:	00000097          	auipc	ra,0x0
800035e8:	430080e7          	jalr	1072(ra) # 80003a14 <syscall>
  if(p->killed)
800035ec:	0184a783          	lw	a5,24(s1)
800035f0:	0a079c63          	bnez	a5,800036a8 <usertrap+0x148>
  usertrapret();
800035f4:	00000097          	auipc	ra,0x0
800035f8:	d6c080e7          	jalr	-660(ra) # 80003360 <usertrapret>
}
800035fc:	00c12083          	lw	ra,12(sp)
80003600:	00812403          	lw	s0,8(sp)
80003604:	00412483          	lw	s1,4(sp)
80003608:	00012903          	lw	s2,0(sp)
8000360c:	01010113          	addi	sp,sp,16
80003610:	00008067          	ret
    panic("usertrap: not from user mode");
80003614:	00008517          	auipc	a0,0x8
80003618:	52c50513          	addi	a0,a0,1324 # 8000bb40 <userret+0x2aa0>
8000361c:	ffffd097          	auipc	ra,0xffffd
80003620:	0e4080e7          	jalr	228(ra) # 80000700 <panic>
      exit(-1);
80003624:	fff00513          	li	a0,-1
80003628:	fffff097          	auipc	ra,0xfffff
8000362c:	564080e7          	jalr	1380(ra) # 80002b8c <exit>
80003630:	f8dff06f          	j	800035bc <usertrap+0x5c>
  } else if((which_dev = devintr()) != 0){
80003634:	00000097          	auipc	ra,0x0
80003638:	e64080e7          	jalr	-412(ra) # 80003498 <devintr>
8000363c:	00050913          	mv	s2,a0
80003640:	00050863          	beqz	a0,80003650 <usertrap+0xf0>
  if(p->killed)
80003644:	0184a783          	lw	a5,24(s1)
80003648:	04078663          	beqz	a5,80003694 <usertrap+0x134>
8000364c:	03c0006f          	j	80003688 <usertrap+0x128>
  asm volatile("csrr %0, scause" : "=r" (x) );
80003650:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
80003654:	0204a603          	lw	a2,32(s1)
80003658:	00008517          	auipc	a0,0x8
8000365c:	50850513          	addi	a0,a0,1288 # 8000bb60 <userret+0x2ac0>
80003660:	ffffd097          	auipc	ra,0xffffd
80003664:	0fc080e7          	jalr	252(ra) # 8000075c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
80003668:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
8000366c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
80003670:	00008517          	auipc	a0,0x8
80003674:	51c50513          	addi	a0,a0,1308 # 8000bb8c <userret+0x2aec>
80003678:	ffffd097          	auipc	ra,0xffffd
8000367c:	0e4080e7          	jalr	228(ra) # 8000075c <printf>
    p->killed = 1;
80003680:	00100793          	li	a5,1
80003684:	00f4ac23          	sw	a5,24(s1)
    exit(-1);
80003688:	fff00513          	li	a0,-1
8000368c:	fffff097          	auipc	ra,0xfffff
80003690:	500080e7          	jalr	1280(ra) # 80002b8c <exit>
  if(which_dev == 2)
80003694:	00200793          	li	a5,2
80003698:	f4f91ee3          	bne	s2,a5,800035f4 <usertrap+0x94>
    yield();
8000369c:	fffff097          	auipc	ra,0xfffff
800036a0:	62c080e7          	jalr	1580(ra) # 80002cc8 <yield>
800036a4:	f51ff06f          	j	800035f4 <usertrap+0x94>
  int which_dev = 0;
800036a8:	00000913          	li	s2,0
800036ac:	fddff06f          	j	80003688 <usertrap+0x128>

800036b0 <kerneltrap>:
{
800036b0:	fe010113          	addi	sp,sp,-32
800036b4:	00112e23          	sw	ra,28(sp)
800036b8:	00812c23          	sw	s0,24(sp)
800036bc:	00912a23          	sw	s1,20(sp)
800036c0:	01212823          	sw	s2,16(sp)
800036c4:	01312623          	sw	s3,12(sp)
800036c8:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sepc" : "=r" (x) );
800036cc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
800036d0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
800036d4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
800036d8:	1004f793          	andi	a5,s1,256
800036dc:	04078463          	beqz	a5,80003724 <kerneltrap+0x74>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
800036e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
800036e4:	0027f793          	andi	a5,a5,2
  if(intr_get() != 0)
800036e8:	04079663          	bnez	a5,80003734 <kerneltrap+0x84>
  if((which_dev = devintr()) == 0){
800036ec:	00000097          	auipc	ra,0x0
800036f0:	dac080e7          	jalr	-596(ra) # 80003498 <devintr>
800036f4:	04050863          	beqz	a0,80003744 <kerneltrap+0x94>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
800036f8:	00200793          	li	a5,2
800036fc:	08f50263          	beq	a0,a5,80003780 <kerneltrap+0xd0>
  asm volatile("csrw sepc, %0" : : "r" (x));
80003700:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
80003704:	10049073          	csrw	sstatus,s1
}
80003708:	01c12083          	lw	ra,28(sp)
8000370c:	01812403          	lw	s0,24(sp)
80003710:	01412483          	lw	s1,20(sp)
80003714:	01012903          	lw	s2,16(sp)
80003718:	00c12983          	lw	s3,12(sp)
8000371c:	02010113          	addi	sp,sp,32
80003720:	00008067          	ret
    panic("kerneltrap: not from supervisor mode");
80003724:	00008517          	auipc	a0,0x8
80003728:	48850513          	addi	a0,a0,1160 # 8000bbac <userret+0x2b0c>
8000372c:	ffffd097          	auipc	ra,0xffffd
80003730:	fd4080e7          	jalr	-44(ra) # 80000700 <panic>
    panic("kerneltrap: interrupts enabled");
80003734:	00008517          	auipc	a0,0x8
80003738:	4a050513          	addi	a0,a0,1184 # 8000bbd4 <userret+0x2b34>
8000373c:	ffffd097          	auipc	ra,0xffffd
80003740:	fc4080e7          	jalr	-60(ra) # 80000700 <panic>
    printf("scause %p\n", scause);
80003744:	00098593          	mv	a1,s3
80003748:	00008517          	auipc	a0,0x8
8000374c:	4ac50513          	addi	a0,a0,1196 # 8000bbf4 <userret+0x2b54>
80003750:	ffffd097          	auipc	ra,0xffffd
80003754:	00c080e7          	jalr	12(ra) # 8000075c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
80003758:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
8000375c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
80003760:	00008517          	auipc	a0,0x8
80003764:	43850513          	addi	a0,a0,1080 # 8000bb98 <userret+0x2af8>
80003768:	ffffd097          	auipc	ra,0xffffd
8000376c:	ff4080e7          	jalr	-12(ra) # 8000075c <printf>
    panic("kerneltrap");
80003770:	00008517          	auipc	a0,0x8
80003774:	49050513          	addi	a0,a0,1168 # 8000bc00 <userret+0x2b60>
80003778:	ffffd097          	auipc	ra,0xffffd
8000377c:	f88080e7          	jalr	-120(ra) # 80000700 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
80003780:	fffff097          	auipc	ra,0xfffff
80003784:	b5c080e7          	jalr	-1188(ra) # 800022dc <myproc>
80003788:	f6050ce3          	beqz	a0,80003700 <kerneltrap+0x50>
8000378c:	fffff097          	auipc	ra,0xfffff
80003790:	b50080e7          	jalr	-1200(ra) # 800022dc <myproc>
80003794:	00c52703          	lw	a4,12(a0)
80003798:	00300793          	li	a5,3
8000379c:	f6f712e3          	bne	a4,a5,80003700 <kerneltrap+0x50>
    yield();
800037a0:	fffff097          	auipc	ra,0xfffff
800037a4:	528080e7          	jalr	1320(ra) # 80002cc8 <yield>
800037a8:	f59ff06f          	j	80003700 <kerneltrap+0x50>

800037ac <argraw>:
  return strlen(buf);
}

static uint32
argraw(int n)
{
800037ac:	ff010113          	addi	sp,sp,-16
800037b0:	00112623          	sw	ra,12(sp)
800037b4:	00812423          	sw	s0,8(sp)
800037b8:	00912223          	sw	s1,4(sp)
800037bc:	01010413          	addi	s0,sp,16
800037c0:	00050493          	mv	s1,a0
  struct proc *p = myproc();
800037c4:	fffff097          	auipc	ra,0xfffff
800037c8:	b18080e7          	jalr	-1256(ra) # 800022dc <myproc>
  switch (n) {
800037cc:	00500793          	li	a5,5
800037d0:	0697ec63          	bltu	a5,s1,80003848 <argraw+0x9c>
800037d4:	00249493          	slli	s1,s1,0x2
800037d8:	00008717          	auipc	a4,0x8
800037dc:	77070713          	addi	a4,a4,1904 # 8000bf48 <states.0+0x14>
800037e0:	00e484b3          	add	s1,s1,a4
800037e4:	0004a783          	lw	a5,0(s1)
800037e8:	00e787b3          	add	a5,a5,a4
800037ec:	00078067          	jr	a5
  case 0:
    return p->tf->a0;
800037f0:	03052783          	lw	a5,48(a0)
800037f4:	0387a503          	lw	a0,56(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
800037f8:	00c12083          	lw	ra,12(sp)
800037fc:	00812403          	lw	s0,8(sp)
80003800:	00412483          	lw	s1,4(sp)
80003804:	01010113          	addi	sp,sp,16
80003808:	00008067          	ret
    return p->tf->a1;
8000380c:	03052783          	lw	a5,48(a0)
80003810:	03c7a503          	lw	a0,60(a5)
80003814:	fe5ff06f          	j	800037f8 <argraw+0x4c>
    return p->tf->a2;
80003818:	03052783          	lw	a5,48(a0)
8000381c:	0407a503          	lw	a0,64(a5)
80003820:	fd9ff06f          	j	800037f8 <argraw+0x4c>
    return p->tf->a3;
80003824:	03052783          	lw	a5,48(a0)
80003828:	0447a503          	lw	a0,68(a5)
8000382c:	fcdff06f          	j	800037f8 <argraw+0x4c>
    return p->tf->a4;
80003830:	03052783          	lw	a5,48(a0)
80003834:	0487a503          	lw	a0,72(a5)
80003838:	fc1ff06f          	j	800037f8 <argraw+0x4c>
    return p->tf->a5;
8000383c:	03052783          	lw	a5,48(a0)
80003840:	04c7a503          	lw	a0,76(a5)
80003844:	fb5ff06f          	j	800037f8 <argraw+0x4c>
  panic("argraw");
80003848:	00008517          	auipc	a0,0x8
8000384c:	3c450513          	addi	a0,a0,964 # 8000bc0c <userret+0x2b6c>
80003850:	ffffd097          	auipc	ra,0xffffd
80003854:	eb0080e7          	jalr	-336(ra) # 80000700 <panic>

80003858 <fetchaddr>:
{
80003858:	ff010113          	addi	sp,sp,-16
8000385c:	00112623          	sw	ra,12(sp)
80003860:	00812423          	sw	s0,8(sp)
80003864:	00912223          	sw	s1,4(sp)
80003868:	01212023          	sw	s2,0(sp)
8000386c:	01010413          	addi	s0,sp,16
80003870:	00050493          	mv	s1,a0
80003874:	00058913          	mv	s2,a1
  struct proc *p = myproc();
80003878:	fffff097          	auipc	ra,0xfffff
8000387c:	a64080e7          	jalr	-1436(ra) # 800022dc <myproc>
  if(addr >= p->sz || addr+sizeof(uint32) > p->sz)
80003880:	02852783          	lw	a5,40(a0)
80003884:	04f4f263          	bgeu	s1,a5,800038c8 <fetchaddr+0x70>
80003888:	00448713          	addi	a4,s1,4
8000388c:	04e7e263          	bltu	a5,a4,800038d0 <fetchaddr+0x78>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
80003890:	00400693          	li	a3,4
80003894:	00048613          	mv	a2,s1
80003898:	00090593          	mv	a1,s2
8000389c:	02c52503          	lw	a0,44(a0)
800038a0:	ffffe097          	auipc	ra,0xffffe
800038a4:	664080e7          	jalr	1636(ra) # 80001f04 <copyin>
800038a8:	00a03533          	snez	a0,a0
800038ac:	40a00533          	neg	a0,a0
}
800038b0:	00c12083          	lw	ra,12(sp)
800038b4:	00812403          	lw	s0,8(sp)
800038b8:	00412483          	lw	s1,4(sp)
800038bc:	00012903          	lw	s2,0(sp)
800038c0:	01010113          	addi	sp,sp,16
800038c4:	00008067          	ret
    return -1;
800038c8:	fff00513          	li	a0,-1
800038cc:	fe5ff06f          	j	800038b0 <fetchaddr+0x58>
800038d0:	fff00513          	li	a0,-1
800038d4:	fddff06f          	j	800038b0 <fetchaddr+0x58>

800038d8 <fetchstr>:
{
800038d8:	fe010113          	addi	sp,sp,-32
800038dc:	00112e23          	sw	ra,28(sp)
800038e0:	00812c23          	sw	s0,24(sp)
800038e4:	00912a23          	sw	s1,20(sp)
800038e8:	01212823          	sw	s2,16(sp)
800038ec:	01312623          	sw	s3,12(sp)
800038f0:	02010413          	addi	s0,sp,32
800038f4:	00050913          	mv	s2,a0
800038f8:	00058493          	mv	s1,a1
800038fc:	00060993          	mv	s3,a2
  struct proc *p = myproc();
80003900:	fffff097          	auipc	ra,0xfffff
80003904:	9dc080e7          	jalr	-1572(ra) # 800022dc <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
80003908:	00098693          	mv	a3,s3
8000390c:	00090613          	mv	a2,s2
80003910:	00048593          	mv	a1,s1
80003914:	02c52503          	lw	a0,44(a0)
80003918:	ffffe097          	auipc	ra,0xffffe
8000391c:	6d4080e7          	jalr	1748(ra) # 80001fec <copyinstr>
  if(err < 0)
80003920:	00054863          	bltz	a0,80003930 <fetchstr+0x58>
  return strlen(buf);
80003924:	00048513          	mv	a0,s1
80003928:	ffffe097          	auipc	ra,0xffffe
8000392c:	8d0080e7          	jalr	-1840(ra) # 800011f8 <strlen>
}
80003930:	01c12083          	lw	ra,28(sp)
80003934:	01812403          	lw	s0,24(sp)
80003938:	01412483          	lw	s1,20(sp)
8000393c:	01012903          	lw	s2,16(sp)
80003940:	00c12983          	lw	s3,12(sp)
80003944:	02010113          	addi	sp,sp,32
80003948:	00008067          	ret

8000394c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8000394c:	ff010113          	addi	sp,sp,-16
80003950:	00112623          	sw	ra,12(sp)
80003954:	00812423          	sw	s0,8(sp)
80003958:	00912223          	sw	s1,4(sp)
8000395c:	01010413          	addi	s0,sp,16
80003960:	00058493          	mv	s1,a1
  *ip = argraw(n);
80003964:	00000097          	auipc	ra,0x0
80003968:	e48080e7          	jalr	-440(ra) # 800037ac <argraw>
8000396c:	00a4a023          	sw	a0,0(s1)
  return 0;
}
80003970:	00000513          	li	a0,0
80003974:	00c12083          	lw	ra,12(sp)
80003978:	00812403          	lw	s0,8(sp)
8000397c:	00412483          	lw	s1,4(sp)
80003980:	01010113          	addi	sp,sp,16
80003984:	00008067          	ret

80003988 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint32 *ip)
{
80003988:	ff010113          	addi	sp,sp,-16
8000398c:	00112623          	sw	ra,12(sp)
80003990:	00812423          	sw	s0,8(sp)
80003994:	00912223          	sw	s1,4(sp)
80003998:	01010413          	addi	s0,sp,16
8000399c:	00058493          	mv	s1,a1
  *ip = argraw(n);
800039a0:	00000097          	auipc	ra,0x0
800039a4:	e0c080e7          	jalr	-500(ra) # 800037ac <argraw>
800039a8:	00a4a023          	sw	a0,0(s1)
  return 0;
}
800039ac:	00000513          	li	a0,0
800039b0:	00c12083          	lw	ra,12(sp)
800039b4:	00812403          	lw	s0,8(sp)
800039b8:	00412483          	lw	s1,4(sp)
800039bc:	01010113          	addi	sp,sp,16
800039c0:	00008067          	ret

800039c4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
800039c4:	ff010113          	addi	sp,sp,-16
800039c8:	00112623          	sw	ra,12(sp)
800039cc:	00812423          	sw	s0,8(sp)
800039d0:	00912223          	sw	s1,4(sp)
800039d4:	01212023          	sw	s2,0(sp)
800039d8:	01010413          	addi	s0,sp,16
800039dc:	00058493          	mv	s1,a1
800039e0:	00060913          	mv	s2,a2
  *ip = argraw(n);
800039e4:	00000097          	auipc	ra,0x0
800039e8:	dc8080e7          	jalr	-568(ra) # 800037ac <argraw>
  uint32 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
800039ec:	00090613          	mv	a2,s2
800039f0:	00048593          	mv	a1,s1
800039f4:	00000097          	auipc	ra,0x0
800039f8:	ee4080e7          	jalr	-284(ra) # 800038d8 <fetchstr>
}
800039fc:	00c12083          	lw	ra,12(sp)
80003a00:	00812403          	lw	s0,8(sp)
80003a04:	00412483          	lw	s1,4(sp)
80003a08:	00012903          	lw	s2,0(sp)
80003a0c:	01010113          	addi	sp,sp,16
80003a10:	00008067          	ret

80003a14 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80003a14:	ff010113          	addi	sp,sp,-16
80003a18:	00112623          	sw	ra,12(sp)
80003a1c:	00812423          	sw	s0,8(sp)
80003a20:	00912223          	sw	s1,4(sp)
80003a24:	01212023          	sw	s2,0(sp)
80003a28:	01010413          	addi	s0,sp,16
  int num;
  struct proc *p = myproc();
80003a2c:	fffff097          	auipc	ra,0xfffff
80003a30:	8b0080e7          	jalr	-1872(ra) # 800022dc <myproc>
80003a34:	00050493          	mv	s1,a0

  num = p->tf->a7;
80003a38:	03052903          	lw	s2,48(a0)
80003a3c:	05492683          	lw	a3,84(s2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80003a40:	fff68713          	addi	a4,a3,-1 # fff <_entry-0x7ffff001>
80003a44:	01400793          	li	a5,20
80003a48:	02e7e463          	bltu	a5,a4,80003a70 <syscall+0x5c>
80003a4c:	00269713          	slli	a4,a3,0x2
80003a50:	00008797          	auipc	a5,0x8
80003a54:	51078793          	addi	a5,a5,1296 # 8000bf60 <syscalls>
80003a58:	00e787b3          	add	a5,a5,a4
80003a5c:	0007a783          	lw	a5,0(a5)
80003a60:	00078863          	beqz	a5,80003a70 <syscall+0x5c>
    p->tf->a0 = syscalls[num]();
80003a64:	000780e7          	jalr	a5
80003a68:	02a92c23          	sw	a0,56(s2)
80003a6c:	0280006f          	j	80003a94 <syscall+0x80>
  } else {
    printf("%d %s: unknown sys call %d\n",
80003a70:	0b048613          	addi	a2,s1,176
80003a74:	0204a583          	lw	a1,32(s1)
80003a78:	00008517          	auipc	a0,0x8
80003a7c:	19c50513          	addi	a0,a0,412 # 8000bc14 <userret+0x2b74>
80003a80:	ffffd097          	auipc	ra,0xffffd
80003a84:	cdc080e7          	jalr	-804(ra) # 8000075c <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
80003a88:	0304a783          	lw	a5,48(s1)
80003a8c:	fff00713          	li	a4,-1
80003a90:	02e7ac23          	sw	a4,56(a5)
  }
}
80003a94:	00c12083          	lw	ra,12(sp)
80003a98:	00812403          	lw	s0,8(sp)
80003a9c:	00412483          	lw	s1,4(sp)
80003aa0:	00012903          	lw	s2,0(sp)
80003aa4:	01010113          	addi	sp,sp,16
80003aa8:	00008067          	ret

80003aac <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint32
sys_exit(void)
{
80003aac:	fe010113          	addi	sp,sp,-32
80003ab0:	00112e23          	sw	ra,28(sp)
80003ab4:	00812c23          	sw	s0,24(sp)
80003ab8:	02010413          	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
80003abc:	fec40593          	addi	a1,s0,-20
80003ac0:	00000513          	li	a0,0
80003ac4:	00000097          	auipc	ra,0x0
80003ac8:	e88080e7          	jalr	-376(ra) # 8000394c <argint>
    return -1;
80003acc:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
80003ad0:	00054a63          	bltz	a0,80003ae4 <sys_exit+0x38>
  exit(n);
80003ad4:	fec42503          	lw	a0,-20(s0)
80003ad8:	fffff097          	auipc	ra,0xfffff
80003adc:	0b4080e7          	jalr	180(ra) # 80002b8c <exit>
  return 0;  // not reached
80003ae0:	00000793          	li	a5,0
}
80003ae4:	00078513          	mv	a0,a5
80003ae8:	01c12083          	lw	ra,28(sp)
80003aec:	01812403          	lw	s0,24(sp)
80003af0:	02010113          	addi	sp,sp,32
80003af4:	00008067          	ret

80003af8 <sys_getpid>:

uint32
sys_getpid(void)
{
80003af8:	ff010113          	addi	sp,sp,-16
80003afc:	00112623          	sw	ra,12(sp)
80003b00:	00812423          	sw	s0,8(sp)
80003b04:	01010413          	addi	s0,sp,16
  return myproc()->pid;
80003b08:	ffffe097          	auipc	ra,0xffffe
80003b0c:	7d4080e7          	jalr	2004(ra) # 800022dc <myproc>
}
80003b10:	02052503          	lw	a0,32(a0)
80003b14:	00c12083          	lw	ra,12(sp)
80003b18:	00812403          	lw	s0,8(sp)
80003b1c:	01010113          	addi	sp,sp,16
80003b20:	00008067          	ret

80003b24 <sys_fork>:

uint32
sys_fork(void)
{
80003b24:	ff010113          	addi	sp,sp,-16
80003b28:	00112623          	sw	ra,12(sp)
80003b2c:	00812423          	sw	s0,8(sp)
80003b30:	01010413          	addi	s0,sp,16
  return fork();
80003b34:	fffff097          	auipc	ra,0xfffff
80003b38:	c58080e7          	jalr	-936(ra) # 8000278c <fork>
}
80003b3c:	00c12083          	lw	ra,12(sp)
80003b40:	00812403          	lw	s0,8(sp)
80003b44:	01010113          	addi	sp,sp,16
80003b48:	00008067          	ret

80003b4c <sys_wait>:

uint32
sys_wait(void)
{
80003b4c:	fe010113          	addi	sp,sp,-32
80003b50:	00112e23          	sw	ra,28(sp)
80003b54:	00812c23          	sw	s0,24(sp)
80003b58:	02010413          	addi	s0,sp,32
  uint32 p;
  if(argaddr(0, &p) < 0)
80003b5c:	fec40593          	addi	a1,s0,-20
80003b60:	00000513          	li	a0,0
80003b64:	00000097          	auipc	ra,0x0
80003b68:	e24080e7          	jalr	-476(ra) # 80003988 <argaddr>
80003b6c:	00050793          	mv	a5,a0
    return -1;
80003b70:	fff00513          	li	a0,-1
  if(argaddr(0, &p) < 0)
80003b74:	0007c863          	bltz	a5,80003b84 <sys_wait+0x38>
  return wait(p);
80003b78:	fec42503          	lw	a0,-20(s0)
80003b7c:	fffff097          	auipc	ra,0xfffff
80003b80:	254080e7          	jalr	596(ra) # 80002dd0 <wait>
}
80003b84:	01c12083          	lw	ra,28(sp)
80003b88:	01812403          	lw	s0,24(sp)
80003b8c:	02010113          	addi	sp,sp,32
80003b90:	00008067          	ret

80003b94 <sys_sbrk>:

uint32
sys_sbrk(void)
{
80003b94:	fe010113          	addi	sp,sp,-32
80003b98:	00112e23          	sw	ra,28(sp)
80003b9c:	00812c23          	sw	s0,24(sp)
80003ba0:	00912a23          	sw	s1,20(sp)
80003ba4:	02010413          	addi	s0,sp,32
  int addr;
  int n;

  if(argint(0, &n) < 0)
80003ba8:	fec40593          	addi	a1,s0,-20
80003bac:	00000513          	li	a0,0
80003bb0:	00000097          	auipc	ra,0x0
80003bb4:	d9c080e7          	jalr	-612(ra) # 8000394c <argint>
    return -1;
80003bb8:	fff00493          	li	s1,-1
  if(argint(0, &n) < 0)
80003bbc:	02054063          	bltz	a0,80003bdc <sys_sbrk+0x48>
  addr = myproc()->sz;
80003bc0:	ffffe097          	auipc	ra,0xffffe
80003bc4:	71c080e7          	jalr	1820(ra) # 800022dc <myproc>
80003bc8:	02852483          	lw	s1,40(a0)
  if(growproc(n) < 0)
80003bcc:	fec42503          	lw	a0,-20(s0)
80003bd0:	fffff097          	auipc	ra,0xfffff
80003bd4:	b30080e7          	jalr	-1232(ra) # 80002700 <growproc>
80003bd8:	00054e63          	bltz	a0,80003bf4 <sys_sbrk+0x60>
    return -1;
  return addr;
}
80003bdc:	00048513          	mv	a0,s1
80003be0:	01c12083          	lw	ra,28(sp)
80003be4:	01812403          	lw	s0,24(sp)
80003be8:	01412483          	lw	s1,20(sp)
80003bec:	02010113          	addi	sp,sp,32
80003bf0:	00008067          	ret
    return -1;
80003bf4:	fff00493          	li	s1,-1
80003bf8:	fe5ff06f          	j	80003bdc <sys_sbrk+0x48>

80003bfc <sys_sleep>:

uint32
sys_sleep(void)
{
80003bfc:	fd010113          	addi	sp,sp,-48
80003c00:	02112623          	sw	ra,44(sp)
80003c04:	02812423          	sw	s0,40(sp)
80003c08:	03010413          	addi	s0,sp,48
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80003c0c:	fdc40593          	addi	a1,s0,-36
80003c10:	00000513          	li	a0,0
80003c14:	00000097          	auipc	ra,0x0
80003c18:	d38080e7          	jalr	-712(ra) # 8000394c <argint>
    return -1;
80003c1c:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
80003c20:	08054863          	bltz	a0,80003cb0 <sys_sleep+0xb4>
80003c24:	03212023          	sw	s2,32(sp)
  acquire(&tickslock);
80003c28:	00015517          	auipc	a0,0x15
80003c2c:	abc50513          	addi	a0,a0,-1348 # 800186e4 <tickslock>
80003c30:	ffffd097          	auipc	ra,0xffffd
80003c34:	2c4080e7          	jalr	708(ra) # 80000ef4 <acquire>
  ticks0 = ticks;
80003c38:	00022917          	auipc	s2,0x22
80003c3c:	3d892903          	lw	s2,984(s2) # 80026010 <ticks>
  while(ticks - ticks0 < n){
80003c40:	fdc42783          	lw	a5,-36(s0)
80003c44:	04078a63          	beqz	a5,80003c98 <sys_sleep+0x9c>
80003c48:	02912223          	sw	s1,36(sp)
80003c4c:	01312e23          	sw	s3,28(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80003c50:	00015997          	auipc	s3,0x15
80003c54:	a9498993          	addi	s3,s3,-1388 # 800186e4 <tickslock>
80003c58:	00022497          	auipc	s1,0x22
80003c5c:	3b848493          	addi	s1,s1,952 # 80026010 <ticks>
    if(myproc()->killed){
80003c60:	ffffe097          	auipc	ra,0xffffe
80003c64:	67c080e7          	jalr	1660(ra) # 800022dc <myproc>
80003c68:	01852783          	lw	a5,24(a0)
80003c6c:	04079c63          	bnez	a5,80003cc4 <sys_sleep+0xc8>
    sleep(&ticks, &tickslock);
80003c70:	00098593          	mv	a1,s3
80003c74:	00048513          	mv	a0,s1
80003c78:	fffff097          	auipc	ra,0xfffff
80003c7c:	0a8080e7          	jalr	168(ra) # 80002d20 <sleep>
  while(ticks - ticks0 < n){
80003c80:	0004a783          	lw	a5,0(s1)
80003c84:	412787b3          	sub	a5,a5,s2
80003c88:	fdc42703          	lw	a4,-36(s0)
80003c8c:	fce7eae3          	bltu	a5,a4,80003c60 <sys_sleep+0x64>
80003c90:	02412483          	lw	s1,36(sp)
80003c94:	01c12983          	lw	s3,28(sp)
  }
  release(&tickslock);
80003c98:	00015517          	auipc	a0,0x15
80003c9c:	a4c50513          	addi	a0,a0,-1460 # 800186e4 <tickslock>
80003ca0:	ffffd097          	auipc	ra,0xffffd
80003ca4:	2c8080e7          	jalr	712(ra) # 80000f68 <release>
  return 0;
80003ca8:	00000793          	li	a5,0
80003cac:	02012903          	lw	s2,32(sp)
}
80003cb0:	00078513          	mv	a0,a5
80003cb4:	02c12083          	lw	ra,44(sp)
80003cb8:	02812403          	lw	s0,40(sp)
80003cbc:	03010113          	addi	sp,sp,48
80003cc0:	00008067          	ret
      release(&tickslock);
80003cc4:	00015517          	auipc	a0,0x15
80003cc8:	a2050513          	addi	a0,a0,-1504 # 800186e4 <tickslock>
80003ccc:	ffffd097          	auipc	ra,0xffffd
80003cd0:	29c080e7          	jalr	668(ra) # 80000f68 <release>
      return -1;
80003cd4:	fff00793          	li	a5,-1
80003cd8:	02412483          	lw	s1,36(sp)
80003cdc:	02012903          	lw	s2,32(sp)
80003ce0:	01c12983          	lw	s3,28(sp)
80003ce4:	fcdff06f          	j	80003cb0 <sys_sleep+0xb4>

80003ce8 <sys_kill>:

uint32
sys_kill(void)
{
80003ce8:	fe010113          	addi	sp,sp,-32
80003cec:	00112e23          	sw	ra,28(sp)
80003cf0:	00812c23          	sw	s0,24(sp)
80003cf4:	02010413          	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
80003cf8:	fec40593          	addi	a1,s0,-20
80003cfc:	00000513          	li	a0,0
80003d00:	00000097          	auipc	ra,0x0
80003d04:	c4c080e7          	jalr	-948(ra) # 8000394c <argint>
80003d08:	00050793          	mv	a5,a0
    return -1;
80003d0c:	fff00513          	li	a0,-1
  if(argint(0, &pid) < 0)
80003d10:	0007c863          	bltz	a5,80003d20 <sys_kill+0x38>
  return kill(pid);
80003d14:	fec42503          	lw	a0,-20(s0)
80003d18:	fffff097          	auipc	ra,0xfffff
80003d1c:	2b8080e7          	jalr	696(ra) # 80002fd0 <kill>
}
80003d20:	01c12083          	lw	ra,28(sp)
80003d24:	01812403          	lw	s0,24(sp)
80003d28:	02010113          	addi	sp,sp,32
80003d2c:	00008067          	ret

80003d30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint32
sys_uptime(void)
{
80003d30:	ff010113          	addi	sp,sp,-16
80003d34:	00112623          	sw	ra,12(sp)
80003d38:	00812423          	sw	s0,8(sp)
80003d3c:	00912223          	sw	s1,4(sp)
80003d40:	01010413          	addi	s0,sp,16
  uint xticks;

  acquire(&tickslock);
80003d44:	00015517          	auipc	a0,0x15
80003d48:	9a050513          	addi	a0,a0,-1632 # 800186e4 <tickslock>
80003d4c:	ffffd097          	auipc	ra,0xffffd
80003d50:	1a8080e7          	jalr	424(ra) # 80000ef4 <acquire>
  xticks = ticks;
80003d54:	00022497          	auipc	s1,0x22
80003d58:	2bc4a483          	lw	s1,700(s1) # 80026010 <ticks>
  release(&tickslock);
80003d5c:	00015517          	auipc	a0,0x15
80003d60:	98850513          	addi	a0,a0,-1656 # 800186e4 <tickslock>
80003d64:	ffffd097          	auipc	ra,0xffffd
80003d68:	204080e7          	jalr	516(ra) # 80000f68 <release>
  return xticks;
}
80003d6c:	00048513          	mv	a0,s1
80003d70:	00c12083          	lw	ra,12(sp)
80003d74:	00812403          	lw	s0,8(sp)
80003d78:	00412483          	lw	s1,4(sp)
80003d7c:	01010113          	addi	sp,sp,16
80003d80:	00008067          	ret

80003d84 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80003d84:	fe010113          	addi	sp,sp,-32
80003d88:	00112e23          	sw	ra,28(sp)
80003d8c:	00812c23          	sw	s0,24(sp)
80003d90:	00912a23          	sw	s1,20(sp)
80003d94:	01212823          	sw	s2,16(sp)
80003d98:	01312623          	sw	s3,12(sp)
80003d9c:	01412423          	sw	s4,8(sp)
80003da0:	02010413          	addi	s0,sp,32
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80003da4:	00008597          	auipc	a1,0x8
80003da8:	e8c58593          	addi	a1,a1,-372 # 8000bc30 <userret+0x2b90>
80003dac:	00015517          	auipc	a0,0x15
80003db0:	94450513          	addi	a0,a0,-1724 # 800186f0 <bcache>
80003db4:	ffffd097          	auipc	ra,0xffffd
80003db8:	fb4080e7          	jalr	-76(ra) # 80000d68 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80003dbc:	0001d797          	auipc	a5,0x1d
80003dc0:	93478793          	addi	a5,a5,-1740 # 800206f0 <bcache+0x8000>
80003dc4:	0001c717          	auipc	a4,0x1c
80003dc8:	7c870713          	addi	a4,a4,1992 # 8002058c <bcache+0x7e9c>
80003dcc:	ece7a423          	sw	a4,-312(a5)
  bcache.head.next = &bcache.head;
80003dd0:	ece7a623          	sw	a4,-308(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80003dd4:	00015497          	auipc	s1,0x15
80003dd8:	92848493          	addi	s1,s1,-1752 # 800186fc <bcache+0xc>
    b->next = bcache.head.next;
80003ddc:	00078913          	mv	s2,a5
    b->prev = &bcache.head;
80003de0:	00070993          	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
80003de4:	00008a17          	auipc	s4,0x8
80003de8:	e54a0a13          	addi	s4,s4,-428 # 8000bc38 <userret+0x2b98>
    b->next = bcache.head.next;
80003dec:	ecc92783          	lw	a5,-308(s2)
80003df0:	02f4a823          	sw	a5,48(s1)
    b->prev = &bcache.head;
80003df4:	0334a623          	sw	s3,44(s1)
    initsleeplock(&b->lock, "buffer");
80003df8:	000a0593          	mv	a1,s4
80003dfc:	01048513          	addi	a0,s1,16
80003e00:	00002097          	auipc	ra,0x2
80003e04:	c3c080e7          	jalr	-964(ra) # 80005a3c <initsleeplock>
    bcache.head.next->prev = b;
80003e08:	ecc92783          	lw	a5,-308(s2)
80003e0c:	0297a623          	sw	s1,44(a5)
    bcache.head.next = b;
80003e10:	ec992623          	sw	s1,-308(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80003e14:	43848493          	addi	s1,s1,1080
80003e18:	fd349ae3          	bne	s1,s3,80003dec <binit+0x68>
  }
}
80003e1c:	01c12083          	lw	ra,28(sp)
80003e20:	01812403          	lw	s0,24(sp)
80003e24:	01412483          	lw	s1,20(sp)
80003e28:	01012903          	lw	s2,16(sp)
80003e2c:	00c12983          	lw	s3,12(sp)
80003e30:	00812a03          	lw	s4,8(sp)
80003e34:	02010113          	addi	sp,sp,32
80003e38:	00008067          	ret

80003e3c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80003e3c:	fe010113          	addi	sp,sp,-32
80003e40:	00112e23          	sw	ra,28(sp)
80003e44:	00812c23          	sw	s0,24(sp)
80003e48:	00912a23          	sw	s1,20(sp)
80003e4c:	01212823          	sw	s2,16(sp)
80003e50:	01312623          	sw	s3,12(sp)
80003e54:	02010413          	addi	s0,sp,32
80003e58:	00050913          	mv	s2,a0
80003e5c:	00058993          	mv	s3,a1
  acquire(&bcache.lock);
80003e60:	00015517          	auipc	a0,0x15
80003e64:	89050513          	addi	a0,a0,-1904 # 800186f0 <bcache>
80003e68:	ffffd097          	auipc	ra,0xffffd
80003e6c:	08c080e7          	jalr	140(ra) # 80000ef4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80003e70:	0001c497          	auipc	s1,0x1c
80003e74:	74c4a483          	lw	s1,1868(s1) # 800205bc <bcache+0x7ecc>
80003e78:	0001c797          	auipc	a5,0x1c
80003e7c:	71478793          	addi	a5,a5,1812 # 8002058c <bcache+0x7e9c>
80003e80:	04f48863          	beq	s1,a5,80003ed0 <bread+0x94>
80003e84:	00078713          	mv	a4,a5
80003e88:	00c0006f          	j	80003e94 <bread+0x58>
80003e8c:	0304a483          	lw	s1,48(s1)
80003e90:	04e48063          	beq	s1,a4,80003ed0 <bread+0x94>
    if(b->dev == dev && b->blockno == blockno){
80003e94:	0084a783          	lw	a5,8(s1)
80003e98:	fef91ae3          	bne	s2,a5,80003e8c <bread+0x50>
80003e9c:	00c4a783          	lw	a5,12(s1)
80003ea0:	fef996e3          	bne	s3,a5,80003e8c <bread+0x50>
      b->refcnt++;
80003ea4:	0284a783          	lw	a5,40(s1)
80003ea8:	00178793          	addi	a5,a5,1
80003eac:	02f4a423          	sw	a5,40(s1)
      release(&bcache.lock);
80003eb0:	00015517          	auipc	a0,0x15
80003eb4:	84050513          	addi	a0,a0,-1984 # 800186f0 <bcache>
80003eb8:	ffffd097          	auipc	ra,0xffffd
80003ebc:	0b0080e7          	jalr	176(ra) # 80000f68 <release>
      acquiresleep(&b->lock);
80003ec0:	01048513          	addi	a0,s1,16
80003ec4:	00002097          	auipc	ra,0x2
80003ec8:	bd0080e7          	jalr	-1072(ra) # 80005a94 <acquiresleep>
      return b;
80003ecc:	06c0006f          	j	80003f38 <bread+0xfc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80003ed0:	0001c497          	auipc	s1,0x1c
80003ed4:	6e84a483          	lw	s1,1768(s1) # 800205b8 <bcache+0x7ec8>
80003ed8:	0001c797          	auipc	a5,0x1c
80003edc:	6b478793          	addi	a5,a5,1716 # 8002058c <bcache+0x7e9c>
80003ee0:	00f48c63          	beq	s1,a5,80003ef8 <bread+0xbc>
80003ee4:	00078713          	mv	a4,a5
    if(b->refcnt == 0) {
80003ee8:	0284a783          	lw	a5,40(s1)
80003eec:	00078e63          	beqz	a5,80003f08 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80003ef0:	02c4a483          	lw	s1,44(s1)
80003ef4:	fee49ae3          	bne	s1,a4,80003ee8 <bread+0xac>
  panic("bget: no buffers");
80003ef8:	00008517          	auipc	a0,0x8
80003efc:	d4850513          	addi	a0,a0,-696 # 8000bc40 <userret+0x2ba0>
80003f00:	ffffd097          	auipc	ra,0xffffd
80003f04:	800080e7          	jalr	-2048(ra) # 80000700 <panic>
      b->dev = dev;
80003f08:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
80003f0c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
80003f10:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
80003f14:	00100793          	li	a5,1
80003f18:	02f4a423          	sw	a5,40(s1)
      release(&bcache.lock);
80003f1c:	00014517          	auipc	a0,0x14
80003f20:	7d450513          	addi	a0,a0,2004 # 800186f0 <bcache>
80003f24:	ffffd097          	auipc	ra,0xffffd
80003f28:	044080e7          	jalr	68(ra) # 80000f68 <release>
      acquiresleep(&b->lock);
80003f2c:	01048513          	addi	a0,s1,16
80003f30:	00002097          	auipc	ra,0x2
80003f34:	b64080e7          	jalr	-1180(ra) # 80005a94 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
80003f38:	0004a783          	lw	a5,0(s1)
80003f3c:	02078263          	beqz	a5,80003f60 <bread+0x124>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
80003f40:	00048513          	mv	a0,s1
80003f44:	01c12083          	lw	ra,28(sp)
80003f48:	01812403          	lw	s0,24(sp)
80003f4c:	01412483          	lw	s1,20(sp)
80003f50:	01012903          	lw	s2,16(sp)
80003f54:	00c12983          	lw	s3,12(sp)
80003f58:	02010113          	addi	sp,sp,32
80003f5c:	00008067          	ret
    virtio_disk_rw(b, 0);
80003f60:	00000593          	li	a1,0
80003f64:	00048513          	mv	a0,s1
80003f68:	00004097          	auipc	ra,0x4
80003f6c:	194080e7          	jalr	404(ra) # 800080fc <virtio_disk_rw>
    b->valid = 1;
80003f70:	00100793          	li	a5,1
80003f74:	00f4a023          	sw	a5,0(s1)
  return b;
80003f78:	fc9ff06f          	j	80003f40 <bread+0x104>

80003f7c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80003f7c:	ff010113          	addi	sp,sp,-16
80003f80:	00112623          	sw	ra,12(sp)
80003f84:	00812423          	sw	s0,8(sp)
80003f88:	00912223          	sw	s1,4(sp)
80003f8c:	01010413          	addi	s0,sp,16
80003f90:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
80003f94:	01050513          	addi	a0,a0,16
80003f98:	00002097          	auipc	ra,0x2
80003f9c:	be8080e7          	jalr	-1048(ra) # 80005b80 <holdingsleep>
80003fa0:	02050463          	beqz	a0,80003fc8 <bwrite+0x4c>
    panic("bwrite");
  virtio_disk_rw(b, 1);
80003fa4:	00100593          	li	a1,1
80003fa8:	00048513          	mv	a0,s1
80003fac:	00004097          	auipc	ra,0x4
80003fb0:	150080e7          	jalr	336(ra) # 800080fc <virtio_disk_rw>
}
80003fb4:	00c12083          	lw	ra,12(sp)
80003fb8:	00812403          	lw	s0,8(sp)
80003fbc:	00412483          	lw	s1,4(sp)
80003fc0:	01010113          	addi	sp,sp,16
80003fc4:	00008067          	ret
    panic("bwrite");
80003fc8:	00008517          	auipc	a0,0x8
80003fcc:	c8c50513          	addi	a0,a0,-884 # 8000bc54 <userret+0x2bb4>
80003fd0:	ffffc097          	auipc	ra,0xffffc
80003fd4:	730080e7          	jalr	1840(ra) # 80000700 <panic>

80003fd8 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80003fd8:	ff010113          	addi	sp,sp,-16
80003fdc:	00112623          	sw	ra,12(sp)
80003fe0:	00812423          	sw	s0,8(sp)
80003fe4:	00912223          	sw	s1,4(sp)
80003fe8:	01212023          	sw	s2,0(sp)
80003fec:	01010413          	addi	s0,sp,16
80003ff0:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
80003ff4:	01050913          	addi	s2,a0,16
80003ff8:	00090513          	mv	a0,s2
80003ffc:	00002097          	auipc	ra,0x2
80004000:	b84080e7          	jalr	-1148(ra) # 80005b80 <holdingsleep>
80004004:	08050a63          	beqz	a0,80004098 <brelse+0xc0>
    panic("brelse");

  releasesleep(&b->lock);
80004008:	00090513          	mv	a0,s2
8000400c:	00002097          	auipc	ra,0x2
80004010:	b10080e7          	jalr	-1264(ra) # 80005b1c <releasesleep>

  acquire(&bcache.lock);
80004014:	00014517          	auipc	a0,0x14
80004018:	6dc50513          	addi	a0,a0,1756 # 800186f0 <bcache>
8000401c:	ffffd097          	auipc	ra,0xffffd
80004020:	ed8080e7          	jalr	-296(ra) # 80000ef4 <acquire>
  b->refcnt--;
80004024:	0284a783          	lw	a5,40(s1)
80004028:	fff78793          	addi	a5,a5,-1
8000402c:	02f4a423          	sw	a5,40(s1)
  if (b->refcnt == 0) {
80004030:	04079063          	bnez	a5,80004070 <brelse+0x98>
    // no one is waiting for it.
    b->next->prev = b->prev;
80004034:	0304a703          	lw	a4,48(s1)
80004038:	02c4a783          	lw	a5,44(s1)
8000403c:	02f72623          	sw	a5,44(a4)
    b->prev->next = b->next;
80004040:	0304a703          	lw	a4,48(s1)
80004044:	02e7a823          	sw	a4,48(a5)
    b->next = bcache.head.next;
80004048:	0001c797          	auipc	a5,0x1c
8000404c:	6a878793          	addi	a5,a5,1704 # 800206f0 <bcache+0x8000>
80004050:	ecc7a703          	lw	a4,-308(a5)
80004054:	02e4a823          	sw	a4,48(s1)
    b->prev = &bcache.head;
80004058:	0001c717          	auipc	a4,0x1c
8000405c:	53470713          	addi	a4,a4,1332 # 8002058c <bcache+0x7e9c>
80004060:	02e4a623          	sw	a4,44(s1)
    bcache.head.next->prev = b;
80004064:	ecc7a703          	lw	a4,-308(a5)
80004068:	02972623          	sw	s1,44(a4)
    bcache.head.next = b;
8000406c:	ec97a623          	sw	s1,-308(a5)
  }
  
  release(&bcache.lock);
80004070:	00014517          	auipc	a0,0x14
80004074:	68050513          	addi	a0,a0,1664 # 800186f0 <bcache>
80004078:	ffffd097          	auipc	ra,0xffffd
8000407c:	ef0080e7          	jalr	-272(ra) # 80000f68 <release>
}
80004080:	00c12083          	lw	ra,12(sp)
80004084:	00812403          	lw	s0,8(sp)
80004088:	00412483          	lw	s1,4(sp)
8000408c:	00012903          	lw	s2,0(sp)
80004090:	01010113          	addi	sp,sp,16
80004094:	00008067          	ret
    panic("brelse");
80004098:	00008517          	auipc	a0,0x8
8000409c:	bc450513          	addi	a0,a0,-1084 # 8000bc5c <userret+0x2bbc>
800040a0:	ffffc097          	auipc	ra,0xffffc
800040a4:	660080e7          	jalr	1632(ra) # 80000700 <panic>

800040a8 <bpin>:

void
bpin(struct buf *b) {
800040a8:	ff010113          	addi	sp,sp,-16
800040ac:	00112623          	sw	ra,12(sp)
800040b0:	00812423          	sw	s0,8(sp)
800040b4:	00912223          	sw	s1,4(sp)
800040b8:	01010413          	addi	s0,sp,16
800040bc:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
800040c0:	00014517          	auipc	a0,0x14
800040c4:	63050513          	addi	a0,a0,1584 # 800186f0 <bcache>
800040c8:	ffffd097          	auipc	ra,0xffffd
800040cc:	e2c080e7          	jalr	-468(ra) # 80000ef4 <acquire>
  b->refcnt++;
800040d0:	0284a783          	lw	a5,40(s1)
800040d4:	00178793          	addi	a5,a5,1
800040d8:	02f4a423          	sw	a5,40(s1)
  release(&bcache.lock);
800040dc:	00014517          	auipc	a0,0x14
800040e0:	61450513          	addi	a0,a0,1556 # 800186f0 <bcache>
800040e4:	ffffd097          	auipc	ra,0xffffd
800040e8:	e84080e7          	jalr	-380(ra) # 80000f68 <release>
}
800040ec:	00c12083          	lw	ra,12(sp)
800040f0:	00812403          	lw	s0,8(sp)
800040f4:	00412483          	lw	s1,4(sp)
800040f8:	01010113          	addi	sp,sp,16
800040fc:	00008067          	ret

80004100 <bunpin>:

void
bunpin(struct buf *b) {
80004100:	ff010113          	addi	sp,sp,-16
80004104:	00112623          	sw	ra,12(sp)
80004108:	00812423          	sw	s0,8(sp)
8000410c:	00912223          	sw	s1,4(sp)
80004110:	01010413          	addi	s0,sp,16
80004114:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
80004118:	00014517          	auipc	a0,0x14
8000411c:	5d850513          	addi	a0,a0,1496 # 800186f0 <bcache>
80004120:	ffffd097          	auipc	ra,0xffffd
80004124:	dd4080e7          	jalr	-556(ra) # 80000ef4 <acquire>
  b->refcnt--;
80004128:	0284a783          	lw	a5,40(s1)
8000412c:	fff78793          	addi	a5,a5,-1
80004130:	02f4a423          	sw	a5,40(s1)
  release(&bcache.lock);
80004134:	00014517          	auipc	a0,0x14
80004138:	5bc50513          	addi	a0,a0,1468 # 800186f0 <bcache>
8000413c:	ffffd097          	auipc	ra,0xffffd
80004140:	e2c080e7          	jalr	-468(ra) # 80000f68 <release>
}
80004144:	00c12083          	lw	ra,12(sp)
80004148:	00812403          	lw	s0,8(sp)
8000414c:	00412483          	lw	s1,4(sp)
80004150:	01010113          	addi	sp,sp,16
80004154:	00008067          	ret

80004158 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80004158:	ff010113          	addi	sp,sp,-16
8000415c:	00112623          	sw	ra,12(sp)
80004160:	00812423          	sw	s0,8(sp)
80004164:	00912223          	sw	s1,4(sp)
80004168:	01212023          	sw	s2,0(sp)
8000416c:	01010413          	addi	s0,sp,16
80004170:	00058493          	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80004174:	00d5d593          	srli	a1,a1,0xd
80004178:	0001d797          	auipc	a5,0x1d
8000417c:	8687a783          	lw	a5,-1944(a5) # 800209e0 <sb+0x1c>
80004180:	00f585b3          	add	a1,a1,a5
80004184:	00000097          	auipc	ra,0x0
80004188:	cb8080e7          	jalr	-840(ra) # 80003e3c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8000418c:	0074f713          	andi	a4,s1,7
80004190:	00100793          	li	a5,1
80004194:	00e797b3          	sll	a5,a5,a4
  bi = b % BPB;
80004198:	01349493          	slli	s1,s1,0x13
  if((bp->data[bi/8] & m) == 0)
8000419c:	0164d493          	srli	s1,s1,0x16
800041a0:	00950733          	add	a4,a0,s1
800041a4:	03874703          	lbu	a4,56(a4)
800041a8:	00f776b3          	and	a3,a4,a5
800041ac:	04068263          	beqz	a3,800041f0 <bfree+0x98>
800041b0:	00050913          	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
800041b4:	009504b3          	add	s1,a0,s1
800041b8:	fff7c793          	not	a5,a5
800041bc:	00f77733          	and	a4,a4,a5
800041c0:	02e48c23          	sb	a4,56(s1)
  log_write(bp);
800041c4:	00001097          	auipc	ra,0x1
800041c8:	744080e7          	jalr	1860(ra) # 80005908 <log_write>
  brelse(bp);
800041cc:	00090513          	mv	a0,s2
800041d0:	00000097          	auipc	ra,0x0
800041d4:	e08080e7          	jalr	-504(ra) # 80003fd8 <brelse>
}
800041d8:	00c12083          	lw	ra,12(sp)
800041dc:	00812403          	lw	s0,8(sp)
800041e0:	00412483          	lw	s1,4(sp)
800041e4:	00012903          	lw	s2,0(sp)
800041e8:	01010113          	addi	sp,sp,16
800041ec:	00008067          	ret
    panic("freeing free block");
800041f0:	00008517          	auipc	a0,0x8
800041f4:	a7450513          	addi	a0,a0,-1420 # 8000bc64 <userret+0x2bc4>
800041f8:	ffffc097          	auipc	ra,0xffffc
800041fc:	508080e7          	jalr	1288(ra) # 80000700 <panic>

80004200 <balloc>:
{
80004200:	fd010113          	addi	sp,sp,-48
80004204:	02112623          	sw	ra,44(sp)
80004208:	02812423          	sw	s0,40(sp)
8000420c:	02912223          	sw	s1,36(sp)
80004210:	03212023          	sw	s2,32(sp)
80004214:	01312e23          	sw	s3,28(sp)
80004218:	01412c23          	sw	s4,24(sp)
8000421c:	01512a23          	sw	s5,20(sp)
80004220:	01612823          	sw	s6,16(sp)
80004224:	01712623          	sw	s7,12(sp)
80004228:	01812423          	sw	s8,8(sp)
8000422c:	03010413          	addi	s0,sp,48
  for(b = 0; b < sb.size; b += BPB){
80004230:	0001c797          	auipc	a5,0x1c
80004234:	7987a783          	lw	a5,1944(a5) # 800209c8 <sb+0x4>
80004238:	0a078663          	beqz	a5,800042e4 <balloc+0xe4>
8000423c:	00050b93          	mv	s7,a0
80004240:	00000a93          	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
80004244:	000029b7          	lui	s3,0x2
80004248:	fff98c13          	addi	s8,s3,-1 # 1fff <_entry-0x7fffe001>
8000424c:	0001cb17          	auipc	s6,0x1c
80004250:	778b0b13          	addi	s6,s6,1912 # 800209c4 <sb>
      m = 1 << (bi % 8);
80004254:	00100a13          	li	s4,1
80004258:	01c0006f          	j	80004274 <balloc+0x74>
    brelse(bp);
8000425c:	00090513          	mv	a0,s2
80004260:	00000097          	auipc	ra,0x0
80004264:	d78080e7          	jalr	-648(ra) # 80003fd8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80004268:	013a8ab3          	add	s5,s5,s3
8000426c:	004b2783          	lw	a5,4(s6)
80004270:	06fafa63          	bgeu	s5,a5,800042e4 <balloc+0xe4>
    bp = bread(dev, BBLOCK(b, sb));
80004274:	41fad793          	srai	a5,s5,0x1f
80004278:	0187f7b3          	and	a5,a5,s8
8000427c:	015787b3          	add	a5,a5,s5
80004280:	40d7d793          	srai	a5,a5,0xd
80004284:	01cb2583          	lw	a1,28(s6)
80004288:	00b785b3          	add	a1,a5,a1
8000428c:	000b8513          	mv	a0,s7
80004290:	00000097          	auipc	ra,0x0
80004294:	bac080e7          	jalr	-1108(ra) # 80003e3c <bread>
80004298:	00050913          	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8000429c:	004b2503          	lw	a0,4(s6)
800042a0:	000a8493          	mv	s1,s5
800042a4:	00000713          	li	a4,0
800042a8:	faa4fae3          	bgeu	s1,a0,8000425c <balloc+0x5c>
      m = 1 << (bi % 8);
800042ac:	00777693          	andi	a3,a4,7
800042b0:	00da16b3          	sll	a3,s4,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
800042b4:	41f75793          	srai	a5,a4,0x1f
800042b8:	0077f793          	andi	a5,a5,7
800042bc:	00e787b3          	add	a5,a5,a4
800042c0:	4037d793          	srai	a5,a5,0x3
800042c4:	00f90633          	add	a2,s2,a5
800042c8:	03864603          	lbu	a2,56(a2)
800042cc:	00d675b3          	and	a1,a2,a3
800042d0:	02058263          	beqz	a1,800042f4 <balloc+0xf4>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
800042d4:	00170713          	addi	a4,a4,1
800042d8:	00148493          	addi	s1,s1,1
800042dc:	fd3716e3          	bne	a4,s3,800042a8 <balloc+0xa8>
800042e0:	f7dff06f          	j	8000425c <balloc+0x5c>
  panic("balloc: out of blocks");
800042e4:	00008517          	auipc	a0,0x8
800042e8:	99450513          	addi	a0,a0,-1644 # 8000bc78 <userret+0x2bd8>
800042ec:	ffffc097          	auipc	ra,0xffffc
800042f0:	414080e7          	jalr	1044(ra) # 80000700 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
800042f4:	00f907b3          	add	a5,s2,a5
800042f8:	00d66633          	or	a2,a2,a3
800042fc:	02c78c23          	sb	a2,56(a5)
        log_write(bp);
80004300:	00090513          	mv	a0,s2
80004304:	00001097          	auipc	ra,0x1
80004308:	604080e7          	jalr	1540(ra) # 80005908 <log_write>
        brelse(bp);
8000430c:	00090513          	mv	a0,s2
80004310:	00000097          	auipc	ra,0x0
80004314:	cc8080e7          	jalr	-824(ra) # 80003fd8 <brelse>
  bp = bread(dev, bno);
80004318:	00048593          	mv	a1,s1
8000431c:	000b8513          	mv	a0,s7
80004320:	00000097          	auipc	ra,0x0
80004324:	b1c080e7          	jalr	-1252(ra) # 80003e3c <bread>
80004328:	00050913          	mv	s2,a0
  memset(bp->data, 0, BSIZE);
8000432c:	40000613          	li	a2,1024
80004330:	00000593          	li	a1,0
80004334:	03850513          	addi	a0,a0,56
80004338:	ffffd097          	auipc	ra,0xffffd
8000433c:	c90080e7          	jalr	-880(ra) # 80000fc8 <memset>
  log_write(bp);
80004340:	00090513          	mv	a0,s2
80004344:	00001097          	auipc	ra,0x1
80004348:	5c4080e7          	jalr	1476(ra) # 80005908 <log_write>
  brelse(bp);
8000434c:	00090513          	mv	a0,s2
80004350:	00000097          	auipc	ra,0x0
80004354:	c88080e7          	jalr	-888(ra) # 80003fd8 <brelse>
}
80004358:	00048513          	mv	a0,s1
8000435c:	02c12083          	lw	ra,44(sp)
80004360:	02812403          	lw	s0,40(sp)
80004364:	02412483          	lw	s1,36(sp)
80004368:	02012903          	lw	s2,32(sp)
8000436c:	01c12983          	lw	s3,28(sp)
80004370:	01812a03          	lw	s4,24(sp)
80004374:	01412a83          	lw	s5,20(sp)
80004378:	01012b03          	lw	s6,16(sp)
8000437c:	00c12b83          	lw	s7,12(sp)
80004380:	00812c03          	lw	s8,8(sp)
80004384:	03010113          	addi	sp,sp,48
80004388:	00008067          	ret

8000438c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
8000438c:	fe010113          	addi	sp,sp,-32
80004390:	00112e23          	sw	ra,28(sp)
80004394:	00812c23          	sw	s0,24(sp)
80004398:	00912a23          	sw	s1,20(sp)
8000439c:	01212823          	sw	s2,16(sp)
800043a0:	01312623          	sw	s3,12(sp)
800043a4:	02010413          	addi	s0,sp,32
800043a8:	00050913          	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
800043ac:	00b00793          	li	a5,11
800043b0:	06b7f863          	bgeu	a5,a1,80004420 <bmap+0x94>
800043b4:	01412423          	sw	s4,8(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
800043b8:	ff458493          	addi	s1,a1,-12

  if(bn < NINDIRECT){
800043bc:	0ff00793          	li	a5,255
800043c0:	0c97e263          	bltu	a5,s1,80004484 <bmap+0xf8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
800043c4:	06452583          	lw	a1,100(a0)
800043c8:	08058063          	beqz	a1,80004448 <bmap+0xbc>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
800043cc:	00092503          	lw	a0,0(s2)
800043d0:	00000097          	auipc	ra,0x0
800043d4:	a6c080e7          	jalr	-1428(ra) # 80003e3c <bread>
800043d8:	00050a13          	mv	s4,a0
    a = (uint*)bp->data;
800043dc:	03850793          	addi	a5,a0,56
    if((addr = a[bn]) == 0){
800043e0:	00249593          	slli	a1,s1,0x2
800043e4:	00b784b3          	add	s1,a5,a1
800043e8:	0004a983          	lw	s3,0(s1)
800043ec:	06098a63          	beqz	s3,80004460 <bmap+0xd4>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
800043f0:	000a0513          	mv	a0,s4
800043f4:	00000097          	auipc	ra,0x0
800043f8:	be4080e7          	jalr	-1052(ra) # 80003fd8 <brelse>
    return addr;
800043fc:	00812a03          	lw	s4,8(sp)
  }

  panic("bmap: out of range");
}
80004400:	00098513          	mv	a0,s3
80004404:	01c12083          	lw	ra,28(sp)
80004408:	01812403          	lw	s0,24(sp)
8000440c:	01412483          	lw	s1,20(sp)
80004410:	01012903          	lw	s2,16(sp)
80004414:	00c12983          	lw	s3,12(sp)
80004418:	02010113          	addi	sp,sp,32
8000441c:	00008067          	ret
    if((addr = ip->addrs[bn]) == 0)
80004420:	00259593          	slli	a1,a1,0x2
80004424:	00b504b3          	add	s1,a0,a1
80004428:	0344a983          	lw	s3,52(s1)
8000442c:	fc099ae3          	bnez	s3,80004400 <bmap+0x74>
      ip->addrs[bn] = addr = balloc(ip->dev);
80004430:	00052503          	lw	a0,0(a0)
80004434:	00000097          	auipc	ra,0x0
80004438:	dcc080e7          	jalr	-564(ra) # 80004200 <balloc>
8000443c:	00050993          	mv	s3,a0
80004440:	02a4aa23          	sw	a0,52(s1)
80004444:	fbdff06f          	j	80004400 <bmap+0x74>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80004448:	00052503          	lw	a0,0(a0)
8000444c:	00000097          	auipc	ra,0x0
80004450:	db4080e7          	jalr	-588(ra) # 80004200 <balloc>
80004454:	00050593          	mv	a1,a0
80004458:	06a92223          	sw	a0,100(s2)
8000445c:	f71ff06f          	j	800043cc <bmap+0x40>
      a[bn] = addr = balloc(ip->dev);
80004460:	00092503          	lw	a0,0(s2)
80004464:	00000097          	auipc	ra,0x0
80004468:	d9c080e7          	jalr	-612(ra) # 80004200 <balloc>
8000446c:	00050993          	mv	s3,a0
80004470:	00a4a023          	sw	a0,0(s1)
      log_write(bp);
80004474:	000a0513          	mv	a0,s4
80004478:	00001097          	auipc	ra,0x1
8000447c:	490080e7          	jalr	1168(ra) # 80005908 <log_write>
80004480:	f71ff06f          	j	800043f0 <bmap+0x64>
  panic("bmap: out of range");
80004484:	00008517          	auipc	a0,0x8
80004488:	80c50513          	addi	a0,a0,-2036 # 8000bc90 <userret+0x2bf0>
8000448c:	ffffc097          	auipc	ra,0xffffc
80004490:	274080e7          	jalr	628(ra) # 80000700 <panic>

80004494 <iget>:
{
80004494:	fe010113          	addi	sp,sp,-32
80004498:	00112e23          	sw	ra,28(sp)
8000449c:	00812c23          	sw	s0,24(sp)
800044a0:	00912a23          	sw	s1,20(sp)
800044a4:	01212823          	sw	s2,16(sp)
800044a8:	01312623          	sw	s3,12(sp)
800044ac:	01412423          	sw	s4,8(sp)
800044b0:	02010413          	addi	s0,sp,32
800044b4:	00050993          	mv	s3,a0
800044b8:	00058a13          	mv	s4,a1
  acquire(&icache.lock);
800044bc:	0001c517          	auipc	a0,0x1c
800044c0:	52850513          	addi	a0,a0,1320 # 800209e4 <icache>
800044c4:	ffffd097          	auipc	ra,0xffffd
800044c8:	a30080e7          	jalr	-1488(ra) # 80000ef4 <acquire>
  empty = 0;
800044cc:	00000913          	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
800044d0:	0001c497          	auipc	s1,0x1c
800044d4:	52048493          	addi	s1,s1,1312 # 800209f0 <icache+0xc>
800044d8:	0001e697          	auipc	a3,0x1e
800044dc:	96868693          	addi	a3,a3,-1688 # 80021e40 <log>
800044e0:	0100006f          	j	800044f0 <iget+0x5c>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
800044e4:	04090263          	beqz	s2,80004528 <iget+0x94>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
800044e8:	06848493          	addi	s1,s1,104
800044ec:	04d48463          	beq	s1,a3,80004534 <iget+0xa0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
800044f0:	0084a783          	lw	a5,8(s1)
800044f4:	fef058e3          	blez	a5,800044e4 <iget+0x50>
800044f8:	0004a703          	lw	a4,0(s1)
800044fc:	ff3714e3          	bne	a4,s3,800044e4 <iget+0x50>
80004500:	0044a703          	lw	a4,4(s1)
80004504:	ff4710e3          	bne	a4,s4,800044e4 <iget+0x50>
      ip->ref++;
80004508:	00178793          	addi	a5,a5,1
8000450c:	00f4a423          	sw	a5,8(s1)
      release(&icache.lock);
80004510:	0001c517          	auipc	a0,0x1c
80004514:	4d450513          	addi	a0,a0,1236 # 800209e4 <icache>
80004518:	ffffd097          	auipc	ra,0xffffd
8000451c:	a50080e7          	jalr	-1456(ra) # 80000f68 <release>
      return ip;
80004520:	00048913          	mv	s2,s1
80004524:	0380006f          	j	8000455c <iget+0xc8>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80004528:	fc0790e3          	bnez	a5,800044e8 <iget+0x54>
      empty = ip;
8000452c:	00048913          	mv	s2,s1
80004530:	fb9ff06f          	j	800044e8 <iget+0x54>
  if(empty == 0)
80004534:	04090663          	beqz	s2,80004580 <iget+0xec>
  ip->dev = dev;
80004538:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
8000453c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
80004540:	00100793          	li	a5,1
80004544:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
80004548:	02092223          	sw	zero,36(s2)
  release(&icache.lock);
8000454c:	0001c517          	auipc	a0,0x1c
80004550:	49850513          	addi	a0,a0,1176 # 800209e4 <icache>
80004554:	ffffd097          	auipc	ra,0xffffd
80004558:	a14080e7          	jalr	-1516(ra) # 80000f68 <release>
}
8000455c:	00090513          	mv	a0,s2
80004560:	01c12083          	lw	ra,28(sp)
80004564:	01812403          	lw	s0,24(sp)
80004568:	01412483          	lw	s1,20(sp)
8000456c:	01012903          	lw	s2,16(sp)
80004570:	00c12983          	lw	s3,12(sp)
80004574:	00812a03          	lw	s4,8(sp)
80004578:	02010113          	addi	sp,sp,32
8000457c:	00008067          	ret
    panic("iget: no inodes");
80004580:	00007517          	auipc	a0,0x7
80004584:	72450513          	addi	a0,a0,1828 # 8000bca4 <userret+0x2c04>
80004588:	ffffc097          	auipc	ra,0xffffc
8000458c:	178080e7          	jalr	376(ra) # 80000700 <panic>

80004590 <fsinit>:
fsinit(int dev) {
80004590:	fe010113          	addi	sp,sp,-32
80004594:	00112e23          	sw	ra,28(sp)
80004598:	00812c23          	sw	s0,24(sp)
8000459c:	00912a23          	sw	s1,20(sp)
800045a0:	01212823          	sw	s2,16(sp)
800045a4:	01312623          	sw	s3,12(sp)
800045a8:	02010413          	addi	s0,sp,32
800045ac:	00050913          	mv	s2,a0
  bp = bread(dev, 1);
800045b0:	00100593          	li	a1,1
800045b4:	00000097          	auipc	ra,0x0
800045b8:	888080e7          	jalr	-1912(ra) # 80003e3c <bread>
800045bc:	00050493          	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
800045c0:	0001c997          	auipc	s3,0x1c
800045c4:	40498993          	addi	s3,s3,1028 # 800209c4 <sb>
800045c8:	02000613          	li	a2,32
800045cc:	03850593          	addi	a1,a0,56
800045d0:	00098513          	mv	a0,s3
800045d4:	ffffd097          	auipc	ra,0xffffd
800045d8:	a80080e7          	jalr	-1408(ra) # 80001054 <memmove>
  brelse(bp);
800045dc:	00048513          	mv	a0,s1
800045e0:	00000097          	auipc	ra,0x0
800045e4:	9f8080e7          	jalr	-1544(ra) # 80003fd8 <brelse>
  if(sb.magic != FSMAGIC)
800045e8:	0009a703          	lw	a4,0(s3)
800045ec:	102037b7          	lui	a5,0x10203
800045f0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
800045f4:	02f71a63          	bne	a4,a5,80004628 <fsinit+0x98>
  initlog(dev, &sb);
800045f8:	0001c597          	auipc	a1,0x1c
800045fc:	3cc58593          	addi	a1,a1,972 # 800209c4 <sb>
80004600:	00090513          	mv	a0,s2
80004604:	00001097          	auipc	ra,0x1
80004608:	fc0080e7          	jalr	-64(ra) # 800055c4 <initlog>
}
8000460c:	01c12083          	lw	ra,28(sp)
80004610:	01812403          	lw	s0,24(sp)
80004614:	01412483          	lw	s1,20(sp)
80004618:	01012903          	lw	s2,16(sp)
8000461c:	00c12983          	lw	s3,12(sp)
80004620:	02010113          	addi	sp,sp,32
80004624:	00008067          	ret
    panic("invalid file system");
80004628:	00007517          	auipc	a0,0x7
8000462c:	68c50513          	addi	a0,a0,1676 # 8000bcb4 <userret+0x2c14>
80004630:	ffffc097          	auipc	ra,0xffffc
80004634:	0d0080e7          	jalr	208(ra) # 80000700 <panic>

80004638 <iinit>:
{
80004638:	fe010113          	addi	sp,sp,-32
8000463c:	00112e23          	sw	ra,28(sp)
80004640:	00812c23          	sw	s0,24(sp)
80004644:	00912a23          	sw	s1,20(sp)
80004648:	01212823          	sw	s2,16(sp)
8000464c:	01312623          	sw	s3,12(sp)
80004650:	02010413          	addi	s0,sp,32
  initlock(&icache.lock, "icache");
80004654:	00007597          	auipc	a1,0x7
80004658:	67458593          	addi	a1,a1,1652 # 8000bcc8 <userret+0x2c28>
8000465c:	0001c517          	auipc	a0,0x1c
80004660:	38850513          	addi	a0,a0,904 # 800209e4 <icache>
80004664:	ffffc097          	auipc	ra,0xffffc
80004668:	704080e7          	jalr	1796(ra) # 80000d68 <initlock>
  for(i = 0; i < NINODE; i++) {
8000466c:	0001c497          	auipc	s1,0x1c
80004670:	39048493          	addi	s1,s1,912 # 800209fc <icache+0x18>
80004674:	0001d997          	auipc	s3,0x1d
80004678:	7d898993          	addi	s3,s3,2008 # 80021e4c <log+0xc>
    initsleeplock(&icache.inode[i].lock, "inode");
8000467c:	00007917          	auipc	s2,0x7
80004680:	65490913          	addi	s2,s2,1620 # 8000bcd0 <userret+0x2c30>
80004684:	00090593          	mv	a1,s2
80004688:	00048513          	mv	a0,s1
8000468c:	00001097          	auipc	ra,0x1
80004690:	3b0080e7          	jalr	944(ra) # 80005a3c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80004694:	06848493          	addi	s1,s1,104
80004698:	ff3496e3          	bne	s1,s3,80004684 <iinit+0x4c>
}
8000469c:	01c12083          	lw	ra,28(sp)
800046a0:	01812403          	lw	s0,24(sp)
800046a4:	01412483          	lw	s1,20(sp)
800046a8:	01012903          	lw	s2,16(sp)
800046ac:	00c12983          	lw	s3,12(sp)
800046b0:	02010113          	addi	sp,sp,32
800046b4:	00008067          	ret

800046b8 <ialloc>:
{
800046b8:	fe010113          	addi	sp,sp,-32
800046bc:	00112e23          	sw	ra,28(sp)
800046c0:	00812c23          	sw	s0,24(sp)
800046c4:	00912a23          	sw	s1,20(sp)
800046c8:	01212823          	sw	s2,16(sp)
800046cc:	01312623          	sw	s3,12(sp)
800046d0:	01412423          	sw	s4,8(sp)
800046d4:	01512223          	sw	s5,4(sp)
800046d8:	01612023          	sw	s6,0(sp)
800046dc:	02010413          	addi	s0,sp,32
  for(inum = 1; inum < sb.ninodes; inum++){
800046e0:	0001c717          	auipc	a4,0x1c
800046e4:	2f072703          	lw	a4,752(a4) # 800209d0 <sb+0xc>
800046e8:	00100793          	li	a5,1
800046ec:	06e7f063          	bgeu	a5,a4,8000474c <ialloc+0x94>
800046f0:	00050a93          	mv	s5,a0
800046f4:	00058b13          	mv	s6,a1
800046f8:	00078913          	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
800046fc:	0001ca17          	auipc	s4,0x1c
80004700:	2c8a0a13          	addi	s4,s4,712 # 800209c4 <sb>
80004704:	00495593          	srli	a1,s2,0x4
80004708:	018a2783          	lw	a5,24(s4)
8000470c:	00f585b3          	add	a1,a1,a5
80004710:	000a8513          	mv	a0,s5
80004714:	fffff097          	auipc	ra,0xfffff
80004718:	728080e7          	jalr	1832(ra) # 80003e3c <bread>
8000471c:	00050493          	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
80004720:	03850993          	addi	s3,a0,56
80004724:	00f97793          	andi	a5,s2,15
80004728:	00679793          	slli	a5,a5,0x6
8000472c:	00f989b3          	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
80004730:	00099783          	lh	a5,0(s3)
80004734:	02078463          	beqz	a5,8000475c <ialloc+0xa4>
    brelse(bp);
80004738:	00000097          	auipc	ra,0x0
8000473c:	8a0080e7          	jalr	-1888(ra) # 80003fd8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80004740:	00190913          	addi	s2,s2,1
80004744:	00ca2783          	lw	a5,12(s4)
80004748:	faf96ee3          	bltu	s2,a5,80004704 <ialloc+0x4c>
  panic("ialloc: no inodes");
8000474c:	00007517          	auipc	a0,0x7
80004750:	58c50513          	addi	a0,a0,1420 # 8000bcd8 <userret+0x2c38>
80004754:	ffffc097          	auipc	ra,0xffffc
80004758:	fac080e7          	jalr	-84(ra) # 80000700 <panic>
      memset(dip, 0, sizeof(*dip));
8000475c:	04000613          	li	a2,64
80004760:	00000593          	li	a1,0
80004764:	00098513          	mv	a0,s3
80004768:	ffffd097          	auipc	ra,0xffffd
8000476c:	860080e7          	jalr	-1952(ra) # 80000fc8 <memset>
      dip->type = type;
80004770:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
80004774:	00048513          	mv	a0,s1
80004778:	00001097          	auipc	ra,0x1
8000477c:	190080e7          	jalr	400(ra) # 80005908 <log_write>
      brelse(bp);
80004780:	00048513          	mv	a0,s1
80004784:	00000097          	auipc	ra,0x0
80004788:	854080e7          	jalr	-1964(ra) # 80003fd8 <brelse>
      return iget(dev, inum);
8000478c:	00090593          	mv	a1,s2
80004790:	000a8513          	mv	a0,s5
80004794:	00000097          	auipc	ra,0x0
80004798:	d00080e7          	jalr	-768(ra) # 80004494 <iget>
}
8000479c:	01c12083          	lw	ra,28(sp)
800047a0:	01812403          	lw	s0,24(sp)
800047a4:	01412483          	lw	s1,20(sp)
800047a8:	01012903          	lw	s2,16(sp)
800047ac:	00c12983          	lw	s3,12(sp)
800047b0:	00812a03          	lw	s4,8(sp)
800047b4:	00412a83          	lw	s5,4(sp)
800047b8:	00012b03          	lw	s6,0(sp)
800047bc:	02010113          	addi	sp,sp,32
800047c0:	00008067          	ret

800047c4 <iupdate>:
{
800047c4:	ff010113          	addi	sp,sp,-16
800047c8:	00112623          	sw	ra,12(sp)
800047cc:	00812423          	sw	s0,8(sp)
800047d0:	00912223          	sw	s1,4(sp)
800047d4:	01212023          	sw	s2,0(sp)
800047d8:	01010413          	addi	s0,sp,16
800047dc:	00050493          	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
800047e0:	00452783          	lw	a5,4(a0)
800047e4:	0047d793          	srli	a5,a5,0x4
800047e8:	0001c597          	auipc	a1,0x1c
800047ec:	1f45a583          	lw	a1,500(a1) # 800209dc <sb+0x18>
800047f0:	00b785b3          	add	a1,a5,a1
800047f4:	00052503          	lw	a0,0(a0)
800047f8:	fffff097          	auipc	ra,0xfffff
800047fc:	644080e7          	jalr	1604(ra) # 80003e3c <bread>
80004800:	00050913          	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80004804:	03850793          	addi	a5,a0,56
80004808:	0044a703          	lw	a4,4(s1)
8000480c:	00f77713          	andi	a4,a4,15
80004810:	00671713          	slli	a4,a4,0x6
80004814:	00e787b3          	add	a5,a5,a4
  dip->type = ip->type;
80004818:	02849703          	lh	a4,40(s1)
8000481c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
80004820:	02a49703          	lh	a4,42(s1)
80004824:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
80004828:	02c49703          	lh	a4,44(s1)
8000482c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
80004830:	02e49703          	lh	a4,46(s1)
80004834:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
80004838:	0304a703          	lw	a4,48(s1)
8000483c:	00e7a423          	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80004840:	03400613          	li	a2,52
80004844:	00c485b3          	add	a1,s1,a2
80004848:	00c78513          	addi	a0,a5,12
8000484c:	ffffd097          	auipc	ra,0xffffd
80004850:	808080e7          	jalr	-2040(ra) # 80001054 <memmove>
  log_write(bp);
80004854:	00090513          	mv	a0,s2
80004858:	00001097          	auipc	ra,0x1
8000485c:	0b0080e7          	jalr	176(ra) # 80005908 <log_write>
  brelse(bp);
80004860:	00090513          	mv	a0,s2
80004864:	fffff097          	auipc	ra,0xfffff
80004868:	774080e7          	jalr	1908(ra) # 80003fd8 <brelse>
}
8000486c:	00c12083          	lw	ra,12(sp)
80004870:	00812403          	lw	s0,8(sp)
80004874:	00412483          	lw	s1,4(sp)
80004878:	00012903          	lw	s2,0(sp)
8000487c:	01010113          	addi	sp,sp,16
80004880:	00008067          	ret

80004884 <idup>:
{
80004884:	ff010113          	addi	sp,sp,-16
80004888:	00112623          	sw	ra,12(sp)
8000488c:	00812423          	sw	s0,8(sp)
80004890:	00912223          	sw	s1,4(sp)
80004894:	01010413          	addi	s0,sp,16
80004898:	00050493          	mv	s1,a0
  acquire(&icache.lock);
8000489c:	0001c517          	auipc	a0,0x1c
800048a0:	14850513          	addi	a0,a0,328 # 800209e4 <icache>
800048a4:	ffffc097          	auipc	ra,0xffffc
800048a8:	650080e7          	jalr	1616(ra) # 80000ef4 <acquire>
  ip->ref++;
800048ac:	0084a783          	lw	a5,8(s1)
800048b0:	00178793          	addi	a5,a5,1
800048b4:	00f4a423          	sw	a5,8(s1)
  release(&icache.lock);
800048b8:	0001c517          	auipc	a0,0x1c
800048bc:	12c50513          	addi	a0,a0,300 # 800209e4 <icache>
800048c0:	ffffc097          	auipc	ra,0xffffc
800048c4:	6a8080e7          	jalr	1704(ra) # 80000f68 <release>
}
800048c8:	00048513          	mv	a0,s1
800048cc:	00c12083          	lw	ra,12(sp)
800048d0:	00812403          	lw	s0,8(sp)
800048d4:	00412483          	lw	s1,4(sp)
800048d8:	01010113          	addi	sp,sp,16
800048dc:	00008067          	ret

800048e0 <ilock>:
{
800048e0:	ff010113          	addi	sp,sp,-16
800048e4:	00112623          	sw	ra,12(sp)
800048e8:	00812423          	sw	s0,8(sp)
800048ec:	00912223          	sw	s1,4(sp)
800048f0:	01010413          	addi	s0,sp,16
  if(ip == 0 || ip->ref < 1)
800048f4:	02050c63          	beqz	a0,8000492c <ilock+0x4c>
800048f8:	00050493          	mv	s1,a0
800048fc:	00852783          	lw	a5,8(a0)
80004900:	02f05663          	blez	a5,8000492c <ilock+0x4c>
  acquiresleep(&ip->lock);
80004904:	00c50513          	addi	a0,a0,12
80004908:	00001097          	auipc	ra,0x1
8000490c:	18c080e7          	jalr	396(ra) # 80005a94 <acquiresleep>
  if(ip->valid == 0){
80004910:	0244a783          	lw	a5,36(s1)
80004914:	02078663          	beqz	a5,80004940 <ilock+0x60>
}
80004918:	00c12083          	lw	ra,12(sp)
8000491c:	00812403          	lw	s0,8(sp)
80004920:	00412483          	lw	s1,4(sp)
80004924:	01010113          	addi	sp,sp,16
80004928:	00008067          	ret
8000492c:	01212023          	sw	s2,0(sp)
    panic("ilock");
80004930:	00007517          	auipc	a0,0x7
80004934:	3bc50513          	addi	a0,a0,956 # 8000bcec <userret+0x2c4c>
80004938:	ffffc097          	auipc	ra,0xffffc
8000493c:	dc8080e7          	jalr	-568(ra) # 80000700 <panic>
80004940:	01212023          	sw	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80004944:	0044a783          	lw	a5,4(s1)
80004948:	0047d793          	srli	a5,a5,0x4
8000494c:	0001c597          	auipc	a1,0x1c
80004950:	0905a583          	lw	a1,144(a1) # 800209dc <sb+0x18>
80004954:	00b785b3          	add	a1,a5,a1
80004958:	0004a503          	lw	a0,0(s1)
8000495c:	fffff097          	auipc	ra,0xfffff
80004960:	4e0080e7          	jalr	1248(ra) # 80003e3c <bread>
80004964:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80004968:	03850593          	addi	a1,a0,56
8000496c:	0044a783          	lw	a5,4(s1)
80004970:	00f7f793          	andi	a5,a5,15
80004974:	00679793          	slli	a5,a5,0x6
80004978:	00f585b3          	add	a1,a1,a5
    ip->type = dip->type;
8000497c:	00059783          	lh	a5,0(a1)
80004980:	02f49423          	sh	a5,40(s1)
    ip->major = dip->major;
80004984:	00259783          	lh	a5,2(a1)
80004988:	02f49523          	sh	a5,42(s1)
    ip->minor = dip->minor;
8000498c:	00459783          	lh	a5,4(a1)
80004990:	02f49623          	sh	a5,44(s1)
    ip->nlink = dip->nlink;
80004994:	00659783          	lh	a5,6(a1)
80004998:	02f49723          	sh	a5,46(s1)
    ip->size = dip->size;
8000499c:	0085a783          	lw	a5,8(a1)
800049a0:	02f4a823          	sw	a5,48(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
800049a4:	03400613          	li	a2,52
800049a8:	00c58593          	addi	a1,a1,12
800049ac:	00c48533          	add	a0,s1,a2
800049b0:	ffffc097          	auipc	ra,0xffffc
800049b4:	6a4080e7          	jalr	1700(ra) # 80001054 <memmove>
    brelse(bp);
800049b8:	00090513          	mv	a0,s2
800049bc:	fffff097          	auipc	ra,0xfffff
800049c0:	61c080e7          	jalr	1564(ra) # 80003fd8 <brelse>
    ip->valid = 1;
800049c4:	00100793          	li	a5,1
800049c8:	02f4a223          	sw	a5,36(s1)
    if(ip->type == 0)
800049cc:	02849783          	lh	a5,40(s1)
800049d0:	00078663          	beqz	a5,800049dc <ilock+0xfc>
800049d4:	00012903          	lw	s2,0(sp)
800049d8:	f41ff06f          	j	80004918 <ilock+0x38>
      panic("ilock: no type");
800049dc:	00007517          	auipc	a0,0x7
800049e0:	31850513          	addi	a0,a0,792 # 8000bcf4 <userret+0x2c54>
800049e4:	ffffc097          	auipc	ra,0xffffc
800049e8:	d1c080e7          	jalr	-740(ra) # 80000700 <panic>

800049ec <iunlock>:
{
800049ec:	ff010113          	addi	sp,sp,-16
800049f0:	00112623          	sw	ra,12(sp)
800049f4:	00812423          	sw	s0,8(sp)
800049f8:	00912223          	sw	s1,4(sp)
800049fc:	01212023          	sw	s2,0(sp)
80004a00:	01010413          	addi	s0,sp,16
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80004a04:	04050463          	beqz	a0,80004a4c <iunlock+0x60>
80004a08:	00050493          	mv	s1,a0
80004a0c:	00c50913          	addi	s2,a0,12
80004a10:	00090513          	mv	a0,s2
80004a14:	00001097          	auipc	ra,0x1
80004a18:	16c080e7          	jalr	364(ra) # 80005b80 <holdingsleep>
80004a1c:	02050863          	beqz	a0,80004a4c <iunlock+0x60>
80004a20:	0084a783          	lw	a5,8(s1)
80004a24:	02f05463          	blez	a5,80004a4c <iunlock+0x60>
  releasesleep(&ip->lock);
80004a28:	00090513          	mv	a0,s2
80004a2c:	00001097          	auipc	ra,0x1
80004a30:	0f0080e7          	jalr	240(ra) # 80005b1c <releasesleep>
}
80004a34:	00c12083          	lw	ra,12(sp)
80004a38:	00812403          	lw	s0,8(sp)
80004a3c:	00412483          	lw	s1,4(sp)
80004a40:	00012903          	lw	s2,0(sp)
80004a44:	01010113          	addi	sp,sp,16
80004a48:	00008067          	ret
    panic("iunlock");
80004a4c:	00007517          	auipc	a0,0x7
80004a50:	2b850513          	addi	a0,a0,696 # 8000bd04 <userret+0x2c64>
80004a54:	ffffc097          	auipc	ra,0xffffc
80004a58:	cac080e7          	jalr	-852(ra) # 80000700 <panic>

80004a5c <iput>:
{
80004a5c:	fe010113          	addi	sp,sp,-32
80004a60:	00112e23          	sw	ra,28(sp)
80004a64:	00812c23          	sw	s0,24(sp)
80004a68:	00912a23          	sw	s1,20(sp)
80004a6c:	02010413          	addi	s0,sp,32
80004a70:	00050493          	mv	s1,a0
  acquire(&icache.lock);
80004a74:	0001c517          	auipc	a0,0x1c
80004a78:	f7050513          	addi	a0,a0,-144 # 800209e4 <icache>
80004a7c:	ffffc097          	auipc	ra,0xffffc
80004a80:	478080e7          	jalr	1144(ra) # 80000ef4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
80004a84:	0084a703          	lw	a4,8(s1)
80004a88:	00100793          	li	a5,1
80004a8c:	02f70a63          	beq	a4,a5,80004ac0 <iput+0x64>
  ip->ref--;
80004a90:	0084a783          	lw	a5,8(s1)
80004a94:	fff78793          	addi	a5,a5,-1
80004a98:	00f4a423          	sw	a5,8(s1)
  release(&icache.lock);
80004a9c:	0001c517          	auipc	a0,0x1c
80004aa0:	f4850513          	addi	a0,a0,-184 # 800209e4 <icache>
80004aa4:	ffffc097          	auipc	ra,0xffffc
80004aa8:	4c4080e7          	jalr	1220(ra) # 80000f68 <release>
}
80004aac:	01c12083          	lw	ra,28(sp)
80004ab0:	01812403          	lw	s0,24(sp)
80004ab4:	01412483          	lw	s1,20(sp)
80004ab8:	02010113          	addi	sp,sp,32
80004abc:	00008067          	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
80004ac0:	0244a783          	lw	a5,36(s1)
80004ac4:	fc0786e3          	beqz	a5,80004a90 <iput+0x34>
80004ac8:	02e49783          	lh	a5,46(s1)
80004acc:	fc0792e3          	bnez	a5,80004a90 <iput+0x34>
80004ad0:	01212823          	sw	s2,16(sp)
80004ad4:	01312623          	sw	s3,12(sp)
80004ad8:	01412423          	sw	s4,8(sp)
    acquiresleep(&ip->lock);
80004adc:	00c48a13          	addi	s4,s1,12
80004ae0:	000a0513          	mv	a0,s4
80004ae4:	00001097          	auipc	ra,0x1
80004ae8:	fb0080e7          	jalr	-80(ra) # 80005a94 <acquiresleep>
    release(&icache.lock);
80004aec:	0001c517          	auipc	a0,0x1c
80004af0:	ef850513          	addi	a0,a0,-264 # 800209e4 <icache>
80004af4:	ffffc097          	auipc	ra,0xffffc
80004af8:	474080e7          	jalr	1140(ra) # 80000f68 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80004afc:	03448913          	addi	s2,s1,52
80004b00:	06448993          	addi	s3,s1,100
80004b04:	00c0006f          	j	80004b10 <iput+0xb4>
80004b08:	00490913          	addi	s2,s2,4
80004b0c:	03390063          	beq	s2,s3,80004b2c <iput+0xd0>
    if(ip->addrs[i]){
80004b10:	00092583          	lw	a1,0(s2)
80004b14:	fe058ae3          	beqz	a1,80004b08 <iput+0xac>
      bfree(ip->dev, ip->addrs[i]);
80004b18:	0004a503          	lw	a0,0(s1)
80004b1c:	fffff097          	auipc	ra,0xfffff
80004b20:	63c080e7          	jalr	1596(ra) # 80004158 <bfree>
      ip->addrs[i] = 0;
80004b24:	00092023          	sw	zero,0(s2)
80004b28:	fe1ff06f          	j	80004b08 <iput+0xac>
    }
  }

  if(ip->addrs[NDIRECT]){
80004b2c:	0644a583          	lw	a1,100(s1)
80004b30:	04059a63          	bnez	a1,80004b84 <iput+0x128>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80004b34:	0204a823          	sw	zero,48(s1)
  iupdate(ip);
80004b38:	00048513          	mv	a0,s1
80004b3c:	00000097          	auipc	ra,0x0
80004b40:	c88080e7          	jalr	-888(ra) # 800047c4 <iupdate>
    ip->type = 0;
80004b44:	02049423          	sh	zero,40(s1)
    iupdate(ip);
80004b48:	00048513          	mv	a0,s1
80004b4c:	00000097          	auipc	ra,0x0
80004b50:	c78080e7          	jalr	-904(ra) # 800047c4 <iupdate>
    ip->valid = 0;
80004b54:	0204a223          	sw	zero,36(s1)
    releasesleep(&ip->lock);
80004b58:	000a0513          	mv	a0,s4
80004b5c:	00001097          	auipc	ra,0x1
80004b60:	fc0080e7          	jalr	-64(ra) # 80005b1c <releasesleep>
    acquire(&icache.lock);
80004b64:	0001c517          	auipc	a0,0x1c
80004b68:	e8050513          	addi	a0,a0,-384 # 800209e4 <icache>
80004b6c:	ffffc097          	auipc	ra,0xffffc
80004b70:	388080e7          	jalr	904(ra) # 80000ef4 <acquire>
80004b74:	01012903          	lw	s2,16(sp)
80004b78:	00c12983          	lw	s3,12(sp)
80004b7c:	00812a03          	lw	s4,8(sp)
80004b80:	f11ff06f          	j	80004a90 <iput+0x34>
80004b84:	01512223          	sw	s5,4(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80004b88:	0004a503          	lw	a0,0(s1)
80004b8c:	fffff097          	auipc	ra,0xfffff
80004b90:	2b0080e7          	jalr	688(ra) # 80003e3c <bread>
80004b94:	00050a93          	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
80004b98:	03850913          	addi	s2,a0,56
80004b9c:	43850993          	addi	s3,a0,1080
80004ba0:	0180006f          	j	80004bb8 <iput+0x15c>
        bfree(ip->dev, a[j]);
80004ba4:	0004a503          	lw	a0,0(s1)
80004ba8:	fffff097          	auipc	ra,0xfffff
80004bac:	5b0080e7          	jalr	1456(ra) # 80004158 <bfree>
    for(j = 0; j < NINDIRECT; j++){
80004bb0:	00490913          	addi	s2,s2,4
80004bb4:	01390863          	beq	s2,s3,80004bc4 <iput+0x168>
      if(a[j])
80004bb8:	00092583          	lw	a1,0(s2)
80004bbc:	fe058ae3          	beqz	a1,80004bb0 <iput+0x154>
80004bc0:	fe5ff06f          	j	80004ba4 <iput+0x148>
    brelse(bp);
80004bc4:	000a8513          	mv	a0,s5
80004bc8:	fffff097          	auipc	ra,0xfffff
80004bcc:	410080e7          	jalr	1040(ra) # 80003fd8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80004bd0:	0644a583          	lw	a1,100(s1)
80004bd4:	0004a503          	lw	a0,0(s1)
80004bd8:	fffff097          	auipc	ra,0xfffff
80004bdc:	580080e7          	jalr	1408(ra) # 80004158 <bfree>
    ip->addrs[NDIRECT] = 0;
80004be0:	0604a223          	sw	zero,100(s1)
80004be4:	00412a83          	lw	s5,4(sp)
80004be8:	f4dff06f          	j	80004b34 <iput+0xd8>

80004bec <iunlockput>:
{
80004bec:	ff010113          	addi	sp,sp,-16
80004bf0:	00112623          	sw	ra,12(sp)
80004bf4:	00812423          	sw	s0,8(sp)
80004bf8:	00912223          	sw	s1,4(sp)
80004bfc:	01010413          	addi	s0,sp,16
80004c00:	00050493          	mv	s1,a0
  iunlock(ip);
80004c04:	00000097          	auipc	ra,0x0
80004c08:	de8080e7          	jalr	-536(ra) # 800049ec <iunlock>
  iput(ip);
80004c0c:	00048513          	mv	a0,s1
80004c10:	00000097          	auipc	ra,0x0
80004c14:	e4c080e7          	jalr	-436(ra) # 80004a5c <iput>
}
80004c18:	00c12083          	lw	ra,12(sp)
80004c1c:	00812403          	lw	s0,8(sp)
80004c20:	00412483          	lw	s1,4(sp)
80004c24:	01010113          	addi	sp,sp,16
80004c28:	00008067          	ret

80004c2c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80004c2c:	ff010113          	addi	sp,sp,-16
80004c30:	00112623          	sw	ra,12(sp)
80004c34:	00812423          	sw	s0,8(sp)
80004c38:	01010413          	addi	s0,sp,16
  st->dev = ip->dev;
80004c3c:	00052783          	lw	a5,0(a0)
80004c40:	00f5a023          	sw	a5,0(a1)
  st->ino = ip->inum;
80004c44:	00452783          	lw	a5,4(a0)
80004c48:	00f5a223          	sw	a5,4(a1)
  st->type = ip->type;
80004c4c:	02851783          	lh	a5,40(a0)
80004c50:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
80004c54:	02e51783          	lh	a5,46(a0)
80004c58:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
80004c5c:	03052783          	lw	a5,48(a0)
80004c60:	00f5a823          	sw	a5,16(a1)
80004c64:	0005aa23          	sw	zero,20(a1)
}
80004c68:	00c12083          	lw	ra,12(sp)
80004c6c:	00812403          	lw	s0,8(sp)
80004c70:	01010113          	addi	sp,sp,16
80004c74:	00008067          	ret

80004c78 <readi>:
readi(struct inode *ip, int user_dst, uint32 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
80004c78:	03052783          	lw	a5,48(a0)
80004c7c:	14d7e863          	bltu	a5,a3,80004dcc <readi+0x154>
{
80004c80:	fd010113          	addi	sp,sp,-48
80004c84:	02112623          	sw	ra,44(sp)
80004c88:	02812423          	sw	s0,40(sp)
80004c8c:	01312e23          	sw	s3,28(sp)
80004c90:	01512a23          	sw	s5,20(sp)
80004c94:	01612823          	sw	s6,16(sp)
80004c98:	01712623          	sw	s7,12(sp)
80004c9c:	01812423          	sw	s8,8(sp)
80004ca0:	03010413          	addi	s0,sp,48
80004ca4:	00050b93          	mv	s7,a0
80004ca8:	00058c13          	mv	s8,a1
80004cac:	00060a93          	mv	s5,a2
80004cb0:	00068993          	mv	s3,a3
80004cb4:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
80004cb8:	00e68733          	add	a4,a3,a4
80004cbc:	10d76c63          	bltu	a4,a3,80004dd4 <readi+0x15c>
    return -1;
  if(off + n > ip->size)
80004cc0:	00e7f463          	bgeu	a5,a4,80004cc8 <readi+0x50>
    n = ip->size - off;
80004cc4:	40d78b33          	sub	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80004cc8:	0c0b0263          	beqz	s6,80004d8c <readi+0x114>
80004ccc:	02912223          	sw	s1,36(sp)
80004cd0:	03212023          	sw	s2,32(sp)
80004cd4:	01412c23          	sw	s4,24(sp)
80004cd8:	01912223          	sw	s9,4(sp)
80004cdc:	01a12023          	sw	s10,0(sp)
80004ce0:	00000a13          	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80004ce4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
80004ce8:	fff00c93          	li	s9,-1
80004cec:	0400006f          	j	80004d2c <readi+0xb4>
80004cf0:	03890613          	addi	a2,s2,56
80004cf4:	00048693          	mv	a3,s1
80004cf8:	00f60633          	add	a2,a2,a5
80004cfc:	000a8593          	mv	a1,s5
80004d00:	000c0513          	mv	a0,s8
80004d04:	ffffe097          	auipc	ra,0xffffe
80004d08:	374080e7          	jalr	884(ra) # 80003078 <either_copyout>
80004d0c:	07950063          	beq	a0,s9,80004d6c <readi+0xf4>
      brelse(bp);
      break;
    }
    brelse(bp);
80004d10:	00090513          	mv	a0,s2
80004d14:	fffff097          	auipc	ra,0xfffff
80004d18:	2c4080e7          	jalr	708(ra) # 80003fd8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80004d1c:	009a0a33          	add	s4,s4,s1
80004d20:	009989b3          	add	s3,s3,s1
80004d24:	009a8ab3          	add	s5,s5,s1
80004d28:	096a7663          	bgeu	s4,s6,80004db4 <readi+0x13c>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80004d2c:	000ba483          	lw	s1,0(s7)
80004d30:	00a9d593          	srli	a1,s3,0xa
80004d34:	000b8513          	mv	a0,s7
80004d38:	fffff097          	auipc	ra,0xfffff
80004d3c:	654080e7          	jalr	1620(ra) # 8000438c <bmap>
80004d40:	00050593          	mv	a1,a0
80004d44:	00048513          	mv	a0,s1
80004d48:	fffff097          	auipc	ra,0xfffff
80004d4c:	0f4080e7          	jalr	244(ra) # 80003e3c <bread>
80004d50:	00050913          	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
80004d54:	3ff9f793          	andi	a5,s3,1023
80004d58:	414b0733          	sub	a4,s6,s4
80004d5c:	40fd04b3          	sub	s1,s10,a5
80004d60:	f89778e3          	bgeu	a4,s1,80004cf0 <readi+0x78>
80004d64:	00070493          	mv	s1,a4
80004d68:	f89ff06f          	j	80004cf0 <readi+0x78>
      brelse(bp);
80004d6c:	00090513          	mv	a0,s2
80004d70:	fffff097          	auipc	ra,0xfffff
80004d74:	268080e7          	jalr	616(ra) # 80003fd8 <brelse>
      break;
80004d78:	02412483          	lw	s1,36(sp)
80004d7c:	02012903          	lw	s2,32(sp)
80004d80:	01812a03          	lw	s4,24(sp)
80004d84:	00412c83          	lw	s9,4(sp)
80004d88:	00012d03          	lw	s10,0(sp)
  }
  return n;
80004d8c:	000b0513          	mv	a0,s6
}
80004d90:	02c12083          	lw	ra,44(sp)
80004d94:	02812403          	lw	s0,40(sp)
80004d98:	01c12983          	lw	s3,28(sp)
80004d9c:	01412a83          	lw	s5,20(sp)
80004da0:	01012b03          	lw	s6,16(sp)
80004da4:	00c12b83          	lw	s7,12(sp)
80004da8:	00812c03          	lw	s8,8(sp)
80004dac:	03010113          	addi	sp,sp,48
80004db0:	00008067          	ret
80004db4:	02412483          	lw	s1,36(sp)
80004db8:	02012903          	lw	s2,32(sp)
80004dbc:	01812a03          	lw	s4,24(sp)
80004dc0:	00412c83          	lw	s9,4(sp)
80004dc4:	00012d03          	lw	s10,0(sp)
80004dc8:	fc5ff06f          	j	80004d8c <readi+0x114>
    return -1;
80004dcc:	fff00513          	li	a0,-1
}
80004dd0:	00008067          	ret
    return -1;
80004dd4:	fff00513          	li	a0,-1
80004dd8:	fb9ff06f          	j	80004d90 <readi+0x118>

80004ddc <writei>:
writei(struct inode *ip, int user_src, uint32 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
80004ddc:	03052783          	lw	a5,48(a0)
80004de0:	14d7ee63          	bltu	a5,a3,80004f3c <writei+0x160>
{
80004de4:	fd010113          	addi	sp,sp,-48
80004de8:	02112623          	sw	ra,44(sp)
80004dec:	02812423          	sw	s0,40(sp)
80004df0:	01312e23          	sw	s3,28(sp)
80004df4:	01512a23          	sw	s5,20(sp)
80004df8:	01612823          	sw	s6,16(sp)
80004dfc:	01712623          	sw	s7,12(sp)
80004e00:	01812423          	sw	s8,8(sp)
80004e04:	03010413          	addi	s0,sp,48
80004e08:	00050b93          	mv	s7,a0
80004e0c:	00058c13          	mv	s8,a1
80004e10:	00060a93          	mv	s5,a2
80004e14:	00068993          	mv	s3,a3
80004e18:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
80004e1c:	00e687b3          	add	a5,a3,a4
80004e20:	12d7e263          	bltu	a5,a3,80004f44 <writei+0x168>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80004e24:	00043737          	lui	a4,0x43
80004e28:	12f76263          	bltu	a4,a5,80004f4c <writei+0x170>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80004e2c:	0e0b0463          	beqz	s6,80004f14 <writei+0x138>
80004e30:	02912223          	sw	s1,36(sp)
80004e34:	03212023          	sw	s2,32(sp)
80004e38:	01412c23          	sw	s4,24(sp)
80004e3c:	01912223          	sw	s9,4(sp)
80004e40:	01a12023          	sw	s10,0(sp)
80004e44:	00000a13          	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80004e48:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
80004e4c:	fff00c93          	li	s9,-1
80004e50:	04c0006f          	j	80004e9c <writei+0xc0>
80004e54:	03890793          	addi	a5,s2,56
80004e58:	00048693          	mv	a3,s1
80004e5c:	000a8613          	mv	a2,s5
80004e60:	000c0593          	mv	a1,s8
80004e64:	00a78533          	add	a0,a5,a0
80004e68:	ffffe097          	auipc	ra,0xffffe
80004e6c:	2a0080e7          	jalr	672(ra) # 80003108 <either_copyin>
80004e70:	07950663          	beq	a0,s9,80004edc <writei+0x100>
      brelse(bp);
      break;
    }
    log_write(bp);
80004e74:	00090513          	mv	a0,s2
80004e78:	00001097          	auipc	ra,0x1
80004e7c:	a90080e7          	jalr	-1392(ra) # 80005908 <log_write>
    brelse(bp);
80004e80:	00090513          	mv	a0,s2
80004e84:	fffff097          	auipc	ra,0xfffff
80004e88:	154080e7          	jalr	340(ra) # 80003fd8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80004e8c:	009a0a33          	add	s4,s4,s1
80004e90:	009989b3          	add	s3,s3,s1
80004e94:	009a8ab3          	add	s5,s5,s1
80004e98:	056a7863          	bgeu	s4,s6,80004ee8 <writei+0x10c>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80004e9c:	000ba483          	lw	s1,0(s7)
80004ea0:	00a9d593          	srli	a1,s3,0xa
80004ea4:	000b8513          	mv	a0,s7
80004ea8:	fffff097          	auipc	ra,0xfffff
80004eac:	4e4080e7          	jalr	1252(ra) # 8000438c <bmap>
80004eb0:	00050593          	mv	a1,a0
80004eb4:	00048513          	mv	a0,s1
80004eb8:	fffff097          	auipc	ra,0xfffff
80004ebc:	f84080e7          	jalr	-124(ra) # 80003e3c <bread>
80004ec0:	00050913          	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
80004ec4:	3ff9f513          	andi	a0,s3,1023
80004ec8:	414b07b3          	sub	a5,s6,s4
80004ecc:	40ad04b3          	sub	s1,s10,a0
80004ed0:	f897f2e3          	bgeu	a5,s1,80004e54 <writei+0x78>
80004ed4:	00078493          	mv	s1,a5
80004ed8:	f7dff06f          	j	80004e54 <writei+0x78>
      brelse(bp);
80004edc:	00090513          	mv	a0,s2
80004ee0:	fffff097          	auipc	ra,0xfffff
80004ee4:	0f8080e7          	jalr	248(ra) # 80003fd8 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
80004ee8:	030ba783          	lw	a5,48(s7)
80004eec:	0137f463          	bgeu	a5,s3,80004ef4 <writei+0x118>
      ip->size = off;
80004ef0:	033ba823          	sw	s3,48(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
80004ef4:	000b8513          	mv	a0,s7
80004ef8:	00000097          	auipc	ra,0x0
80004efc:	8cc080e7          	jalr	-1844(ra) # 800047c4 <iupdate>
80004f00:	02412483          	lw	s1,36(sp)
80004f04:	02012903          	lw	s2,32(sp)
80004f08:	01812a03          	lw	s4,24(sp)
80004f0c:	00412c83          	lw	s9,4(sp)
80004f10:	00012d03          	lw	s10,0(sp)
  }

  return n;
80004f14:	000b0513          	mv	a0,s6
}
80004f18:	02c12083          	lw	ra,44(sp)
80004f1c:	02812403          	lw	s0,40(sp)
80004f20:	01c12983          	lw	s3,28(sp)
80004f24:	01412a83          	lw	s5,20(sp)
80004f28:	01012b03          	lw	s6,16(sp)
80004f2c:	00c12b83          	lw	s7,12(sp)
80004f30:	00812c03          	lw	s8,8(sp)
80004f34:	03010113          	addi	sp,sp,48
80004f38:	00008067          	ret
    return -1;
80004f3c:	fff00513          	li	a0,-1
}
80004f40:	00008067          	ret
    return -1;
80004f44:	fff00513          	li	a0,-1
80004f48:	fd1ff06f          	j	80004f18 <writei+0x13c>
    return -1;
80004f4c:	fff00513          	li	a0,-1
80004f50:	fc9ff06f          	j	80004f18 <writei+0x13c>

80004f54 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80004f54:	ff010113          	addi	sp,sp,-16
80004f58:	00112623          	sw	ra,12(sp)
80004f5c:	00812423          	sw	s0,8(sp)
80004f60:	01010413          	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
80004f64:	00e00613          	li	a2,14
80004f68:	ffffc097          	auipc	ra,0xffffc
80004f6c:	180080e7          	jalr	384(ra) # 800010e8 <strncmp>
}
80004f70:	00c12083          	lw	ra,12(sp)
80004f74:	00812403          	lw	s0,8(sp)
80004f78:	01010113          	addi	sp,sp,16
80004f7c:	00008067          	ret

80004f80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80004f80:	fc010113          	addi	sp,sp,-64
80004f84:	02112e23          	sw	ra,60(sp)
80004f88:	02812c23          	sw	s0,56(sp)
80004f8c:	02912a23          	sw	s1,52(sp)
80004f90:	03212823          	sw	s2,48(sp)
80004f94:	03312623          	sw	s3,44(sp)
80004f98:	03412423          	sw	s4,40(sp)
80004f9c:	03512223          	sw	s5,36(sp)
80004fa0:	03612023          	sw	s6,32(sp)
80004fa4:	01712e23          	sw	s7,28(sp)
80004fa8:	04010413          	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80004fac:	02851703          	lh	a4,40(a0)
80004fb0:	00100793          	li	a5,1
80004fb4:	02f71863          	bne	a4,a5,80004fe4 <dirlookup+0x64>
80004fb8:	00050913          	mv	s2,a0
80004fbc:	00058a93          	mv	s5,a1
80004fc0:	00060b93          	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80004fc4:	03052783          	lw	a5,48(a0)
80004fc8:	00000493          	li	s1,0
    if(readi(dp, 0, (uint32)&de, off, sizeof(de)) != sizeof(de))
80004fcc:	fc040a13          	addi	s4,s0,-64
80004fd0:	01000993          	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80004fd4:	fc240b13          	addi	s6,s0,-62
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80004fd8:	00000513          	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
80004fdc:	02079a63          	bnez	a5,80005010 <dirlookup+0x90>
80004fe0:	08c0006f          	j	8000506c <dirlookup+0xec>
    panic("dirlookup not DIR");
80004fe4:	00007517          	auipc	a0,0x7
80004fe8:	d2850513          	addi	a0,a0,-728 # 8000bd0c <userret+0x2c6c>
80004fec:	ffffb097          	auipc	ra,0xffffb
80004ff0:	714080e7          	jalr	1812(ra) # 80000700 <panic>
      panic("dirlookup read");
80004ff4:	00007517          	auipc	a0,0x7
80004ff8:	d2c50513          	addi	a0,a0,-724 # 8000bd20 <userret+0x2c80>
80004ffc:	ffffb097          	auipc	ra,0xffffb
80005000:	704080e7          	jalr	1796(ra) # 80000700 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80005004:	01048493          	addi	s1,s1,16
80005008:	03092783          	lw	a5,48(s2)
8000500c:	04f4fe63          	bgeu	s1,a5,80005068 <dirlookup+0xe8>
    if(readi(dp, 0, (uint32)&de, off, sizeof(de)) != sizeof(de))
80005010:	00098713          	mv	a4,s3
80005014:	00048693          	mv	a3,s1
80005018:	000a0613          	mv	a2,s4
8000501c:	00000593          	li	a1,0
80005020:	00090513          	mv	a0,s2
80005024:	00000097          	auipc	ra,0x0
80005028:	c54080e7          	jalr	-940(ra) # 80004c78 <readi>
8000502c:	fd3514e3          	bne	a0,s3,80004ff4 <dirlookup+0x74>
    if(de.inum == 0)
80005030:	fc045783          	lhu	a5,-64(s0)
80005034:	fc0788e3          	beqz	a5,80005004 <dirlookup+0x84>
    if(namecmp(name, de.name) == 0){
80005038:	000b0593          	mv	a1,s6
8000503c:	000a8513          	mv	a0,s5
80005040:	00000097          	auipc	ra,0x0
80005044:	f14080e7          	jalr	-236(ra) # 80004f54 <namecmp>
80005048:	fa051ee3          	bnez	a0,80005004 <dirlookup+0x84>
      if(poff)
8000504c:	000b8463          	beqz	s7,80005054 <dirlookup+0xd4>
        *poff = off;
80005050:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
80005054:	fc045583          	lhu	a1,-64(s0)
80005058:	00092503          	lw	a0,0(s2)
8000505c:	fffff097          	auipc	ra,0xfffff
80005060:	438080e7          	jalr	1080(ra) # 80004494 <iget>
80005064:	0080006f          	j	8000506c <dirlookup+0xec>
  return 0;
80005068:	00000513          	li	a0,0
}
8000506c:	03c12083          	lw	ra,60(sp)
80005070:	03812403          	lw	s0,56(sp)
80005074:	03412483          	lw	s1,52(sp)
80005078:	03012903          	lw	s2,48(sp)
8000507c:	02c12983          	lw	s3,44(sp)
80005080:	02812a03          	lw	s4,40(sp)
80005084:	02412a83          	lw	s5,36(sp)
80005088:	02012b03          	lw	s6,32(sp)
8000508c:	01c12b83          	lw	s7,28(sp)
80005090:	04010113          	addi	sp,sp,64
80005094:	00008067          	ret

80005098 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80005098:	fd010113          	addi	sp,sp,-48
8000509c:	02112623          	sw	ra,44(sp)
800050a0:	02812423          	sw	s0,40(sp)
800050a4:	02912223          	sw	s1,36(sp)
800050a8:	03212023          	sw	s2,32(sp)
800050ac:	01312e23          	sw	s3,28(sp)
800050b0:	01412c23          	sw	s4,24(sp)
800050b4:	01512a23          	sw	s5,20(sp)
800050b8:	01612823          	sw	s6,16(sp)
800050bc:	01712623          	sw	s7,12(sp)
800050c0:	01812423          	sw	s8,8(sp)
800050c4:	01912223          	sw	s9,4(sp)
800050c8:	01a12023          	sw	s10,0(sp)
800050cc:	03010413          	addi	s0,sp,48
800050d0:	00050493          	mv	s1,a0
800050d4:	00058b13          	mv	s6,a1
800050d8:	00060a93          	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
800050dc:	00054703          	lbu	a4,0(a0)
800050e0:	02f00793          	li	a5,47
800050e4:	02f70863          	beq	a4,a5,80005114 <namex+0x7c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
800050e8:	ffffd097          	auipc	ra,0xffffd
800050ec:	1f4080e7          	jalr	500(ra) # 800022dc <myproc>
800050f0:	0ac52503          	lw	a0,172(a0)
800050f4:	fffff097          	auipc	ra,0xfffff
800050f8:	790080e7          	jalr	1936(ra) # 80004884 <idup>
800050fc:	00050a13          	mv	s4,a0
  while(*path == '/')
80005100:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
80005104:	00d00c13          	li	s8,13
    memmove(name, s, DIRSIZ);
80005108:	00e00c93          	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
8000510c:	00100b93          	li	s7,1
80005110:	10c0006f          	j	8000521c <namex+0x184>
    ip = iget(ROOTDEV, ROOTINO);
80005114:	00100593          	li	a1,1
80005118:	00058513          	mv	a0,a1
8000511c:	fffff097          	auipc	ra,0xfffff
80005120:	378080e7          	jalr	888(ra) # 80004494 <iget>
80005124:	00050a13          	mv	s4,a0
80005128:	fd9ff06f          	j	80005100 <namex+0x68>
      iunlockput(ip);
8000512c:	000a0513          	mv	a0,s4
80005130:	00000097          	auipc	ra,0x0
80005134:	abc080e7          	jalr	-1348(ra) # 80004bec <iunlockput>
      return 0;
80005138:	00000a13          	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
8000513c:	000a0513          	mv	a0,s4
80005140:	02c12083          	lw	ra,44(sp)
80005144:	02812403          	lw	s0,40(sp)
80005148:	02412483          	lw	s1,36(sp)
8000514c:	02012903          	lw	s2,32(sp)
80005150:	01c12983          	lw	s3,28(sp)
80005154:	01812a03          	lw	s4,24(sp)
80005158:	01412a83          	lw	s5,20(sp)
8000515c:	01012b03          	lw	s6,16(sp)
80005160:	00c12b83          	lw	s7,12(sp)
80005164:	00812c03          	lw	s8,8(sp)
80005168:	00412c83          	lw	s9,4(sp)
8000516c:	00012d03          	lw	s10,0(sp)
80005170:	03010113          	addi	sp,sp,48
80005174:	00008067          	ret
      iunlock(ip);
80005178:	000a0513          	mv	a0,s4
8000517c:	00000097          	auipc	ra,0x0
80005180:	870080e7          	jalr	-1936(ra) # 800049ec <iunlock>
      return ip;
80005184:	fb9ff06f          	j	8000513c <namex+0xa4>
      iunlockput(ip);
80005188:	000a0513          	mv	a0,s4
8000518c:	00000097          	auipc	ra,0x0
80005190:	a60080e7          	jalr	-1440(ra) # 80004bec <iunlockput>
      return 0;
80005194:	00098a13          	mv	s4,s3
80005198:	fa5ff06f          	j	8000513c <namex+0xa4>
  len = path - s;
8000519c:	40998d33          	sub	s10,s3,s1
  if(len >= DIRSIZ)
800051a0:	0bac5c63          	bge	s8,s10,80005258 <namex+0x1c0>
    memmove(name, s, DIRSIZ);
800051a4:	000c8613          	mv	a2,s9
800051a8:	00048593          	mv	a1,s1
800051ac:	000a8513          	mv	a0,s5
800051b0:	ffffc097          	auipc	ra,0xffffc
800051b4:	ea4080e7          	jalr	-348(ra) # 80001054 <memmove>
800051b8:	00098493          	mv	s1,s3
  while(*path == '/')
800051bc:	0004c783          	lbu	a5,0(s1)
800051c0:	01279863          	bne	a5,s2,800051d0 <namex+0x138>
    path++;
800051c4:	00148493          	addi	s1,s1,1
  while(*path == '/')
800051c8:	0004c783          	lbu	a5,0(s1)
800051cc:	ff278ce3          	beq	a5,s2,800051c4 <namex+0x12c>
    ilock(ip);
800051d0:	000a0513          	mv	a0,s4
800051d4:	fffff097          	auipc	ra,0xfffff
800051d8:	70c080e7          	jalr	1804(ra) # 800048e0 <ilock>
    if(ip->type != T_DIR){
800051dc:	028a1783          	lh	a5,40(s4)
800051e0:	f57796e3          	bne	a5,s7,8000512c <namex+0x94>
    if(nameiparent && *path == '\0'){
800051e4:	000b0663          	beqz	s6,800051f0 <namex+0x158>
800051e8:	0004c783          	lbu	a5,0(s1)
800051ec:	f80786e3          	beqz	a5,80005178 <namex+0xe0>
    if((next = dirlookup(ip, name, 0)) == 0){
800051f0:	00000613          	li	a2,0
800051f4:	000a8593          	mv	a1,s5
800051f8:	000a0513          	mv	a0,s4
800051fc:	00000097          	auipc	ra,0x0
80005200:	d84080e7          	jalr	-636(ra) # 80004f80 <dirlookup>
80005204:	00050993          	mv	s3,a0
80005208:	f80500e3          	beqz	a0,80005188 <namex+0xf0>
    iunlockput(ip);
8000520c:	000a0513          	mv	a0,s4
80005210:	00000097          	auipc	ra,0x0
80005214:	9dc080e7          	jalr	-1572(ra) # 80004bec <iunlockput>
    ip = next;
80005218:	00098a13          	mv	s4,s3
  while(*path == '/')
8000521c:	0004c783          	lbu	a5,0(s1)
80005220:	01279863          	bne	a5,s2,80005230 <namex+0x198>
    path++;
80005224:	00148493          	addi	s1,s1,1
  while(*path == '/')
80005228:	0004c783          	lbu	a5,0(s1)
8000522c:	ff278ce3          	beq	a5,s2,80005224 <namex+0x18c>
  if(*path == 0)
80005230:	04078663          	beqz	a5,8000527c <namex+0x1e4>
  while(*path != '/' && *path != 0)
80005234:	0004c783          	lbu	a5,0(s1)
80005238:	00048993          	mv	s3,s1
  len = path - s;
8000523c:	00000d13          	li	s10,0
  while(*path != '/' && *path != 0)
80005240:	01278c63          	beq	a5,s2,80005258 <namex+0x1c0>
80005244:	f4078ce3          	beqz	a5,8000519c <namex+0x104>
    path++;
80005248:	00198993          	addi	s3,s3,1
  while(*path != '/' && *path != 0)
8000524c:	0009c783          	lbu	a5,0(s3)
80005250:	ff279ae3          	bne	a5,s2,80005244 <namex+0x1ac>
80005254:	f49ff06f          	j	8000519c <namex+0x104>
    memmove(name, s, len);
80005258:	000d0613          	mv	a2,s10
8000525c:	00048593          	mv	a1,s1
80005260:	000a8513          	mv	a0,s5
80005264:	ffffc097          	auipc	ra,0xffffc
80005268:	df0080e7          	jalr	-528(ra) # 80001054 <memmove>
    name[len] = 0;
8000526c:	01aa8d33          	add	s10,s5,s10
80005270:	000d0023          	sb	zero,0(s10)
80005274:	00098493          	mv	s1,s3
80005278:	f45ff06f          	j	800051bc <namex+0x124>
  if(nameiparent){
8000527c:	ec0b00e3          	beqz	s6,8000513c <namex+0xa4>
    iput(ip);
80005280:	000a0513          	mv	a0,s4
80005284:	fffff097          	auipc	ra,0xfffff
80005288:	7d8080e7          	jalr	2008(ra) # 80004a5c <iput>
    return 0;
8000528c:	00000a13          	li	s4,0
80005290:	eadff06f          	j	8000513c <namex+0xa4>

80005294 <dirlink>:
{
80005294:	fd010113          	addi	sp,sp,-48
80005298:	02112623          	sw	ra,44(sp)
8000529c:	02812423          	sw	s0,40(sp)
800052a0:	03212023          	sw	s2,32(sp)
800052a4:	01512a23          	sw	s5,20(sp)
800052a8:	01612823          	sw	s6,16(sp)
800052ac:	03010413          	addi	s0,sp,48
800052b0:	00050913          	mv	s2,a0
800052b4:	00058a93          	mv	s5,a1
800052b8:	00060b13          	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
800052bc:	00000613          	li	a2,0
800052c0:	00000097          	auipc	ra,0x0
800052c4:	cc0080e7          	jalr	-832(ra) # 80004f80 <dirlookup>
800052c8:	06051263          	bnez	a0,8000532c <dirlink+0x98>
800052cc:	02912223          	sw	s1,36(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
800052d0:	03092483          	lw	s1,48(s2)
800052d4:	08048063          	beqz	s1,80005354 <dirlink+0xc0>
800052d8:	01312e23          	sw	s3,28(sp)
800052dc:	01412c23          	sw	s4,24(sp)
800052e0:	00000493          	li	s1,0
    if(readi(dp, 0, (uint32)&de, off, sizeof(de)) != sizeof(de))
800052e4:	fd040a13          	addi	s4,s0,-48
800052e8:	01000993          	li	s3,16
800052ec:	00098713          	mv	a4,s3
800052f0:	00048693          	mv	a3,s1
800052f4:	000a0613          	mv	a2,s4
800052f8:	00000593          	li	a1,0
800052fc:	00090513          	mv	a0,s2
80005300:	00000097          	auipc	ra,0x0
80005304:	978080e7          	jalr	-1672(ra) # 80004c78 <readi>
80005308:	03351a63          	bne	a0,s3,8000533c <dirlink+0xa8>
    if(de.inum == 0)
8000530c:	fd045783          	lhu	a5,-48(s0)
80005310:	02078e63          	beqz	a5,8000534c <dirlink+0xb8>
  for(off = 0; off < dp->size; off += sizeof(de)){
80005314:	01048493          	addi	s1,s1,16
80005318:	03092783          	lw	a5,48(s2)
8000531c:	fcf4e8e3          	bltu	s1,a5,800052ec <dirlink+0x58>
80005320:	01c12983          	lw	s3,28(sp)
80005324:	01812a03          	lw	s4,24(sp)
80005328:	02c0006f          	j	80005354 <dirlink+0xc0>
    iput(ip);
8000532c:	fffff097          	auipc	ra,0xfffff
80005330:	730080e7          	jalr	1840(ra) # 80004a5c <iput>
    return -1;
80005334:	fff00513          	li	a0,-1
80005338:	0640006f          	j	8000539c <dirlink+0x108>
      panic("dirlink read");
8000533c:	00007517          	auipc	a0,0x7
80005340:	9f450513          	addi	a0,a0,-1548 # 8000bd30 <userret+0x2c90>
80005344:	ffffb097          	auipc	ra,0xffffb
80005348:	3bc080e7          	jalr	956(ra) # 80000700 <panic>
8000534c:	01c12983          	lw	s3,28(sp)
80005350:	01812a03          	lw	s4,24(sp)
  strncpy(de.name, name, DIRSIZ);
80005354:	00e00613          	li	a2,14
80005358:	000a8593          	mv	a1,s5
8000535c:	fd240513          	addi	a0,s0,-46
80005360:	ffffc097          	auipc	ra,0xffffc
80005364:	de8080e7          	jalr	-536(ra) # 80001148 <strncpy>
  de.inum = inum;
80005368:	fd641823          	sh	s6,-48(s0)
  if(writei(dp, 0, (uint32)&de, off, sizeof(de)) != sizeof(de))
8000536c:	01000713          	li	a4,16
80005370:	00048693          	mv	a3,s1
80005374:	fd040613          	addi	a2,s0,-48
80005378:	00000593          	li	a1,0
8000537c:	00090513          	mv	a0,s2
80005380:	00000097          	auipc	ra,0x0
80005384:	a5c080e7          	jalr	-1444(ra) # 80004ddc <writei>
80005388:	00050713          	mv	a4,a0
8000538c:	01000793          	li	a5,16
  return 0;
80005390:	00000513          	li	a0,0
  if(writei(dp, 0, (uint32)&de, off, sizeof(de)) != sizeof(de))
80005394:	02f71263          	bne	a4,a5,800053b8 <dirlink+0x124>
80005398:	02412483          	lw	s1,36(sp)
}
8000539c:	02c12083          	lw	ra,44(sp)
800053a0:	02812403          	lw	s0,40(sp)
800053a4:	02012903          	lw	s2,32(sp)
800053a8:	01412a83          	lw	s5,20(sp)
800053ac:	01012b03          	lw	s6,16(sp)
800053b0:	03010113          	addi	sp,sp,48
800053b4:	00008067          	ret
800053b8:	01312e23          	sw	s3,28(sp)
800053bc:	01412c23          	sw	s4,24(sp)
    panic("dirlink");
800053c0:	00007517          	auipc	a0,0x7
800053c4:	a6c50513          	addi	a0,a0,-1428 # 8000be2c <userret+0x2d8c>
800053c8:	ffffb097          	auipc	ra,0xffffb
800053cc:	338080e7          	jalr	824(ra) # 80000700 <panic>

800053d0 <namei>:

struct inode*
namei(char *path)
{
800053d0:	fe010113          	addi	sp,sp,-32
800053d4:	00112e23          	sw	ra,28(sp)
800053d8:	00812c23          	sw	s0,24(sp)
800053dc:	02010413          	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
800053e0:	fe040613          	addi	a2,s0,-32
800053e4:	00000593          	li	a1,0
800053e8:	00000097          	auipc	ra,0x0
800053ec:	cb0080e7          	jalr	-848(ra) # 80005098 <namex>
}
800053f0:	01c12083          	lw	ra,28(sp)
800053f4:	01812403          	lw	s0,24(sp)
800053f8:	02010113          	addi	sp,sp,32
800053fc:	00008067          	ret

80005400 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80005400:	ff010113          	addi	sp,sp,-16
80005404:	00112623          	sw	ra,12(sp)
80005408:	00812423          	sw	s0,8(sp)
8000540c:	01010413          	addi	s0,sp,16
80005410:	00058613          	mv	a2,a1
  return namex(path, 1, name);
80005414:	00100593          	li	a1,1
80005418:	00000097          	auipc	ra,0x0
8000541c:	c80080e7          	jalr	-896(ra) # 80005098 <namex>
}
80005420:	00c12083          	lw	ra,12(sp)
80005424:	00812403          	lw	s0,8(sp)
80005428:	01010113          	addi	sp,sp,16
8000542c:	00008067          	ret

80005430 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80005430:	ff010113          	addi	sp,sp,-16
80005434:	00112623          	sw	ra,12(sp)
80005438:	00812423          	sw	s0,8(sp)
8000543c:	00912223          	sw	s1,4(sp)
80005440:	01212023          	sw	s2,0(sp)
80005444:	01010413          	addi	s0,sp,16
  struct buf *buf = bread(log.dev, log.start);
80005448:	0001d917          	auipc	s2,0x1d
8000544c:	9f890913          	addi	s2,s2,-1544 # 80021e40 <log>
80005450:	00c92583          	lw	a1,12(s2)
80005454:	01c92503          	lw	a0,28(s2)
80005458:	fffff097          	auipc	ra,0xfffff
8000545c:	9e4080e7          	jalr	-1564(ra) # 80003e3c <bread>
80005460:	00050493          	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80005464:	02092603          	lw	a2,32(s2)
80005468:	02c52c23          	sw	a2,56(a0)
  for (i = 0; i < log.lh.n; i++) {
8000546c:	02c05663          	blez	a2,80005498 <write_head+0x68>
80005470:	0001d717          	auipc	a4,0x1d
80005474:	9f470713          	addi	a4,a4,-1548 # 80021e64 <log+0x24>
80005478:	00050793          	mv	a5,a0
8000547c:	00261613          	slli	a2,a2,0x2
80005480:	00a60633          	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
80005484:	00072683          	lw	a3,0(a4)
80005488:	02d7ae23          	sw	a3,60(a5)
  for (i = 0; i < log.lh.n; i++) {
8000548c:	00470713          	addi	a4,a4,4
80005490:	00478793          	addi	a5,a5,4
80005494:	fec798e3          	bne	a5,a2,80005484 <write_head+0x54>
  }
  bwrite(buf);
80005498:	00048513          	mv	a0,s1
8000549c:	fffff097          	auipc	ra,0xfffff
800054a0:	ae0080e7          	jalr	-1312(ra) # 80003f7c <bwrite>
  brelse(buf);
800054a4:	00048513          	mv	a0,s1
800054a8:	fffff097          	auipc	ra,0xfffff
800054ac:	b30080e7          	jalr	-1232(ra) # 80003fd8 <brelse>
}
800054b0:	00c12083          	lw	ra,12(sp)
800054b4:	00812403          	lw	s0,8(sp)
800054b8:	00412483          	lw	s1,4(sp)
800054bc:	00012903          	lw	s2,0(sp)
800054c0:	01010113          	addi	sp,sp,16
800054c4:	00008067          	ret

800054c8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
800054c8:	0001d797          	auipc	a5,0x1d
800054cc:	9987a783          	lw	a5,-1640(a5) # 80021e60 <log+0x20>
800054d0:	0ef05863          	blez	a5,800055c0 <install_trans+0xf8>
{
800054d4:	fe010113          	addi	sp,sp,-32
800054d8:	00112e23          	sw	ra,28(sp)
800054dc:	00812c23          	sw	s0,24(sp)
800054e0:	00912a23          	sw	s1,20(sp)
800054e4:	01212823          	sw	s2,16(sp)
800054e8:	01312623          	sw	s3,12(sp)
800054ec:	01412423          	sw	s4,8(sp)
800054f0:	01512223          	sw	s5,4(sp)
800054f4:	01612023          	sw	s6,0(sp)
800054f8:	02010413          	addi	s0,sp,32
800054fc:	0001da97          	auipc	s5,0x1d
80005500:	968a8a93          	addi	s5,s5,-1688 # 80021e64 <log+0x24>
  for (tail = 0; tail < log.lh.n; tail++) {
80005504:	00000a13          	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80005508:	0001d997          	auipc	s3,0x1d
8000550c:	93898993          	addi	s3,s3,-1736 # 80021e40 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80005510:	40000b13          	li	s6,1024
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80005514:	00c9a583          	lw	a1,12(s3)
80005518:	00ba05b3          	add	a1,s4,a1
8000551c:	00158593          	addi	a1,a1,1
80005520:	01c9a503          	lw	a0,28(s3)
80005524:	fffff097          	auipc	ra,0xfffff
80005528:	918080e7          	jalr	-1768(ra) # 80003e3c <bread>
8000552c:	00050913          	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80005530:	000aa583          	lw	a1,0(s5)
80005534:	01c9a503          	lw	a0,28(s3)
80005538:	fffff097          	auipc	ra,0xfffff
8000553c:	904080e7          	jalr	-1788(ra) # 80003e3c <bread>
80005540:	00050493          	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80005544:	000b0613          	mv	a2,s6
80005548:	03890593          	addi	a1,s2,56
8000554c:	03850513          	addi	a0,a0,56
80005550:	ffffc097          	auipc	ra,0xffffc
80005554:	b04080e7          	jalr	-1276(ra) # 80001054 <memmove>
    bwrite(dbuf);  // write dst to disk
80005558:	00048513          	mv	a0,s1
8000555c:	fffff097          	auipc	ra,0xfffff
80005560:	a20080e7          	jalr	-1504(ra) # 80003f7c <bwrite>
    bunpin(dbuf);
80005564:	00048513          	mv	a0,s1
80005568:	fffff097          	auipc	ra,0xfffff
8000556c:	b98080e7          	jalr	-1128(ra) # 80004100 <bunpin>
    brelse(lbuf);
80005570:	00090513          	mv	a0,s2
80005574:	fffff097          	auipc	ra,0xfffff
80005578:	a64080e7          	jalr	-1436(ra) # 80003fd8 <brelse>
    brelse(dbuf);
8000557c:	00048513          	mv	a0,s1
80005580:	fffff097          	auipc	ra,0xfffff
80005584:	a58080e7          	jalr	-1448(ra) # 80003fd8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80005588:	001a0a13          	addi	s4,s4,1
8000558c:	004a8a93          	addi	s5,s5,4
80005590:	0209a783          	lw	a5,32(s3)
80005594:	f8fa40e3          	blt	s4,a5,80005514 <install_trans+0x4c>
}
80005598:	01c12083          	lw	ra,28(sp)
8000559c:	01812403          	lw	s0,24(sp)
800055a0:	01412483          	lw	s1,20(sp)
800055a4:	01012903          	lw	s2,16(sp)
800055a8:	00c12983          	lw	s3,12(sp)
800055ac:	00812a03          	lw	s4,8(sp)
800055b0:	00412a83          	lw	s5,4(sp)
800055b4:	00012b03          	lw	s6,0(sp)
800055b8:	02010113          	addi	sp,sp,32
800055bc:	00008067          	ret
800055c0:	00008067          	ret

800055c4 <initlog>:
{
800055c4:	fe010113          	addi	sp,sp,-32
800055c8:	00112e23          	sw	ra,28(sp)
800055cc:	00812c23          	sw	s0,24(sp)
800055d0:	00912a23          	sw	s1,20(sp)
800055d4:	01212823          	sw	s2,16(sp)
800055d8:	01312623          	sw	s3,12(sp)
800055dc:	02010413          	addi	s0,sp,32
800055e0:	00050913          	mv	s2,a0
800055e4:	00058993          	mv	s3,a1
  initlock(&log.lock, "log");
800055e8:	0001d497          	auipc	s1,0x1d
800055ec:	85848493          	addi	s1,s1,-1960 # 80021e40 <log>
800055f0:	00006597          	auipc	a1,0x6
800055f4:	75058593          	addi	a1,a1,1872 # 8000bd40 <userret+0x2ca0>
800055f8:	00048513          	mv	a0,s1
800055fc:	ffffb097          	auipc	ra,0xffffb
80005600:	76c080e7          	jalr	1900(ra) # 80000d68 <initlock>
  log.start = sb->logstart;
80005604:	0149a583          	lw	a1,20(s3)
80005608:	00b4a623          	sw	a1,12(s1)
  log.size = sb->nlog;
8000560c:	0109a783          	lw	a5,16(s3)
80005610:	00f4a823          	sw	a5,16(s1)
  log.dev = dev;
80005614:	0124ae23          	sw	s2,28(s1)
  struct buf *buf = bread(log.dev, log.start);
80005618:	00090513          	mv	a0,s2
8000561c:	fffff097          	auipc	ra,0xfffff
80005620:	820080e7          	jalr	-2016(ra) # 80003e3c <bread>
  log.lh.n = lh->n;
80005624:	03852603          	lw	a2,56(a0)
80005628:	02c4a023          	sw	a2,32(s1)
  for (i = 0; i < log.lh.n; i++) {
8000562c:	02c05663          	blez	a2,80005658 <initlog+0x94>
80005630:	00050793          	mv	a5,a0
80005634:	0001d717          	auipc	a4,0x1d
80005638:	83070713          	addi	a4,a4,-2000 # 80021e64 <log+0x24>
8000563c:	00261613          	slli	a2,a2,0x2
80005640:	00a60633          	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
80005644:	03c7a683          	lw	a3,60(a5)
80005648:	00d72023          	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
8000564c:	00478793          	addi	a5,a5,4
80005650:	00470713          	addi	a4,a4,4
80005654:	fec798e3          	bne	a5,a2,80005644 <initlog+0x80>
  brelse(buf);
80005658:	fffff097          	auipc	ra,0xfffff
8000565c:	980080e7          	jalr	-1664(ra) # 80003fd8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80005660:	00000097          	auipc	ra,0x0
80005664:	e68080e7          	jalr	-408(ra) # 800054c8 <install_trans>
  log.lh.n = 0;
80005668:	0001c797          	auipc	a5,0x1c
8000566c:	7e07ac23          	sw	zero,2040(a5) # 80021e60 <log+0x20>
  write_head(); // clear the log
80005670:	00000097          	auipc	ra,0x0
80005674:	dc0080e7          	jalr	-576(ra) # 80005430 <write_head>
}
80005678:	01c12083          	lw	ra,28(sp)
8000567c:	01812403          	lw	s0,24(sp)
80005680:	01412483          	lw	s1,20(sp)
80005684:	01012903          	lw	s2,16(sp)
80005688:	00c12983          	lw	s3,12(sp)
8000568c:	02010113          	addi	sp,sp,32
80005690:	00008067          	ret

80005694 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80005694:	ff010113          	addi	sp,sp,-16
80005698:	00112623          	sw	ra,12(sp)
8000569c:	00812423          	sw	s0,8(sp)
800056a0:	00912223          	sw	s1,4(sp)
800056a4:	01212023          	sw	s2,0(sp)
800056a8:	01010413          	addi	s0,sp,16
  acquire(&log.lock);
800056ac:	0001c517          	auipc	a0,0x1c
800056b0:	79450513          	addi	a0,a0,1940 # 80021e40 <log>
800056b4:	ffffc097          	auipc	ra,0xffffc
800056b8:	840080e7          	jalr	-1984(ra) # 80000ef4 <acquire>
  while(1){
    if(log.committing){
800056bc:	0001c497          	auipc	s1,0x1c
800056c0:	78448493          	addi	s1,s1,1924 # 80021e40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
800056c4:	01e00913          	li	s2,30
800056c8:	0140006f          	j	800056dc <begin_op+0x48>
      sleep(&log, &log.lock);
800056cc:	00048593          	mv	a1,s1
800056d0:	00048513          	mv	a0,s1
800056d4:	ffffd097          	auipc	ra,0xffffd
800056d8:	64c080e7          	jalr	1612(ra) # 80002d20 <sleep>
    if(log.committing){
800056dc:	0184a783          	lw	a5,24(s1)
800056e0:	fe0796e3          	bnez	a5,800056cc <begin_op+0x38>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
800056e4:	0144a703          	lw	a4,20(s1)
800056e8:	00170713          	addi	a4,a4,1
800056ec:	00271793          	slli	a5,a4,0x2
800056f0:	00e787b3          	add	a5,a5,a4
800056f4:	00179793          	slli	a5,a5,0x1
800056f8:	0204a683          	lw	a3,32(s1)
800056fc:	00d787b3          	add	a5,a5,a3
80005700:	00f95c63          	bge	s2,a5,80005718 <begin_op+0x84>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80005704:	00048593          	mv	a1,s1
80005708:	00048513          	mv	a0,s1
8000570c:	ffffd097          	auipc	ra,0xffffd
80005710:	614080e7          	jalr	1556(ra) # 80002d20 <sleep>
80005714:	fc9ff06f          	j	800056dc <begin_op+0x48>
    } else {
      log.outstanding += 1;
80005718:	0001c517          	auipc	a0,0x1c
8000571c:	72850513          	addi	a0,a0,1832 # 80021e40 <log>
80005720:	00e52a23          	sw	a4,20(a0)
      release(&log.lock);
80005724:	ffffc097          	auipc	ra,0xffffc
80005728:	844080e7          	jalr	-1980(ra) # 80000f68 <release>
      break;
    }
  }
}
8000572c:	00c12083          	lw	ra,12(sp)
80005730:	00812403          	lw	s0,8(sp)
80005734:	00412483          	lw	s1,4(sp)
80005738:	00012903          	lw	s2,0(sp)
8000573c:	01010113          	addi	sp,sp,16
80005740:	00008067          	ret

80005744 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80005744:	fe010113          	addi	sp,sp,-32
80005748:	00112e23          	sw	ra,28(sp)
8000574c:	00812c23          	sw	s0,24(sp)
80005750:	00912a23          	sw	s1,20(sp)
80005754:	01212823          	sw	s2,16(sp)
80005758:	02010413          	addi	s0,sp,32
  int do_commit = 0;

  acquire(&log.lock);
8000575c:	0001c917          	auipc	s2,0x1c
80005760:	6e490913          	addi	s2,s2,1764 # 80021e40 <log>
80005764:	00090513          	mv	a0,s2
80005768:	ffffb097          	auipc	ra,0xffffb
8000576c:	78c080e7          	jalr	1932(ra) # 80000ef4 <acquire>
  log.outstanding -= 1;
80005770:	01492483          	lw	s1,20(s2)
80005774:	fff48493          	addi	s1,s1,-1
80005778:	00992a23          	sw	s1,20(s2)
  if(log.committing)
8000577c:	01892783          	lw	a5,24(s2)
80005780:	06079063          	bnez	a5,800057e0 <end_op+0x9c>
    panic("log.committing");
  if(log.outstanding == 0){
80005784:	06049e63          	bnez	s1,80005800 <end_op+0xbc>
    do_commit = 1;
    log.committing = 1;
80005788:	0001c917          	auipc	s2,0x1c
8000578c:	6b890913          	addi	s2,s2,1720 # 80021e40 <log>
80005790:	00100793          	li	a5,1
80005794:	00f92c23          	sw	a5,24(s2)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80005798:	00090513          	mv	a0,s2
8000579c:	ffffb097          	auipc	ra,0xffffb
800057a0:	7cc080e7          	jalr	1996(ra) # 80000f68 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
800057a4:	02092783          	lw	a5,32(s2)
800057a8:	08f04863          	bgtz	a5,80005838 <end_op+0xf4>
    acquire(&log.lock);
800057ac:	0001c497          	auipc	s1,0x1c
800057b0:	69448493          	addi	s1,s1,1684 # 80021e40 <log>
800057b4:	00048513          	mv	a0,s1
800057b8:	ffffb097          	auipc	ra,0xffffb
800057bc:	73c080e7          	jalr	1852(ra) # 80000ef4 <acquire>
    log.committing = 0;
800057c0:	0004ac23          	sw	zero,24(s1)
    wakeup(&log);
800057c4:	00048513          	mv	a0,s1
800057c8:	ffffd097          	auipc	ra,0xffffd
800057cc:	768080e7          	jalr	1896(ra) # 80002f30 <wakeup>
    release(&log.lock);
800057d0:	00048513          	mv	a0,s1
800057d4:	ffffb097          	auipc	ra,0xffffb
800057d8:	794080e7          	jalr	1940(ra) # 80000f68 <release>
}
800057dc:	0440006f          	j	80005820 <end_op+0xdc>
800057e0:	01312623          	sw	s3,12(sp)
800057e4:	01412423          	sw	s4,8(sp)
800057e8:	01512223          	sw	s5,4(sp)
800057ec:	01612023          	sw	s6,0(sp)
    panic("log.committing");
800057f0:	00006517          	auipc	a0,0x6
800057f4:	55450513          	addi	a0,a0,1364 # 8000bd44 <userret+0x2ca4>
800057f8:	ffffb097          	auipc	ra,0xffffb
800057fc:	f08080e7          	jalr	-248(ra) # 80000700 <panic>
    wakeup(&log);
80005800:	0001c497          	auipc	s1,0x1c
80005804:	64048493          	addi	s1,s1,1600 # 80021e40 <log>
80005808:	00048513          	mv	a0,s1
8000580c:	ffffd097          	auipc	ra,0xffffd
80005810:	724080e7          	jalr	1828(ra) # 80002f30 <wakeup>
  release(&log.lock);
80005814:	00048513          	mv	a0,s1
80005818:	ffffb097          	auipc	ra,0xffffb
8000581c:	750080e7          	jalr	1872(ra) # 80000f68 <release>
}
80005820:	01c12083          	lw	ra,28(sp)
80005824:	01812403          	lw	s0,24(sp)
80005828:	01412483          	lw	s1,20(sp)
8000582c:	01012903          	lw	s2,16(sp)
80005830:	02010113          	addi	sp,sp,32
80005834:	00008067          	ret
80005838:	01312623          	sw	s3,12(sp)
8000583c:	01412423          	sw	s4,8(sp)
80005840:	01512223          	sw	s5,4(sp)
80005844:	01612023          	sw	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
80005848:	0001ca97          	auipc	s5,0x1c
8000584c:	61ca8a93          	addi	s5,s5,1564 # 80021e64 <log+0x24>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80005850:	0001ca17          	auipc	s4,0x1c
80005854:	5f0a0a13          	addi	s4,s4,1520 # 80021e40 <log>
    memmove(to->data, from->data, BSIZE);
80005858:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8000585c:	00ca2583          	lw	a1,12(s4)
80005860:	00b485b3          	add	a1,s1,a1
80005864:	00158593          	addi	a1,a1,1
80005868:	01ca2503          	lw	a0,28(s4)
8000586c:	ffffe097          	auipc	ra,0xffffe
80005870:	5d0080e7          	jalr	1488(ra) # 80003e3c <bread>
80005874:	00050913          	mv	s2,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80005878:	000aa583          	lw	a1,0(s5)
8000587c:	01ca2503          	lw	a0,28(s4)
80005880:	ffffe097          	auipc	ra,0xffffe
80005884:	5bc080e7          	jalr	1468(ra) # 80003e3c <bread>
80005888:	00050993          	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
8000588c:	000b0613          	mv	a2,s6
80005890:	03850593          	addi	a1,a0,56
80005894:	03890513          	addi	a0,s2,56
80005898:	ffffb097          	auipc	ra,0xffffb
8000589c:	7bc080e7          	jalr	1980(ra) # 80001054 <memmove>
    bwrite(to);  // write the log
800058a0:	00090513          	mv	a0,s2
800058a4:	ffffe097          	auipc	ra,0xffffe
800058a8:	6d8080e7          	jalr	1752(ra) # 80003f7c <bwrite>
    brelse(from);
800058ac:	00098513          	mv	a0,s3
800058b0:	ffffe097          	auipc	ra,0xffffe
800058b4:	728080e7          	jalr	1832(ra) # 80003fd8 <brelse>
    brelse(to);
800058b8:	00090513          	mv	a0,s2
800058bc:	ffffe097          	auipc	ra,0xffffe
800058c0:	71c080e7          	jalr	1820(ra) # 80003fd8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
800058c4:	00148493          	addi	s1,s1,1
800058c8:	004a8a93          	addi	s5,s5,4
800058cc:	020a2783          	lw	a5,32(s4)
800058d0:	f8f4c6e3          	blt	s1,a5,8000585c <end_op+0x118>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
800058d4:	00000097          	auipc	ra,0x0
800058d8:	b5c080e7          	jalr	-1188(ra) # 80005430 <write_head>
    install_trans(); // Now install writes to home locations
800058dc:	00000097          	auipc	ra,0x0
800058e0:	bec080e7          	jalr	-1044(ra) # 800054c8 <install_trans>
    log.lh.n = 0;
800058e4:	0001c797          	auipc	a5,0x1c
800058e8:	5607ae23          	sw	zero,1404(a5) # 80021e60 <log+0x20>
    write_head();    // Erase the transaction from the log
800058ec:	00000097          	auipc	ra,0x0
800058f0:	b44080e7          	jalr	-1212(ra) # 80005430 <write_head>
800058f4:	00c12983          	lw	s3,12(sp)
800058f8:	00812a03          	lw	s4,8(sp)
800058fc:	00412a83          	lw	s5,4(sp)
80005900:	00012b03          	lw	s6,0(sp)
80005904:	ea9ff06f          	j	800057ac <end_op+0x68>

80005908 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80005908:	ff010113          	addi	sp,sp,-16
8000590c:	00112623          	sw	ra,12(sp)
80005910:	00812423          	sw	s0,8(sp)
80005914:	00912223          	sw	s1,4(sp)
80005918:	01212023          	sw	s2,0(sp)
8000591c:	01010413          	addi	s0,sp,16
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80005920:	0001c717          	auipc	a4,0x1c
80005924:	54072703          	lw	a4,1344(a4) # 80021e60 <log+0x20>
80005928:	01d00793          	li	a5,29
8000592c:	0ae7c263          	blt	a5,a4,800059d0 <log_write+0xc8>
80005930:	00050493          	mv	s1,a0
80005934:	0001c797          	auipc	a5,0x1c
80005938:	51c7a783          	lw	a5,1308(a5) # 80021e50 <log+0x10>
8000593c:	fff78793          	addi	a5,a5,-1
80005940:	08f75863          	bge	a4,a5,800059d0 <log_write+0xc8>
    panic("too big a transaction");
  if (log.outstanding < 1)
80005944:	0001c797          	auipc	a5,0x1c
80005948:	5107a783          	lw	a5,1296(a5) # 80021e54 <log+0x14>
8000594c:	08f05a63          	blez	a5,800059e0 <log_write+0xd8>
    panic("log_write outside of trans");

  acquire(&log.lock);
80005950:	0001c917          	auipc	s2,0x1c
80005954:	4f090913          	addi	s2,s2,1264 # 80021e40 <log>
80005958:	00090513          	mv	a0,s2
8000595c:	ffffb097          	auipc	ra,0xffffb
80005960:	598080e7          	jalr	1432(ra) # 80000ef4 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80005964:	02092603          	lw	a2,32(s2)
80005968:	08c05463          	blez	a2,800059f0 <log_write+0xe8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8000596c:	00c4a583          	lw	a1,12(s1)
80005970:	0001c717          	auipc	a4,0x1c
80005974:	4f470713          	addi	a4,a4,1268 # 80021e64 <log+0x24>
  for (i = 0; i < log.lh.n; i++) {
80005978:	00000793          	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8000597c:	00072683          	lw	a3,0(a4)
80005980:	06b68a63          	beq	a3,a1,800059f4 <log_write+0xec>
  for (i = 0; i < log.lh.n; i++) {
80005984:	00178793          	addi	a5,a5,1
80005988:	00470713          	addi	a4,a4,4
8000598c:	fec798e3          	bne	a5,a2,8000597c <log_write+0x74>
      break;
  }
  log.lh.block[i] = b->blockno;
80005990:	00860613          	addi	a2,a2,8
80005994:	00261613          	slli	a2,a2,0x2
80005998:	0001c797          	auipc	a5,0x1c
8000599c:	4a878793          	addi	a5,a5,1192 # 80021e40 <log>
800059a0:	00c787b3          	add	a5,a5,a2
800059a4:	00c4a703          	lw	a4,12(s1)
800059a8:	00e7a223          	sw	a4,4(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
800059ac:	00048513          	mv	a0,s1
800059b0:	ffffe097          	auipc	ra,0xffffe
800059b4:	6f8080e7          	jalr	1784(ra) # 800040a8 <bpin>
    log.lh.n++;
800059b8:	0001c717          	auipc	a4,0x1c
800059bc:	48870713          	addi	a4,a4,1160 # 80021e40 <log>
800059c0:	02072783          	lw	a5,32(a4)
800059c4:	00178793          	addi	a5,a5,1
800059c8:	02f72023          	sw	a5,32(a4)
800059cc:	0480006f          	j	80005a14 <log_write+0x10c>
    panic("too big a transaction");
800059d0:	00006517          	auipc	a0,0x6
800059d4:	38450513          	addi	a0,a0,900 # 8000bd54 <userret+0x2cb4>
800059d8:	ffffb097          	auipc	ra,0xffffb
800059dc:	d28080e7          	jalr	-728(ra) # 80000700 <panic>
    panic("log_write outside of trans");
800059e0:	00006517          	auipc	a0,0x6
800059e4:	38c50513          	addi	a0,a0,908 # 8000bd6c <userret+0x2ccc>
800059e8:	ffffb097          	auipc	ra,0xffffb
800059ec:	d18080e7          	jalr	-744(ra) # 80000700 <panic>
  for (i = 0; i < log.lh.n; i++) {
800059f0:	00000793          	li	a5,0
  log.lh.block[i] = b->blockno;
800059f4:	00878693          	addi	a3,a5,8
800059f8:	00269693          	slli	a3,a3,0x2
800059fc:	0001c717          	auipc	a4,0x1c
80005a00:	44470713          	addi	a4,a4,1092 # 80021e40 <log>
80005a04:	00d70733          	add	a4,a4,a3
80005a08:	00c4a683          	lw	a3,12(s1)
80005a0c:	00d72223          	sw	a3,4(a4)
  if (i == log.lh.n) {  // Add new block to log?
80005a10:	f8f60ee3          	beq	a2,a5,800059ac <log_write+0xa4>
  }
  release(&log.lock);
80005a14:	0001c517          	auipc	a0,0x1c
80005a18:	42c50513          	addi	a0,a0,1068 # 80021e40 <log>
80005a1c:	ffffb097          	auipc	ra,0xffffb
80005a20:	54c080e7          	jalr	1356(ra) # 80000f68 <release>
}
80005a24:	00c12083          	lw	ra,12(sp)
80005a28:	00812403          	lw	s0,8(sp)
80005a2c:	00412483          	lw	s1,4(sp)
80005a30:	00012903          	lw	s2,0(sp)
80005a34:	01010113          	addi	sp,sp,16
80005a38:	00008067          	ret

80005a3c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80005a3c:	ff010113          	addi	sp,sp,-16
80005a40:	00112623          	sw	ra,12(sp)
80005a44:	00812423          	sw	s0,8(sp)
80005a48:	00912223          	sw	s1,4(sp)
80005a4c:	01212023          	sw	s2,0(sp)
80005a50:	01010413          	addi	s0,sp,16
80005a54:	00050493          	mv	s1,a0
80005a58:	00058913          	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
80005a5c:	00006597          	auipc	a1,0x6
80005a60:	32c58593          	addi	a1,a1,812 # 8000bd88 <userret+0x2ce8>
80005a64:	00450513          	addi	a0,a0,4
80005a68:	ffffb097          	auipc	ra,0xffffb
80005a6c:	300080e7          	jalr	768(ra) # 80000d68 <initlock>
  lk->name = name;
80005a70:	0124a823          	sw	s2,16(s1)
  lk->locked = 0;
80005a74:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
80005a78:	0004aa23          	sw	zero,20(s1)
}
80005a7c:	00c12083          	lw	ra,12(sp)
80005a80:	00812403          	lw	s0,8(sp)
80005a84:	00412483          	lw	s1,4(sp)
80005a88:	00012903          	lw	s2,0(sp)
80005a8c:	01010113          	addi	sp,sp,16
80005a90:	00008067          	ret

80005a94 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80005a94:	ff010113          	addi	sp,sp,-16
80005a98:	00112623          	sw	ra,12(sp)
80005a9c:	00812423          	sw	s0,8(sp)
80005aa0:	00912223          	sw	s1,4(sp)
80005aa4:	01212023          	sw	s2,0(sp)
80005aa8:	01010413          	addi	s0,sp,16
80005aac:	00050493          	mv	s1,a0
  acquire(&lk->lk);
80005ab0:	00450913          	addi	s2,a0,4
80005ab4:	00090513          	mv	a0,s2
80005ab8:	ffffb097          	auipc	ra,0xffffb
80005abc:	43c080e7          	jalr	1084(ra) # 80000ef4 <acquire>
  while (lk->locked) {
80005ac0:	0004a783          	lw	a5,0(s1)
80005ac4:	00078e63          	beqz	a5,80005ae0 <acquiresleep+0x4c>
    sleep(lk, &lk->lk);
80005ac8:	00090593          	mv	a1,s2
80005acc:	00048513          	mv	a0,s1
80005ad0:	ffffd097          	auipc	ra,0xffffd
80005ad4:	250080e7          	jalr	592(ra) # 80002d20 <sleep>
  while (lk->locked) {
80005ad8:	0004a783          	lw	a5,0(s1)
80005adc:	fe0796e3          	bnez	a5,80005ac8 <acquiresleep+0x34>
  }
  lk->locked = 1;
80005ae0:	00100793          	li	a5,1
80005ae4:	00f4a023          	sw	a5,0(s1)
  lk->pid = myproc()->pid;
80005ae8:	ffffc097          	auipc	ra,0xffffc
80005aec:	7f4080e7          	jalr	2036(ra) # 800022dc <myproc>
80005af0:	02052783          	lw	a5,32(a0)
80005af4:	00f4aa23          	sw	a5,20(s1)
  release(&lk->lk);
80005af8:	00090513          	mv	a0,s2
80005afc:	ffffb097          	auipc	ra,0xffffb
80005b00:	46c080e7          	jalr	1132(ra) # 80000f68 <release>
}
80005b04:	00c12083          	lw	ra,12(sp)
80005b08:	00812403          	lw	s0,8(sp)
80005b0c:	00412483          	lw	s1,4(sp)
80005b10:	00012903          	lw	s2,0(sp)
80005b14:	01010113          	addi	sp,sp,16
80005b18:	00008067          	ret

80005b1c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80005b1c:	ff010113          	addi	sp,sp,-16
80005b20:	00112623          	sw	ra,12(sp)
80005b24:	00812423          	sw	s0,8(sp)
80005b28:	00912223          	sw	s1,4(sp)
80005b2c:	01212023          	sw	s2,0(sp)
80005b30:	01010413          	addi	s0,sp,16
80005b34:	00050493          	mv	s1,a0
  acquire(&lk->lk);
80005b38:	00450913          	addi	s2,a0,4
80005b3c:	00090513          	mv	a0,s2
80005b40:	ffffb097          	auipc	ra,0xffffb
80005b44:	3b4080e7          	jalr	948(ra) # 80000ef4 <acquire>
  lk->locked = 0;
80005b48:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
80005b4c:	0004aa23          	sw	zero,20(s1)
  wakeup(lk);
80005b50:	00048513          	mv	a0,s1
80005b54:	ffffd097          	auipc	ra,0xffffd
80005b58:	3dc080e7          	jalr	988(ra) # 80002f30 <wakeup>
  release(&lk->lk);
80005b5c:	00090513          	mv	a0,s2
80005b60:	ffffb097          	auipc	ra,0xffffb
80005b64:	408080e7          	jalr	1032(ra) # 80000f68 <release>
}
80005b68:	00c12083          	lw	ra,12(sp)
80005b6c:	00812403          	lw	s0,8(sp)
80005b70:	00412483          	lw	s1,4(sp)
80005b74:	00012903          	lw	s2,0(sp)
80005b78:	01010113          	addi	sp,sp,16
80005b7c:	00008067          	ret

80005b80 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80005b80:	fe010113          	addi	sp,sp,-32
80005b84:	00112e23          	sw	ra,28(sp)
80005b88:	00812c23          	sw	s0,24(sp)
80005b8c:	00912a23          	sw	s1,20(sp)
80005b90:	01212823          	sw	s2,16(sp)
80005b94:	02010413          	addi	s0,sp,32
80005b98:	00050493          	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
80005b9c:	00450913          	addi	s2,a0,4
80005ba0:	00090513          	mv	a0,s2
80005ba4:	ffffb097          	auipc	ra,0xffffb
80005ba8:	350080e7          	jalr	848(ra) # 80000ef4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80005bac:	0004a783          	lw	a5,0(s1)
80005bb0:	02079863          	bnez	a5,80005be0 <holdingsleep+0x60>
80005bb4:	00000493          	li	s1,0
  release(&lk->lk);
80005bb8:	00090513          	mv	a0,s2
80005bbc:	ffffb097          	auipc	ra,0xffffb
80005bc0:	3ac080e7          	jalr	940(ra) # 80000f68 <release>
  return r;
}
80005bc4:	00048513          	mv	a0,s1
80005bc8:	01c12083          	lw	ra,28(sp)
80005bcc:	01812403          	lw	s0,24(sp)
80005bd0:	01412483          	lw	s1,20(sp)
80005bd4:	01012903          	lw	s2,16(sp)
80005bd8:	02010113          	addi	sp,sp,32
80005bdc:	00008067          	ret
80005be0:	01312623          	sw	s3,12(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
80005be4:	0144a983          	lw	s3,20(s1)
80005be8:	ffffc097          	auipc	ra,0xffffc
80005bec:	6f4080e7          	jalr	1780(ra) # 800022dc <myproc>
80005bf0:	02052483          	lw	s1,32(a0)
80005bf4:	413484b3          	sub	s1,s1,s3
80005bf8:	0014b493          	seqz	s1,s1
80005bfc:	00c12983          	lw	s3,12(sp)
80005c00:	fb9ff06f          	j	80005bb8 <holdingsleep+0x38>

80005c04 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80005c04:	ff010113          	addi	sp,sp,-16
80005c08:	00112623          	sw	ra,12(sp)
80005c0c:	00812423          	sw	s0,8(sp)
80005c10:	01010413          	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
80005c14:	00006597          	auipc	a1,0x6
80005c18:	18058593          	addi	a1,a1,384 # 8000bd94 <userret+0x2cf4>
80005c1c:	0001c517          	auipc	a0,0x1c
80005c20:	31050513          	addi	a0,a0,784 # 80021f2c <ftable>
80005c24:	ffffb097          	auipc	ra,0xffffb
80005c28:	144080e7          	jalr	324(ra) # 80000d68 <initlock>
}
80005c2c:	00c12083          	lw	ra,12(sp)
80005c30:	00812403          	lw	s0,8(sp)
80005c34:	01010113          	addi	sp,sp,16
80005c38:	00008067          	ret

80005c3c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80005c3c:	ff010113          	addi	sp,sp,-16
80005c40:	00112623          	sw	ra,12(sp)
80005c44:	00812423          	sw	s0,8(sp)
80005c48:	00912223          	sw	s1,4(sp)
80005c4c:	01010413          	addi	s0,sp,16
  struct file *f;

  acquire(&ftable.lock);
80005c50:	0001c517          	auipc	a0,0x1c
80005c54:	2dc50513          	addi	a0,a0,732 # 80021f2c <ftable>
80005c58:	ffffb097          	auipc	ra,0xffffb
80005c5c:	29c080e7          	jalr	668(ra) # 80000ef4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80005c60:	0001c497          	auipc	s1,0x1c
80005c64:	2d848493          	addi	s1,s1,728 # 80021f38 <ftable+0xc>
80005c68:	0001d717          	auipc	a4,0x1d
80005c6c:	dc070713          	addi	a4,a4,-576 # 80022a28 <ftable+0xafc>
    if(f->ref == 0){
80005c70:	0044a783          	lw	a5,4(s1)
80005c74:	02078263          	beqz	a5,80005c98 <filealloc+0x5c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80005c78:	01c48493          	addi	s1,s1,28
80005c7c:	fee49ae3          	bne	s1,a4,80005c70 <filealloc+0x34>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80005c80:	0001c517          	auipc	a0,0x1c
80005c84:	2ac50513          	addi	a0,a0,684 # 80021f2c <ftable>
80005c88:	ffffb097          	auipc	ra,0xffffb
80005c8c:	2e0080e7          	jalr	736(ra) # 80000f68 <release>
  return 0;
80005c90:	00000493          	li	s1,0
80005c94:	01c0006f          	j	80005cb0 <filealloc+0x74>
      f->ref = 1;
80005c98:	00100793          	li	a5,1
80005c9c:	00f4a223          	sw	a5,4(s1)
      release(&ftable.lock);
80005ca0:	0001c517          	auipc	a0,0x1c
80005ca4:	28c50513          	addi	a0,a0,652 # 80021f2c <ftable>
80005ca8:	ffffb097          	auipc	ra,0xffffb
80005cac:	2c0080e7          	jalr	704(ra) # 80000f68 <release>
}
80005cb0:	00048513          	mv	a0,s1
80005cb4:	00c12083          	lw	ra,12(sp)
80005cb8:	00812403          	lw	s0,8(sp)
80005cbc:	00412483          	lw	s1,4(sp)
80005cc0:	01010113          	addi	sp,sp,16
80005cc4:	00008067          	ret

80005cc8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80005cc8:	ff010113          	addi	sp,sp,-16
80005ccc:	00112623          	sw	ra,12(sp)
80005cd0:	00812423          	sw	s0,8(sp)
80005cd4:	00912223          	sw	s1,4(sp)
80005cd8:	01010413          	addi	s0,sp,16
80005cdc:	00050493          	mv	s1,a0
  acquire(&ftable.lock);
80005ce0:	0001c517          	auipc	a0,0x1c
80005ce4:	24c50513          	addi	a0,a0,588 # 80021f2c <ftable>
80005ce8:	ffffb097          	auipc	ra,0xffffb
80005cec:	20c080e7          	jalr	524(ra) # 80000ef4 <acquire>
  if(f->ref < 1)
80005cf0:	0044a783          	lw	a5,4(s1)
80005cf4:	02f05a63          	blez	a5,80005d28 <filedup+0x60>
    panic("filedup");
  f->ref++;
80005cf8:	00178793          	addi	a5,a5,1
80005cfc:	00f4a223          	sw	a5,4(s1)
  release(&ftable.lock);
80005d00:	0001c517          	auipc	a0,0x1c
80005d04:	22c50513          	addi	a0,a0,556 # 80021f2c <ftable>
80005d08:	ffffb097          	auipc	ra,0xffffb
80005d0c:	260080e7          	jalr	608(ra) # 80000f68 <release>
  return f;
}
80005d10:	00048513          	mv	a0,s1
80005d14:	00c12083          	lw	ra,12(sp)
80005d18:	00812403          	lw	s0,8(sp)
80005d1c:	00412483          	lw	s1,4(sp)
80005d20:	01010113          	addi	sp,sp,16
80005d24:	00008067          	ret
    panic("filedup");
80005d28:	00006517          	auipc	a0,0x6
80005d2c:	07450513          	addi	a0,a0,116 # 8000bd9c <userret+0x2cfc>
80005d30:	ffffb097          	auipc	ra,0xffffb
80005d34:	9d0080e7          	jalr	-1584(ra) # 80000700 <panic>

80005d38 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80005d38:	fe010113          	addi	sp,sp,-32
80005d3c:	00112e23          	sw	ra,28(sp)
80005d40:	00812c23          	sw	s0,24(sp)
80005d44:	00912a23          	sw	s1,20(sp)
80005d48:	02010413          	addi	s0,sp,32
80005d4c:	00050493          	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
80005d50:	0001c517          	auipc	a0,0x1c
80005d54:	1dc50513          	addi	a0,a0,476 # 80021f2c <ftable>
80005d58:	ffffb097          	auipc	ra,0xffffb
80005d5c:	19c080e7          	jalr	412(ra) # 80000ef4 <acquire>
  if(f->ref < 1)
80005d60:	0044a783          	lw	a5,4(s1)
80005d64:	06f05863          	blez	a5,80005dd4 <fileclose+0x9c>
    panic("fileclose");
  if(--f->ref > 0){
80005d68:	fff78793          	addi	a5,a5,-1
80005d6c:	00f4a223          	sw	a5,4(s1)
80005d70:	08f04263          	bgtz	a5,80005df4 <fileclose+0xbc>
80005d74:	01212823          	sw	s2,16(sp)
80005d78:	01312623          	sw	s3,12(sp)
80005d7c:	01412423          	sw	s4,8(sp)
80005d80:	01512223          	sw	s5,4(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
80005d84:	0004a903          	lw	s2,0(s1)
80005d88:	0094ca83          	lbu	s5,9(s1)
80005d8c:	00c4aa03          	lw	s4,12(s1)
80005d90:	0104a983          	lw	s3,16(s1)
  f->ref = 0;
80005d94:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
80005d98:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
80005d9c:	0001c517          	auipc	a0,0x1c
80005da0:	19050513          	addi	a0,a0,400 # 80021f2c <ftable>
80005da4:	ffffb097          	auipc	ra,0xffffb
80005da8:	1c4080e7          	jalr	452(ra) # 80000f68 <release>

  if(ff.type == FD_PIPE){
80005dac:	00100793          	li	a5,1
80005db0:	06f90463          	beq	s2,a5,80005e18 <fileclose+0xe0>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
80005db4:	ffe90913          	addi	s2,s2,-2
80005db8:	00100793          	li	a5,1
80005dbc:	0927f063          	bgeu	a5,s2,80005e3c <fileclose+0x104>
80005dc0:	01012903          	lw	s2,16(sp)
80005dc4:	00c12983          	lw	s3,12(sp)
80005dc8:	00812a03          	lw	s4,8(sp)
80005dcc:	00412a83          	lw	s5,4(sp)
80005dd0:	0340006f          	j	80005e04 <fileclose+0xcc>
80005dd4:	01212823          	sw	s2,16(sp)
80005dd8:	01312623          	sw	s3,12(sp)
80005ddc:	01412423          	sw	s4,8(sp)
80005de0:	01512223          	sw	s5,4(sp)
    panic("fileclose");
80005de4:	00006517          	auipc	a0,0x6
80005de8:	fc050513          	addi	a0,a0,-64 # 8000bda4 <userret+0x2d04>
80005dec:	ffffb097          	auipc	ra,0xffffb
80005df0:	914080e7          	jalr	-1772(ra) # 80000700 <panic>
    release(&ftable.lock);
80005df4:	0001c517          	auipc	a0,0x1c
80005df8:	13850513          	addi	a0,a0,312 # 80021f2c <ftable>
80005dfc:	ffffb097          	auipc	ra,0xffffb
80005e00:	16c080e7          	jalr	364(ra) # 80000f68 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80005e04:	01c12083          	lw	ra,28(sp)
80005e08:	01812403          	lw	s0,24(sp)
80005e0c:	01412483          	lw	s1,20(sp)
80005e10:	02010113          	addi	sp,sp,32
80005e14:	00008067          	ret
    pipeclose(ff.pipe, ff.writable);
80005e18:	000a8593          	mv	a1,s5
80005e1c:	000a0513          	mv	a0,s4
80005e20:	00000097          	auipc	ra,0x0
80005e24:	57c080e7          	jalr	1404(ra) # 8000639c <pipeclose>
80005e28:	01012903          	lw	s2,16(sp)
80005e2c:	00c12983          	lw	s3,12(sp)
80005e30:	00812a03          	lw	s4,8(sp)
80005e34:	00412a83          	lw	s5,4(sp)
80005e38:	fcdff06f          	j	80005e04 <fileclose+0xcc>
    begin_op();
80005e3c:	00000097          	auipc	ra,0x0
80005e40:	858080e7          	jalr	-1960(ra) # 80005694 <begin_op>
    iput(ff.ip);
80005e44:	00098513          	mv	a0,s3
80005e48:	fffff097          	auipc	ra,0xfffff
80005e4c:	c14080e7          	jalr	-1004(ra) # 80004a5c <iput>
    end_op();
80005e50:	00000097          	auipc	ra,0x0
80005e54:	8f4080e7          	jalr	-1804(ra) # 80005744 <end_op>
80005e58:	01012903          	lw	s2,16(sp)
80005e5c:	00c12983          	lw	s3,12(sp)
80005e60:	00812a03          	lw	s4,8(sp)
80005e64:	00412a83          	lw	s5,4(sp)
80005e68:	f9dff06f          	j	80005e04 <fileclose+0xcc>

80005e6c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint32 addr)
{
80005e6c:	fc010113          	addi	sp,sp,-64
80005e70:	02112e23          	sw	ra,60(sp)
80005e74:	02812c23          	sw	s0,56(sp)
80005e78:	02912a23          	sw	s1,52(sp)
80005e7c:	03312623          	sw	s3,44(sp)
80005e80:	04010413          	addi	s0,sp,64
80005e84:	00050493          	mv	s1,a0
80005e88:	00058993          	mv	s3,a1
  struct proc *p = myproc();
80005e8c:	ffffc097          	auipc	ra,0xffffc
80005e90:	450080e7          	jalr	1104(ra) # 800022dc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
80005e94:	0004a783          	lw	a5,0(s1)
80005e98:	ffe78793          	addi	a5,a5,-2
80005e9c:	00100713          	li	a4,1
80005ea0:	06f76c63          	bltu	a4,a5,80005f18 <filestat+0xac>
80005ea4:	03212823          	sw	s2,48(sp)
80005ea8:	03412423          	sw	s4,40(sp)
80005eac:	00050913          	mv	s2,a0
    ilock(f->ip);
80005eb0:	0104a503          	lw	a0,16(s1)
80005eb4:	fffff097          	auipc	ra,0xfffff
80005eb8:	a2c080e7          	jalr	-1492(ra) # 800048e0 <ilock>
    stati(f->ip, &st);
80005ebc:	fc840a13          	addi	s4,s0,-56
80005ec0:	000a0593          	mv	a1,s4
80005ec4:	0104a503          	lw	a0,16(s1)
80005ec8:	fffff097          	auipc	ra,0xfffff
80005ecc:	d64080e7          	jalr	-668(ra) # 80004c2c <stati>
    iunlock(f->ip);
80005ed0:	0104a503          	lw	a0,16(s1)
80005ed4:	fffff097          	auipc	ra,0xfffff
80005ed8:	b18080e7          	jalr	-1256(ra) # 800049ec <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
80005edc:	01800693          	li	a3,24
80005ee0:	000a0613          	mv	a2,s4
80005ee4:	00098593          	mv	a1,s3
80005ee8:	02c92503          	lw	a0,44(s2)
80005eec:	ffffc097          	auipc	ra,0xffffc
80005ef0:	f30080e7          	jalr	-208(ra) # 80001e1c <copyout>
80005ef4:	41f55513          	srai	a0,a0,0x1f
80005ef8:	03012903          	lw	s2,48(sp)
80005efc:	02812a03          	lw	s4,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
80005f00:	03c12083          	lw	ra,60(sp)
80005f04:	03812403          	lw	s0,56(sp)
80005f08:	03412483          	lw	s1,52(sp)
80005f0c:	02c12983          	lw	s3,44(sp)
80005f10:	04010113          	addi	sp,sp,64
80005f14:	00008067          	ret
  return -1;
80005f18:	fff00513          	li	a0,-1
80005f1c:	fe5ff06f          	j	80005f00 <filestat+0x94>

80005f20 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint32 addr, int n)
{
80005f20:	fe010113          	addi	sp,sp,-32
80005f24:	00112e23          	sw	ra,28(sp)
80005f28:	00812c23          	sw	s0,24(sp)
80005f2c:	01212823          	sw	s2,16(sp)
80005f30:	02010413          	addi	s0,sp,32
  int r = 0;

  if(f->readable == 0)
80005f34:	00854783          	lbu	a5,8(a0)
80005f38:	10078663          	beqz	a5,80006044 <fileread+0x124>
80005f3c:	00912a23          	sw	s1,20(sp)
80005f40:	01312623          	sw	s3,12(sp)
80005f44:	00050493          	mv	s1,a0
80005f48:	00058993          	mv	s3,a1
80005f4c:	00060913          	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
80005f50:	00052783          	lw	a5,0(a0)
80005f54:	00100713          	li	a4,1
80005f58:	06e78e63          	beq	a5,a4,80005fd4 <fileread+0xb4>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
80005f5c:	00300713          	li	a4,3
80005f60:	08e78863          	beq	a5,a4,80005ff0 <fileread+0xd0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
80005f64:	00200713          	li	a4,2
80005f68:	0ce79663          	bne	a5,a4,80006034 <fileread+0x114>
    ilock(f->ip);
80005f6c:	01052503          	lw	a0,16(a0)
80005f70:	fffff097          	auipc	ra,0xfffff
80005f74:	970080e7          	jalr	-1680(ra) # 800048e0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
80005f78:	00090713          	mv	a4,s2
80005f7c:	0144a683          	lw	a3,20(s1)
80005f80:	00098613          	mv	a2,s3
80005f84:	00100593          	li	a1,1
80005f88:	0104a503          	lw	a0,16(s1)
80005f8c:	fffff097          	auipc	ra,0xfffff
80005f90:	cec080e7          	jalr	-788(ra) # 80004c78 <readi>
80005f94:	00050913          	mv	s2,a0
80005f98:	00a05863          	blez	a0,80005fa8 <fileread+0x88>
      f->off += r;
80005f9c:	0144a783          	lw	a5,20(s1)
80005fa0:	00a787b3          	add	a5,a5,a0
80005fa4:	00f4aa23          	sw	a5,20(s1)
    iunlock(f->ip);
80005fa8:	0104a503          	lw	a0,16(s1)
80005fac:	fffff097          	auipc	ra,0xfffff
80005fb0:	a40080e7          	jalr	-1472(ra) # 800049ec <iunlock>
80005fb4:	01412483          	lw	s1,20(sp)
80005fb8:	00c12983          	lw	s3,12(sp)
  } else {
    panic("fileread");
  }

  return r;
}
80005fbc:	00090513          	mv	a0,s2
80005fc0:	01c12083          	lw	ra,28(sp)
80005fc4:	01812403          	lw	s0,24(sp)
80005fc8:	01012903          	lw	s2,16(sp)
80005fcc:	02010113          	addi	sp,sp,32
80005fd0:	00008067          	ret
    r = piperead(f->pipe, addr, n);
80005fd4:	00c52503          	lw	a0,12(a0)
80005fd8:	00000097          	auipc	ra,0x0
80005fdc:	5d4080e7          	jalr	1492(ra) # 800065ac <piperead>
80005fe0:	00050913          	mv	s2,a0
80005fe4:	01412483          	lw	s1,20(sp)
80005fe8:	00c12983          	lw	s3,12(sp)
80005fec:	fd1ff06f          	j	80005fbc <fileread+0x9c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
80005ff0:	01851783          	lh	a5,24(a0)
80005ff4:	01079693          	slli	a3,a5,0x10
80005ff8:	0106d693          	srli	a3,a3,0x10
80005ffc:	00900713          	li	a4,9
80006000:	04d76663          	bltu	a4,a3,8000604c <fileread+0x12c>
80006004:	00379793          	slli	a5,a5,0x3
80006008:	0001c717          	auipc	a4,0x1c
8000600c:	ed470713          	addi	a4,a4,-300 # 80021edc <devsw>
80006010:	00f707b3          	add	a5,a4,a5
80006014:	0007a783          	lw	a5,0(a5)
80006018:	04078263          	beqz	a5,8000605c <fileread+0x13c>
    r = devsw[f->major].read(1, addr, n);
8000601c:	00100513          	li	a0,1
80006020:	000780e7          	jalr	a5
80006024:	00050913          	mv	s2,a0
80006028:	01412483          	lw	s1,20(sp)
8000602c:	00c12983          	lw	s3,12(sp)
80006030:	f8dff06f          	j	80005fbc <fileread+0x9c>
    panic("fileread");
80006034:	00006517          	auipc	a0,0x6
80006038:	d7c50513          	addi	a0,a0,-644 # 8000bdb0 <userret+0x2d10>
8000603c:	ffffa097          	auipc	ra,0xffffa
80006040:	6c4080e7          	jalr	1732(ra) # 80000700 <panic>
    return -1;
80006044:	fff00913          	li	s2,-1
80006048:	f75ff06f          	j	80005fbc <fileread+0x9c>
      return -1;
8000604c:	fff00913          	li	s2,-1
80006050:	01412483          	lw	s1,20(sp)
80006054:	00c12983          	lw	s3,12(sp)
80006058:	f65ff06f          	j	80005fbc <fileread+0x9c>
8000605c:	fff00913          	li	s2,-1
80006060:	01412483          	lw	s1,20(sp)
80006064:	00c12983          	lw	s3,12(sp)
80006068:	f55ff06f          	j	80005fbc <fileread+0x9c>

8000606c <filewrite>:
int
filewrite(struct file *f, uint32 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
8000606c:	00954783          	lbu	a5,9(a0)
80006070:	1c078863          	beqz	a5,80006240 <filewrite+0x1d4>
{
80006074:	fd010113          	addi	sp,sp,-48
80006078:	02112623          	sw	ra,44(sp)
8000607c:	02812423          	sw	s0,40(sp)
80006080:	03212023          	sw	s2,32(sp)
80006084:	01512a23          	sw	s5,20(sp)
80006088:	01712623          	sw	s7,12(sp)
8000608c:	03010413          	addi	s0,sp,48
80006090:	00050913          	mv	s2,a0
80006094:	00058b93          	mv	s7,a1
80006098:	00060a93          	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
8000609c:	00052783          	lw	a5,0(a0)
800060a0:	00100713          	li	a4,1
800060a4:	04e78063          	beq	a5,a4,800060e4 <filewrite+0x78>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
800060a8:	00300713          	li	a4,3
800060ac:	04e78463          	beq	a5,a4,800060f4 <filewrite+0x88>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
800060b0:	00200713          	li	a4,2
800060b4:	16e79463          	bne	a5,a4,8000621c <filewrite+0x1b0>
800060b8:	01312e23          	sw	s3,28(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
800060bc:	14c05c63          	blez	a2,80006214 <filewrite+0x1a8>
800060c0:	02912223          	sw	s1,36(sp)
800060c4:	01412c23          	sw	s4,24(sp)
800060c8:	01612823          	sw	s6,16(sp)
800060cc:	01812423          	sw	s8,8(sp)
    int i = 0;
800060d0:	00000993          	li	s3,0
      int n1 = n - i;
      if(n1 > max)
800060d4:	00001b37          	lui	s6,0x1
800060d8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
800060dc:	00100c13          	li	s8,1
800060e0:	0b00006f          	j	80006190 <filewrite+0x124>
    ret = pipewrite(f->pipe, addr, n);
800060e4:	00c52503          	lw	a0,12(a0)
800060e8:	00000097          	auipc	ra,0x0
800060ec:	354080e7          	jalr	852(ra) # 8000643c <pipewrite>
800060f0:	0e40006f          	j	800061d4 <filewrite+0x168>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
800060f4:	01851783          	lh	a5,24(a0)
800060f8:	01079693          	slli	a3,a5,0x10
800060fc:	0106d693          	srli	a3,a3,0x10
80006100:	00900713          	li	a4,9
80006104:	14d76263          	bltu	a4,a3,80006248 <filewrite+0x1dc>
80006108:	00379793          	slli	a5,a5,0x3
8000610c:	0001c717          	auipc	a4,0x1c
80006110:	dd070713          	addi	a4,a4,-560 # 80021edc <devsw>
80006114:	00f707b3          	add	a5,a4,a5
80006118:	0047a783          	lw	a5,4(a5)
8000611c:	12078a63          	beqz	a5,80006250 <filewrite+0x1e4>
    ret = devsw[f->major].write(1, addr, n);
80006120:	00100513          	li	a0,1
80006124:	000780e7          	jalr	a5
80006128:	0ac0006f          	j	800061d4 <filewrite+0x168>
      begin_op();
8000612c:	fffff097          	auipc	ra,0xfffff
80006130:	568080e7          	jalr	1384(ra) # 80005694 <begin_op>
      ilock(f->ip);
80006134:	01092503          	lw	a0,16(s2)
80006138:	ffffe097          	auipc	ra,0xffffe
8000613c:	7a8080e7          	jalr	1960(ra) # 800048e0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
80006140:	000a0713          	mv	a4,s4
80006144:	01492683          	lw	a3,20(s2)
80006148:	01798633          	add	a2,s3,s7
8000614c:	000c0593          	mv	a1,s8
80006150:	01092503          	lw	a0,16(s2)
80006154:	fffff097          	auipc	ra,0xfffff
80006158:	c88080e7          	jalr	-888(ra) # 80004ddc <writei>
8000615c:	00050493          	mv	s1,a0
80006160:	04a05063          	blez	a0,800061a0 <filewrite+0x134>
        f->off += r;
80006164:	01492783          	lw	a5,20(s2)
80006168:	00a787b3          	add	a5,a5,a0
8000616c:	00f92a23          	sw	a5,20(s2)
      iunlock(f->ip);
80006170:	01092503          	lw	a0,16(s2)
80006174:	fffff097          	auipc	ra,0xfffff
80006178:	878080e7          	jalr	-1928(ra) # 800049ec <iunlock>
      end_op();
8000617c:	fffff097          	auipc	ra,0xfffff
80006180:	5c8080e7          	jalr	1480(ra) # 80005744 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80006184:	069a1663          	bne	s4,s1,800061f0 <filewrite+0x184>
        panic("short filewrite");
      i += r;
80006188:	009989b3          	add	s3,s3,s1
    while(i < n){
8000618c:	0759da63          	bge	s3,s5,80006200 <filewrite+0x194>
      int n1 = n - i;
80006190:	413a8a33          	sub	s4,s5,s3
      if(n1 > max)
80006194:	f94b5ce3          	bge	s6,s4,8000612c <filewrite+0xc0>
80006198:	000b0a13          	mv	s4,s6
8000619c:	f91ff06f          	j	8000612c <filewrite+0xc0>
      iunlock(f->ip);
800061a0:	01092503          	lw	a0,16(s2)
800061a4:	fffff097          	auipc	ra,0xfffff
800061a8:	848080e7          	jalr	-1976(ra) # 800049ec <iunlock>
      end_op();
800061ac:	fffff097          	auipc	ra,0xfffff
800061b0:	598080e7          	jalr	1432(ra) # 80005744 <end_op>
      if(r < 0)
800061b4:	fc04d8e3          	bgez	s1,80006184 <filewrite+0x118>
800061b8:	02412483          	lw	s1,36(sp)
800061bc:	01812a03          	lw	s4,24(sp)
800061c0:	01012b03          	lw	s6,16(sp)
800061c4:	00812c03          	lw	s8,8(sp)
    }
    ret = (i == n ? n : -1);
800061c8:	093a9863          	bne	s5,s3,80006258 <filewrite+0x1ec>
800061cc:	000a8513          	mv	a0,s5
800061d0:	01c12983          	lw	s3,28(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
800061d4:	02c12083          	lw	ra,44(sp)
800061d8:	02812403          	lw	s0,40(sp)
800061dc:	02012903          	lw	s2,32(sp)
800061e0:	01412a83          	lw	s5,20(sp)
800061e4:	00c12b83          	lw	s7,12(sp)
800061e8:	03010113          	addi	sp,sp,48
800061ec:	00008067          	ret
        panic("short filewrite");
800061f0:	00006517          	auipc	a0,0x6
800061f4:	bcc50513          	addi	a0,a0,-1076 # 8000bdbc <userret+0x2d1c>
800061f8:	ffffa097          	auipc	ra,0xffffa
800061fc:	508080e7          	jalr	1288(ra) # 80000700 <panic>
80006200:	02412483          	lw	s1,36(sp)
80006204:	01812a03          	lw	s4,24(sp)
80006208:	01012b03          	lw	s6,16(sp)
8000620c:	00812c03          	lw	s8,8(sp)
80006210:	fb9ff06f          	j	800061c8 <filewrite+0x15c>
    int i = 0;
80006214:	00000993          	li	s3,0
80006218:	fb1ff06f          	j	800061c8 <filewrite+0x15c>
8000621c:	02912223          	sw	s1,36(sp)
80006220:	01312e23          	sw	s3,28(sp)
80006224:	01412c23          	sw	s4,24(sp)
80006228:	01612823          	sw	s6,16(sp)
8000622c:	01812423          	sw	s8,8(sp)
    panic("filewrite");
80006230:	00006517          	auipc	a0,0x6
80006234:	b9c50513          	addi	a0,a0,-1124 # 8000bdcc <userret+0x2d2c>
80006238:	ffffa097          	auipc	ra,0xffffa
8000623c:	4c8080e7          	jalr	1224(ra) # 80000700 <panic>
    return -1;
80006240:	fff00513          	li	a0,-1
}
80006244:	00008067          	ret
      return -1;
80006248:	fff00513          	li	a0,-1
8000624c:	f89ff06f          	j	800061d4 <filewrite+0x168>
80006250:	fff00513          	li	a0,-1
80006254:	f81ff06f          	j	800061d4 <filewrite+0x168>
    ret = (i == n ? n : -1);
80006258:	fff00513          	li	a0,-1
8000625c:	01c12983          	lw	s3,28(sp)
80006260:	f75ff06f          	j	800061d4 <filewrite+0x168>

80006264 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80006264:	fe010113          	addi	sp,sp,-32
80006268:	00112e23          	sw	ra,28(sp)
8000626c:	00812c23          	sw	s0,24(sp)
80006270:	00912a23          	sw	s1,20(sp)
80006274:	01412423          	sw	s4,8(sp)
80006278:	02010413          	addi	s0,sp,32
8000627c:	00050493          	mv	s1,a0
80006280:	00058a13          	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
80006284:	0005a023          	sw	zero,0(a1)
80006288:	00052023          	sw	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8000628c:	00000097          	auipc	ra,0x0
80006290:	9b0080e7          	jalr	-1616(ra) # 80005c3c <filealloc>
80006294:	00a4a023          	sw	a0,0(s1)
80006298:	0c050463          	beqz	a0,80006360 <pipealloc+0xfc>
8000629c:	00000097          	auipc	ra,0x0
800062a0:	9a0080e7          	jalr	-1632(ra) # 80005c3c <filealloc>
800062a4:	00aa2023          	sw	a0,0(s4)
800062a8:	0a050463          	beqz	a0,80006350 <pipealloc+0xec>
800062ac:	01212823          	sw	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
800062b0:	ffffb097          	auipc	ra,0xffffb
800062b4:	a30080e7          	jalr	-1488(ra) # 80000ce0 <kalloc>
800062b8:	00050913          	mv	s2,a0
800062bc:	06050e63          	beqz	a0,80006338 <pipealloc+0xd4>
800062c0:	01312623          	sw	s3,12(sp)
    goto bad;
  pi->readopen = 1;
800062c4:	00100993          	li	s3,1
800062c8:	21352a23          	sw	s3,532(a0)
  pi->writeopen = 1;
800062cc:	21352c23          	sw	s3,536(a0)
  pi->nwrite = 0;
800062d0:	20052823          	sw	zero,528(a0)
  pi->nread = 0;
800062d4:	20052623          	sw	zero,524(a0)
  initlock(&pi->lock, "pipe");
800062d8:	00006597          	auipc	a1,0x6
800062dc:	b0058593          	addi	a1,a1,-1280 # 8000bdd8 <userret+0x2d38>
800062e0:	ffffb097          	auipc	ra,0xffffb
800062e4:	a88080e7          	jalr	-1400(ra) # 80000d68 <initlock>
  (*f0)->type = FD_PIPE;
800062e8:	0004a783          	lw	a5,0(s1)
800062ec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
800062f0:	0004a783          	lw	a5,0(s1)
800062f4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
800062f8:	0004a783          	lw	a5,0(s1)
800062fc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
80006300:	0004a783          	lw	a5,0(s1)
80006304:	0127a623          	sw	s2,12(a5)
  (*f1)->type = FD_PIPE;
80006308:	000a2783          	lw	a5,0(s4)
8000630c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
80006310:	000a2783          	lw	a5,0(s4)
80006314:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
80006318:	000a2783          	lw	a5,0(s4)
8000631c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
80006320:	000a2783          	lw	a5,0(s4)
80006324:	0127a623          	sw	s2,12(a5)
  return 0;
80006328:	00000513          	li	a0,0
8000632c:	01012903          	lw	s2,16(sp)
80006330:	00c12983          	lw	s3,12(sp)
80006334:	0480006f          	j	8000637c <pipealloc+0x118>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
80006338:	0004a503          	lw	a0,0(s1)
8000633c:	00050663          	beqz	a0,80006348 <pipealloc+0xe4>
80006340:	01012903          	lw	s2,16(sp)
80006344:	0140006f          	j	80006358 <pipealloc+0xf4>
80006348:	01012903          	lw	s2,16(sp)
8000634c:	0140006f          	j	80006360 <pipealloc+0xfc>
80006350:	0004a503          	lw	a0,0(s1)
80006354:	04050063          	beqz	a0,80006394 <pipealloc+0x130>
    fileclose(*f0);
80006358:	00000097          	auipc	ra,0x0
8000635c:	9e0080e7          	jalr	-1568(ra) # 80005d38 <fileclose>
  if(*f1)
80006360:	000a2783          	lw	a5,0(s4)
    fileclose(*f1);
  return -1;
80006364:	fff00513          	li	a0,-1
  if(*f1)
80006368:	00078a63          	beqz	a5,8000637c <pipealloc+0x118>
    fileclose(*f1);
8000636c:	00078513          	mv	a0,a5
80006370:	00000097          	auipc	ra,0x0
80006374:	9c8080e7          	jalr	-1592(ra) # 80005d38 <fileclose>
  return -1;
80006378:	fff00513          	li	a0,-1
}
8000637c:	01c12083          	lw	ra,28(sp)
80006380:	01812403          	lw	s0,24(sp)
80006384:	01412483          	lw	s1,20(sp)
80006388:	00812a03          	lw	s4,8(sp)
8000638c:	02010113          	addi	sp,sp,32
80006390:	00008067          	ret
  return -1;
80006394:	fff00513          	li	a0,-1
80006398:	fe5ff06f          	j	8000637c <pipealloc+0x118>

8000639c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
8000639c:	ff010113          	addi	sp,sp,-16
800063a0:	00112623          	sw	ra,12(sp)
800063a4:	00812423          	sw	s0,8(sp)
800063a8:	00912223          	sw	s1,4(sp)
800063ac:	01212023          	sw	s2,0(sp)
800063b0:	01010413          	addi	s0,sp,16
800063b4:	00050493          	mv	s1,a0
800063b8:	00058913          	mv	s2,a1
  acquire(&pi->lock);
800063bc:	ffffb097          	auipc	ra,0xffffb
800063c0:	b38080e7          	jalr	-1224(ra) # 80000ef4 <acquire>
  if(writable){
800063c4:	04090463          	beqz	s2,8000640c <pipeclose+0x70>
    pi->writeopen = 0;
800063c8:	2004ac23          	sw	zero,536(s1)
    wakeup(&pi->nread);
800063cc:	20c48513          	addi	a0,s1,524
800063d0:	ffffd097          	auipc	ra,0xffffd
800063d4:	b60080e7          	jalr	-1184(ra) # 80002f30 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
800063d8:	2144a783          	lw	a5,532(s1)
800063dc:	00079663          	bnez	a5,800063e8 <pipeclose+0x4c>
800063e0:	2184a783          	lw	a5,536(s1)
800063e4:	02078e63          	beqz	a5,80006420 <pipeclose+0x84>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
800063e8:	00048513          	mv	a0,s1
800063ec:	ffffb097          	auipc	ra,0xffffb
800063f0:	b7c080e7          	jalr	-1156(ra) # 80000f68 <release>
}
800063f4:	00c12083          	lw	ra,12(sp)
800063f8:	00812403          	lw	s0,8(sp)
800063fc:	00412483          	lw	s1,4(sp)
80006400:	00012903          	lw	s2,0(sp)
80006404:	01010113          	addi	sp,sp,16
80006408:	00008067          	ret
    pi->readopen = 0;
8000640c:	2004aa23          	sw	zero,532(s1)
    wakeup(&pi->nwrite);
80006410:	21048513          	addi	a0,s1,528
80006414:	ffffd097          	auipc	ra,0xffffd
80006418:	b1c080e7          	jalr	-1252(ra) # 80002f30 <wakeup>
8000641c:	fbdff06f          	j	800063d8 <pipeclose+0x3c>
    release(&pi->lock);
80006420:	00048513          	mv	a0,s1
80006424:	ffffb097          	auipc	ra,0xffffb
80006428:	b44080e7          	jalr	-1212(ra) # 80000f68 <release>
    kfree((char*)pi);
8000642c:	00048513          	mv	a0,s1
80006430:	ffffa097          	auipc	ra,0xffffa
80006434:	74c080e7          	jalr	1868(ra) # 80000b7c <kfree>
80006438:	fbdff06f          	j	800063f4 <pipeclose+0x58>

8000643c <pipewrite>:

int
pipewrite(struct pipe *pi, uint32 addr, int n)
{
8000643c:	fc010113          	addi	sp,sp,-64
80006440:	02112e23          	sw	ra,60(sp)
80006444:	02812c23          	sw	s0,56(sp)
80006448:	02912a23          	sw	s1,52(sp)
8000644c:	03412423          	sw	s4,40(sp)
80006450:	03512223          	sw	s5,36(sp)
80006454:	03612023          	sw	s6,32(sp)
80006458:	04010413          	addi	s0,sp,64
8000645c:	00050493          	mv	s1,a0
80006460:	00058a93          	mv	s5,a1
80006464:	00060a13          	mv	s4,a2
  int i;
  char ch;
  struct proc *pr = myproc();
80006468:	ffffc097          	auipc	ra,0xffffc
8000646c:	e74080e7          	jalr	-396(ra) # 800022dc <myproc>
80006470:	00050b13          	mv	s6,a0

  acquire(&pi->lock);
80006474:	00048513          	mv	a0,s1
80006478:	ffffb097          	auipc	ra,0xffffb
8000647c:	a7c080e7          	jalr	-1412(ra) # 80000ef4 <acquire>
  for(i = 0; i < n; i++){
80006480:	11405663          	blez	s4,8000658c <pipewrite+0x150>
80006484:	03212823          	sw	s2,48(sp)
80006488:	03312623          	sw	s3,44(sp)
8000648c:	01712e23          	sw	s7,28(sp)
80006490:	015a0bb3          	add	s7,s4,s5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
80006494:	20c48993          	addi	s3,s1,524
      sleep(&pi->nwrite, &pi->lock);
80006498:	21048913          	addi	s2,s1,528
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
8000649c:	20c4a783          	lw	a5,524(s1)
800064a0:	20078793          	addi	a5,a5,512
800064a4:	2104a703          	lw	a4,528(s1)
800064a8:	04f71463          	bne	a4,a5,800064f0 <pipewrite+0xb4>
      if(pi->readopen == 0 || myproc()->killed){
800064ac:	2144a783          	lw	a5,532(s1)
800064b0:	08078a63          	beqz	a5,80006544 <pipewrite+0x108>
800064b4:	ffffc097          	auipc	ra,0xffffc
800064b8:	e28080e7          	jalr	-472(ra) # 800022dc <myproc>
800064bc:	01852783          	lw	a5,24(a0)
800064c0:	08079263          	bnez	a5,80006544 <pipewrite+0x108>
      wakeup(&pi->nread);
800064c4:	00098513          	mv	a0,s3
800064c8:	ffffd097          	auipc	ra,0xffffd
800064cc:	a68080e7          	jalr	-1432(ra) # 80002f30 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
800064d0:	00048593          	mv	a1,s1
800064d4:	00090513          	mv	a0,s2
800064d8:	ffffd097          	auipc	ra,0xffffd
800064dc:	848080e7          	jalr	-1976(ra) # 80002d20 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
800064e0:	20c4a783          	lw	a5,524(s1)
800064e4:	20078793          	addi	a5,a5,512
800064e8:	2104a703          	lw	a4,528(s1)
800064ec:	fcf700e3          	beq	a4,a5,800064ac <pipewrite+0x70>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
800064f0:	00100693          	li	a3,1
800064f4:	000a8613          	mv	a2,s5
800064f8:	fcf40593          	addi	a1,s0,-49
800064fc:	02cb2503          	lw	a0,44(s6)
80006500:	ffffc097          	auipc	ra,0xffffc
80006504:	a04080e7          	jalr	-1532(ra) # 80001f04 <copyin>
80006508:	fff00793          	li	a5,-1
8000650c:	06f50a63          	beq	a0,a5,80006580 <pipewrite+0x144>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
80006510:	2104a783          	lw	a5,528(s1)
80006514:	00178713          	addi	a4,a5,1
80006518:	20e4a823          	sw	a4,528(s1)
8000651c:	1ff7f793          	andi	a5,a5,511
80006520:	00f487b3          	add	a5,s1,a5
80006524:	fcf44703          	lbu	a4,-49(s0)
80006528:	00e78623          	sb	a4,12(a5)
  for(i = 0; i < n; i++){
8000652c:	001a8a93          	addi	s5,s5,1
80006530:	f77a96e3          	bne	s5,s7,8000649c <pipewrite+0x60>
80006534:	03012903          	lw	s2,48(sp)
80006538:	02c12983          	lw	s3,44(sp)
8000653c:	01c12b83          	lw	s7,28(sp)
80006540:	04c0006f          	j	8000658c <pipewrite+0x150>
        release(&pi->lock);
80006544:	00048513          	mv	a0,s1
80006548:	ffffb097          	auipc	ra,0xffffb
8000654c:	a20080e7          	jalr	-1504(ra) # 80000f68 <release>
        return -1;
80006550:	fff00513          	li	a0,-1
80006554:	03012903          	lw	s2,48(sp)
80006558:	02c12983          	lw	s3,44(sp)
8000655c:	01c12b83          	lw	s7,28(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return n;
}
80006560:	03c12083          	lw	ra,60(sp)
80006564:	03812403          	lw	s0,56(sp)
80006568:	03412483          	lw	s1,52(sp)
8000656c:	02812a03          	lw	s4,40(sp)
80006570:	02412a83          	lw	s5,36(sp)
80006574:	02012b03          	lw	s6,32(sp)
80006578:	04010113          	addi	sp,sp,64
8000657c:	00008067          	ret
80006580:	03012903          	lw	s2,48(sp)
80006584:	02c12983          	lw	s3,44(sp)
80006588:	01c12b83          	lw	s7,28(sp)
  wakeup(&pi->nread);
8000658c:	20c48513          	addi	a0,s1,524
80006590:	ffffd097          	auipc	ra,0xffffd
80006594:	9a0080e7          	jalr	-1632(ra) # 80002f30 <wakeup>
  release(&pi->lock);
80006598:	00048513          	mv	a0,s1
8000659c:	ffffb097          	auipc	ra,0xffffb
800065a0:	9cc080e7          	jalr	-1588(ra) # 80000f68 <release>
  return n;
800065a4:	000a0513          	mv	a0,s4
800065a8:	fb9ff06f          	j	80006560 <pipewrite+0x124>

800065ac <piperead>:

int
piperead(struct pipe *pi, uint32 addr, int n)
{
800065ac:	fc010113          	addi	sp,sp,-64
800065b0:	02112e23          	sw	ra,60(sp)
800065b4:	02812c23          	sw	s0,56(sp)
800065b8:	02912a23          	sw	s1,52(sp)
800065bc:	03212823          	sw	s2,48(sp)
800065c0:	03312623          	sw	s3,44(sp)
800065c4:	03412423          	sw	s4,40(sp)
800065c8:	03512223          	sw	s5,36(sp)
800065cc:	04010413          	addi	s0,sp,64
800065d0:	00050493          	mv	s1,a0
800065d4:	00058a93          	mv	s5,a1
800065d8:	00060993          	mv	s3,a2
  int i;
  struct proc *pr = myproc();
800065dc:	ffffc097          	auipc	ra,0xffffc
800065e0:	d00080e7          	jalr	-768(ra) # 800022dc <myproc>
800065e4:	00050a13          	mv	s4,a0
  char ch;

  acquire(&pi->lock);
800065e8:	00048513          	mv	a0,s1
800065ec:	ffffb097          	auipc	ra,0xffffb
800065f0:	908080e7          	jalr	-1784(ra) # 80000ef4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
800065f4:	20c4a703          	lw	a4,524(s1)
800065f8:	2104a783          	lw	a5,528(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
800065fc:	20c48913          	addi	s2,s1,524
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
80006600:	04f71463          	bne	a4,a5,80006648 <piperead+0x9c>
80006604:	2184a783          	lw	a5,536(s1)
80006608:	06078263          	beqz	a5,8000666c <piperead+0xc0>
    if(myproc()->killed){
8000660c:	ffffc097          	auipc	ra,0xffffc
80006610:	cd0080e7          	jalr	-816(ra) # 800022dc <myproc>
80006614:	01852783          	lw	a5,24(a0)
80006618:	04079063          	bnez	a5,80006658 <piperead+0xac>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
8000661c:	00048593          	mv	a1,s1
80006620:	00090513          	mv	a0,s2
80006624:	ffffc097          	auipc	ra,0xffffc
80006628:	6fc080e7          	jalr	1788(ra) # 80002d20 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
8000662c:	20c4a703          	lw	a4,524(s1)
80006630:	2104a783          	lw	a5,528(s1)
80006634:	fcf708e3          	beq	a4,a5,80006604 <piperead+0x58>
80006638:	03612023          	sw	s6,32(sp)
8000663c:	01712e23          	sw	s7,28(sp)
80006640:	01812c23          	sw	s8,24(sp)
80006644:	0340006f          	j	80006678 <piperead+0xcc>
80006648:	03612023          	sw	s6,32(sp)
8000664c:	01712e23          	sw	s7,28(sp)
80006650:	01812c23          	sw	s8,24(sp)
80006654:	0240006f          	j	80006678 <piperead+0xcc>
      release(&pi->lock);
80006658:	00048513          	mv	a0,s1
8000665c:	ffffb097          	auipc	ra,0xffffb
80006660:	90c080e7          	jalr	-1780(ra) # 80000f68 <release>
      return -1;
80006664:	fff00913          	li	s2,-1
80006668:	0940006f          	j	800066fc <piperead+0x150>
8000666c:	03612023          	sw	s6,32(sp)
80006670:	01712e23          	sw	s7,28(sp)
80006674:	01812c23          	sw	s8,24(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80006678:	00000913          	li	s2,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
8000667c:	fcf40c13          	addi	s8,s0,-49
80006680:	00100b93          	li	s7,1
80006684:	fff00b13          	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80006688:	05305863          	blez	s3,800066d8 <piperead+0x12c>
    if(pi->nread == pi->nwrite)
8000668c:	20c4a783          	lw	a5,524(s1)
80006690:	2104a703          	lw	a4,528(s1)
80006694:	04e78263          	beq	a5,a4,800066d8 <piperead+0x12c>
    ch = pi->data[pi->nread++ % PIPESIZE];
80006698:	00178713          	addi	a4,a5,1
8000669c:	20e4a623          	sw	a4,524(s1)
800066a0:	1ff7f793          	andi	a5,a5,511
800066a4:	00f487b3          	add	a5,s1,a5
800066a8:	00c7c783          	lbu	a5,12(a5)
800066ac:	fcf407a3          	sb	a5,-49(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
800066b0:	000b8693          	mv	a3,s7
800066b4:	000c0613          	mv	a2,s8
800066b8:	015905b3          	add	a1,s2,s5
800066bc:	02ca2503          	lw	a0,44(s4)
800066c0:	ffffb097          	auipc	ra,0xffffb
800066c4:	75c080e7          	jalr	1884(ra) # 80001e1c <copyout>
800066c8:	01650863          	beq	a0,s6,800066d8 <piperead+0x12c>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
800066cc:	00190913          	addi	s2,s2,1
800066d0:	fb299ee3          	bne	s3,s2,8000668c <piperead+0xe0>
800066d4:	00098913          	mv	s2,s3
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
800066d8:	21048513          	addi	a0,s1,528
800066dc:	ffffd097          	auipc	ra,0xffffd
800066e0:	854080e7          	jalr	-1964(ra) # 80002f30 <wakeup>
  release(&pi->lock);
800066e4:	00048513          	mv	a0,s1
800066e8:	ffffb097          	auipc	ra,0xffffb
800066ec:	880080e7          	jalr	-1920(ra) # 80000f68 <release>
800066f0:	02012b03          	lw	s6,32(sp)
800066f4:	01c12b83          	lw	s7,28(sp)
800066f8:	01812c03          	lw	s8,24(sp)
  return i;
}
800066fc:	00090513          	mv	a0,s2
80006700:	03c12083          	lw	ra,60(sp)
80006704:	03812403          	lw	s0,56(sp)
80006708:	03412483          	lw	s1,52(sp)
8000670c:	03012903          	lw	s2,48(sp)
80006710:	02c12983          	lw	s3,44(sp)
80006714:	02812a03          	lw	s4,40(sp)
80006718:	02412a83          	lw	s5,36(sp)
8000671c:	04010113          	addi	sp,sp,64
80006720:	00008067          	ret

80006724 <exec>:

static int loadseg(pde_t *pgdir, uint32 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
80006724:	ed010113          	addi	sp,sp,-304
80006728:	12112623          	sw	ra,300(sp)
8000672c:	12812423          	sw	s0,296(sp)
80006730:	12912223          	sw	s1,292(sp)
80006734:	13212023          	sw	s2,288(sp)
80006738:	13010413          	addi	s0,sp,304
8000673c:	00050913          	mv	s2,a0
80006740:	eca42a23          	sw	a0,-300(s0)
80006744:	ecb42c23          	sw	a1,-296(s0)
  uint32 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
80006748:	ffffc097          	auipc	ra,0xffffc
8000674c:	b94080e7          	jalr	-1132(ra) # 800022dc <myproc>
80006750:	00050493          	mv	s1,a0

  begin_op();
80006754:	fffff097          	auipc	ra,0xfffff
80006758:	f40080e7          	jalr	-192(ra) # 80005694 <begin_op>

  if((ip = namei(path)) == 0){
8000675c:	00090513          	mv	a0,s2
80006760:	fffff097          	auipc	ra,0xfffff
80006764:	c70080e7          	jalr	-912(ra) # 800053d0 <namei>
80006768:	06050e63          	beqz	a0,800067e4 <exec+0xc0>
8000676c:	11512a23          	sw	s5,276(sp)
80006770:	00050a93          	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
80006774:	ffffe097          	auipc	ra,0xffffe
80006778:	16c080e7          	jalr	364(ra) # 800048e0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint32)&elf, 0, sizeof(elf)) != sizeof(elf))
8000677c:	03400713          	li	a4,52
80006780:	00000693          	li	a3,0
80006784:	f0840613          	addi	a2,s0,-248
80006788:	00000593          	li	a1,0
8000678c:	000a8513          	mv	a0,s5
80006790:	ffffe097          	auipc	ra,0xffffe
80006794:	4e8080e7          	jalr	1256(ra) # 80004c78 <readi>
80006798:	03400793          	li	a5,52
8000679c:	00f51a63          	bne	a0,a5,800067b0 <exec+0x8c>
    goto bad;
  if(elf.magic != ELF_MAGIC)
800067a0:	f0842703          	lw	a4,-248(s0)
800067a4:	464c47b7          	lui	a5,0x464c4
800067a8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
800067ac:	04f70463          	beq	a4,a5,800067f4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
800067b0:	000a8513          	mv	a0,s5
800067b4:	ffffe097          	auipc	ra,0xffffe
800067b8:	438080e7          	jalr	1080(ra) # 80004bec <iunlockput>
    end_op();
800067bc:	fffff097          	auipc	ra,0xfffff
800067c0:	f88080e7          	jalr	-120(ra) # 80005744 <end_op>
  }
  return -1;
800067c4:	fff00513          	li	a0,-1
800067c8:	11412a83          	lw	s5,276(sp)
}
800067cc:	12c12083          	lw	ra,300(sp)
800067d0:	12812403          	lw	s0,296(sp)
800067d4:	12412483          	lw	s1,292(sp)
800067d8:	12012903          	lw	s2,288(sp)
800067dc:	13010113          	addi	sp,sp,304
800067e0:	00008067          	ret
    end_op();
800067e4:	fffff097          	auipc	ra,0xfffff
800067e8:	f60080e7          	jalr	-160(ra) # 80005744 <end_op>
    return -1;
800067ec:	fff00513          	li	a0,-1
800067f0:	fddff06f          	j	800067cc <exec+0xa8>
800067f4:	11612823          	sw	s6,272(sp)
  if((pagetable = proc_pagetable(p)) == 0)
800067f8:	00048513          	mv	a0,s1
800067fc:	ffffc097          	auipc	ra,0xffffc
80006800:	c00080e7          	jalr	-1024(ra) # 800023fc <proc_pagetable>
80006804:	00050b13          	mv	s6,a0
80006808:	34050863          	beqz	a0,80006b58 <exec+0x434>
8000680c:	11312e23          	sw	s3,284(sp)
80006810:	11412c23          	sw	s4,280(sp)
80006814:	11712623          	sw	s7,268(sp)
80006818:	11812423          	sw	s8,264(sp)
8000681c:	11912223          	sw	s9,260(sp)
80006820:	11a12023          	sw	s10,256(sp)
80006824:	0fb12e23          	sw	s11,252(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80006828:	f2442683          	lw	a3,-220(s0)
8000682c:	f3445783          	lhu	a5,-204(s0)
80006830:	10078463          	beqz	a5,80006938 <exec+0x214>
  sz = 0;
80006834:	ec042e23          	sw	zero,-292(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80006838:	00000c93          	li	s9,0
    if(readi(ip, 0, (uint32)&ph, off, sizeof(ph)) != sizeof(ph))
8000683c:	02000d93          	li	s11,32
    if(ph.vaddr % PGSIZE != 0)
80006840:	000019b7          	lui	s3,0x1
80006844:	fff98793          	addi	a5,s3,-1 # fff <_entry-0x7ffff001>
80006848:	ecf42823          	sw	a5,-304(s0)
8000684c:	0700006f          	j	800068bc <exec+0x198>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
80006850:	00005517          	auipc	a0,0x5
80006854:	59050513          	addi	a0,a0,1424 # 8000bde0 <userret+0x2d40>
80006858:	ffffa097          	auipc	ra,0xffffa
8000685c:	ea8080e7          	jalr	-344(ra) # 80000700 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint32)pa, offset+i, n) != n)
80006860:	00090713          	mv	a4,s2
80006864:	009c06b3          	add	a3,s8,s1
80006868:	00000593          	li	a1,0
8000686c:	000a8513          	mv	a0,s5
80006870:	ffffe097          	auipc	ra,0xffffe
80006874:	408080e7          	jalr	1032(ra) # 80004c78 <readi>
80006878:	2ea91463          	bne	s2,a0,80006b60 <exec+0x43c>
  for(i = 0; i < sz; i += PGSIZE){
8000687c:	013484b3          	add	s1,s1,s3
80006880:	0344f663          	bgeu	s1,s4,800068ac <exec+0x188>
    pa = walkaddr(pagetable, va + i);
80006884:	009b85b3          	add	a1,s7,s1
80006888:	000b0513          	mv	a0,s6
8000688c:	ffffb097          	auipc	ra,0xffffb
80006890:	c88080e7          	jalr	-888(ra) # 80001514 <walkaddr>
80006894:	00050613          	mv	a2,a0
    if(pa == 0)
80006898:	fa050ce3          	beqz	a0,80006850 <exec+0x12c>
    if(sz - i < PGSIZE)
8000689c:	409a0933          	sub	s2,s4,s1
800068a0:	fd29f0e3          	bgeu	s3,s2,80006860 <exec+0x13c>
800068a4:	00098913          	mv	s2,s3
800068a8:	fb9ff06f          	j	80006860 <exec+0x13c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
800068ac:	001c8c93          	addi	s9,s9,1
800068b0:	020d0693          	addi	a3,s10,32
800068b4:	f3445783          	lhu	a5,-204(s0)
800068b8:	08fcd263          	bge	s9,a5,8000693c <exec+0x218>
    if(readi(ip, 0, (uint32)&ph, off, sizeof(ph)) != sizeof(ph))
800068bc:	00068d13          	mv	s10,a3
800068c0:	000d8713          	mv	a4,s11
800068c4:	ee840613          	addi	a2,s0,-280
800068c8:	00000593          	li	a1,0
800068cc:	000a8513          	mv	a0,s5
800068d0:	ffffe097          	auipc	ra,0xffffe
800068d4:	3a8080e7          	jalr	936(ra) # 80004c78 <readi>
800068d8:	29b51463          	bne	a0,s11,80006b60 <exec+0x43c>
    if(ph.type != ELF_PROG_LOAD)
800068dc:	ee842783          	lw	a5,-280(s0)
800068e0:	00100713          	li	a4,1
800068e4:	fce794e3          	bne	a5,a4,800068ac <exec+0x188>
    if(ph.memsz < ph.filesz)
800068e8:	efc42603          	lw	a2,-260(s0)
800068ec:	ef842783          	lw	a5,-264(s0)
800068f0:	26f66863          	bltu	a2,a5,80006b60 <exec+0x43c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
800068f4:	ef042783          	lw	a5,-272(s0)
800068f8:	00f60633          	add	a2,a2,a5
800068fc:	26f66263          	bltu	a2,a5,80006b60 <exec+0x43c>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
80006900:	edc42583          	lw	a1,-292(s0)
80006904:	000b0513          	mv	a0,s6
80006908:	ffffb097          	auipc	ra,0xffffb
8000690c:	1f0080e7          	jalr	496(ra) # 80001af8 <uvmalloc>
80006910:	eca42e23          	sw	a0,-292(s0)
80006914:	24050663          	beqz	a0,80006b60 <exec+0x43c>
    if(ph.vaddr % PGSIZE != 0)
80006918:	ef042b83          	lw	s7,-272(s0)
8000691c:	ed042783          	lw	a5,-304(s0)
80006920:	00fbf4b3          	and	s1,s7,a5
80006924:	22049e63          	bnez	s1,80006b60 <exec+0x43c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
80006928:	eec42c03          	lw	s8,-276(s0)
8000692c:	ef842a03          	lw	s4,-264(s0)
  for(i = 0; i < sz; i += PGSIZE){
80006930:	f40a1ae3          	bnez	s4,80006884 <exec+0x160>
80006934:	f79ff06f          	j	800068ac <exec+0x188>
  sz = 0;
80006938:	ec042e23          	sw	zero,-292(s0)
  iunlockput(ip);
8000693c:	000a8513          	mv	a0,s5
80006940:	ffffe097          	auipc	ra,0xffffe
80006944:	2ac080e7          	jalr	684(ra) # 80004bec <iunlockput>
  end_op();
80006948:	fffff097          	auipc	ra,0xfffff
8000694c:	dfc080e7          	jalr	-516(ra) # 80005744 <end_op>
  p = myproc();
80006950:	ffffc097          	auipc	ra,0xffffc
80006954:	98c080e7          	jalr	-1652(ra) # 800022dc <myproc>
80006958:	00050a93          	mv	s5,a0
  uint32 oldsz = p->sz;
8000695c:	02852d83          	lw	s11,40(a0)
  sz = PGROUNDUP(sz);
80006960:	000015b7          	lui	a1,0x1
80006964:	fff58593          	addi	a1,a1,-1 # fff <_entry-0x7ffff001>
80006968:	edc42783          	lw	a5,-292(s0)
8000696c:	00b785b3          	add	a1,a5,a1
80006970:	fffff7b7          	lui	a5,0xfffff
80006974:	00f5f5b3          	and	a1,a1,a5
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
80006978:	00002637          	lui	a2,0x2
8000697c:	00c58633          	add	a2,a1,a2
80006980:	000b0513          	mv	a0,s6
80006984:	ffffb097          	auipc	ra,0xffffb
80006988:	174080e7          	jalr	372(ra) # 80001af8 <uvmalloc>
8000698c:	00050a13          	mv	s4,a0
80006990:	04051063          	bnez	a0,800069d0 <exec+0x2ac>
    proc_freepagetable(pagetable, sz);
80006994:	000a0593          	mv	a1,s4
80006998:	000b0513          	mv	a0,s6
8000699c:	ffffc097          	auipc	ra,0xffffc
800069a0:	bc4080e7          	jalr	-1084(ra) # 80002560 <proc_freepagetable>
  return -1;
800069a4:	fff00513          	li	a0,-1
800069a8:	11c12983          	lw	s3,284(sp)
800069ac:	11812a03          	lw	s4,280(sp)
800069b0:	11412a83          	lw	s5,276(sp)
800069b4:	11012b03          	lw	s6,272(sp)
800069b8:	10c12b83          	lw	s7,268(sp)
800069bc:	10812c03          	lw	s8,264(sp)
800069c0:	10412c83          	lw	s9,260(sp)
800069c4:	10012d03          	lw	s10,256(sp)
800069c8:	0fc12d83          	lw	s11,252(sp)
800069cc:	e01ff06f          	j	800067cc <exec+0xa8>
  uvmclear(pagetable, sz-2*PGSIZE);
800069d0:	ffffe5b7          	lui	a1,0xffffe
800069d4:	00b505b3          	add	a1,a0,a1
800069d8:	000b0513          	mv	a0,s6
800069dc:	ffffb097          	auipc	ra,0xffffb
800069e0:	3f4080e7          	jalr	1012(ra) # 80001dd0 <uvmclear>
  stackbase = sp - PGSIZE;
800069e4:	fffffbb7          	lui	s7,0xfffff
800069e8:	017a0bb3          	add	s7,s4,s7
  for(argc = 0; argv[argc]; argc++) {
800069ec:	ed842783          	lw	a5,-296(s0)
800069f0:	0007a503          	lw	a0,0(a5) # fffff000 <end+0x7ffd8fec>
  sp = sz;
800069f4:	000a0913          	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
800069f8:	00000493          	li	s1,0
    ustack[argc] = sp;
800069fc:	f3c40c93          	addi	s9,s0,-196
    if(argc >= MAXARG)
80006a00:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
80006a04:	06050a63          	beqz	a0,80006a78 <exec+0x354>
    sp -= strlen(argv[argc]) + 1;
80006a08:	ffffa097          	auipc	ra,0xffffa
80006a0c:	7f0080e7          	jalr	2032(ra) # 800011f8 <strlen>
80006a10:	00150793          	addi	a5,a0,1
80006a14:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
80006a18:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
80006a1c:	f7796ce3          	bltu	s2,s7,80006994 <exec+0x270>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80006a20:	ed842d03          	lw	s10,-296(s0)
80006a24:	000d2983          	lw	s3,0(s10)
80006a28:	00098513          	mv	a0,s3
80006a2c:	ffffa097          	auipc	ra,0xffffa
80006a30:	7cc080e7          	jalr	1996(ra) # 800011f8 <strlen>
80006a34:	00150693          	addi	a3,a0,1
80006a38:	00098613          	mv	a2,s3
80006a3c:	00090593          	mv	a1,s2
80006a40:	000b0513          	mv	a0,s6
80006a44:	ffffb097          	auipc	ra,0xffffb
80006a48:	3d8080e7          	jalr	984(ra) # 80001e1c <copyout>
80006a4c:	f40544e3          	bltz	a0,80006994 <exec+0x270>
    ustack[argc] = sp;
80006a50:	00249793          	slli	a5,s1,0x2
80006a54:	00fc87b3          	add	a5,s9,a5
80006a58:	0127a023          	sw	s2,0(a5)
  for(argc = 0; argv[argc]; argc++) {
80006a5c:	00148493          	addi	s1,s1,1
80006a60:	004d0793          	addi	a5,s10,4
80006a64:	ecf42c23          	sw	a5,-296(s0)
80006a68:	004d2503          	lw	a0,4(s10)
80006a6c:	00050663          	beqz	a0,80006a78 <exec+0x354>
    if(argc >= MAXARG)
80006a70:	f9849ce3          	bne	s1,s8,80006a08 <exec+0x2e4>
80006a74:	f21ff06f          	j	80006994 <exec+0x270>
  ustack[argc] = 0;
80006a78:	00249793          	slli	a5,s1,0x2
80006a7c:	fc078793          	addi	a5,a5,-64
80006a80:	008787b3          	add	a5,a5,s0
80006a84:	f607ae23          	sw	zero,-132(a5)
  sp -= (argc+1) * sizeof(uint32);
80006a88:	00148693          	addi	a3,s1,1
80006a8c:	00269693          	slli	a3,a3,0x2
80006a90:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
80006a94:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
80006a98:	ef796ee3          	bltu	s2,s7,80006994 <exec+0x270>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint32)) < 0)
80006a9c:	f3c40613          	addi	a2,s0,-196
80006aa0:	00090593          	mv	a1,s2
80006aa4:	000b0513          	mv	a0,s6
80006aa8:	ffffb097          	auipc	ra,0xffffb
80006aac:	374080e7          	jalr	884(ra) # 80001e1c <copyout>
80006ab0:	ee0542e3          	bltz	a0,80006994 <exec+0x270>
  p->tf->a1 = sp;
80006ab4:	030aa783          	lw	a5,48(s5)
80006ab8:	0327ae23          	sw	s2,60(a5)
  for(last=s=path; *s; s++)
80006abc:	ed442783          	lw	a5,-300(s0)
80006ac0:	0007c703          	lbu	a4,0(a5)
80006ac4:	02070463          	beqz	a4,80006aec <exec+0x3c8>
80006ac8:	00178793          	addi	a5,a5,1
    if(*s == '/')
80006acc:	02f00693          	li	a3,47
80006ad0:	0100006f          	j	80006ae0 <exec+0x3bc>
  for(last=s=path; *s; s++)
80006ad4:	00178793          	addi	a5,a5,1
80006ad8:	fff7c703          	lbu	a4,-1(a5)
80006adc:	00070863          	beqz	a4,80006aec <exec+0x3c8>
    if(*s == '/')
80006ae0:	fed71ae3          	bne	a4,a3,80006ad4 <exec+0x3b0>
      last = s+1;
80006ae4:	ecf42a23          	sw	a5,-300(s0)
80006ae8:	fedff06f          	j	80006ad4 <exec+0x3b0>
  safestrcpy(p->name, last, sizeof(p->name));
80006aec:	01000613          	li	a2,16
80006af0:	ed442583          	lw	a1,-300(s0)
80006af4:	0b0a8513          	addi	a0,s5,176
80006af8:	ffffa097          	auipc	ra,0xffffa
80006afc:	6b4080e7          	jalr	1716(ra) # 800011ac <safestrcpy>
  oldpagetable = p->pagetable;
80006b00:	02caa503          	lw	a0,44(s5)
  p->pagetable = pagetable;
80006b04:	036aa623          	sw	s6,44(s5)
  p->sz = sz;
80006b08:	034aa423          	sw	s4,40(s5)
  p->tf->epc = elf.entry;  // initial program counter = main
80006b0c:	030aa783          	lw	a5,48(s5)
80006b10:	f2042703          	lw	a4,-224(s0)
80006b14:	00e7a623          	sw	a4,12(a5)
  p->tf->sp = sp; // initial stack pointer
80006b18:	030aa783          	lw	a5,48(s5)
80006b1c:	0127ac23          	sw	s2,24(a5)
  proc_freepagetable(oldpagetable, oldsz);
80006b20:	000d8593          	mv	a1,s11
80006b24:	ffffc097          	auipc	ra,0xffffc
80006b28:	a3c080e7          	jalr	-1476(ra) # 80002560 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
80006b2c:	00048513          	mv	a0,s1
80006b30:	11c12983          	lw	s3,284(sp)
80006b34:	11812a03          	lw	s4,280(sp)
80006b38:	11412a83          	lw	s5,276(sp)
80006b3c:	11012b03          	lw	s6,272(sp)
80006b40:	10c12b83          	lw	s7,268(sp)
80006b44:	10812c03          	lw	s8,264(sp)
80006b48:	10412c83          	lw	s9,260(sp)
80006b4c:	10012d03          	lw	s10,256(sp)
80006b50:	0fc12d83          	lw	s11,252(sp)
80006b54:	c79ff06f          	j	800067cc <exec+0xa8>
80006b58:	11012b03          	lw	s6,272(sp)
80006b5c:	c55ff06f          	j	800067b0 <exec+0x8c>
    proc_freepagetable(pagetable, sz);
80006b60:	edc42583          	lw	a1,-292(s0)
80006b64:	000b0513          	mv	a0,s6
80006b68:	ffffc097          	auipc	ra,0xffffc
80006b6c:	9f8080e7          	jalr	-1544(ra) # 80002560 <proc_freepagetable>
  if(ip){
80006b70:	11c12983          	lw	s3,284(sp)
80006b74:	11812a03          	lw	s4,280(sp)
80006b78:	11012b03          	lw	s6,272(sp)
80006b7c:	10c12b83          	lw	s7,268(sp)
80006b80:	10812c03          	lw	s8,264(sp)
80006b84:	10412c83          	lw	s9,260(sp)
80006b88:	10012d03          	lw	s10,256(sp)
80006b8c:	0fc12d83          	lw	s11,252(sp)
80006b90:	c21ff06f          	j	800067b0 <exec+0x8c>

80006b94 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80006b94:	fe010113          	addi	sp,sp,-32
80006b98:	00112e23          	sw	ra,28(sp)
80006b9c:	00812c23          	sw	s0,24(sp)
80006ba0:	00912a23          	sw	s1,20(sp)
80006ba4:	01212823          	sw	s2,16(sp)
80006ba8:	02010413          	addi	s0,sp,32
80006bac:	00058913          	mv	s2,a1
80006bb0:	00060493          	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80006bb4:	fec40593          	addi	a1,s0,-20
80006bb8:	ffffd097          	auipc	ra,0xffffd
80006bbc:	d94080e7          	jalr	-620(ra) # 8000394c <argint>
80006bc0:	04054e63          	bltz	a0,80006c1c <argfd+0x88>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80006bc4:	fec42703          	lw	a4,-20(s0)
80006bc8:	00f00793          	li	a5,15
80006bcc:	04e7ec63          	bltu	a5,a4,80006c24 <argfd+0x90>
80006bd0:	ffffb097          	auipc	ra,0xffffb
80006bd4:	70c080e7          	jalr	1804(ra) # 800022dc <myproc>
80006bd8:	fec42703          	lw	a4,-20(s0)
80006bdc:	01870793          	addi	a5,a4,24
80006be0:	00279793          	slli	a5,a5,0x2
80006be4:	00f50533          	add	a0,a0,a5
80006be8:	00c52783          	lw	a5,12(a0)
80006bec:	04078063          	beqz	a5,80006c2c <argfd+0x98>
    return -1;
  if(pfd)
80006bf0:	00090463          	beqz	s2,80006bf8 <argfd+0x64>
    *pfd = fd;
80006bf4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
80006bf8:	00000513          	li	a0,0
  if(pf)
80006bfc:	00048463          	beqz	s1,80006c04 <argfd+0x70>
    *pf = f;
80006c00:	00f4a023          	sw	a5,0(s1)
}
80006c04:	01c12083          	lw	ra,28(sp)
80006c08:	01812403          	lw	s0,24(sp)
80006c0c:	01412483          	lw	s1,20(sp)
80006c10:	01012903          	lw	s2,16(sp)
80006c14:	02010113          	addi	sp,sp,32
80006c18:	00008067          	ret
    return -1;
80006c1c:	fff00513          	li	a0,-1
80006c20:	fe5ff06f          	j	80006c04 <argfd+0x70>
    return -1;
80006c24:	fff00513          	li	a0,-1
80006c28:	fddff06f          	j	80006c04 <argfd+0x70>
80006c2c:	fff00513          	li	a0,-1
80006c30:	fd5ff06f          	j	80006c04 <argfd+0x70>

80006c34 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80006c34:	ff010113          	addi	sp,sp,-16
80006c38:	00112623          	sw	ra,12(sp)
80006c3c:	00812423          	sw	s0,8(sp)
80006c40:	00912223          	sw	s1,4(sp)
80006c44:	01010413          	addi	s0,sp,16
80006c48:	00050493          	mv	s1,a0
  int fd;
  struct proc *p = myproc();
80006c4c:	ffffb097          	auipc	ra,0xffffb
80006c50:	690080e7          	jalr	1680(ra) # 800022dc <myproc>
80006c54:	00050613          	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
80006c58:	06c50793          	addi	a5,a0,108
80006c5c:	00000513          	li	a0,0
80006c60:	01000693          	li	a3,16
    if(p->ofile[fd] == 0){
80006c64:	0007a703          	lw	a4,0(a5)
80006c68:	02070463          	beqz	a4,80006c90 <fdalloc+0x5c>
  for(fd = 0; fd < NOFILE; fd++){
80006c6c:	00150513          	addi	a0,a0,1
80006c70:	00478793          	addi	a5,a5,4
80006c74:	fed518e3          	bne	a0,a3,80006c64 <fdalloc+0x30>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80006c78:	fff00513          	li	a0,-1
}
80006c7c:	00c12083          	lw	ra,12(sp)
80006c80:	00812403          	lw	s0,8(sp)
80006c84:	00412483          	lw	s1,4(sp)
80006c88:	01010113          	addi	sp,sp,16
80006c8c:	00008067          	ret
      p->ofile[fd] = f;
80006c90:	01850793          	addi	a5,a0,24
80006c94:	00279793          	slli	a5,a5,0x2
80006c98:	00f60633          	add	a2,a2,a5
80006c9c:	00962623          	sw	s1,12(a2) # 200c <_entry-0x7fffdff4>
      return fd;
80006ca0:	fddff06f          	j	80006c7c <fdalloc+0x48>

80006ca4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80006ca4:	fd010113          	addi	sp,sp,-48
80006ca8:	02112623          	sw	ra,44(sp)
80006cac:	02812423          	sw	s0,40(sp)
80006cb0:	02912223          	sw	s1,36(sp)
80006cb4:	03212023          	sw	s2,32(sp)
80006cb8:	01312e23          	sw	s3,28(sp)
80006cbc:	01412c23          	sw	s4,24(sp)
80006cc0:	01512a23          	sw	s5,20(sp)
80006cc4:	03010413          	addi	s0,sp,48
80006cc8:	00058a93          	mv	s5,a1
80006ccc:	00060a13          	mv	s4,a2
80006cd0:	00068993          	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80006cd4:	fd040593          	addi	a1,s0,-48
80006cd8:	ffffe097          	auipc	ra,0xffffe
80006cdc:	728080e7          	jalr	1832(ra) # 80005400 <nameiparent>
80006ce0:	00050913          	mv	s2,a0
80006ce4:	18050263          	beqz	a0,80006e68 <create+0x1c4>
    return 0;

  ilock(dp);
80006ce8:	ffffe097          	auipc	ra,0xffffe
80006cec:	bf8080e7          	jalr	-1032(ra) # 800048e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80006cf0:	00000613          	li	a2,0
80006cf4:	fd040593          	addi	a1,s0,-48
80006cf8:	00090513          	mv	a0,s2
80006cfc:	ffffe097          	auipc	ra,0xffffe
80006d00:	284080e7          	jalr	644(ra) # 80004f80 <dirlookup>
80006d04:	00050493          	mv	s1,a0
80006d08:	06050c63          	beqz	a0,80006d80 <create+0xdc>
    iunlockput(dp);
80006d0c:	00090513          	mv	a0,s2
80006d10:	ffffe097          	auipc	ra,0xffffe
80006d14:	edc080e7          	jalr	-292(ra) # 80004bec <iunlockput>
    ilock(ip);
80006d18:	00048513          	mv	a0,s1
80006d1c:	ffffe097          	auipc	ra,0xffffe
80006d20:	bc4080e7          	jalr	-1084(ra) # 800048e0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
80006d24:	00200793          	li	a5,2
80006d28:	04fa9263          	bne	s5,a5,80006d6c <create+0xc8>
80006d2c:	0284d783          	lhu	a5,40(s1)
80006d30:	ffe78793          	addi	a5,a5,-2
80006d34:	01079793          	slli	a5,a5,0x10
80006d38:	0107d793          	srli	a5,a5,0x10
80006d3c:	00100713          	li	a4,1
80006d40:	02f76663          	bltu	a4,a5,80006d6c <create+0xc8>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80006d44:	00048513          	mv	a0,s1
80006d48:	02c12083          	lw	ra,44(sp)
80006d4c:	02812403          	lw	s0,40(sp)
80006d50:	02412483          	lw	s1,36(sp)
80006d54:	02012903          	lw	s2,32(sp)
80006d58:	01c12983          	lw	s3,28(sp)
80006d5c:	01812a03          	lw	s4,24(sp)
80006d60:	01412a83          	lw	s5,20(sp)
80006d64:	03010113          	addi	sp,sp,48
80006d68:	00008067          	ret
    iunlockput(ip);
80006d6c:	00048513          	mv	a0,s1
80006d70:	ffffe097          	auipc	ra,0xffffe
80006d74:	e7c080e7          	jalr	-388(ra) # 80004bec <iunlockput>
    return 0;
80006d78:	00000493          	li	s1,0
80006d7c:	fc9ff06f          	j	80006d44 <create+0xa0>
  if((ip = ialloc(dp->dev, type)) == 0)
80006d80:	000a8593          	mv	a1,s5
80006d84:	00092503          	lw	a0,0(s2)
80006d88:	ffffe097          	auipc	ra,0xffffe
80006d8c:	930080e7          	jalr	-1744(ra) # 800046b8 <ialloc>
80006d90:	00050493          	mv	s1,a0
80006d94:	04050a63          	beqz	a0,80006de8 <create+0x144>
  ilock(ip);
80006d98:	ffffe097          	auipc	ra,0xffffe
80006d9c:	b48080e7          	jalr	-1208(ra) # 800048e0 <ilock>
  ip->major = major;
80006da0:	03449523          	sh	s4,42(s1)
  ip->minor = minor;
80006da4:	03349623          	sh	s3,44(s1)
  ip->nlink = 1;
80006da8:	00100993          	li	s3,1
80006dac:	03349723          	sh	s3,46(s1)
  iupdate(ip);
80006db0:	00048513          	mv	a0,s1
80006db4:	ffffe097          	auipc	ra,0xffffe
80006db8:	a10080e7          	jalr	-1520(ra) # 800047c4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80006dbc:	033a8e63          	beq	s5,s3,80006df8 <create+0x154>
  if(dirlink(dp, name, ip->inum) < 0)
80006dc0:	0044a603          	lw	a2,4(s1)
80006dc4:	fd040593          	addi	a1,s0,-48
80006dc8:	00090513          	mv	a0,s2
80006dcc:	ffffe097          	auipc	ra,0xffffe
80006dd0:	4c8080e7          	jalr	1224(ra) # 80005294 <dirlink>
80006dd4:	08054263          	bltz	a0,80006e58 <create+0x1b4>
  iunlockput(dp);
80006dd8:	00090513          	mv	a0,s2
80006ddc:	ffffe097          	auipc	ra,0xffffe
80006de0:	e10080e7          	jalr	-496(ra) # 80004bec <iunlockput>
  return ip;
80006de4:	f61ff06f          	j	80006d44 <create+0xa0>
    panic("create: ialloc");
80006de8:	00005517          	auipc	a0,0x5
80006dec:	01850513          	addi	a0,a0,24 # 8000be00 <userret+0x2d60>
80006df0:	ffffa097          	auipc	ra,0xffffa
80006df4:	910080e7          	jalr	-1776(ra) # 80000700 <panic>
    dp->nlink++;  // for ".."
80006df8:	02e95783          	lhu	a5,46(s2)
80006dfc:	013787b3          	add	a5,a5,s3
80006e00:	02f91723          	sh	a5,46(s2)
    iupdate(dp);
80006e04:	00090513          	mv	a0,s2
80006e08:	ffffe097          	auipc	ra,0xffffe
80006e0c:	9bc080e7          	jalr	-1604(ra) # 800047c4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80006e10:	0044a603          	lw	a2,4(s1)
80006e14:	00005597          	auipc	a1,0x5
80006e18:	ffc58593          	addi	a1,a1,-4 # 8000be10 <userret+0x2d70>
80006e1c:	00048513          	mv	a0,s1
80006e20:	ffffe097          	auipc	ra,0xffffe
80006e24:	474080e7          	jalr	1140(ra) # 80005294 <dirlink>
80006e28:	02054063          	bltz	a0,80006e48 <create+0x1a4>
80006e2c:	00492603          	lw	a2,4(s2)
80006e30:	00005597          	auipc	a1,0x5
80006e34:	fe458593          	addi	a1,a1,-28 # 8000be14 <userret+0x2d74>
80006e38:	00048513          	mv	a0,s1
80006e3c:	ffffe097          	auipc	ra,0xffffe
80006e40:	458080e7          	jalr	1112(ra) # 80005294 <dirlink>
80006e44:	f6055ee3          	bgez	a0,80006dc0 <create+0x11c>
      panic("create dots");
80006e48:	00005517          	auipc	a0,0x5
80006e4c:	fd050513          	addi	a0,a0,-48 # 8000be18 <userret+0x2d78>
80006e50:	ffffa097          	auipc	ra,0xffffa
80006e54:	8b0080e7          	jalr	-1872(ra) # 80000700 <panic>
    panic("create: dirlink");
80006e58:	00005517          	auipc	a0,0x5
80006e5c:	fcc50513          	addi	a0,a0,-52 # 8000be24 <userret+0x2d84>
80006e60:	ffffa097          	auipc	ra,0xffffa
80006e64:	8a0080e7          	jalr	-1888(ra) # 80000700 <panic>
    return 0;
80006e68:	00050493          	mv	s1,a0
80006e6c:	ed9ff06f          	j	80006d44 <create+0xa0>

80006e70 <sys_dup>:
{
80006e70:	fe010113          	addi	sp,sp,-32
80006e74:	00112e23          	sw	ra,28(sp)
80006e78:	00812c23          	sw	s0,24(sp)
80006e7c:	02010413          	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0)
80006e80:	fec40613          	addi	a2,s0,-20
80006e84:	00000593          	li	a1,0
80006e88:	00000513          	li	a0,0
80006e8c:	00000097          	auipc	ra,0x0
80006e90:	d08080e7          	jalr	-760(ra) # 80006b94 <argfd>
    return -1;
80006e94:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0)
80006e98:	04054063          	bltz	a0,80006ed8 <sys_dup+0x68>
80006e9c:	00912a23          	sw	s1,20(sp)
80006ea0:	01212823          	sw	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
80006ea4:	fec42903          	lw	s2,-20(s0)
80006ea8:	00090513          	mv	a0,s2
80006eac:	00000097          	auipc	ra,0x0
80006eb0:	d88080e7          	jalr	-632(ra) # 80006c34 <fdalloc>
80006eb4:	00050493          	mv	s1,a0
    return -1;
80006eb8:	fff00793          	li	a5,-1
  if((fd=fdalloc(f)) < 0)
80006ebc:	02054863          	bltz	a0,80006eec <sys_dup+0x7c>
  filedup(f);
80006ec0:	00090513          	mv	a0,s2
80006ec4:	fffff097          	auipc	ra,0xfffff
80006ec8:	e04080e7          	jalr	-508(ra) # 80005cc8 <filedup>
  return fd;
80006ecc:	00048793          	mv	a5,s1
80006ed0:	01412483          	lw	s1,20(sp)
80006ed4:	01012903          	lw	s2,16(sp)
}
80006ed8:	00078513          	mv	a0,a5
80006edc:	01c12083          	lw	ra,28(sp)
80006ee0:	01812403          	lw	s0,24(sp)
80006ee4:	02010113          	addi	sp,sp,32
80006ee8:	00008067          	ret
80006eec:	01412483          	lw	s1,20(sp)
80006ef0:	01012903          	lw	s2,16(sp)
80006ef4:	fe5ff06f          	j	80006ed8 <sys_dup+0x68>

80006ef8 <sys_read>:
{
80006ef8:	fe010113          	addi	sp,sp,-32
80006efc:	00112e23          	sw	ra,28(sp)
80006f00:	00812c23          	sw	s0,24(sp)
80006f04:	02010413          	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006f08:	fec40613          	addi	a2,s0,-20
80006f0c:	00000593          	li	a1,0
80006f10:	00000513          	li	a0,0
80006f14:	00000097          	auipc	ra,0x0
80006f18:	c80080e7          	jalr	-896(ra) # 80006b94 <argfd>
    return -1;
80006f1c:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006f20:	04054663          	bltz	a0,80006f6c <sys_read+0x74>
80006f24:	fe840593          	addi	a1,s0,-24
80006f28:	00200513          	li	a0,2
80006f2c:	ffffd097          	auipc	ra,0xffffd
80006f30:	a20080e7          	jalr	-1504(ra) # 8000394c <argint>
    return -1;
80006f34:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006f38:	02054a63          	bltz	a0,80006f6c <sys_read+0x74>
80006f3c:	fe440593          	addi	a1,s0,-28
80006f40:	00100513          	li	a0,1
80006f44:	ffffd097          	auipc	ra,0xffffd
80006f48:	a44080e7          	jalr	-1468(ra) # 80003988 <argaddr>
    return -1;
80006f4c:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006f50:	00054e63          	bltz	a0,80006f6c <sys_read+0x74>
  return fileread(f, p, n);
80006f54:	fe842603          	lw	a2,-24(s0)
80006f58:	fe442583          	lw	a1,-28(s0)
80006f5c:	fec42503          	lw	a0,-20(s0)
80006f60:	fffff097          	auipc	ra,0xfffff
80006f64:	fc0080e7          	jalr	-64(ra) # 80005f20 <fileread>
80006f68:	00050793          	mv	a5,a0
}
80006f6c:	00078513          	mv	a0,a5
80006f70:	01c12083          	lw	ra,28(sp)
80006f74:	01812403          	lw	s0,24(sp)
80006f78:	02010113          	addi	sp,sp,32
80006f7c:	00008067          	ret

80006f80 <sys_write>:
{
80006f80:	fe010113          	addi	sp,sp,-32
80006f84:	00112e23          	sw	ra,28(sp)
80006f88:	00812c23          	sw	s0,24(sp)
80006f8c:	02010413          	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006f90:	fec40613          	addi	a2,s0,-20
80006f94:	00000593          	li	a1,0
80006f98:	00000513          	li	a0,0
80006f9c:	00000097          	auipc	ra,0x0
80006fa0:	bf8080e7          	jalr	-1032(ra) # 80006b94 <argfd>
    return -1;
80006fa4:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006fa8:	04054663          	bltz	a0,80006ff4 <sys_write+0x74>
80006fac:	fe840593          	addi	a1,s0,-24
80006fb0:	00200513          	li	a0,2
80006fb4:	ffffd097          	auipc	ra,0xffffd
80006fb8:	998080e7          	jalr	-1640(ra) # 8000394c <argint>
    return -1;
80006fbc:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006fc0:	02054a63          	bltz	a0,80006ff4 <sys_write+0x74>
80006fc4:	fe440593          	addi	a1,s0,-28
80006fc8:	00100513          	li	a0,1
80006fcc:	ffffd097          	auipc	ra,0xffffd
80006fd0:	9bc080e7          	jalr	-1604(ra) # 80003988 <argaddr>
    return -1;
80006fd4:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
80006fd8:	00054e63          	bltz	a0,80006ff4 <sys_write+0x74>
  return filewrite(f, p, n);
80006fdc:	fe842603          	lw	a2,-24(s0)
80006fe0:	fe442583          	lw	a1,-28(s0)
80006fe4:	fec42503          	lw	a0,-20(s0)
80006fe8:	fffff097          	auipc	ra,0xfffff
80006fec:	084080e7          	jalr	132(ra) # 8000606c <filewrite>
80006ff0:	00050793          	mv	a5,a0
}
80006ff4:	00078513          	mv	a0,a5
80006ff8:	01c12083          	lw	ra,28(sp)
80006ffc:	01812403          	lw	s0,24(sp)
80007000:	02010113          	addi	sp,sp,32
80007004:	00008067          	ret

80007008 <sys_close>:
{
80007008:	fe010113          	addi	sp,sp,-32
8000700c:	00112e23          	sw	ra,28(sp)
80007010:	00812c23          	sw	s0,24(sp)
80007014:	02010413          	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
80007018:	fe840613          	addi	a2,s0,-24
8000701c:	fec40593          	addi	a1,s0,-20
80007020:	00000513          	li	a0,0
80007024:	00000097          	auipc	ra,0x0
80007028:	b70080e7          	jalr	-1168(ra) # 80006b94 <argfd>
    return -1;
8000702c:	fff00793          	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
80007030:	02054863          	bltz	a0,80007060 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80007034:	ffffb097          	auipc	ra,0xffffb
80007038:	2a8080e7          	jalr	680(ra) # 800022dc <myproc>
8000703c:	fec42783          	lw	a5,-20(s0)
80007040:	01878793          	addi	a5,a5,24
80007044:	00279793          	slli	a5,a5,0x2
80007048:	00f50533          	add	a0,a0,a5
8000704c:	00052623          	sw	zero,12(a0)
  fileclose(f);
80007050:	fe842503          	lw	a0,-24(s0)
80007054:	fffff097          	auipc	ra,0xfffff
80007058:	ce4080e7          	jalr	-796(ra) # 80005d38 <fileclose>
  return 0;
8000705c:	00000793          	li	a5,0
}
80007060:	00078513          	mv	a0,a5
80007064:	01c12083          	lw	ra,28(sp)
80007068:	01812403          	lw	s0,24(sp)
8000706c:	02010113          	addi	sp,sp,32
80007070:	00008067          	ret

80007074 <sys_fstat>:
{
80007074:	fe010113          	addi	sp,sp,-32
80007078:	00112e23          	sw	ra,28(sp)
8000707c:	00812c23          	sw	s0,24(sp)
80007080:	02010413          	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
80007084:	fec40613          	addi	a2,s0,-20
80007088:	00000593          	li	a1,0
8000708c:	00000513          	li	a0,0
80007090:	00000097          	auipc	ra,0x0
80007094:	b04080e7          	jalr	-1276(ra) # 80006b94 <argfd>
    return -1;
80007098:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
8000709c:	02054863          	bltz	a0,800070cc <sys_fstat+0x58>
800070a0:	fe840593          	addi	a1,s0,-24
800070a4:	00100513          	li	a0,1
800070a8:	ffffd097          	auipc	ra,0xffffd
800070ac:	8e0080e7          	jalr	-1824(ra) # 80003988 <argaddr>
    return -1;
800070b0:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
800070b4:	00054c63          	bltz	a0,800070cc <sys_fstat+0x58>
  return filestat(f, st);
800070b8:	fe842583          	lw	a1,-24(s0)
800070bc:	fec42503          	lw	a0,-20(s0)
800070c0:	fffff097          	auipc	ra,0xfffff
800070c4:	dac080e7          	jalr	-596(ra) # 80005e6c <filestat>
800070c8:	00050793          	mv	a5,a0
}
800070cc:	00078513          	mv	a0,a5
800070d0:	01c12083          	lw	ra,28(sp)
800070d4:	01812403          	lw	s0,24(sp)
800070d8:	02010113          	addi	sp,sp,32
800070dc:	00008067          	ret

800070e0 <sys_link>:
{
800070e0:	ee010113          	addi	sp,sp,-288
800070e4:	10112e23          	sw	ra,284(sp)
800070e8:	10812c23          	sw	s0,280(sp)
800070ec:	12010413          	addi	s0,sp,288
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
800070f0:	08000613          	li	a2,128
800070f4:	ee040593          	addi	a1,s0,-288
800070f8:	00000513          	li	a0,0
800070fc:	ffffd097          	auipc	ra,0xffffd
80007100:	8c8080e7          	jalr	-1848(ra) # 800039c4 <argstr>
    return -1;
80007104:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
80007108:	16054a63          	bltz	a0,8000727c <sys_link+0x19c>
8000710c:	08000613          	li	a2,128
80007110:	f6040593          	addi	a1,s0,-160
80007114:	00100513          	li	a0,1
80007118:	ffffd097          	auipc	ra,0xffffd
8000711c:	8ac080e7          	jalr	-1876(ra) # 800039c4 <argstr>
    return -1;
80007120:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
80007124:	14054c63          	bltz	a0,8000727c <sys_link+0x19c>
80007128:	10912a23          	sw	s1,276(sp)
  begin_op();
8000712c:	ffffe097          	auipc	ra,0xffffe
80007130:	568080e7          	jalr	1384(ra) # 80005694 <begin_op>
  if((ip = namei(old)) == 0){
80007134:	ee040513          	addi	a0,s0,-288
80007138:	ffffe097          	auipc	ra,0xffffe
8000713c:	298080e7          	jalr	664(ra) # 800053d0 <namei>
80007140:	00050493          	mv	s1,a0
80007144:	0a050a63          	beqz	a0,800071f8 <sys_link+0x118>
  ilock(ip);
80007148:	ffffd097          	auipc	ra,0xffffd
8000714c:	798080e7          	jalr	1944(ra) # 800048e0 <ilock>
  if(ip->type == T_DIR){
80007150:	02849703          	lh	a4,40(s1)
80007154:	00100793          	li	a5,1
80007158:	0af70a63          	beq	a4,a5,8000720c <sys_link+0x12c>
8000715c:	11212823          	sw	s2,272(sp)
  ip->nlink++;
80007160:	02e4d783          	lhu	a5,46(s1)
80007164:	00178793          	addi	a5,a5,1
80007168:	02f49723          	sh	a5,46(s1)
  iupdate(ip);
8000716c:	00048513          	mv	a0,s1
80007170:	ffffd097          	auipc	ra,0xffffd
80007174:	654080e7          	jalr	1620(ra) # 800047c4 <iupdate>
  iunlock(ip);
80007178:	00048513          	mv	a0,s1
8000717c:	ffffe097          	auipc	ra,0xffffe
80007180:	870080e7          	jalr	-1936(ra) # 800049ec <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80007184:	fe040593          	addi	a1,s0,-32
80007188:	f6040513          	addi	a0,s0,-160
8000718c:	ffffe097          	auipc	ra,0xffffe
80007190:	274080e7          	jalr	628(ra) # 80005400 <nameiparent>
80007194:	00050913          	mv	s2,a0
80007198:	0a050063          	beqz	a0,80007238 <sys_link+0x158>
  ilock(dp);
8000719c:	ffffd097          	auipc	ra,0xffffd
800071a0:	744080e7          	jalr	1860(ra) # 800048e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
800071a4:	00092703          	lw	a4,0(s2)
800071a8:	0004a783          	lw	a5,0(s1)
800071ac:	08f71063          	bne	a4,a5,8000722c <sys_link+0x14c>
800071b0:	0044a603          	lw	a2,4(s1)
800071b4:	fe040593          	addi	a1,s0,-32
800071b8:	00090513          	mv	a0,s2
800071bc:	ffffe097          	auipc	ra,0xffffe
800071c0:	0d8080e7          	jalr	216(ra) # 80005294 <dirlink>
800071c4:	06054463          	bltz	a0,8000722c <sys_link+0x14c>
  iunlockput(dp);
800071c8:	00090513          	mv	a0,s2
800071cc:	ffffe097          	auipc	ra,0xffffe
800071d0:	a20080e7          	jalr	-1504(ra) # 80004bec <iunlockput>
  iput(ip);
800071d4:	00048513          	mv	a0,s1
800071d8:	ffffe097          	auipc	ra,0xffffe
800071dc:	884080e7          	jalr	-1916(ra) # 80004a5c <iput>
  end_op();
800071e0:	ffffe097          	auipc	ra,0xffffe
800071e4:	564080e7          	jalr	1380(ra) # 80005744 <end_op>
  return 0;
800071e8:	00000793          	li	a5,0
800071ec:	11412483          	lw	s1,276(sp)
800071f0:	11012903          	lw	s2,272(sp)
800071f4:	0880006f          	j	8000727c <sys_link+0x19c>
    end_op();
800071f8:	ffffe097          	auipc	ra,0xffffe
800071fc:	54c080e7          	jalr	1356(ra) # 80005744 <end_op>
    return -1;
80007200:	fff00793          	li	a5,-1
80007204:	11412483          	lw	s1,276(sp)
80007208:	0740006f          	j	8000727c <sys_link+0x19c>
    iunlockput(ip);
8000720c:	00048513          	mv	a0,s1
80007210:	ffffe097          	auipc	ra,0xffffe
80007214:	9dc080e7          	jalr	-1572(ra) # 80004bec <iunlockput>
    end_op();
80007218:	ffffe097          	auipc	ra,0xffffe
8000721c:	52c080e7          	jalr	1324(ra) # 80005744 <end_op>
    return -1;
80007220:	fff00793          	li	a5,-1
80007224:	11412483          	lw	s1,276(sp)
80007228:	0540006f          	j	8000727c <sys_link+0x19c>
    iunlockput(dp);
8000722c:	00090513          	mv	a0,s2
80007230:	ffffe097          	auipc	ra,0xffffe
80007234:	9bc080e7          	jalr	-1604(ra) # 80004bec <iunlockput>
  ilock(ip);
80007238:	00048513          	mv	a0,s1
8000723c:	ffffd097          	auipc	ra,0xffffd
80007240:	6a4080e7          	jalr	1700(ra) # 800048e0 <ilock>
  ip->nlink--;
80007244:	02e4d783          	lhu	a5,46(s1)
80007248:	fff78793          	addi	a5,a5,-1
8000724c:	02f49723          	sh	a5,46(s1)
  iupdate(ip);
80007250:	00048513          	mv	a0,s1
80007254:	ffffd097          	auipc	ra,0xffffd
80007258:	570080e7          	jalr	1392(ra) # 800047c4 <iupdate>
  iunlockput(ip);
8000725c:	00048513          	mv	a0,s1
80007260:	ffffe097          	auipc	ra,0xffffe
80007264:	98c080e7          	jalr	-1652(ra) # 80004bec <iunlockput>
  end_op();
80007268:	ffffe097          	auipc	ra,0xffffe
8000726c:	4dc080e7          	jalr	1244(ra) # 80005744 <end_op>
  return -1;
80007270:	fff00793          	li	a5,-1
80007274:	11412483          	lw	s1,276(sp)
80007278:	11012903          	lw	s2,272(sp)
}
8000727c:	00078513          	mv	a0,a5
80007280:	11c12083          	lw	ra,284(sp)
80007284:	11812403          	lw	s0,280(sp)
80007288:	12010113          	addi	sp,sp,288
8000728c:	00008067          	ret

80007290 <sys_unlink>:
{
80007290:	f2010113          	addi	sp,sp,-224
80007294:	0c112e23          	sw	ra,220(sp)
80007298:	0c812c23          	sw	s0,216(sp)
8000729c:	0e010413          	addi	s0,sp,224
  if(argstr(0, path, MAXPATH) < 0)
800072a0:	08000613          	li	a2,128
800072a4:	f4040593          	addi	a1,s0,-192
800072a8:	00000513          	li	a0,0
800072ac:	ffffc097          	auipc	ra,0xffffc
800072b0:	718080e7          	jalr	1816(ra) # 800039c4 <argstr>
800072b4:	22054a63          	bltz	a0,800074e8 <sys_unlink+0x258>
800072b8:	0c912a23          	sw	s1,212(sp)
  begin_op();
800072bc:	ffffe097          	auipc	ra,0xffffe
800072c0:	3d8080e7          	jalr	984(ra) # 80005694 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
800072c4:	fc040593          	addi	a1,s0,-64
800072c8:	f4040513          	addi	a0,s0,-192
800072cc:	ffffe097          	auipc	ra,0xffffe
800072d0:	134080e7          	jalr	308(ra) # 80005400 <nameiparent>
800072d4:	00050493          	mv	s1,a0
800072d8:	10050863          	beqz	a0,800073e8 <sys_unlink+0x158>
  ilock(dp);
800072dc:	ffffd097          	auipc	ra,0xffffd
800072e0:	604080e7          	jalr	1540(ra) # 800048e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
800072e4:	00005597          	auipc	a1,0x5
800072e8:	b2c58593          	addi	a1,a1,-1236 # 8000be10 <userret+0x2d70>
800072ec:	fc040513          	addi	a0,s0,-64
800072f0:	ffffe097          	auipc	ra,0xffffe
800072f4:	c64080e7          	jalr	-924(ra) # 80004f54 <namecmp>
800072f8:	1c050263          	beqz	a0,800074bc <sys_unlink+0x22c>
800072fc:	00005597          	auipc	a1,0x5
80007300:	b1858593          	addi	a1,a1,-1256 # 8000be14 <userret+0x2d74>
80007304:	fc040513          	addi	a0,s0,-64
80007308:	ffffe097          	auipc	ra,0xffffe
8000730c:	c4c080e7          	jalr	-948(ra) # 80004f54 <namecmp>
80007310:	1a050663          	beqz	a0,800074bc <sys_unlink+0x22c>
80007314:	0d212823          	sw	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
80007318:	f3c40613          	addi	a2,s0,-196
8000731c:	fc040593          	addi	a1,s0,-64
80007320:	00048513          	mv	a0,s1
80007324:	ffffe097          	auipc	ra,0xffffe
80007328:	c5c080e7          	jalr	-932(ra) # 80004f80 <dirlookup>
8000732c:	00050913          	mv	s2,a0
80007330:	18050463          	beqz	a0,800074b8 <sys_unlink+0x228>
80007334:	0d312623          	sw	s3,204(sp)
  ilock(ip);
80007338:	ffffd097          	auipc	ra,0xffffd
8000733c:	5a8080e7          	jalr	1448(ra) # 800048e0 <ilock>
  if(ip->nlink < 1)
80007340:	02e91783          	lh	a5,46(s2)
80007344:	0af05c63          	blez	a5,800073fc <sys_unlink+0x16c>
  if(ip->type == T_DIR && !isdirempty(ip)){
80007348:	02891703          	lh	a4,40(s2)
8000734c:	00100793          	li	a5,1
80007350:	0cf70263          	beq	a4,a5,80007414 <sys_unlink+0x184>
  memset(&de, 0, sizeof(de));
80007354:	fd040993          	addi	s3,s0,-48
80007358:	01000613          	li	a2,16
8000735c:	00000593          	li	a1,0
80007360:	00098513          	mv	a0,s3
80007364:	ffffa097          	auipc	ra,0xffffa
80007368:	c64080e7          	jalr	-924(ra) # 80000fc8 <memset>
  if(writei(dp, 0, (uint32)&de, off, sizeof(de)) != sizeof(de))
8000736c:	01000713          	li	a4,16
80007370:	f3c42683          	lw	a3,-196(s0)
80007374:	00098613          	mv	a2,s3
80007378:	00000593          	li	a1,0
8000737c:	00048513          	mv	a0,s1
80007380:	ffffe097          	auipc	ra,0xffffe
80007384:	a5c080e7          	jalr	-1444(ra) # 80004ddc <writei>
80007388:	01000793          	li	a5,16
8000738c:	0ef51c63          	bne	a0,a5,80007484 <sys_unlink+0x1f4>
  if(ip->type == T_DIR){
80007390:	02891703          	lh	a4,40(s2)
80007394:	00100793          	li	a5,1
80007398:	10f70263          	beq	a4,a5,8000749c <sys_unlink+0x20c>
  iunlockput(dp);
8000739c:	00048513          	mv	a0,s1
800073a0:	ffffe097          	auipc	ra,0xffffe
800073a4:	84c080e7          	jalr	-1972(ra) # 80004bec <iunlockput>
  ip->nlink--;
800073a8:	02e95783          	lhu	a5,46(s2)
800073ac:	fff78793          	addi	a5,a5,-1
800073b0:	02f91723          	sh	a5,46(s2)
  iupdate(ip);
800073b4:	00090513          	mv	a0,s2
800073b8:	ffffd097          	auipc	ra,0xffffd
800073bc:	40c080e7          	jalr	1036(ra) # 800047c4 <iupdate>
  iunlockput(ip);
800073c0:	00090513          	mv	a0,s2
800073c4:	ffffe097          	auipc	ra,0xffffe
800073c8:	828080e7          	jalr	-2008(ra) # 80004bec <iunlockput>
  end_op();
800073cc:	ffffe097          	auipc	ra,0xffffe
800073d0:	378080e7          	jalr	888(ra) # 80005744 <end_op>
  return 0;
800073d4:	00000513          	li	a0,0
800073d8:	0d412483          	lw	s1,212(sp)
800073dc:	0d012903          	lw	s2,208(sp)
800073e0:	0cc12983          	lw	s3,204(sp)
800073e4:	0f40006f          	j	800074d8 <sys_unlink+0x248>
    end_op();
800073e8:	ffffe097          	auipc	ra,0xffffe
800073ec:	35c080e7          	jalr	860(ra) # 80005744 <end_op>
    return -1;
800073f0:	fff00513          	li	a0,-1
800073f4:	0d412483          	lw	s1,212(sp)
800073f8:	0e00006f          	j	800074d8 <sys_unlink+0x248>
800073fc:	0d412423          	sw	s4,200(sp)
80007400:	0d512223          	sw	s5,196(sp)
    panic("unlink: nlink < 1");
80007404:	00005517          	auipc	a0,0x5
80007408:	a3050513          	addi	a0,a0,-1488 # 8000be34 <userret+0x2d94>
8000740c:	ffff9097          	auipc	ra,0xffff9
80007410:	2f4080e7          	jalr	756(ra) # 80000700 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80007414:	03092703          	lw	a4,48(s2)
80007418:	02000793          	li	a5,32
8000741c:	f2e7fce3          	bgeu	a5,a4,80007354 <sys_unlink+0xc4>
80007420:	0d412423          	sw	s4,200(sp)
80007424:	0d512223          	sw	s5,196(sp)
80007428:	00078993          	mv	s3,a5
    if(readi(dp, 0, (uint32)&de, off, sizeof(de)) != sizeof(de))
8000742c:	f2c40a93          	addi	s5,s0,-212
80007430:	01000a13          	li	s4,16
80007434:	000a0713          	mv	a4,s4
80007438:	00098693          	mv	a3,s3
8000743c:	000a8613          	mv	a2,s5
80007440:	00000593          	li	a1,0
80007444:	00090513          	mv	a0,s2
80007448:	ffffe097          	auipc	ra,0xffffe
8000744c:	830080e7          	jalr	-2000(ra) # 80004c78 <readi>
80007450:	03451263          	bne	a0,s4,80007474 <sys_unlink+0x1e4>
    if(de.inum != 0)
80007454:	f2c45783          	lhu	a5,-212(s0)
80007458:	08079c63          	bnez	a5,800074f0 <sys_unlink+0x260>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8000745c:	01098993          	addi	s3,s3,16
80007460:	03092783          	lw	a5,48(s2)
80007464:	fcf9e8e3          	bltu	s3,a5,80007434 <sys_unlink+0x1a4>
80007468:	0c812a03          	lw	s4,200(sp)
8000746c:	0c412a83          	lw	s5,196(sp)
80007470:	ee5ff06f          	j	80007354 <sys_unlink+0xc4>
      panic("isdirempty: readi");
80007474:	00005517          	auipc	a0,0x5
80007478:	9d450513          	addi	a0,a0,-1580 # 8000be48 <userret+0x2da8>
8000747c:	ffff9097          	auipc	ra,0xffff9
80007480:	284080e7          	jalr	644(ra) # 80000700 <panic>
80007484:	0d412423          	sw	s4,200(sp)
80007488:	0d512223          	sw	s5,196(sp)
    panic("unlink: writei");
8000748c:	00005517          	auipc	a0,0x5
80007490:	9d050513          	addi	a0,a0,-1584 # 8000be5c <userret+0x2dbc>
80007494:	ffff9097          	auipc	ra,0xffff9
80007498:	26c080e7          	jalr	620(ra) # 80000700 <panic>
    dp->nlink--;
8000749c:	02e4d783          	lhu	a5,46(s1)
800074a0:	fff78793          	addi	a5,a5,-1
800074a4:	02f49723          	sh	a5,46(s1)
    iupdate(dp);
800074a8:	00048513          	mv	a0,s1
800074ac:	ffffd097          	auipc	ra,0xffffd
800074b0:	318080e7          	jalr	792(ra) # 800047c4 <iupdate>
800074b4:	ee9ff06f          	j	8000739c <sys_unlink+0x10c>
800074b8:	0d012903          	lw	s2,208(sp)
  iunlockput(dp);
800074bc:	00048513          	mv	a0,s1
800074c0:	ffffd097          	auipc	ra,0xffffd
800074c4:	72c080e7          	jalr	1836(ra) # 80004bec <iunlockput>
  end_op();
800074c8:	ffffe097          	auipc	ra,0xffffe
800074cc:	27c080e7          	jalr	636(ra) # 80005744 <end_op>
  return -1;
800074d0:	fff00513          	li	a0,-1
800074d4:	0d412483          	lw	s1,212(sp)
}
800074d8:	0dc12083          	lw	ra,220(sp)
800074dc:	0d812403          	lw	s0,216(sp)
800074e0:	0e010113          	addi	sp,sp,224
800074e4:	00008067          	ret
    return -1;
800074e8:	fff00513          	li	a0,-1
800074ec:	fedff06f          	j	800074d8 <sys_unlink+0x248>
    iunlockput(ip);
800074f0:	00090513          	mv	a0,s2
800074f4:	ffffd097          	auipc	ra,0xffffd
800074f8:	6f8080e7          	jalr	1784(ra) # 80004bec <iunlockput>
    goto bad;
800074fc:	0d012903          	lw	s2,208(sp)
80007500:	0cc12983          	lw	s3,204(sp)
80007504:	0c812a03          	lw	s4,200(sp)
80007508:	0c412a83          	lw	s5,196(sp)
8000750c:	fb1ff06f          	j	800074bc <sys_unlink+0x22c>

80007510 <sys_open>:

uint32
sys_open(void)
{
80007510:	f5010113          	addi	sp,sp,-176
80007514:	0a112623          	sw	ra,172(sp)
80007518:	0a812423          	sw	s0,168(sp)
8000751c:	0a912223          	sw	s1,164(sp)
80007520:	0b010413          	addi	s0,sp,176
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
80007524:	08000613          	li	a2,128
80007528:	f6040593          	addi	a1,s0,-160
8000752c:	00000513          	li	a0,0
80007530:	ffffc097          	auipc	ra,0xffffc
80007534:	494080e7          	jalr	1172(ra) # 800039c4 <argstr>
    return -1;
80007538:	fff00493          	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
8000753c:	0e054063          	bltz	a0,8000761c <sys_open+0x10c>
80007540:	f5c40593          	addi	a1,s0,-164
80007544:	00100513          	li	a0,1
80007548:	ffffc097          	auipc	ra,0xffffc
8000754c:	404080e7          	jalr	1028(ra) # 8000394c <argint>
80007550:	0c054663          	bltz	a0,8000761c <sys_open+0x10c>
80007554:	0b212023          	sw	s2,160(sp)

  begin_op();
80007558:	ffffe097          	auipc	ra,0xffffe
8000755c:	13c080e7          	jalr	316(ra) # 80005694 <begin_op>

  if(omode & O_CREATE){
80007560:	f5c42783          	lw	a5,-164(s0)
80007564:	2007f793          	andi	a5,a5,512
80007568:	0c078e63          	beqz	a5,80007644 <sys_open+0x134>
    ip = create(path, T_FILE, 0, 0);
8000756c:	00000693          	li	a3,0
80007570:	00000613          	li	a2,0
80007574:	00200593          	li	a1,2
80007578:	f6040513          	addi	a0,s0,-160
8000757c:	fffff097          	auipc	ra,0xfffff
80007580:	728080e7          	jalr	1832(ra) # 80006ca4 <create>
80007584:	00050913          	mv	s2,a0
    if(ip == 0){
80007588:	0a050663          	beqz	a0,80007634 <sys_open+0x124>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
8000758c:	02891703          	lh	a4,40(s2)
80007590:	00300793          	li	a5,3
80007594:	00f71863          	bne	a4,a5,800075a4 <sys_open+0x94>
80007598:	02a95703          	lhu	a4,42(s2)
8000759c:	00900793          	li	a5,9
800075a0:	10e7e463          	bltu	a5,a4,800076a8 <sys_open+0x198>
800075a4:	09312e23          	sw	s3,156(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
800075a8:	ffffe097          	auipc	ra,0xffffe
800075ac:	694080e7          	jalr	1684(ra) # 80005c3c <filealloc>
800075b0:	00050993          	mv	s3,a0
800075b4:	12050063          	beqz	a0,800076d4 <sys_open+0x1c4>
800075b8:	fffff097          	auipc	ra,0xfffff
800075bc:	67c080e7          	jalr	1660(ra) # 80006c34 <fdalloc>
800075c0:	00050493          	mv	s1,a0
800075c4:	10054263          	bltz	a0,800076c8 <sys_open+0x1b8>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
800075c8:	02891703          	lh	a4,40(s2)
800075cc:	00300793          	li	a5,3
800075d0:	12f70463          	beq	a4,a5,800076f8 <sys_open+0x1e8>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
800075d4:	00200793          	li	a5,2
800075d8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
800075dc:	0009aa23          	sw	zero,20(s3)
  }
  f->ip = ip;
800075e0:	0129a823          	sw	s2,16(s3)
  f->readable = !(omode & O_WRONLY);
800075e4:	f5c42783          	lw	a5,-164(s0)
800075e8:	0017f713          	andi	a4,a5,1
800075ec:	00174713          	xori	a4,a4,1
800075f0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
800075f4:	0037f793          	andi	a5,a5,3
800075f8:	00f037b3          	snez	a5,a5
800075fc:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
80007600:	00090513          	mv	a0,s2
80007604:	ffffd097          	auipc	ra,0xffffd
80007608:	3e8080e7          	jalr	1000(ra) # 800049ec <iunlock>
  end_op();
8000760c:	ffffe097          	auipc	ra,0xffffe
80007610:	138080e7          	jalr	312(ra) # 80005744 <end_op>
80007614:	0a012903          	lw	s2,160(sp)
80007618:	09c12983          	lw	s3,156(sp)

  return fd;
}
8000761c:	00048513          	mv	a0,s1
80007620:	0ac12083          	lw	ra,172(sp)
80007624:	0a812403          	lw	s0,168(sp)
80007628:	0a412483          	lw	s1,164(sp)
8000762c:	0b010113          	addi	sp,sp,176
80007630:	00008067          	ret
      end_op();
80007634:	ffffe097          	auipc	ra,0xffffe
80007638:	110080e7          	jalr	272(ra) # 80005744 <end_op>
      return -1;
8000763c:	0a012903          	lw	s2,160(sp)
80007640:	fddff06f          	j	8000761c <sys_open+0x10c>
    if((ip = namei(path)) == 0){
80007644:	f6040513          	addi	a0,s0,-160
80007648:	ffffe097          	auipc	ra,0xffffe
8000764c:	d88080e7          	jalr	-632(ra) # 800053d0 <namei>
80007650:	00050913          	mv	s2,a0
80007654:	04050063          	beqz	a0,80007694 <sys_open+0x184>
    ilock(ip);
80007658:	ffffd097          	auipc	ra,0xffffd
8000765c:	288080e7          	jalr	648(ra) # 800048e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80007660:	02891703          	lh	a4,40(s2)
80007664:	00100793          	li	a5,1
80007668:	f2f712e3          	bne	a4,a5,8000758c <sys_open+0x7c>
8000766c:	f5c42783          	lw	a5,-164(s0)
80007670:	f2078ae3          	beqz	a5,800075a4 <sys_open+0x94>
      iunlockput(ip);
80007674:	00090513          	mv	a0,s2
80007678:	ffffd097          	auipc	ra,0xffffd
8000767c:	574080e7          	jalr	1396(ra) # 80004bec <iunlockput>
      end_op();
80007680:	ffffe097          	auipc	ra,0xffffe
80007684:	0c4080e7          	jalr	196(ra) # 80005744 <end_op>
      return -1;
80007688:	fff00493          	li	s1,-1
8000768c:	0a012903          	lw	s2,160(sp)
80007690:	f8dff06f          	j	8000761c <sys_open+0x10c>
      end_op();
80007694:	ffffe097          	auipc	ra,0xffffe
80007698:	0b0080e7          	jalr	176(ra) # 80005744 <end_op>
      return -1;
8000769c:	fff00493          	li	s1,-1
800076a0:	0a012903          	lw	s2,160(sp)
800076a4:	f79ff06f          	j	8000761c <sys_open+0x10c>
    iunlockput(ip);
800076a8:	00090513          	mv	a0,s2
800076ac:	ffffd097          	auipc	ra,0xffffd
800076b0:	540080e7          	jalr	1344(ra) # 80004bec <iunlockput>
    end_op();
800076b4:	ffffe097          	auipc	ra,0xffffe
800076b8:	090080e7          	jalr	144(ra) # 80005744 <end_op>
    return -1;
800076bc:	fff00493          	li	s1,-1
800076c0:	0a012903          	lw	s2,160(sp)
800076c4:	f59ff06f          	j	8000761c <sys_open+0x10c>
      fileclose(f);
800076c8:	00098513          	mv	a0,s3
800076cc:	ffffe097          	auipc	ra,0xffffe
800076d0:	66c080e7          	jalr	1644(ra) # 80005d38 <fileclose>
    iunlockput(ip);
800076d4:	00090513          	mv	a0,s2
800076d8:	ffffd097          	auipc	ra,0xffffd
800076dc:	514080e7          	jalr	1300(ra) # 80004bec <iunlockput>
    end_op();
800076e0:	ffffe097          	auipc	ra,0xffffe
800076e4:	064080e7          	jalr	100(ra) # 80005744 <end_op>
    return -1;
800076e8:	fff00493          	li	s1,-1
800076ec:	0a012903          	lw	s2,160(sp)
800076f0:	09c12983          	lw	s3,156(sp)
800076f4:	f29ff06f          	j	8000761c <sys_open+0x10c>
    f->type = FD_DEVICE;
800076f8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
800076fc:	02a91783          	lh	a5,42(s2)
80007700:	00f99c23          	sh	a5,24(s3)
80007704:	eddff06f          	j	800075e0 <sys_open+0xd0>

80007708 <sys_mkdir>:

uint32
sys_mkdir(void)
{
80007708:	f7010113          	addi	sp,sp,-144
8000770c:	08112623          	sw	ra,140(sp)
80007710:	08812423          	sw	s0,136(sp)
80007714:	09010413          	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
80007718:	ffffe097          	auipc	ra,0xffffe
8000771c:	f7c080e7          	jalr	-132(ra) # 80005694 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80007720:	08000613          	li	a2,128
80007724:	f7040593          	addi	a1,s0,-144
80007728:	00000513          	li	a0,0
8000772c:	ffffc097          	auipc	ra,0xffffc
80007730:	298080e7          	jalr	664(ra) # 800039c4 <argstr>
80007734:	04054263          	bltz	a0,80007778 <sys_mkdir+0x70>
80007738:	00000693          	li	a3,0
8000773c:	00000613          	li	a2,0
80007740:	00100593          	li	a1,1
80007744:	f7040513          	addi	a0,s0,-144
80007748:	fffff097          	auipc	ra,0xfffff
8000774c:	55c080e7          	jalr	1372(ra) # 80006ca4 <create>
80007750:	02050463          	beqz	a0,80007778 <sys_mkdir+0x70>
    end_op();
    return -1;
  }
  iunlockput(ip);
80007754:	ffffd097          	auipc	ra,0xffffd
80007758:	498080e7          	jalr	1176(ra) # 80004bec <iunlockput>
  end_op();
8000775c:	ffffe097          	auipc	ra,0xffffe
80007760:	fe8080e7          	jalr	-24(ra) # 80005744 <end_op>
  return 0;
80007764:	00000513          	li	a0,0
}
80007768:	08c12083          	lw	ra,140(sp)
8000776c:	08812403          	lw	s0,136(sp)
80007770:	09010113          	addi	sp,sp,144
80007774:	00008067          	ret
    end_op();
80007778:	ffffe097          	auipc	ra,0xffffe
8000777c:	fcc080e7          	jalr	-52(ra) # 80005744 <end_op>
    return -1;
80007780:	fff00513          	li	a0,-1
80007784:	fe5ff06f          	j	80007768 <sys_mkdir+0x60>

80007788 <sys_mknod>:

uint32
sys_mknod(void)
{
80007788:	f6010113          	addi	sp,sp,-160
8000778c:	08112e23          	sw	ra,156(sp)
80007790:	08812c23          	sw	s0,152(sp)
80007794:	0a010413          	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
80007798:	ffffe097          	auipc	ra,0xffffe
8000779c:	efc080e7          	jalr	-260(ra) # 80005694 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
800077a0:	08000613          	li	a2,128
800077a4:	f7040593          	addi	a1,s0,-144
800077a8:	00000513          	li	a0,0
800077ac:	ffffc097          	auipc	ra,0xffffc
800077b0:	218080e7          	jalr	536(ra) # 800039c4 <argstr>
800077b4:	06054063          	bltz	a0,80007814 <sys_mknod+0x8c>
     argint(1, &major) < 0 ||
800077b8:	f6c40593          	addi	a1,s0,-148
800077bc:	00100513          	li	a0,1
800077c0:	ffffc097          	auipc	ra,0xffffc
800077c4:	18c080e7          	jalr	396(ra) # 8000394c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
800077c8:	04054663          	bltz	a0,80007814 <sys_mknod+0x8c>
     argint(2, &minor) < 0 ||
800077cc:	f6840593          	addi	a1,s0,-152
800077d0:	00200513          	li	a0,2
800077d4:	ffffc097          	auipc	ra,0xffffc
800077d8:	178080e7          	jalr	376(ra) # 8000394c <argint>
     argint(1, &major) < 0 ||
800077dc:	02054c63          	bltz	a0,80007814 <sys_mknod+0x8c>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
800077e0:	f6841683          	lh	a3,-152(s0)
800077e4:	f6c41603          	lh	a2,-148(s0)
800077e8:	00300593          	li	a1,3
800077ec:	f7040513          	addi	a0,s0,-144
800077f0:	fffff097          	auipc	ra,0xfffff
800077f4:	4b4080e7          	jalr	1204(ra) # 80006ca4 <create>
     argint(2, &minor) < 0 ||
800077f8:	00050e63          	beqz	a0,80007814 <sys_mknod+0x8c>
    end_op();
    return -1;
  }
  iunlockput(ip);
800077fc:	ffffd097          	auipc	ra,0xffffd
80007800:	3f0080e7          	jalr	1008(ra) # 80004bec <iunlockput>
  end_op();
80007804:	ffffe097          	auipc	ra,0xffffe
80007808:	f40080e7          	jalr	-192(ra) # 80005744 <end_op>
  return 0;
8000780c:	00000513          	li	a0,0
80007810:	0100006f          	j	80007820 <sys_mknod+0x98>
    end_op();
80007814:	ffffe097          	auipc	ra,0xffffe
80007818:	f30080e7          	jalr	-208(ra) # 80005744 <end_op>
    return -1;
8000781c:	fff00513          	li	a0,-1
}
80007820:	09c12083          	lw	ra,156(sp)
80007824:	09812403          	lw	s0,152(sp)
80007828:	0a010113          	addi	sp,sp,160
8000782c:	00008067          	ret

80007830 <sys_chdir>:

uint32
sys_chdir(void)
{
80007830:	f7010113          	addi	sp,sp,-144
80007834:	08112623          	sw	ra,140(sp)
80007838:	08812423          	sw	s0,136(sp)
8000783c:	09212023          	sw	s2,128(sp)
80007840:	09010413          	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
80007844:	ffffb097          	auipc	ra,0xffffb
80007848:	a98080e7          	jalr	-1384(ra) # 800022dc <myproc>
8000784c:	00050913          	mv	s2,a0
  
  begin_op();
80007850:	ffffe097          	auipc	ra,0xffffe
80007854:	e44080e7          	jalr	-444(ra) # 80005694 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
80007858:	08000613          	li	a2,128
8000785c:	f7040593          	addi	a1,s0,-144
80007860:	00000513          	li	a0,0
80007864:	ffffc097          	auipc	ra,0xffffc
80007868:	160080e7          	jalr	352(ra) # 800039c4 <argstr>
8000786c:	06054a63          	bltz	a0,800078e0 <sys_chdir+0xb0>
80007870:	08912223          	sw	s1,132(sp)
80007874:	f7040513          	addi	a0,s0,-144
80007878:	ffffe097          	auipc	ra,0xffffe
8000787c:	b58080e7          	jalr	-1192(ra) # 800053d0 <namei>
80007880:	00050493          	mv	s1,a0
80007884:	04050c63          	beqz	a0,800078dc <sys_chdir+0xac>
    end_op();
    return -1;
  }
  ilock(ip);
80007888:	ffffd097          	auipc	ra,0xffffd
8000788c:	058080e7          	jalr	88(ra) # 800048e0 <ilock>
  if(ip->type != T_DIR){
80007890:	02849703          	lh	a4,40(s1)
80007894:	00100793          	li	a5,1
80007898:	04f71c63          	bne	a4,a5,800078f0 <sys_chdir+0xc0>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8000789c:	00048513          	mv	a0,s1
800078a0:	ffffd097          	auipc	ra,0xffffd
800078a4:	14c080e7          	jalr	332(ra) # 800049ec <iunlock>
  iput(p->cwd);
800078a8:	0ac92503          	lw	a0,172(s2)
800078ac:	ffffd097          	auipc	ra,0xffffd
800078b0:	1b0080e7          	jalr	432(ra) # 80004a5c <iput>
  end_op();
800078b4:	ffffe097          	auipc	ra,0xffffe
800078b8:	e90080e7          	jalr	-368(ra) # 80005744 <end_op>
  p->cwd = ip;
800078bc:	0a992623          	sw	s1,172(s2)
  return 0;
800078c0:	00000513          	li	a0,0
800078c4:	08412483          	lw	s1,132(sp)
}
800078c8:	08c12083          	lw	ra,140(sp)
800078cc:	08812403          	lw	s0,136(sp)
800078d0:	08012903          	lw	s2,128(sp)
800078d4:	09010113          	addi	sp,sp,144
800078d8:	00008067          	ret
800078dc:	08412483          	lw	s1,132(sp)
    end_op();
800078e0:	ffffe097          	auipc	ra,0xffffe
800078e4:	e64080e7          	jalr	-412(ra) # 80005744 <end_op>
    return -1;
800078e8:	fff00513          	li	a0,-1
800078ec:	fddff06f          	j	800078c8 <sys_chdir+0x98>
    iunlockput(ip);
800078f0:	00048513          	mv	a0,s1
800078f4:	ffffd097          	auipc	ra,0xffffd
800078f8:	2f8080e7          	jalr	760(ra) # 80004bec <iunlockput>
    end_op();
800078fc:	ffffe097          	auipc	ra,0xffffe
80007900:	e48080e7          	jalr	-440(ra) # 80005744 <end_op>
    return -1;
80007904:	fff00513          	li	a0,-1
80007908:	08412483          	lw	s1,132(sp)
8000790c:	fbdff06f          	j	800078c8 <sys_chdir+0x98>

80007910 <sys_exec>:

uint32
sys_exec(void)
{
80007910:	ec010113          	addi	sp,sp,-320
80007914:	12112e23          	sw	ra,316(sp)
80007918:	12812c23          	sw	s0,312(sp)
8000791c:	14010413          	addi	s0,sp,320
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint32 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
80007920:	08000613          	li	a2,128
80007924:	f5040593          	addi	a1,s0,-176
80007928:	00000513          	li	a0,0
8000792c:	ffffc097          	auipc	ra,0xffffc
80007930:	098080e7          	jalr	152(ra) # 800039c4 <argstr>
80007934:	18054863          	bltz	a0,80007ac4 <sys_exec+0x1b4>
80007938:	ecc40593          	addi	a1,s0,-308
8000793c:	00100513          	li	a0,1
80007940:	ffffc097          	auipc	ra,0xffffc
80007944:	048080e7          	jalr	72(ra) # 80003988 <argaddr>
80007948:	18054863          	bltz	a0,80007ad8 <sys_exec+0x1c8>
8000794c:	12912a23          	sw	s1,308(sp)
80007950:	13212823          	sw	s2,304(sp)
80007954:	13312623          	sw	s3,300(sp)
80007958:	13412423          	sw	s4,296(sp)
8000795c:	13512223          	sw	s5,292(sp)
80007960:	13612023          	sw	s6,288(sp)
80007964:	11712e23          	sw	s7,284(sp)
    return -1;
  }

  memset(argv, 0, sizeof(argv));
80007968:	ed040a13          	addi	s4,s0,-304
8000796c:	08000613          	li	a2,128
80007970:	00000593          	li	a1,0
80007974:	000a0513          	mv	a0,s4
80007978:	ffff9097          	auipc	ra,0xffff9
8000797c:	650080e7          	jalr	1616(ra) # 80000fc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
80007980:	000a0493          	mv	s1,s4
  memset(argv, 0, sizeof(argv));
80007984:	000a0993          	mv	s3,s4
  for(i=0;; i++){
80007988:	00000913          	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint32)*i, (uint32*)&uarg) < 0){
8000798c:	ec840a93          	addi	s5,s0,-312
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
80007990:	00001b37          	lui	s6,0x1
    if(i >= NELEM(argv)){
80007994:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint32)*i, (uint32*)&uarg) < 0){
80007998:	00291513          	slli	a0,s2,0x2
8000799c:	000a8593          	mv	a1,s5
800079a0:	ecc42783          	lw	a5,-308(s0)
800079a4:	00f50533          	add	a0,a0,a5
800079a8:	ffffc097          	auipc	ra,0xffffc
800079ac:	eb0080e7          	jalr	-336(ra) # 80003858 <fetchaddr>
800079b0:	04054063          	bltz	a0,800079f0 <sys_exec+0xe0>
    if(uarg == 0){
800079b4:	ec842783          	lw	a5,-312(s0)
800079b8:	06078c63          	beqz	a5,80007a30 <sys_exec+0x120>
    argv[i] = kalloc();
800079bc:	ffff9097          	auipc	ra,0xffff9
800079c0:	324080e7          	jalr	804(ra) # 80000ce0 <kalloc>
800079c4:	00050593          	mv	a1,a0
800079c8:	00a9a023          	sw	a0,0(s3)
    if(argv[i] == 0)
800079cc:	0c050263          	beqz	a0,80007a90 <sys_exec+0x180>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
800079d0:	000b0613          	mv	a2,s6
800079d4:	ec842503          	lw	a0,-312(s0)
800079d8:	ffffc097          	auipc	ra,0xffffc
800079dc:	f00080e7          	jalr	-256(ra) # 800038d8 <fetchstr>
800079e0:	00054863          	bltz	a0,800079f0 <sys_exec+0xe0>
  for(i=0;; i++){
800079e4:	00190913          	addi	s2,s2,1
    if(i >= NELEM(argv)){
800079e8:	00498993          	addi	s3,s3,4
800079ec:	fb7916e3          	bne	s2,s7,80007998 <sys_exec+0x88>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
800079f0:	080a0a13          	addi	s4,s4,128
800079f4:	0004a503          	lw	a0,0(s1)
800079f8:	0a050463          	beqz	a0,80007aa0 <sys_exec+0x190>
    kfree(argv[i]);
800079fc:	ffff9097          	auipc	ra,0xffff9
80007a00:	180080e7          	jalr	384(ra) # 80000b7c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
80007a04:	00448493          	addi	s1,s1,4
80007a08:	ff4496e3          	bne	s1,s4,800079f4 <sys_exec+0xe4>
  return -1;
80007a0c:	fff00513          	li	a0,-1
80007a10:	13412483          	lw	s1,308(sp)
80007a14:	13012903          	lw	s2,304(sp)
80007a18:	12c12983          	lw	s3,300(sp)
80007a1c:	12812a03          	lw	s4,296(sp)
80007a20:	12412a83          	lw	s5,292(sp)
80007a24:	12012b03          	lw	s6,288(sp)
80007a28:	11c12b83          	lw	s7,284(sp)
80007a2c:	09c0006f          	j	80007ac8 <sys_exec+0x1b8>
      argv[i] = 0;
80007a30:	ed040593          	addi	a1,s0,-304
80007a34:	00291913          	slli	s2,s2,0x2
80007a38:	00b90933          	add	s2,s2,a1
80007a3c:	00092023          	sw	zero,0(s2)
  int ret = exec(path, argv);
80007a40:	f5040513          	addi	a0,s0,-176
80007a44:	fffff097          	auipc	ra,0xfffff
80007a48:	ce0080e7          	jalr	-800(ra) # 80006724 <exec>
80007a4c:	00050913          	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
80007a50:	080a0a13          	addi	s4,s4,128
80007a54:	0004a503          	lw	a0,0(s1)
80007a58:	00050a63          	beqz	a0,80007a6c <sys_exec+0x15c>
    kfree(argv[i]);
80007a5c:	ffff9097          	auipc	ra,0xffff9
80007a60:	120080e7          	jalr	288(ra) # 80000b7c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
80007a64:	00448493          	addi	s1,s1,4
80007a68:	ff4496e3          	bne	s1,s4,80007a54 <sys_exec+0x144>
  return ret;
80007a6c:	00090513          	mv	a0,s2
80007a70:	13412483          	lw	s1,308(sp)
80007a74:	13012903          	lw	s2,304(sp)
80007a78:	12c12983          	lw	s3,300(sp)
80007a7c:	12812a03          	lw	s4,296(sp)
80007a80:	12412a83          	lw	s5,292(sp)
80007a84:	12012b03          	lw	s6,288(sp)
80007a88:	11c12b83          	lw	s7,284(sp)
80007a8c:	03c0006f          	j	80007ac8 <sys_exec+0x1b8>
      panic("sys_exec kalloc");
80007a90:	00004517          	auipc	a0,0x4
80007a94:	3dc50513          	addi	a0,a0,988 # 8000be6c <userret+0x2dcc>
80007a98:	ffff9097          	auipc	ra,0xffff9
80007a9c:	c68080e7          	jalr	-920(ra) # 80000700 <panic>
  return -1;
80007aa0:	fff00513          	li	a0,-1
80007aa4:	13412483          	lw	s1,308(sp)
80007aa8:	13012903          	lw	s2,304(sp)
80007aac:	12c12983          	lw	s3,300(sp)
80007ab0:	12812a03          	lw	s4,296(sp)
80007ab4:	12412a83          	lw	s5,292(sp)
80007ab8:	12012b03          	lw	s6,288(sp)
80007abc:	11c12b83          	lw	s7,284(sp)
80007ac0:	0080006f          	j	80007ac8 <sys_exec+0x1b8>
    return -1;
80007ac4:	fff00513          	li	a0,-1
}
80007ac8:	13c12083          	lw	ra,316(sp)
80007acc:	13812403          	lw	s0,312(sp)
80007ad0:	14010113          	addi	sp,sp,320
80007ad4:	00008067          	ret
    return -1;
80007ad8:	fff00513          	li	a0,-1
80007adc:	fedff06f          	j	80007ac8 <sys_exec+0x1b8>

80007ae0 <sys_pipe>:

uint32
sys_pipe(void)
{
80007ae0:	fd010113          	addi	sp,sp,-48
80007ae4:	02112623          	sw	ra,44(sp)
80007ae8:	02812423          	sw	s0,40(sp)
80007aec:	02912223          	sw	s1,36(sp)
80007af0:	03010413          	addi	s0,sp,48
  uint32 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
80007af4:	ffffa097          	auipc	ra,0xffffa
80007af8:	7e8080e7          	jalr	2024(ra) # 800022dc <myproc>
80007afc:	00050493          	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
80007b00:	fec40593          	addi	a1,s0,-20
80007b04:	00000513          	li	a0,0
80007b08:	ffffc097          	auipc	ra,0xffffc
80007b0c:	e80080e7          	jalr	-384(ra) # 80003988 <argaddr>
    return -1;
80007b10:	fff00793          	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
80007b14:	10054263          	bltz	a0,80007c18 <sys_pipe+0x138>
  if(pipealloc(&rf, &wf) < 0)
80007b18:	fe440593          	addi	a1,s0,-28
80007b1c:	fe840513          	addi	a0,s0,-24
80007b20:	ffffe097          	auipc	ra,0xffffe
80007b24:	744080e7          	jalr	1860(ra) # 80006264 <pipealloc>
    return -1;
80007b28:	fff00793          	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
80007b2c:	0e054663          	bltz	a0,80007c18 <sys_pipe+0x138>
  fd0 = -1;
80007b30:	fef42023          	sw	a5,-32(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80007b34:	fe842503          	lw	a0,-24(s0)
80007b38:	fffff097          	auipc	ra,0xfffff
80007b3c:	0fc080e7          	jalr	252(ra) # 80006c34 <fdalloc>
80007b40:	fea42023          	sw	a0,-32(s0)
80007b44:	0a054c63          	bltz	a0,80007bfc <sys_pipe+0x11c>
80007b48:	fe442503          	lw	a0,-28(s0)
80007b4c:	fffff097          	auipc	ra,0xfffff
80007b50:	0e8080e7          	jalr	232(ra) # 80006c34 <fdalloc>
80007b54:	fca42e23          	sw	a0,-36(s0)
80007b58:	08054663          	bltz	a0,80007be4 <sys_pipe+0x104>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
80007b5c:	00400693          	li	a3,4
80007b60:	fe040613          	addi	a2,s0,-32
80007b64:	fec42583          	lw	a1,-20(s0)
80007b68:	02c4a503          	lw	a0,44(s1)
80007b6c:	ffffa097          	auipc	ra,0xffffa
80007b70:	2b0080e7          	jalr	688(ra) # 80001e1c <copyout>
80007b74:	02054463          	bltz	a0,80007b9c <sys_pipe+0xbc>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
80007b78:	00400693          	li	a3,4
80007b7c:	fdc40613          	addi	a2,s0,-36
80007b80:	fec42583          	lw	a1,-20(s0)
80007b84:	00d585b3          	add	a1,a1,a3
80007b88:	02c4a503          	lw	a0,44(s1)
80007b8c:	ffffa097          	auipc	ra,0xffffa
80007b90:	290080e7          	jalr	656(ra) # 80001e1c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
80007b94:	00000793          	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
80007b98:	08055063          	bgez	a0,80007c18 <sys_pipe+0x138>
    p->ofile[fd0] = 0;
80007b9c:	fe042783          	lw	a5,-32(s0)
80007ba0:	01878793          	addi	a5,a5,24
80007ba4:	00279793          	slli	a5,a5,0x2
80007ba8:	00f487b3          	add	a5,s1,a5
80007bac:	0007a623          	sw	zero,12(a5)
    p->ofile[fd1] = 0;
80007bb0:	fdc42783          	lw	a5,-36(s0)
80007bb4:	01878793          	addi	a5,a5,24
80007bb8:	00279793          	slli	a5,a5,0x2
80007bbc:	00f48533          	add	a0,s1,a5
80007bc0:	00052623          	sw	zero,12(a0)
    fileclose(rf);
80007bc4:	fe842503          	lw	a0,-24(s0)
80007bc8:	ffffe097          	auipc	ra,0xffffe
80007bcc:	170080e7          	jalr	368(ra) # 80005d38 <fileclose>
    fileclose(wf);
80007bd0:	fe442503          	lw	a0,-28(s0)
80007bd4:	ffffe097          	auipc	ra,0xffffe
80007bd8:	164080e7          	jalr	356(ra) # 80005d38 <fileclose>
    return -1;
80007bdc:	fff00793          	li	a5,-1
80007be0:	0380006f          	j	80007c18 <sys_pipe+0x138>
    if(fd0 >= 0)
80007be4:	fe042783          	lw	a5,-32(s0)
80007be8:	0007ca63          	bltz	a5,80007bfc <sys_pipe+0x11c>
      p->ofile[fd0] = 0;
80007bec:	01878793          	addi	a5,a5,24
80007bf0:	00279793          	slli	a5,a5,0x2
80007bf4:	00f487b3          	add	a5,s1,a5
80007bf8:	0007a623          	sw	zero,12(a5)
    fileclose(rf);
80007bfc:	fe842503          	lw	a0,-24(s0)
80007c00:	ffffe097          	auipc	ra,0xffffe
80007c04:	138080e7          	jalr	312(ra) # 80005d38 <fileclose>
    fileclose(wf);
80007c08:	fe442503          	lw	a0,-28(s0)
80007c0c:	ffffe097          	auipc	ra,0xffffe
80007c10:	12c080e7          	jalr	300(ra) # 80005d38 <fileclose>
    return -1;
80007c14:	fff00793          	li	a5,-1
}
80007c18:	00078513          	mv	a0,a5
80007c1c:	02c12083          	lw	ra,44(sp)
80007c20:	02812403          	lw	s0,40(sp)
80007c24:	02412483          	lw	s1,36(sp)
80007c28:	03010113          	addi	sp,sp,48
80007c2c:	00008067          	ret

80007c30 <kernelvec>:
80007c30:	f8010113          	addi	sp,sp,-128
80007c34:	00112023          	sw	ra,0(sp)
80007c38:	00212223          	sw	sp,4(sp)
80007c3c:	00312423          	sw	gp,8(sp)
80007c40:	00412623          	sw	tp,12(sp)
80007c44:	00512823          	sw	t0,16(sp)
80007c48:	00612a23          	sw	t1,20(sp)
80007c4c:	00712c23          	sw	t2,24(sp)
80007c50:	00812e23          	sw	s0,28(sp)
80007c54:	02912023          	sw	s1,32(sp)
80007c58:	02a12223          	sw	a0,36(sp)
80007c5c:	02b12423          	sw	a1,40(sp)
80007c60:	02c12623          	sw	a2,44(sp)
80007c64:	02d12823          	sw	a3,48(sp)
80007c68:	02e12a23          	sw	a4,52(sp)
80007c6c:	02f12c23          	sw	a5,56(sp)
80007c70:	03012e23          	sw	a6,60(sp)
80007c74:	05112023          	sw	a7,64(sp)
80007c78:	05212223          	sw	s2,68(sp)
80007c7c:	05312423          	sw	s3,72(sp)
80007c80:	05412623          	sw	s4,76(sp)
80007c84:	05512823          	sw	s5,80(sp)
80007c88:	05612a23          	sw	s6,84(sp)
80007c8c:	05712c23          	sw	s7,88(sp)
80007c90:	05812e23          	sw	s8,92(sp)
80007c94:	07912023          	sw	s9,96(sp)
80007c98:	07a12223          	sw	s10,100(sp)
80007c9c:	07b12423          	sw	s11,104(sp)
80007ca0:	07c12623          	sw	t3,108(sp)
80007ca4:	07d12823          	sw	t4,112(sp)
80007ca8:	07e12a23          	sw	t5,116(sp)
80007cac:	07f12c23          	sw	t6,120(sp)
80007cb0:	a01fb0ef          	jal	800036b0 <kerneltrap>
80007cb4:	00012083          	lw	ra,0(sp)
80007cb8:	00412103          	lw	sp,4(sp)
80007cbc:	00812183          	lw	gp,8(sp)
80007cc0:	01012283          	lw	t0,16(sp)
80007cc4:	01412303          	lw	t1,20(sp)
80007cc8:	01812383          	lw	t2,24(sp)
80007ccc:	01c12403          	lw	s0,28(sp)
80007cd0:	02012483          	lw	s1,32(sp)
80007cd4:	02412503          	lw	a0,36(sp)
80007cd8:	02812583          	lw	a1,40(sp)
80007cdc:	02c12603          	lw	a2,44(sp)
80007ce0:	03012683          	lw	a3,48(sp)
80007ce4:	03412703          	lw	a4,52(sp)
80007ce8:	03812783          	lw	a5,56(sp)
80007cec:	03c12803          	lw	a6,60(sp)
80007cf0:	04012883          	lw	a7,64(sp)
80007cf4:	04412903          	lw	s2,68(sp)
80007cf8:	04812983          	lw	s3,72(sp)
80007cfc:	04c12a03          	lw	s4,76(sp)
80007d00:	05012a83          	lw	s5,80(sp)
80007d04:	05412b03          	lw	s6,84(sp)
80007d08:	05812b83          	lw	s7,88(sp)
80007d0c:	05c12c03          	lw	s8,92(sp)
80007d10:	06012c83          	lw	s9,96(sp)
80007d14:	06412d03          	lw	s10,100(sp)
80007d18:	06812d83          	lw	s11,104(sp)
80007d1c:	06c12e03          	lw	t3,108(sp)
80007d20:	07012e83          	lw	t4,112(sp)
80007d24:	07412f03          	lw	t5,116(sp)
80007d28:	07812f83          	lw	t6,120(sp)
80007d2c:	08010113          	addi	sp,sp,128
80007d30:	10200073          	sret
80007d34:	00000013          	nop
80007d38:	00000013          	nop
80007d3c:	00000013          	nop

80007d40 <timervec>:
80007d40:	34051573          	csrrw	a0,mscratch,a0
80007d44:	00b52023          	sw	a1,0(a0)
80007d48:	00c52223          	sw	a2,4(a0)
80007d4c:	00d52423          	sw	a3,8(a0)
80007d50:	00e52623          	sw	a4,12(a0)
80007d54:	01052583          	lw	a1,16(a0)
80007d58:	01452603          	lw	a2,20(a0)
80007d5c:	0005a683          	lw	a3,0(a1)
80007d60:	0045a703          	lw	a4,4(a1)
80007d64:	00c686b3          	add	a3,a3,a2
80007d68:	00c6b633          	sltu	a2,a3,a2
80007d6c:	00c70733          	add	a4,a4,a2
80007d70:	fff00613          	li	a2,-1
80007d74:	00c5a023          	sw	a2,0(a1)
80007d78:	00e5a223          	sw	a4,4(a1)
80007d7c:	00d5a023          	sw	a3,0(a1)
80007d80:	00200593          	li	a1,2
80007d84:	14459073          	csrw	sip,a1
80007d88:	00c52703          	lw	a4,12(a0)
80007d8c:	00852683          	lw	a3,8(a0)
80007d90:	00452603          	lw	a2,4(a0)
80007d94:	00052583          	lw	a1,0(a0)
80007d98:	34051573          	csrrw	a0,mscratch,a0
80007d9c:	30200073          	mret

80007da0 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
80007da0:	ff010113          	addi	sp,sp,-16
80007da4:	00112623          	sw	ra,12(sp)
80007da8:	00812423          	sw	s0,8(sp)
80007dac:	01010413          	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
80007db0:	0c000737          	lui	a4,0xc000
80007db4:	00100793          	li	a5,1
80007db8:	02f72423          	sw	a5,40(a4) # c000028 <_entry-0x73ffffd8>
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
80007dbc:	00f72223          	sw	a5,4(a4)
}
80007dc0:	00c12083          	lw	ra,12(sp)
80007dc4:	00812403          	lw	s0,8(sp)
80007dc8:	01010113          	addi	sp,sp,16
80007dcc:	00008067          	ret

80007dd0 <plicinithart>:

void
plicinithart(void)
{
80007dd0:	ff010113          	addi	sp,sp,-16
80007dd4:	00112623          	sw	ra,12(sp)
80007dd8:	00812423          	sw	s0,8(sp)
80007ddc:	01010413          	addi	s0,sp,16
  int hart = cpuid();
80007de0:	ffffa097          	auipc	ra,0xffffa
80007de4:	49c080e7          	jalr	1180(ra) # 8000227c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
80007de8:	00851713          	slli	a4,a0,0x8
80007dec:	0c0027b7          	lui	a5,0xc002
80007df0:	00e787b3          	add	a5,a5,a4
80007df4:	40200713          	li	a4,1026
80007df8:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
80007dfc:	00d51513          	slli	a0,a0,0xd
80007e00:	0c2017b7          	lui	a5,0xc201
80007e04:	00a787b3          	add	a5,a5,a0
80007e08:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
80007e0c:	00c12083          	lw	ra,12(sp)
80007e10:	00812403          	lw	s0,8(sp)
80007e14:	01010113          	addi	sp,sp,16
80007e18:	00008067          	ret

80007e1c <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint32
plic_pending(void)
{
80007e1c:	ff010113          	addi	sp,sp,-16
80007e20:	00112623          	sw	ra,12(sp)
80007e24:	00812423          	sw	s0,8(sp)
80007e28:	01010413          	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint32*)PLIC_PENDING;

  return mask;
}
80007e2c:	0c0017b7          	lui	a5,0xc001
80007e30:	0007a503          	lw	a0,0(a5) # c001000 <_entry-0x73fff000>
80007e34:	00c12083          	lw	ra,12(sp)
80007e38:	00812403          	lw	s0,8(sp)
80007e3c:	01010113          	addi	sp,sp,16
80007e40:	00008067          	ret

80007e44 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
80007e44:	ff010113          	addi	sp,sp,-16
80007e48:	00112623          	sw	ra,12(sp)
80007e4c:	00812423          	sw	s0,8(sp)
80007e50:	01010413          	addi	s0,sp,16
  int hart = cpuid();
80007e54:	ffffa097          	auipc	ra,0xffffa
80007e58:	428080e7          	jalr	1064(ra) # 8000227c <cpuid>
  // int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
80007e5c:	00d51513          	slli	a0,a0,0xd
80007e60:	0c2017b7          	lui	a5,0xc201
80007e64:	00a787b3          	add	a5,a5,a0
  return irq;
}
80007e68:	0047a503          	lw	a0,4(a5) # c201004 <_entry-0x73dfeffc>
80007e6c:	00c12083          	lw	ra,12(sp)
80007e70:	00812403          	lw	s0,8(sp)
80007e74:	01010113          	addi	sp,sp,16
80007e78:	00008067          	ret

80007e7c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
80007e7c:	ff010113          	addi	sp,sp,-16
80007e80:	00112623          	sw	ra,12(sp)
80007e84:	00812423          	sw	s0,8(sp)
80007e88:	00912223          	sw	s1,4(sp)
80007e8c:	01010413          	addi	s0,sp,16
80007e90:	00050493          	mv	s1,a0
  int hart = cpuid();
80007e94:	ffffa097          	auipc	ra,0xffffa
80007e98:	3e8080e7          	jalr	1000(ra) # 8000227c <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
80007e9c:	00d51513          	slli	a0,a0,0xd
80007ea0:	0c2017b7          	lui	a5,0xc201
80007ea4:	00a787b3          	add	a5,a5,a0
80007ea8:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
}
80007eac:	00c12083          	lw	ra,12(sp)
80007eb0:	00812403          	lw	s0,8(sp)
80007eb4:	00412483          	lw	s1,4(sp)
80007eb8:	01010113          	addi	sp,sp,16
80007ebc:	00008067          	ret

80007ec0 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
80007ec0:	ff010113          	addi	sp,sp,-16
80007ec4:	00112623          	sw	ra,12(sp)
80007ec8:	00812423          	sw	s0,8(sp)
80007ecc:	01010413          	addi	s0,sp,16
  if(i >= NUM)
80007ed0:	00700793          	li	a5,7
80007ed4:	06a7ce63          	blt	a5,a0,80007f50 <free_desc+0x90>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
80007ed8:	0001b717          	auipc	a4,0x1b
80007edc:	12870713          	addi	a4,a4,296 # 80023000 <disk>
80007ee0:	00a70733          	add	a4,a4,a0
80007ee4:	000027b7          	lui	a5,0x2
80007ee8:	00e787b3          	add	a5,a5,a4
80007eec:	00c7c783          	lbu	a5,12(a5) # 200c <_entry-0x7fffdff4>
80007ef0:	06079863          	bnez	a5,80007f60 <free_desc+0xa0>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
80007ef4:	00451713          	slli	a4,a0,0x4
80007ef8:	0001d797          	auipc	a5,0x1d
80007efc:	1087a783          	lw	a5,264(a5) # 80025000 <disk+0x2000>
80007f00:	00e787b3          	add	a5,a5,a4
80007f04:	00000693          	li	a3,0
80007f08:	00000713          	li	a4,0
80007f0c:	00d7a023          	sw	a3,0(a5)
80007f10:	00e7a223          	sw	a4,4(a5)
  disk.free[i] = 1;
80007f14:	0001b717          	auipc	a4,0x1b
80007f18:	0ec70713          	addi	a4,a4,236 # 80023000 <disk>
80007f1c:	00a70733          	add	a4,a4,a0
80007f20:	000027b7          	lui	a5,0x2
80007f24:	00e787b3          	add	a5,a5,a4
80007f28:	00100713          	li	a4,1
80007f2c:	00e78623          	sb	a4,12(a5) # 200c <_entry-0x7fffdff4>
  wakeup(&disk.free[0]);
80007f30:	0001d517          	auipc	a0,0x1d
80007f34:	0dc50513          	addi	a0,a0,220 # 8002500c <disk+0x200c>
80007f38:	ffffb097          	auipc	ra,0xffffb
80007f3c:	ff8080e7          	jalr	-8(ra) # 80002f30 <wakeup>
}
80007f40:	00c12083          	lw	ra,12(sp)
80007f44:	00812403          	lw	s0,8(sp)
80007f48:	01010113          	addi	sp,sp,16
80007f4c:	00008067          	ret
    panic("virtio_disk_intr 1");
80007f50:	00004517          	auipc	a0,0x4
80007f54:	f2c50513          	addi	a0,a0,-212 # 8000be7c <userret+0x2ddc>
80007f58:	ffff8097          	auipc	ra,0xffff8
80007f5c:	7a8080e7          	jalr	1960(ra) # 80000700 <panic>
    panic("virtio_disk_intr 2");
80007f60:	00004517          	auipc	a0,0x4
80007f64:	f3050513          	addi	a0,a0,-208 # 8000be90 <userret+0x2df0>
80007f68:	ffff8097          	auipc	ra,0xffff8
80007f6c:	798080e7          	jalr	1944(ra) # 80000700 <panic>

80007f70 <virtio_disk_init>:
{
80007f70:	ff010113          	addi	sp,sp,-16
80007f74:	00112623          	sw	ra,12(sp)
80007f78:	00812423          	sw	s0,8(sp)
80007f7c:	01010413          	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
80007f80:	00004597          	auipc	a1,0x4
80007f84:	f2458593          	addi	a1,a1,-220 # 8000bea4 <userret+0x2e04>
80007f88:	0001d517          	auipc	a0,0x1d
80007f8c:	0d050513          	addi	a0,a0,208 # 80025058 <disk+0x2058>
80007f90:	ffff9097          	auipc	ra,0xffff9
80007f94:	dd8080e7          	jalr	-552(ra) # 80000d68 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
80007f98:	100017b7          	lui	a5,0x10001
80007f9c:	0007a703          	lw	a4,0(a5) # 10001000 <_entry-0x6ffff000>
80007fa0:	747277b7          	lui	a5,0x74727
80007fa4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
80007fa8:	12f71263          	bne	a4,a5,800080cc <virtio_disk_init+0x15c>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
80007fac:	100017b7          	lui	a5,0x10001
80007fb0:	0047a703          	lw	a4,4(a5) # 10001004 <_entry-0x6fffeffc>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
80007fb4:	00100793          	li	a5,1
80007fb8:	10f71a63          	bne	a4,a5,800080cc <virtio_disk_init+0x15c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
80007fbc:	100017b7          	lui	a5,0x10001
80007fc0:	0087a703          	lw	a4,8(a5) # 10001008 <_entry-0x6fffeff8>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
80007fc4:	00200793          	li	a5,2
80007fc8:	10f71263          	bne	a4,a5,800080cc <virtio_disk_init+0x15c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
80007fcc:	100017b7          	lui	a5,0x10001
80007fd0:	00c7a703          	lw	a4,12(a5) # 1000100c <_entry-0x6fffeff4>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
80007fd4:	554d47b7          	lui	a5,0x554d4
80007fd8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
80007fdc:	0ef71863          	bne	a4,a5,800080cc <virtio_disk_init+0x15c>
  *R(VIRTIO_MMIO_STATUS) = status;
80007fe0:	100017b7          	lui	a5,0x10001
80007fe4:	00100713          	li	a4,1
80007fe8:	06e7a823          	sw	a4,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
80007fec:	00300713          	li	a4,3
80007ff0:	06e7a823          	sw	a4,112(a5)
  uint32 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
80007ff4:	10001737          	lui	a4,0x10001
80007ff8:	01072703          	lw	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
80007ffc:	c7ffe6b7          	lui	a3,0xc7ffe
80008000:	75f68693          	addi	a3,a3,1887 # c7ffe75f <end+0x47fd874b>
80008004:	00d77733          	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
80008008:	100016b7          	lui	a3,0x10001
8000800c:	02e6a023          	sw	a4,32(a3) # 10001020 <_entry-0x6fffefe0>
  *R(VIRTIO_MMIO_STATUS) = status;
80008010:	00b00713          	li	a4,11
80008014:	06e7a823          	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
80008018:	00f00713          	li	a4,15
8000801c:	06e7a823          	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
80008020:	00001737          	lui	a4,0x1
80008024:	02e6a423          	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
80008028:	0206a823          	sw	zero,48(a3)
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
8000802c:	0346a783          	lw	a5,52(a3)
  if(max == 0)
80008030:	0a078663          	beqz	a5,800080dc <virtio_disk_init+0x16c>
  if(max < NUM)
80008034:	00700713          	li	a4,7
80008038:	0af77a63          	bgeu	a4,a5,800080ec <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
8000803c:	100017b7          	lui	a5,0x10001
80008040:	00800713          	li	a4,8
80008044:	02e7ac23          	sw	a4,56(a5) # 10001038 <_entry-0x6fffefc8>
  memset(disk.pages, 0, sizeof(disk.pages));
80008048:	00002637          	lui	a2,0x2
8000804c:	00000593          	li	a1,0
80008050:	0001b517          	auipc	a0,0x1b
80008054:	fb050513          	addi	a0,a0,-80 # 80023000 <disk>
80008058:	ffff9097          	auipc	ra,0xffff9
8000805c:	f70080e7          	jalr	-144(ra) # 80000fc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint32)disk.pages) >> PGSHIFT;
80008060:	0001b717          	auipc	a4,0x1b
80008064:	fa070713          	addi	a4,a4,-96 # 80023000 <disk>
80008068:	00c75693          	srli	a3,a4,0xc
8000806c:	100017b7          	lui	a5,0x10001
80008070:	04d7a023          	sw	a3,64(a5) # 10001040 <_entry-0x6fffefc0>
  disk.desc = (struct VRingDesc *) disk.pages;
80008074:	0001d797          	auipc	a5,0x1d
80008078:	f8c78793          	addi	a5,a5,-116 # 80025000 <disk+0x2000>
8000807c:	00e7a023          	sw	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
80008080:	0001b717          	auipc	a4,0x1b
80008084:	00070713          	mv	a4,a4
80008088:	00e7a223          	sw	a4,4(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
8000808c:	0001c717          	auipc	a4,0x1c
80008090:	f7470713          	addi	a4,a4,-140 # 80024000 <disk+0x1000>
80008094:	00e7a423          	sw	a4,8(a5)
    disk.free[i] = 1;
80008098:	00100713          	li	a4,1
8000809c:	00e78623          	sb	a4,12(a5)
800080a0:	00e786a3          	sb	a4,13(a5)
800080a4:	00e78723          	sb	a4,14(a5)
800080a8:	00e787a3          	sb	a4,15(a5)
800080ac:	00e78823          	sb	a4,16(a5)
800080b0:	00e788a3          	sb	a4,17(a5)
800080b4:	00e78923          	sb	a4,18(a5)
800080b8:	00e789a3          	sb	a4,19(a5)
}
800080bc:	00c12083          	lw	ra,12(sp)
800080c0:	00812403          	lw	s0,8(sp)
800080c4:	01010113          	addi	sp,sp,16
800080c8:	00008067          	ret
    panic("could not find virtio disk");
800080cc:	00004517          	auipc	a0,0x4
800080d0:	de450513          	addi	a0,a0,-540 # 8000beb0 <userret+0x2e10>
800080d4:	ffff8097          	auipc	ra,0xffff8
800080d8:	62c080e7          	jalr	1580(ra) # 80000700 <panic>
    panic("virtio disk has no queue 0");
800080dc:	00004517          	auipc	a0,0x4
800080e0:	df050513          	addi	a0,a0,-528 # 8000becc <userret+0x2e2c>
800080e4:	ffff8097          	auipc	ra,0xffff8
800080e8:	61c080e7          	jalr	1564(ra) # 80000700 <panic>
    panic("virtio disk max queue too short");
800080ec:	00004517          	auipc	a0,0x4
800080f0:	dfc50513          	addi	a0,a0,-516 # 8000bee8 <userret+0x2e48>
800080f4:	ffff8097          	auipc	ra,0xffff8
800080f8:	60c080e7          	jalr	1548(ra) # 80000700 <panic>

800080fc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
800080fc:	fb010113          	addi	sp,sp,-80
80008100:	04112623          	sw	ra,76(sp)
80008104:	04812423          	sw	s0,72(sp)
80008108:	04912223          	sw	s1,68(sp)
8000810c:	05212023          	sw	s2,64(sp)
80008110:	03312e23          	sw	s3,60(sp)
80008114:	03412c23          	sw	s4,56(sp)
80008118:	03512a23          	sw	s5,52(sp)
8000811c:	03612823          	sw	s6,48(sp)
80008120:	03712623          	sw	s7,44(sp)
80008124:	03812423          	sw	s8,40(sp)
80008128:	05010413          	addi	s0,sp,80
8000812c:	00050a93          	mv	s5,a0
80008130:	00058b93          	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
80008134:	00c52c03          	lw	s8,12(a0)
80008138:	001c1c13          	slli	s8,s8,0x1

  acquire(&disk.vdisk_lock);
8000813c:	0001d517          	auipc	a0,0x1d
80008140:	f1c50513          	addi	a0,a0,-228 # 80025058 <disk+0x2058>
80008144:	ffff9097          	auipc	ra,0xffff9
80008148:	db0080e7          	jalr	-592(ra) # 80000ef4 <acquire>
    if(disk.free[i]){
8000814c:	00002937          	lui	s2,0x2
80008150:	00c90913          	addi	s2,s2,12 # 200c <_entry-0x7fffdff4>
80008154:	0001b497          	auipc	s1,0x1b
80008158:	eac48493          	addi	s1,s1,-340 # 80023000 <disk>
  for(int i = 0; i < NUM; i++){
8000815c:	00800993          	li	s3,8
      disk.free[i] = 0;
80008160:	00002b37          	lui	s6,0x2
80008164:	0880006f          	j	800081ec <virtio_disk_rw+0xf0>
80008168:	00f48733          	add	a4,s1,a5
8000816c:	00eb0733          	add	a4,s6,a4
80008170:	00070623          	sb	zero,12(a4)
    idx[i] = alloc_desc();
80008174:	00f62023          	sw	a5,0(a2) # 2000 <_entry-0x7fffe000>
    if(idx[i] < 0){
80008178:	0207cc63          	bltz	a5,800081b0 <virtio_disk_rw+0xb4>
  for(int i = 0; i < 3; i++){
8000817c:	001a0a13          	addi	s4,s4,1
80008180:	00468693          	addi	a3,a3,4
80008184:	20ba0e63          	beq	s4,a1,800083a0 <virtio_disk_rw+0x2a4>
    idx[i] = alloc_desc();
80008188:	00068613          	mv	a2,a3
  for(int i = 0; i < NUM; i++){
8000818c:	00000793          	li	a5,0
    if(disk.free[i]){
80008190:	01278733          	add	a4,a5,s2
80008194:	00970733          	add	a4,a4,s1
80008198:	00074703          	lbu	a4,0(a4)
8000819c:	fc0716e3          	bnez	a4,80008168 <virtio_disk_rw+0x6c>
  for(int i = 0; i < NUM; i++){
800081a0:	00178793          	addi	a5,a5,1
800081a4:	ff3796e3          	bne	a5,s3,80008190 <virtio_disk_rw+0x94>
    idx[i] = alloc_desc();
800081a8:	fff00793          	li	a5,-1
800081ac:	00f62023          	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
800081b0:	03405263          	blez	s4,800081d4 <virtio_disk_rw+0xd8>
        free_desc(idx[j]);
800081b4:	fc442503          	lw	a0,-60(s0)
800081b8:	00000097          	auipc	ra,0x0
800081bc:	d08080e7          	jalr	-760(ra) # 80007ec0 <free_desc>
      for(int j = 0; j < i; j++)
800081c0:	00100793          	li	a5,1
800081c4:	0147d863          	bge	a5,s4,800081d4 <virtio_disk_rw+0xd8>
        free_desc(idx[j]);
800081c8:	fc842503          	lw	a0,-56(s0)
800081cc:	00000097          	auipc	ra,0x0
800081d0:	cf4080e7          	jalr	-780(ra) # 80007ec0 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
800081d4:	0001d597          	auipc	a1,0x1d
800081d8:	e8458593          	addi	a1,a1,-380 # 80025058 <disk+0x2058>
800081dc:	0001d517          	auipc	a0,0x1d
800081e0:	e3050513          	addi	a0,a0,-464 # 8002500c <disk+0x200c>
800081e4:	ffffb097          	auipc	ra,0xffffb
800081e8:	b3c080e7          	jalr	-1220(ra) # 80002d20 <sleep>
  for(int i = 0; i < 3; i++){
800081ec:	fc440693          	addi	a3,s0,-60
800081f0:	00000a13          	li	s4,0
800081f4:	00300593          	li	a1,3
800081f8:	f91ff06f          	j	80008188 <virtio_disk_rw+0x8c>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = ((uint32) b->data) & 0xffffffff; // XXX
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
800081fc:	0001d717          	auipc	a4,0x1d
80008200:	e0472703          	lw	a4,-508(a4) # 80025000 <disk+0x2000>
80008204:	00f70733          	add	a4,a4,a5
80008208:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
8000820c:	0001b897          	auipc	a7,0x1b
80008210:	df488893          	addi	a7,a7,-524 # 80023000 <disk>
80008214:	0001d717          	auipc	a4,0x1d
80008218:	dec70713          	addi	a4,a4,-532 # 80025000 <disk+0x2000>
8000821c:	00072683          	lw	a3,0(a4)
80008220:	00f686b3          	add	a3,a3,a5
80008224:	00c6d603          	lhu	a2,12(a3)
80008228:	00166613          	ori	a2,a2,1
8000822c:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
80008230:	fcc42683          	lw	a3,-52(s0)
80008234:	00072603          	lw	a2,0(a4)
80008238:	00f607b3          	add	a5,a2,a5
8000823c:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
80008240:	40058613          	addi	a2,a1,1024
80008244:	00361613          	slli	a2,a2,0x3
80008248:	00c88633          	add	a2,a7,a2
8000824c:	00060e23          	sb	zero,28(a2)
  disk.desc[idx[2]].addr = ((uint32) &disk.info[idx[0]].status) & 0xffffffff; // XXX
80008250:	00469793          	slli	a5,a3,0x4
80008254:	00072503          	lw	a0,0(a4)
80008258:	00f50533          	add	a0,a0,a5
8000825c:	00359693          	slli	a3,a1,0x3
80008260:	00002837          	lui	a6,0x2
80008264:	01c80813          	addi	a6,a6,28 # 201c <_entry-0x7fffdfe4>
80008268:	010686b3          	add	a3,a3,a6
8000826c:	011686b3          	add	a3,a3,a7
80008270:	00d52023          	sw	a3,0(a0)
80008274:	00052223          	sw	zero,4(a0)
  disk.desc[idx[2]].len = 1;
80008278:	00072683          	lw	a3,0(a4)
8000827c:	00f686b3          	add	a3,a3,a5
80008280:	00100513          	li	a0,1
80008284:	00a6a423          	sw	a0,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
80008288:	00072683          	lw	a3,0(a4)
8000828c:	00f686b3          	add	a3,a3,a5
80008290:	00200813          	li	a6,2
80008294:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
80008298:	00072683          	lw	a3,0(a4)
8000829c:	00f687b3          	add	a5,a3,a5
800082a0:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
800082a4:	00aaa223          	sw	a0,4(s5)
  disk.info[idx[0]].b = b;
800082a8:	01562c23          	sw	s5,24(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
800082ac:	00472683          	lw	a3,4(a4)
800082b0:	0026d783          	lhu	a5,2(a3)
800082b4:	0077f793          	andi	a5,a5,7
800082b8:	010787b3          	add	a5,a5,a6
800082bc:	00179793          	slli	a5,a5,0x1
800082c0:	00f686b3          	add	a3,a3,a5
800082c4:	00b69023          	sh	a1,0(a3)
  __sync_synchronize();
800082c8:	0330000f          	fence	rw,rw
  disk.avail[1] = disk.avail[1] + 1;
800082cc:	00472703          	lw	a4,4(a4)
800082d0:	00275783          	lhu	a5,2(a4)
800082d4:	00a787b3          	add	a5,a5,a0
800082d8:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
800082dc:	100017b7          	lui	a5,0x10001
800082e0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
800082e4:	004aa783          	lw	a5,4(s5)
800082e8:	02a79463          	bne	a5,a0,80008310 <virtio_disk_rw+0x214>
    sleep(b, &disk.vdisk_lock);
800082ec:	0001d917          	auipc	s2,0x1d
800082f0:	d6c90913          	addi	s2,s2,-660 # 80025058 <disk+0x2058>
  while(b->disk == 1) {
800082f4:	00050493          	mv	s1,a0
    sleep(b, &disk.vdisk_lock);
800082f8:	00090593          	mv	a1,s2
800082fc:	000a8513          	mv	a0,s5
80008300:	ffffb097          	auipc	ra,0xffffb
80008304:	a20080e7          	jalr	-1504(ra) # 80002d20 <sleep>
  while(b->disk == 1) {
80008308:	004aa783          	lw	a5,4(s5)
8000830c:	fe9786e3          	beq	a5,s1,800082f8 <virtio_disk_rw+0x1fc>
  }

  disk.info[idx[0]].b = 0;
80008310:	fc442483          	lw	s1,-60(s0)
80008314:	40048713          	addi	a4,s1,1024
80008318:	00371713          	slli	a4,a4,0x3
8000831c:	0001b797          	auipc	a5,0x1b
80008320:	ce478793          	addi	a5,a5,-796 # 80023000 <disk>
80008324:	00e787b3          	add	a5,a5,a4
80008328:	0007ac23          	sw	zero,24(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
8000832c:	0001d917          	auipc	s2,0x1d
80008330:	cd490913          	addi	s2,s2,-812 # 80025000 <disk+0x2000>
    free_desc(i);
80008334:	00048513          	mv	a0,s1
80008338:	00000097          	auipc	ra,0x0
8000833c:	b88080e7          	jalr	-1144(ra) # 80007ec0 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
80008340:	00449493          	slli	s1,s1,0x4
80008344:	00092783          	lw	a5,0(s2)
80008348:	009787b3          	add	a5,a5,s1
8000834c:	00c7d703          	lhu	a4,12(a5)
80008350:	00177713          	andi	a4,a4,1
80008354:	00070663          	beqz	a4,80008360 <virtio_disk_rw+0x264>
      i = disk.desc[i].next;
80008358:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
8000835c:	fd9ff06f          	j	80008334 <virtio_disk_rw+0x238>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
80008360:	0001d517          	auipc	a0,0x1d
80008364:	cf850513          	addi	a0,a0,-776 # 80025058 <disk+0x2058>
80008368:	ffff9097          	auipc	ra,0xffff9
8000836c:	c00080e7          	jalr	-1024(ra) # 80000f68 <release>
}
80008370:	04c12083          	lw	ra,76(sp)
80008374:	04812403          	lw	s0,72(sp)
80008378:	04412483          	lw	s1,68(sp)
8000837c:	04012903          	lw	s2,64(sp)
80008380:	03c12983          	lw	s3,60(sp)
80008384:	03812a03          	lw	s4,56(sp)
80008388:	03412a83          	lw	s5,52(sp)
8000838c:	03012b03          	lw	s6,48(sp)
80008390:	02c12b83          	lw	s7,44(sp)
80008394:	02812c03          	lw	s8,40(sp)
80008398:	05010113          	addi	sp,sp,80
8000839c:	00008067          	ret
  if(write)
800083a0:	017037b3          	snez	a5,s7
800083a4:	faf42823          	sw	a5,-80(s0)
  buf0.reserved = 0;
800083a8:	fa042a23          	sw	zero,-76(s0)
  buf0.sector = sector;
800083ac:	fb842c23          	sw	s8,-72(s0)
800083b0:	fa042e23          	sw	zero,-68(s0)
  disk.desc[idx[0]].addr = kvmpa((uint32) &buf0);
800083b4:	fb040513          	addi	a0,s0,-80
800083b8:	ffff9097          	auipc	ra,0xffff9
800083bc:	1c4080e7          	jalr	452(ra) # 8000157c <kvmpa>
800083c0:	fc442583          	lw	a1,-60(s0)
800083c4:	00459693          	slli	a3,a1,0x4
800083c8:	0001d717          	auipc	a4,0x1d
800083cc:	c3870713          	addi	a4,a4,-968 # 80025000 <disk+0x2000>
800083d0:	00072783          	lw	a5,0(a4)
800083d4:	00d787b3          	add	a5,a5,a3
800083d8:	00a7a023          	sw	a0,0(a5)
800083dc:	0007a223          	sw	zero,4(a5)
  disk.desc[idx[0]].len = sizeof(buf0);
800083e0:	00072783          	lw	a5,0(a4)
800083e4:	00d787b3          	add	a5,a5,a3
800083e8:	01000613          	li	a2,16
800083ec:	00c7a423          	sw	a2,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
800083f0:	00072783          	lw	a5,0(a4)
800083f4:	00d787b3          	add	a5,a5,a3
800083f8:	00100613          	li	a2,1
800083fc:	00c79623          	sh	a2,12(a5)
  disk.desc[idx[0]].next = idx[1];
80008400:	fc842783          	lw	a5,-56(s0)
80008404:	00072603          	lw	a2,0(a4)
80008408:	00d606b3          	add	a3,a2,a3
8000840c:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = ((uint32) b->data) & 0xffffffff; // XXX
80008410:	00479793          	slli	a5,a5,0x4
80008414:	00072683          	lw	a3,0(a4)
80008418:	00f686b3          	add	a3,a3,a5
8000841c:	038a8613          	addi	a2,s5,56
80008420:	00c6a023          	sw	a2,0(a3)
80008424:	0006a223          	sw	zero,4(a3)
  disk.desc[idx[1]].len = BSIZE;
80008428:	00072703          	lw	a4,0(a4)
8000842c:	00f70733          	add	a4,a4,a5
80008430:	40000693          	li	a3,1024
80008434:	00d72423          	sw	a3,8(a4)
  if(write)
80008438:	dc0b92e3          	bnez	s7,800081fc <virtio_disk_rw+0x100>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
8000843c:	0001d717          	auipc	a4,0x1d
80008440:	bc472703          	lw	a4,-1084(a4) # 80025000 <disk+0x2000>
80008444:	00f70733          	add	a4,a4,a5
80008448:	00200693          	li	a3,2
8000844c:	00d71623          	sh	a3,12(a4)
80008450:	dbdff06f          	j	8000820c <virtio_disk_rw+0x110>

80008454 <virtio_disk_intr>:

void
virtio_disk_intr()
{
80008454:	ff010113          	addi	sp,sp,-16
80008458:	00112623          	sw	ra,12(sp)
8000845c:	00812423          	sw	s0,8(sp)
80008460:	01010413          	addi	s0,sp,16
  acquire(&disk.vdisk_lock);
80008464:	0001d517          	auipc	a0,0x1d
80008468:	bf450513          	addi	a0,a0,-1036 # 80025058 <disk+0x2058>
8000846c:	ffff9097          	auipc	ra,0xffff9
80008470:	a88080e7          	jalr	-1400(ra) # 80000ef4 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
80008474:	0001d717          	auipc	a4,0x1d
80008478:	b8c70713          	addi	a4,a4,-1140 # 80025000 <disk+0x2000>
8000847c:	01475783          	lhu	a5,20(a4)
80008480:	00872703          	lw	a4,8(a4)
80008484:	00275683          	lhu	a3,2(a4)
80008488:	00d7c6b3          	xor	a3,a5,a3
8000848c:	0076f693          	andi	a3,a3,7
80008490:	08068263          	beqz	a3,80008514 <virtio_disk_intr+0xc0>
80008494:	00912223          	sw	s1,4(sp)
80008498:	01212023          	sw	s2,0(sp)
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
8000849c:	0001b917          	auipc	s2,0x1b
800084a0:	b6490913          	addi	s2,s2,-1180 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
800084a4:	0001d497          	auipc	s1,0x1d
800084a8:	b5c48493          	addi	s1,s1,-1188 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
800084ac:	00379793          	slli	a5,a5,0x3
800084b0:	00f70733          	add	a4,a4,a5
800084b4:	00472783          	lw	a5,4(a4)
    if(disk.info[id].status != 0)
800084b8:	40078713          	addi	a4,a5,1024
800084bc:	00371713          	slli	a4,a4,0x3
800084c0:	00e90733          	add	a4,s2,a4
800084c4:	01c74703          	lbu	a4,28(a4)
800084c8:	06071663          	bnez	a4,80008534 <virtio_disk_intr+0xe0>
    disk.info[id].b->disk = 0;   // disk is done with buf
800084cc:	40078793          	addi	a5,a5,1024
800084d0:	00379793          	slli	a5,a5,0x3
800084d4:	00f907b3          	add	a5,s2,a5
800084d8:	0187a703          	lw	a4,24(a5)
800084dc:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
800084e0:	0187a503          	lw	a0,24(a5)
800084e4:	ffffb097          	auipc	ra,0xffffb
800084e8:	a4c080e7          	jalr	-1460(ra) # 80002f30 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
800084ec:	0144d783          	lhu	a5,20(s1)
800084f0:	00178793          	addi	a5,a5,1
800084f4:	0077f793          	andi	a5,a5,7
800084f8:	00f49a23          	sh	a5,20(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
800084fc:	0084a703          	lw	a4,8(s1)
80008500:	00275683          	lhu	a3,2(a4)
80008504:	0076f693          	andi	a3,a3,7
80008508:	faf692e3          	bne	a3,a5,800084ac <virtio_disk_intr+0x58>
8000850c:	00412483          	lw	s1,4(sp)
80008510:	00012903          	lw	s2,0(sp)
  }

  release(&disk.vdisk_lock);
80008514:	0001d517          	auipc	a0,0x1d
80008518:	b4450513          	addi	a0,a0,-1212 # 80025058 <disk+0x2058>
8000851c:	ffff9097          	auipc	ra,0xffff9
80008520:	a4c080e7          	jalr	-1460(ra) # 80000f68 <release>
}
80008524:	00c12083          	lw	ra,12(sp)
80008528:	00812403          	lw	s0,8(sp)
8000852c:	01010113          	addi	sp,sp,16
80008530:	00008067          	ret
      panic("virtio_disk_intr status");
80008534:	00004517          	auipc	a0,0x4
80008538:	9d450513          	addi	a0,a0,-1580 # 8000bf08 <userret+0x2e68>
8000853c:	ffff8097          	auipc	ra,0xffff8
80008540:	1c4080e7          	jalr	452(ra) # 80000700 <panic>
	...

80009000 <trampoline>:
80009000:	14051573          	csrrw	a0,sscratch,a0
80009004:	00152a23          	sw	ra,20(a0)
80009008:	00252c23          	sw	sp,24(a0)
8000900c:	00352e23          	sw	gp,28(a0)
80009010:	02452023          	sw	tp,32(a0)
80009014:	02552223          	sw	t0,36(a0)
80009018:	02652423          	sw	t1,40(a0)
8000901c:	02752623          	sw	t2,44(a0)
80009020:	02852823          	sw	s0,48(a0)
80009024:	02952a23          	sw	s1,52(a0)
80009028:	02b52e23          	sw	a1,60(a0)
8000902c:	04c52023          	sw	a2,64(a0)
80009030:	04d52223          	sw	a3,68(a0)
80009034:	04e52423          	sw	a4,72(a0)
80009038:	04f52623          	sw	a5,76(a0)
8000903c:	05052823          	sw	a6,80(a0)
80009040:	05152a23          	sw	a7,84(a0)
80009044:	05252c23          	sw	s2,88(a0)
80009048:	05352e23          	sw	s3,92(a0)
8000904c:	07452023          	sw	s4,96(a0)
80009050:	07552223          	sw	s5,100(a0)
80009054:	07652423          	sw	s6,104(a0)
80009058:	07752623          	sw	s7,108(a0)
8000905c:	07852823          	sw	s8,112(a0)
80009060:	07952a23          	sw	s9,116(a0)
80009064:	07a52c23          	sw	s10,120(a0)
80009068:	07b52e23          	sw	s11,124(a0)
8000906c:	09c52023          	sw	t3,128(a0)
80009070:	09d52223          	sw	t4,132(a0)
80009074:	09e52423          	sw	t5,136(a0)
80009078:	09f52623          	sw	t6,140(a0)
8000907c:	140022f3          	csrr	t0,sscratch
80009080:	02552c23          	sw	t0,56(a0)
80009084:	00452103          	lw	sp,4(a0)
80009088:	01052203          	lw	tp,16(a0)
8000908c:	00852283          	lw	t0,8(a0)
80009090:	00052303          	lw	t1,0(a0)
80009094:	18031073          	csrw	satp,t1
80009098:	12000073          	sfence.vma
8000909c:	00028067          	jr	t0

800090a0 <userret>:
800090a0:	18059073          	csrw	satp,a1
800090a4:	12000073          	sfence.vma
800090a8:	03852283          	lw	t0,56(a0)
800090ac:	14029073          	csrw	sscratch,t0
800090b0:	01452083          	lw	ra,20(a0)
800090b4:	01852103          	lw	sp,24(a0)
800090b8:	01c52183          	lw	gp,28(a0)
800090bc:	02052203          	lw	tp,32(a0)
800090c0:	02452283          	lw	t0,36(a0)
800090c4:	02852303          	lw	t1,40(a0)
800090c8:	02c52383          	lw	t2,44(a0)
800090cc:	03052403          	lw	s0,48(a0)
800090d0:	03452483          	lw	s1,52(a0)
800090d4:	03c52583          	lw	a1,60(a0)
800090d8:	04052603          	lw	a2,64(a0)
800090dc:	04452683          	lw	a3,68(a0)
800090e0:	04852703          	lw	a4,72(a0)
800090e4:	04c52783          	lw	a5,76(a0)
800090e8:	05052803          	lw	a6,80(a0)
800090ec:	05452883          	lw	a7,84(a0)
800090f0:	05852903          	lw	s2,88(a0)
800090f4:	05c52983          	lw	s3,92(a0)
800090f8:	06052a03          	lw	s4,96(a0)
800090fc:	06452a83          	lw	s5,100(a0)
80009100:	06852b03          	lw	s6,104(a0)
80009104:	06c52b83          	lw	s7,108(a0)
80009108:	07052c03          	lw	s8,112(a0)
8000910c:	07452c83          	lw	s9,116(a0)
80009110:	07852d03          	lw	s10,120(a0)
80009114:	07c52d83          	lw	s11,124(a0)
80009118:	08052e03          	lw	t3,128(a0)
8000911c:	08452e83          	lw	t4,132(a0)
80009120:	08852f03          	lw	t5,136(a0)
80009124:	08c52f83          	lw	t6,140(a0)
80009128:	14051573          	csrrw	a0,sscratch,a0
8000912c:	10200073          	sret
