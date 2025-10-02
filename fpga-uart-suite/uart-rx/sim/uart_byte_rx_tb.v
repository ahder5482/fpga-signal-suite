`timescale 1ns / 1ps

module uart_byte_rx_tb();

    reg Clk;
    reg Reset_n;
    reg uart_rx;
    wire [7:0]Rx_Data;
    wire Rx_Done;
    
//    assign Baud_set = 4;

    uart_byte_rx uart_byte_rx(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .uart_rx(uart_rx),
        .Rx_Data(Rx_Data),
        .Rx_Done(Rx_Done)
    );

    initial Clk = 1;
    always #10 Clk = ~Clk;
    
    initial begin
        Reset_n = 0;
        uart_rx = 1;
        #201;
        Reset_n = 1;
        #200;
        
        //8'b0101_0101
        uart_rx = 0; #(5208*20);    //起始位
        uart_rx = 1; #(5208*20);    //bit0
        uart_rx = 0; #(5208*20);    //bit1
        uart_rx = 1; #(5208*20);    //bit2
        uart_rx = 0; #(5208*20);    //bit3
        uart_rx = 1; #(5208*20);    //bit4
        uart_rx = 0; #(5208*20);    //bit5
        uart_rx = 1; #(5208*20);    //bit6
        uart_rx = 0; #(5208*20);    //bit7
        uart_rx = 1; #(5208*20);    //停止位
        #(5208*20);
        
        //8'b1010_1010
        uart_rx = 0; #(5208*20);    //起始位
        uart_rx = 0; #(5208*20);    //bit0
        uart_rx = 1; #(5208*20);    //bit1
        uart_rx = 0; #(5208*20);    //bit2
        uart_rx = 1; #(5208*20);    //bit3
        uart_rx = 0; #(5208*20);    //bit4
        uart_rx = 1; #(5208*20);    //bit5
        uart_rx = 0; #(5208*20);    //bit6
        uart_rx = 1; #(5208*20);    //bit7
        uart_rx = 1; #(5208*20);    //停止位
        #(5208*20); 
        
        //8'b1111_0000
        uart_rx = 0; #(5208*20);    //起始位
        uart_rx = 0; #(5208*20);    //bit0
        uart_rx = 0; #(5208*20);    //bit1
        uart_rx = 0; #(5208*20);    //bit2
        uart_rx = 0; #(5208*20);    //bit3
        uart_rx = 1; #(5208*20);    //bit4
        uart_rx = 1; #(5208*20);    //bit5
        uart_rx = 1; #(5208*20);    //bit6
        uart_rx = 1; #(5208*20);    //bit7
        uart_rx = 1; #(5208*20);    //停止位
        #(5208*20); 
        
        //8'b0000_1111
        uart_rx = 0; #(5208*20);    //起始位
        uart_rx = 1; #(5208*20);    //bit0
        uart_rx = 1; #(5208*20);    //bit1
        uart_rx = 1; #(5208*20);    //bit2
        uart_rx = 1; #(5208*20);    //bit3
        uart_rx = 0; #(5208*20);    //bit4
        uart_rx = 0; #(5208*20);    //bit5
        uart_rx = 0; #(5208*20);    //bit6
        uart_rx = 0; #(5208*20);    //bit7
        uart_rx = 1; #(5208*20);    //停止位
        #(5208*20); 
        $stop;                     
    
    end
    
    
    
//    initial begin
//        Reset_n = 0;
//        uart_rx = 1;
//        #201;
//        Reset_n = 1;
//        #200;
//        uart_tx_byte(8'h5a);
//        #5000;
//        uart_tx_byte(8'ha5);
//        #5000;
//        uart_tx_byte(8'h86);
//        #5000;
//        $stop;      
//    end

//    task uart_tx_byte;
//        input [7:0]tx_data;
//        begin
//            uart_rx = 1;
//            #20;
//            uart_rx = 0;    //baud=115200, 計算每bit延遲，1,000,000,000/115200 = 8680ns
//            #8680;
//            uart_rx = tx_data[0];
//            #8680
//            uart_rx = tx_data[1];
//            #868
//            uart_rx = tx_data[2];
//            #8680
//            uart_rx = tx_data[3];
//            #8680
//            uart_rx = tx_data[4];
//            #8680
//            uart_rx = tx_data[5];
//            #8680
//            uart_rx = tx_data[6];
//            #8680
//            uart_rx = tx_data[7];
//            #8680
//            uart_rx = 1;
//            #8680;   
//        end
//    endtask        






endmodule