date
set SOC_DIR $env(SOC_DIR)

## library
set target_library "$SOC_DIR/../dc/lib/sky130_fd_sc_hs__ss_150C_1v60.db"
set link_library " * $target_library"

set search_path "$SOC_DIR/../dc/lib"

# file list
## generate filelist
source $SOC_DIR/../flow/filelist/gen_filelist.tcl
## read file list: search path and rtl file list.
source -echo $SOC_DIR/../flow/filelist/rtl_list.tcl

set_svf ../outputs/soc_syn.svf

set verilogout_no_tri true

# design read
set TOP soc_top
analyze -autoread -define { SYNTHESIS XCELIUM DV_FCOV_DISABLE SYNTHESIS_MEMORY_BLACK_BOXING TECH_HH90 }  $rtl_list
elaborate $TOP

# sdc
source -echo ../scr/soc_sdc.tcl

compile_ultra -no_autoungroup -incremental

check_design > ../reports/check_design.rpt
report_timing -max_paths 20 > ../reports/timing.rpt
report_area -hierarchy > ../reports/area.rpt
report_power > ../reports/power.rpt

write_file -format verilog -hierarchy -output ../outputs/netlist.v
write_sdc ../outputs/syn.sdc

write_file -format ddc -hierarchy -output ../outputs/soc_top.ddc

# svf for fm
set_svf ../outputs/soc_syn.svf

date
#exit
