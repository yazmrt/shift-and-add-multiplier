`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 07:26:22 PM
// Design Name: 
// Module Name: serialAdder
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


module serialAdder
#(parameter DATA_WIDTH = 8)
( 
input clk,
input reset,
input [DATA_WIDTH-1:0] a_i,
input [DATA_WIDTH-1:0] b_i,
input start_i, // starts the addition process
output reg [DATA_WIDTH-1:0] sum_reg,
output reg flag_o, // indicates that addition is done
output reg carry_o
);

reg shift_reg; //signal for shifting registers
reg load_reg; //loading data to registers
wire [DATA_WIDTH-1:0] rega_o, regb_o; //shift register outputs

wire regc_o;
wire and_o, dff_in, dff_out;

localparam idle = 3'b001;
localparam load = 3'b010;
localparam shift = 3'b100;

reg [DATA_WIDTH:0] counter;
reg [2:0] state;

// module instantiations
shift_reg #(DATA_WIDTH) A(clk, reset, shift_reg, load_reg, a_i, 1'b0, rega_o);
shift_reg #(DATA_WIDTH) B(clk, reset, shift_reg, load_reg, b_i, 1'b0, regb_o);

FullAdder fa(rega_o[0], regb_o[0], dff_out, regc_o, dff_in);

dff D(and_o, reset, dff_in, dff_out);

and_gate AND(shift_i, clk, and_o);

always @(posedge clk) begin
if (reset == 0)  begin
    counter <= 0;
    shift_reg <= 0;
    load_reg <= 0;
    sum_reg <= 0;
    flag_o <= 0;
    carry_o <= 0;
    state <= idle;
end
else begin
case (state)
idle: begin
    load_reg <= 0;
    shift_reg <= 0;
    sum_reg <= 0;
    flag_o <= 0;
    if (start_i) begin
	counter <= DATA_WIDTH+1;
	flag_o <= 0;
	state <= load;
    end
    else 
	state <= idle;
end

load: begin
    load_reg <= 1;
    shift_reg <= 0;
    state <= shift;
end

shift: begin
    if (counter != 0) begin
    	load_reg <= 0;
    	shift_reg <= 1;
    	counter <= counter -1;
    	sum_reg <= {regc_o, sum_reg[DATA_WIDTH-1:1]};
	carry_o <= dff_in;
	state <= shift;
    end
    else begin
	counter <= 0;
	load_reg <= 0;
	shift_reg <= 0;
	flag_o <= 1;
	state <= idle;
    end
end
default: state <= idle; 
endcase
end
end
endmodule
