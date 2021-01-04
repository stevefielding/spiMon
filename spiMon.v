// --------------------------- spiMon -----------------------------------
// top level for Xilinx artex dev board
module spiMon(
  input GCLK,
  input JA4,
  input JA10,
  output JA1,
  output [7:0] LED
    );
    
// local wires and regs
reg [27:0] cnt;
reg heartBeat;
wire clk;
wire rst;
wire uR_uart_rx_pad_i;
wire uT_uart_rx_pad_i;
wire [7:0] byteCnt;

qspiMonitor u_qspiMonitor(
  .clk(clk),
  .rst(rst),
  .spi_di(spi_di),
  .spi_do(spi_do),
  .spi_clk(spi_clk),
  .spi_cs(spi_cs),
  .uart_tx_pad_o(uart_tx_pad_o),
  .byteCnt(byteCnt)
);

clk_wiz_0 u_clk160MHz
 (
  // Clock out ports
  .clk_out1(clk),
  // Status and control signals
  .reset(0),
  .locked(pllLocked),
 // Clock in ports
  .clk_in1(GCLK)
 );

always @(posedge clk) begin
  if (rst == 1'b1) begin
    cnt <= {28{1'b0}};
    heartBeat <= 1'b0;
  end
  else begin
    if (cnt == 28'h4C4B400) begin
      cnt <= {28{1'b0}};
      heartBeat <= ~heartBeat;
    end
    else begin
      cnt <= cnt + 1'b1;
    end
  end
end

assign rst = !pllLocked;
assign LED [6:0] = byteCnt [6:0];
assign LED [7] = heartBeat;
assign JA1 = uart_tx_pad_o;
assign spi_di = JA4;
assign spi_do = JA10;
assign spi_cs = ?;
assign spi_clk = ?;

endmodule
