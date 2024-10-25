
#include "debug.h"

#define VALUE_64 0x1234567890ABCDEFULL

int main(void) {
    int64_t x = 0;

    // Test 1
    x = VALUE_64;
    // assert(x == VALUE_64);

    // Test 2
    x = 0;

    // pointer test
    int64_t* ptr = &x;

    printf("x = %lx\n", x);
    printf("x = %ld\n", x);
    *ptr = VALUE_64;
    printf("x = %lx\n", x);

    assert(x == VALUE_64);

    return 0;
}
