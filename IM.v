`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:44:31 11/12/2019 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [11:2] addr,
    output [5:0] opcode,
    output [5:0] Func,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm_16,
    output [25:0] imm_26
    );

	reg [31:0] im [1023:0];

	initial
	begin
		$readmemh("code.txt",im);
	end

	assign opcode = im[addr][31:26];
	assign  Func  = im[addr][5:0];
	assign   rs   = im[addr][25:21];
	assign   rt   = im[addr][20:16];
	assign   rd   = im[addr][15:11];
	assign imm_16 = im[addr][15:0];
	assign imm_26 = im[addr][25:0];
endmodule
