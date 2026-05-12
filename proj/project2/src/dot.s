.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    ebreak
    li t0 1
    blt a2 t0 num_element_less_one
    blt a3 t0 stride_less_one
    blt a4 t0 stride_less_one
    j loop_start
    # Prologue
num_element_less_one:
    li a0 36
    j exit
stride_less_one:
    li a0 37
    j exit
loop_start:
    li t0 0 # t0 is res
    mv t1 a2
    slli t1 t1 2
    mv t2 a2
    slli t2 t2 2
    add t1 t1 a0 # t1 is end pointer to arr0
    add t2 t2 a1 # t2 is end pointer to arr1
    
loop:
    lw t3 0(a0) # now a0 become local pointer
    lw t4 0(a1) # same for a1
    mul t5 t3 t4
    add t0 t0 t5
    
    slli t3 a3 2 # now t3 is delta_arr0
    slli t4 a4 2 # same for t4

    add a0 a0 t3
    add a1 a1 t4
    
    bge a0 t1 loop_end
    bge a0 t2 loop_end
    j loop
loop_end:
    mv a0 t0
    # Epilogue
    jr ra
