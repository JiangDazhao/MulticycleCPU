`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 09:14:10
// Design Name: 
// Module Name: DFlipFlop_32bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DFlipFlop_32bits(
    input clk,
    input Reset,
    input [31:0] in,
    output reg [31:0] out
    );
    
    always @(posedge clk/* or negedge Reset*/) begin
        //if(Reset==0) out <= 0;
        /*else*/ out <= in;
    end
endmodule
