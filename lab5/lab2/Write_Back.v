module Write_Back(
					input [31:0] instruction,
					input [31:0] PC_add_four,
					input [1:0] MemToReg,
					input [1:0] load_sel,
					input mem_sel,
					input [31:0] memory_out,
					input [31:0] alu_out,
					output [31:0] write_data
					);
					
	
	wire [31:0] load_out;
	 
	mux_four_n #(.WIDTH(32))
				write_data_mux(
				.select(MemToReg),
				.inA(load_out),
				.inB(alu_out),
				.inC({instruction[15:0],16'b0}),
				.inD(PC_add_four),
				.out(write_data)
				);
				
	loader loader(
				.mem_out(memory_out),
				.load_sel(load_sel),
				.mem_sel(mem_sel),
				.pos(alu_out[1:0]),
				.load_out(load_out)
			);
endmodule