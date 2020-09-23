`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:28 12/20/2019 
// Design Name: 
// Module Name:    BDreg 
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
module BDreg(
    input clk,
    input reset,
    input stall,
    input BD_in,
    output reg BD_out
    );

	initial 
	begin
		BD_out = 0;
	end
		
	always @(posedge clk)
	begin
		if (reset)
			BD_out = 0;
		else
		begin
			if (~stall)
				BD_out = BD_in;
		end
	end
	
endmodule
