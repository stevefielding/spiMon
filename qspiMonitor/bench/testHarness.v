//-----------------------------------------------------------------------------
// MODULE: testHarness
//
//-----------------------------------------------------------------------------
// Description : 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  INCLUDE FILES
//-----------------------------------------------------------------------------
`include "timescale.v"

module testHarness ();

reg clk;
wire spi_di;
wire spi_do;
wire spi_clk;
wire spi_cs;
reg rst;
wire [7:0] byteCnt;
wire uOut_uartRx;

`ifndef NO_WAVE
initial begin
  $dumpfile("wave.vcd");
  $dumpvars(0, testHarness);
end
`endif

// ---------------------- UUT ----------------------------
qspiMonitor u_qspiMonitor (
  .clk(clk),
  .rst(rst),
  .spi_di(spi_di), 
  .spi_do(spi_do), 
  .spi_clk(spi_clk),
  .spi_cs(spi_cs),
  .uart_tx_pad_o(uOut_uartRx),
  .byteCnt(byteCnt)
);

// ------------------ spiTrafficModel ---------------------------
// Use the output pin uartTx to geneate a serial stream that can be connected
// to UUT
spiTrafficModel u_spiTrafficModel (
  .clk(clk),
  .spi_di(spi_di), 
  .spi_do(spi_do), 
  .spi_clk(spi_clk),
  .spi_cs(spi_cs)
);

// -------------------- uartHostModel ---------------------------
// Monitor the uart serial stream from UUT, by connecting to uartRx and
// reading the received characters
uartHostModel #(.UART_CLK_DIV_LSB(`UART_CLK_DIV_115KBPS)) uOut_uartHostModel (
  .clk(clk),
  .uartRx(uOut_uartRx),
  .uartTx()
);

// ******************************  reset  ****************************** 
task reset;
begin

  rst <= 1'b1;
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  rst <= 1'b0;
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
end
endtask

// ******************************  Clock section  ******************************
// 166.6666 MHz
`define CLK_HALF_PERIOD 3
always begin
  #`CLK_HALF_PERIOD clk <= 1'b0;
  #`CLK_HALF_PERIOD clk <= 1'b1;
end


endmodule

