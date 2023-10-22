`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/
module sign_extender(
			input [5:0] opcode,
			input [15:0] in,
			output [31:0] out
			);
			
			reg [31:0] out_reg;
			assign out = out_reg;
			
			always @(*) begin
				if((opcode == 6'b001100)|| // andi
					(opcode == 6'b001101)|| // ori
					(opcode == 6'b001110)|| // xori
					(opcode == 6'b100100)|| // lbu
					(opcode == 6'b100101))  // lhu
					begin
						out_reg = {16'b0,in};
					end
				else out_reg = {{16{in[15]}},in};
			end	
endmodule			