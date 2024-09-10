set verification_clock_gate_hold_mode low
set verification_failing_point_limit 0
#set_mismatch_message_filter -warn FM-089
#set_mismatch_message_filter -suppress FM-089
#set hdlin_warn_on_mismatch_message "FM-089"
set hdlin_error_on_mismatch_message false

set SOC_DIR $env(SOC_DIR)

set design soc_top

read_db ${SOC_DIR}/../dc/lib/sky130_fd_sc_hs__ss_150C_1v60.db
 set rtl_list " \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/dv/uvm/core_ibex/common/prim/prim_pkg.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_1p.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/dv/uvm/core_ibex/common/prim/prim_ram_1p.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_gating.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/dv/uvm/core_ibex/common/prim/prim_clock_gating.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_buf.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/dv/uvm/core_ibex/common/prim/prim_buf.sv   \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_util_pkg.sv  \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_cdc_rand_delay.sv  \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_pkg.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_alu.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_compressed_decoder.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_controller.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_counter.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_cs_registers.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_decoder.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_ex_block.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_id_stage.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_if_stage.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_load_store_unit.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_multdiv_slow.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_multdiv_fast.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_prefetch_buffer.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_fetch_fifo.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_register_file_ff.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_wb_stage.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_csr.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_icache.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_core.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/rtl/ibex_top.sv     \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma_ahb_config.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma_ahb_mux.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma_arbiter.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma_int_control.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma_rx_sm.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma_tx_sm.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dma/dma_channel.v  \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/isp/isp_demosaic_lite.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/isp/isp_dgain.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/isp/isp_top.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/isp/isp_utils.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/isp/isp_dma.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/isp/rdma2isp.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/isp/isp2wdma.v     \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/include/ahb2apb_defines.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/include/SoC_amba-defines.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/pad/pin_mux_rf.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/pad/gnrl_io_pad.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/pad/pin_mux.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/i2c/i2c_master_defines.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/i2c/i2c_master_byte_ctrl.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/i2c/timescale.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/i2c/i2c_master_top.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/i2c/i2c_master_bit_ctrl.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/ahb2apb/ahb2apb.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/apb_subsystem.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/qspi/spi_master_fifo.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/qspi/spi_master_tx.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/qspi/spi_master_clkgen.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/qspi/spi_master_apb_if.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/qspi/spi_master_controller.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/qspi/spi_master_rx.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/qspi/apb_spi_master.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/uart_defines.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/raminfr_hubing.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/uart_apb.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/uart_rfifo_hubing.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/uart_transmitter.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/uart_sync_flops.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/uart_tfifo_hubing.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/uart/uart_receiver.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/pwm/pwm_apb.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/apb_subsystem/rtl/pwm/pwm.sv  \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/busmatrix/arbiter.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/busmatrix/master_if.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/busmatrix/multiplexer.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/busmatrix/req_register.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/busmatrix/slave_if.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/busmatrix/busmatrix.v  \
/home/cxjl03/project/SOC_V2/To_Customer/soc/model/sram.sv   \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dm_pkg.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dm_csrs.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dmi_cdc.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dmi_intf.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dmi_jtag.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dm_mem.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dm_sba.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dm_top.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/debug_rom/debug_rom.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dmi_jtag_tap.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ip/dm/dm_wrapper.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync_cnt.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_async.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_flop_2sync.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/dv/uvm/core_ibex/common/prim/prim_flop.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_flop.sv \
/home/cxjl03/project/SOC_V2/To_Customer/soc/top/core2ahb.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/top/cmsdk_ahb_to_sram.v \
/home/cxjl03/project/SOC_V2/To_Customer/soc/top/top.sv  "

# design read

#set_svf ../data/digital_top-compile.svf
#set_svf -append ../data/digital_top-dft.svf

#source -echo -verbose ../syn_verilog_source.tcl
#read_sverilog -container r -libname WORK $rtl_list

#if { ${stage} == "rtlvssyn" || ${stage} == "rtlvspnr" } {
#	read_sverilog -container r -libname WORK $rtl_list
#} elseif {${stage} == "synvspnr" } {
#    read_sverilog -container r -libname WORK ../dc/outputs/netlist.v
#}
read_sverilog -container r -define { SYNTHESIS XCELIUM DV_FCOV_DISABLE } -libname WORK $rtl_list
set_top r:/WORK/$design

#if { ${stage} == "rtlvspnr" || ${stage} == "synvspnr" } {
#	read_sverilog -container i -libname WORK ../dc/outputs/netlist.v
#} elseif {${stage} == "rtlvssyn" } {
#    read_sverilog -container i -libname WORK ../dc/outputs/netlist.v
#}
read_sverilog -container i -libname WORK ../dc/outputs/netlist.v
set_top i:/WORK/$design

match
verify

#write_fm_report $design syn2dft
#exit
