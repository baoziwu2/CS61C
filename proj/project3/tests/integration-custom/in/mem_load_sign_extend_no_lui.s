# Task 8 custom test: lb/lh/lw sign extension, no lui.

addi s0, x0, 448       # base address
addi s1, x0, -1
sw   s1, 0(s0)

lb   t0, 0(s0)         # expect -1 / 0xffffffff
lb   t1, 1(s0)         # expect -1 / 0xffffffff
lh   t2, 0(s0)         # expect -1 / 0xffffffff
lw   a0, 0(s0)         # expect -1 / 0xffffffff

sw   x0, 4(s0)
addi s1, x0, -128      # low byte = 0x80
sb   s1, 4(s0)
lb   s1, 4(s0)         # expect -128 / 0xffffff80
lw   a0, 4(s0)         # expect 0x00000080, proves sb only wrote one byte

sw   x0, 8(s0)
addi s1, x0, -2048     # low halfword = 0xf800
sh   s1, 8(s0)
lh   t0, 8(s0)         # expect 0xfffff800
lw   a0, 8(s0)         # expect 0x0000f800, proves sh only wrote two bytes
