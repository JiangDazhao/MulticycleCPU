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
    output [31:0] ReadData1, //rs读出数据
    output [31:0] ReadData2, //rt读出数据
    output [31:0] ALU_result, //ALU输出
    output [31:0] DataBus //DBDR的数据
    );
    
    /* 需要用到的数据变量 */
    wire [31:0] bincode;  //IR out binary codes
    wire [31:0] IDataOut; //InstructionMemory out
    wire [31:0] ALU_inA; 
    wire [31:0] ALU_inB; 
    wire [31:0] DataOut; //DataMemory输出
    wire [5:0] opcode;
    wire ALU_zero;
    wire [15:0] immediate;
    wire [31:0] extended;
    wire [5:0] func;
    wire [31:0] ADR_out, BDR_out, ALUoutDR_out, DataBus_before;
    wire [4:0] rd;
    
    //二进制码按照MIPS指令格式进行划分
    assign opcode = bincode[31:26];
    assign rs = bincode[25:21];
    assign rt = bincode[20:16];
    assign rd = bincode[15:11];
    assign immediate = bincode[15:0];
    assign func =  immediate[5:0];

    
    /* 控制信号 */
    wire InsMemRW;//读写指令寄存器,设置为只读
    wire PCWre; //PC修改
    wire ALUSrcA;//ALU运算的数据来源格式
    wire ALUSrcB;//ALU运算的数据来源格式
    wire DBDataSrc;//ALU结果输出或数据存储器输出
    wire RegWre; //存储器写
    wire WrRegDSrc;//存储器写的数据来源
    wire mRD;//数据存储器读
    wire mWR; //数据存储器写
    wire IRWre;//指令存储器写
    wire ExtSel;//位拓展类型
    wire [1:0] PCSrc; //PC改变的方式
    wire [1:0] RegDst; //写结果到寄存器组的寄存器地址
    wire [3:0] ALUOp;  //ALU的功能选择
    
    wire [4:0] WriteReg;  //写入Register的寄存器号
    wire [31:0] WriteData; //写入Register的数据
    
    /* CPU的关键部件 */
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
    
    
    /*切分数据通路*/
    //存储指令，转换为二进制码
    IR IR(
        .clk(clk), .IRWre(IRWre), .insIn(IDataOut),
        .insOut(bincode)
    );
    //存储Register File中出来的ReadData1
    DFlipFlop_32bits ADR(
        .clk(clk), .Reset(Reset), .in(ReadData1),
        .out(ADR_out)
    );
    //存储Register File中出来的ReadData2
    DFlipFlop_32bits BDR(
        .clk(clk), .Reset(Reset), .in(ReadData2),
        .out(BDR_out)
    );
    //存储ALU出来的result
    DFlipFlop_32bits ALUoutDR(
        .clk(clk), .Reset(Reset), .in(ALU_result),
        .out(ALUoutDR_out)
    );
    //存储DBDR之前的选择器出来的ALU result或者DataMemory DataOut
    DFlipFlop_32bits DBDR(
        .clk(clk), .Reset(Reset), .in(DataBus_before),
        .out(DataBus)
    );
    
    
    /* 数据选择器 */
    //与PCSrc对应，PC的地址改变方式
    Multiplexer41_32bits Mux_nextIAddr(
        .choice(PCSrc), .in0(currentIAddr+4), .in1(currentIAddr+4+(extended<<2)), .in2(ReadData1), .in3({currentIAddr[31:28], bincode[25:0], 2'b00}),
        .out(nextIAddr)
    );
    //与RegDst对应，将数据写入寄存器组的寄存器地址
    Multiplexer41_5bits Mux_WriteReg(
        .choice(RegDst), .in0(5'd31), .in1(rt), .in2(rd), .in3(5'bzzzzz),
        .out(WriteReg)
    );
    //与WrRegDSrc对应，写入寄存器组的数据
    Multiplexer21_32bits Mux_WriteData(
        .choice(WrRegDSrc), .in0(currentIAddr+4), .in1(DataBus),
        .out(WriteData)
    );
    //与ALUSrcA对应，ALU A端口的数据来源
    Multiplexer21_32bits Mux_ALU_inA(
        .choice(ALUSrcA), .in0(ADR_out), .in1({27'd0, immediate[10:6]}),
        .out(ALU_inA)
    );
    //与ALUSrcB对应，ALU B端口的数据来源
    Multiplexer21_32bits Mux_ALU_inB(
        .choice(ALUSrcB), .in0(BDR_out), .in1(extended),
        .out(ALU_inB)
    );
    //与DBDataSrc对应，区分DBDR中的数据来源
    Multiplexer21_32bits Mux_DBDR(
        .choice(DBDataSrc), .in0(ALU_result), .in1(DataOut),
        .out(DataBus_before)
    );
endmodule
