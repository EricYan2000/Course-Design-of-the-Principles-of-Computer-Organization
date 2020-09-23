`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:40 11/11/2019 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input clk,
    input reset,
    input [31:0] PC,
    input RegWrite,
    input [4:0] RA1,
    input [4:0] RA2,
    input [4:0] WA,
    input [31:0] WD,
    output [31:0] RD1,
    output [31:0] RD2
    );

	reg [31:0] register [31:0];
	integer i;
	assign RD1 = register[RA1];
	assign RD2 = register[RA2];
	
	initial
	begin
		for (i=0;i<32;i=i+1)
			register[i] = 32'h 0000_0000;
	end
	
	always @(posedge clk)
	begin
		if (reset)
			for (i=0;i<32;i=i+1)
				register[i] = 32'h 0000_0000;
		else 
			if (RegWrite && (WA != 5'b00000))
			begin
				register[WA] <= WD;
				$display("@%h: $%d <= %h", PC, WA, WD);
			end
	end
endmodule
