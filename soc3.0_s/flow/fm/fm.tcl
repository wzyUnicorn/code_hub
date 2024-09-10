date
set SOC_DIR $env(SOC_DIR)

set verification_clock_gate_hold_mode low
set verification_failing_point_limit 0
set hdlin_error_on_mismatch_message false
set hdlin_unresolved_modules "black_box"

set design soc_top

read_db ${SOC_DIR}/../dc/lib/sky130_fd_sc_hs__ss_150C_1v60.db

set rtl_list ""
source -echo $SOC_DIR/../flow/filelist/rtl_list.tcl

set_svf $SOC_DIR/../flow/dc/outputs/soc_syn.svf

if { ${stage} == "rtlvssyn" || ${stage} == "rtlvspnr" } {
	read_sverilog -container r -define { SYNTHESIS XCELIUM DV_FCOV_DISABLE SYNTHESIS_MEMORY_BLACK_BOXING TECH_HH90  } -libname WORK $rtl_list
} elseif {${stage} == "synvspnr" } {
    read_sverilog -container r -libname WORK ../dc/outputs/netlist.v
}
set_top r:/WORK/$design

if { ${stage} == "rtlvspnr" || ${stage} == "synvspnr" } {
    ##TODO
	read_sverilog -container i -libname WORK ../dc/outputs/netlist.v 
} elseif {${stage} == "rtlvssyn" } {
    read_sverilog -container i -libname WORK ../dc/outputs/netlist.v
}
set_top i:/WORK/$design

match
verify

date
#write_fm_report $design syn2dft
#exit
