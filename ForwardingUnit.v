`timescale 1ns / 1ps

module Forwarding_Unit
(
    input [4:0] EXMEM_rd, MEMWB_rd, IDEX_rs1, IDEX_rs2,
    input EXMEM_RegWrite, MEMWB_RegWrite,
    output reg [1:0] ForwardA, ForwardB
);

always @(*) begin
    if (EXMEM_rd == IDEX_rs1 && EXMEM_RegWrite && EXMEM_rd != 0) 
            ForwardA = 2'b10;
    else if (((MEMWB_rd == IDEX_rs1) && MEMWB_RegWrite && (MEMWB_rd != 0)) && !(EXMEM_RegWrite && (EXMEM_rd != 0) && (EXMEM_rd == IDEX_rs1)))
         ForwardA = 2'b01;
    else
         ForwardA = 2'b00;
 
    if ((EXMEM_rd == IDEX_rs2) && (EXMEM_RegWrite) && (EXMEM_rd != 0))
         ForwardB = 2'b10;
    else if (((MEMWB_rd == IDEX_rs2) && (MEMWB_RegWrite == 1) && (MEMWB_rd != 0)) && !(EXMEM_RegWrite && (EXMEM_rd != 0) && (EXMEM_rd == IDEX_rs2)))
        ForwardB = 2'b01;
    else 
        ForwardB = 2'b00;
end
endmodule
