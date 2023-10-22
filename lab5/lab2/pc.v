`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/

module pc (
			input clk,
			input rst,
			input [31:0]PC_next,
			//input branch,
			output [31:0] PC_out
			);
			
			reg [31:0] PC_reg;
			//reg [31:0] Branch_PC_reg;
			
			parameter [31:0] rst_value = 32'h003FFFFC;
			
			initial PC_reg = rst_value;
			assign PC_out = PC_reg;
			
			always @(posedge clk)
			begin
				if(rst)
					begin
						PC_reg <= rst_value;
					end
				else PC_reg <= PC_next;
			end
endmodule