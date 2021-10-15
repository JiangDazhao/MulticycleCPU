`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 06:49:27
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,                          //时钟
    input Reset,                        //重置信号
    input PCWre,                        //PC是否更改，为0不更改
    input [31:0] nextIAddr,             //新指令
    output reg [31:0] currentIAddr      //当前指令
    );
    initial currentIAddr <= 0;          
    always @(posedge clk or negedge Reset) begin
        if(Reset == 0) currentIAddr <= 0;           //  重置
        else begin
            if(PCWre == 1) currentIAddr <= nextIAddr;   //PC更改
            else currentIAddr <= currentIAddr;
        end
    end
endmodule
