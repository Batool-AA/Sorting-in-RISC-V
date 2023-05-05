`timescale 1ns / 1ps

module MEM_WB_h(
input clk,

input regwrite, memtoreg, 

input [63:0]alures, 

input [63:0]readmem, 

input [4:0]RD, 

output reg regwriteout, memtoregout, 

output reg [63:0]aluresout, 

output reg[63:0]readmemout, 

output reg[4:0]RDout 

); 
always @(posedge clk)
begin
    regwriteout = regwrite; 

    memtoregout = memtoreg; 

    aluresout = alures; 

    readmemout = readmem; 

    RDout = RD; 
end

endmodule
