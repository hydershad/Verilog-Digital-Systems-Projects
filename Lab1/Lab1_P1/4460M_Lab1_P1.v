
//Hyder Shad
//UT EID: hs25796
//EE460M Lab1 P1(a) 1-bit full subtractor
//Logic Equations derived from given truth table:
//
//Diff = A'B'Bin + A'BBin' + AB'Bin' + ABBin
//Bout = A'Bin + A'B + BBin
//

module BitSubtractor(A, B, Bin, Diff, Bout);
   output Diff, Bout;
   input A, B, Bin;

	assign Diff = (~A & ~B & Bin) | (~A & B & ~Bin) | (A & ~B & ~Bin) | (A & B & Bin);
	assign Bout = (~A & Bin) | (~A & B) | (B & Bin);

endmodule

//EE460M Lab1 P1(b) 4-bit full subtractor
//Uses module 'BitSubtractor' from Lab1 P1(a) as a component to create a 4 bit full subtractor

module Subtractor4bit (A, B, Bin, Diff, Bout);
output [3:0] Diff;
output Bout;
input [3:0] B;
input [3:0] A;
input Bin;
wire [3:1] Brw;  //internal borrows

BitSubtractor s1(A[0], B[0], Bin, Diff[0], Brw[1]);
BitSubtractor s2(A[1], B[1], Brw[1], Diff[1], Brw[2]);
BitSubtractor s3(A[2], B[2], Brw[2], Diff[2], Brw[3]);
BitSubtractor s4(A[3], B[3], Brw[3], Diff[3], Bout);

endmodule

