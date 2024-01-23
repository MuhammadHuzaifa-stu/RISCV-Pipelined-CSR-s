module pc_reg (
	input  logic        clk,
	input  logic        reset, 
	input  logic [31:0] in, 
	
	output logic [31:0] pc_out
);
	
	always_ff @(posedge clk)
	begin
		if (reset) 
		begin
			pc_out <= 32'd0;
		end
		else 
		begin
			pc_out <= in;
		end
	end

endmodule: pc_reg