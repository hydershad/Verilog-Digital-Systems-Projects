//Hyder Shad
//UT EID: hs25796
//EE460M Lab #3 Part 3 Traffic FSM

module traffic_FSM(clk100Mhz, rst, Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw);

wire quartersecond;
input clk100Mhz, rst;
output Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw;
//output clock_out; //to show clock signal for debugging states


reg [1:0] seconds;
reg[4:0] count_timing, state_res;
reg [3:0] state;
wire [4:0] next_state[13:0];
wire[4:0] timing[13:0]; 
wire [2:0] Aout[13:0];
wire [2:0] Bout[13:0];
wire [1:0] Wout[13:0];

slowCLK s1(clk100Mhz, quartersecond);
//assign clock_out = seconds[1];

assign Ga = ((Aout[state]>>2)&(~rst));
assign Ya = ((Aout[state]>>1)&(~rst)); 
assign Ra = ((Aout[state])&(~rst)) | ((Aout[13])&(rst)&(seconds[1]));
assign Gb = ((Bout[state]>>2)&(~rst)) ;
assign Yb = ((Bout[state]>>1)&(~rst)); 
assign Rb = ((Bout[state])&(~rst)) | ((Bout[13])&(rst)&(seconds[1]));  
assign Gw = ((Wout[state]>>1)&(~rst));
assign Rw = ((Wout[state])&(~rst)) | ((Wout[13])&(rst)&(seconds[1]));

initial begin

state <=0;
count_timing <=0;
seconds<=0;
end

begin
 assign next_state[0] = 1;
 assign next_state[1] = 2;
 assign next_state[2] = 3;
 assign next_state[3] = 4;		
 assign next_state[4] = 5;		
 assign next_state[5] = 6;
 assign next_state[6] = 7;
 assign next_state[7] = 8;
 assign next_state[8] = 9;
 assign next_state[9] = 10;
 assign next_state[10] = 11;
 assign next_state[11] = 12;
 assign next_state[12] = 0;
 assign next_state[13] = 14;//reset states
// assign next_state[14] = 13;//reset states

 assign Aout[0] = 3'b100; //[Ga, Ya, Ra]
 assign Aout[1] = 3'b010;
 assign Aout[2] = 3'b001;
 assign Aout[3] = 3'b001;
 assign Aout[4] = 3'b001;
 assign Aout[5] = 3'b001;
 assign Aout[6] = 3'b001;
 assign Aout[7] = 3'b001;
 assign Aout[8] = 3'b001;
 assign Aout[9] = 3'b001;
 assign Aout[10] = 3'b001;
 assign Aout[11] = 3'b001;
 assign Aout[12] = 3'b001;
 assign Aout[13] = 3'b001;//reset states
 //assign Aout[14] = 3'b000;//reset states

assign Bout[0] = 3'b001; //[Gb, Yb, Rb]
assign Bout[1] = 3'b001;
assign Bout[2] = 3'b100;
assign Bout[3] = 3'b010;
assign Bout[4] = 3'b001;
assign Bout[5] = 3'b001;
assign Bout[6] = 3'b001;
assign Bout[7] = 3'b001;
assign Bout[8] = 3'b001;
assign Bout[9] = 3'b001;
assign Bout[10] = 3'b001;
assign Bout[11] = 3'b001;
assign Bout[12] = 3'b001;
assign Bout[13] = 3'b001;//reset states
//assign Bout[14] = 3'b000;//reset states

assign Wout[0] = 2'b01; //[Gw,Rw]
assign Wout[1] = 2'b01;
assign Wout[2] = 2'b01;
assign Wout[3] = 2'b01;
assign Wout[4] = 2'b10;
assign Wout[5] = 2'b01; //flash on
assign Wout[6] = 2'b00; //flash off 
assign Wout[7] = 2'b01; //flash on
assign Wout[8] = 2'b00; //flash off
assign Wout[9] = 2'b01; //flash on
assign Wout[10] = 2'b00;
assign Wout[11] = 2'b01; //flash on
assign Wout[12] = 2'b00; //flash off
assign Wout[13] = 2'b01;//reset states
//assign Wout[14] = 2'b00;//reset states

assign timing[0] = 12; //Ga
assign timing[1] = 8; //Ya
assign timing[2] = 12; //Gb
assign timing[3] = 4; //Yb
assign timing[4] = 8; //Gw
assign timing[5] = 0; //Fwon
assign timing[6] = 0; //Fwoff
assign timing[7] = 0; //Fwon
assign timing[8] = 0; //Fwoff
assign timing[9] = 0; //Fwon
assign timing[10] = 0; //Fwoff
assign timing[11] = 0; //Fwon
assign timing[12] = 0; //Fwoff
assign timing[13] = 1;//rst
//assign timing[14] = 1;//rst

end

always@(rst)
begin
if(rst)
begin
state_res = 5'b00000;
end
else
begin
state_res = 5'b11111;
end
end

always@(posedge quartersecond)
begin
seconds = seconds+1;
state = state & state_res;
count_timing = count_timing & state_res;

if(count_timing == timing[state])
begin
state <= next_state[state];
count_timing = 0;
end //count reset

else
begin
count_timing = (count_timing + 1);
end

end //end pos halfsecond 




endmodule


module slowCLK(clk100Mhz, quartersecond);  //want to check for counter = 25'b1011111010111100001000000

  input clk100Mhz; //fast clock
  
  output quartersecond; //slow clock
  reg check;
  reg[23:0] counter;
  assign quartersecond = check;  //= 0.25seconds

  initial begin
  counter = 0;
  check = 0;
  end

  always @ (posedge clk100Mhz)
  begin
   counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.

if(counter == 24'b101111101011110000100000)
begin
check <= ~check;
counter <= 0;
end


end//always
endmodule