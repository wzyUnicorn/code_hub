set_app_var fml_mode_on true
set design pin_mux
read_file -top $design -format verilog -sva -vcs {-f ../../rtl/filelist}

create_clock cpu_clk -period 100
create_clock apb_clk -period 100

create_reset cpu_reset_n -high
create_reset apb_reset_n -high

sim_run -stable
sim_save_reset

check_fv -block 
report_fv -list > results.txt
