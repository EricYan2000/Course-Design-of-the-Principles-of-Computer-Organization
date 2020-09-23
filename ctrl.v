`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:52 11/12/2019 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(
    input [5:0] opcode,
    input [5:0] Func,
    output reg [2:0] RegDst,
    output reg [2:0] NPCop,
    output reg [2:0] MemToReg,
    output reg RegWrite,
    output reg MemWrite,
    output reg [2:0] ALUSrc,
    output reg [1:0] Extop,
    output reg [1:0] ALUop
    );

	always @(*)
	begin
		if (opcode == 6'b000000)
		begin
			if (Func == 6'b 100001)   //addu
			begin
				 RegDst  = 3'b000;
				  NPCop  = 3'b000;
				MemToReg = 3'b000;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				 ALUSrc  = 3'b000;
				  Extop  = 2'b00;
				  ALUop  = 2'b00;
			end
			else if (Func == 6'b 100011)   //subu
			begin
				 RegDst  = 3'b000;
				  NPCop  = 3'b000;
				MemToReg = 3'b000;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				 ALUSrc  = 3'b000;
				  Extop  = 2'b00;
				  ALUop  = 2'b01;
			end
			else if (Func == 6'b001000)  //jr
			begin
				 RegDst  = 3'b000;
				  NPCop  = 3'b011;
				MemToReg = 3'b000;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				 ALUSrc  = 3'b000;
				  Extop  = 2'b00;
				  ALUop  = 2'b00;
			end
			else    //for safe keeping
			begin
			 	 RegDst  = 3'b000;
			     NPCop  = 3'b000;
				MemToReg = 3'b000;
			   RegWrite = 1'b0;
			   MemWrite = 1'b0;
			    ALUSrc  = 3'b000;
			     Extop  = 2'b00;
			     ALUop  = 2'b00;
			end
		end
		else if (opcode == 6'b 001101)   //ori
		begin
			 RegDst  = 3'b001;
			  NPCop  = 3'b000;
			MemToReg = 3'b000;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			 ALUSrc  = 3'b001;
			  Extop  = 2'b00;
			  ALUop  = 2'b10;
		end
		else if (opcode == 6'b 100011)   //lw
		begin
			 RegDst  = 3'b001;
			  NPCop  = 3'b000;
			MemToReg = 3'b001;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			 ALUSrc  = 3'b001;
			  Extop  = 2'b01;
			  ALUop  = 2'b00;
		end
		else if (opcode == 6'b 101011)   //sw
		begin
			 RegDst  = 3'b000;
			  NPCop  = 3'b000;
			MemToReg = 3'b000;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			 ALUSrc  = 3'b001;
			  Extop  = 2'b01;
			  ALUop  = 2'b00;
		end
		else if (opcode == 6'b 000100)   //beq
		begin
			 RegDst  = 3'b000;
			  NPCop  = 3'b001;
			MemToReg = 3'b000;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			 ALUSrc  = 3'b000;
			  Extop  = 2'b01;
			  ALUop  = 2'b00;
		end
		else if (opcode == 6'b 001111)   //lui
		begin
			 RegDst  = 3'b001;
			  NPCop  = 3'b000;
			MemToReg = 3'b000;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			 ALUSrc  = 3'b001;
			  Extop  = 2'b10;
			  ALUop  = 2'b00;
		end
		else if (opcode == 6'b 000011)   //jal
		begin
			 RegDst  = 3'b010;
			  NPCop  = 3'b010;
			MemToReg = 3'b010;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			 ALUSrc  = 3'b000;
			  Extop  = 2'b00;
			  ALUop  = 2'b00;
		end
		else     //fo safe keeping
		begin
			 RegDst  = 3'b000;
			  NPCop  = 3'b000;
			MemToReg = 3'b000;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			 ALUSrc  = 3'b000;
			  Extop  = 2'b00;
			  ALUop  = 2'b00;
		end
	end
endmodule
