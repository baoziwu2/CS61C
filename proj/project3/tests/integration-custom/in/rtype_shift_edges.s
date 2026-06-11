# R-type shift instructions: sll, srl, sra
# Focus: shift amount comes from rs2 and only low 5 bits should be used.

addi t0, x0, 1        # t0 = 1
addi t1, x0, 37       # low 5 bits = 5
sll  t2, t0, t1       # t2 = 0x00000020

addi s0, x0, -32      # s0 = 0xffffffe0
sra  s1, s0, t1       # s1 = 0xffffffff, arithmetic right shift by 5
srl  a0, s0, t1       # a0 = 0x07ffffff, logical right shift by 5

addi t1, x0, 0        # shift by 0
sll  t0, s0, t1       # t0 = 0xffffffe0
srl  t2, s0, t1       # t2 = 0xffffffe0
sra  s1, s0, t1       # s1 = 0xffffffe0
