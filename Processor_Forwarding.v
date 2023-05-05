`timescale 1ns / 1ps

module Processor_Forwarding( 

    input clk, reset, 

    output wire [63:0] PC_In,  //prev inst add 

    output wire [63:0] PC_Out,  //new ins add 

    output wire [31:0] instruction,  //ins 

    output wire [6:0] opcode, //opcode 

   output wire [4:0] rs1, 

   output wire [4:0] rs2, 

   output  wire [63:0]imm_data,

   output wire [4:0] rd_MEMWB, 

    output wire [63:0] Result, //Mem_Add 

   output wire [63:0] read_mem_data,

   output wire ZERO,
   
   output wire [63:0] WriteData, //in rd 

   output wire [63:0] ReadData1, 

   output wire [63:0] ReadData2, //writedata (mem) 

   output wire Branch_EXMEM, MemWrite_EXMEM, MemRead_EXMEM, MemtoReg_MEMWB, 

   output wire [1:0] ALUOp_IDEX, 

   output wire ALUSrc_IDEX, RegWrite_MEMWB,
   
   output wire [1:0] ForwardA,
   
   output wire [1:0] ForwardB,
   
    output wire [63:0] element1, element2, element3, element4, element5, element6
); 

wire [63:0] ALU_input2;

wire[63:0] branch_adder;

wire[63:0] imm;

wire [31:0]  instruction_IFID;

wire [63:0] PC_Out_IFID;

wire [3:0] operation;

wire [63:0] normal_adder; 

wire [2:0] funct3; 

wire [6:0] funct7; 

wire [3:0] Func; 

wire [63:0] PC_Out_IDEX,ReadData1_IDEX,ReadData2_IDEX,imm_data_IDEX;

wire [3:0] Func_IDEX;

wire [4:0] rd_IDEX, rs1_IDEX, rs2_IDEX;

wire MemtoReg_IDEX, RegWrite_IDEX,Branch_IDEX, MemWrite_IDEX, MemRead_IDEX,ALUSrc;

wire [1:0] ALUOp;

wire [2:0] funct3_IDEX;

wire RegWrite_EXMEM, MemtoReg_EXMEM, Branch, ZERO_EXMEM, MemWrite, MemRead;

wire [63:0] branch_adder_EXMEM, Result_EXMEM, ReadData2_EXMEM;

wire [3:0] Func_EXMEM;

wire [4:0] rd_EXMEM;

wire RegWrite, MemtoReg;

wire [63:0] read_mem_data_MEMWB,Result_MEMWB;

wire [4:0] rd;

assign Func[3] = instruction[30]; 

assign Func[2:0] = instruction[14:12]; 

wire [63:0] ALU_input1, Mux_input0;


Mux m1 (normal_adder, branch_adder_EXMEM, Branch&ZERO, PC_In); //PC src, deciding which pc_in to use

Program_Counter p1 (clk,reset,PC_In, PC_Out); //Program counter taking in PC_in from the adders and giving a pc_out 

Adder a1 (PC_Out, 64'b100, normal_adder); //adder adding 4 to take to the next instruction 

Instruction_Memory i1 (PC_Out,instruction); //reading the instruction 

IF_ID u1(clk,PC_Out,instruction,PC_Out_IFID,instruction_IFID);

InsParser in1(instruction_IFID,opcode,rd,funct3,rs1,rs2,funct7); //decoding the instruction 

Control_Unit c1 (opcode,Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp); //control unit giving the control signals 

ImmGen im1(instruction_IFID,imm_data);  //immediate generation of the immediate value 

registerFile r1 (WriteData,rs1,rs2,rd_MEMWB,RegWrite, clk, reset,ReadData1,ReadData2);  //working in the register block 

ID_EX u2(clk,PC_Out_IFID,ReadData1,ReadData2,imm_data,Func,rd,rs1,rs2,MemtoReg, RegWrite,Branch, MemWrite, MemRead,ALUSrc,ALUOp,funct3,PC_Out_IDEX,ReadData1_IDEX,ReadData2_IDEX,imm_data_IDEX,Func_IDEX,rd_IDEX,rs1_IDEX, rs2_IDEX,MemtoReg_IDEX, RegWrite_IDEX,Branch_IDEX, MemWrite_IDEX, MemRead_IDEX,ALUSrc_IDEX,ALUOp_IDEX,funct3_IDEX);

ALU_Control alu_c1 (ALUOp_IDEX, Func_IDEX,operation); //deciding the operation for alu 

mux_3_bit m3_1 (ReadData1_IDEX, WriteData, Result_EXMEM, ForwardA, ALU_input1);

mux_3_bit m3_2 (ReadData2_IDEX, WriteData, Result_EXMEM, ForwardB, Mux_input0);

Mux m2 (Mux_input0, imm_data_IDEX, ALUSrc_IDEX, ALU_input2); //ALU src, deciding what goes to the alu 

ALU_64_bit alu1 (ALU_input1, ALU_input2, operation,funct3_IDEX, Result, ZERO); //alu performing the said operation 

Forwarding_Unit f1 (rd_EXMEM, rd_MEMWB, rs1_IDEX, rs2_IDEX,  RegWrite_EXMEM, RegWrite_MEMWB, ForwardA, ForwardB);

Adder a2 (PC_Out_IDEX, imm_data_IDEX << 1, branch_adder); //adder adding in the branch value 

EX_MEM u3 (clk,RegWrite_IDEX, MemtoReg_IDEX, Branch_IDEX, ZERO, MemWrite_IDEX, MemRead_IDEX,branch_adder, Result, Mux_input0,Func_IDEX,rd_IDEX,RegWrite_EXMEM, MemtoReg_EXMEM, Branch_EXMEM, ZERO_EXMEM, MemWrite_EXMEM, MemRead_EXMEM,branch_adder_EXMEM, Result_EXMEM, ReadData2_EXMEM,Func_EXMEM,rd_EXMEM);

Data_Memory d1(Result_EXMEM,ReadData2_EXMEM, clk, MemWrite_EXMEM, MemRead_EXMEM,read_mem_data, element1, element2, element3, element4, element5, element6); //working with the data memeory 

MEM_WB u4(clk,RegWrite_EXMEM, MemtoReg_EXMEM,read_mem_data,Result_EXMEM,rd_EXMEM,RegWrite_MEMWB, MemtoReg_MEMWB,read_mem_data_MEMWB,Result_MEMWB,rd_MEMWB);

Mux m3 (Result_MEMWB, read_mem_data_MEMWB, MemtoReg_MEMWB, WriteData); //deciding which data to write back 
endmodule
