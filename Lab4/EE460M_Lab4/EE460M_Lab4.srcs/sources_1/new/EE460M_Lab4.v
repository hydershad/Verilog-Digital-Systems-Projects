//Hyder Shad
//UT EID: hs25796
//EE460M Lab4
//03-07-2018
module park_meter(clk, add50, add150, add200, add500, reset10, reset205, s0, s1, s2, s3, s4, s5, s6, an0, an1, an2, an3);
//input for debounce
input clk, add50, add150, add200, add500, reset10, reset205;
//outputs for out7seg
output s0, s1, s2, s3, s4, s5, s6, an0, an1, an2, an3;
reg flash, new_val;                                   // to identify when counter value is less than 200, used in out7seg;
reg [15:0] math;             //dummy register used to do math operations in decimal and check 9999 max limit for counter+addtime
reg[15:0] segment;           //7seg bcd disply values for parking meter
//slowclk output
wire slow_clk, bounce_clk;
//debounce outputs
wire [15:0] segment_add;                               //s10 and s100 are used to indicate new values that go into the seg10 and seg100 rtegisters from the button presses
//output from hexto7, inputs for out7seg
wire[3:0] sin1, sin10, sin100, sin1000;
wire [6:0]sout1, sout10, sout100, sout1000;            //value to display to actual 7segment

assign sin1 = segment % 10;                                    //for hexto7seg
assign sin10 = (segment/10)%10;
assign sin100 = (segment/100)%10;
assign sin1000 = segment/1000;

slowCLK slw(clk, slow_clk);                              //for the slow clock to decrement the parking meter
new_debounce d1(clk, add50, add150, add200, add500, segment_add);  //instantiates the debounce module which returns the add time values

hexToSevenSegment h1(sin1, sout1);                      //instantiates conversion from decimal register to 7 bit control for 7segments
hexToSevenSegment h2(sin10, sout10); 
hexToSevenSegment h3(sin100, sout100); 
hexToSevenSegment h4(sin1000, sout1000);

out7seg out1(clk, flash, sout1, sout10, sout100, sout1000, s0, s1, s2, s3, s4, s5, s6, an0, an1, an2, an3);

initial begin
segment = 0;
new_val = 1;
end

always@(posedge slow_clk)// posedge segment_add, posedge reset10, posedge reset205) 
begin
if(reset10 || reset205)
begin
flash = 1;
if(reset205)
    begin
   segment = 205;
    end
 else
        begin
        segment = 10;
        end
end
else if(segment_add && new_val)  //if time added
begin
new_val = 0;
flash = 1;
math = segment_add + segment;
if(math <= 9999)              //add time to current and update
begin
    segment = math;
end
else               //if ime is greater than max allowable, default to 9999
begin
    segment = 9999;
end
end  //end the button press update

else
begin
if(segment_add == 0)new_val = 1;
if(segment > 0)
begin
segment = segment - 1;
    if(segment < 200)
    begin
        if(segment % 2)
        begin
            flash = 0;
        end
        else
        begin
            flash = 1;
        end
    end
end
else
begin
flash = ~flash;
end
end //else

end  //end always case
endmodule


module new_debounce(bounce_clk, add50, add150, add200, add500, segment_add);

input bounce_clk, add50, add150, add200, add500;
output [15:0] segment_add;
reg [21:0] bounce_time;
reg [15:0] s;
reg [2:0]inuse;
reg flag;

assign segment_add = s;

initial begin
s = 0;
flag = 0;
end

always@(posedge bounce_clk)
begin

if(inuse > 3'b000)
begin
bounce_time = bounce_time +1;
    if(bounce_time[17])
    begin
    flag = 1;
    bounce_time = 0;
    end
end

else
begin
flag = 0;
bounce_time = 0;
end

end//always


always@(add50, add150, add200, add500)
begin
if(~add50 & ~add150 & ~add200 & ~add500)
begin
inuse = 3'b000;
end

 if(add50)begin
    if(inuse == 3'b000)
    begin
    inuse  = 3'b001;
    end
end

else if(add150)begin
    if(inuse == 3'b000)
    begin
    inuse  = 3'b010;
    end
end

else if(add200)begin
    if(inuse == 3'b000)
    begin
    inuse  = 3'b011;
    end
end

else if(add500)begin
    if(inuse == 3'b000)
    begin
    inuse  = 3'b100;
    end
end

else inuse = 3'b000;

end//always


always@( flag )
begin

case(inuse)
3'b000 : s = 0;

3'b001 : begin
if(add50)s = 50;
end
3'b010 : begin
if(add150)s = 150;
end
3'b011 : begin
if(add200)s = 200;
end
3'b100 : begin
if(add500)s = 500;
end
default : begin
s = 0;
end
endcase

end

endmodule



module slowCLK(clk, slow_clk);  //want to check for counter = 25'b1011111010111100001000000
  input clk;                              //fast clock in
  
  output slow_clk;  //slow clock out
  reg check;
  reg[25:0] counter;
  assign slow_clk = check;  //= 0.25seconds

  initial begin
  counter = 0;
  check = 0;
  end

  always @ (posedge clk)
  begin
   counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.

if(counter == 26'b10111110101111000010000000)
begin
check = ~check;
counter = 0;
end

end//always
endmodule



//hex converter for outputs
module hexToSevenSegment( x, rout); 
    input [3:0] x;
    output [6:0] rout;
    reg [6:0] r;
    assign rout = r;
    always@(*) 
            case (x) 
                4'b0000: r = 7'b0000001;//0 
                4'b0001: r = 7'b1001111;//1 
                4'b0010: r = 7'b0010010;//2 
                4'b0011: r = 7'b0000110;//3 
                4'b0100: r = 7'b1001100;//4 
                4'b0101: r = 7'b0100100;//5 
                4'b0110: r = 7'b0100000;//6 
                4'b0111: r = 7'b0001111;//7 
                4'b1000: r = 7'b0000000;//8 
                4'b1001: r = 7'b0001100;//9 
                endcase 
endmodule 

module out7seg(clk, flash, in0, in1, in2, in3, s0, s1, s2, s3, s4, s5, s6, an0, an1, an2, an3);
input clk, flash;
input [6:0] in0 ,in1, in2, in3;
output reg s0, s1, s2, s3, s4, s5, s6, an0, an1, an2, an3;
reg[17:0] counter;
reg [1:0] display;
always@(posedge clk)
begin
if(counter[17])
    begin
    display = display + 1;
    counter = 0;
end
else
    begin
    counter = counter + 1;
end
    
end // end always posedge clk

always@(display, flash, in0, in1, in2, in3)
begin
case(display)
0 : begin
    an0<= (~flash);
    an1<=1;
    an2<=1;
    an3<=1;
    s0<=in0[0];
    s1<=in0[1];
    s2<=in0[2];
    s3<=in0[3];
    s4<=in0[4];
    s5<=in0[5];
    s6<=in0[6];
end
1 : begin
  an0<=1;
  an1<= (~flash);
  an2<=1;
  an3<=1;
  s0<=in1[0];
  s1<=in1[1];
  s2<=in1[2];
  s3<=in1[3];
  s4<=in1[4];
  s5<=in1[5];
  s6<=in1[6];
end
2 : begin
  an0<=1;
  an1<=1;
  an2<= (~flash);
  an3<=1;
  s0<=in2[0];
  s1<=in2[1];
  s2<=in2[2];
  s3<=in2[3];
  s4<=in2[4];
  s5<=in2[5];
  s6<=in2[6];
end
3 : begin
  an0<=1;
  an1<=1;
  an2<=1;
  an3<= (~flash);
  s0<=in3[0];
  s1<=in3[1];
  s2<=in3[2];
  s3<=in3[3];
  s4<=in3[4];
  s5<=in3[5];
  s6<=in3[6];
end
default : begin 
            an0= 1;
            an1<=1;
            an2<=1;
            an3<=1;
   end
 
endcase
end // end display always
endmodule

