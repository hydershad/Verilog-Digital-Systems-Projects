module dualBCD(D1, D2, Q1, Q2, clk, LD, EN, UP, CLR, CO);
input LD, EN, CLR, UP, clk;
input [3:0] D1, D2;
output [3:0] Q1, Q2;
output CO;
wire onescarry;

reg ten_enable;
singleBCD onedigit(D1, Q1, clk, LD, EN, UP, CLR, onescarry);
singleBCD tensdigit(D2, Q2, clk, LD, ten_enable, UP, CLR);

always@(posedge onescarry, negedge clk, LD)
begin
if(LD == 1 && EN == 1)
begin
ten_enable = 1;
end

else if(clk == 0 && onescarry == 0)
begin
ten_enable = 0;
end

else
begin
ten_enable = onescarry;
end
end


endmodule

//module dualBCD(D1, D2, Q1, Q2, clk, LD, EN, UP, CLR, CO);
//input LD, EN, CLR, UP, clk;
//input [3:0] D1, D2;
//output [3:0] Q1, Q2;
//output CO;
//wire onescarry;
//reg [3:0]R2, clear;
//wire[3:0]clear_reset;
//
//singleBCD onedigit(D1, Q1, clk, LD, EN, UP, CLR, onescarry);
//
//initial begin
//clear = 4'b1111;
//R2 = 0;
//end
//
//assign clear_reset = ~clear;
//assign CO = CLR & EN &( ((Q1 == 9 )&(Q2 == 9) & UP) | ((Q1 == 0) & (Q2 == 0) & ~UP ));
//assign Q2 = R2 & clear;
//
//always@(CLR, clear_reset)
//begin
//if(clear_reset == 4'b1111)
//begin
//clear = 4'b1111;
//end
//if(CLR == 0)
//begin
//clear = 4'b0000;
//end
//end
//
//always@(posedge clk)
//begin
//R2 = R2 & clear;
//
//if(LD==1 && EN==1)
//begin
//R2 = D2;
//end
//
//end //posedge clk
//
//always@(posedge onescarry)
//begin
//
//if(EN && UP)
//begin
//	if(R2 == 9)
//	begin
//	R2 = 4'b0000;
//	end
//	else
//	begin
//	R2 = R2 + 1;
//	end
//end	//end if
//
//else if(EN && (~UP))
//begin
//	if(R2 == 0)
//	begin
//	R2 = 4'b1001;
//	end
//	else
//	begin
//	R2 = R2 - 1;
//	end
//end //end else if
//else
//begin
//end
//
//end // end always statement
//
//
//endmodule
//
