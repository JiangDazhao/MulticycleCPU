`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 08:50:17
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk,
    input [31:0] DAddr,    //数据存储器地址输入端口
    input [31:0] DataIn,   //数据存储器数据输入端口
    input RD,    // 读控制，1有效
    input WR,    // 写控制，1有效
    output [31:0] DataOut    // 读出32位数据
    );
    
    // 每个内存单元为8位，即一个字节，共有8个64位内存
    reg [7:0] RAM [0:63];    
    
    //读内存，为组合逻辑
    //RD=1，则字节读入，否则为高阻态
    assign DataOut[7:0]   = (RD==1) ? RAM[DAddr+3] : 8'bz;
    assign DataOut[15:8]  = (RD==1) ? RAM[DAddr+2] : 8'bz;
    assign DataOut[23:16] = (RD==1) ? RAM[DAddr+1] : 8'bz;
    assign DataOut[31:24] = (RD==1) ? RAM[DAddr+0] : 8'bz;
    
    //写内存，为时序逻辑
    //WR=1，则字节写入
    always @(negedge clk) begin
        if(WR == 1) begin
            RAM[DAddr+0] <= DataIn[31:24];
            RAM[DAddr+1] <= DataIn[23:16];
            RAM[DAddr+2] <= DataIn[15:8];
            RAM[DAddr+3] <= DataIn[7:0];
        end
    end
endmodule
