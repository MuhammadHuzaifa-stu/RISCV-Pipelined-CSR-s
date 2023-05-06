module data_memory (input logic [31:0] addr,write_data,input logic [3:0]mask, 
					input logic clk,reset,rd_en,wr_en,cs,output logic [31:0]read_data);
	
	logic [31:0] dmemory [63:0];
	integer k;
	logic [5:0] addr2;
	logic [31:0] tmp;
	
	assign addr2 = addr[7:2]; 		//just because i have height of d memory of 64'
	assign tmp = (rd_en) ? dmemory[addr2] : 32'b0;
	
	always @(posedge clk)
	begin
		
		if (reset) begin
	
			for (k=0; k<64; k=k+1) begin
				dmemory[k] <= 32'd0;
			end
	
		end
	
	end
	
	// Read_Operation
	always_comb
	begin
	
		if (rd_en & ~(cs)) begin
			case(mask)
			4'b0000: 
				begin
					case(addr[1:0])
					2'b00: 
					begin
						read_data[7:0] = tmp[7:0];
						read_data[31:8]= tmp[7] ? 24'hffffff : 24'h000000;
					end
					
					2'b01: 
					begin
						read_data[7:0] = tmp[15:8];
						read_data[31:8]= tmp[15] ? 24'hffffff : 24'h000000;
					end
					
					2'b10: 
					begin
						read_data[7:0] = tmp[23:16];
						read_data[31:8]= tmp[23] ? 24'hffffff : 24'h000000;
					end

					2'b11: 
					begin
						read_data[7:0] = tmp[31:24];
						read_data[31:8]= tmp[31] ? 24'hffffff : 24'h000000;
					end
					endcase
				end

			4'b0001:
				begin
					case(addr[1])
					1'b0: 
					begin
						read_data[15:0] = tmp[15:0];
						read_data[31:16]= tmp[15] ? 16'hffff : 16'h0000;
					end
					
					1'b1: 
					begin
						read_data[15:0] = tmp[31:16];
						read_data[31:16]= tmp[31] ? 16'hffff : 16'h0000;
					end
					endcase
				end
			
			4'b1000:
				begin
					read_data[31:0] = tmp[31:0];
				end

			4'b0010:
				begin
					case(addr[1:0])
					2'b00: 
					begin
						read_data[7:0] = tmp[7:0];
						read_data[31:8]= 24'h000000;
					end
					
					2'b01: 
					begin
						read_data[7:0] = tmp[15:8];
						read_data[31:8]= 24'h000000;
					end

					2'b10: 
					begin
						read_data[7:0] = tmp[23:16];
						read_data[31:8]= 24'h000000;
					end
					
					2'b11: 
					begin
						read_data[7:0] = tmp[31:23];
						read_data[31:8]= 24'h000000;
					end
					endcase
				end
			
			4'b0100:
				begin
					case(addr[1])
					1'b0: 
					begin
						read_data[15:0] = tmp[15:0];
						read_data[31:16]= 16'h0000;
					end
					
					1'b1: 
					begin
						read_data[15:0] = tmp[31:16];
						read_data[31:16]= 16'h0000;
					end
					endcase
				end
			endcase
		end
	end
	
	//Write Operation
	always @(negedge clk)
	begin
		if (~(wr_en) & ~(cs)) begin
			case(mask)
				4'b0000 | 4'b0010:
				begin
					case(addr[1:0])
						2'b00: dmemory[addr2][7:0] <= write_data[7:0];
						2'b01: dmemory[addr2][7:0] <= write_data[15:8];
						2'b10: dmemory[addr2][7:0] <= write_data[23:16];
						2'b11: dmemory[addr2][7:0] <= write_data[31:24];
					endcase
				end

				4'b0001 | 4'b0100:
				begin
					case(addr[1])
						1'b0: dmemory[addr2][15:0] <= write_data[15:0];
						1'b1: dmemory[addr2][15:0] <= write_data[31:16];
					endcase	
				end
				
				4'b1000:
				begin
					dmemory[addr2][31:0] <= write_data[31:0];
				end
			endcase
		end
	end
	
endmodule