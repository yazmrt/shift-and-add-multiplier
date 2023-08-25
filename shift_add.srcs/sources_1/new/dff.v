`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 07:25:54 PM
// Design Name: 
// Module Name: dff
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


module dff( 
input clk,
input reset,
input data_i,
output data_o);

reg reg_o;

always @(posedge clk) begin 
    if (!reset) 
        reg_o <= 0;
    else
        reg_o <= data_i;
end

assign data_o = reg_o;
endmodule