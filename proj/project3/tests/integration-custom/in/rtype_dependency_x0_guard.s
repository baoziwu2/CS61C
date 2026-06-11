# R-type dependency and x0 guard test.
# Focus: consecutive writeback/read, and writes to x0 must be ignored.

addi t0, x0, 5        # t0 = 5
addi t1, x0, 6        # t1 = 6

add  x0, t0, t1       # x0 must stay 0
add  t2, x0, t0       # t2 = 5 if x0 is hardwired to 0

sub  x0, t1, t0       # x0 must stay 0
add  s0, x0, t1       # s0 = 6

mul  x0, t0, t1       # x0 must stay 0
add  s1, x0, t0       # s1 = 5

add  a0, t2, s0       # a0 = 11, dependency on t2 and s0
sub  a0, a0, s1       # a0 = 6, dependency on previous a0 and s1
