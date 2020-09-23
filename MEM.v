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
	 input [31:0] PrRD,
	 input [4:0] ExcCode_M,
	 input BD_M,
	 input [5:0] HWInt,
	 input eret_w,
	 
    output [31:0] Instr_M_out,
    output [31:0] ALUout_M_out,   //������Ҫд������ݺ�����ALUout_M_out��,������DM�����Ľ��
    output [4:0] A3_M_out,
    output [31:0] PC4_M_out,
    output [31:0] PC8_M_out,
	 output PrWE,
	 output [31:0] PrWD,
	 output [3:0] PrBE,
	 output [31:0] PrAddr,
	 output interrupt,
    output exception,
    output [31:0] EPC
    );

	wire [31:0] PC_M;
	wire error_m, DISABLE_m;
	assign error_m = (ExcCode_M != 0) ? 1'b1 : 1'b0;
	assign DISABLE_m = interrupt || exception || error_m;
	assign Instr_M_out = Instr_M_in;
	assign A3_M_out = A3_M_in;
	assign PC4_M_out = PC4_M_in;
	assign PC8_M_out = PC8_M_in;
	assign PC_M = PC4_M_in - 32'd4;
	
	
	wire [31:0] DMWD;
	MUX_4_32bits MFRTM (.MUXop(ForwardRTM), .in0(RT_M_in), .in1(WD_W), .out(DMWD));//Forward
	
	wire [2:0]  MemToReg, extop_2;
	wire MemWrite, cp0write;
	ctrl controller_MEM (.Instr(Instr_M_in), .MemWrite(MemWrite), .extop_2(extop_2), .MemToReg(MemToReg),
								.cp0write(cp0write));
	
	wire [3:0] BE;
	BE be (.instr(Instr_M_in), .ALUout(ALUout_M), .BE(BE));
	
	wire [31:0] DMRD;
	assign PrWE = (MemWrite && ~DISABLE_m);			
	DM dm (.clk(clk), .reset(reset), .PC4(PC4_M_in), .A(ALUout_M), .MemWrite(MemWrite && ~DISABLE_m), .WD(DMWD), 
				.BE(BE),	.RD(DMRD));
				
	wire [31:0] EXTRD;
	Ext_2 exteneder_2 (.DM(DMRD), .extop_2(extop_2), .BE(BE), .DMout(EXTRD));
	
	
	wire mtc0, mfc0;
	wire [4:0] RA, WA;
	wire [31:0] CP0_RD;
	assign mtc0 = (Instr_M_in[31:21] == 11'b01000000100) ? 1'b1 : 1'b0;
	assign mfc0 = (Instr_M_in[31:21] == 11'b01000000000) ? 1'b1 : 1'b0;
	assign RA = (mtc0||mfc0) ? Instr_M_in[15:11] : 5'b0;
	assign WA = (mtc0||mfc0) ? Instr_M_in[15:11] : 5'b0;
	CP0 CP0_reg (.clk(clk), .reset(reset), .cp0write(cp0write && ~DISABLE_m), .RA(RA), .WA(WA), .Din(DMWD), .PC(PC_M), 
				.ExcCode_in(ExcCode_M), .HWInt(HWInt), .BD_in(BD_M), .eret(eret_w), .interrupt(interrupt),
				.exception(exception), .EPC(EPC), .Dout(CP0_RD));
				
	memtoreg Memtoreg (.MUXop(MemToReg), .in0(ALUout_M), .in1(EXTRD), .in2(PrRD), .in3(CP0_RD), .out(ALUout_M_out));
	//MUX_4_32bits memtoreg_mux (.MUXop(MemToReg), .in0(ALUout_M), .in1(EXTRD), .out(ALUout_M_out));
	//all the writing data goes out at the ALUout_M_out
	
	assign PrAddr = ALUout_M;
	assign PrWD = DMWD;
	assign PrBE = BE;
	
endmodule
