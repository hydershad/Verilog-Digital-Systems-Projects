
module VGA(pixelclk,strobecount, sw, hsync,vsync, Red, Green, Blue, Keyin); 

input pixelclk;
input [7:0] sw, Keyin;
input[3:0]strobecount;
output [3:0] Red, Green, Blue;
output reg hsync, vsync;
reg [9:0] hcount, vcount;
reg[2:0] orient, orientold; //00 right, 01, left, 10 up, 11 down
reg [11:0] xpos, ypos, xsize, ysize;
reg[20:0] movecount, speed;
reg pause, alive, newkey;
reg [7:0]keyold;
reg[3:0] R, G, B, blackout;

assign Red = R & blackout;
assign Green = G & blackout;
assign Blue = B & blackout;

initial
begin
hcount = 0;
vcount = 0;
R = 0; 
G = 0;
B = 0;
orient = 0;
orientold = 0;
blackout = 4'b1111;
alive = 1;
pause = 1;
xpos = 300;
ypos = 200;
 xsize = 39;
 ysize = 9;
speed = 21'b001000000000000000000;
end

always @(*)
begin

if(pause == 0)
begin
    if(orient>1)
    begin
    xsize = 9;
    ysize = 39;
    end
    else
    begin
    xsize = 39;
    ysize = 9;
    end
end

if(hcount >= 659 && hcount <= 755) hsync <= 1'b0; 
else hsync <= 1'b1; 
if(vcount >= 493 && vcount <= 494) vsync <= 1'b0; 
else vsync <= 1'b1;

end//always star


always @(posedge pixelclk)
begin
if((strobecount == 1)||(Keyin != keyold))newkey = 1;

if((newkey))
begin
newkey = 0;
    case(Keyin)
        'h74:  
            begin
                if(pause==0)
                begin
                orient = 2'b00; //right arrow
                    if(orientold == 2'b10)
                    begin
                    ypos = ypos + 30;
                    end
                orientold = orient;
                end
            end
        'h6b:  
            begin
                if(pause==0)
                begin
                orient = 2'b01; //left
                if(orientold == 2'b11)
                    begin
                    xpos = xpos-30;
                    end
                if(orientold == 2'b10)
                    begin
                    xpos = xpos-30;
                    ypos= ypos+30;
                    end
                orientold = orient;
                end
            end
        'h75:  
            begin
                if(pause==0)
                begin
                orient = 2'b10; //up
                if(orientold == 2'b00)
                    begin
                    ypos = ypos - 30;
                    end
                if(orientold == 2'b01)
                    begin
                    ypos = ypos - 30;
                    xpos = xpos + 30;
                    end
                    
                orientold = orient;
                end
            end
        'h72:  
            begin
                if(pause==0)
                begin
                orient = 2'b11; //down
                if(orientold == 2'b01)
                    begin
                    xpos = xpos + 30;
                    end   
                orientold = orient;
                end
            end
        'h1b: 
        begin
        pause = 0; //S = start
        orient = 0;
        blackout = 4'b1111;
        xpos = 300;
        ypos = 200;
        alive = 1;
        end
        'h4d: if(alive)pause = 1; //P = pause
        'h2d: if(alive)pause = 0; //R = resume
        'h76:   //ESC
         begin
         alive = 0;
         pause = 1;
         blackout = 4'b0000;
         end
         
        'h05: if(pause ==0)speed =  21'b010000000000000000000;
        'h06: if(pause ==0)speed =  21'b001000000000000000000;
        'h04: if(pause ==0)speed =  21'b000100000000000000000;
        'h0C: if(pause ==0)speed =  21'b000010000000000000000;
        default: blackout = 4'b1111;
    endcase
    keyold = Keyin;
end

if((pause == 0))
begin
    if((xpos<1) || ((xpos+xsize)>638) || (ypos<1) || ((ypos+ysize)>478))
    begin
    pause = 1;
    alive = 0;
    end
    
    else if(movecount==speed)
    begin
    movecount = 0;
        case(orient)
        2'b00:xpos = xpos+1;
        2'b01:xpos = xpos-1;
        2'b10:ypos = ypos-1;
        2'b11:ypos = ypos+1;
        endcase
    end
    
    else movecount = movecount+1;
end

if(hcount == 800) 
begin
hcount = 0; 
if(vcount == 525)vcount = 0;
else vcount = vcount + 1; 
end
else 
begin
hcount = hcount + 1; 
vcount = vcount; 
end

if(hcount < 640 && vcount < 480)
begin
    if( (((xpos)<= hcount) && (hcount<=(xpos+xsize))) && (((ypos)<=vcount) && (vcount<=(ypos+ysize))) )
    begin
        case (sw) 
        8'b00000001: 
        begin
        R <= 4'b1111; 
        G <= 4'b1111; 
        B <= 4'b1111;  
        end 
        8'b00000010: 
        begin
        R <= 4'b1111; 
        G <= 0;
        B <= 0;  
        end 
        8'b00000100: 
        begin
        R <= 4'b1111; 
        G <= 4'b1111; 
        B <= 4'b1111;  
        end 
        8'b00001000: 
        begin
        R <= 4'b1111; 
        G <= 0; 
        B <= 0;  
        end 
        8'b00010000: 
        begin
        R <= 0; 
        G <= 4'b1111; 
        B <= 0;  
        end 
        8'b00100000: 
        begin
        R <= 0; 
        G <= 4'b1111; 
        B <= 0;  
        end 
        8'b01000000: 
        begin
        R <= 4'b1111; 
        G <= 0; 
        B <= 0;  
        end 
        8'b10000000: 
        begin
        R <= 0; 
        G <= 0; 
        B <= 4'b1111;
        end 
        default: 
        begin
        R <= 0;
        G <= 0; 
        B <= 0;
        end
        endcase  
     end
        
    else
    begin
     case (sw) 
           8'b00000001: 
           begin
           R <= 0; 
           G <= 0; 
           B <= 0;  
           end 
           8'b00000010: 
           begin
           R <= 0; 
           G <= 0;
           B <= 4'b1111;  
           end 
           8'b00000100: 
           begin
           R <= 4'b1001; 
           G <= 4'b0100; 
           B <= 4'b0001;  
           end 
           8'b00001000: 
           begin
           R <= 4'b0000; 
           G <= 4'b1111; 
           B <= 4'b1111;  
           end 
           8'b00010000: 
           begin
           R <= 4'b1111; 
           G <= 0; 
           B <= 0;  
           end 
           8'b00100000: 
           begin
           R <= 4'b1001; 
           G <= 0; 
           B <= 4'b1001;  
           end 
           8'b01000000: 
           begin
           R <= 4'b1111; 
           G <= 4'b1111; 
           B <= 0;  
           end 
           8'b10000000: 
           begin
           R <= 4'b1111; 
           G <= 4'b1111; 
           B <= 4'b1111;  
           end 
           default: 
           begin
           R <= 0;
           G <= 0; 
           B <= 0;
           end
           endcase  
   end
   
end

else
begin
R <= 0; 
G <= 0; 
B <= 0;
end
end

endmodule

module clkDivider(clk, clockvalue , slowClk);
  input clk; //fast clock
  output reg slowClk; //slow clock
  input [1:0] clockvalue; 
  reg[1:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk)
  begin
    if(counter == clockvalue) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end

endmodule 