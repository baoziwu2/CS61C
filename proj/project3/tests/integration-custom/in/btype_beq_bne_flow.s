# B-type basic control-flow test: beq and bne, both taken and not taken.
# Expected final debug registers:
# t0 = 1, t1 = 2, t2 = 3, s0 = 4, s1 = 5, a0 = 6

addi t0, x0, 0
addi t1, x0, 0
addi t2, x0, 0
addi s0, x0, 0
addi s1, x0, 0
addi a0, x0, 0

addi t0, x0, 1
beq  t0, x0, fail1      # not taken: 1 != 0
addi t1, x0, 2
beq  t0, t0, pass1      # taken
addi t1, x0, -1         # skipped

pass1:
bne  t0, t0, fail2      # not taken: 1 == 1
addi t2, x0, 3
bne  t0, x0, pass2      # taken: 1 != 0
addi t2, x0, -1         # skipped

pass2:
addi s0, x0, 4
beq  x0, x0, done       # unconditional branch using beq

fail1:
addi t0, x0, -1
beq  x0, x0, done

fail2:
addi t1, x0, -1
beq  x0, x0, done

done:
addi s1, x0, 5
addi a0, x0, 6
