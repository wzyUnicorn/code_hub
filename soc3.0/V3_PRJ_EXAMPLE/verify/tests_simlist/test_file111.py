
import sys
import os
import re
PRJ_ROOT       = os.environ.get('PRJ_ROOT')
sys.path.append(PRJ_ROOT+'/verify/flow_script/')
from create_testcase import *

create_testcase(
    test_name          = 'test1',
    compile_file       = 'cmp_file1',
    compile_name       = 'basic',
    sim_option         = '+UVM_TESTNAME=my_case0 ',
    pre_sim_cmd        = 'echo \"pre sim cmd\" > 1.log',
    tag                = 'TEST1'
)

create_testcase(
    test_name          = 'test2',
    compile_file       = 'cmp_file1',
    compile_name       = 'error_inject',
    sim_option         = '+UVM_TESTNAME=my_case1',
    pre_sim_cmd        = '',
    tag                = 'TEST2'
)