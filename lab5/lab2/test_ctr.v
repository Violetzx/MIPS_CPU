`timescale 1ns/1ps

module test_ctr();

		reg [5:0] oprand;
		reg [5:0] func;
		wire RegDst;
		wire Branch;
		wire re_in;
		wire MemToReg;
		wire [5:0] Func_in;
		wire we_in;
		wire ALUSrc;
		wire RegWrite;

initial begin
	oprand = 6'b100011;
	func = 6'b000000;
	
	#20
	
	oprand = 6'b101011;
	func = 6'b000000;
	
	#20
	
	oprand = 6'b000000;
	func = 6'b100000;

	#20
	
	oprand = 6'b001000;
	func = 6'b100000;
	
	#20
	
	oprand = 6'b000000;
	func = 6'b100010;
	
	#20
	
	oprand = 6'b000000;
	func = 6'b100100;
	
	#20
	
	oprand = 6'b000000;
	func = 6'b100101;
	
	#20
	
	oprand = 6'b000000;
	func = 6'b100111;
	
	#20
	
	oprand = 6'b000000;
	func = 6'b100110;
	
end

//Drop reset after 200 ns
	
ctr_unit ctr(
				.oprand(oprand),
				.func(func),
				.RegDst(RegDst),
				.Branch(Branch),
				.re_in(re_in),
				.MemToReg(MemToReg),
				.we_in(we_in),
				.Func_in(Func_in),
				.ALUSrc(ALUSrc),
				.RegWrite(RegWrite)
				);
				
endmodule