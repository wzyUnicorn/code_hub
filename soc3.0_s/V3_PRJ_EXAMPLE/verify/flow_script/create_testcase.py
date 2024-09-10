import os
import re
import sys

def create_testcase(
    test_name          = '',
    compile_file       = '',
    compile_name       = '',
    sim_option         = '',
    pre_sim_cmd        = '',
    tag                = '',
    test_file_name = os.path.basename(sys.argv[0])
):
    #sim_option = " +vcs+lic+wait +no_notifier +dontStopOnSimulError=1 +UVM_NO_RELNOTES " + simv_option
    sim_option = sim_option + " "
    testcase_file = open(sys.argv[2] + "/" + test_file_name.replace(".py",'') + "_testcase.log", mode ='a')

    testcase_file.write('''TESTCASE:TEST_NAME=%s::COMPILE_FILE=%s::COMPILE_NAME=%s::SIM_OPTION=%s::PRE_SIM_CMD=%s::TAG=%s::\n'''%(test_name,compile_file,compile_name,sim_option,pre_sim_cmd,tag))
    testcase_file.close()
    #vcs_option = "-full64 -ntb_opts uvm-1.2 +v2k -sverilog -kdb -error=noMPD +libext+.v+.vlib+.sv+.svh+.vp+.sva+.svp -P ${NOVAS_HOME}/share/PLI/VCS/LINUX64/novas.tab ${NOVAS_HOME}/share/PLI/VCS/LINUX64/pli.a -Mupdate -lca -debug_access+f -CFLAGS -DVCS +define+UVM_PACKER_MAX_BYTES=1500000 +define+UVM_DISABLE_AUTO_ITEM_RECORDING " + vcs_option 