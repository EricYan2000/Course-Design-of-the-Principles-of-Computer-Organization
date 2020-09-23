`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:02 12/21/2019 
// Design Name: 
// Module Name:    insert_nop 
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
module insert_nop(
    input eret_d,
    input [31:0] instr_in,
    output [31:0] instr_out
    );

	assign instr_out = (eret_d) ? 32'h0 :
					instr_in;

endmodule
