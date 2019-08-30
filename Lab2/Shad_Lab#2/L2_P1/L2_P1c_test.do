force CLK 1 0, 0 10 -repeat 20ns
force -deposit Q1 0 0ns
force -deposit Q2 0 0ns
force -deposit Q3 0 0ns
force X 1 0ns, 0 25ns, 1 45ns, 0 65ns, 1 85ns, 1 105ns, 1 125ns, 1 145ns, 0 165ns, 1 185ns, 1 205ns, 0 225ns
run 255ns