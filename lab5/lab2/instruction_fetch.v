`timescale 1ns / 1ps
module instruction_fetch(
						input clk,
						input rst,
						input	PC_mux_sel,
						input [31:0] PC_jump,
						input stall,
						output reg [31:0] PC_add_four_out,
						output reg [31:0] instruction_out
						);
	
	reg [31:0] PC_add_four_reg;
	
	wire [31:0] instruction;
	wire [31:0] PC_add_four;
	wire [31:0] PC_next;
	wire [31:0] PC;
	
	assign PC_add_four = PC_add_four_reg;
	
	always @(posedge clk) begin
		if(PC_mux_sel) begin
			PC_add_four_out <= 32'b0;
			instruction_out <= 32'b0;
		end else begin
			PC_add_four_out <= PC_add_four;
			instruction_out <= instruction;
		end
	end
	
	always @(*) begin
		if(stall) begin
			PC_add_four_reg <= PC;
		end else begin
			PC_add_four_reg <= PC + 32'd4;
		end
	end
						
	n_mux #(.WIDTH(32))
				PC_mux(
				.select(PC_mux_sel),
				.inA(PC_jump),
				.inB(PC_add_four),
				.out(PC_next)
				);
	
	pc program_counter(
				.clk(clk),
				.rst(rst),
				.PC_next(PC_next),
				.PC_out(PC)
				);
	inst_rom #(
				.ADDR_WIDTH(10), //added for lab4
				.INIT_PROGRAM("C:/Users/yuz057/Desktop/test/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.inst_rom.memh"))
				//helloWorld
				//C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/hello_world/hello_world.inst_rom.memh
				//nbhelloworld
				//C:/Users/yuz057/Desktop/MIPS_cpu/nbhelloworld/nbhelloworld.inst_rom.memh
				//fib
				//C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.inst_rom.memh
				inst_rom(.clock(clk), 
							.reset(rst), 
							.addr_in(PC_next), 
							.data_out(instruction)
				);

endmodule