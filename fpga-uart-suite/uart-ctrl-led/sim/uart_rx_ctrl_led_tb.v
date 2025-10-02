`timescale 1ns / 1ps

module uart_rx_ctrl_led_tb(

);

    reg Clk;
    reg Reset_n;
    wire Led;
    reg uart_rx;


    uart_rx_ctrl_led uart_rx_ctrl_led(
        .Clk(Clk), 
        .Reset_n(Reset_n),
        .Led(Led),
        .uart_rx(uart_rx)
    );
    
    initial Clk = 1;
    always #10 Clk = ~Clk;
    
    initial begin
        Reset_n = 0;
        uart_rx = 1;
        #201;
        Reset_n = 1;
        #200;
        uart_tx_byte(8'h55);
        #90000;
        uart_tx_byte(8'ha5);
        #90000;
        uart_tx_byte(8'h12);
        #90000;
        uart_tx_byte(8'h34);
        #90000;
        uart_tx_byte(8'h56);
        #90000;
        uart_tx_byte(8'h78);
        #90000;
        uart_tx_byte(8'h9a);
        #90000;
        uart_tx_byte(8'hf0);
        #90000;
        $stop;      
    end

    task uart_tx_byte;
        input [7:0]tx_data;
        begin
            uart_rx = 1;
            #20;
            uart_rx = 0;    //baud=115200, 計算每bit延遲，1,000,000,000/115200 = 8680ns
            #8680;
            uart_rx = tx_data[0];
            #8680
            uart_rx = tx_data[1];
            #868
            uart_rx = tx_data[2];
            #8680
            uart_rx = tx_data[3];
            #8680
            uart_rx = tx_data[4];
            #8680
            uart_rx = tx_data[5];
            #8680
            uart_rx = tx_data[6];
            #8680
            uart_rx = tx_data[7];
            #8680
            uart_rx = 1;
            #8680;   
        end
    endtask        




endmodule
