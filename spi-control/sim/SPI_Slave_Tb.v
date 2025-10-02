`timescale 1ns / 1ps

module SPI_Slave_Tb();

reg Clk;
reg Rst_n;
reg Send_Data_Valid;
reg [7:0]Send_Data;
wire [7:0]Recive_Data;
wire [15:0]Trans_Cnt;
wire Data_Valid;
wire Trans_Done;
wire Trans_State;
reg SPI_CS;
reg SPI_SCK;
reg SPI_MOSI;
wire SPI_MISO;
wire Trans_Start;
wire Trans_End;

localparam Data = 8'hAA;

initial Clk = 0;
always #10 Clk = ~Clk;

initial begin
    Rst_n = 0;
    Send_Data = 8'h56;
    Send_Data_Valid = 1;
    SPI_CS = 1;
    SPI_SCK = 0;
    #33
    Rst_n = 1;
    #83;
    SPI_CS = 0;
    SPI_MOSI = Data[7];
    #93;
    SPI_SCK = 1;//1
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[6];
    #54
    SPI_SCK = 1;//2
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[5];
    #54
    SPI_SCK = 1;//3
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[4];
    #54
    SPI_SCK = 1;//4
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[3];
    #54
    SPI_SCK = 1;//5
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[2];
    #54
    SPI_SCK = 1;//6
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[1];
    #54
    SPI_SCK = 1;//7
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[0];
    #54
    SPI_SCK = 1;//8
    #54
    SPI_SCK = 0;
    #93
    Send_Data = 8'h8F;
    Send_Data_Valid = 1;
    #88
    SPI_CS = 1;
    #100
        #83;
    SPI_CS = 0;
    SPI_MOSI = Data[7];
    #93;
    SPI_SCK = 1;//1
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[6];
    #54
    SPI_SCK = 1;//2
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[5];
    #54
    SPI_SCK = 1;//3
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[4];
    #54
    SPI_SCK = 1;//4
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[3];
    #54
    SPI_SCK = 1;//5
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[2];
    #54
    SPI_SCK = 1;//6
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[1];
    #54
    SPI_SCK = 1;//7
    #54
    SPI_SCK = 0;
    SPI_MOSI = Data[0];
    #54
    SPI_SCK = 1;//8
    #54
    SPI_SCK = 0;
    #93
    SPI_CS = 1;
    #100
    $stop;
end


SPI_Slave # 
(
    .CPHA(0),       
    .BITS_ORDER(1)  
) SPI_Slave (
    .Clk(Clk),
    .Rst_n(Rst_n),
    .Send_Data_Valid(Send_Data_Valid),
    .Send_Data(Send_Data),
    .Recive_Data(Recive_Data),
    .Trans_Done(Trans_Done),
    .Trans_Cnt(Trans_Cnt),
    .Recive_Data_Valid(Data_Valid),
    .SPI_CS(SPI_CS),
    .SPI_SCK(SPI_SCK), 
    .SPI_MOSI(SPI_MOSI),
    .SPI_MISO(SPI_MISO),
    .Trans_Start(Trans_Start),
    .Trans_End(Trans_End)
);

endmodule
