`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:48:44 12/21/2019 
// Design Name: 
// Module Name:    PC_modifier 
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
module PC_modifier(
    input [31:0] original,
    input [31:0] exception_handler,
    input [31:0] EPC,
    input interrupt,
    input exception,
    input eret_d,
    output [31:0] to_PC
    );

	assign to_PC = (eret_d) ? EPC :
						(interrupt || exception) ? exception_handler :
						original;
endmodule
