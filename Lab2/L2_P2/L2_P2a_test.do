force -deposit Q 4'b0000 0ns
force -deposit CO 0 0ns
force -deposit D 4'b0010 0ns
force -deposit CLR 1 0ns
force clk 0 0, 1 10 -repeat 20
force LD 1 0ns, 0 15ns
force EN 1 0ns, 0 35ns, 1 55ns
force UP 1 0ns, 0 15ns, 1 35ns, 0 105ns
force CLR 0 45ns, 1 55ns
run 225ns
