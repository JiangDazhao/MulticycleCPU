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
    input clk,                          //ʱ��
    input Reset,                        //�����ź�
    input PCWre,                        //PC�Ƿ���ģ�Ϊ0������
    input [31:0] nextIAddr,             //��ָ��
    output reg [31:0] currentIAddr      //��ǰָ��
    );
    initial currentIAddr <= 0;          
    always @(posedge clk or negedge Reset) begin
        if(Reset == 0) currentIAddr <= 0;           //  ����
        else begin
            if(PCWre == 1) currentIAddr <= nextIAddr;   //PC����
            else currentIAddr <= currentIAddr;
        end
    end
endmodule
