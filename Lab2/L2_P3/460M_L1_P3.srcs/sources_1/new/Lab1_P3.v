
module singleBCD(D, Q, clk, LD, EN, UP, CLR, CO);

input clk, EN, UP, CLR, LD ;
input [3:0] D;
output [3:0] Q;
reg [3:0] R;
output CO;
reg cout;


 assign Q = R;
 assign CO = cout; 


always@(CLR)
begin

if(CLR == 0)
begin
R = 0;
end	//clr if statement
end	//always block for clr

always@(posedge clk)
begin
cout = CLR & EN &( (R[3] & (~R[2]) & (~R[1]) & R[0] & UP) | ((~R[3]) & (~R[2]) & (~R[1]) & (~R[0]) & ~(UP)) );
if(CLR == 0)
begin
R = 0;
end	//clr if statement

else if(EN == 1)
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

end	//end of enable elseif statement 

else
begin
	
end 	//else redundant


end	//always block

endmodule
