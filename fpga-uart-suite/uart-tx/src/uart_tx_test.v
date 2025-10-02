module uart_tx_test(
    Clk,
    Reset_n,
    uart_tx
);
    input Clk;
    input Reset_n;
    output uart_tx;
    
    reg Send_Go;
    reg [7:0]Data;

    uart_byte_tx uart_byte_tx(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data(Data),
        .Send_Go(Send_Go),
        .Baud_set(3'd4),
        .uart_tx(uart_tx),
        .Tx_done(Tx_done)
    );
    
    reg [18:0]counter;   
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        counter <= 0;
    else if(counter == 499999)
        counter <= 0;
    else 
        counter <= counter + 1'b1;
        
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Send_Go <= 0;
    else if(counter == 1)
        Send_Go <= 1;
    else
        Send_Go <= 0;
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Data <= 0;
    else if(Tx_done)
        Data <= Data + 1'b1;
    
    
    
            
        

endmodule