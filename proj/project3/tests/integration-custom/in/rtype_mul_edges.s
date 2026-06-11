# R-type multiplication instructions: mul, mulh, mulhu
# Focus: low 32 bits vs high 32 bits, signed high multiply, unsigned high multiply.

addi t0, x0, -1       # t0 = 0xffffffff
addi t1, x0, 2        # t1 = 2
mul   t2, t0, t1      # t2 = 0xfffffffe, low 32 bits of -1 * 2
mulh  s0, t0, t1      # s0 = 0xffffffff, high signed 32 bits of -2
mulhu s1, t0, t1      # s1 = 0x00000001, high unsigned 32 bits of 0xffffffff * 2

addi t0, x0, 123      # t0 = 123
addi t1, x0, -7       # t1 = -7
mul   a0, t0, t1      # a0 = -861 = 0xfffffca3
mulh  t2, t0, t1      # t2 = 0xffffffff, high signed 32 bits of -861
mulhu s0, t0, t1      # s0 = 0x0000007a, high unsigned 32 bits of 123 * 0xfffffff9
