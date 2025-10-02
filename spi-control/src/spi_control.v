module spi_control(
    SPI_CS,
    SPI_MISO,
    SPI_MOSI,
    SPI_SCK,
    
    clk, 
    reset_n,
    uart_tx
);

  input SPI_CS;
  output SPI_MISO;
  input SPI_MOSI;
  input SPI_SCK;
  input clk;
  input reset_n;
  output uart_tx;
  
  //ram信號
  wire [14:0]RAM_Addr_A;
  wire [7:0]RAM_Read_Data_A;
  wire [7:0]RAM_Write_Data_A;
  wire RAM_Write_En_A;
  
  wire [14:0]RAM_Addr_B;
  wire [7:0]RAM_Read_Data_B;
  wire [7:0]RAM_Write_Data_B;
  wire RAM_Write_En_B;
  
  //reg信號
  wire [7:0]Reg_Addr_A;
  wire [7:0]Reg_Read_Data_A;
  wire Reg_Read_En_A;
  wire [7:0]Reg_Write_Data_A;
  wire Reg_Write_En_A;

  
  wire [7:0]Reg_Addr_B;
  wire [7:0]Reg_Read_Data_B;
  wire Reg_Read_En_B;
  wire [7:0]Reg_Write_Data_B;
  wire Reg_Write_En_B;
  
  //
  wire R_Send_En;
  wire [7:0] R_Ram_AddrH;
  wire [7:0] R_Ram_AddrL;
  wire [7:0] R_Send_Len;
  wire R_Status;
  
  //PLL相關信號
  wire clk_100M;
  wire pll_locked;
  wire Rst_n;
  assign Rst_n = pll_locked;
  
  //pll module
   mmcm mmcm
   (
    // Clock out ports
    .clk_out1(clk_100M),     // output clk_out1
    // Status and control signals
    .resetn(reset_n), // input resetn
    .locked(pll_locked),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input clk_in1
    
  SPI2CMD
  #(
      .CPOL(1'D0),
      .CPHA(1'D0),
      .BITS_ORDER(1'D1)
 )SPI2CMD(
    .Clk(clk_100M),
    .RAM_Addr(RAM_Addr_A),
    .RAM_Read_Data(RAM_Read_Data_A),
    .RAM_Write_Data(RAM_Write_Data_A),
    .RAM_Write_En(RAM_Write_En_A),
    .Reg_Addr(Reg_Addr_A),
    .Reg_Read_Data(Reg_Read_Data_A),
    .Reg_Read_En(Reg_Read_En_A),
    .Reg_Write_Data(Reg_Write_Data_A),
    .Reg_Write_En(Reg_Write_En_A),
    .Rst_n(Rst_n),
    .SPI_CS(SPI_CS),
    .SPI_MISO(SPI_MISO),
    .SPI_MOSI(SPI_MOSI),
    .SPI_SCK(SPI_SCK)
    );
    
  SPI_REG SPI_REG (
    .Clk(clk_100M),
    .Rst_n(Rst_n),
    .A_Write_En(Reg_Write_En_A),
    .A_Read_En(Reg_Read_En_A),
    .A_Reg_Addr(Reg_Addr_A),
    .A_Input_Data(Reg_Write_Data_A),
    .A_Output_Data(Reg_Read_Data_A),
    .B_Write_En(Reg_Write_En_B),
    .B_Read_En(),
    .B_Reg_Addr(Reg_Addr_B),
    .B_Input_Data(Reg_Write_Data_B),
    .B_Output_Data(),
    .R_Send_En(R_Send_En),
    .R_Ram_AddrH(R_Ram_AddrH),
    .R_Ram_AddrL(R_Ram_AddrL),
    .R_Send_Len(R_Send_Len),
    .R_Status(R_Status)
  );
    
  DPRAM DPRAM (
    .clka(clk_100M),    // input wire clka
    .wea(RAM_Write_En_A),      // input wire [0 : 0] wea
    .addra(RAM_Addr_A),  // input wire [14 : 0] addra
    .dina(RAM_Write_Data_A),    // input wire [7 : 0] dina
    .douta(RAM_Read_Data_A),  // output wire [7 : 0] douta
    .clkb(clk_100M),    // input wire clkb
    .web(RAM_Write_En_B),      // input wire [0 : 0] web
    .addrb(RAM_Addr_B),  // input wire [14 : 0] addrb
    .dinb(RAM_Write_Data_B),    // input wire [7 : 0] dinb
    .doutb(RAM_Read_Data_B)  // output wire [7 : 0] doutb
  );
  
  uart_peripheral uart_peripheral(
    .Clk(clk_100M),
    .RAM_Addr(RAM_Addr_B),
    .RAM_Read_Data(RAM_Read_Data_B),
    .RAM_Write_Data(RAM_Write_Data_B),
    .RAM_Write_En(RAM_Write_En_B),
    .R_Ram_AddrH(R_Ram_AddrH),
    .R_Ram_AddrL(R_Ram_AddrL),
    .R_Send_En(R_Send_En),
    .R_Send_Len(R_Send_Len),
    .R_Status(R_Status),
    .Reg_Addr(Reg_Addr_B),
    .Reg_Write_Data(Reg_Write_Data_B),
    .Reg_Write_En(Reg_Write_En_B),
    .Rst_n(Rst_n),
    .uart_tx(uart_tx)
    );

endmodule