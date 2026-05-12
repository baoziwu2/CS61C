.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -44
    sw ra,  40(sp)
    sw s0,  36(sp)   # filename
    sw s1,  32(sp)   # rows ptr
    sw s2,  28(sp)   # cols ptr
    sw s3,  24(sp)   # file descriptor
    sw s4,  20(sp)   # matrix ptr (heap)
    sw s5,  16(sp)   # total byte count for matrix

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen(filename, 0)
    mv   a0, s0
    li   a1, 0
    call fopen
    li   t0, -1
    beq  a0, t0, error27
    mv   s3, a0          # fd

    # fread rows (4 bytes)
    mv   a0, s3
    mv   a1, s1
    li   a2, 4
    call fread
    li   t0, 4
    bne  a0, t0, error29

    # fread cols (4 bytes)
    mv   a0, s3
    mv   a1, s2
    li   a2, 4
    call fread
    li   t0, 4
    bne  a0, t0, error29

    # malloc(rows * cols * 4)
    lw   t0, 0(s1)
    lw   t1, 0(s2)
    mul  t0, t0, t1
    slli t0, t0, 2
    mv   s5, t0          # save byte count (callee-saved, survives malloc call)
    mv   a0, t0
    call malloc
    beqz a0, error26
    mv   s4, a0          # matrix ptr

    # fread matrix data
    mv   a0, s3
    mv   a1, s4
    mv   a2, s5          # s5 preserved across fread
    call fread
    bne  a0, s5, error29

    # fclose
    mv   a0, s3
    call fclose
    li   t0, -1
    beq  a0, t0, error28

    mv   a0, s4          # return matrix ptr

    lw ra,  40(sp)
    lw s0,  36(sp)
    lw s1,  32(sp)
    lw s2,  28(sp)
    lw s3,  24(sp)
    lw s4,  20(sp)
    lw s5,  16(sp)
    addi sp, sp, 44
    ret

error26: 
    li a0, 26 
    j exit
error27: 
    li a0, 27
    j exit
error28: 
    li a0, 28
    j exit
error29: 
    li a0, 29
    j exit
