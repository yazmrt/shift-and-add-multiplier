`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 07:25:37 PM
// Design Name: 
// Module Name: ShiftAdd_Top
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


module ShiftAdd_Top
#(parameter DATA_WIDTH = 8)
(
input clk,
input [DATA_WIDTH-1:0] Multiplicand, 
input [DATA_WIDTH-1:0] Multiplier,
output [2*DATA_WIDTH-1:0] Product, 
output halt //indicates product ready
);

wire [DATA_WIDTH-1:0] RegQ, RegB, Sum; // Q and B register and adder outputs
wire [DATA_WIDTH:0] RegA; // A register output
wire Cout, flag, shift, start, write; // Adder carry and controller outputs
reg [7:0] sum_reg = 0;

assign Product = {RegA[DATA_WIDTH-1:0],RegQ};

shift_reg #(DATA_WIDTH) B_Reg // Multiplicand register
(.clk(clk), .shift_i(1'b0), .load_i(load), .data_i(Multiplicand), .shiftin_i(1'b0), .data_o(RegB));

shift_reg #(DATA_WIDTH) Q_Reg // Multiplier register
(.clk(clk), .shift_i(shift), .load_i(load), .data_i(Multiplier), .shiftin_i(RegA[0]), .data_o(RegQ));

shift_reg #(DATA_WIDTH+1) A_Reg // Accumulator register
(.clk(clk), .shift_i(shift), .load_i(write), .data_i({Cout,sum_reg}), .shiftin_i(1'b0), .data_o(RegA));

serialAdder #(DATA_WIDTH) adder // Adder with one FA and shift
(.clk(clk), .a_i(RegA[DATA_WIDTH-1:0]), .b_i(RegB), .start_i(start), .sum_reg(Sum) , .flag_o(flag), .carry_o(Cout));

mult_control #(DATA_WIDTH) control //Control unit
(.clk(clk), .Q_0(RegQ[0]), .flag_i(flag), .start_o(start),.write_o(write), .shift_o(shift), .halt_o(halt), .load_o(load));


always @(posedge clk) begin 
sum_reg <= Sum;
end 

endmodule
