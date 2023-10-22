module execution (
				input clk,
				input [31:0] instruction_wb,
				input [31:0] write_data_wb,
				input [4:0] write_data_in_mem,
				input RegWrite_mem,
				input [31:0] alu_out_mem,
				input [31:0] instruction,
				input [31:0] PC_add_four,
				input [31:0] sign_extend,
				input [31:0] read_data1,
				input [31:0] read_data2,
				input [4:0] write_data_in,
				input re_in,
				input [1:0] MemToReg,
				input [5:0] func_in,
				input we_in,
				input ALUSrc,
				input RegWrite,
				input [1:0] jump,
				input [1:0] size_in,
				input [1:0] load_sel,
				input mem_sel,
				output reg [31:0] instruction_out,
				output reg [4:0] write_data_in_out,
				output reg RegWrite_out,
				output reg re_in_out,
				output reg we_in_out,
				output reg [1:0] MemToReg_out,
				output reg [1:0] size_in_out,
				output reg [1:0] load_sel_out,
				output reg mem_sel_out,
				output reg [31:0] PC_jump_out,
				output reg [31:0] alu_out_out,
				output reg [31:0] read_data2_out,
				output reg [31:0] PC_add_four_out,
				output reg BorJ,
				output reg forward1,
				output reg forward2
				);
				
	wire [31:0] alu_in_b;
	wire [31:0] PC_jump;
	wire [31:0] alu_out;
	wire BranchOut;
	wire JumpOut;
	wire [31:0] read_data2_fi;
	reg [31:0] read_data2_fi_reg;
	assign read_data2_fi = read_data2_fi_reg;
	
	wire [31:0] alu_in_a;
	reg [31:0] alu_in_a_reg;
	assign alu_in_a = alu_in_a_reg;
	
	wire [31:0] alu_in_b_fi;
	reg [31:0] alu_in_b_fi_reg;
	assign alu_in_b_fi = alu_in_b_fi_reg;
	
	reg [4:0] write_data_in_reg;
	reg [31:0] alu_out_reg;
	reg RegWrite_reg;
	
	wire [4:0] write_data_in_reg_wire;
	wire [31:0] alu_out_reg_wire;
	wire RegWrite_reg_wire;
	
	assign write_data_in_reg_wire = write_data_in_reg;
	assign alu_out_reg_wire = alu_out_reg;
	assign RegWrite_reg_wire = RegWrite_reg;
	
	
	initial BorJ = 1'b0;
	
	/*always @ (posedge clk) begin
		write_data_in_reg <= write_data_in;
		alu_out_reg <= alu_out;
		RegWrite_reg <= RegWrite;
	end*/
	
	always @(posedge clk) begin
		write_data_in_reg <= write_data_in;
		alu_out_reg <= alu_out;
		RegWrite_reg <= RegWrite;
		if(BorJ) begin
			write_data_in_out <= 5'b0;
			RegWrite_out <= 1'b0;
			re_in_out <= 1'b0;
			we_in_out <= 1'b0;
			MemToReg_out <= 2'b0;
			size_in_out <= 2'b0;
			load_sel_out <= 2'b0;
			mem_sel_out <= 1'b0;
			PC_jump_out <= 32'b0;
			alu_out_out <= 32'b0;
			read_data2_out <= 32'b0;
			BorJ <= 1'b0;
			instruction_out <= 32'b0;
			PC_add_four_out <= 32'b0;
		end else begin
			write_data_in_out <= write_data_in;
			RegWrite_out <= RegWrite;
			re_in_out <= re_in;
			we_in_out <= we_in;
			MemToReg_out <= MemToReg;
			size_in_out <= size_in;
			load_sel_out <= load_sel;
			mem_sel_out <= mem_sel;
			PC_jump_out <= PC_jump;
			alu_out_out <= alu_out;
			read_data2_out <= read_data2_fi;
			BorJ <= BranchOut || JumpOut;
			instruction_out <= instruction;
			PC_add_four_out <= PC_add_four;
		end
	end
	
	always @(*) begin
		if(((instruction_wb[31:26] == 6'b100011) ||
			(instruction_wb[31:26] == 6'b100000) ||
			(instruction_wb[31:26] == 6'b100001) ||
			(instruction_wb[31:26] == 6'b100100) ||
			(instruction_wb[31:26] == 6'b100101) ||
			(instruction_wb[31:26] == 6'b001111)) && ((instruction[25:21] == instruction_wb[20:16]) || (instruction[20:16] == instruction_wb[20:16]))
			) begin //lw
			case(instruction[31:26]) 
				6'b000000: begin
									read_data2_fi_reg <= read_data2;
									if(instruction[25:21] == instruction_wb[20:16]) begin
										alu_in_a_reg <= write_data_wb;
										forward1 <= 1'b1;
										if((instruction[20:16] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
											alu_in_b_fi_reg <= alu_out_reg_wire;
											forward2 <= 1'b1;
										end else begin
											alu_in_b_fi_reg <= alu_in_b;
											forward2 <= 1'b0;
										end
									end else begin
										alu_in_a_reg <= read_data1;
										forward1 <= 1'b0;
									end
									if(instruction[20:16] == instruction_wb[20:16]) begin
										alu_in_b_fi_reg <= write_data_wb;
										forward2 <= 1'b1;
										if((instruction[25:21] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
											alu_in_a_reg <= alu_out_reg_wire;
											forward1 <= 1'b1;
										end else begin
											alu_in_a_reg <= read_data1;
											forward1 <= 1'b0;
										end
									end else begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b0;
									end
								end
				6'b101011: begin //sw
									if(instruction[25:21] == instruction_wb[20:16]) begin
										alu_in_a_reg <= write_data_wb;
										forward1 <= 1'b1;
									end else begin
										alu_in_a_reg <= read_data1;
										forward1 <= 1'b0;
									end
									if(instruction[20:16] == instruction_wb[20:16]) begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b1;
										read_data2_fi_reg <= write_data_wb;
									end else begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b0;
										read_data2_fi_reg <= read_data2;
									end
								end
				6'b101000: begin //sb
									if(instruction[25:21] == instruction_wb[20:16]) begin
										alu_in_a_reg <= write_data_wb;
										forward1 <= 1'b1;
									end else begin
										alu_in_a_reg <= read_data1;
										forward1 <= 1'b0;
									end
									if(instruction[20:16] == instruction_wb[20:16]) begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b1;
										read_data2_fi_reg <= write_data_wb;
									end else begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b0;
										read_data2_fi_reg <= read_data2;
									end
								end
				6'b101001: begin //sh
									if(instruction[25:21] == instruction_wb[20:16]) begin
										alu_in_a_reg <= write_data_wb;
										forward1 <= 1'b1;
									end else begin
										alu_in_a_reg <= read_data1;
										forward1 <= 1'b0;
									end
									if(instruction[20:16] == instruction_wb[20:16]) begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b1;
										read_data2_fi_reg <= write_data_wb;
									end else begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b0;
										read_data2_fi_reg <= read_data2;
									end
								end
				default: begin
									if(instruction[25:21] == instruction_wb[20:16]) begin
										alu_in_a_reg <= write_data_wb;
										forward1 <= 1'b1;
									end else begin
										alu_in_a_reg <= read_data1;
										forward1 <= 1'b0;
									end
									alu_in_b_fi_reg <= alu_in_b;
									forward2 <= 1'b0;
									read_data2_fi_reg <= read_data2;
								end
			endcase
		end else begin
			if((instruction[25:21] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
				alu_in_a_reg <= alu_out_reg_wire;
				forward1 <= 1'b1;
			end else begin
				if((instruction[25:21] == write_data_in_mem) && RegWrite_mem) begin
					alu_in_a_reg <= alu_out_mem;
					forward1 <= 1'b1;
				end else begin
					alu_in_a_reg <= read_data1;
					forward1 <= 1'b0;
				end
			end
			case(instruction[31:26])
				6'b000000: begin
							read_data2_fi_reg <= read_data2;
							if((instruction[20:16] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
								alu_in_b_fi_reg <= alu_out_reg_wire;
								forward2 <= 1'b1;
							end else begin
								if((instruction[20:16] == write_data_in_mem) && RegWrite_mem) begin
									alu_in_b_fi_reg <= alu_out_mem;
									forward2 <= 1'b1;
								end else begin
									alu_in_b_fi_reg <= alu_in_b;
									forward2 <= 1'b0;
								end
							end
						end
				6'b101011: begin //sw
								if((instruction[20:16] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
									alu_in_b_fi_reg <= alu_in_b;
									read_data2_fi_reg <= alu_out_reg_wire;
									forward2 <= 1'b1;
								end else begin
									if((instruction[20:16] == write_data_in_mem) && RegWrite_mem) begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b1;
										read_data2_fi_reg <= alu_out_mem;
									end else begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b0;
										read_data2_fi_reg <= read_data2;
									end
								end
							end
				6'b101000: begin //sb
								if((instruction[20:16] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
									alu_in_b_fi_reg <= alu_in_b;
									read_data2_fi_reg <= alu_out_reg_wire;
									forward2 <= 1'b1;
								end else begin
									if((instruction[20:16] == write_data_in_mem) && RegWrite_mem) begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b1;
										read_data2_fi_reg <= alu_out_mem;
									end else begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b0;
										read_data2_fi_reg <= read_data2;
									end
								end
							end
				6'b101001: begin //sh
								if((instruction[20:16] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
									alu_in_b_fi_reg <= alu_in_b;
									read_data2_fi_reg <= alu_out_reg_wire;
									forward2 <= 1'b1;
								end else begin
									if((instruction[20:16] == write_data_in_mem) && RegWrite_mem) begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b1;
										read_data2_fi_reg <= alu_out_mem;
									end else begin
										alu_in_b_fi_reg <= alu_in_b;
										forward2 <= 1'b0;
										read_data2_fi_reg <= read_data2;
									end
								end
							end
				6'b000100: begin //beq
							read_data2_fi_reg <= read_data2;
							if((instruction[20:16] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
								alu_in_b_fi_reg <= alu_out_reg_wire;
								forward2 <= 1'b1;
							end else begin
								if((instruction[20:16] == write_data_in_mem) && RegWrite_mem) begin
									alu_in_b_fi_reg <= alu_out_mem;
									forward2 <= 1'b1;
								end else begin
									alu_in_b_fi_reg <= alu_in_b;
									forward2 <= 1'b0;
								end
							end
						end
				6'b000101: begin //bne
							read_data2_fi_reg <= read_data2;
							if((instruction[20:16] == write_data_in_reg_wire) && RegWrite_reg_wire) begin
								alu_in_b_fi_reg <= alu_out_reg_wire;
								forward2 <= 1'b1;
							end else begin
								if((instruction[20:16] == write_data_in_mem) && RegWrite_mem) begin
									alu_in_b_fi_reg <= alu_out_mem;
									forward2 <= 1'b1;
								end else begin
									alu_in_b_fi_reg <= alu_in_b;
									forward2 <= 1'b0;
								end
							end
						end
				default: begin
								alu_in_b_fi_reg <= alu_in_b;
								forward2 <= 1'b0;
								read_data2_fi_reg <= read_data2;
							end
			endcase
		end
	end
	
	
	n_mux #(.WIDTH(32))
			alu_mux(
			.select(ALUSrc),
			.inA(sign_extend),
			.inB(read_data2),
			.out(alu_in_b)
			);
	pc_jumper pc_jumper(
				.instruction(instruction),
				.PC_add_four(PC_add_four),
				.sign_extend(sign_extend),
				.read_data1(alu_in_a),
				.jump(jump),
				.PC_jump(PC_jump)
				);
	alu alu(
		.Func_in(func_in),
		.A_in(alu_in_a),
		.B_in(alu_in_b_fi),
		.O_out(alu_out),
		.Branch_out(BranchOut),
		.Jump_out(JumpOut)	
		);	
				
endmodule