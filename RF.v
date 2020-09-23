`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:12 11/18/2019 
// Design Name: 
// Module Name:    RF 
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
module RF(
    input clk,
    input reset,
    input RegWrite,
	 input [31:0] PC4_W,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] RD1,
    output [31:0] RD2
    );

	reg [31:0] register[31:0]; 
	wire [31:0] PC_W;
	assign PC_W = PC4_W - 4;    //the PC of the instruction in the WB phase
	assign RD1 = (RegWrite && (A1!=5'b00000) && (A1==A3)) ? WD : register[A1];
	assign RD2 = (RegWrite && (A2!=5'b00000) && (A2==A3)) ? WD : register[A2];

	integer i;
	initial
	begin
		for (i=0;i<32;i=i+1)
			register[i] = 32'h0000_0000;
	end
	
	always @(posedge clk)
	begin
		if (reset)
			for (i=0;i<32;i=i+1)
				register[i] = 32'h0000_0000;
		else
			if ((A3!=5'b00000)&&RegWrite)
			begin
				register[A3] <= WD;
				$display("%d@%h: $%d <= %h",$time,PC_W,A3,WD);
			end
	end
endmodule
