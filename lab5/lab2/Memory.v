module Memory (
				input [7:0] serial_in,
				input serial_valid_in,
				input serial_ready_in,
				input [31:0] instruction,
				input [31:0] PC_add_four,
				input clk,
				input rst,
				input [4:0] write_data_in,
				input RegWrite,
				input re_in,
				input we_in,
				input [1:0] MemToReg,
				input [1:0] size_in,
				input [1:0] load_sel,
				input mem_sel,
				input [31:0] alu_out,
				input [31:0] read_data2,
				output reg [31:0] instruction_out,
				output reg [4:0] write_data_in_out,
				output reg RegWrite_out,
				output reg [1:0] MemToReg_out,
				output reg [1:0] load_sel_out,
				output reg mem_sel_out,
				output reg [31:0] memory_out_out,
				output reg [31:0] alu_out_out,
				output reg [31:0] PC_add_four_out,
				output reg [7:0] serial_out_out,
				output reg serial_rden_out_out,
				output reg serial_wren_out_out
			);
			
			wire [31:0] memory_out;
			wire [7:0] serial_out;
			wire serial_rden_out;
			wire serial_wren_out;
			
			always @(posedge clk) begin
				write_data_in_out <= write_data_in;
				RegWrite_out <= RegWrite;
				MemToReg_out <= MemToReg;
				load_sel_out <= load_sel;
				mem_sel_out <= mem_sel;
				memory_out_out <= memory_out;
				alu_out_out <= alu_out;
				serial_out_out <= serial_out;
				serial_rden_out_out <= serial_rden_out;
				serial_wren_out_out <= serial_wren_out;
				instruction_out <= instruction;
				PC_add_four_out <= PC_add_four;
			end
			
			
			data_memory #(
				.INIT_PROGRAM0("C:/Users/yuz057/Desktop/test/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram0.memh"),
				.INIT_PROGRAM1("C:/Users/yuz057/Desktop/test/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram1.memh"),
				.INIT_PROGRAM2("C:/Users/yuz057/Desktop/test/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram2.memh"),
				.INIT_PROGRAM3("C:/Users/yuz057/Desktop/test/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram3.memh")
				)
				//helloworld
				//.INIT_PROGRAM0("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/hello_world/hello_world.data_ram0.memh"),
				//.INIT_PROGRAM1("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/hello_world/hello_world.data_ram1.memh"),
				//.INIT_PROGRAM2("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/hello_world/hello_world.data_ram2.memh"),
				//.INIT_PROGRAM3("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/hello_world/hello_world.data_ram3.memh")
				//nbhelloworld
				/*.INIT_PROGRAM0("C:/Users/yuz057/Desktop/MIPS_cpu/nbhelloworld/nbhelloworld.data_ram0.memh"),
				.INIT_PROGRAM1("C:/Users/yuz057/Desktop/MIPS_cpu/nbhelloworld/nbhelloworld.data_ram1.memh"),
				.INIT_PROGRAM2("C:/Users/yuz057/Desktop/MIPS_cpu/nbhelloworld/nbhelloworld.data_ram2.memh"),
				.INIT_PROGRAM3("C:/Users/yuz057/Desktop/MIPS_cpu/nbhelloworld/nbhelloworld.data_ram3.memh")*/
				
				/*.INIT_PROGRAM0("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram0.memh"),
				.INIT_PROGRAM1("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram1.memh"),
				.INIT_PROGRAM2("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram2.memh"),
				.INIT_PROGRAM3("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram3.memh")*/
				rom (
				 .clock(clk),
				 .reset(rst),
				.addr_in(alu_out),
				.writedata_in(read_data2),
				.re_in(re_in),
				.we_in(we_in),
				.size_in(size_in),
				.readdata_out(memory_out),
				.serial_in(serial_in),
				.serial_ready_in(serial_ready_in),
				.serial_valid_in(serial_valid_in),
				.serial_out(serial_out),
				.serial_rden_out(serial_rden_out),
				.serial_wren_out(serial_wren_out)
				);
endmodule