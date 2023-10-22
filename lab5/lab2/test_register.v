`timescale 1ns/1ps

module test_register();

reg clock;
reg reset;

reg [4:0] read1;
reg [4:0] read2;
reg [4:0] write;
reg we;
reg [31:0] write_data;

wire [31:0] read_data1;
wire [31:0] read_data2;


//Generate clock at 100 MHz
initial begin
	clock <= 1'b0;
	reset <= 1'b0;
	forever #10 clock <= ~clock;
end

initial begin
	read1 = 5'b00001;
	read2 = 5'b00000;
	write = 5'b00001;
	we = 1'b1;
	write_data = 32'h00000001;
	
	#20
	
	read1 = 5'b00001;
	read2 = 5'b00000;
	write = 5'b00000;
	we = 1'b1;
	write_data = 32'h0000FFFF;
	
	#20
	
	read1 = 5'b00000;
	read2 = 5'b00010;
	write = 5'b00010;
	we = 1'b1;
	write_data = 32'h00000002;
	
	#20
	
	read1 = 5'b00010;
	read2 = 5'b00011;
	write = 5'b00011;
	we = 1'b1;
	write_data = 32'h00000003;
	
	#20
	
	read1 = 5'b00011;
	read2 = 5'b11111;
	write = 5'b11111;
	we = 1'b1;
	write_data = 32'hFFFFFFFF;
	
	#20
	
	read1 = 5'b11111;
	read2 = 5'b00000;
	write = 0;
	we = 1'b0;
	write_data = 32'h00000001;
	
	
	//@(negedge clock);
end

//Drop reset after 200 ns
always begin
	#200 reset <= 1'b1;
end
	
	
register registers(	
			.clk(clock),
			.rst(reset),
			.we(we),
			.read1(read1),
			.read2(read2),
			.write(write),
			.write_data(write_data),
			.read_data1(read_data1),
			.read_data2(read_data2)
			);
				
endmodule