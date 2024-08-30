#############################
# User variables
#############################
TB       = tb3_ref
SEED     = 1
TESTNAME ?= chnl_basic_test 
DFILES   = ../mcdt/v1/{arbiter.v,slave_fifo.v,mcdt.v}
VFILES  += chnl_pkg3_ref.sv $(TB).sv


#############################
# Environment variables
#############################
VCOMP                = vlogan -full64 -sverilog -timescale=1ps/1ps -nc -l comp.log 
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

