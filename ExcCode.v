`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:47:07 12/17/2019 
// Design Name: 
// Module Name:    ExcCode 
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
module ExcCode(
    input clk,
    input reset,
	 input stall,
    input [4:0] ExcCode_in,
    output reg [4:0] ExcCode_out
    );

	initial 
	begin
		ExcCode_out = 0;
	end

	always @(posedge clk)
	begin
		if (reset)
			ExcCode_out = 0;
		else
			if (~stall)
				ExcCode_out = ExcCode_in;
	end
endmodule
