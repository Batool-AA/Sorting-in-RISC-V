`timescale 1ns / 1ps

module test_processor();
   reg clk;
   reg reset;
   wire [63:0] PC_In;  //prev inst add
   wire [63:0] PC_Out;  //new ins add
   wire [31:0] Instruction;  //ins
   wire [6:0] opcode; //opcode
   wire [4:0] rs1;
   wire [4:0] rs2;
   wire [4:0] rd;
   wire [63:0] WriteData; //in rd
   wire [63:0] ReadData1;
   wire [63:0] ReadData2; //writedata (mem)
   wire [63:0] Result; //Mem_Add
   wire [63:0] read_mem_data;
   wire Branch, MemWrite, MemRead, MemtoReg;
    wire ALUSrc, RegWrite;
    wire [1:0] ALUOp;
    wire [63:0] imm_data;
    wire [63:0] ALU_input2;
    wire [63:0] a;
    wire [63:0] b;
    wire [63:0] c;
    wire [63:0] d;
    wire [63:0] e;
    wire [63:0] f;
    
RISC_V_Processor r1(clk, reset, PC_In, PC_Out, Instruction, opcode, rs1, rs2, rd, WriteData, ReadData1,ReadData2, Result,  read_mem_data, Branch, MemWrite, MemRead, MemtoReg,ALUSrc, RegWrite,ALUOp, imm_data, ALU_input2, a,b,c,d,e,f);

initial begin

clk = 1'b0; 
reset = 1'b1;
#5 reset = 1'b0;
end
 always
 #10 clk = ~clk;
endmodule




