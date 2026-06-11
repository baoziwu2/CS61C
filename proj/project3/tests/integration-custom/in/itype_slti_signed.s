# I-type signed comparison: slti
# Focus: signed comparison and sign-extension of the immediate.

addi t0, x0, -1       # t0 = -1
slti t1, t0, 0        # t1 = 1, because -1 < 0
slti t2, t0, -1       # t2 = 0, because -1 < -1 is false
slti s0, t0, -2048    # s0 = 0, because -1 < -2048 is false

addi t0, x0, 0        # t0 = 0
slti s1, t0, 1        # s1 = 1, because 0 < 1
slti a0, t0, 0        # a0 = 0, because 0 < 0 is false

addi t0, x0, 2047     # t0 = 2047
slti t1, t0, 2047     # t1 = 0, equality is not less-than
slti t2, t0, -1       # t2 = 0, signed 2047 < -1 is false

addi t0, x0, -2048    # t0 = -2048
slti s0, t0, -2047    # s0 = 1, because -2048 < -2047
slti s1, t0, -2048    # s1 = 0, equality is not less-than
