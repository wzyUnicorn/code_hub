fusesoc-deps := \
  /root/project/ibex/ibex/dv/riscv_compliance/ibex_riscv_compliance.core \
  /root/project/ibex/ibex/dv/riscv_compliance/rtl/ibex_riscv_compliance.sv \
  /root/project/ibex/ibex/dv/riscv_compliance/rtl/riscv_testutil.sv \
  /root/project/ibex/ibex/dv/riscv_compliance/ibex_riscv_compliance.cc \
  /root/project/ibex/ibex/dv/riscv_compliance/lint/verilator_waiver.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/simutil_verilator/simutil_verilator.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/simutil_verilator/cpp/verilator_sim_ctrl.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/simutil_verilator/cpp/verilated_toplevel.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/simutil_verilator/cpp/verilator_sim_ctrl.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/simutil_verilator/cpp/verilated_toplevel.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/simutil_verilator/cpp/sim_ctrl_extension.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/memutil_verilator.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/verilator_memutil.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/verilator_memutil.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/memutil_dpi.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/dpi_memutil.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/dpi_memutil.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/ecc32_mem_area.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/ecc32_mem_area.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/mem_area.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/mem_area.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/ranged_map.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/sv_scoped.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/sv_scoped.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_secded/secded_enc.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_secded/secded_enc.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_secded/secded_enc.c \
  /root/project/ibex/ibex/shared/sim_shared.core \
  /root/project/ibex/ibex/shared/rtl/ram_1p.sv \
  /root/project/ibex/ibex/shared/rtl/ram_2p.sv \
  /root/project/ibex/ibex/shared/rtl/bus.sv \
  /root/project/ibex/ibex/shared/rtl/sim/simulator_ctrl.sv \
  /root/project/ibex/ibex/shared/rtl/timer.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_ram_2p.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_ram_2p-impl_0/prim_ram_2p.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_ram_2p-impl_0/prim_ram_2p.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/prim_generic_ram_2p.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/lint/prim_generic_ram_2p.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_2p.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_util_memload.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_util_memload.svh \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/primgen.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_ram_2p_pkg.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_2p_pkg.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_pkg.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_prim_pkg-impl_0.1/prim_pkg.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_prim_pkg-impl_0.1/prim_pkg.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/lint/common.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/lint/tools/verilator/common.vlt \
  /root/project/ibex/ibex/check_tool_requirements.core \
  /root/project/ibex/ibex/util/check_tool_requirements.py \
  /root/project/ibex/ibex/tool_requirements.py \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_ram_1p.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_ram_1p-impl_0/prim_ram_1p.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_ram_1p-impl_0/prim_ram_1p.sv \
  /root/project/ibex/ibex/dv/uvm/icache/dv/prim_badbit/prim_badbit_ram_1p.core \
  /root/project/ibex/ibex/dv/uvm/icache/dv/prim_badbit/prim_badbit_ram_1p.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/prim_generic_ram_1p.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/lint/prim_generic_ram_1p.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_1p.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_ram_1p_pkg.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_assert.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/lint/prim_assert.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_assert.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_assert_dummy_macros.svh \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_assert_yosys_macros.svh \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_assert_standard_macros.svh \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_assert_sec_cm.svh \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_flop_macros.sv \
  /root/project/ibex/ibex/ibex_top_tracing.core \
  /root/project/ibex/ibex/rtl/ibex_top_tracing.sv \
  /root/project/ibex/ibex/ibex_tracer.core \
  /root/project/ibex/ibex/rtl/ibex_tracer_pkg.sv \
  /root/project/ibex/ibex/rtl/ibex_tracer.sv \
  /root/project/ibex/ibex/ibex_pkg.core \
  /root/project/ibex/ibex/rtl/ibex_pkg.sv \
  /root/project/ibex/ibex/ibex_top.core \
  /root/project/ibex/ibex/lint/verilator_waiver.vlt \
  /root/project/ibex/ibex/rtl/ibex_register_file_ff.sv \
  /root/project/ibex/ibex/rtl/ibex_register_file_fpga.sv \
  /root/project/ibex/ibex/rtl/ibex_register_file_latch.sv \
  /root/project/ibex/ibex/rtl/ibex_lockstep.sv \
  /root/project/ibex/ibex/rtl/ibex_top.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_onehot_check.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/lint/prim_onehot_check.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_onehot_check.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_util.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_util_pkg.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_ram_1p_scr.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/lint/prim_ram_1p_scr.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_scr.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/memutil_dpi_scrambled.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/scrambled_ecc32_mem_area.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/verilator/cpp/scrambled_ecc32_mem_area.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_ram_scr/cpp/scramble_model.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_ram_scr/cpp/scramble_model.cc \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_ram_scr/cpp/scramble_model.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_prince/crypto_dpi_prince/crypto_prince_ref.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/dv/prim_prince/crypto_dpi_prince/prince_ref.h \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_util_get_scramble_params.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_util_get_scramble_params.svh \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_cipher.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/lint/prim_cipher.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_subst_perm.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_present.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_prince.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_cipher_pkg.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_cipher_pkg.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_lfsr.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_lfsr.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_ram_1p_adv.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_adv.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_secded.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_22_16_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_22_16_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_28_22_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_28_22_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_39_32_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_39_32_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_64_57_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_64_57_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_72_64_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_72_64_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_22_16_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_22_16_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_39_32_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_39_32_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_72_64_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_72_64_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_76_68_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_76_68_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_22_16_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_22_16_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_28_22_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_28_22_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_39_32_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_39_32_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_64_57_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_64_57_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_72_64_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_72_64_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_22_16_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_22_16_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_39_32_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_39_32_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_72_64_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_72_64_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_76_68_dec.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_76_68_enc.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_flop.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_flop-impl_0/prim_flop.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_flop-impl_0/prim_flop.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/prim_xilinx_flop.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_flop.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/prim_generic_flop.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_flop.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_clock_mux2.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_clock_mux2-impl_0/prim_clock_mux2.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_clock_mux2-impl_0/prim_clock_mux2.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/prim_xilinx_clock_mux2.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/lint/prim_xilinx_clock_mux2.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_clock_mux2.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/prim_generic_clock_mux2.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/lint/prim_generic_clock_mux2.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_mux2.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_buf.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_buf-impl_0/prim_buf.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_buf-impl_0/prim_buf.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/prim_generic_buf.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_buf.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/prim_xilinx_buf.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_buf.sv \
  /root/project/ibex/ibex/ibex_core.core \
  /root/project/ibex/ibex/lint/verilator_waiver.vlt \
  /root/project/ibex/ibex/rtl/ibex_alu.sv \
  /root/project/ibex/ibex/rtl/ibex_branch_predict.sv \
  /root/project/ibex/ibex/rtl/ibex_compressed_decoder.sv \
  /root/project/ibex/ibex/rtl/ibex_controller.sv \
  /root/project/ibex/ibex/rtl/ibex_cs_registers.sv \
  /root/project/ibex/ibex/rtl/ibex_csr.sv \
  /root/project/ibex/ibex/rtl/ibex_counter.sv \
  /root/project/ibex/ibex/rtl/ibex_decoder.sv \
  /root/project/ibex/ibex/rtl/ibex_ex_block.sv \
  /root/project/ibex/ibex/rtl/ibex_fetch_fifo.sv \
  /root/project/ibex/ibex/rtl/ibex_id_stage.sv \
  /root/project/ibex/ibex/rtl/ibex_if_stage.sv \
  /root/project/ibex/ibex/rtl/ibex_load_store_unit.sv \
  /root/project/ibex/ibex/rtl/ibex_multdiv_fast.sv \
  /root/project/ibex/ibex/rtl/ibex_multdiv_slow.sv \
  /root/project/ibex/ibex/rtl/ibex_prefetch_buffer.sv \
  /root/project/ibex/ibex/rtl/ibex_pmp.sv \
  /root/project/ibex/ibex/rtl/ibex_wb_stage.sv \
  /root/project/ibex/ibex/rtl/ibex_dummy_instr.sv \
  /root/project/ibex/ibex/rtl/ibex_core.sv \
  /root/project/ibex/ibex/rtl/ibex_pmp_reset_default.svh \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/sv/dv_utils/dv_fcov_macros.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/dv/sv/dv_utils/dv_fcov_macros.svh \
  /root/project/ibex/ibex/ibex_icache.core \
  /root/project/ibex/ibex/rtl/ibex_icache.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/prim_clock_gating.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_clock_gating-impl_0/prim_clock_gating.core \
  /root/project/ibex/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/generated/lowrisc_prim_clock_gating-impl_0/prim_clock_gating.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/prim_generic_clock_gating.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/lint/prim_generic_clock_gating.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_gating.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/prim_xilinx_clock_gating.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/lint/prim_xilinx_clock_gating.vlt \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_clock_gating.sv \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/primgen.core \
  /root/project/ibex/ibex/vendor/lowrisc_ip/ip/prim/util/primgen.py