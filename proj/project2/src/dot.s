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
    li   t0, 1
    blt  a2, t0, num_element_less_one
    blt  a3, t0, stride_less_one
    blt  a4, t0, stride_less_one

    li   t0, 0    # result
    li   t5, 0    # counter i

loop:
    bge  t5, a2, loop_end
    lw   t3, 0(a0)
    lw   t4, 0(a1)
    mul  t6, t3, t4
    add  t0, t0, t6

    slli t3, a3, 2     # stride0 * 4
    slli t4, a4, 2     # stride1 * 4
    add  a0, a0, t3
    add  a1, a1, t4
    addi t5, t5, 1
    j    loop

loop_end:
    mv   a0, t0
    jr   ra

num_element_less_one:
    li   a0, 36
    j    exit

stride_less_one:
    li   a0, 37
    j    exit
