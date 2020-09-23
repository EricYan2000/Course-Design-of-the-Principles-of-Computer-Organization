`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:20:13 11/19/2019 
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
    input clk,
    input reset,
    input [31:0] NPC,
    output reg [31:0] PC,
    input en
    );

	initial
	begin
		PC = 32'h0000_3000;
	end

	always @(posedge clk)
	begin
		if (~en)
		begin
			if (reset)
				PC <= 32'h0000_3000;
			else
				PC <= NPC;
		end
	end
endmodule
