module led_flash_s4(
    Clk,
    Reset_n,
    Ctrl,
    Time,
    Led
);

    input Clk;
    input Reset_n;
    input [7:0] Ctrl;
    input [31:0] Time;
    output [7:0] Led;
    reg [7:0] Led;
    
    //parameter MCNT = 100000000;
    
    reg [31 :0] counter;
    //reg [1:0] state;
    
    always@(posedge Clk or negedge Reset_n)
        if(!Reset_n)
            counter <= 0;
        else if(counter == Time - 1)
            counter <= 0;
        else
            counter <= counter + 1'b1;            
      
    reg [2:0] counter2;    
    
    always@(posedge Clk or negedge Reset_n)
        if(!Reset_n)
            counter2 <= 0;
        else if(counter == Time -1)
            counter2 <= counter2 + 1'b1;
    
                           
    always@(posedge Clk or negedge Reset_n)
        if(!Reset_n)
            Led <= 0;
        else
            case(counter2)
                0:Led <= Ctrl[0];
                1:Led <= Ctrl[1];
                2:Led <= Ctrl[2];
                3:Led <= Ctrl[3];
                4:Led <= Ctrl[4];
                5:Led <= Ctrl[5];
                6:Led <= Ctrl[6];
                7:Led <= Ctrl[7];
                default:Led <= Led;
            endcase                                            
                           

endmodule