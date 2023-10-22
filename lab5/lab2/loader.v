module loader(
				input [31:0] mem_out,
				input [1:0] load_sel,
				input mem_sel,
				input [1:0] pos,
				output [31:0] load_out
			);
			
			wire [31:0] load;
			wire [31:0] lb;
			wire [31:0] lh;
			wire [31:0] lbu;
			wire [31:0] lhu;
			
			/*assign lb = {{24{mem_out[31]}},mem_out[31:24]};
			assign lh = {{16{mem_out[31]}},mem_out[31:16]};
			assign lbu = {24'b0,mem_out[31:24]};
			assign lhu = {16'b0,mem_out[31:16]};*/
			
			
			reg [31:0] lb_reg;
			reg [31:0] lh_reg;
			reg [31:0] lbu_reg;
			reg [31:0] lhu_reg;
			
			assign lb = lb_reg;
			assign lh = lh_reg;
			assign lbu = lbu_reg;
			assign lhu = lhu_reg;
			
			always @(*) begin
				case(pos)
					2'b00:begin
								lb_reg <={{24{mem_out[7]}},mem_out[7:0]};
								lh_reg <={{16{mem_out[15]}},mem_out[15:0]};
								lbu_reg <={24'b0,mem_out[7:0]};
								lhu_reg <={16'b0,mem_out[15:0]};
							end
							
					2'b01:begin
								lb_reg <={{24{mem_out[15]}},mem_out[15:8]};
								lh_reg <={{16{mem_out[15]}},mem_out[15:0]};
								lbu_reg <={24'b0,mem_out[15:8]};
								lhu_reg <={16'b0,mem_out[15:0]};
							end
					2'b10:begin
								lb_reg <={{24{mem_out[23]}},mem_out[23:16]};
								lh_reg <={{16{mem_out[31]}},mem_out[31:16]};
								lbu_reg <={24'b0,mem_out[23:16]};
								lhu_reg <={16'b0,mem_out[31:16]};
							end
					2'b11:begin
								lb_reg <={{24{mem_out[31]}},mem_out[31:24]};
								lh_reg <={{16{mem_out[31]}},mem_out[31:16]};
								lbu_reg <={24'b0,mem_out[31:24]};
								lhu_reg <={16'b0,mem_out[31:16]};
							end
					default: begin
									lb_reg <={{24{mem_out[7]}},mem_out[7:0]};
									lh_reg <={{16{mem_out[15]}},mem_out[15:0]};
									lbu_reg <={24'b0,mem_out[7:0]};
									lhu_reg <={16'b0,mem_out[15:0]};
								end
				endcase
			end
			
			mux_four_n #(.WIDTH(32))
				loader_mux(
				.select(load_sel),
				.inA(lb),
				.inB(lh),
				.inC(lbu),
				.inD(lhu),
				.out(load)
				);
			n_mux #(.WIDTH(32))
				mem_mux(
				.select(mem_sel),
				.inA(mem_out),
				.inB(load),
				.out(load_out)
				);
endmodule