force CLK 1 0, 0 10 -repeat 20ns
force -deposit Q1 0 0ns
force -deposit Q2 0 0ns
force -deposit Q3 0 0ns
force X 1 0ns, 0 25ns, 1 45ns, 1 65ns, 0 85ns, 0 105ns, 1 125ns, 1 145ns, 1 165ns, 1 185ns, 0 205ns, 1 225ns
run 255ns