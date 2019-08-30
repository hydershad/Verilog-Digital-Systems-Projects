force -deposit Q1 4'b0000 0ns
force -deposit Q2 4'b0000 0ns
force -deposit CO 0 0ns
force -deposit D1 4'b0011 0ns
force -deposit D2 4'b0001 0ns
force -deposit CLR 1 0ns
force clk 0 0, 1 10 -repeat 20
force LD 1 0ns, 0 15ns
force EN 1 0ns, 0 115ns, 1 155ns
force UP 1 0ns, 0 45ns, 1 135ns
force CLR 0 275
run 285ns
