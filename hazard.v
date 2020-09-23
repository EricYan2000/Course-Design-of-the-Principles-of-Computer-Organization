`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:11:27 11/20/2019 
// Design Name: 
// Module Name:    hazard 
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
module hazard(
    input [31:0] Instr_D_in,
    input [31:0] Instr_E_in,
    input [31:0] Instr_M_in,
	 input [31:0] Instr_W_in,
    input [4:0] A3_E,
    input [4:0] A3_M,
    input [4:0] A3_W,
    output [2:0] ForwardRSD,
    output [2:0] ForwardRTD,
    output [2:0] ForwardRSE,
    output [2:0] ForwardRTE,
    output [2:0] ForwardRTM,
    output stall
    );

	//`define rs 25:21
	//`define rt 20:16
	//`define rd 15:11

	wire [2:0] tnew_D, tnew_D_pre, tnew_E, tnew_E_pre, tnew_M, tnew_M_pre, tnew_W, tnew_W_pre;
	wire [4:0] rsnum_D, rsnum_E, rsnum_M, rsnum_W;
	wire [4:0] rtnum_D, rtnum_E, rtnum_M, rtnum_W;
	wire [2:0] tuse_rs_D, tuse_rt_D;
	wire eret_d, mtc0_e, mtc0_m;
	
	ctrl controller_D (.Instr(Instr_D_in), .tnew(tnew_D_pre), .rsnum(rsnum_D), .rtnum(rtnum_D),
							.tuse_rs(tuse_rs_D), .tuse_rt(tuse_rt_D), .eret(eret_d));
	ctrl controller_E (.Instr(Instr_E_in), .tnew(tnew_E_pre), .rsnum(rsnum_E), .rtnum(rtnum_E), .mtc0(mtc0_e));
	ctrl controller_M (.Instr(Instr_M_in), .tnew(tnew_M_pre), .rsnum(rsnum_M), .rtnum(rtnum_M), .mtc0(mtc0_m));
	ctrl controller_W (.Instr(Instr_W_in), .tnew(tnew_W_pre), .rsnum(rsnum_W), .rtnum(rtnum_W));
						
	//The tnew decreases every level
	//assign tnew_D = tnew_D_pre;
	assign tnew_E = tnew_E_pre;
	assign tnew_M = (tnew_M_pre <= 3'd1) ? 3'b0 : (tnew_M_pre - 3'd1);
	assign tnew_W = (tnew_W_pre <= 3'd2) ? 3'b0 : (tnew_W_pre - 3'd2);
	
	//stalls
	wire stall_D_E, stall_D_M, stall_D_E_eret, stall_D_M_eret;
	assign stall_D_E = ((A3_E != 5'b0) && (A3_E == rsnum_D) && (tnew_E > tuse_rs_D)) ||
							 ((A3_E != 5'b0) && (A3_E == rtnum_D) && (tnew_E > tuse_rt_D));
	assign stall_D_M = ((A3_M != 5'b0) && (A3_M == rsnum_D) && (tnew_M > tuse_rs_D)) ||
							 ((A3_M != 5'b0) && (A3_M == rtnum_D) && (tnew_M > tuse_rt_D));
	assign stall_D_E_eret = (eret_d && mtc0_e);
	assign stall_D_M_eret = (eret_d && mtc0_m);
	assign stall = (stall_D_E || stall_D_M || stall_D_E_eret || stall_D_M_eret) ? 1'b1 : 1'b0;
	
	
	//?????????RegWrite??ID??RegWrite=0??A3???0
	assign ForwardRSD = ((A3_E!=5'b0)&&(A3_E==rsnum_D)&&(tnew_E==3'b0)) ? 3'b001 : 
							  ((A3_M!=5'b0)&&(A3_M==rsnum_D)&&(tnew_M==3'b0)) ? 3'b010 :
							  3'b000;
	assign ForwardRTD = ((A3_E!=5'b0)&&(A3_E==rtnum_D)&&(tnew_E==3'b0)) ? 3'b001 : 
							  ((A3_M!=5'b0)&&(A3_M==rtnum_D)&&(tnew_M==3'b0)) ? 3'b010 :
							  3'b000;
	assign ForwardRSE = ((A3_M!=5'b0)&&(A3_M==rsnum_E)&&(tnew_M==3'b0)) ? 3'b001 : 
							  ((A3_W!=5'b0)&&(A3_W==rsnum_E)&&(tnew_W==3'b0)) ? 3'b010 :
							  3'b000;
	assign ForwardRTE = ((A3_M!=5'b0)&&(A3_M==rtnum_E)&&(tnew_M==3'b0)) ? 3'b001 : 
							  ((A3_W!=5'b0)&&(A3_W==rtnum_E)&&(tnew_W==3'b0)) ? 3'b010 :
							  3'b000;
	assign ForwardRTM = ((A3_W!=5'b0)&&(A3_W==rtnum_M)&&(tnew_W==3'b0)) ? 3'b001 :
							  3'b000;
endmodule
