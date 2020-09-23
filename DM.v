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
	 input[31:0] PC4,
	 input[31:0] A,
    input MemWrite,
    input[31:0] WD,
    output[31:0] RD
    );
    
	reg[31:0] RAM[1023:0];  //RAM
	wire [31:0] PC;
	assign PC = PC4 - 4;
	assign RD = RAM[A[11:2]];
	 
	integer i;
	initial 
	begin
		for(i=0;i<1024;i=i+1)
			RAM[i]=0;
	end
	 
	always@(posedge clk)
	begin
		if(reset)
			for(i=0;i<1024;i=i+1)
				RAM[i]=0;
		else 
			if(MemWrite)
			begin
				RAM[A[11:2]] = WD;
				$display("%d@%h: *%h <= %h",$time,PC,A,RAM[A[11:2]]);
			end
	end
endmodule
