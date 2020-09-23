`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:32:20 12/03/2019 
// Design Name: 
// Module Name:    BE 
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
module BE(
    input [31:0] instr,
	 input [31:0] ALUout,
    output reg [3:0] BE
    );
	 
	`define opcode (instr[31:26])
	`define func   (instr[5:0])
	initial
		BE = 4'b0000;

	always @(*)
	begin
		if ((`opcode == 6'h28)||(`opcode == 6'h20)||(`opcode == 6'h24))			//sb||lb||lbu
		begin
			case (ALUout[1:0])
				2'b00:	BE = 4'b0001;
				2'b01:	BE = 4'b0010;
				2'b10:	BE = 4'b0100;
				2'b11:	BE = 4'b1000;
			endcase
		end
		else if ((`opcode == 6'h29)||(`opcode == 6'h21)||(`opcode == 6'h25))		//sh||lh||lhu
		begin
			case (ALUout[1])
				1'b0:		BE = 4'b0011;
				1'b1:		BE = 4'b1100;
			endcase
		end
		else if ((`opcode == 6'h2b)||(`opcode == 6'h23))		//sw||lw
			BE = 4'b1111;
		else									//for safe keeping
			BE = 4'b0000;
	end
endmodule
