# spiMon
Monitor a hardware spi bus, and output activity to a uart. 
Connect the uart to a PC (probably via a usb/uart dongle) and analyze the bus activity.
Hard coded for 32-bit MISO and MOSI, chip select active low for duration of the transaction (plus extra), over sampling clock (you will need to generate a "clk" that is faster than spiClk), only tested with x4 oversampling. 
