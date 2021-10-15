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
    input clk,     //ʱ��
    input Reset,    //�����ź�
    input WE,    // �Ĵ�����дʹ�ܣ�1Ϊ��Ч
    input [4:0] ReadReg1,   //�Ĵ�����ַ����˿ڣ�rs��
    input [4:0] ReadReg2,   //�Ĵ�����ַ����˿ڣ�rt��
    input [4:0] WriteReg,   //������д��ļĴ����˿ڣ���ַ������rt��rd
    input [31:0] WriteData, //д��Ĵ��������ݶ˿�
    output [31:0] ReadData1, //�Ĵ�����������˿�(rs)
    output [31:0] ReadData2  //�Ĵ�����������˿�(rt)
    );
    
    //�½�32��32λ�Ĵ���
    reg [31:0] register [0:31];
    integer i;
    
    //���Ĵ���
    assign ReadData1 = (ReadReg1 == 0) ? 0 : register[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0) ? 0 : register[ReadReg2];
    
    //д�Ĵ���
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
