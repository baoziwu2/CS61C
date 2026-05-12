.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================

# void write_matrix(char *filename, int *matrix, int rows, int cols)
write_matrix:
    # Prologue
    addi sp sp -44
    sw ra  40(sp)
    sw s0  36(sp)   # filename
    sw s1  32(sp)   # matrix ptr
    sw s2  28(sp)   # rows
    sw s3  24(sp)   # cols
    sw s4  20(sp)   # fd
    sw s5  16(sp)   # total element count
    # sp+0..sp+7: scratch (rows/cols stored for fwrite header)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3

    # fopen(filename, 1)
    mv   a0 s0
    li   a1 1
    call fopen
    li   t0 -1
    beq  a0 t0 error27
    mv   s4 a0

    # header
    # Store rows & cols into scratch area at bottom of stack frame
    sw   s2 0(sp)        # [sp+0] = rows
    sw   s3 4(sp)        # [sp+4] = cols
    mv   a0 s4           # fd
    mv   a1 sp           # pointer to {rows, cols}
    li   a2 2            # 2 elements
    li   a3 4            # 4 bytes each
    call fwrite
    li   t0 2
    bne  a0 t0 error30

    # fwrite matrix data
    mul  s5 s2 s3       # total elements (callee-saved → survives fwrite)
    mv   a0 s4
    mv   a1 s1
    mv   a2 s5
    li   a3 4
    call fwrite
    bne  a0 s5 error30  # s5 preserved across call

    # fclose
    mv   a0 s4
    call fclose
    li   t0 -1
    beq  a0 t0 error28

    lw ra  40(sp)
    lw s0  36(sp)
    lw s1  32(sp)
    lw s2  28(sp)
    lw s3  24(sp)
    lw s4  20(sp)
    lw s5  16(sp)
    addi sp sp 44
    ret

error27: 
    li a0 27 
    j exit
error28: 
    li a0 28
    j exit
error30: 
    li a0 30
    j exit