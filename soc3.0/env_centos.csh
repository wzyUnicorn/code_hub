setenv SOC_DIR ${PWD}/soc
setenv PRJ_ROOT ${PWD}/soc/sim
setenv VERDI_HOME "/home/synopsys/verdi/Verdi_O-2018.09-SP2"
alias yinfo  "$PRJ_ROOT/script/get_random_id/get_random_id"
alias yrun "$PRJ_ROOT/script/flow_script/v3flow_run/v3flow_run"
alias ycheck "python3 $PRJ_ROOT/script/flow_script/report.py"
alias ycommit "python3 $PRJ_ROOT/script/flow_script/v3_commit.py"
alias ygpt "python3 $PRJ_ROOT/script/flow_script/v3_gpt.py"
alias ydebug "yrun -testfile soc_test -testname "
