`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:29 11/19/2019 
// Design Name: 
// Module Name:    WB 
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
module WB(
    input [31:0] Instr_W_in,
    input [31:0] ALUout_W_in,
    //input [31:0] DM_W_in,
    input [31:0] PC4_W_in,
    input [31:0] PC8_W_in,
    input [4:0] A3_W_in,
    output RegWrite_W,
    output [31:0] PC4_W_out,
    output [31:0] WD_W,
    output [4:0] A3_W,
	 output eret_w
    );

	assign PC4_W_out = PC4_W_in;
	assign A3_W = A3_W_in;
	assign WD_W = ALUout_W_in;

	wire [2:0] MemToReg;
	ctrl controller_WB (.Instr(Instr_W_in), .RegWrite(RegWrite_W), .eret(eret_w));
	
endmodule
