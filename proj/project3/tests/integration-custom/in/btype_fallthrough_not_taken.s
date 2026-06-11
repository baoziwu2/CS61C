# B-type fall-through test: many not-taken branches in a row.
# This is good for catching PCSel that is always choosing PC + imm.
# Expected final debug registers:
# t0 = 5, t1 = 6, t2 = 7, s0 = 8, s1 = 9, a0 = 10

addi t0, x0, 5
addi t1, x0, 6
addi t2, x0, 0
addi s0, x0, 0
addi s1, x0, 0
addi a0, x0, 0

beq  t0, t1, fail       # not taken
bne  t0, t0, fail       # not taken
blt  t1, t0, fail       # not taken, signed
bge  t0, t1, fail       # not taken, signed
bltu t1, t0, fail       # not taken, unsigned positive values
bgeu t0, t1, fail       # not taken, unsigned positive values

addi t2, x0, 7
addi s0, x0, 8
addi s1, x0, 9
addi a0, x0, 10
beq  x0, x0, done

fail:
addi t2, x0, -1
addi s0, x0, -1
addi s1, x0, -1
addi a0, x0, -1

done:
addi x0, x0, 0
