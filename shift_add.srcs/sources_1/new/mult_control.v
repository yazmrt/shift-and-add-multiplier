`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 07:25:14 PM
// Design Name: 
// Module Name: mult_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module mult_control #(parameter N = 8) 
(
input clk, 
input reset, 
input Q_0,
input flag_i,
output start_o, 
output write_o,
output shift_o,
output halt_o,
output load_o
);

reg [4:0] state;
reg start_reg;
reg write_reg;
reg shift_reg;
reg load_reg;
localparam IdleS=5'b00001, TestS=5'b00010, AddS=5'b00100, ShiftS=5'b01000, HaltS=5'b10000;

reg [N-1:0] Count; //iteration count
reg [1:0] start_count; //stops the count after 2 iteration
wire C_0; // C_0 = 1 if count < N

assign C_0 = (Count == N-1) ? 1 : 0; //detect Nth iteration


always @(posedge clk) begin
if (!reset) begin
	start_reg <= 0;
	write_reg <= 0;
	shift_reg <= 0; 
	load_reg <= 1;
	state <= IdleS; 
	Count <= 0;
end
else begin
case (state) 

IdleS: begin
    load_reg <= 0;
    start_reg <= 0;
	shift_reg <= 0; 
	write_reg <= 0;
	state <= TestS;
	start_count <= 2'b00;
	end
	
TestS: begin
	start_reg <= 0;
	shift_reg <= 0; 
	write_reg <= 0;
	if (Q_0) begin
	state <= AddS; 
	end
	else 
	state <= ShiftS;
end

AddS: begin
	write_reg <= 0;
	shift_reg <= 0; 
	if (start_count == 2'b10) begin
	   start_reg <= 0;
	   end
	else begin
	start_reg <= 1;
	start_count <= start_count + 2'b01;
	end
	if (flag_i) begin
	start_reg <= 0;
	write_reg <= 1;
	state <= ShiftS; 
	end
	else begin
	state <= AddS;
	end
end

ShiftS: begin
	Count <= Count + 1;
	shift_reg <= 1;
	write_reg <= 0;
	start_reg <= 0;
if (C_0) 
	state <= HaltS; // go to HaltS if Count = N
else begin
	state <= IdleS; // go to IdleS if Count < N
end
end

HaltS: begin
	write_reg <= 0;
	shift_reg <= 0; 
	start_reg <= 0;
	state <= HaltS; 
end
default: state <= IdleS;
endcase
end
end

assign load_o = load_reg;
assign start_o = start_reg; 
assign write_o = write_reg;
assign shift_o = shift_reg; 
assign halt_o = state[4];
endmodule
