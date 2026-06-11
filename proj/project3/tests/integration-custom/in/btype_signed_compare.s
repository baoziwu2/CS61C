# B-type signed comparisons: blt and bge.
# Tests that -1 < 1 is true under signed comparison.
# Expected final debug registers:
# t0 = -1, t1 = 1, t2 = 11, s0 = 22, s1 = 33, a0 = 44

addi t0, x0, -1
addi t1, x0, 1
addi t2, x0, 0
addi s0, x0, 0
addi s1, x0, 0
addi a0, x0, 0

blt  t0, t1, signed_lt_taken    # taken: -1 < 1
addi t2, x0, -1                 # skipped

signed_lt_taken:
addi t2, x0, 11
blt  t1, t0, fail               # not taken: 1 < -1 is false
addi s0, x0, 22
bge  t1, t0, signed_ge_taken    # taken: 1 >= -1
addi s0, x0, -1                 # skipped

signed_ge_taken:
addi s1, x0, 33
bge  t0, t1, fail               # not taken: -1 >= 1 is false
addi a0, x0, 44
beq  x0, x0, done

fail:
addi a0, x0, -1

done:
addi x0, x0, 0
