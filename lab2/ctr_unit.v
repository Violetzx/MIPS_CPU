module ctr_unit(
		input [31:0] instruction,
		output [1:0] RegDst,
		output Branch,
		output re_in,
		output [1:0]MemToReg,
		output [5:0] func_in,
		output we_in,
		output ALUSrc,
		output RegWrite,
		output [1:0] jump,
		output [1:0] size_in,
		output [1:0] load_sel,
		output mem_sel
);

	reg [1:0] RegDst_reg;
	reg Branch_reg;
	reg re_in_reg;
	reg [1:0]MemToReg_reg;
	reg [5:0] func_in_reg;
	reg we_in_reg;
	reg ALUSrc_reg;
	reg RegWrite_reg;
	reg [1:0]jump_reg;
	reg [1:0] size_in_reg;
	reg [1:0] load_sel_reg;
	reg mem_sel_reg;
	
	assign RegDst = RegDst_reg;
	assign Branch = Branch_reg;
	assign re_in = re_in_reg;
	assign MemToReg = MemToReg_reg;
	assign func_in =func_in_reg;
	assign we_in = we_in_reg;
	assign ALUSrc = ALUSrc_reg;
	assign RegWrite = RegWrite_reg;
	assign jump = jump_reg;
	assign size_in = size_in_reg;
	assign load_sel = load_sel_reg;
	assign mem_sel = mem_sel_reg;
	
	always @(*)
		begin
			/*if(instruction[31:26] == 6'b000000) // R type
			begin
				func_in_reg <= instruction[5:0];
				ALUSrc_reg <= 1'b0;
				re_in_reg <= 1'b0;
				Branch_reg <= 1'b0;
				size_in_reg <= 2'bxx;
				if(instruction[5:0] == 6'b001000) begin
					jump_reg <= 2'b00;
					we_in_reg <= 1'b0;
					MemToReg_reg <= 2'b10;
					RegDst_reg <= 2'b11;
					RegWrite_reg <= 1'b1;
				end
				else if(instruction[5:0] == 6'b001001) begin
					jump_reg <= 2'b00;
					we_in_reg <= 1'b1;
					MemToReg_reg <= 2'b00;
					RegDst_reg <= 2'b11;
					RegWrite_reg <= 1'b1;
				end
				else begin
					jump_reg <= 2'b01;
					we_in_reg <= 1'b0;
					MemToReg_reg <= 2'b10;
					RegDst_reg <= 2'b11;
					RegWrite_reg <= 1'b1;
				end
				// sll logic havn't been implementeddededed
			end*/
			//**********new R type*************
			if(instruction[31:26] == 6'b000000) // R type
			begin
				load_sel_reg <= 2'bxx;
				mem_sel_reg <= 1'b1;
				if((instruction[5:0] == 6'b101010) || 
					(instruction[5:0] == 6'b101011) || 
					(instruction[5:0] == 6'b000000) || 
					(instruction[5:0] == 6'b001000) || 
					(instruction[5:0] == 6'b001001))
					begin
						case(instruction[5:0])
								6'b101010: 	begin //slt
													func_in_reg <= 6'b101000;
													RegDst_reg <= 2'b11; 
													ALUSrc_reg <= 1'b0;
													RegWrite_reg <= 1'b1;
													re_in_reg <= 1'b0;
													Branch_reg <= 1'b0;
													size_in_reg <= 2'bxx;
													jump_reg <= 2'b01;
													we_in_reg <= 1'b0;
													MemToReg_reg <= 2'b10;
												end
								6'b101011:  begin //sltu
													func_in_reg <= 6'b101001;
													RegDst_reg <= 2'b11; 
													ALUSrc_reg <= 1'b0;
													RegWrite_reg <= 1'b1;
													re_in_reg <= 1'b0;
													Branch_reg <= 1'b0;
													size_in_reg <= 2'bxx;
													jump_reg <= 2'b01;
													we_in_reg <= 1'b0;
													MemToReg_reg <= 2'b10;
												end
								6'b000000:	begin //sll
													func_in_reg <= 6'b100000;
													RegDst_reg <= 2'b10; 
													ALUSrc_reg <= 1'b0;
													RegWrite_reg <= 1'b0;
													re_in_reg <= 1'b0;
													Branch_reg <= 1'b0;
													size_in_reg <= 2'bxx;
													jump_reg <= 2'b00;
													we_in_reg <= 1'b0;
													MemToReg_reg <= 2'b10;
												end
								6'b001000:	begin //jr
													func_in_reg <= 6'b111010;
													ALUSrc_reg <= 1'b0;
													re_in_reg <= 1'b0;
													Branch_reg <= 1'b0;
													size_in_reg <= 2'bxx;
													jump_reg <= 2'b00;
													we_in_reg <= 1'b0;
													MemToReg_reg <= 2'b10;
													RegDst_reg <= 2'b11;
													RegWrite_reg <= 1'b1;
												end
								6'b001001:	begin //jalr
													func_in_reg <= 6'b111010;
													ALUSrc_reg <= 1'b0;
													re_in_reg <= 1'b0;
													Branch_reg <= 1'b0;
													size_in_reg <= 2'bxx;
													jump_reg <= 2'b00;
													we_in_reg <= 1'b1;
													MemToReg_reg <= 2'b00;
													RegDst_reg <= 2'b11;
													RegWrite_reg <= 1'b1;
												end
						endcase
					end
					
				else
					begin //all other R types
						func_in_reg <= instruction[5:0];
						ALUSrc_reg <= 1'b0;
						re_in_reg <= 1'b0;
						Branch_reg <= 1'b0;
						size_in_reg <= 2'b11;
						jump_reg <= 2'b01;
						we_in_reg <= 1'b0;
						MemToReg_reg <= 2'b10;
						RegDst_reg <= 2'b11;
						RegWrite_reg <= 1'b1;
					end
			end
			
			else if((instruction[31:26] == 6'b000010) || (instruction[31:26] == 6'b000011)) begin // J type
				ALUSrc_reg <= 1'b0;
				re_in_reg <= 1'b0;
				we_in_reg <= 1'b0;
				jump_reg <= 2'b11;
				MemToReg_reg <= 2'b00;
				func_in_reg <= 6'b111010;
				size_in_reg <= 2'bxx;
				Branch_reg <= 1'b0;
				load_sel_reg <= 2'bxx;
				mem_sel_reg <= 1'b1;
				case(instruction[31:26])
					6'b000010: begin
										RegDst_reg <= 2'b00;
										RegWrite_reg <= 1'b0;
								  end
					6'b000011: begin
										RegDst_reg <= 2'b01;
										RegWrite_reg <= 1'b1;
								  end
				endcase			
			end
			else begin										// I type
				jump_reg <= 2'b01;
				case(instruction[31:26])
					6'b100011:	begin //lw
										func_in_reg = 6'b100000; 
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b1;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b11;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b11;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b101011:	begin //sw
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b1;
										MemToReg_reg <= 2'b1x;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b11;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b001000:	begin //addi
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b100000:	begin //lb
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b1;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b11;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b00;
										load_sel_reg <= 2'b11;
										mem_sel_reg <= 1'b0;
									end
					6'b100001:	begin //lh
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b1;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b11;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b01;
										load_sel_reg <= 2'b10;
										mem_sel_reg <= 1'b0;
									end
					6'b101000:	begin //sb
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b1;
										MemToReg_reg <= 2'b1x;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b00;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b101001:	begin //sh
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b1;
										MemToReg_reg <= 2'b1x;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b01;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b100100:	begin //lbu
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b1;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b11;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b00;
										load_sel_reg <= 2'b01;
										mem_sel_reg <= 1'b0;
									end
					6'b100101:	begin //lhu
										func_in_reg = 6'b100000;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b1;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b11;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b01;
										load_sel_reg <= 2'b00;
										mem_sel_reg <= 1'b0;
									end
					6'b000100:	begin //beq
										func_in_reg = 6'b111100;
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b0;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b000101:	begin //bne
										func_in_reg = 6'b111101;
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b0;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b000001:	begin //bltz  or bgez
										if(instruction[20:16] == 5'b00001)	begin // bgez
											func_in_reg = 6'b111000;
										end
										else if(instruction[20:16] == 5'b00000) begin //bltz
											func_in_reg = 6'b111001;
										end
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b0;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b000110:	begin //blez
										func_in_reg = 6'b111110;
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b0;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b000111:	begin //bgtz
										func_in_reg = 6'b111111;
										RegDst_reg <= 2'b1x;
										ALUSrc_reg <= 1'b0;
										RegWrite_reg <= 1'b0;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b001001:	begin //addiu
										func_in_reg = 6'b100001;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b001100:	begin //andi
										func_in_reg = 6'b100100;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b001101:	begin //ori
										func_in_reg = 6'b100101;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b001110:	begin //xori
										func_in_reg = 6'b100110;
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b10;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'bxx;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
					6'b001111:	begin //lui
										func_in_reg = 6'b100000; //don't care case
										RegDst_reg <= 2'b10;
										ALUSrc_reg <= 1'b1;
										RegWrite_reg <= 1'b1;
										re_in_reg <= 1'b0;
										we_in_reg <= 1'b0;
										MemToReg_reg <= 2'b01;
										Branch_reg <= 1'b0;
										size_in_reg <= 2'b01;
										load_sel_reg <= 2'bxx;
										mem_sel_reg <= 1'b1;
									end
				endcase
			end
		end

endmodule