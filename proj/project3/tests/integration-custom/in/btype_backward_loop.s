# B-type backward-branch test: uses a negative branch immediate.
# Sums 3 + 2 + 1 into s0 using bne as the loop branch.
# Expected final debug registers:
# t0 = 0, t1 = 0, t2 = 3, s0 = 6, s1 = 99, a0 = 6

addi t0, x0, 3         # loop counter
addi t1, x0, 0         # constant zero
addi t2, x0, 3         # original count marker
addi s0, x0, 0         # sum
addi s1, x0, 0
addi a0, x0, 0

loop:
add  s0, s0, t0        # s0 += counter; requires R-type add from Task 6
addi t0, t0, -1
bne  t0, t1, loop      # backward branch while t0 != 0

addi s1, x0, 99
addi a0, s0, 0         # a0 = 6
