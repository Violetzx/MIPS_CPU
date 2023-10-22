`timescale 1ns / 1ps
/*
**  UCSD CSE141L Lab2 Answer Module
** -------------------------------------------------------------------
**
*/
module register(
			input clk,
			input rst,
			input [4:0] read1,
			input [4:0] read2,
			input [4:0] write,
			input  we,
			input [31:0] write_data,
			output [31:0] read_data1,
			output [31:0] read_data2
			);
			
			reg [31:0] registers [0:31]; //store register
			
			assign read_data1 = registers[read1];
			assign read_data2 = registers[read2];
			
			initial 
				begin
					registers[0] <= 0;
					registers[1] <= 0;
					registers[2] <= 0;
					registers[3] <= 0;
					registers[4] <= 0;
					registers[5] <= 0;
					registers[6] <= 0;
					registers[7] <= 0;
					registers[8] <= 0;
					registers[9] <= 0;
					registers[10] <= 0;
					registers[11] <= 0;
					registers[12] <= 0;
					registers[13] <= 0;
					registers[14] <= 0;
					registers[15] <= 0;
					registers[16] <= 0;
					registers[17] <= 0;
					registers[18] <= 0;
					registers[19] <= 0;
					registers[20] <= 0;
					registers[21] <= 0;
					registers[22] <= 0;
					registers[23] <= 0;
					registers[24] <= 0;
					registers[25] <= 0;
					registers[26] <= 0;
					registers[27] <= 0;
					registers[28] <= 0;
					registers[29] <= 0;
					registers[30] <= 0;
					registers[31] <= 0;
				end
				
			always @(negedge clk)
			   begin
				if(we)
					begin
						if(write != 5'b00000)
							begin
								registers[write] <= write_data;
							end
					end
				if(rst)
					begin
						registers[0] <= 0;
						registers[1] <= 0;
						registers[2] <= 0;
						registers[3] <= 0;
						registers[4] <= 0;
						registers[5] <= 0;
						registers[6] <= 0;
						registers[7] <= 0;
						registers[8] <= 0;
						registers[9] <= 0;
						registers[10] <= 0;
						registers[11] <= 0;
						registers[12] <= 0;
						registers[13] <= 0;
						registers[14] <= 0;
						registers[15] <= 0;
						registers[16] <= 0;
						registers[17] <= 0;
						registers[18] <= 0;
						registers[19] <= 0;
						registers[20] <= 0;
						registers[21] <= 0;
						registers[22] <= 0;
						registers[23] <= 0;
						registers[24] <= 0;
						registers[25] <= 0;
						registers[26] <= 0;
						registers[27] <= 0;
						registers[28] <= 0;
						registers[29] <= 0;
						registers[30] <= 0;
						registers[31] <= 0;
					end
				end
endmodule