
//-----------------------------------------------------------------------------
// MODULE: uart_simple
//
//-----------------------------------------------------------------------------
// Description : 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  INCLUDE FILES
//-----------------------------------------------------------------------------

`include "timescale.v"
`include "spiMonitor_defines.v"

module uart_simple (
 input clk,
 input rst,
 input uart_accessReq,
 output uart_busy,
 input [7:0] uart_dataIn,
 output [7:0] uart_dataOut,
 input uart_rnw,
 input uart_rx_pad_i,
 output uart_tx_pad_o
);
parameter UART_CLK_DIV_LSB = 8'h3c;

// local wires and regs
wire [2:0] wb_addr;
wire [7:0] wb_data_from_uart;
wire [7:0] wb_data_to_uart;
wire wb_stb;
wire wb_we;
wire wb_ack;
wire dtr_pad_o;
wire int_o;
wire rts_pad_o;
wire uartTimeOut;

// -----------------------------------
// Instance of Module: uartAccess
// -----------------------------------
uartAccess #(.UART_CLK_DIV_LSB(UART_CLK_DIV_LSB)) u_uartAccess(
	.accessReq(	uart_accessReq	),
	.busy(		uart_busy	),
	.clk(		clk		),
	.dataIn(	uart_dataIn	),
	.dataOut(	uart_dataOut	),
	.readNotWrite(uart_rnw		),
	.rst(		rst	),
	.wb_addr(	wb_addr		),
	.wb_data_i(	wb_data_from_uart),
	.wb_data_o(	wb_data_to_uart),
	.wb_stb(	wb_stb		),
	.wb_we(		wb_we		),
	.wb_ack(	wb_ack		),
        .timeOutEnable( 1'b0   ),
        .timeOut(       uartTimeOut     )
	);


// -----------------------------------
// Instance of Module: uart_top
// -----------------------------------
uart_top #(.uart_data_width(`UARTMON_UART_DATA_WIDTH), .uart_addr_width(`UARTMON_UART_ADDR_WIDTH) ) u_uart_top(
	.cts_pad_i(	1'b1		),
	.dcd_pad_i(	1'b0		),
	.dsr_pad_i(	1'b0		),
	.dtr_pad_o(	dtr_pad_o	),
	.int_o(		int_o		),
	.ri_pad_i(	1'b0		),
	.rts_pad_o(	rts_pad_o	),
	.srx_pad_i(	uart_rx_pad_i		),
	.stx_pad_o(	uart_tx_pad_o		),
	.wb_ack_o(	wb_ack		),
	.wb_adr_i(	wb_addr		),
	.wb_clk_i(	clk		),
	.wb_cyc_i(	1'b1		),
	.wb_dat_i(	wb_data_to_uart	),
	.wb_dat_o(	wb_data_from_uart),
	.wb_rst_i(	rst	),
	.wb_sel_i(	4'b0000		),
	.wb_stb_i(	wb_stb		),
	.wb_we_i(	wb_we		)
	);

endmodule




