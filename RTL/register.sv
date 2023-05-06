module register(input logic [31:0] a,input logic clk, rst, output logic [31:0] b);
	
	always_ff @(posedge clk)
	begin
		if (rst) b <= 32'd0;
		else b <= a;
	end

endmodule