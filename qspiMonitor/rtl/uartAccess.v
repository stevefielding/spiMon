
//-----------------------------------------------------------------------------
// MODULE: uartAccess
//-----------------------------------------------------------------------------
// Description : 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  INCLUDE FILES
//-----------------------------------------------------------------------------

`include "timescale.v"
`include "uart_defines.v"
`include "spiMonitor_defines.v"


module uartAccess (accessReq, busy, clk, dataIn, dataOut, readNotWrite, rst, wb_ack, wb_addr, wb_data_i, wb_data_o, wb_stb, wb_we, timeOutEnable, timeOut);
input   accessReq;
input   clk;
input   [7:0]dataIn;
input   readNotWrite;
input   rst;
input   wb_ack;
input   [7:0]wb_data_i;
output  busy;
output  [7:0]dataOut;
output  [2:0]wb_addr;
output  [7:0]wb_data_o;
output  wb_stb;
output  wb_we;
input timeOutEnable;
output reg timeOut;

parameter UART_CLK_DIV_LSB = 8'h3c;

wire    accessReq;
reg     busy, next_busy;
wire    clk;
wire    [7:0]dataIn;
reg     [7:0]dataOut, next_dataOut;
wire    readNotWrite;
wire    rst;
wire    wb_ack;
reg     [2:0]wb_addr, next_wb_addr;
wire    [7:0]wb_data_i;
reg     [7:0]wb_data_o, next_wb_data_o;
reg     wb_stb, next_wb_stb;
reg     wb_we, next_wb_we;
reg     [23:0] timeOutCnt, next_timeOutCnt;
reg     next_timeOut;

// diagram signals declarations
reg  [7:0]dataInReg, next_dataInReg;
reg  [1:0]wt_cnt, next_wt_cnt;

// BINARY ENCODED state machine: uartAcc
// State codes definitions:
`define J1_S3 4'b0000
`define WT_REQ 4'b0001
`define START 4'b0010
`define WR_STS 4'b0011
`define WR_DATA 4'b0100
`define RD_DATA 4'b0101
`define RD_STS 4'b0110
`define INIT_UART_DIV_LO 4'b0111
`define INIT_UART_LC_REG 4'b1000
`define INIT_UART_DIV_HI 4'b1001
`define INIT_UART_EN_DIV 4'b1010

reg [3:0]CurrState_uartAcc, NextState_uartAcc;

// Diagram actions (continuous assignments allowed only: assign ...)
// diagram ACTION


// Machine: uartAcc

// NextState logic (combinatorial)
always @ (*)
begin
  NextState_uartAcc <= CurrState_uartAcc;
  // Set default values for outputs and signals
  next_busy <= busy;
  next_dataInReg <= dataInReg;
  next_wb_we <= wb_we;
  next_wb_stb <= wb_stb;
  next_wb_addr <= wb_addr;
  next_wb_data_o <= wb_data_o;
  next_dataOut <= dataOut;
  next_wt_cnt <= wt_cnt;
  next_timeOutCnt <= timeOutCnt;
  next_timeOut <= timeOut;
  case (CurrState_uartAcc)  // synopsys parallel_case full_case
    `WT_REQ:
    begin
      next_busy <= 1'b0;
      if (accessReq == 1'b1)
      begin
        NextState_uartAcc <= `J1_S3;
        next_busy <= 1'b1;
        next_dataInReg <= dataIn;
      end
    end
    `START:
    begin
      next_busy <= 1'b1;
      next_wb_we <= 1'b0;
      next_wb_stb <= 1'b0;
      next_wb_addr <= 3'b000;
      next_wb_data_o <= 8'h00;
      next_dataOut <= 8'h00;
      next_dataInReg <= 8'h00;
      next_wt_cnt <= 2'b00;
      next_timeOutCnt <= {24{1'b0}};
      next_timeOut <= 1'b0;
      NextState_uartAcc <= `INIT_UART_EN_DIV;
    end
    `J1_S3:
    begin
      if (readNotWrite == 1'b1)
      begin
        NextState_uartAcc <= `RD_STS;
        next_timeOutCnt <= {24{1'b0}};
        next_timeOut <= 1'b0;
      end
      else
      begin
        NextState_uartAcc <= `WR_STS;
      end
    end
    `RD_DATA:
    begin
      next_wb_addr <= `UART_REG_RB;
      next_wb_stb <= 1'b1;
      if (wb_ack == 1'b1)
      begin
        NextState_uartAcc <= `WT_REQ;
        next_wb_stb <= 1'b0;
        next_dataOut <= wb_data_i;
      end
    end
    `RD_STS:
    begin
      next_wb_addr <= `UART_REG_LS;
      next_wb_we <= 1'b0;
      next_wb_stb <= 1'b1;
      next_timeOutCnt <= timeOutCnt + 1'b1;
      if (wb_data_i[0] == 1'b1 && wb_ack == 1'b1)
      begin
        NextState_uartAcc <= `RD_DATA;
        next_wb_stb <= 1'b0;
      end
      else if (timeOutCnt == `UART_RESP_TIME_OUT && timeOutEnable == 1'b1) begin
        NextState_uartAcc <= `WT_REQ;
        next_timeOut <= 1'b1;
      end
    end
    `WR_STS:
    begin
      next_wb_addr <= `UART_REG_LS;
      next_wb_we <= 1'b0;
      next_wb_stb <= 1'b1;
      if (wb_ack == 1'b1 && wb_data_i[5] == 1'b1)
      begin
        NextState_uartAcc <= `WR_DATA;
        next_wb_stb <= 1'b0;
      end
    end
    `WR_DATA:
    begin
      next_wb_addr <= `UART_REG_TR;
      next_wb_we <= 1'b1;
      next_wb_stb <= 1'b1;
      next_wb_data_o <= dataInReg;
      if (wb_ack == 1'b1)
      begin
        NextState_uartAcc <= `WT_REQ;
        next_wb_stb <= 1'b0;
        next_wb_we <= 1'b0;
      end
    end
    `INIT_UART_DIV_LO:
    begin
      next_wb_addr <= `UART_REG_DL1;
      //Divisor LSB
      next_wb_stb <= 1'b1;
      next_wb_data_o <= UART_CLK_DIV_LSB;
      if (wb_ack == 1'b1)
      begin
        NextState_uartAcc <= `INIT_UART_LC_REG;
        next_wb_stb <= 1'b0;
      end
    end
    `INIT_UART_LC_REG:
    begin
      next_wb_addr <= `UART_REG_LC;
      next_wb_stb <= 1'b1;
      next_wb_data_o <= 8'h03;
      //8-data, no-parity, 1-stop
      if (wb_ack == 1'b1)
      begin
        NextState_uartAcc <= `WT_REQ;
        next_wb_stb <= 1'b0;
        next_wb_we <= 1'b0;
      end
    end
    `INIT_UART_DIV_HI:
    begin
      next_wb_addr <= `UART_REG_DL2;
      //Divisor MSB
      next_wb_stb <= 1'b1;
      next_wb_data_o <= `UART_CLK_DIV_MSB;
      if (wb_ack == 1'b1)
      begin
        NextState_uartAcc <= `INIT_UART_DIV_LO;
        next_wb_stb <= 1'b0;
      end
    end
    `INIT_UART_EN_DIV:
    begin
      next_wb_addr <= `UART_REG_LC;
      next_wb_we <= 1'b1;
      next_wb_stb <= 1'b1;
      next_wb_data_o <= 8'h80;
      // Enable divisor access
      if (wb_ack == 1'b1)
      begin
        NextState_uartAcc <= `INIT_UART_DIV_HI;
        next_wb_stb <= 1'b0;
      end
    end
  endcase
end

// Current State Logic (sequential)
always @ (posedge clk)
begin
  if (rst)
    CurrState_uartAcc <= `START;
  else
    CurrState_uartAcc <= NextState_uartAcc;
end

// Registered outputs logic
always @ (posedge clk)
begin
  if (rst)
  begin
    busy <= 1'b1;
    wb_we <= 1'b0;
    wb_stb <= 1'b0;
    wb_addr <= 3'b000;
    wb_data_o <= 8'h00;
    dataOut <= 8'h00;
    dataInReg <= 8'h00;
    wt_cnt <= 2'b00;
    timeOutCnt <= {24{1'b0}};
    timeOut <= 1'b0;
  end
  else 
  begin
    busy <= next_busy;
    wb_we <= next_wb_we;
    wb_stb <= next_wb_stb;
    wb_addr <= next_wb_addr;
    wb_data_o <= next_wb_data_o;
    dataOut <= next_dataOut;
    dataInReg <= next_dataInReg;
    wt_cnt <= next_wt_cnt;
    timeOutCnt <= next_timeOutCnt;
    timeOut <= next_timeOut;
  end
end




`ifndef SIM_COMPILE
//`define LA_UACC_DEBUG
`endif

`ifdef LA_UACC_DEBUG

wire [63:0] acq_trigger_in_sig;

assign acq_trigger_in_sig[3:0] = CurrState_uartAcc;
assign acq_trigger_in_sig[4] = accessReq;
assign acq_trigger_in_sig[5] = busy;
assign acq_trigger_in_sig[6] = wb_stb;
assign acq_trigger_in_sig[7] = timeOut;
assign acq_trigger_in_sig[15:8] = dataIn;
assign acq_trigger_in_sig[23:16] = dataOut;
assign acq_trigger_in_sig[24] = rst;
assign acq_trigger_in_sig[25] = wb_we;


wire [35 : 0] CONTROL0;

chipscope_icon u_chipscope_icon (
  .CONTROL0(CONTROL0)
);

chipscope_ila u_chipscope_ila (
  .CONTROL(CONTROL0),
  .CLK(clk),
  .TRIG0(acq_trigger_in_sig )
);

`endif

endmodule
