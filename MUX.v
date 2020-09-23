`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:53:13 11/19/2019 
// Design Name: 
// Module Name:    MUX 
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
module MUX_4_5bits(
    input [2:0] MUXop,
    input [4:0] in0,
    input [4:0] in1,
    input [4:0] in2,
    input [4:0] in3,
    output [4:0] out
    );
	
	assign out = (MUXop == 3'b000) ? in0 :
					 (MUXop == 3'b001) ? in1 : 
					 (MUXop == 3'b010) ? in2 : 
					 (MUXop == 3'b011) ? in3 :
					 5'bz;
endmodule

module MUX_4_32bits(
    input [2:0] MUXop,
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    output [31:0] out
    );
	
	assign out = (MUXop == 3'b000) ? in0 :
					 (MUXop == 3'b001) ? in1 : 
					 (MUXop == 3'b010) ? in2 : 
					 (MUXop == 3'b011) ? in3 :
					 32'bz;
endmodule

module MUX_2_32bits(
    input MUXop,
    input [31:0] in0,
    input [31:0] in1,
    output [31:0] out
    );
	
	assign out = (MUXop == 1'b0) ? in0 :
					 (MUXop == 1'b1) ? in1 : 
					 5'bz;
endmodule
