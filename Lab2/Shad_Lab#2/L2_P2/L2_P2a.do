force -deposit Q 4'b0000 0ns
force -deposit CO 0 0ns
force -deposit D 4'b0110 0ns
force -deposit CLR 1 0ns
force clk 0 0, 1 10 -repeat 20
force LD 1 0ns, 0 15ns
force EN 1 0ns
force UP 1 0ns, 0 105ns.
force CLR 0 125ns
run 155ns
