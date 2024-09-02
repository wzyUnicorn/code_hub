TOP_TB=top_tb
TEST=my_case0
MSG=-messages -nocopyright
UVM_DEBUG=+UVM_PHASE_TRACE
COMPILE_ONLY=-c

sim:
	irun ${MSG} -64bit -sv -uvm -update -define CONFIG_FOR_SIM -work worklib -l sim_logs/${TEST}_sim.log \
	-sem2009 -errormax 15 -access +rwc -input probe_wave.tcl -covtest ${TEST} \
	-timescale 1ns/1ns -coverage all -covoverwrite -status \
	+UVM_NO_RELNOTES +UVM_TESTNAME=${TEST} \
	-incdir ../../../dut \
	-incdir ../env \
	-incdir ../top \
	../../../dut/dut.sv \
	../top/top_tb.sv 

clean:
	rm -rf INCA_libs cov_work sim_logs html_* *.key *.log *.diag *.err *.shm

merge_cov:
	imc -exec merge_cov.tcl
check_fatal:
	grep -r "UVM_FATAL :    " sim_logs/
