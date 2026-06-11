# I-type shift instructions: slli, srli, srai
# Focus: shamt edge cases and distinction between logical/arithmetic right shift.

addi t0, x0, 1        # t0 = 1
slli t1, t0, 31       # t1 = 0x80000000
srli t2, t1, 31       # t2 = 0x00000001
srai s0, t1, 31       # s0 = 0xffffffff
srai s1, t1, 30       # s1 = 0xfffffffe
srli a0, t1, 30       # a0 = 0x00000002

slli t0, t0, 0        # t0 = 0x00000001
addi t1, x0, -1       # t1 = 0xffffffff
srli t2, t1, 1        # t2 = 0x7fffffff
srai s0, t1, 1        # s0 = 0xffffffff
slli s1, t1, 4        # s1 = 0xfffffff0
