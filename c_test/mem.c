#include "debug.h"

#include <stdint.h>
#include <stdbool.h>

// enable this to print debug info about the heap / program
// #define DEBUG

#ifdef DEBUG
#define debug printf
#else
#define debug(...)
#endif

typedef struct mem_block {
	struct mem_block* next;
	struct mem_block* prev;
	size_t size;
	bool free;
	char data[];
} mem_block;

static mem_block* mem_head = NULL;

static inline
void print_block(mem_block* block) {
#ifndef DEBUG
	(void)block;
	return;
#endif
	debug("BLOCK INFO {\n");
	debug("  block: 0x%p\n", block);
	debug("  block->size: %zu\n", block->size);
	debug("  block->free: %s\n", block->free ? "true" : "false");
	debug("}\n");
}

#define HEAP_START (0x80000000)
#define HEAP_END (HEAP_START + (4 * 1024 * 1024))

// we need to make our own sbrk because we cant use anything from std
// this is a very simple implementation that just uses an arbitrary address as the start of the heap
void* sbrk(intptr_t increment) {
	debug("sbrking\n");

	static intptr_t heap_end;
	if(!heap_end) {
		debug("first sbrk call\n");
		heap_end = HEAP_START;
		debug("heap start: 0x%p\n", (void*)heap_end);
	}

	if(heap_end + increment >= HEAP_END) {
		debug("Failed to get more on heap memory.\ntheres no more space left!\n");
		return (void*)-1;
	}

	debug("old heap end: 0x%p\n", (void*)heap_end);

	intptr_t old_end = heap_end;
	heap_end += increment;

	return (void*)old_end;
}

// custom malloc implementation
void* malloc(size_t size) {
	debug("mallocing block\n");

    // if there is no heap yet, create one
    if(!mem_head) {
		// first call to malloc
        debug("no heap yet\n");

        mem_head = (mem_block*)sbrk(sizeof(mem_block) + size);
		debug("new heap: 0x%p\n", mem_head);

        if (mem_head == (void*)-1) {
            debug("Failed to allocate memory: out of heap space\n");
            return NULL;
        }

		debug("new block: 0x%p\n", mem_head);
        mem_head->next = NULL;
        mem_head->prev = NULL;
        mem_head->size = size;
        mem_head->free = false;

		debug("finished allocation!\n");

        return mem_head->data;
    }

    // find a free block
    mem_block* block = mem_head;
    while(block) {
        debug("block: 0x%p\n", block);
        if(block->free && block->size >= size) {
            debug("found free block\n");
            break;
        }
        debug("not a free block\n");
        block = block->next;
    }

    // if no free block was found, create a new one
    if(!block) {
        debug("no free block found\n");
        block = (mem_block*)sbrk(sizeof(mem_block) + size);
        if (block == (void*)-1) {
            debug("Failed to allocate memory: out of heap space\n");
            return NULL;
        }
        block->next = NULL;
        block->prev = NULL;
        block->size = size;
        block->free = false;
        debug("new block: 0x%p\n", block);
        return block->data;
    }

    // if the block is too big, split it
    if(block->size > size + sizeof(mem_block)) {
        debug("splitting block\n");
        mem_block* new_block = (mem_block*)((char*)block + sizeof(mem_block) + size);
        new_block->next = block->next;
        new_block->prev = block;
        new_block->size = block->size - size - sizeof(mem_block);
        new_block->free = true;
        block->next = new_block;
        block->size = size;
        debug("new block: 0x%p\n", new_block);
    }

	debug("finished allocation!\n");

    block->free = false;
    return block->data;
}

// custom free implementation
void free(void* ptr) {
	debug("freeing block\n");

	mem_block* block = (mem_block*)((char*)ptr - sizeof(mem_block));
	if(!block) {
		debug("block is NULL\n");
		return;
	}

	block->free = true;
}

void* realloc(void* ptr, size_t size) {
	debug("reallocating block\n");

	mem_block* block = (mem_block*)((char*)ptr - sizeof(mem_block));
	if(!block) {
		debug("block is NULL\n");
		return malloc(size);
	}

	if(block->size >= size) {
		debug("block is big enough\n");
		return ptr;
	}

	void* new_ptr = malloc(size);
	memcpy(new_ptr, ptr, block->size);
	free(ptr);
	return new_ptr;
}

// custom memset implementation
void* memset(void* ptr, int value, size_t length) {
	for (size_t i = 0; i < length; i++) {
		((volatile char*)ptr)[i] = value;
	}
	return ptr;
}

// custom memcpy implementation
void* memcpy(void *dest, const void *src, size_t n) {
	char *d = (char*)dest;
	const char *s = (const char *)src;
	for (size_t i = 0; i < n; i++) {
		d[i] = s[i];
	}
	return dest;
}

// custom memmove implementation
void* memmove(void *dest, const void *src, size_t n) {
	char *d = (char*)dest;
	const char *s = (const char *)src;
	if (d < s) {
		for (size_t i = 0; i < n; i++) {
			d[i] = s[i];
		}
	} else {
		for (size_t i = n; i > 0; i--) {
			d[i - 1] = s[i - 1];
		}
	}
	return dest;
}

// custom memcmp implementation
int memcmp(const void *s1, const void *s2, size_t n) {
	const unsigned char *c1 = s1;
	const unsigned char *c2 = s2;
	for (size_t i = 0; i < n; i++) {
		if (c1[i] < c2[i]) {
			return -1;
		} else if (c1[i] > c2[i]) {
			return 1;
		}
	}
	return 0;
}

// custom calloc implementation
void* calloc(volatile size_t nmemb, volatile size_t size) {
	void* ptr = malloc(nmemb * size);
	if(!ptr) {
		return NULL;
	}

	memset(ptr, 0, nmemb * size);

	return ptr;
}

// used to debug allocations
void debug_heap(void) {
	// were going to printf out roughly what the heap looks like after all this
	// as blocks
	// [block1][block2][block3][block4][block5][block6][block7][block8][block9][block10]
	// block1: 12 bytes
	// block2: 16 bytes
	// block3: 16 bytes
	// block4: 16 bytes
	// block5: 16 bytes
	// block6: 16 bytes
	// block7: 16 bytes
	// block8: 16 bytes
	// block9: 16 bytes
	// block10: 16 bytes
	// total: 144 bytes
	// free: 128 bytes
	// used: 16 bytes
	// free blocks: 8
	// used blocks: 2
	// free block sizes: 16, 16, 16, 16, 16, 16, 16, 16
	// used block sizes: 12, 16
	// free block addresses: 0x00000000, 0x00000010, 0x00000020, 0x00000030, 0x00000040, 0x00000050, 0x00000060, 0x00000070
	// used block addresses: 0x00000080, 0x00000090
	// in this format

	debug("debugging heap\n");

	mem_block* block = mem_head;
	int total = 0;
	int free = 0;
	int used = 0;
	int free_blocks = 0;
	int used_blocks = 0;
	debug("blocks: ");
	while(block) {
		debug("[0x%p(%zu)]", block, block->size);
		if(block->free) {
			free += block->size;
			free_blocks++;
		} else {
			used += block->size;
			used_blocks++;
		}
		total += block->size;
		block = block->next;
	}
	debug("\n");
	debug("total: %d bytes\n", total);
	debug("free: %d bytes\n", free);
	debug("used: %d bytes\n", used);
	debug("free blocks: %d\n", free_blocks);
	debug("used blocks: %d\n", used_blocks);

	block = mem_head;
	debug("free block sizes: ");
	while(block) {
		if(block->free) {
			debug("%zu, ", block->size);
		}
		block = block->next;
	}
	debug("\n");

	block = mem_head;
	debug("used block sizes: ");
	while(block) {
		if(!block->free) {
			debug("%zu, ", block->size);
		}
		block = block->next;
	}
	debug("\n");

	block = mem_head;
	debug("free block addresses: ");
	while(block) {
		if(block->free) {
			debug("%p, ", block);
		}
		block = block->next;
	}
	debug("\n");

	block = mem_head;
	debug("used block addresses: ");
	while(block) {
		if(!block->free) {
			debug("%p, ", block);
		}
		block = block->next;
	}
	debug("\n");

	debug("done debugging heap\n");
}
