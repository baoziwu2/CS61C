# Mixed I-type dependency test.
# Focus: consecutive writeback/read dependency and different ALU operations.

addi t0, x0, 3        # t0 = 3
slli t0, t0, 4        # t0 = 48
addi t0, t0, -1       # t0 = 47 = 0x0000002f
andi t1, t0, 15       # t1 = 15 = 0x0000000f
ori  t2, t1, -2048    # t2 = 0xfffff80f
xori s0, t2, -1       # s0 = 0x000007f0
srli s1, s0, 4        # s1 = 0x0000007f
srai a0, t2, 8        # a0 = 0xfffffff8
slti t1, a0, -7       # t1 = 1, because -8 < -7
slti t2, a0, -8       # t2 = 0, because -8 < -8 is false
