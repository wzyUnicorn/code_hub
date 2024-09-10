+incdir+$PRJ_ROOT/../ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/src/lowrisc_prim_assert_0.1/rtl/ 
+incdir+$PRJ_ROOT/../ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/src/lowrisc_prim_ram_1p_pkg_0/rtl
+incdir+$PRJ_ROOT/../ibex/build/lowrisc_ibex_ibex_riscv_compliance_0.1/src/lowrisc_dv_dv_fcov_macros_0/
+incdir+$PRJ_ROOT/../ibex/rtl/
+incdir+$PRJ_ROOT/../ip/apb_subsystem/rtl/i2c
+incdir+$PRJ_ROOT/../ip/apb_subsystem/rtl/ahb2apb
+incdir+$PRJ_ROOT/../ip/include
+incdir+$PRJ_ROOT/../ip/apb_subsystem/rtl/uart
+incdir+$PRJ_ROOT/../ip/busmatrix
+incdir+$PRJ_ROOT/../ip/pad


//-f ./filelist/ibex_core_other.f
$PRJ_ROOT/../ibex/dv/uvm/core_ibex/common/prim/prim_buf.sv
$PRJ_ROOT/../ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_buf.sv
$PRJ_ROOT/../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv
-f $PRJ_ROOT/../filelist/ibex_core.f
$PRJ_ROOT/../ibex/syn/rtl/prim_clock_gating.v

-f $PRJ_ROOT/../filelist/dma.f
-f $PRJ_ROOT/../filelist/isp.f
-f $PRJ_ROOT/../filelist/apb_filelist.f
-f $PRJ_ROOT/../filelist/busmatrix_filelist.f
-f $PRJ_ROOT/../filelist/model.f
$PRJ_ROOT/../top/monitior.v
$PRJ_ROOT/../top/core2ahb.v
$PRJ_ROOT/../top/cmsdk_ahb_to_sram.v
$PRJ_ROOT/../top/top.v
