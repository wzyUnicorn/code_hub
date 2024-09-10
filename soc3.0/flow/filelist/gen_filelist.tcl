set SOC_DIR $env(SOC_DIR)
set search_path_pre ""
set rtl_list_pre " "

set fin [open "$SOC_DIR/../flow/filelist/top.f" r]
set fout [open "$SOC_DIR/../flow/filelist/rtl_list.tcl" w]

while {![eof $fin]} {
	gets $fin line
	set comp_str [string range $line 0 1]
	if { $comp_str == {//} } {
	} elseif { $comp_str == {+i} } {
        set next_dir [string range $line 8 end]
        append search_path_pre "    $next_dir \\\n"
	} elseif {$comp_str == {-f} } {
		set next_f [string range $line 29 end]
		set ff [open "[concat $SOC_DIR/../flow/filelist/$next_f]" r]
		while {![eof $ff]} {
			gets $ff linen
			set comp_str2 [string range $linen 0 1]
			if { $comp_str2 == {//} } {
			} elseif { $comp_str2 == {+i} } {
				set next_dir [string range $linen 8 end]
                append search_path_pre "    $next_dir \\\n"
			} elseif {$comp_str2 == {-f} } {
				set next_f [string range $linen 3 end]	
			} else {
				append rtl_list_pre "    $linen \\\n"
			}
		}
	} else {
		append rtl_list_pre "    $line \\\n "
	}
}

puts $fout "set search_path \[ concat \$search_path \\"
puts $fout $search_path_pre
puts $fout "\]"
puts $fout " "
puts $fout "set rtl_list \[ concat \\"
puts $fout $rtl_list_pre
puts $fout "\]"
close $fout
