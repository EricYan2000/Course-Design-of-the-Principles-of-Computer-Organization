`timescale 1ns / 1ps

`define IM7_2   SR[15:10]
`define EXL     SR[1]
`define IE      SR[0]

`define BD      CAUSE[31]
`define IP7_2   CAUSE[15:10]
`define ExcCode CAUSE[6:2]
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:28 12/18/2019 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
    input clk,
    input reset,
    input cp0write,
    input [4:0] RA,
    input [4:0] WA,
    input [31:0] Din,
    input [31:0] PC,
    input [4:0] ExcCode_in,
    input [5:0] HWInt,
    input BD_in,
    input eret,
    output interrupt,
    output exception,
    output reg [31:0] EPC,
    output [31:0] Dout 
    );

    reg [31:0] SR, CAUSE;		//EPC
    reg [31:0] PRID = 32'h20191220;
	 
	 //mod 4 before sending PC into EPC

    initial
    begin
        SR = 0;
        CAUSE = 0;
        EPC = 0;
        PRID = 20191220;
    end

	 wire test;
	 assign test = |(HWInt[5:0] & `IM7_2);
    assign interrupt = ((|(HWInt[5:0] & `IM7_2)) & `IE & ~(`EXL));
    assign exception = ( ~interrupt && ((ExcCode_in != 5'b0) && ~(`EXL)) );     //interrupt > exception
    assign Dout = (RA == 5'd12) ? SR :
                    (RA == 5'd13) ? CAUSE :
                    (RA == 5'd14) ? EPC :
                    (RA == 5'd15) ? PRID :
                    32'hx;


    always @(posedge clk)
    begin
        if (reset)
        begin
            SR = 0;
            CAUSE = 0;
            EPC = 0;
            PRID = 20191220;
        end
        else
        begin
            `IP7_2 = HWInt;
            if (interrupt)
            begin
                `EXL = 1'b1;
                `ExcCode = 5'b0;
                `BD = BD_in;
                EPC = BD_in ? ({PC[31:2], 2'b00} - 32'd4) : {PC[31:2], 2'b00};
            end
            else if (exception)
            begin
                `EXL = 1'b1;
                `ExcCode = ExcCode_in;
                `BD = BD_in;
                EPC = BD_in ? ({PC[31:2], 2'b00} - 32'd4) : {PC[31:2], 2'b00};
            end
            else if (eret)
            begin
                `EXL = 1'b0;
                `BD = 1'b0;
            end
            else if (cp0write)
            begin
                if (WA == 5'd12)                //SR
                begin
                    `IM7_2 = Din[15:10];
                    `EXL = Din[1]; 
                    `IE = Din[0];
                end
                else if (WA == 5'd14)
                begin
                    EPC = Din;
                end 
                else    
                    ;
            end
            else    
                ;
        end
    end

endmodule
