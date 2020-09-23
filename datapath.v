`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:38 11/12/2019 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
    input clk,
    input reset,
    input [2:0] RegDst,
    input [2:0] NPCop,
    input [2:0] MemToReg,
    input RegWrite,
    input MemWrite,
    input [2:0] ALUSrc,
    input [1:0] Extop,
    input [1:0] ALUop,
	 output [5:0] OPCODE,
	 output [5:0] FUNC
    );

	wire [31:0] NPC, PCwire, Extout, result, DMRD, Adder, RD1, RD2, ALUB, WD;
	wire [5:0] opcode, Func;
   wire [4:0] rs, rt, rd, WA;
   wire [15:0] imm_16;
   wire [25:0] imm_26;
	wire Zero;
	
	assign OPCODE = opcode;
	assign FUNC = Func;
	
	PC pc (NPC, clk, reset, PCwire);
	IM im (PCwire[11:2], opcode, Func, rs, rt, rd, imm_16, imm_26);
	MUX_4_5bits MuxToWA (RegDst, rd, rt, 5'd31, 5'bzzzzz, WA);
	Extender extender (imm_16, Extop, Extout);
	MUX_4_32bits MuxToWD (MemToReg, result, DMRD, Adder, 5'bzzzzz, WD);
	GRF grf (clk, reset, PCwire, RegWrite, rs, rt, WA, WD, RD1, RD2);
	MUX_4_32bits MuxToAluB (ALUSrc, RD2, Extout, 5'bzzzzz, 5'bzzzzz, ALUB);
	ALU alu (RD1, ALUB, ALUop, result, Zero);
	NextPC nextpc (PCwire, imm_16, imm_26, NPCop, RD1, Zero, Adder, NPC);
	DM dm (clk, reset, MemWrite, PCwire, result, RD2, DMRD);
	
endmodule
