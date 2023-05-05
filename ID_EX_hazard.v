`timescale 1ns / 1ps

module ID_EX_h(
input clk,

input flush,

input branch, memwrite, memread, memtoreg, alusrc, regwrite, 

input [1:0]ALUop,

input [63:0]PC, 

input [63:0]RD1, RD2, 

input [63:0]Immgen, 

input [3:0]func, 

input [2:0]func3,

input [4:0]RD, 

input [4:0]rd1,

input [4:0]rd2,

output reg branchout, memwriteout, memreadout, memtoregout,regwriteout,alusrcout, 

output reg[1:0]ALUopout,

output reg [63:0]PCout, 

output reg [63:0]RD1out, RD2out, 

output reg [63:0]Immgenout, 

output reg [3:0]funcout,

output reg [2:0]func3out, 

output reg [4:0]RDout,

output reg [4:0]rd1out,

output reg [4:0]rd2out

); 
always @(posedge clk)
begin
if (flush)
begin
 branchout = 1'b0; 

 memwriteout = 1'b0; 

 memreadout = 1'b0; 

 memtoregout = 1'b0; 

 regwriteout = 1'b0; 

 alusrcout = 1'b0; 
 
 ALUopout = 2'b0;
 
 PCout = 64'b0; 

 RD1out = 64'b0; 

 RD2out = 64'b0; 

 Immgenout = 64'b0; 

 funcout = 4'b0; 
 
 func3out = 3'b0;

 RDout = 5'b0; 
 
 rd1out = 5'b0;
 
 rd2out = 5'b0;
end
else
begin
branchout = branch; 

 memwriteout = memwrite; 

 memreadout = memread; 

 memtoregout = memtoreg; 

 regwriteout = regwrite; 

 alusrcout = alusrc; 
 
 ALUopout = ALUop;
 
 PCout = PC; 

 RD1out = RD1; 

 RD2out = RD2; 

 Immgenout = Immgen; 

 funcout = func; 
 
 func3out = func3;

 RDout = RD; 
 
 rd1out = rd1;
 
 rd2out = rd2;
end

end

endmodule