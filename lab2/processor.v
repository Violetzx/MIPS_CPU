`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/

module processor(
		input clock,
		input reset,
		
		//these ports are used for serial IO and
		//must be wired up to the data_memory module
		input [7:0] serial_in,
		input serial_valid_in,
		input serial_ready_in,
		output [7:0] serial_out,
		output serial_rden_out,
		output serial_wren_out
);
		
	wire [31:0] instruction;
	wire [31:0] PC_next;
	
	wire [31:0] PC_add_four;
	reg [31:0] PC_add_four_reg;
	assign PC_add_four = PC_add_four_reg;
	wire [31:0] PC;
	wire [31:0] PC_jump;
	
	wire [4:0]  write_data_in;

	wire [31:0] write_data;
	wire [31:0] read_data1;
	wire [31:0] read_data2;
	wire [31:0] memory_out;
	wire [31:0] alu_in_b;
	wire [31:0] alu_out;
		
	wire [31:0] sign_extend;
	wire [1:0]RegDst; 
	wire RegWrite;
	wire ALUSrc;
	wire [5:0] ALUop;
	wire JumpOut;
	wire BranchOut;
	wire re_in;
	wire we_in;
	wire [1:0]MemToReg;
	wire Branch;
	wire [1:0] jump;
	wire [1:0] size_in;
	
	wire[1:0] load_sel;
	wire mem_sel;
	wire[31:0] load_out;
	
	always @(*) begin
		PC_add_four_reg = PC + 32'd4;
	end
	
	ctr_unit ctr(
				.instruction(instruction),
				.RegDst(RegDst),
				.Branch(Branch),
				.re_in(re_in),
				.func_in(ALUop),
				.MemToReg(MemToReg),
				.we_in(we_in),
				.ALUSrc(ALUSrc),
				.RegWrite(RegWrite),
				.jump(jump),
				.size_in(size_in),
				.load_sel(load_sel),
				.mem_sel(mem_sel)
				);
	
	mux_four_n #(.WIDTH(5))
				write_mux(
				.select(RegDst),
				.inA(instruction[15:11]),
				.inB(instruction[20:16]),
				.inC(5'b11111),
				.inD(5'bx),
				.out(write_data_in)
				);
	
	mux_four_n #(.WIDTH(32))
				write_data_mux(
				.select(MemToReg),
				.inA(load_out),
				.inB(alu_out),
				.inC({instruction[15:0],16'b0}),
				.inD(PC_add_four),
				.out(write_data)
				);
				
	n_mux #(.WIDTH(32))
				alu_mux(
				.select(ALUSrc),
				.inA(sign_extend),
				.inB(read_data2),
				.out(alu_in_b)
				);
	
	sign_extender se(
				.opcode(instruction[31:26]),
				.in(instruction[15:0]),
				.out(sign_extend)
				);
	
	n_mux #(.WIDTH(32))
				PC_mux(
				.select(JumpOut || BranchOut),
				.inA(PC_jump),
				.inB(PC_add_four),
				.out(PC_next)
				);
	
	pc_jumper pc_jumper(
				.instruction(instruction),
				.PC_add_four(PC_add_four),
				.sign_extend(sign_extend),
				.read_data1(read_data1),
				.jump(jump),
				.PC_jump(PC_jump)
				);
	
	pc program_counter(
				.clk(clock),
				.rst(reset),
				.PC_next(PC_next),
				.PC_out(PC)
				);
				
	loader loader(
				.mem_out(memory_out),
				.load_sel(load_sel),
				.mem_sel(mem_sel),
				.pos(read_data1[1:0]),
				.load_out(load_out)
			);
	
	register registers(	
				.clk(clock),
				.rst(reset),
				.we(RegWrite),
				.read1(instruction[25:21]),
				.read2(instruction[20:16]),
				.write(write_data_in),
				.write_data(write_data),
				.read_data1(read_data1),
				.read_data2(read_data2)
				);
				
	inst_rom #(
				.ADDR_WIDTH(10), //added for lab4
				.INIT_PROGRAM("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.inst_rom.memh"))
				inst_rom(.clock(clock), 
							.reset(reset), 
							.addr_in(PC_next), 
							.data_out(instruction)
							);
							
	
	alu alu(
		.Func_in(ALUop),
		.A_in(read_data1),
		.B_in(alu_in_b),
		.O_out(alu_out),
		.Branch_out(BranchOut),
		.Jump_out(JumpOut)	
		);
		
	 data_memory #(
				.INIT_PROGRAM0("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram0.memh"),
				.INIT_PROGRAM1("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram1.memh"),
				.INIT_PROGRAM2("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram2.memh"),
				.INIT_PROGRAM3("C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib2/fib/fib.data_ram3.memh")
				)
				
				//nbhelloworld
				//F:/CSE141L/MIPS_cpu/lab4-files-2/memh/nbhelloworld/nbhelloworld.inst_rom.memh
				//F:/CSE141L/MIPS_cpu/lab4-files-2/memh/nbhelloworld/nbhelloworld.data_ram0.memh
				
				//helloworld
				//F:/CSE141L/MIPS_cpu/lab4-files-2/memh/hello_world/hello_world.data_ram3.memh
				//F:/CSE141L/MIPS_cpu/lab4-files-2/memh/hello_world/hello_world.inst_rom.memh
				
				//fib
				//F:/CSE141L/MIPS_cpu/fib/fib.data_ram0.memh
				//F:/CSE141L/MIPS_cpu/lab4-files-2/memh/fib/fib.inst_rom.memh
				
				//C:/Users/yuz057/Desktop/MIPS_cpu/lab4-files-2/memh/fib/fib.data_ram0.memh
				
				//test
				//F:/CSE141L/MIPS_cpu/lab4-test/lab4-test.data_ram3.memh
				//F:/CSE141L/MIPS_cpu/lab4-test/lab4-test.inst_rom.memh
				
				//C:/Users/yuz057/Desktop/MIPS_cpu/lab4-test/
				rom (
				 .clock(clock),
				 .reset(reset),
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