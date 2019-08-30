force -deposit flash 0 0ns
force -deposit segment 0 0ns
force -deposit new_val 0 0ns
force -deposit add50 0 0ns
force -deposit add150 0 0ns
force -deposit add200 0 0ns
force -deposit add500 0 0ns
force -deposit reset10 0 0ns
force -deposit reset205 0 0ns
force clk 0 0, 1 1 -repeat 2
force add50 1 1ns, 0 3 ns, 1 5ns, 0 7 ns, 1 9ns, 0 20ns, 1 22ns, 0 24ns, 1 26ns, 0 28ns
force add200 1 51ns, 0 53 ns, 1 55ns, 0 57 ns, 1 59ns, 0 70ns, 1 72ns, 0 74ns, 1 76ns, 0 78ns
force add500 1 85ns, 0 87 ns, 1 89ns, 0 91 ns, 1 93ns, 0 110ns, 1 112ns, 0 114ns, 1 116ns, 0 118ns, 1 130, 0 140, 1 150, 0 160, 1 170, 0 180
force reset10 1 225ns, 0 228ns
force reset205 1 250ns, 0 255ns
run 270ns
