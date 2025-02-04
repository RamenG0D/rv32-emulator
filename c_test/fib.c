
#include "debug.h"

static inline int get_input(void);
static inline int fast_fib(int n);
int cursed_fib(int n);
int fib(int n);

#define MAX_INPUT 45

int main(void) {
    printf("Fibonacci :D\n");
    int input = get_input();
	printf("\n");

	printf("Calculating using fast algorithm...\n");
	printf("Value: %d\n", fast_fib(input));
	printf("Finished calculating using fast algorithm\n");

	printf("Calculating using cursed algorithm...\n");
	printf("Value: %d\n", cursed_fib(input));
	printf("Finished calculating using cursed algorithm\n");

	printf("Calculating using recursive algorithm...\n");
    printf("Value: %d\n", fib(input));
	printf("Finished calculating using recursive algorithm\n");

    return 0;
}

#define MAX_INPUT_SIZE 10

static inline
int get_input(void) {
	int input = 0; int* res = NULL;
    do {
        // wait for user input
        printf("Enter a number: ");
        char* buffer = get_string();
		printf("Input: %s\n", buffer);
        res = str2int(buffer, 10);
		// note we need to free the buffer here becuase get_string allocates it
		// on the heap
		free(buffer);

		// check if input is a valid number
		if(!res) {
			printf("Input must be a number!\n");
		}

		// otherwise, we know we have a valid number
		// so we can assign it to input
		input = *res;

		// now we can check if the input is negative
		if(input < 0) {
			printf("Negative numbers are not allowed!\n");
		}
		// check if input is too large
		if (input > MAX_INPUT) {
			printf("Input too large, Please provide a number smaller than %d!\n", MAX_INPUT);
		}
    } while (!res || input > MAX_INPUT || input < 0);

	return input;
}

// EXTREMELY CURSED C CODE
// DO NOT TRY THIS AT HOME
// DO NOT TRY THIS AT WORK
// DO NOT TRY THIS... EVER
// this is still a valid implementation that solve for the fibonacci sequence
// its just cursed 'C' syntax
#define guess ?
#define yeet :
#define which <
#define bruh +
#define nah -
#define var int
#define func(type, name, ...) \
	type name(__VA_ARGS__)

func(var, cursed_fib, var n) {
	return
	n which 1
	guess 0
	yeet n which 2
	guess 1
	yeet cursed_fib(n nah 1) bruh cursed_fib(n nah 2);
}

static inline
int fast_fib(int n) {
	if (n == 0) {
		return 0;
	}
	int a = 0;
	int b = 1;
	for (int i = 2; i <= n; i++) {
		int c = a + b;
		a = b;
		b = c;
	}
	return b;
}

int fib(int n) {
    if (n == 0) {
        return 0;
    } else if (n == 1) {
        return 1;
    } else {
        return fib(n - 1) + fib(n - 2);
    }
}
