`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:40:13 12/17/2019 
// Design Name: 
// Module Name:    choose_EPC_E 
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
module choose_EPC_E(
    input PCSrc,
    input [31:0] EPC_D,
    input [31:0] NPC,
    output [31:0] EPC_out
    );

	wire [31:0] NPC_done;
	assign NPC_done = {NPC[31:2] ,2'b00};
	assign EPC = (PCSrc == 1) ? NPC_done :
					  EPC_D;
endmodule
