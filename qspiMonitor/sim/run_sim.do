
vsim +no_identifier +notimingchecks testHarness testCase0 -L unisims_ver -L xilinxcorelib_ver

view signals wave structure
do wave.do
run -all

  
