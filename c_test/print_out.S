
.text

main:
    # li t1, 0x10000000
    # # write 'H' (72) to address 0x10000000 (uart address, allows us to print to console)
    # li t0, 72
    # sb t0, 0(t1)
    # li t0, 10 # newline
    # sb t0, 0(t1)

# print out the string
    la t0, string # load address of string into t0
    li t1, 0x10000000 # load uart address into t1
print:
    lb t2, 0(t0) # load byte from address in t0 into t2
    beqz t2, end # if t2 is 0, end
    sb t2, 0(t1) # store byte in t2 to address in t1
    addi t0, t0, 1 # increment t0
    j print # jump to print
end:

    ret

.data

string:
    .ascii "Hello, World!"
