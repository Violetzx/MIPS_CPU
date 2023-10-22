`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/

module adder(
			input [31:0] in_a,
			input [31:0] in_b,
			output [31:0] out,
			);
			reg [31:0] pre_pc_reg;
			reg [31:0] next_pc_reg;
			wire [31:0] wireout;
			assign wireout = pre_pc_reg + 32'd 4;
			assign nextpc = next_pc_reg;
			
			always@(posedge clk)
			begin
				pre_pc_reg <= prepc;
				next_pc_reg <= wireout;
			end
endmodule