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
    input [31:0] Instr_E_in,
    input [31:0] RS_E_in,
    input [31:0] RT_E_in,
    input [31:0] PC4_E_in,
    input [31:0] PC8_E_in,
    input [4:0] A3_E_in,
    input [31:0] Ext_E_in,
    input [31:0] ALUout_M,
    input [31:0] PC8_M_in,
    input [31:0] WD_W,
    input [2:0] ForwardRSE,
    input [2:0] ForwardRTE,
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
	wire [31:0] RS_E, ALU_B;
	MUX_4_32bits MFRSE (.MUXop(ForwardRSE), .in0(RS_E_in), .in1(ALUout_M), .in2(PC8_M_in), .in3(WD_W), .out(RS_E));
	MUX_4_32bits MFRTE (.MUXop(ForwardRTE), .in0(RT_E_in), .in1(ALUout_M), .in2(PC8_M_in), .in3(WD_W), .out(RT_E_out));
	
	//ALUSrc
	wire [2:0] ALUSrc;
	MUX_4_32bits mux_alusrc (.MUXop(ALUSrc), .in0(RT_E_out), .in1(Ext_E_in), .out(ALU_B));
	
	//control
	wire [1:0] ALUop; 
	ctrl controller_EX (.Instr(Instr_E_in), .ALUSrc(ALUSrc), .ALUop(ALUop));
	
	//ALU
	ALU alu (.A(RS_E), .B(ALU_B), .ALUop(ALUop), .result(ALUout_E));
	
endmodule
