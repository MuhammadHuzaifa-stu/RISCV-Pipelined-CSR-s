module reg_IR (
	input  logic        clk, 
	input  logic        flush, 
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
		else if (flush) 
		begin
			b <= 32'd51;	// 32'd51 == 32'h00000033 => add x0,x0,x0
		end
		else 
		begin
			b <= a;
		end
	end

endmodule: reg_IR