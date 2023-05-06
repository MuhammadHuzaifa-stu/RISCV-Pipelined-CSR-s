module register_1bit(input logic a, flush, clk, rst, output logic b);
	
	always_ff @(posedge clk)
	begin
		if (rst) b <= 0;
		else if (flush) b <= 0;
		else b <= a;
	end

endmodule