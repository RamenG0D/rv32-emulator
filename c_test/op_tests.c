
#include "debug.h"

#define TEST(op, expected, x_val, y_val) { \
    int x = x_val; \
    int y = y_val; \
    printf("Testing Operation %s with x = %d and y = %d\n", #op, x, y); \
    assert_eq((x op y), expected); \
}

#define TEST_UN(op, expected, x_val) { \
    int x = x_val; \
    printf("Testing Operation %s with x = %d\n", #op, x); \
    assert_eq((op x), expected); \
}

#define check_int(x, expected) { \
    printf("Checking %d == %d\n", x, expected); \
    assert_eq(x, expected); \
}

#define PUSH_CSR(csr, name, val) { \
    asm volatile ( \
        /* set a register to our value */ \
        "li t0, " #val "\n" \
        #csr " zero," #name ", t0\n" \
        : \
        : \
        : "t0" \
    ); \
}
#define POP_CSR(csr, name, input) { \
    asm volatile ( \
        #csr " %0, " #name ", zero\n" \
        : "=r" (input) \
    ); \
}

#define TEST_CSR(csr, value, rname) { \
    printf("Testing CSR %s\n", #csr); \
    int x /* the value to be read from the CSR */; \
    PUSH_CSR(csr, rname, value); \
    POP_CSR(csr, rname, x); \
    check_int(x, value); \
}

void test_bin_ops(void);
void test_un_ops(void);
void test_csrs(void);

int main(void) {
    test_bin_ops();
    test_un_ops();
    test_csrs();

    return 0;
}

void test_csrs(void) {
    printf("Running csr_tests\n");
    TEST_CSR(csrrw, 5, mtvec);
    TEST_CSR(csrrs, 5, mtvec);
    TEST_CSR(csrrc, 5, satp);
    printf("All tests passed\n");
}

void test_un_ops(void) {
    printf("Running un_op_tests\n");
    TEST_UN(-, -5, 5);
    TEST_UN(~, -6, 5);
    TEST_UN(!, 0, 1);
    printf("All tests passed\n");
}

void test_bin_ops(void) {
    printf("Running op_tests\n");
    TEST(+, 10, 5, 5);
    TEST(-, 0, 5, 5);
    TEST(*, 25, 5, 5);
    TEST(/, 2, 10, 5);
    TEST(%, 0, 5, 5);
    TEST(^, 1, 5, 4);
    TEST(&, 4, 5, 4);
    TEST(|, 5, 5, 4);
    TEST(<<, 10, 5, 1);
    TEST(>>, 2, 5, 1);
    TEST(&&, 1, 1, 1);
    TEST(||, 1, 1, 0);
    TEST(==, 1, 1, 1);
    TEST(!=, 1, 1, 0);
    TEST(<, 1, 1, 2);
    TEST(>, 1, 2, 1);
    TEST(<=, 1, 1, 2);
    TEST(>=, 1, 2, 1);

    // Test that should fail
    // TEST(+, 11, 5, 5);

    printf("All tests passed\n");
}
