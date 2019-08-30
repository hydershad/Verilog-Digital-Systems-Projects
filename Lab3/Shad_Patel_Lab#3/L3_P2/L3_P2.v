module package_sort(clk, reset, weight, Grp1, Grp2, Grp3, Grp4, Grp5, Grp6, currentGrp);

input clk, reset;
input [11:0] weight;
output [7:0] Grp1, Grp2, Grp3, Grp4, Grp5, Grp6;
reg [7:0] G1, G2, G3, G4, G5, G6;
output [2:0]currentGrp;
reg [2:0]current;
reg new_weight;
initial begin
current= 0;
new_weight = 1;
end

assign Grp1 = G1;
assign Grp2 = G2;
assign Grp3 = G3;
assign Grp4 = G4;
assign Grp5 = G5;
assign Grp6 = G6;
assign currentGrp = current;

always@(weight)
begin


if(weight == 0)
begin
current = 0;
new_weight = 1;
end


else if((weight>=1) && (weight<=250))
begin
current = 3'b001;
end

else if((weight>=251) && (weight<=500)) 
begin
current = 3'b010;
end

else if((weight>=501) && (weight<=750))
begin
current = 3'b011;
end

else if((weight>=751) && (weight<=1500))
begin
 current = 3'b100;
end

else if((weight>=1501) && (weight<=2000)) 
begin
current = 3'b101;
end
else if(2000<weight)
begin
current = 3'b110;
end

else
begin
end

end // end awlways

always@(posedge reset)
begin

G1 <= 0;
G2 <= 0;
G3 <= 0;
G4 <= 0;
G5 <= 0;
G6 <= 0;

end

always@(negedge clk)

if((new_weight == 1) && (reset==0))
begin

if(current == 1)G1 = G1+1;
else if(current == 2)G2 = G2+1;
else if(current == 3)G3 = G3+1;
else if(current == 4)G4 = G4+1;
else if(current == 5)G5 = G5+1;
else if(current == 6)G6 = G6+1;

else
begin
end
new_weight = 0;

end
endmodule
