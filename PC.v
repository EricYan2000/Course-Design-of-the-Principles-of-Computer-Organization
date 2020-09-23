`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:13:14 11/11/2019 
// Design Name: 
// Module Name:    PC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PC(
    input [31:0] NextPC,
    input clk,
    input reset,
    output reg [31:0] PC
    );

	initial 
	begin
		PC = 32'h0000_3000;
	end
	
	always @(posedge clk)
	begin
		if (reset)
			PC <= 32'h0000_3000;
		else
			PC <= NextPC;
	end
endmodule
