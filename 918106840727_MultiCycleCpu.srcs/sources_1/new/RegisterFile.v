`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 07:06:10
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input clk,     //时钟
    input Reset,    //置零信号
    input WE,    // 寄存器堆写使能，1为有效
    input [4:0] ReadReg1,   //寄存器地址输入端口（rs）
    input [4:0] ReadReg2,   //寄存器地址输入端口（rt）
    input [4:0] WriteReg,   //将数据写入的寄存器端口，地址来自于rt或rd
    input [31:0] WriteData, //写入寄存器的数据端口
    output [31:0] ReadData1, //寄存器数据输出端口(rs)
    output [31:0] ReadData2  //寄存器数据输出端口(rt)
    );
    
    //新建32个32位寄存器
    reg [31:0] register [0:31];
    integer i;
    
    //读寄存器
    assign ReadData1 = (ReadReg1 == 0) ? 0 : register[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0) ? 0 : register[ReadReg2];
    
    //写寄存器
    always @(negedge clk or negedge Reset) begin
        if(Reset == 0) begin
            for(i = 1; i <= 31; i=i+1) begin
                register[i] <= 0;
            end
        end
        else if(WE == 1 && WriteReg != 0)
            register[WriteReg] <= WriteData;
    end
endmodule
