`timescale 1ns / 1ns

module uart_tx_test_tb();
    reg Clk;
    reg Reset_n;
    wire uart_tx;    

    uart_tx_test uart_tx_test(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .uart_tx(uart_tx)
    );
    
    initial Clk = 1;
    always #10 Clk = ~Clk;
    
    initial begin
        Reset_n = 0;
        #201;
        Reset_n = 1;
        #50000000;
        $stop;
    end
    
    
endmodule