`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:50 12/03/2019 
// Design Name: 
// Module Name:    Ext_2 
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
module Ext_2(
    input [31:0] DM,
    input [2:0] extop_2,
	 input [3:0] BE,
    output reg [31:0] DMout
    );

	always @(*)
	begin
		if (extop_2 == 3'b000)						//нч╧ь
			DMout = DM;
		else if (extop_2 == 3'b001)				//lb
		begin
			if (BE == 4'b0001)			DMout = { {24{DM[7]}}, DM[7:0] };
			else if (BE == 4'b0010)		DMout = { {24{DM[15]}}, DM[15:8] };
			else if (BE == 4'b0100)		DMout = { {24{DM[23]}}, DM[23:16] };
			else if (BE == 4'b1000)		DMout = { {24{DM[31]}}, DM[31:24] };
			else								DMout = DM;
		end	
		else if (extop_2 == 3'b010)		//lbu
		begin
			if (BE == 4'b0001)			DMout = { {24'b0}, DM[7:0] };
			else if (BE == 4'b0010)		DMout = { {24'b0}, DM[15:8] };
			else if (BE == 4'b0100)		DMout = { {24'b0}, DM[23:16] };
			else if (BE == 4'b1000)		DMout = { {24'b0}, DM[31:24] };
			else								DMout = DM;
		end	
		else if (extop_2 == 3'b011)		//lh
		begin
			if (BE == 4'b0011)			DMout = { {16{DM[15]}}, DM[15:0] };
			else if (BE == 4'b1100)		DMout = { {16{DM[31]}}, DM[31:16] };
			else								DMout = DM;
		end
		else if (extop_2 == 3'b100)		//lhu
		begin
			if (BE == 4'b0011)			DMout = { {16'b0}, DM[15:0] };
			else if (BE == 4'b1100)		DMout = { {16'b0}, DM[31:16] };
			else								DMout = DM;
		end
		else
			DMout = DM;
	end
endmodule
