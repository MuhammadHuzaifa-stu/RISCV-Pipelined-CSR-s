module controll (
	input  logic       clk, 
	input  logic       reset, 
	input  logic       reg_wr, 
	input  logic       wr_en, 
	input  logic       rd_en, 
	input  logic       cs, 
	input  logic       CSR_reg_wr, 
	input  logic       CSR_reg_rd, 
	input  logic       is_mret, 
	input  logic [1:0] wb_sel, 

	output logic       reg_wrMW, 
	output logic       wr_enMW, 
	output logic       rd_enMW, 
	output logic       csMW, 
	output logic       CSR_reg_wrMW, 
	output logic       CSR_reg_rdMW, 
	output logic       is_mretMW, 
	output logic [1:0] wb_selMW
);
	
	always_ff @(posedge clk) 
	begin
		if (reset) 
		begin
			reg_wrMW     <= 1'b0;
			wr_enMW      <= 1'b0;
			rd_enMW      <= 1'b0;
			wb_selMW     <= 2'b0;
			csMW 	     <= 1'b0;
			CSR_reg_wrMW <= 1'b0;
			CSR_reg_rdMW <= 1'b0;
			is_mretMW 	 <= 1'b0;
		end
		
		else begin
			reg_wrMW     <= reg_wr;
			wr_enMW      <= wr_en;
			rd_enMW      <= rd_en;
			wb_selMW     <= wb_sel;
			csMW	     <= cs;
			CSR_reg_wrMW <= CSR_reg_wr;
			CSR_reg_rdMW <= CSR_reg_rd;
			is_mretMW 	 <= is_mret;
		end
	end

endmodule: controll
