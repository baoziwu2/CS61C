# Guard test: I-type writes to x0 must not change x0.
# This catches accidental RegFile x0 mutability or write-enable mistakes.

addi x0, x0, 123      # x0 must stay 0
ori  x0, x0, -1       # x0 must stay 0
slli x0, x0, 31       # x0 must stay 0
addi t0, x0, 5        # t0 should be 5 if x0 is still hardwired to 0
andi t1, x0, -1       # t1 should be 0
xori t2, x0, -1       # t2 should be 0xffffffff
