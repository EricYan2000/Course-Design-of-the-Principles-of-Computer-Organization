`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:23:27 11/19/2019 
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
    input [31:0] PC,
    output [31:0] RD
    );

	reg [31:0] ROM[4095:0];
	wire [31:0] address;
	assign address = PC - 32'h3000;
	
	initial
	begin
		$readmemh("code.txt",ROM);
	end
	
	assign RD = ROM[address[13:2]];
endmodule
