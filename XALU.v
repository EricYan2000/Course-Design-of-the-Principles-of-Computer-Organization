`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:20:12 12/10/2019 
// Design Name: 
// Module Name:    XALU 
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
module XALU(
	 input clk,
    input [31:0] A,
    input [31:0] B,
    input [31:0] instr,
	 input reset,
    input start,
	 input DISABLE,
    output reg busy,
    output reg [31:0] HI,
    output reg [31:0] LO
    );

	reg [31:0] hi_reg, lo_reg, state;
	reg [5:0] func;
	initial 
	begin
		busy = 0;
		HI = 32'h0;
		LO = 32'h0;
		hi_reg = 32'h0;
		lo_reg = 32'h0;
		func = 32'h0;
		state = 32'h0;
	end

	always @(posedge clk)
	begin
		if (reset)
		begin
			busy = 0;
			HI = 32'h0;
			LO = 32'h0;
			hi_reg = 32'h0;
			lo_reg = 32'h0;
			func = 32'h0;
			state = 32'h0;
		end
		else 
		begin
			if ((state == 0) && ~DISABLE)
			begin
				if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd16))	//MFHI
				begin
					state = 0;
					busy = 0;
					HI = hi_reg;
					func = 0;
				end
				else if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd18))	//MFLO
				begin
					state = 0;
					busy = 0;
					LO = lo_reg;
					func = 0;
				end
				else						
				begin
					if (start)			//����Ҫ����ĳ˳�ָ��
					begin
						if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd24))			//MULT
						begin
							state = 1;
							busy = 1;
							{hi_reg, lo_reg} = $signed(A) * $signed(B);
							func = instr[5:0];
						end
						else if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd25))	//MULTU
						begin
							state = 1;
							busy = 1;
							{hi_reg, lo_reg} = A * B;
							func = instr[5:0];
						end
						else if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd26))	//DIV
						begin
							state = 1;
							busy = 1;
							hi_reg = $signed(A) % $signed(B);
							lo_reg = $signed(A) / $signed(B);
							func = instr[5:0];
						end
						else if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd27))	//DIVU
						begin
							state = 1;
							busy = 1;
							hi_reg = A % B;
							lo_reg = A / B;
							func = instr[5:0];
						end
						else if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd17))	//MTHI
						begin
							state = 0;
							busy = 0;
							hi_reg = A;
							HI = A;
							func = 0;
						end
						else if ((instr[31:26] == 6'b000000) && (instr[5:0] == 6'd19))	//MTLO
						begin
							state = 0;
							busy = 0;
							lo_reg = A;
							LO = A;
							func = 0;
						end
						else
						begin
							state = 0;
							busy = 0;
							func = 0;
						end
					end
					else
					begin
						state = 0;
						busy = 0;
						func = 0;
					end
				end
			end
			else if ((state==32'd1)||(state==32'd2)||(state==32'd3)||(state==32'd4))
			begin
				if ((state==32'd1) && DISABLE)
				begin
					hi_reg = HI;
					lo_reg = LO;
					state = 0;
					busy = 0;
				end
				else
				begin
					state = state + 32'b1;
					busy = 1;
				end
			end
			else if (state == 5)
			begin
				if ((func == 32'd24)||(func == 32'd25))		//MULT��MULTU�������㣬�����������س�̬��busyϨ��
				begin
					state = 0;
					busy = 0;
					HI = hi_reg;
					LO = lo_reg;
				end
				else if ((func == 32'd26)||(func == 32'd27))	//DIV��DIVU������������
				begin
					state = state + 32'b1;
					busy = 1;
				end
				else
				begin														//if something went wrong
					state = 0;
					busy = 0;
				end
			end
			else if ((state == 6)||(state == 7)||(state == 8)||(state == 9))
			begin
				state = state + 1;
				busy = 1;
			end
			else if (state == 10)			//DIV��DIVU�������㣬������
			begin
				HI = hi_reg;
				LO = lo_reg;
				busy = 0;
				state = 0;
			end
			else 
			begin									//if something went wrong
				busy = 0;
				state = 0;
			end
		end
	end
endmodule
