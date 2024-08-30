clean:
	rm -rf *.cache *.hw *.sim *.ip_user_files *.runs
	rm -f *.jou *.log *.txt *.xpr  
built:
	vivado -mode batch -source ../script/create_prj.tcl & 

open:
	vivado -source open_project ./*.xpr &
