`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:35 11/11/2019 
// Design Name: 
// Module Name:    NextPC 
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
module NextPC(
    input [31:0] PC,
    input [15:0] imm_16,
    input [25:0] imm_26,
    input [2:0] NPCop,
    input [31:0] RD1,
    input Zero,
    output [31:0] Adder,
    output [31:0] NextPC
    );

	assign Adder = PC + 3'd4;
	assign NextPC = ( NPCop == 3'b000) 						 ? (PC + 3'd4) :  //no jump
						 ((NPCop == 3'b001)&&(Zero == 1'b1)) ? (PC + 3'd4 + {{14{imm_16[15]}}, imm_16, 2'b00}) : //beq_jump
						 ((NPCop == 3'b001)&&(Zero == 1'b0)) ? (PC + 3'd4) : //beq_no_jump
						 ( NPCop == 3'b010)						 ? {PC[31:28], imm_26, 2'b00} : //jal
						 ( NPCop == 3'b011) 						 ?  RD1 ://jr
						 32'bz;
endmodule
