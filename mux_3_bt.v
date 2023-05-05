`timescale 1ns / 1ps

module mux_3_bit
(
	input [63:0] a,
	input [63:0] b, c,
	input  [1:0] sel,
	
	output reg [63:0]data_out
);


always @ (*)
begin
	if (sel == 2'b00)
		data_out = a;
	else if (sel == 2'b01)
		data_out = b;
	else if (sel == 2'b10)
	   data_out = c;
end

endmodule 
