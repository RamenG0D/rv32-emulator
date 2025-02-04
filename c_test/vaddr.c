typedef unsigned long int uint32;

#define SATP_SV32 (1L << 31)
#define MAKE_SATP(pagetable) (SATP_SV32 | (((uint32)pagetable) >> 12)) // 32 bit

static inline void w_satp(uint32 x);
void ptable_init();

static uint32* ptable;

int main(void) {
	ptable_init();

	w_satp(MAKE_SATP(ptable));

	int a = 1, b = 2;
	int* ap = &a;
	int* bp = &b;
	*ap = 4;
	int c = *ap + *bp;

	return c;
}

#define PAGE_SIZE 4096

#define BASE_ADDR 0x80002000

// page table init
void ptable_init() {
	ptable = (uint32*)BASE_ADDR;
	for (int i = 0; i < 1024; i++) {
		ptable[i] = BASE_ADDR + PAGE_SIZE * i | 0x1;
	}
}

// supervisor address translation and protection;
// holds the address of the page table.
static inline void w_satp(uint32 x) {
  asm volatile("csrw satp, %0" : : "r" (x));
}
