`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:20:05 11/19/2019 
// Design Name: 
// Module Name:    EMreg 
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
module EMreg(
    input clk,
    input reset,
    input [31:0] Instr_E_out,
    input [31:0] ALUout_E,
    input [31:0] RT_E_out,
    input [4:0] A3_E_out,
    input [31:0] PC4_E_out,
    input [31:0] PC8_E_out,
    output reg [31:0] Instr_M_in,
    output reg [31:0] ALUout_M,
    output reg [31:0] RT_M_in,
    output reg [4:0] A3_M_in,
    output reg [31:0] PC4_M_in,
    output reg [31:0] PC8_M_in
    );

	initial
	begin
		Instr_M_in = 0;
		ALUout_M = 0;
		RT_M_in = 0;
		A3_M_in = 0;
		PC4_M_in = 0;
		PC8_M_in = 0;
	end
	
	always @(posedge clk)
	begin
		if (reset)
		begin
			Instr_M_in <= 0;
			ALUout_M <= 0;
			RT_M_in <= 0;
			A3_M_in <= 0;
			PC4_M_in <= 0;
			PC8_M_in <= 0;
		end
		else 
		begin
			Instr_M_in <= Instr_E_out;
			ALUout_M <= ALUout_E;
			RT_M_in <= RT_E_out;
			A3_M_in <= A3_E_out;
			PC4_M_in <= PC4_E_out;
			PC8_M_in <= PC8_E_out;
		end
	end
endmodule
