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

  add wave  -expand -group "dut i/o"   -ports            /tb_space_wire_codec/dut/*
  add wave          -group "dut sig"   -internal         /tb_space_wire_codec/dut/*
    
  add wave          -group "comp i/o"  -ports            /tb_space_wire_codec/dut/spacewirelinkinterface/*
  add wave          -group "comp i/o"  -internal         /tb_space_wire_codec/dut/spacewirelinkinterface/*
  


echo "view wave forms"
  view wave
  run 50 us
  wave zoomfull
  