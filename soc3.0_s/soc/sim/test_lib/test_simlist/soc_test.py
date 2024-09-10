
import sys
import os
import re
PRJ_ROOT       = os.environ.get('PRJ_ROOT')
sys.path.append(PRJ_ROOT+'/script/flow_script/')
from create_testcase import *

create_testcase(
    test_name          = 'spi1_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl +UVM_TESTNAME=soc_test ',
    pre_sim_cmd        = '',
    uvm_en             = '',
    tag                = 'TEST1'
)

create_testcase(
    test_name          = 'spi2_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl +UVM_TESTNAME=soc_test ',
    pre_sim_cmd        = '',
    uvm_en             = '',
    tag                = 'TEST1'
)

create_testcase(
    test_name          = 'uart_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '',
    tag                = 'TEST2'
)

create_testcase(
    test_name          = 'soc_dma_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '',
    tag                = 'TEST2'
)

create_testcase(
    test_name          = 'isp_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '',
    tag                = 'TEST3'
)

create_testcase(
    test_name          = 'cnn_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'jtag_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'pwm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'i2c_read_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'i2c_write_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'soc_dma_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'soc_dma_test1',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'soc_dma_test2',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'led',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'sram_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '0',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'soc_base_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'cnn_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'i2c_read_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'i2c_write_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'jtag_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'pwm_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)


create_testcase(
    test_name          = 'spi_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'isp_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)


create_testcase(
    test_name          = 'soc_dma_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'soc_dma_uvm_test1',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'soc_dma_uvm_test2',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'sram_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)

create_testcase(
    test_name          = 'uart_uvm_test',
    compile_file       = 'soc_compile',
    compile_name       = 'soc_uvm_test',
    sim_option         = '+verbose=1 -l vcs.log -cm line+cond+tgl',
    pre_sim_cmd        = '',
    uvm_en             = '1',
    tag                = 'TEST4'
)


