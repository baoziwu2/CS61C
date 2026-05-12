    .globl classify

    .text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
# a0 (int) argc
# a1 (char**) argv
# a1[1] (char*) pointer to the filepath string of m0
# a1[2] (char*) pointer to the filepath string of m1
# a1[3] (char*) pointer to the filepath string of input matrix
# a1[4] (char*) pointer to the filepath string of output file
# a2 (int) silent mode, if this is 1, you should not print
# anything. Otherwise, you should print the
# classification and a newline.
# Returns:
# a0 (int) Classification
# Exceptions:
# - If there are an incorrect number of command line args,
# this function terminates the program with exit code 31
# - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
# main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>



classify:
# Stack layout (64 bytes total):
# sp+ 0: m0_rows sp+ 4: m0_cols
# sp+ 8: m1_rows sp+12: m1_cols
# sp+16: input_rows sp+20: input_cols
# sp+24: s8 sp+28: s7 sp+32: s6 sp+36: s5
# sp+40: s4 sp+44: s3 sp+48: s2 sp+52: s1
# sp+56: s0 sp+60: ra
    addi   sp sp -64
    sw     ra 60(sp)
    sw     s0 56(sp)        # argv
    sw     s1 52(sp)        # m0 ptr
    sw     s2 48(sp)        # m1 ptr
    sw     s3 44(sp)        # input ptr
    sw     s4 40(sp)        # h ptr
    sw     s5 36(sp)        # o ptr
    sw     s6 32(sp)        # print flag
    sw     s7 28(sp)        # (spare)
    sw     s8 24(sp)        # argmax result

    mv     s0 a1
    mv     s6 a2

    li     t0 5
    bne    a0 t0 error31

# Read pretrained m0
    lw     a0 4(s0)         # argv[1]
    addi   a1 sp 0          # &m0_rows
    addi   a2 sp 4          # &m0_cols
    call   read_matrix
    mv     s1 a0            # m0 ptr

# Read pretrained m1
    lw     a0 8(s0)
    addi   a1 sp 8
    addi   a2 sp 12
    call   read_matrix
    mv     s2 a0            # m1 ptr

# Read input matrix
    lw     a0 12(s0)
    addi   a1 sp 16
    addi   a2 sp 20
    call   read_matrix
    mv     s3 a0            # input ptr

# Compute h = matmul(m0 input)
    lw     t0 0(sp)         # m0_rows
    lw     t1 20(sp)        # input_cols
    mul    t0 t0 t1
    slli   t0 t0 2
    mv     a0 t0
    call   malloc
    beqz   a0 error26
    mv     s4 a0            # h ptr

    mv     a0 s1
    lw     a1 0(sp)         # m0_rows
    lw     a2 4(sp)         # m0_cols
    mv     a3 s3
    lw     a4 16(sp)        # input_rows
    lw     a5 20(sp)        # input_cols
    mv     a6 s4
    call   matmul

# Compute h = relu(h)
    lw     t0 0(sp)
    lw     t1 20(sp)
    mul    t0 t0 t1
    mv     a0 s4
    mv     a1 t0
    call   relu

# Compute o = matmul(m1 h)
    lw     t0 8(sp)         # m1_rows
    lw     t1 20(sp)        # input_cols (= h_cols)
    mul    t0 t0 t1
    slli   t0 t0 2
    mv     a0 t0
    call   malloc
    beqz   a0 error26
    mv     s5 a0            # o ptr

    mv     a0 s2            # m1 ptr
    lw     a1 8(sp)         # m1_rows
    lw     a2 12(sp)        # m1_cols
    mv     a3 s4            # h ptr
    lw     a4 0(sp)         # h_rows = m0_rows
    lw     a5 20(sp)        # h_cols = input_cols
    mv     a6 s5
    call   matmul

# Write output matrix o
    lw     a0 16(s0)        # argv[4]
    mv     a1 s5
    lw     a2 8(sp)         # m1_rows
    lw     a3 20(sp)        # input_cols
    call   write_matrix

# Compute and return argmax(o)
    lw     t0 8(sp)
    lw     t1 20(sp)
    mul    t0 t0 t1
    mv     a0 s5
    mv     a1 t0
    call   argmax
    mv     s8 a0

# If enabled print argmax(o) and newline
    bne    s6 x0 skip_print
    mv     a0 s8
    call   print_int
    li     a0 '\n'
    call   print_char

skip_print:
# ---- Free all heap allocations ----
    mv     a0 s1
    call   free             # m0
    mv     a0 s2
    call   free             # m1
    mv     a0 s3
    call   free             # input
    mv     a0 s4
    call   free             # h
    mv     a0 s5
    call   free             # o

    mv     a0 s8            # return classification

    lw     ra 60(sp)
    lw     s0 56(sp)
    lw     s1 52(sp)
    lw     s2 48(sp)
    lw     s3 44(sp)
    lw     s4 40(sp)
    lw     s5 36(sp)
    lw     s6 32(sp)
    lw     s7 28(sp)
    lw     s8 24(sp)
    addi   sp sp 64
    jr     ra

error26:
    li     a0 26
    j      exit
error31:
    li     a0 31
    j      exit
