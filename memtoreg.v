`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:33:25 12/18/2019 
// Design Name: 
// Module Name:    memtoreg 
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
module memtoreg(
    input [2:0] MUXop,
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
	 input [31:0] in3,
	 output [31:0] out
    );

	assign out = (MUXop == 3'b000) ? in0 :
					 ((MUXop == 3'b001) && (in0 >= 32'h0000_0000) && (in0 <= 32'h0000_2fff)) ? in1 :
					 ((MUXop == 3'b001) && (in0 >= 32'h0000_7f00) && (in0 <= 32'h0000_7f0b)) ? in2 :
					 ((MUXop == 3'b001) && (in0 >= 32'h0000_7f10) && (in0 <= 32'h0000_7f1b)) ? in2 :
					 (MUXop == 3'b011) ? in3 :
					 32'hx;

endmodule
