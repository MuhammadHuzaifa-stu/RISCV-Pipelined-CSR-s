`timescale 1ps/1ps
module tb_RISCV;

	logic clk, reset;
	logic [1:0] interrupt;

	RISCV DUT (clk, reset, interrupt);
	
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		reset = 1;
		interrupt = 0;
		@(posedge clk);
		reset = 0;
		@(posedge clk);
		repeat(15) @(posedge clk);
		interrupt = 1;
		@(posedge clk);
		interrupt = 0;
		repeat(40) @(posedge clk);
		reset  = 1;
		@(posedge clk);
		reset = 0;
		$stop;
	end

endmodule
