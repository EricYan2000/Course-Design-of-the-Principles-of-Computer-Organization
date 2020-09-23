`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:28:45 11/19/2019 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
	 input [31:0] PC4,
	 input [31:0] A,
    input MemWrite,
    input [31:0] WD,
	 input [3:0] BE,
    output[31:0] RD
    );
    
	reg [31:0] RAM[4095:0];  //RAM
	wire [31:0] PC, addr;
	assign PC = PC4 - 4;
	assign addr = A[13:2];
	assign RD = RAM[addr];

	integer i;
	initial 
	begin
		for(i=0;i<4096;i=i+1)
			RAM[i]=0;
	end
	 
	always@(posedge clk)
	begin
		if(reset)
			for(i=0;i<4096;i=i+1)
				RAM[i]=0;
		else 
			if(MemWrite && (A >= 32'h0000_0000) && (A <= 32'h0000_2fff))
			begin
				if (BE == 4'b1111)				RAM[addr] = WD;
				else if (BE == 4'b1100)			RAM[addr][31:16] = WD[15:0]; 
				else if (BE == 4'b0011)			RAM[addr][15:0] = WD[15:0];
				else if (BE == 4'b1000)			RAM[addr][31:24] = WD[7:0];
				else if (BE == 4'b0100)			RAM[addr][23:16] = WD[7:0];
				else if (BE == 4'b0010)			RAM[addr][15:8] = WD[7:0];
				else if (BE == 4'b0001)			RAM[addr][7:0] = WD[7:0];
				else									;
				
				$display("%d@%h: *%h <= %h",$time,PC, {A[31:2],2'b00} ,RAM[addr]);
			end
	end
endmodule
