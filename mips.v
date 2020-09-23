`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:01:33 12/17/2019 
// Design Name: 
// Module Name:    mips.v 
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
module mips(
	 input clk,
    input reset,
    input interrupt,
    output [31:0] addr
    );


	wire [31:0] Addr, PrAddr;
	wire [3:0] PrBE;
	wire WE0, WE1, PrWE;
	wire [31:0] DEV_WD, DEV0_RD, DEV1_RD, PrRD, PrWD;
	wire IRQ0, IRQ1;
	wire [5:0] HWInt;
	
	CPU cpu (.clk(clk), .reset(reset), .PrRD(PrRD), .HWInt(HWInt), .PrWE(PrWE), .PrAddr(PrAddr), .PrWD(PrWD), 
				.PrBE(PrBE), .addr(addr));
	bridge Bridge (.PrAddr(PrAddr), .PrWE(PrWE), .PrWD(PrWD), .IRQ0(IRQ0), .IRQ1(IRQ1), .interrupt(interrupt), 
						.DEV0_RD(DEV0_RD), .DEV1_RD(DEV1_RD), .PrRD(PrRD), .HWInt(HWInt), .Addr(Addr),
						.WE0(WE0), .WE1(WE1), .DEV_WD(DEV_WD));
	TC timer0 (.clk(clk), .reset(reset), .Addr(Addr), .WE(WE0), .Din(DEV_WD), .Dout(DEV0_RD), .IRQ(IRQ0));
	TC timer1 (.clk(clk), .reset(reset), .Addr(Addr), .WE(WE1), .Din(DEV_WD), .Dout(DEV1_RD), .IRQ(IRQ1));

endmodule
