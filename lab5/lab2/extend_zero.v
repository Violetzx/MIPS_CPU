`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/
module extend_zero(
			input [15:0] in,
			output [31:0] out
			);

			assign out = {in, 16'b0};
endmodule			