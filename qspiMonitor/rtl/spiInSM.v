// ----------------- spiInSM -----------------------------

module spiInSM(
  input clk,
  input rst,
  output [7:0] fifoDataOut,
  input fifoREn,
  output fifoFull,
  output fifoEmpty,
  input spi_di, 
  input spi_do, 
  input spi_clk,
  input spi_cs
);

// local wires and regs
wire spi_busy;
reg spi_accessReq;
wire [7:0] spi_dataOut;
reg [7:0] fifoDataIn;
reg fifoWEn;
wire [31:0] spi_cap_do;
wire [31:0] spi_cap_di;

spi_simple u_spi_simple(
  .clk(clk),
  .rst(rst),
  .spi_cap_ready(spi_cap_ready),
  .spi_cap_do(spi_cap_do),
  .spi_cap_di(spi_cap_di),
  .spi_di(spi_di),
  .spi_do(spi_do),
  .spi_cs(spi_cs),
  .spi_clk(spi_clk)
);


fifoRTL #(.FIFO_WIDTH(8), .FIFO_DEPTH(512), .ADDR_WIDTH(9) ) u_fifo(
  .wrClk(clk),
  .rdClk(clk),
  .rstSyncToWrClk(rst), 
  .rstSyncToRdClk(rst), 
  .dataIn(fifoDataIn),
  .dataOut(fifoDataOut),
  .fifoWEn(fifoWEn), 
  .fifoREn(fifoREn), 
  .fifoFull(fifoFull), 
  .fifoEmpty(fifoEmpty), 
  .forceEmptySyncToWrClk(1'b0), 
  .forceEmptySyncToRdClk(1'b0), 
  .numElementsInFifo() );


// state machine
// Reads spi data write to fifo
// spi data is 32 bytes for spi_do and spi_di. This is arranged as a block of
// 5 chars, a start char followed by 8 bytes of data.
// Data is sent msb first
// ! (start char)
// spi_do[31:0] (4 chars)
// spi_di[31:0] (4 chars)
//
// If the fifo is full, then it waits for space in the fifo.
// If spi data is available whilst the fifo is full then they may be lost.
reg [3:0] currState;
parameter [3:0] WAIT_FOR_SPI_DATA = 4'h0;
parameter [3:0] SPI_DO_1 = 4'h1;
parameter [3:0] SPI_DO_2 = 4'h2;
parameter [3:0] SPI_DO_3 = 4'h3;
parameter [3:0] SPI_DO_4 = 4'h4;
parameter [3:0] SPI_DI_1 = 4'h5;
parameter [3:0] SPI_DI_2 = 4'h6;
parameter [3:0] SPI_DI_3 = 4'h7;
parameter [3:0] SPI_DI_4 = 4'h8;
parameter [3:0] WAIT_FOR_FIFO_NOT_FULL = 4'h9;
always @(posedge clk) begin
  if (rst == 1'b1) begin
    currState <= WAIT_FOR_SPI_DATA;
    spi_accessReq <= 1'b0;
    fifoDataIn <= 8'h00;
    fifoWEn <= 1'b0;
  end
  else begin
    case (currState)
      WAIT_FOR_SPI_DATA: begin
        if (spi_cap_ready == 1'b1) begin
          fifoDataIn <= 8'h20; //start with an exclamation mark
          fifoWEn <= 1'b1;
          currState <= SPI_DO_1;
        end
      end
      SPI_DO_1: begin
        fifoDataIn <= spi_cap_do[31:24];
        currState <= SPI_DO_2;
      end
      SPI_DO_2: begin
        fifoDataIn <= spi_cap_do[23:16];
        currState <= SPI_DO_3;
      end
      SPI_DO_3: begin
        fifoDataIn <= spi_cap_do[15:8];
        currState <= SPI_DO_4;
      end
      SPI_DO_4: begin
        fifoDataIn <= spi_cap_do[7:0];
        currState <= SPI_DI_1;
      end
      SPI_DI_1: begin
        fifoDataIn <= spi_cap_di[31:24];
        currState <= SPI_DI_2;
      end
      SPI_DI_2: begin
        fifoDataIn <= spi_cap_di[23:16];
        currState <= SPI_DI_3;
      end
      SPI_DI_3: begin
        fifoDataIn <= spi_cap_di[15:8];
        currState <= SPI_DI_4;
      end
      SPI_DI_4: begin
        fifoDataIn <= spi_cap_di[7:0];
        currState <= WAIT_FOR_FIFO_NOT_FULL;
      end
      WAIT_FOR_FIFO_NOT_FULL: begin
        fifoWEn <= 1'b0;
        if (fifoFull == 1'b0)
          currState <= WAIT_FOR_SPI_DATA;
      end
    endcase
  end
end

endmodule

