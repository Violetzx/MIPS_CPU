module Instruction_decode(
				input clk,
				input rst,
				input forward1,
				input forward2,
				input BorJ,
				input [31:0] instruction_if,
				input [31:0] PC_add_four_if,
				input [4:0] write_data_in_in,
				input RegWrite_in,
				input [31:0] write_data,
				output reg [31:0] instruction_out,
				output reg [31:0] PC_add_four_out,
				output reg [31:0] sign_extend_out,
				output reg [31:0] read_data1_out,
				output reg [31:0] read_data2_out,
				output reg [4:0] write_data_in_out,
				output reg re_in_out,
				output reg [1:0] MemToReg_out,
				output reg [5:0] func_in_out,
				output reg we_in_out,
				output reg ALUSrc_out,
				output reg RegWrite_out,
				output reg [1:0] jump_out,
				output reg [1:0] size_in_out,
				output reg[1:0] load_sel_out,
				output reg mem_sel_out,
				output reg stall_out
				);
				
	wire Branch;
	wire [31:0] sign_extend;
	wire [31:0] read_data1;
	wire [31:0] read_data2;
	wire [4:0] write_data_in;
	wire [1:0] RegDst;
	wire re_in;
	wire [1:0] MemToReg;
	wire [5:0] func_in;
	wire we_in;
	wire ALUSrc;
	wire RegWrite;
	wire [1:0] jump;
	wire [1:0] size_in;
	wire [1:0] load_sel;
	wire mem_sel;
	wire stall;
	reg stall_reg;
	assign stall = stall_reg;
	
	wire [31:0] instruction_stall;
	wire [31:0] PC_add_four_stall;
	reg [31:0] instruction_stall_reg;
	reg [31:0] PC_add_four_stall_reg;
	assign instruction_stall = instruction_stall_reg;
	assign PC_add_four_stall = PC_add_four_stall_reg;
	
	wire [31:0] instruction;
	wire [31:0] PC_add_four;
	reg [31:0] instruction_reg;
	reg [31:0] PC_add_four_reg;
	assign instruction = instruction_reg;
	assign PC_add_four = PC_add_four_reg;
	
	always @(posedge clk) begin
		instruction_stall_reg <= instruction_if;
		PC_add_four_stall_reg <= PC_add_four_if;
		stall_reg <= stall_out;
	end
	
	always @(*) begin
		if(stall) begin
			instruction_reg <= instruction_stall;
			PC_add_four_reg <=  PC_add_four_stall;
		end else begin
			instruction_reg <= instruction_if;
			PC_add_four_reg <= PC_add_four_if;
		end
	end
	
	always @(*) begin
		if(instruction_out[20:16] == 5'b00000) begin
			stall_out <= 1'b0;
		end
		else if((instruction_out[31:26] == 6'b100011) ||
			(instruction_out[31:26] == 6'b100000) ||
			(instruction_out[31:26] == 6'b100001) ||
			(instruction_out[31:26] == 6'b100100) ||
			(instruction_out[31:26] == 6'b100101) ||
			(instruction_out[31:26] == 6'b001111)
			) begin
			case(instruction[31:26])
				6'b000000: begin //R-type
									if((instruction[25:21] == instruction_out[20:16]) || (instruction[20:16] == instruction_out[20:16])) begin
										stall_out <= 1'b1;
									end else begin
										stall_out <= 1'b0;
									end
								end
				6'b101011: begin //sw
									if((instruction[25:21] == instruction_out[20:16]) || (instruction[20:16] == instruction_out[20:16])) begin
										stall_out <= 1'b1;
									end else begin
										stall_out <= 1'b0;
									end
								end
				6'b101000: begin //sb
									if((instruction[25:21] == instruction_out[20:16]) || (instruction[20:16] == instruction_out[20:16])) begin
										stall_out <= 1'b1;
									end else begin
										stall_out <= 1'b0;
									end
								end
				6'b101001: begin //sh
									if((instruction[25:21] == instruction_out[20:16]) || (instruction[20:16] == instruction_out[20:16])) begin
										stall_out <= 1'b1;
									end else begin
										stall_out <= 1'b0;
									end
								end
				default: begin
									if(instruction[25:21] == instruction_out[20:16]) begin
										stall_out <= 1'b1;
									end else begin
										stall_out <= 1'b0;
									end
								end
			endcase
			end
			else begin
				stall_out <= 1'b0;
			end
	end
	
	always @(posedge clk) begin
		if(stall_out || BorJ) begin
			instruction_out <= 32'b0;
			PC_add_four_out <= 32'b0;
			sign_extend_out <= 32'b0;
			read_data1_out <= 32'b0;
			read_data2_out <= 32'b0;
			write_data_in_out <= 5'b0;
			re_in_out <= 1'b0;
			MemToReg_out <= 2'b0;
			func_in_out <= 6'b0;
			we_in_out <= 1'b0;
			ALUSrc_out <=  1'b0;
			RegWrite_out <= 1'b0;
			jump_out <= 2'b0;
			size_in_out <= 2'b0;
			load_sel_out <= 2'b0;
			mem_sel_out <= 1'b0;
		end else begin
			instruction_out <= instruction;
			PC_add_four_out <= PC_add_four;
			sign_extend_out <= sign_extend;
			read_data1_out <= read_data1;
			read_data2_out <= read_data2;
			write_data_in_out <= write_data_in;
			re_in_out <= re_in;
			MemToReg_out <= MemToReg;
			func_in_out <= func_in;
			we_in_out <= we_in;
			ALUSrc_out <=  ALUSrc;
			RegWrite_out <= RegWrite;
			jump_out <= jump;
			size_in_out <= size_in;
			load_sel_out <= load_sel;
			mem_sel_out <= mem_sel;
		end
	end
	
	mux_four_n #(.WIDTH(5))
				write_mux(
				.select(RegDst),
				.inA(instruction[15:11]),
				.inB(instruction[20:16]),
				.inC(5'b11111),
				.inD(5'b11111),
				.out(write_data_in)
				);
				
	ctr_unit ctr(
				.instruction(instruction),
				.RegDst(RegDst),
				.Branch(Branch),
				.re_in(re_in),
				.func_in(func_in),
				.MemToReg(MemToReg),
				.we_in(we_in),
				.ALUSrc(ALUSrc),
				.RegWrite(RegWrite),
				.jump(jump),
				.size_in(size_in),
				.load_sel(load_sel),
				.mem_sel(mem_sel)
				);
				
	register registers(	
				.clk(clk),
				.rst(rst),
				.we(RegWrite_in),
				.read1(instruction[25:21]),
				.read2(instruction[20:16]),
				.write(write_data_in_in),
				.write_data(write_data),
				.read_data1(read_data1),
				.read_data2(read_data2)
				);
				
	sign_extender se(
				.opcode(instruction[31:26]),
				.in(instruction[15:0]),
				.out(sign_extend)
				);

endmodule