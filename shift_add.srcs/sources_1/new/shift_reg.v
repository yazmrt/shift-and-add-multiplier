`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 07:24:58 PM
// Design Name: 
// Module Name: shift_reg
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


module shift_reg
#(parameter N = 8)
( 
input clk,
input reset,
input shift_i,
input load_i,
input [N-1:0] data_i,
input shiftin_i,
output [N-1:0] data_o
);

reg [N-1:0] reg_o;

always @(posedge clk) begin
    if (!reset) 
        reg_o <= 0;
        
    else if (load_i)
        reg_o <= data_i;
        
    else if (shift_i) 
        reg_o <= {shiftin_i, reg_o[N-1:1]};
        
    else 
		reg_o <= reg_o;
		
end
assign data_o = reg_o;
endmodule
