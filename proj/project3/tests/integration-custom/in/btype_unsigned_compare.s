# B-type unsigned comparisons: bltu and bgeu.
# t0 = -1 means 0xffffffff, so unsigned t0 > 1.
# Expected final debug registers:
# t0 = -1, t1 = 1, t2 = 7, s0 = 8, s1 = 9, a0 = 10

addi t0, x0, -1        # 0xffffffff unsigned
addi t1, x0, 1
addi t2, x0, 0
addi s0, x0, 0
addi s1, x0, 0
addi a0, x0, 0

bltu t1, t0, unsigned_lt_taken  # taken: 1 < 0xffffffff unsigned
addi t2, x0, -1                 # skipped

unsigned_lt_taken:
addi t2, x0, 7
bltu t0, t1, fail               # not taken: 0xffffffff < 1 unsigned is false
addi s0, x0, 8
bgeu t0, t1, unsigned_ge_taken  # taken: 0xffffffff >= 1 unsigned
addi s0, x0, -1                 # skipped

unsigned_ge_taken:
addi s1, x0, 9
bgeu t1, t0, fail               # not taken: 1 >= 0xffffffff unsigned is false
addi a0, x0, 10
beq  x0, x0, done

fail:
addi a0, x0, -1

done:
addi x0, x0, 0
