rtlvssyn: # rtl vs syn netlist
	fm_shell -64 -x "set stage rtlvssyn" -file ./fm.tcl | tee fm.log

rtlvspnr: # rtl vs pnr netlist
	fm_shell -x "set stage rtlvspnr" -file ./fm.tcl | tee fm.log

synvspnr: # syn netlist vs pnr netlist
	fm_shell -x "set stage synvspnr" -file ./fm.tcl | tee fm.log

clean:
	rm -rf fm_shell_command* formality* FM_WOR*
