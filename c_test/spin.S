.text

.global print_str
.global spin

main:
    # just spin and print forever
spin:
    # load the std i/o address
    li t1, 0x10000000
    # load the address of the string
    la t0, string
    # print "spining\n"
    j print_str
    # and then jump back to the start of the loop
    j spin

    # t3 contains the address of the uart
    # t0 contains the address of the string
print_str:
    # put the current return address on the stack
    addi sp, sp, -32
    sw ra, 0(sp)
    # loop through the string
    loop:
        # load the current character
        lbu a0, 0(t0)
        ## if the character is null, we are done
        beqz a0, done
        # otherwise, print the character
        sb a0, 0(t1)
        # increment the string pointer
        addi t0, t0, 1
        # and loop
        j loop
    done:
        # restore the return address
        lw ra, 0(sp)
        addi sp, sp, 32
        # return
        ret

.data

# string to print
string:
    .asciz "spining\n"
