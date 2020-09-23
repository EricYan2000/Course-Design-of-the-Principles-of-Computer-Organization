`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:18:18 11/12/2019 
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
    input MemWrite,
    input [31:0] PC,
    input [31:0] address,
    input [31:0] WD,
    output [31:0] RD
    );

	wire [11:2] addr;
	reg [31:0] mem [1023:0];
	assign addr = address[11:2];    //input the 32bits address, and then make it a 10 bits addr inside of the DM
	assign RD = mem[addr];          //remember address is longer than addr
	
	integer i;
	initial
	begin
		for(i=0;i<1024;i=i+1)
			mem[i] = 32'h0000_0000;
	end
	
	always @(posedge clk)
	begin
		if (reset)
			for(i=0;i<1024;i=i+1)
				mem[i] = 32'h0000_0000;
		else
			if (MemWrite)
			begin
				mem[addr] = WD;
				$display("@%h: *%h <= %h", PC, address, WD);
			end
	end
endmodule



