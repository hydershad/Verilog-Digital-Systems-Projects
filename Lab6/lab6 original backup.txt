module tracker(clk, start, rst, mode, overflow, s0, s1, s2 ,s3, s4, s5, s6, an0, an1, an2, an3);
input clk, start, rst;
input [1:0] mode;
output overflow, s0, s1, s2 ,s3, s4, s5, s6, an0, an1, an2, an3; //sec;
//output [2:0] m;
reg step_over;
reg [23:0] steps, elapsed_time;                                //step counter , total elapsed time since simulation
reg [15:0] hactive_count, hactive_trig, distance, hybrid_state, add_steps;    //counter for highactive seconds, distance traveled = steps/2048, counts since hybrid mode entered for state
wire [6:0] sout1, sout10, sout100, sout1000;                  //counter to triggger highactive
reg [3:0] steps_over32, sin1, sin10, sin100, sin1000;         //# of seconds with over 32 steps taken, count only for first 9 seconds;
reg [2:0] disp_mode;

wire second;
wire [7:0] hybridsteps[12:0];
//assign sec = second;
//assign m = disp_mode;

clk_div(clk, second);

hexToSevenSegment h1(sin1, sout1);                  //instantiates conversion from decimal register to 7 bit control for 7segments
hexToSevenSegment h2(sin10, sout10); 
hexToSevenSegment h3(sin100, sout100); 
hexToSevenSegment h4(sin1000, sout1000);

out7seg out1(clk, sout1, sout10, sout100, sout1000, s0, s1, s2, s3, s4, s5, s6, an0, an1, an2, an3);
assign overflow = step_over;

begin

assign hybridsteps[0] = 0;
assign hybridsteps[1] = 20;
assign hybridsteps[2] = 33;
assign hybridsteps[3] = 66;
assign hybridsteps[4] = 27;
assign hybridsteps[5] = 70;
assign hybridsteps[6] = 30;
assign hybridsteps[7] = 19;
assign hybridsteps[8] = 30;
assign hybridsteps[9] = 33;
assign hybridsteps[10] = 69;
assign hybridsteps[11] = 34;
assign hybridsteps[12] = 124;

end //ROM table for hybrid state

initial 
begin
hybrid_state = 1;
steps = 0;
elapsed_time = 0;
disp_mode = 0;
hactive_count=0;
hactive_trig = 0;
distance = 0;
steps_over32 = 0; 
sin1 = 0; 
sin10 = 0;
sin100 = 0;
sin1000 = 0;
add_steps = 32;

end


always@(posedge second, posedge rst)
begin

disp_mode = disp_mode +1;

if(rst)
begin
    hybrid_state = 1;
    steps = 0;
    elapsed_time = 0;
    disp_mode = 0;
    hactive_count=0;
    hactive_trig = 0;
    distance = 0;
    steps_over32 = 0; 
    sin1 = 0; 
    sin10 = 0;
    sin100 = 0;
    sin1000 = 0;
end

else if((start==1) && (rst==0))
begin
    elapsed_time = elapsed_time +1;
    
    if(mode == 2'b00)add_steps = 32;
    else if(mode == 2'b01)add_steps = 64;
    else if(mode == 2'b10)add_steps = 128;
    else
    begin
     add_steps = hybridsteps[hybrid_state];
     hybrid_state = hybrid_state+1;
    end
    if(mode != 2'b11)hybrid_state = 1;
    
    if((elapsed_time<10)&& (add_steps>32)) steps_over32 = steps_over32 +1;

    if(add_steps >63)
    begin
           hactive_trig = hactive_trig+1;
           if(hactive_trig == 60)hactive_count = hactive_count + 60;
           if(hactive_trig > 60)hactive_count = hactive_count +1;
    end
    else hactive_trig = 0; //do not reset hactive count
    
    steps = steps + add_steps;
    if(steps>9999)step_over = 1;
    else step_over =0;
    distance = (steps / 1024)*5; // distance in half miles
   
   if(disp_mode < 2)
    begin
        if(steps>9999)
        begin
            sin1 = 9;
            sin10 = 9;
            sin100 = 9;
            sin1000 = 9;
        end
        else
        begin
            sin1 = steps % 10;                                    //for hexto7seg
            sin10 = (steps/10)%10;
            sin100 = (steps/100)%10;
            sin1000 = (steps/1000)%10;
        end
    end //00 mode
    
    else if((disp_mode>1) && (disp_mode<4))
    begin
        sin1 = distance % 10;                                    //for hexto7seg
        sin10 = 4'b1111;
        sin100 = (distance/10)%10;
        sin1000 = (distance/100)%10;
    end //01 mode
    
    else if((disp_mode>3) && (disp_mode<6))
    begin
       sin1 = steps_over32 % 10;
       sin10 = 0;
       sin100 = 0;
       sin1000 = 0; 
    end //10 mode
    
    else
    begin
        sin1 = hactive_count % 10;
        sin10 = (hactive_count/10)%10;
        sin100 = (hactive_count/100)%10;
        sin1000 = (hactive_count/1000)%10;
    end//11 mode

    
end  //start && ~rst

end //always second


endmodule


module clk_div(clk, second);
input clk;
output second;

reg [26:0] timing;
reg ss;
assign second = ss;

initial begin
timing = 0;
ss = 0;
end

always@(posedge clk)
begin



    if(timing == 27'b010111110101111000010000000)//00000
    begin
    timing = 0;
    ss = ~ss;
    end
    else timing = timing+1;


end//always

endmodule

module hexToSevenSegment(x, rout); 
    input [3:0] x;
    output [6:0] rout;
    reg [6:0] r;
    assign rout = r;
    always@(x) 
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
                4'b1111: r = 7'b1110111; // _ underscore dash
                endcase 
endmodule 

module out7seg(clk, in0, in1, in2, in3, s0, s1, s2, s3, s4, s5, s6, an0, an1, an2, an3);
input clk;
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

always@(display, in0, in1, in2, in3)
begin
case(display)
0 : begin
    an0<= 0;
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
  an1<= 0;
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
  an2<= 0;
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
  an3<= 0;
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
