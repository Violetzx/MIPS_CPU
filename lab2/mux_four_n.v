`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/

module mux_four_n #(parameter WIDTH = 1)(
			input [1:0] 		  select,
			input [WIDTH - 1:0] inA, // 11
			input [WIDTH - 1:0] inB, // 10
			input [WIDTH - 1:0] inC, // 01
			input [WIDTH - 1:0] inD, // 00
			output [WIDTH - 1:0] out
			);
	
			assign out = select[1] ? select[0] ? inA : inB : select[0] ? inC : inD;
endmodule