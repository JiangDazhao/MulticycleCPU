`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 20:50:38
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input clk, rst,
    input zero,
    input [5:0] opcode,//������
    input [5:0] func,//���������Ӷ�
    output wire InsMemRW,//��дָ��Ĵ���,����Ϊֻ��
    output reg PCWre, //PC�޸�
    output reg ALUSrcA,//ALU�����������Դ��ʽ
    output reg ALUSrcB,//ALU�����������Դ��ʽ
    output reg DBDataSrc,//ALU�����������ݴ洢�����
    output reg RegWre, //�洢��д
    output reg WrRegDSrc,//�洢��д��������Դ
    output reg mRD,//���ݴ洢����
    output reg mWR, //���ݴ洢��д
    output reg IRWre,//ָ��洢��д
    output reg ExtSel,//λ��չ����
    output reg [1:0] PCSrc, //PC�ı�ķ�ʽ
    output reg [1:0] RegDst, //д�Ĵ�����ַ����Դ
    output reg [3:0] ALUOp  //ALU�Ĺ���ѡ��
    );
    
    reg [2:0] state;
    assign InsMemRW = 1;    // ָ��洢��ֻ��
    
    
    /* �Զ���״̬ת�� */
    always @(posedge clk or negedge rst) begin
        if(rst==0) begin
            state <= 3'b000;
            PCWre <= 1;
            IRWre <= 1;
        end
        else begin
            case(state)
                3'b000: state <= 3'b001;
                3'b001: begin
                        if(opcode==6'b000100 
                        || opcode==6'b000101) 
                        state <= 3'b101;
                        else 
                        if(opcode==6'b101011 
                        || opcode==6'b100011)
                         state <= 3'b010;
                        else 
                        if(opcode==6'b000010 
                        || opcode==6'b000011 
                        || (opcode==6'b000000 && func==6'b001000))
                            state <= 3'b000;
                        else state <= 3'b110;
                    end
                3'b110: state <= 3'b111;
                3'b010: state <= 3'b011;
                3'b011: begin
                        if(opcode==6'b100011) state <= 3'b100;
                        else state <= 3'b000;
                    end
                3'b111, 3'b101, 3'b100: state <= 3'b000;
            endcase
        end
    end
    
    /* �źſ��� */
    //��Ӧָ���״̬���������ź�
    always @(state or opcode or func or zero) begin //���������źŸı�  
      case(opcode)
       6'b000000:begin
          case(func)
            6'b100000:begin  // add
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
            6'b100001:begin  // addu
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
            6'b100010:begin  // sub
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0001;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end      
            6'b100011:begin  // subu
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0001;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
            6'b100100:begin  // and
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0101;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
            6'b100101:begin  // or
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0100;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
            6'b100110:begin  // xor
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_1010;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
            6'b100111:begin  // nor
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_1011;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
            6'b000000: begin  // sll
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b100100_00_10_0010;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
           end
           6'b000010:begin  // srl
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b100100_00_10_0011;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
           end
           6'b101010:begin  // slt
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0111;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
           6'b101011:begin  // sltu
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_00_10_0110;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
            end
           6'b001000:begin  // jr
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_10_00_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                endcase
           end
       endcase 
       end
       6'b001000:begin  // addi
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010101_00_01_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
       end
       6'b001001:begin  // addiu
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010100_00_01_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
       end
       6'b001100:begin  // andi
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010100_00_01_0101;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
       end
       6'b001101:begin  // ori
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010100_00_01_0100;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
       end
       6'b001110:begin  // xori
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010100_00_01_1010;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
       end
       6'b001010:begin  // slti
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010101_00_01_0111;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
       end
       6'b001011:begin  // sltiu
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010100_00_01_0110;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b110: {IRWre, mWR, RegWre} = 4'b100;
                    3'b111: {IRWre, mWR, RegWre} = 4'b101;
                endcase
        end
       6'b101011:begin  // sw
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b010101_00_00_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b010: {IRWre, mWR, RegWre} = 4'b100;
                    3'b011: {IRWre, mWR, RegWre} = 4'b110;
                endcase
        end
       6'b100011:begin  // lw
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b011111_00_01_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                    3'b010: {IRWre, mWR, RegWre} = 4'b100;
                    3'b011: {IRWre, mWR, RegWre} = 4'b100;
                    3'b100: {IRWre, mWR, RegWre} = 4'b101;
                endcase
       end
       6'b000100:begin  // beq
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, RegDst[1:0], ALUOp[3:0]} <= 12'b000101_00_0001;
                PCSrc[1:0] <= (zero==1) ? 2'b01 : 2'b00;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    default: {IRWre, mWR, RegWre} = 4'b100;
                endcase
       end
       6'b000101:begin  // bne
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, RegDst[1:0], ALUOp[3:0]} <= 12'b000101_00_0001;
                PCSrc[1:0] <= (zero==0) ? 2'b01 : 2'b00;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    default: {IRWre, mWR, RegWre} = 4'b100;
                endcase
       end
       6'b000010:begin  // j
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000100_11_00_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b100;
                endcase
       end
       6'b000011:begin  // jal
                {ALUSrcA, ALUSrcB, DBDataSrc, WrRegDSrc, mRD, ExtSel, PCSrc[1:0], RegDst[1:0], ALUOp[3:0]} <= 14'b000000_11_00_0000;
                case(state)
                    3'b000: {IRWre, mWR, RegWre} = 4'b100;
                    3'b001: {IRWre, mWR, RegWre} = 4'b101;  // jal��ID�׶Σ�001��д�Ĵ���
                endcase
       end  
       endcase       
    end         

    always @(negedge clk) begin
        case(state)
            3'b111, 3'b101, 3'b100: PCWre <= 1;
            3'b011: PCWre <= (opcode==6'b101011 ? 1 : 0);   // sw
            3'b001: PCWre <= (opcode==6'b000010||opcode==6'b000011||(opcode==6'b000000&&func==6'b001000) ? 1 : 0);  // j, jr, jal
            default: PCWre <= 0;
        endcase
    end
    
    
    
endmodule
