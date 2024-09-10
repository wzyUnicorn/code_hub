import os
import re
import sys
PRJ_ROOT       = os.environ.get('PRJ_ROOT')
sys.path.append(PRJ_ROOT+'/verify/flow_script/')
from create_compile import *

create_compile(
    compile_name       = 'basic',
    compile_option     = '+define+V3FLOW -top top_tb -timescale=1ns/1ps',
    vlogan_option      = '',
    pre_compile_cmd    = 'echo \"pre compile cmd\" > 2.log',
    rtl_file           = '$PRJ_ROOT/design/dut.f',
    verify_file        = '$PRJ_ROOT/verify/example/filelist.f'
)

create_compile(
    compile_name       = 'basic_fpga',
    compile_option     = '+define+V3FLOW -top top_tb -timescale=1ns/1ps',
    vlogan_option      = '',
    pre_compile_cmd    = 'echo \"pre compile cmd\" > 2.log',
    rtl_file           = '$PRJ_ROOT/design/dut.f',
    verify_file        = '$PRJ_ROOT/verify/example/filelist.f'
)

create_compile(
    compile_name       = 'error_inject',
    compile_option     = '+define+ERROR_INJECT  -top top_tb -timescale=1ns/1ps',
    vlogan_option      = '',
    pre_compile_cmd    = 'echo \"pre compile cmd\" > 2.log',
    rtl_file           = '$PRJ_ROOT/design/dut.f',
    verify_file        = '$PRJ_ROOT/verify/example/filelist.f'
)