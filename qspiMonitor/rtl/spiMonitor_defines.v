// Clock dependent constants
// UART_RESP_TIME_OUT = 10mS at 100 MHz
`ifdef SIM_COMPILE
`define UART_RESP_TIME_OUT 24'h00_0480
`define UART_CLK_DIV_MSB 8'h00
`else
`define UART_RESP_TIME_OUT 24'h0f_4240
`define UART_CLK_DIV_MSB 8'h00
`endif

// UART wb bus defines
`define UARTMON_UART_ADDR_WIDTH 3
`define UARTMON_UART_DATA_WIDTH 8

// UART baud rates for high and low speed UARTs
`define UART_CLK_DIV_10MBPS 8'h01
`ifdef SIM_COMPILE
`define UART_CLK_DIV_115KBPS 8'h02
`else
`define UART_CLK_DIV_115KBPS 8'h57
`endif

// Every character read from the high speed uart ports will be 
// prepended with one of these characters
// 'R' - Uart Rx char, fifo full state detected
// 'r' - Uart Rx char, no errors
// 'T' - Uart Tx char, fifo full state detected
// 't' - Uart Tx char, no errors
`define FULL_RX_ID_CHAR 8'h52
`define FULL_TX_ID_CHAR 8'h54
`define NO_ERROR_RX_ID_CHAR 8'h72
`define NO_ERROR_TX_ID_CHAR 8'h74
