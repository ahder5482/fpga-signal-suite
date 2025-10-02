`timescale 1ns / 1ns
`define WR_CLK_PERIOD 10
`define RD_CLK_PERIOD 30

module dcfifo_tb();
	reg rst;
	reg wr_clk;
	reg rd_clk;
	reg [7:0]din;
	reg wr_en;
	reg rd_en;  
	wire [7:0]dout;
	wire full;
	wire almost_full;
	wire wr_ack;
	wire overflow;
	wire empty;
	wire almost_empty;
	wire valid;
	wire underflow;
	wire [7:0]rd_data_count;
	wire [7:0]wr_data_count;
	wire  wr_rst_busy;
	wire  rd_rst_busy;
  
	initial wr_clk = 1;
	always #(`WR_CLK_PERIOD/2) wr_clk = ~wr_clk;

	initial rd_clk = 1;
	always #(`RD_CLK_PERIOD/2) rd_clk = ~rd_clk;
  
	initial begin
		rst   = 1'b1;
		wr_en = 1'b0;
		rd_en = 1'b0;
		din   = 8'hff;
		#(`WR_CLK_PERIOD*8+1);
		rst = 1'b0;
    
		@(negedge wr_rst_busy);    
    //write data
		while(full == 1'b0)
		begin
		@(posedge wr_clk);
			#1;      
			wr_en = 1'b1;
			din   = din + 1'b1;
		end
    
    //再多寫一個數據，看overflow的變化
		din = 8'hff;
		@(posedge wr_clk);
		wr_en = 1'b0;

		wait(rd_rst_busy == 1'b0);
		#2000;
    
		while(empty == 1'b0)
		begin      
		@(posedge rd_clk);
			#1;
			rd_en = 1'b1;
		end
    //再多給一個讀使能，看underflow的變化
		@(posedge rd_clk);
		rd_en = 1'b0; 
    
    //reset
		#200;
		rst   = 1'b1;
		#(`WR_CLK_PERIOD*3+1);
		rst = 1'b0;
		@(negedge wr_rst_busy);
		wait(rd_rst_busy == 1'b0);
		
		#2000;
		$stop;	
		end

	dcfifo dcfifo_inst (
		.rst(rst), // input wire rst
		.wr_clk(wr_clk), // input wire wr_clk
		.rd_clk(rd_clk), // input wire rd_clk
		.din(din), // input wire [7 : 0] din
		.wr_en(wr_en), // input wire wr_en
		.rd_en(rd_en), // input wire rd_en
		.dout(dout), // output wire [7 : 0] dout
		.full(full), // output wire full
		.almost_full(almost_full), // output wire almost_full
		.wr_ack(wr_ack), // output wire wr_ack
		.overflow(overflow), // output wire overflow
		.empty(empty), // output wire empty
		.almost_empty(almost_empty), // output wire almost_empty
		.valid(valid), // output wire valid
		.underflow(underflow), // output wire underflow
		.rd_data_count(rd_data_count), // output wire [7 : 0] rd_data_count
		.wr_data_count(wr_data_count), // output wire [7 : 0] wr_data_count
		.wr_rst_busy(wr_rst_busy), // output wire wr_rst_busy
		.rd_rst_busy(rd_rst_busy)  // output wire rd_rst_busy
	);

endmodule
