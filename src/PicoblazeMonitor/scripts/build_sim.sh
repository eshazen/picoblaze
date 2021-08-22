#!/bin/bash
#
# build simulation
#
xvhdl ../src/uart_new.vhd
xvhdl ../src/sim_uart.vhd
xelab -debug typical sim_uart -s uart_sim
xsim --gui uart_sim -t ../scripts/init.tcl
