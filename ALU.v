`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:26:09 11/19/2019 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [1:0] ALUop,
    output [31:0] result,
    output Zero
    );

	assign Zero = (A == B);
	assign result = (ALUop == 2'b00) ? (A + B) :
						 (ALUop == 2'b01) ? (A - B) :
						 (ALUop == 2'b10) ? (A | B) :
						 32'bz;

endmodule
