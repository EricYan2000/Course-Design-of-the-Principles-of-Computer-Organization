`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:26:09 11/19/2019 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
	 input [31:0] instr,
    input [3:0] ALUop,
    output reg [31:0] result,
    output Zero
    );

	assign Zero = (A == B);
	`define shamt (instr[10:6])
	
	always @(*)
	begin
		if (ALUop == 4'b0000)			result = A + B;
		else if (ALUop == 4'b0001)		result = A - B;
		else if (ALUop == 4'b0010)		result = A | B;
		else if (ALUop == 4'b0011)		result = A & B;
		else if (ALUop == 4'b0100)		result = A ^ B;
		else if (ALUop == 4'b0101)		result = ~(A|B);
		else if (ALUop == 4'b0110)		result = B << `shamt;				//SLL
		else if (ALUop == 4'b0111)		result = B >> `shamt;				//SRL
		else if (ALUop == 4'b1000)		result = $signed(B) >>> `shamt;	//SRA
		else if (ALUop == 4'b1001)		result = B << A[4:0];				//SLLV
		else if (ALUop == 4'b1010)		result = B >> A[4:0];				//SRLV
		else if (ALUop == 4'b1011)		result = $signed(B) >>> A[4:0];	//SRAV
		else if (ALUop == 4'b1100)		result = ($signed(A)<$signed(B)) ? 32'b1 : 32'b0;
		else if (ALUop == 4'b1101)		result = (A<B) ? 32'b1 : 32'b0; 
		else									result = 32'hz;
	end
endmodule
