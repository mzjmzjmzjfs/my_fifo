module rd_empty#(
	parameter ADDR_WIDTH = 8)(
	input 						rd_clk,
	input 						rd_rstn,
	input 						rd_en,
	input 	[ADDR_WIDTH:0]		syn_wr_ptr,

	output 	[ADDR_WIDTH:0]		rd_ptr,
	output  [ADDR_WIDTH-1:0]	rd_addr,
	output 		reg				rd_empty
	);

	reg		[ADDR_WIDTH:0]		rd_tpr_gray;
	wire 	[ADDR_WIDTH:0]		rd_tpr_gray_next;
	reg 	[ADDR_WIDTH:0]		rd_ptr_bin;
	wire 	[ADDR_WIDTH:0]		rd_ptr_bin_next;

	//count bin & gray rd_addr
	always @(posedge rd_clk or negedge rd_rstn) begin
		if (rd_rstn == 1'b0) 	{rd_ptr_bin,rd_tpr_gray} <= 0;
		else 					{rd_ptr_bin,rd_tpr_gray} <= {rd_ptr_bin_next,rd_tpr_gray_next};
	end
	assign rd_ptr = rd_tpr_gray;
	assign rd_addr = rd_ptr_bin[ADDR_WIDTH-1:0];
	assign rd_ptr_bin_next = rd_ptr_bin + (rd_en & ~ rd_empty);
	assign rd_tpr_gray_next = (rd_ptr_bin_next >> 1) ^ rd_ptr_bin_next;

	//generate rd_empty
	wire 						rd_empty_reg;
	assign rd_empty_reg = (syn_wr_ptr == rd_ptr);
	always @(posedge rd_clk or negedge rd_rstn) begin
		if (rd_rstn == 1'b0) rd_empty <= 0;
		else 				 rd_empty <= rd_empty_reg;
	end
endmodule