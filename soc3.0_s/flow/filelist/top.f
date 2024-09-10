//+incdir+/root/tools/synopsys/vcs_2016.06/amd64/etc/uvm-1.2/src
//+incdir+$SOC_DIR/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/src/lowrisc_prim_assert_0.1/rtl/ 
//+incdir+$SOC_DIR/sim/output/ip/pad
//+incdir+$SOC_DIR/ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/src/lowrisc_prim_ram_1p_pkg_0/rtl
+incdir+$SOC_DIR/sim/output/ip/apb_subsystem/rtl/i2c
+incdir+$SOC_DIR/sim/output/ip/apb_subsystem/rtl/ahb2apb
+incdir+$SOC_DIR/sim/output/ip/include
+incdir+$SOC_DIR/sim/output/ip/apb_subsystem/rtl/uart
+incdir+$SOC_DIR/sim/output/ip/busmatrix

-f $SOC_DIR/../flow/filelist/ibex_core_other.f
-f $SOC_DIR/../flow/filelist/ibex_core.f
-f $SOC_DIR/../flow/filelist/dma.f
-f $SOC_DIR/../flow/filelist/isp.f
-f $SOC_DIR/../flow/filelist/apb_filelist.f
-f $SOC_DIR/../flow/filelist/busmatrix_filelist.f
-f $SOC_DIR/../flow/filelist/model.f
-f $SOC_DIR/../flow/filelist/dm.f
-f $SOC_DIR/../flow/filelist/cnn_sram.f
$SOC_DIR/top/core2ahb.v
$SOC_DIR/top/cmsdk_ahb_to_sram.v
$SOC_DIR/top/top.sv
