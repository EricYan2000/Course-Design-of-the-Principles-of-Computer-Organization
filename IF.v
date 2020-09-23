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
    output [31:0] Instr,
    output [31:0] PC4,
    output [31:0] PC8
    );

	wire [31:0] PC, NPC_to_pc;
	assign PC4 = PC + 4;
	assign PC8 = PC + 8;
	
	MUX_2_32bits choose_npc (.MUXop(PCSrc), .in0(PC4), .in1(NPC), .out(NPC_to_pc));
	PC pc (.clk(clk), .reset(reset), .en(stall), .NPC(NPC_to_pc), .PC(PC));
	IM im (.PC(PC), .RD(Instr));
endmodule
