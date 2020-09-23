`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:32:33 11/19/2019 
// Design Name: 
// Module Name:    MWreg 
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
module MWreg(
    input clk,
    input reset,
    input [31:0] Instr_M_out,
    input [31:0] ALUout_M_out,
	 input [31:0] DM_M_out,
    input [31:0] PC4_M_out,
    input [31:0] PC8_M_out,
    input [4:0] A3_M_out,
    output reg [31:0] Instr_W_in,
    output reg [31:0] ALUout_W_in,
	 output reg [31:0] DM_W_in,
    output reg [31:0] PC4_W_in,
    output reg [31:0] PC8_W_in,
    output reg [4:0] A3_W_in
    );

	initial
	begin
		Instr_W_in = 0;
		ALUout_W_in = 0;
		DM_W_in = 0;
		PC4_W_in = 0;
		PC8_W_in = 0;
		A3_W_in = 0;
	end
	
	always @(posedge clk)
	begin
		if(reset)
		begin
			Instr_W_in <= 0;
			ALUout_W_in <= 0;
			DM_W_in <= 0;
			PC4_W_in <= 0;
			PC8_W_in <= 0;
			A3_W_in <= 0;	
		end
		else
		begin
			Instr_W_in <= Instr_M_out;
			ALUout_W_in <= ALUout_M_out;
			DM_W_in <= DM_M_out;
			PC4_W_in <= PC4_M_out;
			PC8_W_in <= PC8_M_out;
			A3_W_in <= A3_M_out;	
		end
	end
endmodule
