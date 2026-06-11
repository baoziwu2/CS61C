# Task 8 custom test: sw/lw basic address calculation, no lui.
# Uses only addi plus load/store instructions.

addi s0, x0, 256       # base address
addi s1, x0, 1234      # positive word value
sw   s1, 0(s0)
lw   t0, 0(s0)         # expect 1234

addi s1, x0, -123      # negative word value
sw   s1, 4(s0)
lw   t1, 4(s0)         # expect -123 / 0xffffff85

sw   x0, 8(s0)
lw   t2, 8(s0)         # expect 0

sw   s1, -4(s0)        # negative S-type immediate
lw   a0, -4(s0)        # expect -123 / 0xffffff85
