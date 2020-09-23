`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:44:10 12/17/2019 
// Design Name: 
// Module Name:    EPC_cal 
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
module EPC_cal(
    input [31:0] PC,
    input BD,
    output [31:0] EPC
    );

	wire [31:0] PC_done;
	assign PC_done = {PC[31:2], 2'b00};
	assign EPC = (BD == 1) ? (PC_done - 4) :
					 PC_done;

endmodule
