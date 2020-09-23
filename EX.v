`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:05 11/19/2019 
// Design Name: 
// Module Name:    EX 
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
module EX(
	 input clk,
	 input reset,
    input [31:0] Instr_E_in,
    input [31:0] RS_E_in,
    input [31:0] RT_E_in,
    input [31:0] PC4_E_in,
    input [31:0] PC8_E_in,
    input [4:0] A3_E_in,
    input [31:0] Ext_E_in,
    input [31:0] ALUout_M,  //实际上是dataout_M
    input [31:0] WD_W,
    input [2:0] ForwardRSE,
    input [2:0] ForwardRTE,
	 
	 output start,
	 output busy,
    output [31:0] Instr_E_out,
    output [31:0] ALUout_E,
    output [31:0] RT_E_out,
    output [4:0] A3_E_out,
    output [31:0] PC4_E_out,
    output [31:0] PC8_E_out
    );

	assign Instr_E_out = Instr_E_in;
	assign A3_E_out = A3_E_in;
	assign PC4_E_out = PC4_E_in;
	assign PC8_E_out = PC8_E_in;

	//Forward
	wire [31:0] RS_E, ALU_B;	//RS不用继续往后送了
	MUX_4_32bits MFRSE (.MUXop(ForwardRSE), .in0(RS_E_in), .in1(ALUout_M), .in2(WD_W), .out(RS_E));
	MUX_4_32bits MFRTE (.MUXop(ForwardRTE), .in0(RT_E_in), .in1(ALUout_M), .in2(WD_W), .out(RT_E_out));
	
	//ALUSrc
	wire [2:0] ALUSrc;
	MUX_4_32bits mux_alusrc (.MUXop(ALUSrc), .in0(RT_E_out), .in1(Ext_E_in), .out(ALU_B));
	
	//control
	wire [2:0] EXout_sel;
	wire [3:0] ALUop; 
	ctrl controller_EX (.Instr(Instr_E_in), .ALUSrc(ALUSrc), .ALUop(ALUop), .EXout_sel(EXout_sel));
	
	//ALU
	wire [31:0] ALUout, HI, LO;
	ALU alu (.A(RS_E), .B(ALU_B), .instr(Instr_E_in), .ALUop(ALUop), .result(ALUout));
	XALU xalu (.clk(clk), .A(RS_E), .B(ALU_B), .instr(Instr_E_in), .reset(reset), .start(start), .busy(busy),
					.HI(HI), .LO(LO));
	
	//EXout_sel
	MUX_4_32bits mux_exout (.MUXop(EXout_sel), .in0(ALUout), .in1(PC8_E_in), .in2(HI), .in3(LO), .out(ALUout_E));
endmodule
