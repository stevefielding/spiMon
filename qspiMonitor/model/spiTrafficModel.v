
//-----------------------------------------------------------------------------
// MODULE: spiTrafficModel
//
//-----------------------------------------------------------------------------
// Description : 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  INCLUDE FILES
//-----------------------------------------------------------------------------

`include "timescale.v"
`include "spiMonitor_defines.v"

module spiTrafficModel (
 input clk,
 output reg spi_di, 
 output reg spi_do, 
 output reg spi_clk,
 output reg spi_cs
);

// local wires and regs
reg localReset;
reg [31:0] dataToSpi_do;
reg [31:0] dataToSpi_di;
reg spi_accessReq;
reg spi_busy;
reg [7:0] seqData1;
reg [7:0] seqData2;
reg [7:0] bitCnt;
reg [3:0] currState;

//--------------- genMultiTrans ---------------
task genMultiTrans;
input [7:0] startVal1;
input [7:0] startVal2;
input [7:0] dataLen;
input incNotDec;
reg [15:0] i;

  begin
    //write data
    seqData1 <= startVal1;
    seqData2 <= startVal2;
    for (i=1;i<=dataLen;i=i+1) begin
      @(posedge clk);
      genOneTrans({24'h00_0000, seqData1}, {seqData2, 24'h00_0000});
      if (incNotDec == 1'b1) begin 
        seqData1 <= seqData1 + 1'b1;
        seqData2 <= seqData2 + 1'b1;
      end
      else begin
        seqData1 <= seqData1 - 1'b1;
        seqData2 <= seqData2 - 1'b1;
      end
    end
  end
endtask

//--------------- genOneTrans ---------------
task genOneTrans;
input [31:0] word_di;
input [31:0] word_do;

  begin
    @(posedge clk);
    dataToSpi_di <= word_di;
    dataToSpi_do <= word_do;
    spi_accessReq <= 1'b1;
    @(posedge clk);
    spi_accessReq <= 1'b0;
    @(posedge clk);
    wait (spi_busy == 1'b0);
    @(posedge clk);
  end
endtask

// ------------------- transaction state machine -------------------
// Generate a single 32-bit spi transaction
// Drive the clock chip_select MOSI and MISO
// chip select goes low, then after a delay of 2 clock cycles, the two 32-bits
// are driven onto spi_di and spi_do on the falling edge of the clock
// Finally after a delay of 4 clock cycles spi_cs returns high.
// spi_clk = clk / 4 
parameter [3:0] WAIT_START = 4'h0;
parameter [3:0] SB1 = 4'h1;
parameter [3:0] SB2 = 4'h2;
parameter [3:0] SB3 = 4'h3;
parameter [3:0] SB4 = 4'h4;
parameter [3:0] SB5 = 4'h5;
parameter [3:0] SB6 = 4'h6;
parameter [3:0] SB7 = 4'h7;
parameter [3:0] SB8 = 4'h8;
parameter [3:0] END_TRANS = 4'h9;
always @(posedge clk) begin
  if (localReset == 1'b1) begin
    currState <= WAIT_START;
    bitCnt <= 8'h00;
    spi_busy <= 1'b0;
    spi_clk <= 1'b0;
    spi_cs <= 1'b1;
    spi_do <= 1'b0;
    spi_di <= 1'b0;
    dataToSpi_do <= 32'h0000_0000;
    dataToSpi_di <= 32'h0000_0000;
  end
  else begin
    case (currState)
      WAIT_START: begin
	spi_busy <= 1'b0;
        if (spi_accessReq == 1'b1) begin
          currState <= SB1;
	  spi_busy <= 1'b1;
	  bitCnt <= 8'h00;
	end
      end
      SB1: begin
        currState <= SB2;
	spi_cs <= 1'b0;
      end
      SB2: begin
	currState <= SB3;
      end
      SB3: begin
        currState <= SB4;
	spi_clk <= 1'b0;
	spi_do <= dataToSpi_do[31];
	spi_di <= dataToSpi_di[31];
	dataToSpi_do <= {dataToSpi_do[30:0], 1'b0};
	dataToSpi_di <= {dataToSpi_di[30:0], 1'b0};
      end
      SB4: begin
        currState <= SB5;
      end
      SB5: begin
        currState <= SB6;
	spi_clk <= 1'b1;
      end
      SB6: begin
        if (bitCnt == 8'h1f) begin
          currState <= SB7;
	end
	else begin
          currState <= SB3;
	end
        bitCnt <= bitCnt + 1'b1;
      end
      SB7: begin
	bitCnt <= 8'h00;
        currState <= SB8;
	spi_clk <= 1'b0;
	spi_do <= 1'b0;
	spi_di <= 1'b0;
      end
      SB8: begin
        if (bitCnt == 8'h04) begin
          currState <= END_TRANS;
	end
        bitCnt <= bitCnt + 1'b1;
      end
      END_TRANS: begin
        currState <= WAIT_START;
	spi_cs <= 1'b1;
      end
    endcase
  end
end






//--------------- reset ---------------
task reset;
  begin
    @(posedge clk);
    localReset <= 1'b1;
    spi_accessReq <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    localReset <= 1'b0;
    @(posedge clk);
  end
endtask
	
endmodule



