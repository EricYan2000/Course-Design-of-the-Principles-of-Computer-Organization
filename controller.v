`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:02:30 11/19/2019 
// Design Name: 
// Module Name:    controller 
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
    input [31:0] Instr,
    output [2:0] RegDst,
    output [2:0] NPCop,
    output [2:0] MemToReg,
    output RegWrite,
    output MemWrite,
    output [2:0] ALUSrc,
    output [1:0] Extop,
    output [3:0] ALUop,
	 output Jump,			//Jump cannot, it is used in the ID
	 output [2:0] extop_2,
	 output [2:0] EXout_sel,
	 output [2:0] tnew,
	 output [2:0] tuse_rs,
	 output [2:0] tuse_rt,
	 output [4:0] rsnum,
	 output [4:0] rtnum,
	 output M_in_D,
	 output unknown,
	 output start,
	 output need_stall,
	 output cp0write,
	 output eret,
	 output mtc0
    );
	
	wire [5:0] opcode, Func;
	wire [4:0] rs, rt, rd;
	assign opcode = Instr[31:26];
	assign Func = Instr[5:0];
	assign rs = Instr[25:21];
	assign rt = Instr[20:16];
	assign rd = Instr[15:11];

	wire J, JAL, JR, JALR,
		  BEQ, BNE, BLEZ, BGTZ, BLTZ, BGEZ,
		  LB, LH, LW, LBU, LHU,
		  SB, SH, SW,
		  ADDI, ADDIU, SLTI, SLTIU, ANDI, ORI, XORI, LUI, 
		  ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR,
		  SLL, SRL, SRA, SLLV, SRLV, SRAV, SLT, SLTU,
		  MFHI, MTHI, MFLO, MTLO, MULT, MULTU, DIV, DIVU,
		  ERET, MTC0, MFC0;
	
	assign J = (opcode == 6'd2);
	assign JAL = (opcode == 6'd3);
	assign JR = ((opcode == 6'd0)&&(Func == 6'd8));
	assign JALR = ((opcode == 6'd0)&&(Func == 6'd9));
	assign BEQ = (opcode == 6'd4);
	assign BNE = (opcode == 6'd5);
	assign BLEZ = (opcode == 6'd6);
	assign BGTZ = (opcode == 6'd7);
	assign BLTZ = ((opcode == 6'd1)&&(rt == 5'd0));
	assign BGEZ = ((opcode == 6'd1)&&(rt == 5'd1));
	assign ADDI = (opcode == 6'd8);
	assign ADDIU = (opcode == 6'd9);
	assign SLTI = (opcode == 6'd10);
	assign SLTIU = (opcode == 6'd11);
	assign ANDI = (opcode == 6'd12);
	assign ORI = (opcode == 6'd13);
	assign XORI = (opcode == 6'd14);
	assign LUI = (opcode == 6'd15);
	assign SLL = ((opcode == 6'd0)&&(Func == 6'd0));
	assign SRL = ((opcode == 6'd0)&&(Func == 6'd2));
	assign SRA = ((opcode == 6'd0)&&(Func == 6'd3));
	assign SLLV = ((opcode == 6'd0)&&(Func == 6'd4));
	assign SRLV = ((opcode == 6'd0)&&(Func == 6'd6));
	assign SRAV = ((opcode == 6'd0)&&(Func == 6'd7));
	assign MFHI = ((opcode == 6'd0)&&(Func == 6'd16));
	assign MTHI = ((opcode == 6'd0)&&(Func == 6'd17));
	assign MFLO = ((opcode == 6'd0)&&(Func == 6'd18));
	assign MTLO = ((opcode == 6'd0)&&(Func == 6'd19));
	assign MULT = ((opcode == 6'd0)&&(Func == 6'd24));
	assign MULTU = ((opcode == 6'd0)&&(Func == 6'd25));
	assign DIV = ((opcode == 6'd0)&&(Func == 6'd26));
	assign DIVU = ((opcode == 6'd0)&&(Func == 6'd27));
	assign ADD = ((opcode == 6'd0)&&(Func == 6'd32));
	assign ADDU = ((opcode == 6'd0)&&(Func == 6'd33));
	assign SUB = ((opcode == 6'd0)&&(Func == 6'd34));
	assign SUBU = ((opcode == 6'd0)&&(Func == 6'd35));
	assign AND = ((opcode == 6'd0)&&(Func == 6'd36));
	assign OR = ((opcode == 6'd0)&&(Func == 6'd37));
	assign XOR = ((opcode == 6'd0)&&(Func == 6'd38));
	assign NOR = ((opcode == 6'd0)&&(Func == 6'd39));
	assign SLT = ((opcode == 6'd0)&&(Func == 6'd42));
	assign SLTU = ((opcode == 6'd0)&&(Func == 6'd43));
	assign LB = (opcode == 6'd32);
	assign LH = (opcode == 6'd33);
	assign LW = (opcode == 6'd35);
	assign LBU = (opcode == 6'd36);
	assign LHU = (opcode == 6'd37);
	assign SB = (opcode == 6'd40);
	assign SH = (opcode == 6'd41);
	assign SW = (opcode == 6'd43);
	assign ERET = ((opcode == 6'b010000)&&(Func == 6'b011000));
	assign MTC0 = ((opcode == 6'b010000)&&(rs == 5'b00100));
	assign MFC0 = ((opcode == 6'b 010000)&&(rs == 5'b00000));
	
	//controlling signals      
	
	assign RegDst = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						  JR||SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||J||JALR||
						  MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||ERET||MTC0) ? 3'b000 :
						 (ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LUI||LW||LB||LBU||LH||LHU||MFC0) ? 3'b001 :
						 (JAL) ? 3'b010 :
						 3'b000;
	
	assign NPCop = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						 ORI||ADDI||SLTI||SLTIU||ADDIU||ANDI||XORI||LW||LB||LBU||LH||LHU||SW||SH||SB||LUI||
						 MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||ERET||MTC0||MFC0) ? 3'b000 :
						(BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ) ? 3'b001 :  
						(JAL) ? 3'b010 :
						(JR||JALR) ? 3'b011 :
						(J) ? 3'b100 :
						3'b000;
						
	assign MemToReg = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
							 JR||ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||SW||SH||SB||
							 MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||
							 BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||LUI||JAL||J||JALR||ERET||MTC0) ? 3'b000 :
							(LW||LB||LBU||LH||LHU) ? 3'b001 : 
							(MFC0) ? 3'b011 :
							3'b000;
							
	assign RegWrite = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
							 ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LW||LB||LBU||LH||LHU||LUI||JAL||JALR||
							 MFHI||MFLO||MFC0) ? 1'b1 :
							(JR||SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||J||MULT||MULTU||DIV||DIVU||MTHI||MTLO||
							ERET||MTC0) ? 1'b0 : 
							1'b0;
							
	assign MemWrite = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
							 ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||
							 LW||LB||LBU||LH||LHU||LUI||JAL||JR||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||J||JALR||
							 ERET||MTC0||MFC0) ? 1'b0 :
							(SW||SH||SB) ? 1'b1 :
							1'b0;
							
	assign ALUSrc = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||JR||
						  BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||JAL||J||JALR||
						  MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||ERET||MTC0||MFC0) ? 3'b000 : 
						 (ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LW||LB||LBU||LH||LHU||SW||SH||SB||LUI) ? 3'b001 :
						 3'b000;
						 
	assign Extop = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						 JR||ORI||ANDI||XORI||JAL||J||JALR||MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||
						 ERET||MTC0||MFC0) ? 2'b00 : 
						(ADDI||ADDIU||SLTI||SLTIU||LW||LB||LBU||LH||LHU||SW||SH||SB||
						 BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ) ? 2'b01 :
						(LUI) ? 2'b10 :
						2'b00;
						
	assign ALUop = (ADDU||ADD||ADDI||ADDIU||JR||LW||LB||LBU||LH||LHU||SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||
						 LUI||JAL||J||JALR||MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||ERET||MTC0||MFC0) ? 4'b0000 :
						(SUBU||SUB) ? 4'b0001 :
						(ORI||OR) ? 4'b0010 :
						(AND||ANDI) ? 4'b0011 :
						(XOR||XORI) ? 4'b0100 :
						(NOR) ? 4'b0101 :
						(SLL) ? 4'b0110 :
						(SRL) ? 4'b0111 :
						(SRA) ? 4'b1000 :
						(SLLV) ? 4'b1001 :
						(SRLV) ? 4'b1010 :
						(SRAV) ? 4'b1011 :
						(SLTI||SLT) ? 4'b1100 :
						(SLTIU||SLTU) ? 4'b1101 :
						4'b0000;
	//Jump signal is for the unconditional jumping intructions					
	assign Jump = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LUI||MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||
						LW||LB||LBU||LH||LHU||SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||ERET||MTC0||MFC0) ? 1'b0 : 
					  (JR||JAL||J||JALR) ? 1'b1 :
					  1'b0;
					  
	assign extop_2 = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||JR||
							ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LW||SW||SH||SB||
							MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||
							BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||LUI||JAL||J||JALR||ERET||MTC0||MFC0) ? 3'b000 :
						  (LB) ? 3'b001 :
						  (LBU) ? 3'b010 :
						  (LH) ? 3'b011 :
						  (LHU) ? 3'b100 :
						  3'b000;
	
	assign EXout_sel = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||JR||
							  ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LW||LB||LBU||LH||LHU||SW||SH||SB||
							  BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||LUI||J||MULT||MULTU||DIV||DIVU||MTHI||MTLO||
							  ERET||MTC0||MFC0) ? 3'b000 : 
							 (JAL||JALR) ? 3'b001 : 
							 (MFHI) ? 3'b010 :
							 (MFLO) ? 3'b011 :
							 3'b000;
							 
	assign tnew = (JR||SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||JAL||J||JALR||ERET||MTC0) ? 3'd0 : 
					  (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LUI||
						MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO) ? 3'd1 :
					  (LW||LB||LBU||LH||LHU||MFC0) ? 3'd2 : 
					  3'd0;
					  
	assign tuse_rs = (JR||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||JAL||J||JALR||ERET||MTC0||MFC0) ? 3'd0 :
						  (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						   ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LW||LB||LBU||LH||LHU||SW||SH||SB||LUI||
							MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO) ? 3'd1 :
						  3'd0;
						  
	assign tuse_rt = (JR||ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LW||LB||LBU||LH||LHU||BEQ||
							BNE||BLEZ||BGTZ||BLTZ||BGEZ||LUI||JAL||J||JALR||ERET||MFC0) ? 3'd0 :
						  (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						   MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO) ? 3'd1 :
						  (SW||SH||SB||MTC0) ? 3'd2 : 
						  3'd0;
						  
	assign rsnum = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||JR||JALR||
						 ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LUI||MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||
						 LW||LB||LBU||LH||LHU||SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ) ? rs :
						(JAL||J||ERET||MTC0||MFC0) ? 5'b0 :
						5'b0;
						
	assign rtnum = (ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						 SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||MTC0) ? rt : 
						(BLTZ||BGEZ||ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LW||LB||LBU||LH||LHU||LUI||
						 JAL||J||JR||JALR||ERET||MFC0) ? 5'b0 : 
						5'b0;
						
	assign M_in_D = (MFHI||MTHI||MFLO||MTLO||MULT||MULTU||DIV||DIVU) ? 1'b1 :
						 1'b0;

	assign start = (MULT||MULTU||DIV||DIVU||MTHI||MTLO) ? 1'b1 :
						1'b0;

	assign need_stall = (MULT||MULTU||DIV||DIVU) ? 1'b1 :
							1'b0;
							
	assign unknown = ~(ADDU||SUBU||ADD||SUB||SLT||SLTU||AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||
						  JR||SW||SH||SB||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ||J||JALR||JAL||
						  MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO||
						  ORI||ADDI||ADDIU||ANDI||SLTI||SLTIU||XORI||LUI||LW||LB||LBU||LH||LHU||
						  ERET||MTC0||MFC0); 
							
	assign cp0write = (MTC0 === 1'b1) ? 1'b1 : 
							1'b0;

	assign eret = (ERET === 1'b1) ? 1'b1 : 1'b0;
	
	assign mtc0 = (MTC0 === 1'b1) ? 1'b1 : 1'b0;
endmodule

