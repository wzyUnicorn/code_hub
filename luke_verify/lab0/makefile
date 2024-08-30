TOP_TB=top_tb
#TEST=my_case0
MSG=-messages -nocopyright
UVM_DEBUG=+UVM_PHASE_TRACE
COMPILE_ONLY=-c
DFILES   = ../mcdt/v1/{arbiter.v,slave_fifo.v,mcdt.v}

sim:
	irun ${MSG} -gui -64bit -sv -uvm -update -define CONFIG_FOR_SIM -work worklib -l sim_logs \
	-sem2009 -errormax 15 -access +rwc \
	-timescale 1ns/1ns -coverage all -covoverwrite -status \
	*.v \
	tb1.sv 

clean:
	rm -rf INCA_libs cov_work sim_logs html_* *.key *.log *.diag *.err *.shm

merge_cov:
	imc -exec merge_cov.tcl
check_fatal:
	grep -r "UVM_FATAL :    " sim_logs/
