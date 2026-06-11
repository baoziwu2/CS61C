# Task 8 custom test: positive/negative offsets and store-load dependencies, no lui.

addi s0, x0, 512       # base address
addi t0, x0, 77
sw   t0, -8(s0)        # store before base
lw   t1, -8(s0)        # expect 77 immediately after store

addi t2, t1, 1         # expect 78
sw   t2, 12(s0)
lw   a0, 12(s0)        # expect 78

addi s1, x0, -45
sw   s1, -12(s0)
lw   t0, -12(s0)       # expect -45 / 0xffffffd3

addi s1, t0, 45        # expect 0 if load result was correct
sw   s1, 16(s0)
lw   t2, 16(s0)        # expect 0
