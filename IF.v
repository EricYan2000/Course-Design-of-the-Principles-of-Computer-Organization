`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:18:49 11/19/2019 
// Design Name: 
// Module Name:    IF 
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
module IF(
    input clk,
    input reset,
    input PCSrc,
    input [31:0] NPC,
    input stall,
    output [31:0] Instr_F_out,  	//Instr,
    output [31:0] PC4_F_out,		//PC4
    output [31:0] PC8_F_out		//PC8
    );

	wire [31:0] PC, NPC_to_pc;
	assign PC4_F_out = PC + 4;
	assign PC8_F_out = PC + 8;
	
	MUX_2_32bits choose_npc (.MUXop(PCSrc), .in0(PC4_F_out), .in1(NPC), .out(NPC_to_pc));
	PC pc (.clk(clk), .reset(reset), .en(stall), .NPC(NPC_to_pc), .PC(PC));
	IM im (.PC(PC), .RD(Instr_F_out));
endmodule
