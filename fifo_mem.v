module fifo_mem #(
	DATA_WIDTH = 8,
	ADDR_WIDTH = 8)(
	input 						wr_clk,wr_rstn,wr_en,
	input 	[DATA_WIDTH-1:0]	wr_data,
	input 						wr_full,

	input 						rd_clk,rd_rst_n,rd_en,
	output 	[DATA_WIDTH-1:0]	rd_data,
	input 						rd_empty,);
endmodule