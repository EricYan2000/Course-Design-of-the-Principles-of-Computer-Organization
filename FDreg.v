`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:45:45 11/19/2019 
// Design Name: 
// Module Name:    FDreg 
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
module FDreg(
	 input clk,
    input reset,
    input stall,
    input [31:0] Instr_in,
    input [31:0] PC4_in,
    input [31:0] PC8_in,
    output reg [31:0] Instr_out,
    output reg [31:0] PC4_out,
    output reg [31:0] PC8_out
    );
	 
	initial
	begin
		Instr_out = 32'h0000_0000;
		PC4_out = 32'h0000_0000;
		PC8_out = 32'h0000_0000;
	end
	
	always @(posedge clk)
	begin
		if (~stall)
		begin
			if (reset)
			begin
				Instr_out <= 32'h0000_0000;
				PC4_out <= 32'h0000_0000;
				PC8_out <= 32'h0000_0000;
			end
			else
			begin
				Instr_out <= Instr_in;
				PC4_out <= PC4_in;
				PC8_out <= PC8_in;
			end
		end
	end
endmodule
