`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/03 22:54:21
// Design Name: 
// Module Name: MultiCycleCpu
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


module MultiCycleCpu(
    input clk,
    input Reset,
    output [31:0] currentIAddr,
    output [31:0] nextIAddr,
    output [4:0] rs, rt,
    output [31:0] ReadData1, //rs��������
    output [31:0] ReadData2, //rt��������
    output [31:0] ALU_result, //ALU���
    output [31:0] DataBus //DBDR������
    );
    
    /* ��Ҫ�õ������ݱ��� */
    wire [31:0] bincode;  //IR out binary codes
    wire [31:0] IDataOut; //InstructionMemory out
    wire [31:0] ALU_inA; 
    wire [31:0] ALU_inB; 
    wire [31:0] DataOut; //DataMemory���
    wire [5:0] opcode;
    wire ALU_zero;
    wire [15:0] immediate;
    wire [31:0] extended;
    wire [5:0] func;
    wire [31:0] ADR_out, BDR_out, ALUoutDR_out, DataBus_before;
    wire [4:0] rd;
    
    //�������밴��MIPSָ���ʽ���л���
    assign opcode = bincode[31:26];
    assign rs = bincode[25:21];
    assign rt = bincode[20:16];
    assign rd = bincode[15:11];
    assign immediate = bincode[15:0];
    assign func =  immediate[5:0];

    
    /* �����ź� */
    wire InsMemRW;//��дָ��Ĵ���,����Ϊֻ��
    wire PCWre; //PC�޸�
    wire ALUSrcA;//ALU�����������Դ��ʽ
    wire ALUSrcB;//ALU�����������Դ��ʽ
    wire DBDataSrc;//ALU�����������ݴ洢�����
    wire RegWre; //�洢��д
    wire WrRegDSrc;//�洢��д��������Դ
    wire mRD;//���ݴ洢����
    wire mWR; //���ݴ洢��д
    wire IRWre;//ָ��洢��д
    wire ExtSel;//λ��չ����
    wire [1:0] PCSrc; //PC�ı�ķ�ʽ
    wire [1:0] RegDst; //д������Ĵ�����ļĴ�����ַ
    wire [3:0] ALUOp;  //ALU�Ĺ���ѡ��
    
    wire [4:0] WriteReg;  //д��Register�ļĴ�����
    wire [31:0] WriteData; //д��Register������
    
    /* CPU�Ĺؼ����� */
    ControlUnit ControlUnit(
        .clk(clk), .rst(Reset),
        .zero(ALU_zero), 
        .opcode(opcode),
        .func(func),
        .PCWre(PCWre), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .DBDataSrc(DBDataSrc), .RegWre(RegWre), .WrRegDSrc(WrRegDSrc), .InsMemRW(InsMemRW), .mRD(mRD), .mWR(mWR), .IRWre(IRWre), .ExtSel(ExtSel),
        .PCSrc(PCSrc),
        .RegDst(RegDst),
        .ALUOp(ALUOp)
    );
    PC PC(
        .clk(clk), .Reset(Reset), .PCWre(PCWre), .nextIAddr(nextIAddr),
        .currentIAddr(currentIAddr)
    );
    InstructionMemory InstructionMemory(
        .IAddr(currentIAddr),
        .IDataOut(IDataOut)
    );
    RegisterFile RegisterFile(
        .clk(clk), .Reset(Reset), .WE(RegWre),
        .ReadReg1(rs), .ReadReg2(rt), .WriteReg(WriteReg), .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );
    ALU ALU(
        .ALUOp(ALUOp), .A(ALU_inA), .B(ALU_inB),
        .result(ALU_result), .zero(ALU_zero)
    );
    DataMemory DataMemory(
        .clk(clk), .DAddr(ALU_result), .DataIn(ReadData2), .RD(mRD), .WR(mWR),
        .DataOut(DataOut)
    );
    ImmediateExtend ImmediateExtend(
        .original(immediate), .ExtSel(ExtSel),
        .extended(extended)
    );
    
    
    /*�з�����ͨ·*/
    //�洢ָ�ת��Ϊ��������
    IR IR(
        .clk(clk), .IRWre(IRWre), .insIn(IDataOut),
        .insOut(bincode)
    );
    //�洢Register File�г�����ReadData1
    DFlipFlop_32bits ADR(
        .clk(clk), .Reset(Reset), .in(ReadData1),
        .out(ADR_out)
    );
    //�洢Register File�г�����ReadData2
    DFlipFlop_32bits BDR(
        .clk(clk), .Reset(Reset), .in(ReadData2),
        .out(BDR_out)
    );
    //�洢ALU������result
    DFlipFlop_32bits ALUoutDR(
        .clk(clk), .Reset(Reset), .in(ALU_result),
        .out(ALUoutDR_out)
    );
    //�洢DBDR֮ǰ��ѡ����������ALU result����DataMemory DataOut
    DFlipFlop_32bits DBDR(
        .clk(clk), .Reset(Reset), .in(DataBus_before),
        .out(DataBus)
    );
    
    
    /* ����ѡ���� */
    //��PCSrc��Ӧ��PC�ĵ�ַ�ı䷽ʽ
    Multiplexer41_32bits Mux_nextIAddr(
        .choice(PCSrc), .in0(currentIAddr+4), .in1(currentIAddr+4+(extended<<2)), .in2(ReadData1), .in3({currentIAddr[31:28], bincode[25:0], 2'b00}),
        .out(nextIAddr)
    );
    //��RegDst��Ӧ��������д��Ĵ�����ļĴ�����ַ
    Multiplexer41_5bits Mux_WriteReg(
        .choice(RegDst), .in0(5'd31), .in1(rt), .in2(rd), .in3(5'bzzzzz),
        .out(WriteReg)
    );
    //��WrRegDSrc��Ӧ��д��Ĵ����������
    Multiplexer21_32bits Mux_WriteData(
        .choice(WrRegDSrc), .in0(currentIAddr+4), .in1(DataBus),
        .out(WriteData)
    );
    //��ALUSrcA��Ӧ��ALU A�˿ڵ�������Դ
    Multiplexer21_32bits Mux_ALU_inA(
        .choice(ALUSrcA), .in0(ADR_out), .in1({27'd0, immediate[10:6]}),
        .out(ALU_inA)
    );
    //��ALUSrcB��Ӧ��ALU B�˿ڵ�������Դ
    Multiplexer21_32bits Mux_ALU_inB(
        .choice(ALUSrcB), .in0(BDR_out), .in1(extended),
        .out(ALU_inB)
    );
    //��DBDataSrc��Ӧ������DBDR�е�������Դ
    Multiplexer21_32bits Mux_DBDR(
        .choice(DBDataSrc), .in0(ALU_result), .in1(DataOut),
        .out(DataBus_before)
    );
endmodule
