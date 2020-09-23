`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:38 12/17/2019 
// Design Name: 
// Module Name:    overflow_judge 
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
module overflow_judge(
    input overflow,
	 input [31:0] ALUout,
    input [31:0] Instr,
    output reg [4:0] ExcCode
    );

	wire [5:0] opcode, Func;
	wire [4:0] rs, rt, rd;
	assign opcode = Instr[31:26];
	assign Func = Instr[5:0];
	assign rs = Instr[25:21];
	assign rt = Instr[20:16];
	assign rd = Instr[15:11];

	wire ADD, ADDI, SUB, LW, LB, LH, LBU, LHU, SW, SH, SB;
	assign ADD = ((opcode == 6'd0)&&(Func == 6'd32));
	assign ADDI = (opcode == 6'd8);
	assign SUB = ((opcode == 6'd0)&&(Func == 6'd34));
	assign LB = (opcode == 6'd32);
	assign LH = (opcode == 6'd33);
	assign LW = (opcode == 6'd35);
	assign LBU = (opcode == 6'd36);
	assign LHU = (opcode == 6'd37);
	assign SB = (opcode == 6'd40);
	assign SH = (opcode == 6'd41);
	assign SW = (opcode == 6'd43);

	always @(*)
	begin
		if (ADD || ADDI || SUB)
		begin
			if (overflow)
				ExcCode = 5'd12;
			else
				ExcCode = 5'd0;
		end
		else if (LW || LH || LHU || LB || LBU)
		begin
			if ((LW && ALUout[1:0]!=2'b00)||
				((LH||LHU) && ALUout[0]!=1'b0)||
				((LH||LHU||LB||LBU) && (ALUout >= 32'h0000_7f00) && (ALUout <= 32'h0000_7f0b))||
				((LH||LHU||LB||LBU) && (ALUout >= 32'h0000_7f10) && (ALUout <= 32'h0000_7f1b))||
				((LW||LH||LHU||LB||LBU) && overflow)||
				((LW||LH||LHU||LB||LBU) 
				&& ~((ALUout >= 32'h0000_0000)&&(ALUout <= 32'h0000_2fff))
				&& ~((ALUout >= 32'h0000_7f00)&&(ALUout <= 32'h0000_7f0b))
				&& ~((ALUout >= 32'h0000_7f10)&&(ALUout <= 32'h0000_7f1b))
				))
				ExcCode = 5'd4;
			else	
				ExcCode = 5'd0;
		end
		else if (SW || SH ||SB)
		begin
			if ((SW && ALUout[1:0]!=2'b00)||
				(SH && ALUout[0]!= 1'b0)||
				((SH||SB) && (ALUout >= 32'h0000_7f00) && (ALUout <= 32'h0000_7f0b))||
				((SH||SB) && (ALUout >= 32'h0000_7f10) && (ALUout <= 32'h0000_7f1b))||
				((SW||SH||SB) && overflow)||
				((SW||SH||SB) && (ALUout >= 32'h0000_7f08) && (ALUout <= 32'h0000_7f0b))||
				((SW||SH||SB) && (ALUout >= 32'h0000_7f18) && (ALUout <= 32'h0000_7f1b))||
				((SW||SH||SB) 
				&& ~((ALUout >= 32'h0000_0000)&&(ALUout <= 32'h0000_2fff))
				&& ~((ALUout >= 32'h0000_7f00)&&(ALUout <= 32'h0000_7f0b))
				&& ~((ALUout >= 32'h0000_7f10)&&(ALUout <= 32'h0000_7f1b))
				))
				ExcCode = 5'd5;
			else
				ExcCode = 5'd0;
		end
		else	
			ExcCode = 0;
	end

endmodule
