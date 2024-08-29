TOP_TB=cpld_tb
TEST=test_iic_power_on_reset

MSG=-messages -nocopyright
UVM_DEBUG=+UVM_PHASE_TRACE
COMPILE_ONLY=-c

sim:
	irun ${MSG} -64bit -sv -gui -uvm -update -define CONFIG_FOR_SIM -work worklib -l sim_logs/${TEST}_sim.log \
	-sem2009 -errormax 15 -access +rwc -input probe_wave.tcl -covtest ${TEST} \
	-timescale 1ns/1ns -coverage all -covoverwrite -status \
	+UVM_NO_RELNOTES +UVM_TESTNAME=${TEST} \
	-incdir ../../rtl/ -f rtl_list.f \
	-incdir ../agent/btn_agent -incdir ../agent/iic_agent -incdir ../agent/lpc_agent -incdir ../agent/tele_agent \
	-incdir ../env -incdir ../test -incdir ../test/seqlib \
	../top/cpld_if.sv \
	../agent/btn_agent/btn_agent_pkg.svh \
	../agent/iic_agent/iic_agent_pkg.svh \
	../agent/lpc_agent/lpc_agent_pkg.svh \
	../agent/tele_agent/tele_agent_pkg.svh \
	../env/env_pkg.svh ../test/test_pkg.svh \
	../top/cpld_tb.sv

clean:
	rm -rf INCA_libs cov_work sim_logs html_* *.key *.log *.diag *.err *.shm

merge_cov:
	imc -exec merge_cov.tcl
check_fatal:
	grep -r "UVM_FATAL :    " sim_logs/
