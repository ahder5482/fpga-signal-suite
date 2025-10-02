module uart_byte_rx(
    Clk,
    Reset_n,
    uart_rx,
    Rx_Data,
    Rx_Done
);

    input Clk;
    input Reset_n;
    input uart_rx;
    output reg[7:0]Rx_Data;
    output reg Rx_Done;
    
    parameter CLOCK_FREQ = 50_000_000;
    parameter BAUD = 9600;
    parameter MCNT_BAUD = CLOCK_FREQ / BAUD - 1;
    
    reg [1:0]uart_rx_r;
    always@(posedge Clk)begin
        uart_rx_r[0] <= uart_rx;
        uart_rx_r[1] <= uart_rx_r[0];
    end
    
//    wire pedge_uart_rx;
////    assign pedge_uart_rx = ((uart_rx_r[1] == 0) && (uart_rx_r[0] == 1));
//    assign pedge_uart_rx = (uart_rx_r == 2'b01);
//    wire nedge_uart_rx;
////    assign nedge_uart_rx = ((uart_rx_r[1] == 1) && (uart_rx_r[0] == 0));
//    assign nedge_uart_rx = (uart_rx_r == 2'b10);
    
    //波特率分頻計數器邏輯
//    reg[8:0] Bps_DR;
//    always@(*)
//        case(Baud_set)
//            0:Bps_DR = 1000000000/9600/16/20 - 1;
//            1:Bps_DR = 1000000000/19200/16/20 - 1;
//            2:Bps_DR = 1000000000/38400/16/20 - 1;
//            3:Bps_DR = 1000000000/57600/16/20 - 1;
//            4:Bps_DR = 1000000000/115200/16/20 - 1;
//            default:Bps_DR = 1000000000/9600/16/20 - 1;
//        endcase
    //波特率分頻計數器邏輯    
    reg [29:0]baud_div_cnt;
    reg en_baud_cnt;
    reg [3:0]bit_cnt;
    
    wire w_Rx_Done;
    wire nedge_uart_rx;
    
    reg r_uart_rx;
    reg [7:0]r_Rx_Data;
    
    reg dff0_uart_rx, dff1_uart_rx;
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        baud_div_cnt <= 0;
    else if(en_baud_cnt)begin
        if(baud_div_cnt == MCNT_BAUD)
            baud_div_cnt <= 0;
        else 
            baud_div_cnt <= baud_div_cnt + 1'b1;
    end
    else
        baud_div_cnt <= 0;        
        
//    wire bps_clk_16x;
//    assign bps_clk_16x = (div_cnt == Bps_DR / 2);
    
    // reg width name number        
//    reg [2:0]r_data[7:0];   //2維array 
//    reg [2:0]sta_bit;
//    reg [2:0]sto_bit;
    
//UART 信號邊沿檢測邏輯 含uart_rx壓穩態
    always@(posedge Clk)
        dff0_uart_rx <= uart_rx;

    always@(posedge Clk)
        dff1_uart_rx <= dff0_uart_rx;

    always@(posedge Clk)
        r_uart_rx <= dff1_uart_rx;
        
    assign nedge_uart_rx = (dff1_uart_rx == 0) && (r_uart_rx == 1);                    
    
//波特率計數器使能邏輯    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        en_baud_cnt <= 0;
    else if(nedge_uart_rx)
        en_baud_cnt <= 1;
    else if((baud_div_cnt == MCNT_BAUD/2) && (bit_cnt == 0) && (dff1_uart_rx == 1))
        en_baud_cnt <= 0;
    else if((baud_div_cnt == MCNT_BAUD/2) && (bit_cnt == 9))
        en_baud_cnt <= 0;
    
//位計數器邏輯
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        bit_cnt <= 0;
    else if((bit_cnt == 9) && (baud_div_cnt == MCNT_BAUD/2))
        bit_cnt <= 0;
    else if(baud_div_cnt == MCNT_BAUD)
        bit_cnt <= bit_cnt + 1'b1;
//    else if(baud_div_cnt == MCNT_BAUD)begin
//        if(bit_cnt == 9)
//            bit_cnt <= 0;
//        else
//            bit_cnt <= bit_cnt + 1'b1;
//    end    
    
//位接收邏輯

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)   
        r_Rx_Data <= 8'd0;
    else if(baud_div_cnt == MCNT_BAUD/2)begin
        case(bit_cnt)
            1:r_Rx_Data[0] <= dff1_uart_rx;
            2:r_Rx_Data[1] <= dff1_uart_rx; 
            3:r_Rx_Data[2] <= dff1_uart_rx; 
            4:r_Rx_Data[3] <= dff1_uart_rx; 
            5:r_Rx_Data[4] <= dff1_uart_rx; 
            6:r_Rx_Data[5] <= dff1_uart_rx; 
            7:r_Rx_Data[6] <= dff1_uart_rx; 
            8:r_Rx_Data[7] <= dff1_uart_rx;
            default: r_Rx_Data <= r_Rx_Data;
        endcase
    end
    
//接收完成標志信號              
    assign w_Rx_Done = ((baud_div_cnt == MCNT_BAUD/2) && (bit_cnt == 9));
    
    always@(posedge Clk)
        Rx_Done <= w_Rx_Done;
        
    always@(posedge Clk)
        if(w_Rx_Done)
            Rx_Data <= r_Rx_Data;        
    
//reg [7:0]bps_cnt;
//always@(posedge Clk or negedge Reset_n)
//if(!Reset_n)
//    bps_cnt <= 0;
//else if(RX_EN)begin
//     if(bps_clk_16x)begin
//        if(bps_cnt == 159)
//            bps_cnt <= 0;
//        else
//            bps_cnt <= bps_cnt + 1'b1;
//     end
//     else
//        bps_cnt <= bps_cnt;
//end
//else
//    bps_cnt <= 0;
    

    
//always@(posedge Clk or negedge Reset_n)
//if(!Reset_n) begin
//    sta_bit <= 0;
//    sto_bit <= 0;
//    r_data[0] <= 0;
//    r_data[1] <= 0;
//    r_data[2] <= 0;
//    r_data[3] <= 0;
//    r_data[4] <= 0;
//    r_data[5] <= 0;
//    r_data[6] <= 0;
//    r_data[7] <= 0;
    
//end
//else if(bps_clk_16x)begin
//    case(bps_cnt)
//        0:begin
//            sta_bit <= 0;
//            sto_bit <= 0;
//            r_data[0] <= 0;
//            r_data[1] <= 0;
//            r_data[2] <= 0;
//            r_data[3] <= 0;
//            r_data[4] <= 0;
//            r_data[5] <= 0;
//            r_data[6] <= 0;
//            r_data[7] <= 0;  
//        end
//        5,6,7,8,9,10,11:sta_bit <= sta_bit + uart_rx;
//        21,22,23,24,25,26,27:r_data[0] <= r_data[0] + uart_rx;
//        37,38,39,40,41,42,43:r_data[1] <= r_data[1] + uart_rx;
//        53,54,55,56,57,58,59:r_data[2] <= r_data[2] + uart_rx;
//        69,70,71,72,73,74,75:r_data[3] <= r_data[3] + uart_rx;
//        85,86,87,88,89,90,91:r_data[4] <= r_data[4] + uart_rx;
//        101,102,103,104,105,106,107:r_data[5] <= r_data[5] + uart_rx;
//        117,118,119,120,121,122,123:r_data[6] <= r_data[6] + uart_rx;
//        133,134,135,136,137,138,139:r_data[7] <= r_data[7] + uart_rx;
//        149,150,151,152,153,154,155:sto_bit <= sto_bit + uart_rx;
//        default:;
//    endcase
//end

//always@(posedge Clk or negedge Reset_n)
//if(!Reset_n)
//    Data <= 0;
//else if(bps_clk_16x && (bps_cnt == 159))begin
//    Data[0] <= (r_data[0] >= 4)?1'b1:1'b0;
//    Data[1] <= (r_data[1] >= 4)?1'b1:1'b0;
//    Data[2] <= (r_data[2] >= 4)?1'b1:1'b0;
//    Data[3] <= (r_data[3] >= 4)?1'b1:1'b0;
//    Data[4] <= (r_data[4] >= 4)?1'b1:1'b0;
//    Data[5] <= (r_data[5] >= 4)?1'b1:1'b0;
//    Data[6] <= (r_data[6] >= 4)?1'b1:1'b0;
//    Data[7] <= (r_data[7] >= 4)?1'b1:1'b0;
//end

//always@(posedge Clk or negedge Reset_n)
//if(!Reset_n)
//    Rx_Done <= 0;
//else if((div_cnt == Bps_DR) && (bps_cnt == 159))
//    Rx_Done <= 1;
//else    
//    Rx_Done <= 0;
        
        
        

endmodule