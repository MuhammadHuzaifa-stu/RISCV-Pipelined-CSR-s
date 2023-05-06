module pc_reg(input logic clk,reset, input logic [31:0]in , output logic [31:0]pc_out);
	
	always_ff @(posedge clk)
	begin
		if (reset) pc_out <= 32'd0;
		else pc_out <= in;
	end

endmodule