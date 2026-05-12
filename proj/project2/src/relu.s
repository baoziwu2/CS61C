.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li t0 1
    bge a1 t0 loop_start
    li a1, 36
    j exit
loop_start:
    mv t0, a0
    slli t1 a1 2
    add t1 t1 a0
loop_continue:
    beq t0 t1 loop_end
    lw t2 0(t0)
    bge t2 x0 skip
    sw x0, 0(t0)
skip:
    addi t0 t0 4
    j loop_continue
loop_end:
    # Epilogue
    jr ra
