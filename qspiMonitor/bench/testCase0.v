//-----------------------------------------------------------------------------
// MODULE: testCase0
//
//-----------------------------------------------------------------------------
// Description : 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  INCLUDE FILES
//-----------------------------------------------------------------------------
`include "timescale.v"
`include "spiMonitor_defines.v"

module testCase0();


initial
begin

  testHarness.u_spiTrafficModel.reset;	
  testHarness.uOut_uartHostModel.reset;	
  testHarness.reset;	
  #1000;
  $write("--------------------- uartMonitor testcase0 -------------------\n");


  // send 0x55, 0x55
  $write("[INFO] sending spi data seq beginning (0x55, 0x55) at 40Mbps\n");
  testHarness.u_spiTrafficModel.genMultiTrans(8'h55, 8'h55, 8'h02, 1'b1);
  #10000;
  // check that the data has been received
  $write("[INFO] checking receive data from low speed uart\n");
  testHarness.uOut_uartHostModel.getDataBytes(8'h55, 8'h55, 8'h02, 1'b1, `NO_ERROR_RX_ID_CHAR );

  // send 0x10, 0x00
  $write("[INFO] sending spi data sequence beginning (0x10, 0x00) at 40Mbps\n");
  testHarness.u_spiTrafficModel.genMultiTrans(8'h10, 8'h00, 8'h04, 1'b1);
  #10000;
  // check that the data has been received
  $write("[INFO] checking receive data from low speed uart\n");
  testHarness.uOut_uartHostModel.getDataBytes(8'h10, 8'h00, 8'h04, 1'b1, `NO_ERROR_RX_ID_CHAR);

  // If any of the test fails, then should never reach this point
  $write("[INFO] 0x%0x bytes received from the 40Mbps spi port\n", testHarness.byteCnt); 
  $write("[INFO] All tests passed succesfully\n"); 
  $stop;

end

endmodule


