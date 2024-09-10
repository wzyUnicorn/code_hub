set CYCLE100M [expr 10*1]
set CYCLE50M  [expr 20*1]

#GUIDANCE: use the default
#set_max_transition  0.25 [current_design]
#set_max_fanout      32   [current_design]
#set_max_capacitance 0.5  [current_design]

#--------------------------------Clock Definition------------------------------
create_clock -name cpu_clk -period $CYCLE100M [get_ports pad[21]]
create_clock -name pclk -period $CYCLE50M [get_ports pad[23]]

set_clock_uncertainty -hold 0.053 [all_clocks]
set_clock_transition 0.15 [all_clocks]
set_input_transition 0.2 [remove_from_collection [all_inputs] [all_clocks]]

#--------------------------------I/O Constraint-----------------------------
#rst_ports
set rst_inputs [get_ports [list \
    pad[22] \
    pad[24] \
]]
set_ideal_network $rst_inputs

#ports in pclk domain
set pclk_ports [get_ports [list \
    pad[1] pad[2] pad[3] pad[4] pad[5] \
    pad[6] pad[7] pad[8] pad[9] pad[10] \
    pad[11] pad[12] pad[13] pad[14] pad[15] \
    pad[16] pad[17] pad[18] pad[19] pad[20] \
]]

set pclk_inputs [get_ports $pclk_ports -filter "port_direction == in"]
set pclk_outputs [get_ports $pclk_ports -filter "port_direction == out"]

set_input_delay -max [expr $CYCLE100M * 0.6] -clock [get_clocks pclk] $pclk_inputs -add_delay
set_output_delay -max [expr $CYCLE100M * 0.3] -clock [get_clocks pclk] $pclk_outputs -add_delay

#-------------------------System Interface Characteristics--------------------
#set_driving_cell -lib_cell AN2D0BWP7T30P140 [all_inputs]
#If real clock, set infinite drive strength to avoid automatic buffer insertion.
set_drive 0 [get_ports [list cpu_clk pclk]]
set_load -pin_load 0.02 [all_outputs]
#set_fanout_load 4 [all_outputs]

#---------------------------------Timing Exceptions-----------------------------
#set false_ports [get_ports [list \
#    false_port0 \
#    false_port1 \
#]]
#set false_inputs [get_ports $false_ports -filter "port_direction == in"]
#set false_outputs [get_ports $false_ports -filter "port_direction == out"]
#
#set_false_path -from [get_ports $false_inputs]
#set_false_path -to [get_ports $false_outputs]
