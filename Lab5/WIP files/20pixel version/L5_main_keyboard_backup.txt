//Hyder Shad hs25796
//main module outputs scan code to 7seg and instantiates VGA and Keyboard reader modules
module main(clk, PS2Data,PS2Clk, strobe, an0, an1, an2, an3, segout, Hsync,Vsync, vgaRed, vgaGreen, vgaBlue, sw);
input PS2Data;
input clk;
input PS2Clk;//keyclk
input [7:0] sw; 
output strobe;
output reg an0, an1, an2, an3;//selecting the anode 
output  [3:0] vgaRed, vgaGreen, vgaBlue; 

output  Hsync, Vsync;
output [6:0]segout;
reg [6:0]segout;
reg [17:0] counter;
reg display;
wire [7:0] sout;
wire pixel, strobesignal;
wire [3:0]strobecount;
wire [6:0] seg0, seg1;


assign strobe = strobesignal;
//wire slow_clk;

keyboardIN key(pixel,PS2Data, PS2Clk, sout, strobesignal, strobecount);
bcdToSeven(sout[7:4], seg1);
bcdToSeven(sout[3:0], seg0);
clkDivider(clk, 2'b10 , pixel);
VGA(pixel,strobecount,sw, Hsync,Vsync, vgaRed, vgaGreen, vgaBlue, sout);


always @(posedge clk)//main runs the seven seg and instantiates other game functions
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
end

always @(display)
begin
if (display == 0)
    begin
    an0 = 0;
    an1 = 1;
    an2 = 1;
    an3 = 1;
    segout = seg0;
    end
else 
    begin
    an0 = 1;
    an1 = 0;
    an2 = 1;
    an3 = 1;
    segout = seg1;
    end
end

endmodule


module keyboardIN(slwclk,controllerdata, keyclk, sout1, strobe, strobecount);
input controllerdata, keyclk,slwclk;
output [7:0] sout1;
output strobe;
output reg[3:0] strobecount;
reg [21:0] shiftreg, timing, oldshiftregister;
reg [3:0] counter;
reg [7:0] sout;
reg strobesignal;
assign sout1 = sout;
assign strobe = strobesignal;

initial begin
sout = 0;
strobesignal = 0;
shiftreg = 0;
counter = 0;
timing =0;

end

always@(negedge slwclk)
begin
if(counter==9)strobecount = 10;

if((strobecount>0))
    begin
    if(timing == 500000)
    begin
        strobesignal = ~strobesignal;
        timing = 0;
        strobecount = strobecount -1;
   end
   else timing = timing +1;
end
else strobesignal = 0;


end//always strobe

always@(negedge keyclk)
begin

counter = counter + 1;
shiftreg [20:0] = shiftreg [21:1]; 
shiftreg [21] = controllerdata;

if(shiftreg[9:2] == 8'b11110000 && counter == 10)
begin

sout <= shiftreg[20:13];
end

else if (counter == 11)
begin

sout <= sout;
counter <= 0;
end

else
begin

sout <= sout;
end

end
endmodule


module bcdToSeven(bcd, sevenseg);
input [3:0]bcd;
output reg [6:0]sevenseg;

always @(bcd)
begin
case (bcd) 
4'b0000: sevenseg = 7'b0000001;//0 
4'b0001: sevenseg = 7'b1001111;//1 
4'b0010: sevenseg = 7'b0010010;//2 
4'b0011: sevenseg = 7'b0000110;//3 
4'b0100: sevenseg = 7'b1001100;//4 
4'b0101: sevenseg = 7'b0100100;//5 
4'b0110: sevenseg = 7'b0100000;//6 
4'b0111: sevenseg = 7'b0001111;//7 
4'b1000: sevenseg = 7'b0000000;//8 
4'b1001: sevenseg = 7'b0001100;//9
4'b1010: sevenseg = 7'b0001000;//A
4'b1011: sevenseg = 7'b1100000;//b
4'b1100: sevenseg = 7'b0110001;//C
4'b1101: sevenseg = 7'b1000010;//d
4'b1110: sevenseg = 7'b0110000;//E
4'b1111: sevenseg = 7'b0111000;//F
endcase
end
endmodule
