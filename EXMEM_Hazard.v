`timescale 1ns / 1ps
module EX_MEM_h(
input clk,

input flush,

input [63:0]addsum, 

input [63:0]Alures, 

input zero, 

input is_greater,

input [63:0]RD2, 

input [4:0]RD, 

input regwrite, memtoreg, branch, memread,memwrite, 

input [3:0]func,

input [63:0]WriteData,

output reg[63:0]addsumout, 

output reg[63:0]Aluresout, 

output reg zerout,

output reg is_greater_out, 

output reg [63:0]RD2out, 

output reg [4:0]RDout, 

output reg regwriteout, memtoregout, branchout, memreadout, memwriteout ,

output reg[3:0] funcout,

output reg[63:0]WriteDataout



); 
always @(posedge clk)
begin
if (flush)
begin
    addsumout = 0; 

    Aluresout = 0; 

    zerout = 0; 
    
    is_greater_out = 0;

    RD2out = 0; 

    RDout = 0; 

    regwriteout = 0; 

    memtoregout = 0; 

    branchout = 0; 

    memreadout = 0; 

    memwriteout = 0; 
    
    funcout = 0;
    
    WriteDataout = 0;
    
end
else
begin
    addsumout = addsum; 

    Aluresout = Alures; 

    zerout = zero; 
    
    is_greater_out = is_greater;

    RD2out = RD2; 

    RDout = RD; 

    regwriteout = regwrite; 

    memtoregout = memtoreg; 

    branchout = branch; 

    memreadout = memread; 

    memwriteout = memwrite; 
    
    funcout = func;
    
    WriteDataout = WriteData;  
    
end

end

endmodule  
