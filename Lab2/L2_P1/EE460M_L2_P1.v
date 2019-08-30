module P1_behavioral(CLK, X, S, V);

input X, CLK; output S, V; 
 
reg [2:0] X0_next [6:0]; 
reg [2:0] X1_next [6:0]; 
reg [1:0] X0_out [6:0]; 
reg [1:0] X1_out [6:0]; 
 
reg [2:0] state; 
reg updateV;
wire [2:0] next_state; 

initial begin 
state = 0;
  

X0_next[0] <= 1; X1_next[0] <= 2; 
X0_next[1] <= 3; X1_next[1] <= 4; 
X0_next[2] <= 4; X1_next[2] <= 4; 
X0_next[3] <= 5; X1_next[3] <= 5; 
X0_next[4] <= 5; X1_next[4] <= 6; 
X0_next[5] <= 0; X1_next[5] <= 0;
X0_next[6] <= 0; X1_next[6] <= 0;  
X0_out[0] <= 2'b10; X1_out[0] <= 2'b00; 
X0_out[1] <= 2'b10; X1_out[1] <= 2'b00; 
X0_out[2] <= 2'b00; X1_out[2] <= 2'b10; 
X0_out[3] <= 2'b00; X1_out[3] <= 2'b10; 
X0_out[4] <= 2'b10; X1_out[4] <= 2'b00; 
X0_out[5] <= 2'b00; X1_out[5] <= 2'b10; 
X0_out[6] <= 2'b10; X1_out[6] <= 2'b01; 
end

assign S = (X==0)? X0_out[state][1] : X1_out[state][1]; 
 
assign next_state = (X==0)? X0_next[state] : X1_next[state]; 
assign V = updateV;
 
always @(negedge CLK) 
begin 
state <= next_state; 
updateV <= (X==0)? X0_out[state][0] : X1_out[state][0]; 
end


endmodule


module P1_dataflow(CLK, X, S, V);

input CLK, X;
output S, V;
reg Q1, Q2, Q3, updateV;
initial begin
Q1 <=0;
Q2 <=0;
Q3 <=0;
end

assign V = updateV;
assign S = (~X & ~Q1 & ~Q2) | (X & ~Q1 & Q2) | (X & Q1 & Q3) | (~X & Q1 & ~Q3);

always@(negedge CLK)		//logic equations
begin
Q1<=(X & ~Q1 & Q3) | (~Q1 & Q2) | (Q1 & ~Q2 & ~Q3);
Q2<=(X & ~Q2 & ~Q3) | (~X & ~Q1 & ~Q2 & Q3);
Q3<=(Q2 & Q3) | (~X & ~Q2 & ~Q3) | (~X & ~Q1 & ~Q2);
updateV = (X & Q1 & Q2);
end


endmodule

module P1_structural(CLK, X, S, V);

input X, CLK;
output S, V; 


wire Xn, CLKn, D1, D2, D3, Q1, Q2, Q3, Q1n, Q2n, Q3n;


not(CLKn, CLK);
not (Xn, X);

//V
and(V, X, Q1, Q2);


//S = (~X & ~Q1 & ~Q2) | (X & ~Q1 & Q2) | (X & Q1 & Q3) | (~X & Q1 & ~Q3);
wire s1, s2, s3, s4;
and(s1, Xn, Q1n, Q2n);
and(s2, X, Q1n, Q2);
and(s3, X, Q1, Q3);
and(s4, Xn, Q1, Q3n);
or(S, s1, s2, s3, s4);

//D1 <=(X & ~Q1 & Q3) | (~Q1 & Q2) | (Q1 & ~Q2 & ~Q3);
wire d1s1, d1s2, d1s3;
and(d1s1, X, Q1n, Q3);
and(d1s2, Q1n, Q2);
and(d1s3, Q1, Q2n, Q3n);
or(D1, d1s1, d1s2, d1s3);

//D2 <=(X & ~Q2 & ~Q3) | (~X & ~Q1 & ~Q2 & Q3);
wire d2s1, d2s2;
and(d2s1, X, Q2n, Q3n);
and(d2s2, Xn, Q1n, Q2n, Q3);
or(D2, d2s1, d2s2);

//D3 <=(Q2 & Q3) | (~X & ~Q2 & ~Q3) | (~X & ~Q1 & ~Q2);
wire d3s1, d3s2, d3s3;
and(d3s1, Q2, Q3);
and(d3s2, Xn, Q2n, Q3n);
and(d3s3, Xn, Q1n, Q2n);
or(D3, d3s1, d3s2, d3s3);

//DFF negedgeCLK pulse detector


//DFF Q1
//DFF DFF1(D1, CLKn, Q1, Q1n);
wire d1x, d1y;
nand(d1x, CLKn, D1);
nand(d1y, CLKn, d1x);
nand(Q1, d1x, Q1n);
nand(Q1n, d1y, Q1);

//DFF Q2
//DFF DFF2(D2, CLKn, Q2, Q2n);
wire d2x, d2y;
nand(d2x, CLKn, D2);
nand(d2y, CLKn, d2x);
nand(Q2, d2x, Q2n);
nand(Q2n, d2y, Q2);
//DFF Q3

//DFF DFF3(D3, CLKn, Q3, Q3n);
wire d3x, d3y;
nand(d3x, CLKn, D3);
nand(d3y, CLKn, d3x);
nand(Q3, d3x, Q3n);
nand(Q3n, d3y, Q3);

endmodule


