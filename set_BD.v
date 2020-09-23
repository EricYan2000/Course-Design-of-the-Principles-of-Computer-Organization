`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:48 12/20/2019 
// Design Name: 
// Module Name:    set_BD 
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
module set_BD(
    input [31:0] Instr_D,
    output BD
    );

	wire [5:0] opcode, Func;
	wire [4:0] rs, rt, rd;
	assign opcode = Instr_D[31:26];
	assign Func = Instr_D[5:0];
	assign rs = Instr_D[25:21];
	assign rt = Instr_D[20:16];
	assign rd = Instr_D[15:11];
	
	wire J, JAL, JR, JALR, BEQ, BNE, BLEZ, BGTZ, BLTZ, BGEZ;
	assign J = (opcode == 6'd2);
	assign JAL = (opcode == 6'd3);
	assign JR = ((opcode == 6'd0)&&(Func == 6'd8));
	assign JALR = ((opcode == 6'd0)&&(Func == 6'd9));
	assign BEQ = (opcode == 6'd4);
	assign BNE = (opcode == 6'd5);
	assign BLEZ = (opcode == 6'd6);
	assign BGTZ = (opcode == 6'd7);
	assign BLTZ = ((opcode == 6'd1)&&(rt == 5'd0));
	assign BGEZ = ((opcode == 6'd1)&&(rt == 5'd1));
	
	assign BD = (J||JAL||JR||JALR||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ) ? 1'b1 :
					1'b0;

endmodule
