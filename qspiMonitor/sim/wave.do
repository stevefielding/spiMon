onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider top
add wave -noupdate -radix hexadecimal /testHarness/clk
add wave -noupdate -radix hexadecimal /testHarness/rst
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartRx
add wave -noupdate -radix hexadecimal /testHarness/uR_uartTx
add wave -noupdate -radix hexadecimal /testHarness/uT_uartTx
add wave -noupdate -divider uR_uartHostModel
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/UART_CLK_DIV_LSB
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/clk
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/dataFromUART
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/dataToUART
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/dtr_pad_o
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/int_o
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/localReset
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/rts_pad_o
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/rxTimeOut
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/seqData
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/uartRx
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/uartTimeOut
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/uartTimeOutEn
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/uartTx
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/uart_accessReq
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/uart_busy
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/uart_rnw
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/wb_ack
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/wb_addr
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/wb_data_from_uart
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/wb_data_to_uart
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/wb_stb
add wave -noupdate -radix hexadecimal /testHarness/uR_uartHostModel/wb_we
add wave -noupdate -divider uR_uartInSM
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/INIT_USM
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/REQ_UART_RX_CHAR_1
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/REQ_UART_RX_CHAR_2
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/UART_CLK_DIV_LSB
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/WAIT_FOR_FIFO_NOT_FULL
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/WAIT_FOR_UART_CHAR
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/clk
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/currState
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/fifoDataIn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/fifoDataOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/fifoEmpty
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/fifoFull
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/fifoREn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/fifoWEn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/rst
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/uart_accessReq
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/uart_busy
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/uart_dataOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/uart_rx_pad_i
add wave -noupdate -divider uR_uartAccess
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/accessReq
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/busy
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/clk
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/CurrState_uartAcc
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/dataIn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/dataInReg
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/dataOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_busy
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_dataInReg
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_dataOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_timeOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_timeOutCnt
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_wb_addr
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_wb_data_o
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_wb_stb
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_wb_we
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/next_wt_cnt
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/NextState_uartAcc
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/readNotWrite
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/rst
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/timeOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/timeOutCnt
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/timeOutEnable
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/UART_CLK_DIV_LSB
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/wb_ack
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/wb_addr
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/wb_data_i
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/wb_data_o
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/wb_stb
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/wb_we
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uartInSM/u_uart_simple/u_uartAccess/wt_cnt
add wave -noupdate -divider uR_uartMonitor
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/INIT_USM
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/SEND_RX_ID
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/SEND_TX_ID
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/SEND_UART_DATA
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/WAIT_FOR_FIFO_NOT_EMPTY
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/WAIT_FOR_UART_READY1
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/WAIT_FOR_UART_READY2
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/clk
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/currState
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/rst
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/sendChar
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_fifoDataOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_fifoEmpty
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_fifoFull
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_fifoREn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uR_uart_rx_pad_i
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uT_fifoDataOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uT_fifoEmpty
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uT_fifoFull
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uT_fifoREn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uT_uart_rx_pad_i
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uart_accessReq
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uart_busy
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uart_dataIn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/uart_tx_pad_o
add wave -noupdate -divider low_speed_uart_simple
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/UART_CLK_DIV_LSB
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/clk
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/dtr_pad_o
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/int_o
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/rst
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/rts_pad_o
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uartTimeOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uart_accessReq
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uart_busy
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uart_dataIn
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uart_dataOut
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uart_rnw
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uart_rx_pad_i
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/uart_tx_pad_o
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/wb_ack
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/wb_addr
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/wb_data_from_uart
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/wb_data_to_uart
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/wb_stb
add wave -noupdate -radix hexadecimal /testHarness/u_uartMonitor/u_uart_simple/wb_we
add wave -noupdate -divider uOut_uartHostModel
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/UART_CLK_DIV_LSB
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/clk
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/dataFromUART
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/dataToUART
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/dtr_pad_o
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/int_o
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/localReset
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/rts_pad_o
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/rxChar
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/rxTimeOut
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/seqData
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/uartRx
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/uartTimeOut
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/uartTimeOutEn
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/uartTx
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/uart_accessReq
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/uart_busy
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/uart_rnw
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/wb_ack
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/wb_addr
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/wb_data_from_uart
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/wb_data_to_uart
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/wb_stb
add wave -noupdate -radix hexadecimal /testHarness/uOut_uartHostModel/wb_we
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 383
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1076208 ps}
