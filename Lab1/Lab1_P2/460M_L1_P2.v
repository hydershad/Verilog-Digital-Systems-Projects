//Hyder Shad
//UT EID: hs25796
//EE460M Lab1 P2 ALU design using case statement

module ALU(A, B, Cin, Out, Cout, Ctrl);

input [3:0] A, B;
input [2:0] Ctrl;
input Cin;
output [3:0] Out;
output Cout;
reg [3:0] Out; //register to hold output value
reg Cout;

reg[4:0] CB; //used to detect a carry/borrow value;

always @ (Ctrl or A or B or Cin)
begin
case(Ctrl)

//Add
4'b000 : begin
CB = 0;
CB = A + B + Cin;
if(CB[4])
begin
Cout = 1;
end
else
begin
Cout = 0;
end

Out = (A + B) + Cin;
end


//Sub
4'b001 : begin
if(A<(B+Cin))begin
Cout = 1;
end
else
begin
Cout = 0;
end
Out = (A-B) - Cin;

end


//Bit-wise ORR
4'b010 : begin
	Out[0] <= A[0] | B[0];
	Out[1] <= A[1] | B[1];
	Out[2] <= A[2] | B[2];
	Out[3] <= A[3] | B[3];
	Cout <= 0;
	end

//Bit-wise AND
4'b011 : begin
	Out[0] <= A[0] & B[0];
	Out[1] <= A[1] & B[1];
	Out[2] <= A[2] & B[2];
	Out[3] <= A[3] & B[3];
	Cout <= 0;
end

//Shift Left
4'b100 : begin
	Out[0] <= 0;
	Out[1] <= A[0];
	Out[2] <= A[1];
	Out[3] <= A[2];
	Cout <= 0;
end

//Shift Right
4'b101 : begin
	Out[0] <= A[1];
	Out[1] <= A[2];
	Out[2] <= A[3];
	Out[3] <= 0;
	Cout <= 0;
end

//ROL
4'b110 : begin
	Out[0] <= A[3];
	Out[1] <= A[0];
	Out[2] <= A[1];
	Out[3] <= A[2];
	Cout <= 0;
end

//ROR
4'b111 : begin
	Out[0] <= A[1];
	Out[1] <= A[2];
	Out[2] <= A[3];
	Out[3] <= A[0];
	Cout <= 0;
end

default: begin
Out  <= 0;
Cout <= 0;
end

endcase
end
endmodule

