`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:33:51 11/19/2019 
// Design Name: 
// Module Name:    Ext 
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
module Extender(
    input [15:0] imm_16,
    input [1:0] Extop,
    output [31:0] out
    );
	
	assign out = (Extop == 2'b00) ? {{16{1'b0}}, imm_16} :
					 (Extop == 2'b01) ? {{16{imm_16[15]}}, imm_16} :
					 (Extop == 2'b10) ? {imm_16, {16{1'b0}}} :
					 32'bz ;
					//  C = $signed(A) >>> B;
endmodule
