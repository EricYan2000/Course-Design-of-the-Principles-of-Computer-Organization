`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:57:49 11/19/2019 
// Design Name: 
// Module Name:    DEreg 
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
module DEreg(
    input clk,
	 input reset,
	 input stall,
    input[31:0] Instr_in,
    input[31:0] PC4_in,
    input[31:0] PC8_in,
    input[31:0] RS_in,
    input[31:0] RT_in,
    input[31:0] Ext_in,
	 input[4:0] A3_in,
    output reg[31:0] Instr_out,
    output reg[31:0] PC4_out,
    output reg[31:0] PC8_out,
    output reg[31:0] RS_out,
    output reg[31:0] RT_out,
    output reg[31:0] Ext_out,
	 output reg[4:0] A3_out
    );
	 
	 initial begin
	        Instr_out = 0;
			  PC4_out = 0;
			  PC8_out = 0;
			  RS_out = 0;
			  RT_out = 0;
			  Ext_out = 0;
			  A3_out = 0;
	 end
     always@(posedge clk)
	  begin
		  if(reset||stall)
		  begin
			  Instr_out = 0;
			  PC4_out = 0;
			  PC8_out = 0;
			  RS_out = 0;
			  RT_out = 0;
			  Ext_out = 0;
			  A3_out = 0;
		  end
		  else 
		  begin
			  Instr_out = Instr_in;
			  PC4_out = PC4_in;
			  PC8_out = PC8_in;
			  RS_out = RS_in;
			  RT_out = RT_in;
			  Ext_out = Ext_in;
			  A3_out = A3_in;
	     end
	  end
endmodule
