# I-type logical instructions: andi, ori, xori
# Focus: sign-extension of 12-bit immediates and correct ALUSel.

addi t0, x0, -1       # t0 = 0xffffffff
andi t1, t0, 0        # t1 = 0x00000000
andi t2, t0, 2047     # t2 = 0x000007ff
andi s0, t0, -2048    # s0 = 0xfffff800

ori  s1, x0, 0        # s1 = 0x00000000
ori  s1, s1, 2047     # s1 = 0x000007ff
ori  a0, x0, -2048    # a0 = 0xfffff800

xori t1, t0, -1       # t1 = 0x00000000
xori t2, x0, -1       # t2 = 0xffffffff
xori s0, t2, 2047     # s0 = 0xfffff800
xori s1, x0, 2047     # s1 = 0x000007ff
