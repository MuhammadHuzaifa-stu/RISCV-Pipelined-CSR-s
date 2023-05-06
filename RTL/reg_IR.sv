module reg_IR(input logic [31:0] a,input logic clk, flush, rst, output logic [31:0] b);
	
	always_ff @(posedge clk)
	begin

		if (rst) b <= 32'd0;
		else if (flush) b <= 32'd51;	// 32'd51 == 32'h00000033 => add x0,x0,x0
		else b <= a;

	end

endmodule