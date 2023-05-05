`timescale 1ns / 1ps


module Processor_Hazard(  

   input clk, reset,  
   output wire [63:0] PC_In,  //prev inst add  
   output wire [63:0] PC_Out,  //new ins add  
   output wire [31:0] instruction,  //ins  
   output wire [6:0] opcode, //opcode  
   output wire [4:0] rs1,  
   output wire [4:0] rs2,  
   output wire [4:0] MEM_WB_rd,  
   output wire [63:0] WriteData, //in rd  
   output wire [63:0] ReadData1,  
   output wire [63:0] ReadData2, //writedata (mem)  
   output wire EX_MEM_Branch, EX_MEM_MemWrite, EX_MEM_MemRead, MEM_WB_MemtoReg,  
   output wire [1:0] ID_EX_ALUOp,  
   output wire ID_EX_ALUSrc, MEM_WB_RegWrite,  
   output wire [63:0] Result, //Mem_Add  
   output wire [63:0] read_mem_data,  
   output  wire [63:0]imm_data,  
   output wire [63:0] ALU_input2,  
   output wire [63:0] a,
   output wire [63:0] b,
   output wire [63:0] c,
   output wire [63:0] d,
   output wire [63:0] e,
   output wire [63:0] f
);  
wire [3:0] operation;
wire ZERO;
wire [63:0] imm, branch_adder;
wire [63:0] normal_adder;  
wire [2:0] funct3;  
wire [6:0] funct7;  
wire [3:0] Func;  
//ID_EX wires
wire [63:0] ID_EX_PC_Out, ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_imm_data; 
wire [3:0] ID_EX_Func; 
wire [4:0] ID_EX_rd; 
wire ID_EX_MemtoReg, ID_EX_RegWrite, ID_EX_Branch, ID_EX_MemWrite, ID_EX_MemRead,ALUSrc; 
wire [1:0] ALUOp; 
wire [2:0] ID_EX_funct3; 
//EX_MEM_wires
wire EX_MEM_RegWrite, EX_MEM_MemtoReg, Branch, Zero1, MemWrite, MemRead; 
wire [63:0] EX_MEM_branch_adder, EX_MEM_Result, EX_MEM_ReadData2;
wire [3:0] EX_MEM_Func; 
wire [4:0] EX_MEM_rd; 
//MEM_WB_wires
wire RegWrite, MemtoReg; 
wire [63:0] MEM_WB_read_mem_data, MEM_WB_Result; 
wire [4:0] rd; 
wire [31:0]  ins;
wire [63:0] PC_Out1;
wire [63:0]  a_mux;
wire pc_wire;
wire is_lesser;
wire is_lesser1;
wire switch, Flushout;
wire ALUsrc_ID;
wire Branch_ID_EX;
wire RegWrite_ID_EX;
wire MemRead_ID_EX;
wire MemWrite_ID_EX;
wire MemtoReg_ID_EX;
wire [1:0]ALUop_ID_EX;
wire controlmux,IFID_Write,PCWrite;
wire [4:0]rs1_store, rs2_store;
  
Mux m1 (normal_adder, EX_MEM_branch_adder, switch, PC_In); //PC src, deciding which pc_in to use 
Program_Counter_h p1 (clk,reset,PCWrite,PC_In, PC_Out); //Program counter taking in PC_in from the adders and giving a pc_out  
Adder a1 (PC_Out, 64'b100, normal_adder); //adder adding 4 to take to the next instruction  
Instruction_Memory i1 (PC_Out,instruction); //reading the instruction  
IF_ID_h u1(clk,Flushout,IFID_Write,instruction,PC_Out,ins,PC_Out1); 
InsParser in1(ins,opcode,rd,funct3,rs1,rs2,funct7); //decoding the instruction  
assign Func[3] = ins[30];  
assign Func[2:0] = ins[14:12];
Control_Unit c1 (opcode,Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp); //control unit giving the control signals  
ImmGen im1(ins,imm_data);  //immediate generation of the immediate value  
Hazard_Detection h1(ID_EX_rd,rs1,rs2, ID_EX_MemRead,controlmux,IFID_Write, PCWrite);  
assign ALUsrc_ID = controlmux ? ALUSrc : 0;
assign Branch_ID_EX = controlmux ? Branch : 0;
assign RegWrite_ID_EX = controlmux ? RegWrite : 0;
assign MemRead_ID_EX = controlmux ? MemRead : 0;
assign MemWrite_ID_EX = controlmux ? MemWrite : 0;
assign MemtoReg_ID_EX = controlmux ? MemtoReg : 0;
assign ALUop_ID_EX = controlmux ? ALUOp : 2'b00;
registerFile_h r1 (WriteData,rs1,rs2, MEM_WB_rd, MEM_WB_RegWrite, clk, reset,ReadData1,ReadData2);  //working in the register block  
wire [2:0]funct3_ID_EX;
ID_EX_h u2(clk,Flushout,Branch_ID_EX,MemWrite_ID_EX,MemRead_ID_EX,MemtoReg_ID_EX,ALUsrc_ID,RegWrite_ID_EX,ALUop_ID_EX,PC_Out1,ReadData1,ReadData2,imm_data,Func,funct3,rd,rs1,rs2, ID_EX_Branch, ID_EX_MemWrite, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_RegWrite, ID_EX_ALUSrc, ID_EX_ALUOp, ID_EX_PC_Out, ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_imm_data, ID_EX_Func,funct3_ID_EX, ID_EX_rd,rs1_store,rs2_store);
assign imm = ID_EX_imm_data<<1;  
wire [63:0]  b_mux;
wire [1:0] fwd_A_out, fwd_B_out;
ALU_Control alu_c1 (ID_EX_ALUOp, ID_EX_Func,operation); //deciding the operation for alu  
mux_3_bit v3 (ID_EX_ReadData1,WriteData, EX_MEM_Result,fwd_A_out,a_mux);
mux_3_bit v4 (ID_EX_ReadData2,WriteData, EX_MEM_Result,fwd_B_out,b_mux);
Mux m2 (b_mux, ID_EX_imm_data, ID_EX_ALUSrc, ALU_input2); //ALU src, deciding what goes to the alu  
ALU_Hazard alu1 (a_mux, ALU_input2,operation ,funct3_ID_EX, Result, ZERO,is_lesser); //alu performing the said operation  
Forwarding_Unit v6(EX_MEM_rd, MEM_WB_rd,rs1_store,rs2_store, EX_MEM_RegWrite, MEM_WB_RegWrite,fwd_A_out,fwd_B_out);
Adder a2 (ID_EX_PC_Out, imm, branch_adder); //adder adding in the branch value  
wire [63:0]PC_Out3;
wire [63:0]b_muxout;
EX_MEM_h u3 (clk,Flushout,branch_adder,Result,ZERO,is_lesser,b_mux, ID_EX_rd, ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_Func,b_mux, EX_MEM_branch_adder, EX_MEM_Result,ZERO1,is_lesser1, EX_MEM_ReadData2, EX_MEM_rd, EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_Func,b_muxout); 
Branch_Control v8(EX_MEM_Branch,ZERO1,is_lesser1, EX_MEM_Func,switch,Flushout);
Data_Memory_h d1(EX_MEM_Result, EX_MEM_ReadData2, clk, EX_MEM_MemWrite, EX_MEM_MemRead,read_mem_data,a, b, c, d, e, f); //working with the data memeory
MEM_WB_h u4(clk, EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_Result,read_mem_data, EX_MEM_rd, MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_Result, MEM_WB_read_mem_data, MEM_WB_rd);
Mux m3 (MEM_WB_Result, MEM_WB_read_mem_data, MEM_WB_MemtoReg, WriteData); //deciding which data to write back  

endmodule  