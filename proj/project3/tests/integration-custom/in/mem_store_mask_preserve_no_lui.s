# Task 8 custom test: partial stores should preserve untouched byte lanes, no lui.

addi s0, x0, 576       # base address
sw   x0, 0(s0)

addi s1, x0, 17        # 0x11
sb   s1, 0(s0)
addi s1, x0, 34        # 0x22
sb   s1, 1(s0)
addi s1, x0, 51        # 0x33
sb   s1, 2(s0)
addi s1, x0, 68        # 0x44
sb   s1, 3(s0)
lw   a0, 0(s0)         # expect 0x44332211

addi s1, x0, 127       # 0x7f, overwrite byte 1 only
sb   s1, 1(s0)
lw   a0, 0(s0)         # expect 0x44337f11

addi s1, x0, 1365      # 0x0555, overwrite upper halfword only
sh   s1, 2(s0)
lw   a0, 0(s0)         # expect 0x05557f11

lh   t0, 0(s0)         # expect 0x00007f11
lh   t1, 2(s0)         # expect 0x00000555
lb   t2, 1(s0)         # expect 0x0000007f
