    .globl matmul

    .text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# d = matmul(m0, m1)
# Arguments:
# a0 (int*) is the pointer to the start of m0
# a1 (int) is the # of rows (height) of m0
# a2 (int) is the # of columns (width) of m0
# a3 (int*) is the pointer to the start of m1
# a4 (int) is the # of rows (height) of m1
# a5 (int) is the # of columns (width) of m1
# a6 (int*) is the pointer to the the start of d
# Returns:
# None (void), sets d = matmul(m0, m1)
# Exceptions:
# Make sure to check in top to bottom order!
# - If the dimensions of m0 do not make sense,
# this function terminates the program with exit code 38
# - If the dimensions of m1 do not make sense,
# this function terminates the program with exit code 38
# - If the dimensions of m0 and m1 don't match,
# this function terminates the program with exit code 38
# =======================================================
matmul:
    ebreak
    addi   sp sp -48
    sw     ra 44(sp)
    sw     s0 40(sp)         # A*
    sw     s1 36(sp)         # rows_A
    sw     s2 32(sp)         # cols_A
    sw     s3 28(sp)         # B*
    sw     s4 24(sp)         # cols_B
    sw     s5 20(sp)         # C*
    sw     s6 16(sp)         # outer loop i
    sw     s7 12(sp)         # inner loop j

    li     t0 1
    blt    a1 t0 error38     # rows_A < 1
    blt    a2 t0 error38     # cols_A < 1
    blt    a4 t0 error38     # rows_B < 1
    blt    a5 t0 error38     # cols_B < 1
    bne    a2 a4 error38     # cols_A != rows_B

    mv     s0 a0             # A*
    mv     s1 a1             # rows_A
    mv     s2 a2             # cols_A
    mv     s3 a3             # B*
    mv     s4 a5             # cols_B
    mv     s5 a6             # C*
    li     s6 0              # i = 0

outer_loop:
    bge    s6 s1 matmul_done
    li     s7 0              # j = 0

inner_loop:
    ebreak
    bge    s7 s4 next_row

# a0 = &A[i][0] = A* + i*cols_A*4
    mul    t0 s6 s2
    slli   t0 t0 2
    add    a0 s0 t0          # arr0 pointer

# a1 = &B[0][j] = B* + j*4
    slli   t1 s7 2
    add    a1 s3 t1          # arr1 pointer

    mv     a2 s2             # cols_A
    li     a3 1              # stride_A = 1
    mv     a4 s4             # stride_B = cols_B（

    call   dot

# C[i*cols_B + j] = result
    mul    t0 s6 s4
    add    t0 t0 s7
    slli   t0 t0 2
    add    t0 s5 t0
    sw     a0 0(t0)

    addi   s7 s7 1
    j      inner_loop

next_row:
    addi   s6 s6 1
    j      outer_loop

matmul_done:
    lw     ra 44(sp)
    lw     s0 40(sp)
    lw     s1 36(sp)
    lw     s2 32(sp)
    lw     s3 28(sp)
    lw     s4 24(sp)
    lw     s5 20(sp)
    lw     s6 16(sp)
    lw     s7 12(sp)
    addi   sp sp 48
    ret

error38:
    li     a0 38
    j      exit