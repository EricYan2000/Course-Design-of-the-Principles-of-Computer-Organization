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
    //output [31:0] DM_M_out,
    output [31:0] ALUout_M_out,   //所有需要写入的数据合流到ALUout_M_out中,包括从DM出来的结果
    output [4:0] A3_M_out,
    output [31:0] PC4_M_out,
    output [31:0] PC8_M_out
    );

	assign Instr_M_out = Instr_M_in;
	assign A3_M_out = A3_M_in;
	assign PC4_M_out = PC4_M_in;
	assign PC8_M_out = PC8_M_in;
	
	
	wire [31:0] DMWD;
	MUX_4_32bits MFRTM (.MUXop(ForwardRTM), .in0(RT_M_in), .in1(WD_W), .out(DMWD));//Forward
	
	wire [2:0]  MemToReg, extop_2;
	wire MemWrite;
	ctrl controller_MEM (.Instr(Instr_M_in), .MemWrite(MemWrite), .extop_2(extop_2), .MemToReg(MemToReg));
	
	wire [3:0] BE;
	BE be (.instr(Instr_M_in), .ALUout(ALUout_M), .BE(BE));
	
	wire [31:0] DMRD;
	DM dm (.clk(clk), .reset(reset), .PC4(PC4_M_in), .A(ALUout_M), .MemWrite(MemWrite), .WD(DMWD), 
				.BE(BE),	.RD(DMRD));
				
	wire [31:0] EXTRD;
	Ext_2 exteneder_2 (.DM(DMRD), .extop_2(extop_2), .BE(BE), .DMout(EXTRD));
	
	MUX_4_32bits memtoreg_mux (.MUXop(MemToReg), .in0(ALUout_M), .in1(EXTRD), .out(ALUout_M_out));
	//all the writing data goes out at the ALUout_M_out
endmodule
