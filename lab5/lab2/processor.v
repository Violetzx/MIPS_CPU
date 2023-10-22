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
		
	wire [31:0] PC_jump;
	wire [31:0] write_data;
	wire [31:0] read_data1;
	wire [31:0] read_data2_id;
	wire [31:0] read_data2_exe;
	wire [31:0] memory_out;
	wire [31:0] alu_out_exe;
	wire [31:0] alu_out_mem;
	wire [31:0] sign_extend;
	wire ALUSrc;
	wire [5:0] ALUop;
	wire [1:0] jump;

	wire [4:0] write_data_in_out_id;
	wire [4:0] write_data_in_out_exe;
	wire [4:0] write_data_in_out_mem;
	
	wire RegWrite_out_id;
	wire RegWrite_out_exe;
	wire RegWrite_out_mem;
	
	wire [31:0] instruction_out_id;
	wire [31:0] instruction_out_if;
	wire [31:0] instruction_out_exe;
	wire [31:0] instruction_out_mem;
	
	wire [31:0] PC_add_four_out_if;
	wire [31:0] PC_add_four_out_id;
	wire [31:0] PC_add_four_out_exe;
	wire [31:0] PC_add_four_out_mem;
	
	wire re_in_out_id;
	wire re_in_out_exe;
	
	wire we_in_out_id;
	wire we_in_out_exe;
	
	wire [1:0] MemToReg_out_id;
	wire [1:0] MemToReg_out_exe;
	wire [1:0] MemToReg_out_mem;
	
	wire [1:0] size_in_out_id;
	wire [1:0] size_in_out_exe;
	
	wire [1:0] load_sel_out_id;
	wire [1:0] load_sel_out_exe;
	wire [1:0] load_sel_out_mem;
	
	wire mem_sel_out_id;
	wire mem_sel_out_exe;
	wire mem_sel_out_mem;
	
	wire BorJ;
	wire stall;
	
	wire forward1;
	wire forward2;
	
	instruction_fetch IF(
						.clk(clock),
						.rst(reset),
						.PC_mux_sel(BorJ),
						.PC_jump(PC_jump),
						.stall(stall),
						.PC_add_four_out(PC_add_four_out_if),
						.instruction_out(instruction_out_if)
						);
						
	 Instruction_decode ID(
				.clk(clock),
				.rst(reset),
				.forward1(forward1),
				.forward2(forward2),
				.BorJ(BorJ),
				.instruction_if(instruction_out_if),
				.PC_add_four_if(PC_add_four_out_if),
				.write_data_in_in(write_data_in_out_mem),
				.RegWrite_in(RegWrite_out_mem),
				.write_data(write_data),
				.instruction_out(instruction_out_id),
				.PC_add_four_out(PC_add_four_out_id),
				.sign_extend_out(sign_extend),
				.read_data1_out(read_data1),
				.read_data2_out(read_data2_id),
				.write_data_in_out(write_data_in_out_id),
				.re_in_out(re_in_out_id),
				.MemToReg_out(MemToReg_out_id),
				.func_in_out(ALUop),
				.we_in_out(we_in_out_id),
				.ALUSrc_out(ALUSrc),
				.RegWrite_out(RegWrite_out_id),
				.jump_out(jump),
				.size_in_out(size_in_out_id),
				.load_sel_out(load_sel_out_id),
				.mem_sel_out(mem_sel_out_id),
				.stall_out(stall)
				);
	execution EXE(
				.clk(clock),
				.instruction_wb(instruction_out_mem),
				.write_data_wb(write_data),
				.write_data_in_mem(write_data_in_out_mem),
				.RegWrite_mem(RegWrite_out_mem),
				.alu_out_mem(alu_out_mem),
				.instruction(instruction_out_id),
				.PC_add_four(PC_add_four_out_id),
				.sign_extend(sign_extend),
				.read_data1(read_data1),
				.read_data2(read_data2_id),
				.write_data_in(write_data_in_out_id),
				.re_in(re_in_out_id),
				.MemToReg(MemToReg_out_id),
				.func_in(ALUop),
				.we_in(we_in_out_id),
				.ALUSrc(ALUSrc),
				.RegWrite(RegWrite_out_id),
				.jump(jump),
				.size_in(size_in_out_id),
				.load_sel(load_sel_out_id),
				.mem_sel(mem_sel_out_id),
				.instruction_out(instruction_out_exe),
				.write_data_in_out(write_data_in_out_exe),
				.RegWrite_out(RegWrite_out_exe),
				.re_in_out(re_in_out_exe),
				.we_in_out(we_in_out_exe),
				.MemToReg_out(MemToReg_out_exe),
				.size_in_out(size_in_out_exe),
				.load_sel_out(load_sel_out_exe),
				.mem_sel_out(mem_sel_out_exe),
				.PC_jump_out(PC_jump),
				.alu_out_out(alu_out_exe),
				.read_data2_out(read_data2_exe),
				.PC_add_four_out(PC_add_four_out_exe),
				.BorJ(BorJ),
				.forward1(forward1),
				.forward2(forward2)
				);
				
	Memory MEM(
				.serial_in(serial_in),
				.serial_valid_in(serial_valid_in),
				.serial_ready_in(serial_ready_in),
				.instruction(instruction_out_exe),
				.PC_add_four(PC_add_four_out_exe),
				.clk(clock),
				.rst(reset),
				.write_data_in(write_data_in_out_exe),
				.RegWrite(RegWrite_out_exe),
				.re_in(re_in_out_exe),
				.we_in(we_in_out_exe),
				.MemToReg(MemToReg_out_exe),
				.size_in(size_in_out_exe),
				.load_sel(load_sel_out_exe),
				.mem_sel(mem_sel_out_exe),
				.alu_out(alu_out_exe),
				.read_data2(read_data2_exe),
				.instruction_out(instruction_out_mem),
				.write_data_in_out(write_data_in_out_mem),
				.RegWrite_out(RegWrite_out_mem),
				.MemToReg_out(MemToReg_out_mem),
				.load_sel_out(load_sel_out_mem),
				.mem_sel_out(mem_sel_out_mem),
				.memory_out_out(memory_out),
				.alu_out_out(alu_out_mem),
				.PC_add_four_out(PC_add_four_out_mem),
				.serial_out_out(serial_out),
				.serial_rden_out_out(serial_rden_out),
				.serial_wren_out_out(serial_wren_out)
			);

	Write_Back WB(
				.instruction(instruction_out_mem),
				.PC_add_four(PC_add_four_out_mem),
				.MemToReg(MemToReg_out_mem),
				.load_sel(load_sel_out_mem),
				.mem_sel(mem_sel_out_mem),
				.memory_out(memory_out),
				.alu_out(alu_out_mem),
				.write_data(write_data)
				);

endmodule