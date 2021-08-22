synth_design -top top -part xc7a35t-cpg236-1
opt_design
place_design
route_design
write_bitstream -force top.bit

