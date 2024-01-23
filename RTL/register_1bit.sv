module register_1bit (
	input  logic clk, 
	input  logic rst, 
	input  logic flush, 
	input  logic a, 
	
	output logic b
);
	
	always_ff @(posedge clk)
	begin
		if (rst) 
		begin
			b <= 0;
		end
		else if (flush) 
		begin
			b <= 0;
		end
		else begin
			b <= a;
		end
	end

endmodule: register_1bit