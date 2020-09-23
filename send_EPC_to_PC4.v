`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:55:59 12/21/2019 
// Design Name: 
// Module Name:    send_EPC_to_PC4 
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
module send_EPC_to_PC4(
    input eret_d,
    input [31:0] PC,
    input [31:0] EPC,
    output [31:0] PC4_out
    );

	assign PC4_out = (eret_d) ? (EPC + 32'd4) :
							(PC + 32'd4);

endmodule
