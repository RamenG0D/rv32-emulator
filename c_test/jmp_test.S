
#define NUM_LOOPS 100

# we are going to jump to the label 'spin'
# and spin a few times then return to main
main:
    # store our current return address on the stack
    addi sp, sp, -4
    sw ra, 0(sp)
    # call our 'spin' function
    jal spin
    # restore our return address
    lw ra, 0(sp)
    addi sp, sp, 4
    # return from main
    ret

spin:
    li t0, NUM_LOOPS
    # loop 1000 times
    loop:
        addi t0, t0, -1
        bnez t0, loop
    # return from spin
    ret