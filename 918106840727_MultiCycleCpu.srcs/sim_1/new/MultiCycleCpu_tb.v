`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 15:38:43
// Design Name: 
// Module Name: MultiCycleCpu_tb
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


module MultiCycleCpu_tb(
    );
    reg clk, Reset;
    wire [31:0] currentIAddr, nextIAddr;
    wire [4:0] rs, rt;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ALU_result, DataBus;
    
    MultiCycleCpu cpu(
        .clk(clk),
        .Reset(Reset),
        .currentIAddr(currentIAddr), .nextIAddr(nextIAddr),
        .rs(rs), .rt(rt),
        .ReadData1(ReadData1), .ReadData2(ReadData2),
        .ALU_result(ALU_result), .DataBus(DataBus)
    );
    
    always #50 clk = ~clk;    // 仿真时钟周期为100ns
    
    initial begin
        clk = 1;
        Reset = 0;
        #25;
        Reset = 1;    // 开始仿真
        #14000;        // 进行13000ns的仿真
        $stop;  // 断点
    end
endmodule
