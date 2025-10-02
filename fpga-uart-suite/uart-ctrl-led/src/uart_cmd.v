module uart_cmd(
    Clk,
    Reset_n,
    rx_data,
    rx_done,
    ctrl,
    time_set
);

    input Clk;
    input Reset_n;
    input [7:0]rx_data;
    input rx_done;
    output reg [7:0]ctrl;
    output reg [31:0]time_set;
    
    reg [7:0] data_str [7:0];
    
    //接收數據
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n) begin
        data_str[0] <= 0;
        data_str[1] <= 0;
        data_str[2] <= 0;
        data_str[3] <= 0;
        data_str[4] <= 0;
        data_str[5] <= 0;
        data_str[6] <= 0;
        data_str[7] <= 0;
    end
    else if(rx_done)begin
        data_str[7] <= rx_data;
        data_str[6] <= data_str[7];
        data_str[5] <= data_str[6];
        data_str[4] <= data_str[5];
        data_str[3] <= data_str[4];
        data_str[2] <= data_str[3];
        data_str[1] <= data_str[2];
        data_str[0] <= data_str[1];
    end
        

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        ctrl <= 0;
        time_set <= 0;
    end 
    else if(rx_done)begin
        if((data_str[0] == 8'h55) && (data_str[1] == 8'hA5) && (data_str[7] == 8'hF0))begin
            time_set[7:0] <= data_str[2];
            time_set[15:8] <= data_str[3];
            time_set[23:16] <= data_str[4];
            time_set[31:24] <= data_str[5];
            ctrl <= data_str[6];      
        end
    end
        


endmodule