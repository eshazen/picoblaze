add_wave clk rst dat uart_dat uart_valid
add_wave uart_new_1/sampCtr uart_new_1/bit_ctr
add_wave uart_new_1/ser_busy uart_new_1/ser_sr
add_force clk {0 0} {1 5ns} -repeat_every 10ns
add_force rst 1
add_force dat 1
run 20ns
add_force rst 0
run 1us
