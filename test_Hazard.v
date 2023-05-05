`timescale 1ns / 1ps

module test_Hazard();
   reg clk;
   reg reset;
   wire [63:0] PC_In;
   wire [63:0] PC_Out;
   wire [31:0] instruction;
   wire [6:0] opcode;
   wire [4:0] rs1;
   wire [4:0] rs2;
   wire [4:0] rd;
   wire [63:0] WriteData;
   wire [63:0] ReadData1;
   wire [63:0] ReadData2;
   wire Branch, MemWrite, MemRead, MemtoReg;
   wire [1:0] ALUOp;
   wire ALUSrc, RegWrite;
   wire [63:0] Result;
   wire [63:0] read_mem_data;
   wire [63:0] imm;
   wire [63:0] ALU_input2;
   wire [63:0] a;
    wire [63:0] b;
    wire [63:0] c;
    wire [63:0] d;
    wire [63:0] e;
    wire [63:0] f;

Processor_Hazard r1(clk, reset, PC_In, PC_Out, instruction, opcode, rs1, rs2, rd, WriteData, ReadData1,ReadData2, Branch, MemWrite, MemRead, MemtoReg, ALUOp, ALUSrc, RegWrite, Result,  read_mem_data,imm, ALU_input2,a,b,c,d,e,f);

initial begin

clk = 1'b0; 
reset = 1'b1;
#20 reset = 1'b0;

end
always
#5 clk = ~clk;
endmodule
