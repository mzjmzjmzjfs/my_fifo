module wr_full#(
	parameter ADDR_WIDTH = 8)(
	input 	 					wr_clk,
	input 						wr_rstn,
	input 						wr_en,
	input 	[ADDR_WIDTH:0]		syn_rd_ptr,

	output  [ADDR_WIDTH:0]		wr_ptr,
	output	[ADDR_WIDTH-1:0] 	wr_addr,
	output 	reg					wr_full);

	reg		[ADDR_WIDTH:0]		wr_tpr_gray;
	wire 	[ADDR_WIDTH:0]		wr_tpr_gray_next;
	reg 	[ADDR_WIDTH:0]		wr_ptr_bin;
	wire 	[ADDR_WIDTH:0]		wr_ptr_bin_next;
	//count bin & gray wr_addr
	always @(posedge wr_clk or negedge wr_rstn) begin
		if (wr_rstn == 1'b0) 	{wr_ptr_bin,wr_tpr_gray} <= 16'b0;
		else 					{wr_ptr_bin,wr_tpr_gray} <= {wr_ptr_bin_next,wr_tpr_gray_next};
	end
	assign wr_ptr = wr_tpr_gray;
	assign wr_addr = wr_ptr_bin[ADDR_WIDTH-1:0];
	assign wr_ptr_bin_next = wr_ptr_bin + (wr_en & ~ wr_full);
	assign wr_tpr_gray_next = (wr_ptr_bin_next >> 1) ^ wr_ptr_bin_next;

	//generate wr_full
	wire 						wr_full_reg;
	assign wr_full_reg = ({~syn_rd_ptr[ADDR_WIDTH:ADDR_WIDTH-1],syn_rd_ptr[ADDR_WIDTH-2:0]} == wr_ptr);
	always @(posedge wr_clk or negedge wr_rstn) begin
		if (wr_rstn == 1'b0) wr_full <= 0;
		else 				 wr_full <= wr_full_reg;
	end
endmodule