set_property SLEW SLOW [get_ports led]

set_property IOSTANDARD LVCMOS33 [get_ports led]
set_property PACKAGE_PIN N23 [get_ports led]

set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN AF25 [get_ports rst_n]

set_property PACKAGE_PIN AB11 [get_ports clk_in_p]
set_property IOSTANDARD LVDS [get_ports clk_in_p]

set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]

