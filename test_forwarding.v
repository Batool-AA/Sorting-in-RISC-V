`timescale 1ns / 1ps

module test_forwarding();
   reg clk;
   reg reset;
   wire [63:0] PC_In;  //prev inst add
   wire [63:0] PC_Out;  //new ins add
   wire [31:0] instruction;  //ins
   wire [6:0] opcode; //opcode
   wire [4:0] rs1;
   wire [4:0] rs2;
   wire [63:0] imm;
   wire [63:0] Result; //Mem_Add
   wire [63:0] read_mem_data;
   wire Zero;
   wire [4:0] rd;
   wire [63:0] WriteData; //in rd
   wire [63:0] ReadData1;
   wire [63:0] ReadData2; //writedata (mem)
   wire Branch, MemWrite, MemRead, MemtoReg;
   wire [1:0] ALUOp;
   wire ALUSrc, RegWrite;
   wire [1:0] ForwardA, ForwardB;
   wire [63:0] element1, element2, element3, element4, element5, element6;
   
Processor_Forwarding r1(clk, reset, PC_In, PC_Out, instruction, opcode, rs1, rs2, imm,rd, Result,  read_mem_data,Zero, WriteData, ReadData1,ReadData2, Branch, MemWrite, MemRead, MemtoReg, ALUOp, ALUSrc, RegWrite,  ForwardA, ForwardB, element1, element2, element3, element4, element5, element6);

initial begin

clk = 1'b0; 
reset = 1'b1;
#20 reset = 1'b0;

end
 always
 #10 clk = ~clk;
 
endmodule