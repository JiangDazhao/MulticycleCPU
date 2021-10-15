`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 06:57:13
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(
     input [31:0] IAddr,    //ָ���ַ
    output [31:0] IDataOut  //ָ��
    );
    
    reg [7:0] ROM [0:127];
    
    //����ROM��
    initial begin
        $readmemb("C:/Users/27801/Desktop/918106840727_MultiCycleCpu/instructions.txt", ROM);
    end
    
    //MIPS���ֽ�С��ģʽȡ��
    assign IDataOut[31:24] = ROM[IAddr+0];
    assign IDataOut[23:16] = ROM[IAddr+1];
    assign IDataOut[15:8]  = ROM[IAddr+2];
    assign IDataOut[7:0]   = ROM[IAddr+3];
    
endmodule
