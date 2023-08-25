`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 07:26:07 PM
// Design Name: 
// Module Name: FullAdder
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


module FullAdder( 
input a_i,
input b_i,
input cin_i,
output reg sum_o,
output cout_o);

//reg sum_reg;
reg cout_reg;

always @(*) begin
    sum_o = a_i ^ b_i ^ cin_i;
    cout_reg = (a_i & b_i) | (b_i & cin_i) | (a_i & cin_i);
end
assign cout_o = cout_reg;
endmodule
