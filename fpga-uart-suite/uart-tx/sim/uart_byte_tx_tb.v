`timescale 1ns / 1ns

module uart_byte_tx_tb;
    reg Clk;
    reg Reset_n;
    reg [7:0]Data;
    reg Send_en;
    reg [2:0]Baud_set;
    wire uart_tx;
    wire Tx_done;

    uart_byte_tx uart_byte_tx_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data(Data),
        .Send_en(Send_en),
        .Baud_set(Baud_set),
        .uart_tx(uart_tx),
        .Tx_done(Tx_done)
    );

    initial Clk = 1;
    always #10 Clk = ~Clk;
    
    initial begin
        Reset_n = 0;
        Data = 0;
        Send_en = 0;
        Baud_set = 4;
        #201;
        Reset_n = 1;
        #100;
        Data = 8'h57;
        Send_en = 1;
        #20;
        @(posedge Tx_done);
        Send_en = 0;
        #20000;
        Data = 8'h75;
        Send_en = 1;
        #20;
        @(posedge Tx_done);
        Send_en = 0;
        #20000;
        $stop;
    
    
    end

endmodule