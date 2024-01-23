module register (
	input  logic        clk, 
	input  logic        rst, 
	input  logic [31:0] a,
	
	output logic [31:0] b
);
	
	always_ff @(posedge clk)
	begin
		if (rst) 
		begin
			b <= 32'd0;
		end
		else 
		begin
			b <= a;
		end
	end

endmodule: register