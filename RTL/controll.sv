module controll(input logic clk, reset, reg_wr, wr_en, rd_en, cs, CSR_reg_wr, CSR_reg_rd, is_mret, input logic [1:0] wb_sel, 
				output logic reg_wrMW, wr_enMW, rd_enMW, csMW, CSR_reg_wrMW, CSR_reg_rdMW, is_mretMW, output logic [1:0] wb_selMW);
	
	always_ff @(posedge clk) begin
	
		if (reset) begin
			reg_wrMW <= 0;
			wr_enMW  <= 0;
			rd_enMW  <= 0;
			wb_selMW <= 0;
			csMW 	 <= 0;
			CSR_reg_wrMW <= 0;
			CSR_reg_rdMW <= 0;
			is_mretMW 	 <= 0;
		end
		
		else begin
			reg_wrMW <= reg_wr;
			wr_enMW  <= wr_en;
			rd_enMW  <= rd_en;
			wb_selMW <= wb_sel;
			csMW	 <= cs;
			CSR_reg_wrMW <= CSR_reg_wr;
			CSR_reg_rdMW <= CSR_reg_rd;
			is_mretMW 	 <= is_mret;
		end
	end
endmodule
