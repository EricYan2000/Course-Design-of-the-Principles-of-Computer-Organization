`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:01:12 12/17/2019 
// Design Name: 
// Module Name:    bridge 
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
module bridge(
    input [31:0] PrAddr,
    input PrWE,
    input [31:0] PrWD,
    input IRQ0,
    input IRQ1,
    input interrupt,
    input [31:0] DEV0_RD,
    input [31:0] DEV1_RD,

    output [31:0] PrRD,
    output [5:0] HWInt,
    output [31:0] Addr,
    output WE0,
    output WE1,
    output [31:0] DEV_WD
    );

    wire [31:0] addr_32;
    assign addr_32 = PrAddr;       //special way of writing//ISE's feature. adapt to it

    assign HWInt = {3'b000, interrupt, IRQ1, IRQ0};
    assign Addr = PrAddr;
    assign PrRD = ((addr_32 >= 32'h0000_7f00) && (addr_32 <= 32'h0000_7f0b)) ? DEV0_RD :
                  ((addr_32 >= 32'h0000_7f10) && (addr_32 <= 32'h0000_7f1b)) ? DEV1_RD :  
                  32'hx;  
    assign WE0 = ((addr_32 >= 32'h0000_7f00) && (addr_32 <= 32'h0000_7f0b) && PrWE && (addr_32[1:0] == 2'b00)) ? 1'b1 :
                 1'b0;
    assign WE1 = ((addr_32 >= 32'h0000_7f10) && (addr_32 <= 32'h0000_7f1b) && PrWE && (addr_32[1:0] == 2'b00)) ? 1'b1 :
                 1'b0;
    assign DEV_WD = PrWD;

endmodule
