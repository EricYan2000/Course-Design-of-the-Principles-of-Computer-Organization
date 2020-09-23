`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:27:54 11/19/2019 
// Design Name: 
// Module Name:    MEM 
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
module MEM(
	 input clk,
    input reset,
    input [31:0] Instr_M_in,
    input [31:0] ALUout_M,
    input [31:0] RT_M_in,
    input [4:0] A3_M_in,
    input [31:0] PC4_M_in,
    input [31:0] PC8_M_in,
    input [31:0] WD_W,
	 input [2:0] ForwardRTM,
    output [31:0] Instr_M_out,
    output [31:0] DM_M_out,
    output [31:0] ALUout_M_out,
    output [4:0] A3_M_out,
    output [31:0] PC4_M_out,
    output [31:0] PC8_M_out
    );

	assign Instr_M_out = Instr_M_in;
	assign ALUout_M_out = ALUout_M;
	assign A3_M_out = A3_M_in;
	assign PC4_M_out = PC4_M_in;
	assign PC8_M_out = PC8_M_in;
	
	//Forward
	wire [31:0] DMWD;
	MUX_4_32bits MFRTM (.MUXop(ForwardRTM), .in0(RT_M_in), .in1(WD_W), .out(DMWD));
	
	//ctrl
	wire MemWrite;
	ctrl controller_MEM (.Instr(Instr_M_in), .MemWrite(MemWrite));
	
	//DM
	DM dm (.clk(clk), .reset(reset), .PC4(PC4_M_in), .A(ALUout_M), .MemWrite(MemWrite), .WD(DMWD), .RD(DM_M_out));

endmodule
