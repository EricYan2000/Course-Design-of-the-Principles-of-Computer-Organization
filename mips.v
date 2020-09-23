`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:30 11/19/2019 
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

	//wires around IF
	wire PCSrc_D, stall;
	wire [31:0] NPC_D, Instr_F_out, PC4_F_out, PC8_F_out;
	//wires around ID
	wire [4:0] A3_D, A3_W;
	wire [31:0] Instr_D_in, PC4_D_in, PC8_D_in, Instr_D_out, RS_D_out, RT_D_out, PC4_D_out, PC8_D_out, Ext_D;
	wire [31:0] PC4_W, WD_W, PC8_E_in, ALUout_M, PC8_M_in;
	wire [2:0] ForwardRSD, ForwardRTD;
	wire RegWrite_W;
	//wires around EX   PC8_E_in, ALUout_M
	wire [4:0] A3_E_in, A3_E_out;
	wire [31:0] Instr_E_in, PC4_E_in, RS_E_in, RT_E_in, Ext_E_in;
	wire [31:0] Instr_E_out, ALUout_E, RT_E_out, PC4_E_out, PC8_E_out;
	wire [2:0] ForwardRSE, ForwardRTE;
	//wires around MEM   ALUout_M, PC8_M_in
	wire [4:0] A3_M_in, A3_M_out;
	wire [31:0] Instr_M_in, RT_M_in, PC4_M_in;
	wire [31:0] Instr_M_out, DM_M_out, ALUout_M_out, PC4_M_out, PC8_M_out;
	wire [2:0] ForwardRTM;
	//wires arounf WB   A3_W,  WD_W,   RegWrite_W
	wire [4:0] A3_W_in;
	wire [31:0] Instr_W_in, ALUout_W_in, DM_W_in, PC4_W_in, PC8_W_in;
	
	IF IF_module (.clk(clk), .reset(reset), .PCSrc(PCSrc_D), .NPC(NPC_D), .stall(stall), .Instr(Instr_F_out), 
						.PC4(PC4_F_out), .PC8(PC8_F_out));
						
	FDreg FDREG (.clk(clk), .reset(reset), .stall(stall), .Instr_in(Instr_F_out), .PC4_in(PC4_F_out), 
						.PC8_in(PC8_F_out), .Instr_out(Instr_D_in), .PC4_out(PC4_D_in), .PC8_out(PC8_D_in));
						
	ID ID_module (.clk(clk), .reset(reset), .Instr_D_in(Instr_D_in), .PC4_D_in(PC4_D_in), .PC8_D_in(PC8_D_in),
						.A3_W(A3_W), .WD_W(WD_W), .PC4_W(PC4_W),.RegWrite_W(RegWrite_W), .PC8_E_in(PC8_E_in), .ALUout_M(ALUout_M),
						.PC8_M_in(PC8_M_in), .ForwardRSD(ForwardRSD), .ForwardRTD(ForwardRTD), .PCSrc(PCSrc_D), 
						.NPC_D(NPC_D), .Instr_D_out(Instr_D_out), .PC4_D_out(PC4_D_out), .PC8_D_out(PC8_D_out), 
						.RS_D_out(RS_D_out), .RT_D_out(RT_D_out), .A3_D(A3_D), .Ext_D(Ext_D));
						
	DEreg DEREG (.clk(clk), .reset(reset), .stall(stall), .Instr_in(Instr_D_out), .PC4_in(PC4_D_out), 
						.PC8_in(PC8_D_out), .RS_in(RS_D_out), .RT_in(RT_D_out), .Ext_in(Ext_D), .A3_in(A3_D),
						.Instr_out(Instr_E_in), .PC4_out(PC4_E_in), .PC8_out(PC8_E_in), 
						.RS_out(RS_E_in), .RT_out(RT_E_in), .Ext_out(Ext_E_in), .A3_out(A3_E_in));
						
	EX EX_module (.Instr_E_in(Instr_E_in), .RS_E_in(RS_E_in), .RT_E_in(RT_E_in), .PC4_E_in(PC4_E_in), 
						.PC8_E_in(PC8_E_in), .A3_E_in(A3_E_in), .Ext_E_in(Ext_E_in), .ALUout_M(ALUout_M), 
						.PC8_M_in(PC8_M_in), .WD_W(WD_W), .ForwardRSE(ForwardRSE), .ForwardRTE(ForwardRTE),
						.Instr_E_out(Instr_E_out), .ALUout_E(ALUout_E), .RT_E_out(RT_E_out), .A3_E_out(A3_E_out),
						.PC4_E_out(PC4_E_out), .PC8_E_out(PC8_E_out));
						
	EMreg EMREG (.clk(clk), .reset(reset), .Instr_E_out(Instr_E_out), .ALUout_E(ALUout_E), .RT_E_out(RT_E_out),
						.A3_E_out(A3_E_out), .PC4_E_out(PC4_E_out), .PC8_E_out(PC8_E_out), .Instr_M_in(Instr_M_in), .ALUout_M(ALUout_M), 
						.RT_M_in(RT_M_in), .A3_M_in(A3_M_in), .PC4_M_in(PC4_M_in), .PC8_M_in(PC8_M_in));
						
	MEM MEM_module (.clk(clk), .reset(reset), .Instr_M_in(Instr_M_in), .ALUout_M(ALUout_M), .RT_M_in(RT_M_in),
						.A3_M_in(A3_M_in), .PC4_M_in(PC4_M_in), .PC8_M_in(PC8_M_in), .WD_W(WD_W), .ForwardRTM(ForwardRTM),
						.Instr_M_out(Instr_M_out), .DM_M_out(DM_M_out), .ALUout_M_out(ALUout_M_out), .A3_M_out(A3_M_out),
						.PC4_M_out(PC4_M_out), .PC8_M_out(PC8_M_out));
						
	MWreg MWREG (.clk(clk), .reset(reset), .Instr_M_out(Instr_M_out), .ALUout_M_out(ALUout_M_out), .DM_M_out(DM_M_out),
						.PC4_M_out(PC4_M_out), .PC8_M_out(PC8_M_out), .A3_M_out(A3_M_out),
						.Instr_W_in(Instr_W_in), .ALUout_W_in(ALUout_W_in), .DM_W_in(DM_W_in), .PC4_W_in(PC4_W_in),
						.PC8_W_in(PC8_W_in), .A3_W_in(A3_W_in));
						
	WB WB_module (.Instr_W_in(Instr_W_in), .ALUout_W_in(ALUout_W_in), .DM_W_in(DM_W_in), .PC4_W_in(PC4_W_in),
						.PC8_W_in(PC8_W_in), .A3_W_in(A3_W_in), .RegWrite_W(RegWrite_W), .PC4_W_out(PC4_W),
						.WD_W(WD_W), .A3_W(A3_W));
						
	hazard FUCKYOU (.Instr_D_in(Instr_D_in), .Instr_E_in(Instr_E_in), .Instr_M_in(Instr_M_in), .Instr_W_in(Instr_W_in),
						.A3_E_in(A3_E_in), .A3_M_in(A3_M_in), .A3_W(A3_W), .ForwardRSD(ForwardRSD), 
						.ForwardRTD(ForwardRTD), .ForwardRSE(ForwardRSE), .ForwardRTE(ForwardRTE),
						.ForwardRTM(ForwardRTM), .stall(stall));
endmodule

