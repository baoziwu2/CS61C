# Task 8 custom test: sh halfword lanes, lh, and partial-store preservation, no lui.

addi s0, x0, 384       # base address
sw   x0, 0(s0)

addi s1, x0, 1929      # 0x0789 fits in addi immediate
sh   s1, 0(s0)
lw   a0, 0(s0)         # expect 0x00000789
lh   t0, 0(s0)         # expect 0x00000789

addi s1, x0, 291       # 0x0123
sh   s1, 2(s0)
lw   a0, 0(s0)         # expect 0x01230789
lh   t1, 2(s0)         # expect 0x00000123

sw   x0, 4(s0)
addi s1, x0, -1
sh   s1, 4(s0)
lw   s1, 4(s0)         # expect 0x0000ffff, proves sh did not write all 4 bytes
lh   t2, 4(s0)         # expect 0xffffffff, proves lh sign extension
