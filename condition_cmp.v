`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:06:50 12/03/2019 
// Design Name: 
// Module Name:    condition_cmp 
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
module condition_cmp(
    input [31:0] instr,
    input [31:0] rs,
    input [31:0] rt,
    output reg cmp_jump
    );

	`define opcode (instr[31:26])
	`define func   (instr[5:0])

	always @(*)
	begin
		if (`opcode == 6'h4)        cmp_jump = (rs == rt) ? 1'b1 : 1'b0;   //beq
		else if (`opcode == 6'h5)   cmp_jump = (rs != rt) ? 1'b1 : 1'b0;   //bne
		else if (`opcode == 6'h6)   cmp_jump = ($signed(rs) <= $signed(32'b0)) ? 1'b1 : 1'b0;   //blez
		else if (`opcode == 6'h7)   cmp_jump = ($signed(rs) >  $signed(32'b0)) ? 1'b1 : 1'b0;   //bgtz
		else if ((`opcode == 6'h1)&&(instr[20:16] == 5'b00001))
			cmp_jump = ($signed(rs) >= $signed(32'b0)) ? 1'b1 : 1'b0;   //bgez
		else if ((`opcode == 6'h1)&&(instr[20:16] == 5'b00000))
			cmp_jump = ($signed(rs) <  $signed(32'b0)) ? 1'b1 : 1'b0;   //bltz
		else
			cmp_jump = 1'b0;   //for safe keeping
	end
endmodule
