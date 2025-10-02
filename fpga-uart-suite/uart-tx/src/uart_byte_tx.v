module uart_byte_tx(
    Clk,
    Reset_n,
    Data,
    Send_Go,
    Baud_set,
    uart_tx,
    Tx_done
);
    input Clk;
    input Reset_n;
    input [7:0]Data;
    input Send_Go;
    input [2:0]Baud_set;
    output reg uart_tx;
    output reg Tx_done;
    
    //這邊就是一個decoder的過程
    //Baud_set = 0, 就讓波特率 = 9600;
    //Baud_set = 1, 就讓波特率 = 19200;
    //Baud_set = 2, 就讓波特率 = 38400;
    //Baud_set = 3, 就讓波特率 = 57600;
    //Baud_set = 4, 就讓波特率 = 115200;
    reg [17:0]bps_DR;
    always@(*)
        case(Baud_set)
            0:bps_DR = 1000000000/9600/20;
            1:bps_DR = 1000000000/19200/20;
            2:bps_DR = 1000000000/38400/20;
            3:bps_DR = 1000000000/57600/20;
            4:bps_DR = 1000000000/115200/20;
            default bps_DR = 1000000000/9600/20;
        endcase

    reg Send_en;        
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Send_en <= 0;
    else if(Send_Go)
        Send_en <= 1;
    else if(Tx_done)
        Send_en <= 0;  
        
    reg [7:0]r_Data;
    always@(posedge Clk)
    if(Send_Go)
        r_Data <= Data;
    else
        r_Data <= r_Data;              
        
    reg [17:0]div_cnt;
    wire bps_clk;
    assign bps_clk = (div_cnt == 1);
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if(Send_en)begin
        if(div_cnt == bps_DR - 1)
            div_cnt <= 0;
        else 
            div_cnt <= div_cnt + 1'b1;
    end            
    else    
        div_cnt <= 0;            


    reg [3:0]bps_cnt;

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        bps_cnt <= 0;
    else if(Send_en)begin
        if(bps_clk)begin    //原本是if(div_cnt == bps_DR - 1)
            if(bps_cnt == 12)
                bps_cnt <= 0;
            else 
                bps_cnt <= bps_cnt + 1'b1;
        end
    end
    else
         bps_cnt <= 0;                
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        uart_tx <= 1'b1;
    end        
    else begin   
        case(bps_cnt)
            1:uart_tx <= 0;
            2:uart_tx <= r_Data[0];
            3:uart_tx <= r_Data[1];
            4:uart_tx <= r_Data[2];
            5:uart_tx <= r_Data[3];
            6:uart_tx <= r_Data[4];
            7:uart_tx <= r_Data[5];
            8:uart_tx <= r_Data[6];
            9:uart_tx <= r_Data[7];
            10:uart_tx <= 1;
            11:uart_tx <= 1;
            default uart_tx <= 1;
        endcase
    end 
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Tx_done <= 0;
    else if((bps_clk == 1) && (bps_cnt == 10))
        Tx_done <= 1;
    else
        Tx_done <= 0;
                                           










endmodule