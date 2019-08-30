
module singleBCD(D, Q, clk, LD, EN, UP, CLR, CO);

input clk, EN, UP, CLR, LD ;
input [3:0] D;
output [3:0] Q;
reg [3:0] R, clear;
reg clear_reset;
output CO;
wire slowclk;
reg[27:0] counter;

initial begin
clear = 4'b1111;
clear_reset = 0;
R = 0;
counter = 0;
end

assign slowclk = counter[27];  //(2^27 / 100E6) = 1.34seconds
assign Q = R & clear; 
assign CO = CLR & EN &( (R[3] & (~R[2]) & (~R[1]) & R[0] & UP) | ((~R[3]) & (~R[2]) & (~R[1]) & (~R[0]) & ~(UP)) ); 


always @ (posedge clk)
begin
  counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
end


always@(CLR, clear_reset)
begin
if(clear_reset == 1)
begin
clear = 4'b1111;
end
if(CLR == 0)
begin
clear = 4'b0000;
end

end	//always block for clr


always@(posedge slowclk)
begin

R = R & clear;
if(clear == 4'b0000)
begin
clear_reset = 1;
end
clear_reset = ~clear[0];
if(EN == 1)
begin

	if(LD == 1)
	begin
	R = D;
	end

	else if(UP == 1)
	begin
		if(R == 9)
		begin
		R = 4'b0000;
		end
		else
		begin
		R = R+1;
		end
	end

	else
	begin
		if(R == 0)
		begin
		R = 4'b1001;
		end
		else
		begin
		R = R-1;
		end
	end

end	//end of enable if statement 

else
begin
	//do nothing
end 	//else redundant

end	//always block

endmodule

