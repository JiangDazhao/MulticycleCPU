`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 09:12:16
// Design Name: 
// Module Name: Multiplexer21_32bits
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


module Multiplexer21_32bits(
    input choice,
    input [31:0] in0,
    input [31:0] in1,
    output [31:0] out
    );
    
    assign out = (choice==0) ? in0 : in1;
    
endmodule
