`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:43:14 11/19/2019 
// Design Name: 
// Module Name:    ID 
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
module ID(
    input clk,
    input reset,
    input [31:0] Instr_D_in,
    input [31:0] PC4_D_in,
    input [31:0] PC8_D_in,
    input [4:0] A3_W,
    input [31:0] WD_W,
    input [31:0] PC4_W,
    input RegWrite_W,
    input [31:0] PC8_E_in,
    input [31:0] ALUout_M,
    input [31:0] PC8_M_in,
    input [2:0] ForwardRSD,
    input [2:0] ForwardRTD,
    output PCSrc,
    output [31:0] NPC_D,
    output [31:0] Instr_D_out,
    output [31:0] PC4_D_out,
    output [31:0] PC8_D_out,
    output [31:0] RS_D_out,
    output [31:0] RT_D_out,
    output [4:0] A3_D,
    output [31:0] Ext_D
    );

	assign Instr_D_out = Instr_D_in;
	assign PC4_D_out = PC4_D_in;
	assign PC8_D_out = PC8_D_in;

	wire [4:0] rs, rt, rd;
	wire [15:0] imm_16;
	assign   rs   = Instr_D_in [25:21];
	assign   rt   = Instr_D_in [20:16];
	assign   rd   = Instr_D_in [15:11];
	assign imm_16 = Instr_D_in [15:0];
	
	//control
	wire [2:0] NPCop, RegDst;
	wire [1:0] Extop;
	wire Branch, Jump;
	ctrl controller_ID (.Instr(Instr_D_in), .NPCop(NPCop), .RegDst(RegDst), .Extop(Extop), .Branch(Branch), .Jump(Jump));
	
	//GRF
	wire [31:0] RD1, RD2;
	RF GRF (.clk(clk), .reset(reset), .RegWrite(RegWrite_W), .PC4_W(PC4_W), .A1(rs), .A2(rt), .A3(A3_W), .WD(WD_W), .RD1(RD1), .RD2(RD2));
	
	//MUX_of_forward
	MUX_4_32bits MFRSD (.MUXop(ForwardRSD), .in0(RD1), .in1(PC8_E_in), .in2(ALUout_M), .in3(PC8_M_in), .out(RS_D_out));
	MUX_4_32bits MFRTD (.MUXop(ForwardRTD), .in0(RD2), .in1(PC8_E_in), .in2(ALUout_M), .in3(PC8_M_in), .out(RT_D_out));
	
	//branching&jumping signals
	wire equal;
	cmp CMP (.A(RS_D_out), .B(RT_D_out), .equal(equal));
	assign PCSrc = (equal&&Branch)||Jump;
	
	//ext
	Extender Ext(.imm_16(imm_16), .Extop(Extop), .out(Ext_D));
	
	//regdst
	MUX_4_5bits regdst (.MUXop(RegDst), .in0(rd), .in1(rt), .in2(5'b11111), .out(A3_D));
	
	//NPC
	NextPC NPC (.PC4(PC4_D_in), .Instr(Instr_D_in), .NPCop(NPCop), .RS_D(RS_D_out), .NextPC(NPC_D));

endmodule
