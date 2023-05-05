`timescale 1ns / 1ps

module ALU_Hazard(
	input [63:0] a,
	input [63:0] b,
	input [3:0] ALUOp,
	input [2:0]func3,
	output reg [63:0] Result,
	output reg Zero,
    output reg Is_lesser
);


always @(*)
begin

    case (ALUOp)

            4'b0000: Result = a & b;
            4'b0001: Result = a | b;
            4'b0010: Result = a + b;
            4'b0110: Result = a - b;
            4'b1100: Result = ~(a | b);
            4'b1000: Result = a << b;
        endcase

    if (Result == 64'd0 && (func3 == 3'b000))
        Zero = 1'b1;
    
    else
        Zero = 1'b0;

    Is_lesser = (Result[63]==1 && func3 == 3'b100)  ? 1'b0 : 1'b1;
end

endmodule