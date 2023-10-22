`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/

module n_mux #(parameter WIDTH = 1)(
			input select,
			input [WIDTH - 1:0] inA,
			input [WIDTH - 1:0] inB,
			output [WIDTH - 1:0] out
			);
			assign out = select ? inA : inB;
endmodule