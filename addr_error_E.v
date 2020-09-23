`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:33 12/17/2019 
// Design Name: 
// Module Name:    addr_error_E 
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
module addr_error_E(
	 input [31:0] PC,
	 output [4:0] ExcCode
    );

	assign ExcCode = ((PC[1:0] == 2'b00) && (PC >= 32'h3000) && (PC <= 32'h4fff)) ? 5'd0 :		//no_error
						5'd4;																							//error

endmodule
