# Task 8 custom test: sb byte lanes and little-endian word assembly, no lui.
# If byte write masks or address low bits are wrong, the lw values will differ.

addi s0, x0, 320       # base address
sw   x0, 0(s0)         # clear word at base

addi s1, x0, 17        # 0x11
sb   s1, 0(s0)
lw   a0, 0(s0)         # expect 0x00000011

addi s1, x0, 34        # 0x22
sb   s1, 1(s0)
lw   a0, 0(s0)         # expect 0x00002211

addi s1, x0, 51        # 0x33
sb   s1, 2(s0)
lw   a0, 0(s0)         # expect 0x00332211

addi s1, x0, 68        # 0x44
sb   s1, 3(s0)
lw   a0, 0(s0)         # expect 0x44332211

lb   t0, 0(s0)         # expect 0x11
lb   t1, 1(s0)         # expect 0x22
lb   t2, 2(s0)         # expect 0x33
lb   s1, 3(s0)         # expect 0x44
