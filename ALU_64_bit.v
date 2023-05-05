`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2023 03:00:51 AM
// Design Name: 
// Module Name: ALU_64_bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_64_bit
(
	input [63:0]a, b,
	input [3:0] ALUOp,
	input [2:0] func_3,
	output reg [63:0] Result,
	output reg ZERO
);

localparam [3:0]
AND = 4'b0000,
OR	= 4'b0001,
ADD	= 4'b0010,
Sub	= 4'b0110,
NOR = 4'b1100,
SLLI = 4'b1000;

localparam [2:0]
beq = 3'b000,
blt = 3'b100,
bge = 3'b101,
bne = 3'b001;

always @ (ALUOp, a, b)
begin
	case (ALUOp)
		AND: Result = a & b;
		OR:	 Result = a | b;
		ADD: Result = a + b;
		Sub: Result = a - b;
		NOR: Result = ~(a | b);
		SLLI: Result = a << b;
		default: Result = 0;
	endcase
	case (func_3)
	   beq:
	       ZERO = (Result == 64'h00000000) ? 1 : 0; //a and b are equal when the result is 0
	   bne:
	       ZERO = (Result == 64'h00000000) ? 0 : 1;  //a and b are unequal with result is 0 hence signal is 1
	   blt:
	       ZERO = (Result[63]); //if result[63] == 0, a > b; blt = 0;  
	   bge:
	       ZERO = (Result[63] == 0 || Result == 64'h00000000) ? 1 : 0; //either result[63] == 0; a > b or result is 0; a == b
	endcase
end
endmodule 
