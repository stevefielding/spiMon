
//-----------------------------------------------------------------------------
// MODULE: uartHostModel
//
//-----------------------------------------------------------------------------
// Description : 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  INCLUDE FILES
//-----------------------------------------------------------------------------

`include "timescale.v"
`include "spiMonitor_defines.v"

module uartHostModel (
 clk,
 uartRx,
 uartTx
);

input clk;
input uartRx;
output uartTx;

parameter UART_CLK_DIV_LSB = 8'h3c;

// local wires and regs
reg localReset;
reg uart_rnw;
reg [7:0] dataToUART;
reg uart_accessReq;
wire uart_busy;
wire [7:0] dataFromUART;
wire [2:0] wb_addr;
wire [7:0] wb_data_from_uart;
wire [7:0] wb_data_to_uart;
wire wb_stb;
wire wb_we;
wire wb_ack;
wire dtr_pad_o;
wire int_o;
wire rts_pad_o;
reg uartTimeOutEn;
wire uartTimeOut;
reg rxTimeOut;
reg [31:0] seqData1;
reg [31:0] seqData2;
reg [7:0] rxChar;
reg oddPass;

//--------------- getDataBytes ---------------
task getDataBytes;
input [7:0] startVal1;
input [7:0] startVal2;
input [7:0] dataLen;
input incNotDec;
input [7:0] idByte;
reg [15:0] i;
reg [15:0] j;

  begin
    //read data
    seqData1 <= startVal2;
    seqData2 <= startVal1;
    oddPass <= 1'b1;
    for (i=1;i<=dataLen;i=i+1) begin
      for (j=1;j<=18;j=j+1) begin
        @(posedge clk);
        getChar(rxChar, rxTimeOut);
        @(posedge clk);
        if (oddPass == 1'b1) begin
          oddPass <= 1'b0;
          if (rxChar != idByte) begin
            $write("[ERROR] rxChar: 0x%0x not equal to idByte: 0x%0x\n", rxChar, idByte);
            $stop;
          end
        end
        else begin
          oddPass <= 1'b1;
	  case (j)
            // leading exclamation mark
	    2: begin
	      if (rxChar != 8'h20) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData1: 0x20\n", rxChar);
                $stop;
              end
            end
	    // first 32-bit word
	    4: begin
	      if (rxChar != seqData1) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData1: 0x%0x\n", rxChar, seqData1);
                $stop;
              end
	    end
	    6: begin
	      if (rxChar != 8'h00) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData1: 0x00\n", rxChar);
                $stop;
              end
	    end
	    8: begin
	      if (rxChar != 8'h00) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData1: 0x00\n", rxChar);
                $stop;
              end
	    end
	    10: begin
	      if (rxChar != 8'h00) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData1: 0x00\n", rxChar);
                $stop;
              end
	    end

	    // second 32-bit word
	    12: begin
	      if (rxChar != 8'h00) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData2: 0x00\n", rxChar);
                $stop;
              end
	    end
	    14: begin
	      if (rxChar != 8'h00) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData2: 0x00\n", rxChar);
                $stop;
              end
	    end
	    16: begin
	      if (rxChar != 8'h00) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData2: 0x00\n", rxChar);
                $stop;
              end
	    end
	    18: begin
	      if (rxChar != seqData2) begin
                $write("[ERROR] rxChar: 0x%0x not equal to seqData2: 0x%0x\n", rxChar, seqData2);
                $stop;
              end
	    end
          endcase
	end
      end
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

//--------------- getChar ---------------
task getChar;
output [7:0] char;
output timeOut;

  begin
    @(posedge clk);
    uart_rnw <= 1'b1;
    uart_accessReq <= 1'b1;
    //uartTimeOutEn <= 1'b1;
    uartTimeOutEn <= 1'b0;
    @(posedge clk);
    uart_accessReq <= 1'b0;
    @(posedge clk);
    wait (uart_busy == 1'b0);
    char <= dataFromUART;
    timeOut <= uartTimeOut;
    @(posedge clk);
  end
endtask


// -----------------------------------
// Instance of Module: uartAccess
// -----------------------------------
uartAccess #(.UART_CLK_DIV_LSB(UART_CLK_DIV_LSB)) sim_uartAccess(
	.accessReq(	uart_accessReq	),
	.busy(		uart_busy	),
	.clk(		clk		),
	.dataIn(	dataToUART	),
	.dataOut(	dataFromUART	),
	.readNotWrite(uart_rnw		),
	.rst(		localReset	),
	.wb_addr(	wb_addr		),
	.wb_data_i(	wb_data_from_uart),
	.wb_data_o(	wb_data_to_uart),
	.wb_stb(	wb_stb		),
	.wb_we(		wb_we		),
	.wb_ack(	wb_ack		),
        .timeOutEnable( uartTimeOutEn   ),
        .timeOut(       uartTimeOut     )
	);


// -----------------------------------
// Instance of Module: uart_top
// -----------------------------------
uart_top #(.uart_data_width(`UARTMON_UART_DATA_WIDTH), .uart_addr_width(`UARTMON_UART_ADDR_WIDTH) ) sim_uart_top(
	.cts_pad_i(	1'b1		),
	.dcd_pad_i(	1'b0		),
	.dsr_pad_i(	1'b0		),
	.dtr_pad_o(	dtr_pad_o	),
	.int_o(		int_o		),
	.ri_pad_i(	1'b0		),
	.rts_pad_o(	rts_pad_o	),
	.srx_pad_i(	uartRx		),
	.stx_pad_o(	uartTx		),
	.wb_ack_o(	wb_ack		),
	.wb_adr_i(	wb_addr		),
	.wb_clk_i(	clk		),
	.wb_cyc_i(	1'b1		),
	.wb_dat_i(	wb_data_to_uart	),
	.wb_dat_o(	wb_data_from_uart),
	.wb_rst_i(	localReset	),
	.wb_sel_i(	4'b0000		),
	.wb_stb_i(	wb_stb		),
	.wb_we_i(	wb_we		)
	);



//--------------- reset ---------------
task reset;
  begin
    @(posedge clk);
    localReset <= 1'b1;
    uart_accessReq <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    localReset <= 1'b0;
    @(posedge clk);
  end
endtask
	
endmodule



