module FIFO_TOP#(
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 8)
	(
	input						wr_clk,
	input 						wr_rstn,
	input 						wr_en,
	input 	[DATA_WIDTH-1:0]	wr_data,

	input						rd_clk,
	input 						rd_rstn,
	input 						rd_en,
	output 	[DATA_WIDTH-1:0]	rd_data,

	output						wr_full,
	output 						rd_empty
	);
	//ptr_syn
	wire 	[ADDR_WIDTH:0]		wr_ptr,rd_ptr;
	reg 	[ADDR_WIDTH:0]		wr_ptr_reg,rd_ptr_reg;
	reg		[ADDR_WIDTH:0]		syn_wr_ptr,syn_rd_ptr;
	always @(posedge wr_clk or negedge wr_rstn) begin
		if (wr_rstn == 1'b0) 	{syn_rd_ptr,rd_ptr_reg} <= 0;
		else 					{syn_rd_ptr,rd_ptr_reg} <= {rd_ptr_reg,rd_ptr};
	end

	always @(posedge rd_clk or negedge rd_rstn) begin
		if (rd_rstn == 1'b0) 	{syn_wr_ptr,wr_ptr_reg} <= 0;
		else 					{syn_wr_ptr,wr_ptr_reg} <= {wr_ptr_reg,wr_ptr};
	end

	//
	wire 	[ADDR_WIDTH-1:0]	wr_addr,rd_addr;
	wr_full #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) inst_wr_full (
		.wr_clk     (wr_clk),
		.wr_rstn    (wr_rstn),
		.wr_en      (wr_en),
		.syn_rd_ptr (syn_rd_ptr),
		.wr_ptr     (wr_ptr),
		.wr_addr    (wr_addr),
		.wr_full    (wr_full)
	);
	rd_empty #(
			.ADDR_WIDTH(ADDR_WIDTH)
		) inst_rd_empty (
			.rd_clk     (rd_clk),
			.rd_rstn    (rd_rstn),
			.rd_en      (rd_en),
			.syn_wr_ptr (syn_wr_ptr),
			.rd_ptr     (rd_ptr),
			.rd_addr    (rd_addr),
			.rd_empty   (rd_empty)
		);
	fifo_ram your_instance_name (
  			.clka(wr_clk),    // input wire clka
  			.wea(wr_en & ~ wr_full),      // input wire [0 : 0] wea
  			.addra(wr_addr),  // input wire [7 : 0] addra
  			.dina(wr_data),    // input wire [7 : 0] dina
  			.clkb(rd_clk),    // input wire clkb
  			.enb(rd_en & ~ rd_empty),      // input wire enb
  			.addrb(rd_addr),  // input wire [7 : 0] addrb
  			.doutb(rd_data)  // output wire [7 : 0] doutb
	);
endmodule