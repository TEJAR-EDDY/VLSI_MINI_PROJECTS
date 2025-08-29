// vending machine rtl design code
//Author:Teja_Reddy

module vending_machine(
input clk,
input reset,
input coin5,
input coin10,
input coin25,
input select,
output reg[4:0] change,
output reg dispense);

//parameter declarations with binary encoding

parameter IDLE=3'b000;
parameter COIN5=3'b001;
parameter COIN10=3'b010;
parameter COIN15=3'b011;
parameter COIN20=3'b100;
parameter DISPENSE=3'b101;

//INTERNAL STATE REGISTERS
reg[2:0]current_state,next_state;
reg[5:0]total_amount;
parameter PRODUCT_PRICE=5'd25;

//state trasition block seq block
always@(posedge clk or posedge reset)begin
if(reset)begin
	current_state<=IDLE;
	total_amount<=5'd0;
end
else begin
current_state<=next_state;
case(current_state)
IDLE:begin
	total_amount<=5'd0;
	if(coin5) total_amount<=5'd5;
	else if(coin10)total_amount<=5'd10;
	else if(coin25)total_amount<=5'd25;
end
COIN5:begin
	total_amount<=5'd0;
	if(coin5) total_amount<=5'd10;
	else if(coin10)total_amount<=5'd15;
	else if(coin25)total_amount<=5'd30;
end
COIN10:begin
	total_amount<=5'd0;
	if(coin5) total_amount<=5'd15;
	else if(coin10)total_amount<=5'd20;
	else if(coin25)total_amount<=6'd35;
end
COIN15:begin
	total_amount<=5'd0;
	if(coin5) total_amount<=5'd20;
	else if(coin10)total_amount<=5'd25;
	else if(coin25)total_amount<=6'd40;
end
COIN20:begin
	total_amount<=5'd0;
	if(coin5) total_amount<=5'd25;
	else if(coin10)total_amount<=5'd30;
	else if(coin25)total_amount<=6'd45;
end
DISPENSE:begin
	total_amount<=5'd0;
end
endcase
end
end

//combinational logic or next state logic
always@(*)begin
next_state<=current_state;
case(current_state)
IDLE:begin
	if(coin5) next_state=COIN5;
	else if(coin10)next_state=COIN10;
	else if(coin25)next_state=DISPENSE;
end
COIN5:begin
	if(select && total_amount>=PRODUCT_PRICE) 
	next_state=DISPENSE;
	else if(coin5) next_state=COIN10;
	else if(coin10)next_state=COIN15;
	else if(coin25)next_state=DISPENSE;
end
COIN10:begin
	if(select && total_amount>=PRODUCT_PRICE) 
	next_state=DISPENSE;
	else if(coin5) next_state=COIN15;
	else if(coin10)next_state=COIN20;
	else if(coin25)next_state=DISPENSE;
end
COIN15:begin
	if(select && total_amount>=PRODUCT_PRICE) 
	next_state=DISPENSE;
	else if(coin5) next_state=COIN20;
	else if(coin10)next_state=DISPENSE;
	else if(coin25)next_state=DISPENSE;
end
COIN20:begin
	if(select && total_amount>=PRODUCT_PRICE) 
	next_state=DISPENSE;
	else if(coin5) next_state=DISPENSE;
	else if(coin10)next_state=DISPENSE;
	else if(coin25)next_state=DISPENSE;
end
DISPENSE:begin
	next_state=IDLE;
end
default:begin
	next_state=IDLE;
end
endcase
end

//output logic block
always@(*) begin
dispense=1'b0;
change=5'd0;
if(current_state==DISPENSE)begin
dispense=1'b1;
change=total_amount-PRODUCT_PRICE;
end
end
endmodule
