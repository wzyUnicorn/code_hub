#################################################
# vivado FPGA environment configuration
#################################################

set PRJ_NAME        Breath_led
set SCRIPT_DIR      ../script
set CONST_DIR       ../constraint
set DEVICE_NAME     xc7k325tffg676-2
set XDC_FILE        $CONST_DIR/pin.xdc
set CODE_FILE       ../../module/breath_led.v
################################################
#Step1: Create project and overwrite old files
################################################
create_project -force $PRJ_NAME ./ -part $DEVICE_NAME
read_xdc $XDC_FILE
add_file $CODE_FILE
add_files ../libs/sysclk_wiz/sysclk_wiz.xci
set_property ip_repo_paths ../libs/sysclk_wiz [current_project]
set_property verilog_define {FPGA_SYN=1} [get_filesets sources_1]
#set max threads
set_param general.maxThreads 8

# Launch Synthesis
launch_runs synth_1
wait_on_run synth_1
# Launch Implementation
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
write_cfgmem -format mcs -size 128 -interface BPIx16 -loadbit {up 0x0 "Breath_led.runs/impl_1/breath_led.bit" } -checksum -force -disablebitswap -file Breath_led.runs/impl_1/Breath_led.mcs
