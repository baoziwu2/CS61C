.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    ebreak
    # Prologue
    li t0 1
    bge a1 t0 loop_start
    li a1 36
    
loop_start:
    mv t0 a0
    slli t1 a1 2
    add t1 t1 a0
    lw t2 0(t0)
    li t4 0
loop_continue:
    lw t3 0(t0)
    bge t2 t3 skip_assign
    mv t2 t3
    sub t4 t0 a0
    srai t4 t4 2
skip_assign:
    addi t0 t0 4
    bne t0 t1 loop_continue
loop_end:
    # Epilogue
    mv a0 t4
    jr ra
