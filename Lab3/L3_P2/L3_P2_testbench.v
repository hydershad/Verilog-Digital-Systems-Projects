module tb_package_sort;
reg clk;
reg reset;
reg [11:0] weight;
wire [7:0] Grp1;
wire [7:0] Grp2;
wire [7:0] Grp3;
wire [7:0] Grp4;
wire [7:0] Grp5;
wire [7:0] Grp6;
wire [2:0] currentGrp;

package_sort u1(
.clk(clk),
.reset(reset), 
.weight(weight),
.Grp1(Grp1),
.Grp2(Grp2), 
.Grp3(Grp3), 
.Grp4(Grp4), 
.Grp5(Grp5), 
.Grp6(Grp6),
.currentGrp(currentGrp)
);

initial begin
clk = 1;
reset = 1;
//weight1 = 0;

#3
reset = 0;//3

#2
weight = 12'd270;//5

#10 
weight = 0;//15

#10
weight = 12'd300;//25

#10
weight = 0;//35

#10
weight = 12'd501; //45

#10
weight = 12'd1013; //55

#10
weight =  12'd502;

#10
weight = 0;

#10
weight = 12'd200;

#10
weight = 12'd700;

end

 always
 #10 clk = ~clk;
endmodule
