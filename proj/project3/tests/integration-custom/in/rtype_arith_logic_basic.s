# R-type arithmetic/logical instructions: add, sub, and, or, xor
# Focus: rs1/rs2 wiring, BSel = RegReadData2, and ALUSel selection.

addi t0, x0, 42       # t0 = 0x0000002a
addi t1, x0, -15      # t1 = 0xfffffff1

add  t2, t0, t1       # t2 = 27 = 0x0000001b
sub  s0, t0, t1       # s0 = 57 = 0x00000039
and  s1, t0, t1       # s1 = 32 = 0x00000020
or   a0, t0, t1       # a0 = 0xfffffffb
xor  t0, t0, t1       # t0 = 0xffffffdb

addi t1, x0, 7        # t1 = 7
add  t2, t2, t1       # t2 = 34, dependency on previous t2
sub  s0, s0, t1       # s0 = 50, dependency on previous s0
