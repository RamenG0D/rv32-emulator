
#include "debug.h"

int fib(int n);

#define MAX_INPUT 30

int main(void) {
    printf("Fibonacci :D\n");

    int input = 0;
    // wait for user input
    printf("Enter a number: ");
    // read input from UART
    char buffer[20];
    get_string(buffer, 20);
    input = str2int(buffer, 10);
    // check if input is too large
    if (input > MAX_INPUT) {
        printf("Input too large, Please provide a number smaller than %d!\n", MAX_INPUT);
        return 0;
    }
    printf("Input: %d\n", input);

    int i = fib(input);

    // print value of i
    printf("Value: %d\n", i);

    return 0;
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
