`timescale 1ns/1ps

module pc_jumper(
			input [31:0] instruction,
			input [31:0] PC_add_four,
			input [31:0] sign_extend,
			input [31:0] read_data1,
			input [1:0] jump,
			output [31:0] PC_jump
			); 
			
			wire [31:0] j_type;
			wire [31:0] branch;
			reg [31:0] branch_reg;
			
			assign branch = branch_reg;
			assign j_type = {PC_add_four[31:28],instruction[25:0],2'b00};
			
			mux_four_n #(.WIDTH(32)) pc_jump_mux(
						.select(jump),
						.inA(j_type),
						.inB(j_type),
						.inC(branch),
						.inD(read_data1),
						.out(PC_jump)
						);
			
			always@(*)begin
				branch_reg = (sign_extend << 2) + PC_add_four;
			end


endmodule