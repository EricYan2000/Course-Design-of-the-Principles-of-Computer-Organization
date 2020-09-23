`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:32:34 11/12/2019 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );

	wire [5:0] opcode;
	wire [5:0] Func;
	wire [2:0] RegDst;
	wire [2:0] NPCop;
	wire [2:0] MemToReg;
   wire RegWrite;
   wire MemWrite;
   wire [2:0] ALUSrc;
   wire [1:0] Extop;
   wire [1:0] ALUop;

	datapath my_path(clk, reset, RegDst, NPCop, MemToReg, RegWrite, MemWrite, ALUSrc, Extop, ALUop, opcode, Func);
	ctrl controller(opcode, Func, RegDst, NPCop, MemToReg, RegWrite, MemWrite, ALUSrc, Extop, ALUop);

endmodule
