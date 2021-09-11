echo "Compiling design"

  vlib work
  vcom  -quiet -work work ../vhdl/spacewirecodecippackage.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodecip.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodecipfifo9x64.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodeciplinkinterface.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodecipreceiversynchronize.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodecipstatemachine.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodecipstatisticalinformationcount.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodecipsynchronizeonepulse.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodeciptimecodecontrol.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodeciptimer.vhdl
  vcom  -quiet -work work ../vhdl/spacewirecodeciptransmitter.vhdl

echo "Compiling test bench"

  vcom  -quiet -work work ../bench/tb_space_wire_codec.vhd

echo "start simulation"

  vsim -gui -t ps -novopt work.tb_space_wire_codec

echo "adding waves"

  delete wave /*

  add wave  -expand -group "dut_0 i/o"   -ports            /tb_space_wire_codec/dut_0/*
  add wave          -group "dut_0 sig"   -internal         /tb_space_wire_codec/dut_0/*

  add wave  -expand -group "dut_1 i/o"   -ports            /tb_space_wire_codec/dut_1/*
  add wave          -group "dut_1 sig"   -internal         /tb_space_wire_codec/dut_1/*

  add wave          -group "comp i/o"    -ports            /tb_space_wire_codec/dut_0/spacewirelinkinterface/*
  add wave          -group "comp sig"    -internal         /tb_space_wire_codec/dut_0/spacewirelinkinterface/*


echo "view wave forms"
  view wave
  run 50 us
  wave zoomfull

  configure wave -namecolwidth  250
  configure wave -valuecolwidth 120
  configure wave -justifyvalue right
  configure wave -signalnamewidth 1
  configure wave -snapdistance 10
  configure wave -datasetprefix 0
  configure wave -rowmargin 4
  configure wave -childrowmargin 2
  configure wave -gridoffset 0
  configure wave -gridperiod 1
  configure wave -griddelta 40
  configure wave -timeline 1
  configure wave -timelineunits us
  update
