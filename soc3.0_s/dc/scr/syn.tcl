set SOC_DIR $env(SOC_DIR)

## library
set search_path "$SOC_DIR/../dc/lib "
set target_library "$SOC_DIR/../dc/lib/sky130_fd_sc_hs__ss_150C_1v60.db"
set link_library " * $target_library"

# file list
set rtl_list ""
set f [open "$SOC_DIR/../spyglass/filelist/top.f" r]
while {![eof $f]} {
	gets $f line
	set comp_str [string range $line 0 1]
	if { $comp_str == {//} } {
	} elseif { $comp_str == {+i} } {
		set next_dir [string range $line 8 end]
		set search_path [ concat $search_path $next_dir]
	} elseif {$comp_str == {-f} } {
		set next_f [string range $line 33 end]
		set ff [open "[concat $SOC_DIR/../spyglass/filelist/$next_f]" r]
		while {![eof $ff]} {
			gets $ff linen
			set comp_str2 [string range $linen 0 1]
			if { $comp_str2 == {//} } {
			} elseif { $comp_str2 == {+i} } {
				set next_dir [string range $linen 8 end]
				set search_path [ concat $search_path $next_dir]
			} elseif {$comp_str2 == {-f} } {
				set next_f [string range $linen 3 end]	
			} else {
				append rtl_list "$linen "
			}
		}
	} else {
		append rtl_list "$line "
	}
}
set new_rtl_list [string map {"\$SOC_DIR" {/home/cxjl03/project/SOC_V2/To_Customer/soc}} $rtl_list]
set old_serch_path $search_path
set search_path [string map {"\$SOC_DIR" {/home/cxjl03/project/SOC_V2/To_Customer/soc}} $old_serch_path]

#echo $rtl_list
echo $new_rtl_list

# design read
set TOP soc_top
#analyze -format sverilog -define SYNTHESIS $new_rtl_list
analyze -autoread -define { SYNTHESIS XCELIUM DV_FCOV_DISABLE } $new_rtl_list
elaborate $TOP

# sdc
source ../scr/soc_sdc.tcl

compile_ultra -no_autoungroup -incremental

check_design > ../reports/check_design.rpt
report_timing -max_paths 20 > ../reports/timing.rpt
report_area -hierarchy > ../reports/area.rpt
report_power > ../reports/power.rpt

write_file -format verilog -hierarchy -output ../outputs/netlist.v
write_sdc ../outputs/syn.sdc

#exit
