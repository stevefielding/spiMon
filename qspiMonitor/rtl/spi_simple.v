
//-----------------------------------------------------------------------------
// MODULE: spi_simple
//
//-----------------------------------------------------------------------------
// Description : 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  INCLUDE FILES
//-----------------------------------------------------------------------------

`include "timescale.v"
`include "spiMonitor_defines.v"

module spi_simple (
 input clk,
 input rst,
 output reg spi_cap_ready,
 output reg [31:0] spi_cap_do,
 output reg [31:0] spi_cap_di,
 input spi_di, 
 input spi_do, 
 input spi_clk,
 input spi_cs
);
parameter UART_CLK_DIV_LSB = 8'h3c;

// local wires and regs
reg [7:0] spi_clk_reg;
reg [7:0] spi_do_reg;
reg [7:0] spi_di_reg;
reg [7:0] spi_cs_reg;
reg [31:0] spi_cap_di_reg;
reg [31:0] spi_cap_do_reg;

// spi_cs goes low, and then there are 32 spi_clk pulses.
// All we need to do is register spi_do and spi_di at the rising edge of
// spi_clk
// clk should be 4x faster than spi_clk

always @(posedge clk) begin
  if (rst == 1'b1) begin
    spi_cap_di <= 32'h0000_0000;
    spi_cap_do <= 32'h0000_0000;
    spi_cap_di_reg <= 32'h0000_0000;
    spi_cap_do_reg <= 32'h0000_0000;
    spi_cap_ready <= 1'b0;
    spi_clk_reg <= 8'h00;
    spi_do_reg <= 8'h00;
    spi_di_reg <= 8'h00;
    spi_cs_reg <= 8'hff;
  end
  else begin
    // Register "spi_clk" clock domain signals
    // into the "clk" clock domain.
    spi_cap_ready <= 1'b0;
    spi_clk_reg <= {spi_clk_reg[6:0], spi_clk};
    spi_do_reg <= {spi_do_reg[6:0], spi_do};
    spi_di_reg <= {spi_di_reg[6:0], spi_di};
    spi_cs_reg <= {spi_cs_reg[6:0], spi_cs};
    // at rising edge of spi_clk, register spi_di and spi_do
    if (spi_cs_reg[4] == 1'b0 && spi_clk_reg[4] == 1'b1 && spi_clk_reg[3] == 1'b0) begin
      spi_cap_di_reg <= {spi_cap_di_reg[30:0], spi_di_reg[4]};
      spi_cap_do_reg <= {spi_cap_do_reg[30:0], spi_do_reg[4]};
    end
    // at spi_cs rising edge, register the final 32-bit values for spi_di and
    // spi_do, and indicate availability
    if (spi_cs_reg[4] == 1'b0 && spi_cs_reg[3] == 1'b1) begin
      spi_cap_di <= spi_cap_di_reg;
      spi_cap_do <= spi_cap_do_reg;
      spi_cap_ready <= 1'b1;
    end
  end
end

endmodule




