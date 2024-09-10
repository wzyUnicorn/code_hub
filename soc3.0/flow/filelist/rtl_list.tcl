set search_path [ concat $search_path \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/i2c \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/ahb2apb \
    $SOC_DIR/sim/output/ip/include \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart \
    $SOC_DIR/sim/output/ip/busmatrix \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl \
    $SOC_DIR/ibex/vendor/lowrisc_ip/dv/sv/dv_utils \
    $SOC_DIR/ibex/rtl/ \
    $SOC_DIR/sim/output/ip/dma \
    $SOC_DIR/sim/output/ip/isp \
    $SOC_DIR/sim/output/ip/apb_subsystem/i2c \
    $SOC_DIR/sim/output/ip/apb_subsystem/qspi \
    $SOC_DIR/sim/output/ip/apb_subsystem/uart \
    $SOC_DIR/sim/output/ip/dm \

]
 
set rtl_list [ concat \
      \
      \
    $SOC_DIR/ibex/dv/uvm/core_ibex/common/prim/prim_pkg.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_1p.sv \
    $SOC_DIR/ibex/dv/uvm/core_ibex/common/prim/prim_ram_1p.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_gating.sv \
    $SOC_DIR/ibex/dv/uvm/core_ibex/common/prim/prim_clock_gating.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_buf.sv \
    $SOC_DIR/ibex/dv/uvm/core_ibex/common/prim/prim_buf.sv \
     \
     \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_util_pkg.sv \
     \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_cdc_rand_delay.sv \
     \
     \
    $SOC_DIR/ibex/rtl/ibex_pkg.sv \
    $SOC_DIR/ibex/rtl/ibex_alu.sv \
    $SOC_DIR/ibex/rtl/ibex_compressed_decoder.sv \
    $SOC_DIR/ibex/rtl/ibex_controller.sv \
    $SOC_DIR/ibex/rtl/ibex_csr.sv \
    $SOC_DIR/ibex/rtl/ibex_cs_registers.sv \
    $SOC_DIR/ibex/rtl/ibex_counter.sv \
    $SOC_DIR/ibex/rtl/ibex_decoder.sv \
    $SOC_DIR/ibex/rtl/ibex_ex_block.sv \
    $SOC_DIR/ibex/rtl/ibex_wb_stage.sv \
    $SOC_DIR/ibex/rtl/ibex_id_stage.sv \
    $SOC_DIR/ibex/rtl/ibex_icache.sv \
    $SOC_DIR/ibex/rtl/ibex_if_stage.sv \
    $SOC_DIR/ibex/rtl/ibex_load_store_unit.sv \
    $SOC_DIR/ibex/rtl/ibex_multdiv_slow.sv \
    $SOC_DIR/ibex/rtl/ibex_multdiv_fast.sv \
    $SOC_DIR/ibex/rtl/ibex_prefetch_buffer.sv \
    $SOC_DIR/ibex/rtl/ibex_fetch_fifo.sv \
    $SOC_DIR/ibex/rtl/ibex_register_file_ff.sv \
    $SOC_DIR/ibex/rtl/ibex_core.sv \
    $SOC_DIR/ibex/rtl/ibex_top.sv \
     \
    $SOC_DIR/sim/output/ip/dma/dma_ahb_config.v \
    $SOC_DIR/sim/output/ip/dma/dma_ahb_mux.v \
    $SOC_DIR/sim/output/ip/dma/dma_arbiter.v \
    $SOC_DIR/sim/output/ip/dma/dma_int_control.v \
    $SOC_DIR/sim/output/ip/dma/dma_rx_sm.v \
    $SOC_DIR/sim/output/ip/dma/dma_tx_sm.v \
    $SOC_DIR/sim/output/ip/dma/dma.v \
    $SOC_DIR/sim/output/ip/dma/dma_channel.v \
     \
    $SOC_DIR/sim/output/ip/isp/isp_demosaic_lite.v \
    $SOC_DIR/sim/output/ip/isp/isp_dgain.v \
    $SOC_DIR/sim/output/ip/isp/isp_top.v \
    $SOC_DIR/sim/output/ip/isp/isp_utils.v \
    $SOC_DIR/sim/output/ip/isp/isp_dma.v \
    $SOC_DIR/sim/output/ip/isp/rdma2isp.v \
    $SOC_DIR/sim/output/ip/isp/isp2wdma.v \
     \
     \
     \
     \
    $SOC_DIR/sim/output/ip/include/ahb2apb_defines.v \
    $SOC_DIR/sim/output/ip/include/SoC_amba-defines.v \
    $SOC_DIR/sim/output/ip/pad/pin_mux_rf.v \
    $SOC_DIR/sim/output/ip/pad/gnrl_io_pad.v \
    $SOC_DIR/sim/output/ip/pad/pin_mux.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/i2c/i2c_master_defines.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/i2c/i2c_master_byte_ctrl.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/i2c/timescale.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/i2c/i2c_master_top.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/i2c/i2c_master_bit_ctrl.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/ahb2apb/ahb2apb.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/apb_subsystem.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/qspi/spi_master_fifo.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/qspi/spi_master_tx.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/qspi/spi_master_clkgen.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/qspi/spi_master_apb_if.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/qspi/spi_master_controller.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/qspi/spi_master_rx.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/qspi/apb_spi_master.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/uart_defines.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/raminfr_hubing.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/uart_apb.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/uart_rfifo_hubing.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/uart_transmitter.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/uart_sync_flops.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/uart_tfifo_hubing.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart/uart_receiver.v \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/pwm/pwm_apb.sv \
    $SOC_DIR/sim/output/ip/apb_subsystem/rtl/pwm/pwm.sv \
     \
    $SOC_DIR/sim/output/ip/busmatrix/arbiter.v \
    $SOC_DIR/sim/output/ip/busmatrix/master_if.v \
    $SOC_DIR/sim/output/ip/busmatrix/multiplexer.v \
    $SOC_DIR/sim/output/ip/busmatrix/req_register.v \
    $SOC_DIR/sim/output/ip/busmatrix/slave_if.v \
    $SOC_DIR/sim/output/ip/busmatrix/busmatrix.v \
     \
     \
     \
    $SOC_DIR/sim/output/ip/dm/dm_pkg.sv \
    $SOC_DIR/sim/output/ip/dm/dm_csrs.sv \
    $SOC_DIR/sim/output/ip/dm/dmi_cdc.sv \
    $SOC_DIR/sim/output/ip/dm/dmi_intf.sv \
    $SOC_DIR/sim/output/ip/dm/dmi_jtag.sv \
    $SOC_DIR/sim/output/ip/dm/dm_mem.sv \
    $SOC_DIR/sim/output/ip/dm/dm_sba.sv \
    $SOC_DIR/sim/output/ip/dm/dm_top.sv \
    $SOC_DIR/sim/output/ip/dm/debug_rom/debug_rom.sv \
    $SOC_DIR/sim/output/ip/dm/dmi_jtag_tap.sv \
    $SOC_DIR/sim/output/ip/dm/dm_wrapper.sv \
     \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync_cnt.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_async.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_flop_2sync.sv \
    $SOC_DIR/ibex/dv/uvm/core_ibex/common/prim/prim_flop.sv \
    $SOC_DIR/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_flop.sv \
     \
    $SOC_DIR/sim/output/ip/cnn_v1/line_mul.sv \
    $SOC_DIR/sim/output/ip/cnn_v1/final_res.sv \
    $SOC_DIR/sim/output/ip/cnn_v1/max_pool.sv \
    $SOC_DIR/sim/output/ip/cnn_v1/conv.sv \
    $SOC_DIR/sim/output/ip/cnn_v1/csr.sv \
    $SOC_DIR/sim/output/ip/cnn_v1/cnn.sv \
    $SOC_DIR/sim/output/ip/cnn_v1/cnn_top.sv \
     \
    $SOC_DIR/top/core2ahb.v \
     $SOC_DIR/top/cmsdk_ahb_to_sram.v \
     $SOC_DIR/top/top.sv \
      \
 
]
