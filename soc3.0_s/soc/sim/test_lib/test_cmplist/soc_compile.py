import os
import re
import sys
PRJ_ROOT       = os.environ.get('PRJ_ROOT')
sys.path.append(PRJ_ROOT+'/script/flow_script/')
from create_compile import *

create_compile(
    compile_name       = 'soc_test',
    compile_option     = ' -sverilog -timescale=1ns/1ns 	+acc +vpi -debug_access+nomemcbk+dmptf -debug_region+cell \
    -debug_access+all -kdb -lca -cm line+cond+tgl -LDFLAGS -Wl,--no-as-needed -ntb_opts uvm-1.2 -CFLAGS -DVCS -debug_pp ',
    vlogan_option      = ' ',
    pre_compile_cmd    = 'echo \"pre compile cmd\" > 2.log',
    rtl_file           = '$PRJ_ROOT/output/filelist/top.f',
    verify_file        = ''
)



create_compile(
    compile_name       = 'soc_uvm_test',
    compile_option     = ' -sverilog -timescale=1ns/1ns 	+acc +vpi -debug_access+nomemcbk+dmptf -debug_region+cell \
    -debug_access+all -kdb -lca -cm line+cond+tgl -LDFLAGS -Wl,--no-as-needed -ntb_opts uvm-1.2 -CFLAGS -DVCS -debug_pp +define+SOC_TB_MODE ',
    vlogan_option      = '',
    pre_compile_cmd    = 'echo \"pre compile cmd\" > 2.log',
    rtl_file           = '$PRJ_ROOT/output/filelist/top.f',
    verify_file        = ''
)
