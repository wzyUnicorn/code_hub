#############################
# User variables
#############################
TB       = tb
SEED     = 1
TESTNAME ?= mcdf_data_consistence_basic_test
DFILES   = ../mcdf/v0/{arbiter.v,slave_fifo.v,reg.v,formater.v,mcdf.v}
VFILES  += rpt_pkg.sv arb_pkg.sv chnl_pkg.sv fmt_pkg.sv reg_pkg.sv mcdf_pkg.sv $(TB).sv


#############################
# Environment variables
#############################
VCOMP                = vlogan -full64 -sverilog -timescale=1ps/1ps -nc -l comp.log +incdir+../mcdf/v0
ELAB                 = vcs -full64 -debug_all -l elab.log -sim_res=1ps 
RUN                  = $(TB).simv -l run.log -sml +ntb_random_seed=$(SEED) +TESTNAME=$(TESTNAME)

comp:
	$(VCOMP) $(DFILES) $(VFILES)

elab: 
	$(ELAB) -top $(TB) -o $(TB).simv

run:
	$(RUN) 

rung:
	$(RUN) -gui

clean:
	rm -rf AN.DB DVEfiles csrc *.simv *.simv.daidir *.simv.vdb ucli.key
	rm -rf *.log* *.vpd urgReport

