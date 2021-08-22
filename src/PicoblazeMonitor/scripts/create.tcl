create_project -force proj1 ./proj1
set_property target_language VHDL [current_project]
read_vhdl ../src/top.vhd 
read_vhdl ../src/kcpsm6.vhd
read_vhdl ../src/uart_rx6.vhd
read_vhdl ../src/uart_tx6.vhd
# read_vhdl ../psm/rom_devel/monitor.vhd
read_vhdl ../psm/my_ROM.vhd
read_vhdl ../src/debounce.vhd
read_xdc ../const/top.xdc

