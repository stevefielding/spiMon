// ------------------------- qspiMonitor ----------------------
`include "spiMonitor_defines.v"

module qspiMonitor (
  input clk,
  input rst,
  output uart_tx_pad_o,
  output reg [7:0] byteCnt,
  input spi_di, 
  input spi_do, 
  input spi_clk,
  input spi_cs
);

// local wires and regs
wire [7:0] spi_fifoDataOut;
wire spi_fifoFull;
reg spi_fifoREn;
wire spi_fifoEmpty;
reg uart_accessReq;
wire uart_busy;
reg [7:0] uart_dataIn;
reg [7:0] sendChar;

spiInSM u_spiInSM(
  .clk(clk),
  .rst(rst),
  .fifoDataOut(spi_fifoDataOut),
  .fifoREn(spi_fifoREn),
  .fifoFull(spi_fifoFull),
  .fifoEmpty(spi_fifoEmpty),
  .spi_di(spi_di), 
  .spi_do(spi_do), 
  .spi_clk(spi_clk),
  .spi_cs(spi_cs)
);

uart_simple #(.UART_CLK_DIV_LSB(`UART_CLK_DIV_115KBPS)) u_uart_simple(
  .clk(clk),
  .rst(rst),
  .uart_accessReq(uart_accessReq),
  .uart_busy(uart_busy),
  .uart_dataIn(uart_dataIn),
  .uart_dataOut(),
  .uart_rnw(1'b0),
  .uart_rx_pad_i(1'b0),
  .uart_tx_pad_o(uart_tx_pad_o)
);

// state machine
// Reads chars from fifos and writes to uart
// If the fifo is full, then chars may have been lost.
// Every char that is sent is prepended by an ASCII letter
// 'R' - Uart Rx char, fifo full state detected
// 'r' - Uart Rx char, no errors
reg [3:0] currState;
parameter [3:0] INIT_USM = 4'h0;
parameter [3:0] WAIT_FOR_FIFO_NOT_EMPTY = 4'h1;
parameter [3:0] SEND_RX_ID = 4'h2;
parameter [3:0] WAIT_FOR_UART_READY1 = 4'h3;
parameter [3:0] SEND_UART_DATA = 4'h4;
parameter [3:0] WAIT_FOR_UART_READY2 = 4'h5;
parameter [3:0] GET_UR_FIFO_DATA = 4'h6;
always @(posedge clk) begin
  if (rst == 1'b1) begin
    currState <= INIT_USM;
    uart_accessReq <= 1'b0;
    uart_dataIn <= 8'h00;
    spi_fifoREn <= 1'b0;
    byteCnt <= 8'h00;
  end
  else begin
    case (currState)
      INIT_USM: begin
        // after start up, wait for uart to finish init before proceeding
        if (uart_busy == 1'b0)
          currState <= WAIT_FOR_FIFO_NOT_EMPTY;
      end
      // Wait for data in either the spififo
      // If data is available, then prepend the appropriate ID char
      // and send to UART 
      WAIT_FOR_FIFO_NOT_EMPTY: begin
        if (spi_fifoEmpty == 1'b0) begin
          if (spi_fifoFull == 1'b1)
            uart_dataIn <= `FULL_RX_ID_CHAR;
          else 
            uart_dataIn <= `NO_ERROR_RX_ID_CHAR;
          spi_fifoREn <= 1'b1;
          uart_accessReq <= 1'b1;
          currState <= SEND_RX_ID;
        end
      end
      // Read the uR fifo data
      SEND_RX_ID: begin
        uart_accessReq <= 1'b0;
        sendChar <= spi_fifoDataOut;
        spi_fifoREn <= 1'b0;
        currState <= GET_UR_FIFO_DATA;
      end
      GET_UR_FIFO_DATA: begin
        sendChar <= spi_fifoDataOut;
        currState <= WAIT_FOR_UART_READY1;
      end
      // Wait for the prepended ID byte to be accepted, 
      // and then send the actual fifo data byte 
      WAIT_FOR_UART_READY1: begin
        if (uart_busy == 1'b0) begin
          uart_accessReq <= 1'b1;
          uart_dataIn <= sendChar;
          currState <= SEND_UART_DATA;
        end
      end
      // Send the fifo data byte
      SEND_UART_DATA: begin
        uart_accessReq <= 1'b0;
        currState <= WAIT_FOR_UART_READY2;
      end
      // And wait for the fifo data byte to be accepted
      WAIT_FOR_UART_READY2: begin
        if (uart_busy == 1'b0) begin
          currState <= WAIT_FOR_FIFO_NOT_EMPTY;
          byteCnt <= byteCnt + 1'b1;
        end
      end
    endcase
  end
end


endmodule

