`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:59:33 12/17/2019 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
    input clk,
    input reset,
	 input [31:0] PrRD,
	 input [5:0] HWInt,
	 output PrWE,
	 output [3:0] PrBE,
	 output [31:0] PrAddr,
	 output [31:0] PrWD,
	 output [31:0] addr
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
	wire start, start_D_out, busy, M_in_D, stall_regular, stall_m;
	wire BD_f_out, BD_d_in, BD_d_out, BD_e_in, BD_e_out, BD_m_in;
	wire [4:0] ExcCode_f_out, ExcCode_d_in, ExcCode_d_out, ExcCode_e_in, ExcCode_e_out, ExcCode_m_in;
	wire [4:0] judger_out;
	wire unknown, need_stall, error_d, error_e, error, interrupt, exception, DISABLE_e, eret_d, flush, eret_w;
	wire [31:0] PC_M, EPC;
	
	assign PC_M = PC4_M_in - 4;
	assign stall_m = ((need_stall||busy) && M_in_D);
	assign stall = stall_m || stall_regular;
	assign addr = {PC_M[31:2], 2'b00};
	assign error = error_e;				// || error_d;
	assign DISABLE_e = interrupt || exception;		//error_e || 
	assign flush = interrupt || exception;
	assign BD_d_out = BD_d_in;
	assign BD_e_out = BD_e_in;
	
	//F level   
	IF IF_module (.clk(clk), .reset(reset), .PCSrc(PCSrc_D), .NPC(NPC_D), .stall(stall), .Instr_F_out(Instr_F_out), 
						.PC4_F_out(PC4_F_out), .PC8_F_out(PC8_F_out), .ExcCode(ExcCode_f_out),
						.Instr_of_D(Instr_D_in), .BD(BD_f_out), .interrupt(interrupt), .exception(exception),
						.eret_d(eret_d), .EPC(EPC));
						
	FDreg FDREG (.clk(clk), .reset(reset||flush), .stall(stall), .Instr_from_F(Instr_F_out), .PC4_in(PC4_F_out), 
						.PC8_in(PC8_F_out), .Instr_to_D(Instr_D_in), .PC4_out(PC4_D_in), .PC8_out(PC8_D_in));
	BDreg BD_D (.clk(clk), .reset(reset||flush), .stall(stall), .BD_in(BD_f_out), .BD_out(BD_d_in));
	ExcCode Exc_D (.clk(clk), .reset(reset||flush), .stall(stall), .ExcCode_in(ExcCode_f_out), 
						.ExcCode_out(ExcCode_d_in));
	
	//D level
	ID ID_module (.clk(clk), .reset(reset), .Instr_D_in(Instr_D_in), .PC4_D_in(PC4_D_in), .PC8_D_in(PC8_D_in),
						.A3_W(A3_W), .WD_W(WD_W), .PC4_W(PC4_W),.RegWrite_W(RegWrite_W), .PC8_E_in(PC8_E_in),
						.ALUout_M(ALUout_M), .ForwardRSD(ForwardRSD), .ForwardRTD(ForwardRTD), .PCSrc(PCSrc_D), 
						.NPC_D(NPC_D), .Instr_D_out(Instr_D_out), .PC4_D_out(PC4_D_out), .PC8_D_out(PC8_D_out), 
						.RS_D_out(RS_D_out), .RT_D_out(RT_D_out), .A3_D(A3_D), .Ext_D(Ext_D), .M_in_D(M_in_D), 
						.Instr_W(Instr_W_in), .unknown(unknown), .eret_d(eret_d));
	
	choose_ExcE choose_exc_E (.unknown(unknown), .ExcCode_in(ExcCode_d_in), .ExcCode_out(ExcCode_d_out), 
										.error(error_d));
	DEreg DEREG (.clk(clk), .reset(reset||flush), .stall(stall), .Instr_in(Instr_D_out), .PC4_in(PC4_D_out), 
						.PC8_in(PC8_D_out), .RS_in(RS_D_out), .RT_in(RT_D_out), .Ext_in(Ext_D), .A3_in(A3_D),
						.Instr_out(Instr_E_in), .PC4_out(PC4_E_in), .PC8_out(PC8_E_in), .RS_out(RS_E_in), .RT_out(RT_E_in), .Ext_out(Ext_E_in), 
						.A3_out(A3_E_in));
	BDreg BD_E (.clk(clk), .reset(reset||flush), .stall(1'b0), .BD_in(BD_d_out), .BD_out(BD_e_in));
	ExcCode Exc_E (.clk(clk), .reset(reset||flush), .stall(1'b0), .ExcCode_in(ExcCode_d_out), .ExcCode_out(ExcCode_e_in));
		
	//E level
	EX EX_module (.Instr_E_in(Instr_E_in), .RS_E_in(RS_E_in), .RT_E_in(RT_E_in), .PC4_E_in(PC4_E_in), 
						.PC8_E_in(PC8_E_in), .A3_E_in(A3_E_in), .Ext_E_in(Ext_E_in), .ALUout_M(ALUout_M), 
						.WD_W(WD_W), .ForwardRSE(ForwardRSE), .ForwardRTE(ForwardRTE), .clk(clk), .reset(reset),
						.Instr_E_out(Instr_E_out), .ALUout_E(ALUout_E), .RT_E_out(RT_E_out), .A3_E_out(A3_E_out),
						.PC4_E_out(PC4_E_out), .PC8_E_out(PC8_E_out), .busy(busy), .need_stall(need_stall),
						.DISABLE(DISABLE_e), .judger_out(judger_out));
	
	choose_Exc_M choose_exc_m (.judger_out(judger_out), .Exc_E(ExcCode_e_in), .Exc_out(ExcCode_e_out),
										.error (error_e));
	BDreg BD_M (.clk(clk), .reset(reset||flush), .stall(1'b0), .BD_in(BD_e_out), .BD_out(BD_m_in));
	ExcCode Exc_M (.clk(clk), .reset(reset||flush), .stall(1'b0), .ExcCode_in(ExcCode_e_out), .ExcCode_out(ExcCode_m_in));
	EMreg EMREG (.clk(clk), .reset(reset||flush), .Instr_E_out(Instr_E_out), .ALUout_E(ALUout_E), .RT_E_out(RT_E_out),
						.A3_E_out(A3_E_out), .PC4_E_out(PC4_E_out), .PC8_E_out(PC8_E_out), .Instr_M_in(Instr_M_in), .ALUout_M(ALUout_M), 
						.RT_M_in(RT_M_in), .A3_M_in(A3_M_in), .PC4_M_in(PC4_M_in), .PC8_M_in(PC8_M_in));
		
	//M level
	MEM MEM_module (.clk(clk), .reset(reset), .Instr_M_in(Instr_M_in), .ALUout_M(ALUout_M), .RT_M_in(RT_M_in),
						.A3_M_in(A3_M_in), .PC4_M_in(PC4_M_in), .PC8_M_in(PC8_M_in), .WD_W(WD_W), .ForwardRTM(ForwardRTM),
						.Instr_M_out(Instr_M_out), .ALUout_M_out(ALUout_M_out), .A3_M_out(A3_M_out), .PrWE(PrWE),
						.PC4_M_out(PC4_M_out), .PC8_M_out(PC8_M_out), .PrRD(PrRD), .PrWD(PrWD), .PrAddr(PrAddr), 
						.PrBE(PrBE), .interrupt(interrupt), .exception(exception), .ExcCode_M(ExcCode_m_in), .EPC(EPC),
						.BD_M(BD_m_in), .HWInt(HWInt), .eret_w(eret_w));
						//
						
	MWreg MWREG (.clk(clk), .reset(reset||flush), .Instr_M_out(Instr_M_out), .ALUout_M_out(ALUout_M_out),
						.PC4_M_out(PC4_M_out), .PC8_M_out(PC8_M_out), .A3_M_out(A3_M_out),
						.Instr_W_in(Instr_W_in), .ALUout_W_in(ALUout_W_in), .PC4_W_in(PC4_W_in),
						.PC8_W_in(PC8_W_in), .A3_W_in(A3_W_in));
			
	//W level
	WB WB_module (.Instr_W_in(Instr_W_in), .ALUout_W_in(ALUout_W_in), .PC4_W_in(PC4_W_in),
						.PC8_W_in(PC8_W_in), .A3_W_in(A3_W_in), .RegWrite_W(RegWrite_W), .PC4_W_out(PC4_W),
						.WD_W(WD_W), .A3_W(A3_W), .eret_w(eret_w));
						
						
	hazard FUCKYOU (.Instr_D_in(Instr_D_in), .Instr_E_in(Instr_E_in), .Instr_M_in(Instr_M_in), .Instr_W_in(Instr_W_in),
						.A3_E(A3_E_in), .A3_M(A3_M_in), .A3_W(A3_W), .ForwardRSD(ForwardRSD), 
						.ForwardRTD(ForwardRTD), .ForwardRSE(ForwardRSE), .ForwardRTE(ForwardRTE),
						.ForwardRTM(ForwardRTM), .stall(stall_regular));

endmodule
