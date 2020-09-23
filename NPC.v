`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:04:35 11/19/2019 
// Design Name: 
// Module Name:    NPC 
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
    input [31:0] PC4,
    input [31:0] Instr,
    input [2:0] NPCop,
	 input [31:0] RS_D, 
    output [31:0] Adder,
    output [31:0] NextPC
    );

	wire [15:0] imm_16;
	wire [25:0] imm_26;
	wire [31:0] PC;
	assign imm_16 = Instr[15:0];
	assign imm_26 = Instr[25:0];
	assign PC = PC4 - 4;
	//assign Adder = PC + 3'd4;   caution
	assign NextPC = ( NPCop == 3'b000 ) 						 ? (PC + 3'd4) :  //no jump
						 ( NPCop == 3'b001 )   ?   (PC + 3'd4 + {{14{imm_16[15]}}, imm_16, 2'b00}) : //beq_jump
						 ( NPCop == 3'b010 )						 ? {PC[31:28], imm_26, 2'b00} : //jal
						 ( NPCop == 3'b011 ) 						 ?  RS_D  :   //jr
						 ( NPCop == 3'b100 )   ?    {{PC[31:28]}, imm_26, {2'b00}}   :    //j
						 32'bz;
endmodule
