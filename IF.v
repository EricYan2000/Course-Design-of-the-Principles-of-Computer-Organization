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
	 input [31:0] Instr_of_D,
    input interrupt,
    input exception,
    input eret_d,
    input [31:0] EPC,
     
    output [31:0] Instr_F_out,  	//Instr,
    output [31:0] PC4_F_out,		//PC4
    output [31:0] PC8_F_out,		//PC8
	 output BD, 
	 output [4:0] ExcCode
    );

	wire [31:0] PC, NPC_to_pc, modified_PC, exception_handler, Instr_F_pre;
	assign exception_handler = 32'h0000_4180;
	assign PC4_F_out = PC + 4;
	assign PC8_F_out = PC + 8;
	
	MUX_2_32bits choose_npc (.MUXop(PCSrc), .in0(PC4_F_out), .in1(NPC), .out(NPC_to_pc));
	PC_modifier modifier (.original(NPC_to_pc), .exception_handler(exception_handler), .EPC(EPC),
                            .interrupt(interrupt), .exception(exception), .eret_d(eret_d), .to_PC(modified_PC));
	PC pc (.clk(clk), .reset(reset), .en(stall && ~interrupt && ~exception), .NPC(modified_PC), .PC(PC));
	IM im (.PC(PC), .RD(Instr_F_pre));
	insert_nop Insert (.eret_d(eret_d), .instr_in(Instr_F_pre), .instr_out(Instr_F_out));
	
	//send_EPC_to_PC4 send_EPC (.eret_d(eret_d), .PC(PC), .EPC(EPC), .PC4_out(PC4_F_out));
	
   wire ADEL;
   addr_error_E addr_error (.PC(PC), .ExcCode(ExcCode));
	set_BD set_bd (.Instr_D(Instr_of_D), .BD(BD));
    
endmodule
