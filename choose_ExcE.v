`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:32 12/17/2019 
// Design Name: 
// Module Name:    choose_ExcE 
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
module choose_ExcE(
    input unknown,
    input [4:0] ExcCode_in,
    output [4:0] ExcCode_out,
	 output error
    );

	assign error = (unknown || (ExcCode_in != 0)) ? 1'b1 : 1'b0;
	assign ExcCode_out = (ExcCode_in != 0) ? ExcCode_in :
								(unknown) ? 5'd10 :
								5'd0;

endmodule
