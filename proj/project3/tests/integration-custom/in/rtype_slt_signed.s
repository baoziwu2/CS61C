# R-type signed comparison: slt
# Focus: signed less-than, equality, and negative-vs-positive cases.

addi t0, x0, -1       # t0 = -1
addi t1, x0, 1        # t1 = 1
slt  t2, t0, t1       # t2 = 1, because -1 < 1
slt  s0, t1, t0       # s0 = 0, because 1 < -1 is false
slt  s1, t0, t0       # s1 = 0, equality is not less-than

addi t0, x0, -2048    # t0 = smallest 12-bit immediate
addi t1, x0, 2047     # t1 = largest 12-bit immediate
slt  a0, t0, t1       # a0 = 1
slt  t2, t1, t0       # t2 = 0
