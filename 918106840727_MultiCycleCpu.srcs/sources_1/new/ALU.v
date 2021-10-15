`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 07:14:46
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0] ALUOp,  //ALU��������
    input [31:0] A,     //����1
    input [31:0] B,     //����2
    output reg [31:0] result,   //ALU������
    output zero    // ����Ƿ�Ϊ0�ı�ʶ����Ϊ1����Ϊ0
    );
    
    assign zero = (result == 0) ? 1 : 0; // ����Ƿ�Ϊ0����Ϊ1����Ϊ0
    
    always @(ALUOp or A or B) begin
        //����ѡ��
        case(ALUOp)
            4'b0000: result = A + B;
            4'b0001: result = A - B;
            4'b0010: result = B << A;
            4'b0011: result = B >> A;
            4'b0100: result = A | B;
            4'b0101: result = A & B;
            4'b0110: result = (A < B) ? 1 : 0; 
            4'b0111: begin                     
                        if((A[31] == B[31]) && (A < B)) result = 1;
                        else if(A[31]==1 && B[31]==0) result = 1;
                        else result = 0;
                    end
            4'b1000: result = (A > B) ? 1 : 0; 
            4'b1001: begin                     
                        if((A[31] == B[31]) && (A > B)) result = 1;
                        else if(A[31]==0 && B[31]==1) result = 1;
                        else result = 0;
                    end       
            4'b1010: result = A ^ B;
            4'b1011: result = ~(A|B);
        endcase
    end
endmodule
