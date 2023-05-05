`timescale 1ns / 1ps

module IF_ID_h(
    input clk,
    
    input Flushout,
    
    input IFID_Write,
    
    input [31:0]Instruction, 
    
    input [63:0]PCOut, 
    
    output reg[31:0]Ins, 
    
    output reg[63:0]PC

    
); 

always @(posedge clk)
begin
if (Flushout)
begin
    Ins = 32'b0; 
    
    PC = 64'b0; 
    
end
else if (!IFID_Write)
begin
    Ins = Ins;
    PC = PC;
end
else
begin
    Ins = Instruction; 
    
    PC = PCOut; 
    
end
end

endmodule
