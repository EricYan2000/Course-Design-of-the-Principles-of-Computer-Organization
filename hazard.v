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
    input [4:0] A3_E_in,
    input [4:0] A3_M_in,
    input [4:0] A3_W,
    output [2:0] ForwardRSD,
    output [2:0] ForwardRTD,
    output [2:0] ForwardRSE,
    output [2:0] ForwardRTE,
    output [2:0] ForwardRTM,
    output stall
    );

	`define rs 25:21
	`define rt 20:16
	`define rd 15:11

	wire calr_D, cali_D, B_D, load_D, save_D, jr_D, jal_D;
	wire calr_E, cali_E, B_E, load_E, save_E, jr_E, jal_E;
	wire calr_M, cali_M, B_M, load_M, save_M, jr_M, jal_M;
	
	ctrl controller_D (.Instr(Instr_D_in), .cal_r(calr_D), .cal_i(cali_D), .b(B_D), .load(load_D), .save(save_D), .jr(jr_D), .jal(jal_D));
	ctrl controller_E (.Instr(Instr_E_in), .cal_r(calr_E), .cal_i(cali_E), .b(B_E), .load(load_E), .save(save_E), .jr(jr_E), .jal(jal_E));
	ctrl controller_M (.Instr(Instr_M_in), .cal_r(calr_M), .cal_i(cali_M), .b(B_M), .load(load_M), .save(save_M), .jr(jr_M), .jal(jal_M));
	ctrl controller_W (.Instr(Instr_W_in), .cal_r(calr_W), .cal_i(cali_W), .b(B_W), .load(load_W), .save(save_W), .jr(jr_W), .jal(jal_W));
	
	//stalls
	wire stall_b_calr, stall_b_cali, stall_b_load2, stall_b_load1;
	wire stall_jr_calr, stall_jr_cali, stall_jr_load2, stall_jr_load1;
	wire stall_calr_load2, stall_cali_load2, stall_lw_load2, stall_sw_load2;
	
	//如果写入的是0号寄存器，就不需要暂停；反之，不是0寄存器，并且满足供给和需求为同一个寄存器的时候才要暂停
	assign stall_b_calr = (B_D && calr_E &&((Instr_D_in[`rs]==Instr_E_in[`rd]) || (Instr_D_in[`rt]==Instr_E_in[`rd])))
									&& (Instr_E_in[`rd]!=5'b0);
	assign stall_b_cali = (B_D && cali_E &&((Instr_D_in[`rs]==Instr_E_in[`rt]) || (Instr_D_in[`rt]==Instr_E_in[`rt])))
									&& (Instr_E_in[`rt]!=5'b0);
	assign stall_b_load2 = (B_D && load_E &&((Instr_D_in[`rs]==Instr_E_in[`rt]) || (Instr_D_in[`rt]==Instr_E_in[`rt])))
									&& (Instr_E_in[`rt]!=5'b0);
	assign stall_b_load1 = (B_D && load_M &&((Instr_D_in[`rs]==Instr_M_in[`rt]) || (Instr_D_in[`rt]==Instr_M_in[`rt])))
									&& (Instr_M_in[`rt]!=5'b0);
	assign stall_jr_calr = (jr_D && calr_E && (Instr_D_in[`rs]==Instr_E_in[`rd]))
									&& (Instr_E_in[`rd]!=5'b0);
	assign stall_jr_cali = (jr_D && cali_E && (Instr_D_in[`rs]==Instr_E_in[`rt]))
									&& (Instr_E_in[`rt]!=5'b0);
	assign stall_jr_load2 = (jr_D && load_E && (Instr_D_in[`rs]==Instr_E_in[`rt]))
									&& (Instr_E_in[`rt]!=5'b0);
	assign stall_jr_load1 = (jr_D && load_M && (Instr_D_in[`rs]==Instr_M_in[`rt]))
									&& (Instr_M_in[`rt]!=5'b0);
	assign stall_calr_load2 = (calr_D && load_E && ((Instr_D_in[`rs]==Instr_E_in[`rt]) || (Instr_D_in[`rt]==Instr_E_in[`rt])))
									&& (Instr_E_in[`rt]!=5'b0);
	assign stall_cali_load2 = (cali_D && load_E && (Instr_D_in[`rs]==Instr_E_in[`rt]))
									&& (Instr_E_in[`rt]!=5'b0);
	assign stall_lw_load2 = (load_D && load_E && (Instr_D_in[`rs]==Instr_E_in[`rt]))
									&& (Instr_E_in[`rt]!=5'b0);
	assign stall_sw_load2 = (save_D && load_E && (Instr_D_in[`rs]==Instr_E_in[`rt]))
									&& (Instr_E_in[`rt]!=5'b0);
									
	assign stall = stall_b_calr || stall_b_cali || stall_b_load2 || stall_b_load1 || 
						stall_jr_calr || stall_jr_cali || stall_jr_load2 || stall_jr_load1 ||
						stall_calr_load2 || stall_cali_load2 || stall_lw_load2 || stall_sw_load2;
	
	//建议判断指令的类型，不然不是很容易分开
	assign ForwardRSD =  ((A3_E_in!=5'b0) && jal_E && (Instr_D_in[`rs]==5'b11111)) ?  3'b001 :   //JAL PC8_E
								((A3_M_in!=5'b0) && jal_M && (Instr_D_in[`rs]==5'b11111)) ?  3'b011 :   //jal PC8_M
								((A3_M_in!=5'b0) && calr_M && (Instr_D_in[`rs]==Instr_M_in[`rd])) ?  3'b010  : //ALU_M
								((A3_M_in!=5'b0) && cali_M && (Instr_D_in[`rs]==Instr_M_in[`rt])) ?  3'b010  :
								3'b000 ;   //no need
	
	assign ForwardRTD =  ((A3_E_in!=5'b0) && jal_E && (Instr_D_in[`rt]==5'b11111)) ?  3'b001 :   //JAL PC8_E
								((A3_M_in!=5'b0) && jal_M && (Instr_D_in[`rt]==5'b11111)) ?  3'b011 :   //jal PC8_M
								((A3_M_in!=5'b0) && calr_M && (Instr_D_in[`rt]==Instr_M_in[`rd])) ?  3'b010  : //ALU_M
								((A3_M_in!=5'b0) && cali_M && (Instr_D_in[`rt]==Instr_M_in[`rt])) ?  3'b010  :
								3'b000 ;   //no need
		
	assign ForwardRSE =  ((A3_M_in!=5'b0) && calr_M && (Instr_E_in[`rs]==Instr_M_in[`rd])) ?  3'b001  : //ALU_M
								((A3_M_in!=5'b0) && cali_M && (Instr_E_in[`rs]==Instr_M_in[`rt])) ?  3'b001  :
								((A3_M_in!=5'b0) && jal_M && (Instr_E_in[`rs]==5'b11111)) ?  3'b010 :   //jalPC8_M
								((A3_W!=5'b0) && calr_W && (Instr_E_in[`rs]==Instr_W_in[`rd])) ?  3'b011  :  //calr
								((A3_W!=5'b0) && cali_W && (Instr_E_in[`rs]==Instr_W_in[`rt])) ?  3'b011  :  //cali
								((A3_W!=5'b0) && load_W && (Instr_E_in[`rs]==Instr_W_in[`rt])) ?  3'b011  :  //load
								((A3_W!=5'b0) && jal_W && (Instr_E_in[`rs]==5'b11111)) ?  3'b011  :  //cali
								3'b000 ;   //no need
		
	assign ForwardRTE =  ((A3_M_in!=5'b0) && calr_M && (Instr_E_in[`rt]==Instr_M_in[`rd])) ?  3'b001  : //ALU_M
								((A3_M_in!=5'b0) && cali_M && (Instr_E_in[`rt]==Instr_M_in[`rt])) ?  3'b001  :
								((A3_M_in!=5'b0) && jal_M && (Instr_E_in[`rt]==5'b11111)) ?  3'b010 :
								((A3_W!=5'b0) && calr_W && (Instr_E_in[`rt]==Instr_W_in[`rd])) ?  3'b011  :  //calr
								((A3_W!=5'b0) && cali_W && (Instr_E_in[`rt]==Instr_W_in[`rt])) ?  3'b011  :  //cali
								((A3_W!=5'b0) && load_W && (Instr_E_in[`rt]==Instr_W_in[`rt])) ?  3'b011  :  //load
								((A3_W!=5'b0) && jal_W && (Instr_E_in[`rt]==5'b11111)) ?  3'b011  :  //cali
								3'b000 ;   //no need
		
	assign ForwardRTM =  ((A3_W!=5'b0) && calr_W && (Instr_M_in[`rt]==Instr_W_in[`rd])) ?  3'b001  :  //calr
								((A3_W!=5'b0) && cali_W && (Instr_M_in[`rt]==Instr_W_in[`rt])) ?  3'b001  :  //cali
								((A3_W!=5'b0) && load_W && (Instr_M_in[`rt]==Instr_W_in[`rt])) ?  3'b001  :  //load
								((A3_W!=5'b0) && jal_W && (Instr_M_in[`rt]==5'b11111)) ?  3'b001  :  //cali
								3'b000 ;   //no need
	
endmodule
