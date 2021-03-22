`timescale 1ns / 1ns
module ASFIFO_tb;

	parameter WIDTH = 8;
	parameter PTR   = 8;

	// 写时钟域tb信号定义
	reg					wrclk		;
	reg					wr_rst_n	;
	reg	[WIDTH-1:0]		wr_data		;
	reg 				wr_en		;
	wire				wr_full		;

	// 读时钟域tb信号定义
	reg					rdclk		;
	reg					rd_rst_n	;
	wire [WIDTH-1:0]	rd_data		;
	reg					rd_en		;
	wire				rd_empty	;
 	// 异步fifo例化
	FIFO_TOP #(
		.DATA_WIDTH(WIDTH),
		.ADDR_WIDTH(PTR)
	) inst_FIFO_TOP (
		.wr_clk   (wrclk),
		.wr_rstn  (wr_rst_n),
		.wr_en    (wr_en),
		.wr_data  (wr_data),
		.rd_clk   (rdclk),
		.rd_rstn  (rd_rst_n),
		.rd_en    (rd_en),
		.rd_data  (rd_data),
		.wr_full  (wr_full),
		.rd_empty (rd_empty)
	);
	// testbench自定义信�?
	reg					init_done	;		// testbench初始化结�?



	// FIFO初始�?
	initial	begin
		// 输入信号初始�?
		wr_rst_n  = 1	;
		rd_rst_n  = 1	;
		wrclk 	  = 0	;
		rdclk 	  = 0	;
		wr_en 	  = 0	;
		rd_en 	  = 0	;
		wr_data   = 'b0 ;
		init_done = 0	;

		// FIFO复位
		#30 wr_rst_n = 0;
			rd_rst_n = 0;
		#30 wr_rst_n = 1;
			rd_rst_n = 1;

		// 初始化完�?
		#30 init_done = 1;
	end



	// 写时�?
	always
		#2 wrclk = ~wrclk;

	// 读时�?
	always
		#4 rdclk = ~rdclk;



	// 读写控制
	always @(*) begin
		if(init_done) begin
			// 写数�?
			if( wr_full == 1'b1 )begin
				wr_en = 0;
			end
			else begin
				wr_en = 1;
			end
		end
	end

	always @(*) begin
		if(init_done) begin
			// 读数�?
			if( rd_empty == 1'b1 )begin
				rd_en = 0;
			end
			else begin
				rd_en = 1;
			end
		end
	end



	// 写入数据自增
	always @(posedge wrclk) begin
		if(init_done) begin
			if( wr_full == 1'b0 )
				wr_data <= wr_data + 1;
			else
				wr_data <= wr_data;
		end
		else begin
			wr_data <= 'b0;
		end
	end

endmodule





