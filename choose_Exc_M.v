`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:26 12/17/2019 
// Design Name: 
// Module Name:    choose_Exc_M 
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
module choose_Exc_M(
    input [4:0] judger_out,
    input [4:0] Exc_E,
    output [4:0] Exc_out,
	 output error
    );

	assign Exc_out = (Exc_E == 5'b0) ? judger_out :
							Exc_E;
	assign error = ((judger_out != 0) || (Exc_E != 0));
	
endmodule
