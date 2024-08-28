`timescale 1ns/1ns
module cpld_tb;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import btn_agent_pkg::*;
    import iic_agent_pkg::*;
    import lpc_agent_pkg::*;
    import env_pkg::*;
    import test_pkg::*;

logic clk;
cpld_if mif(clk);	

CPLD_6B u_CPLD_6B(
.w_InitialSoc(mif.clk),
.i_DCOKSby(mif.i_DCOKSby), 
.i_RST_BUTTON_n(mif.i_RST_BUTTON_n), 
.i_PowerButton_n(mif.i_PowerButton_n),
.i_ATX_PG(mif.i_ATX_PG),
.o_VDD18_EN(mif.o_VDD18_EN),
.o_S0_1V2Enable(mif.o_S0_1V2Enable),
.o_S1_1V2Enable(mif.o_S1_1V2Enable),
.i_WorkPowerGood1(mif.i_WorkPowerGood1),
.i_WorkPowerGood2(mif.i_WorkPowerGood2),
.i_S0_VTT_PWRGD(mif.i_S0_VTT_PWRGD),
.i_S1_VTT_PWRGD(mif.i_S1_VTT_PWRGD),
.o_S0_CORE08_EN(mif.o_S0_CORE08_EN),
.o_S1_CORE08_EN(mif.o_S1_CORE08_EN),
.i_S0_CORE08_PG(mif.i_S0_CORE08_PG),
.i_S1_CORE08_PG(mif.i_S1_CORE08_PG),
.o_S0_DLI_VDD18_EN(mif.o_S0_DLI_VDD18_EN),
.o_S1_DLI_VDD18_EN(mif.o_S1_DLI_VDD18_EN),
.i_S0_DLI_VDD18_PG(mif.i_S0_DLI_VDD18_PG),
.i_S1_DLI_VDD18_PG(mif.i_S1_DLI_VDD18_PG),
.o_PSOn(mif.o_PSOn),
//.i_8619_PG(mif.i_8619_PG),
.o_YellowLED(mif.o_YellowLED),

.o_PCIEReset0_n(mif.o_PCIEReset0_n),
.o_PCIEReset1_n(mif.o_PCIEReset1_n),
.o_9230_PRST_n(mif.o_9230_PRST_n),
.o_HUB_RST_n(mif.o_HUB_RST_n),
.o_S0_CPU_DCOK(mif.o_S0_CPU_DCOK),
.o_S0_CPUReset_n(mif.o_S0_CPUReset_n),	
.o_S1_CPU_DCOK(mif.o_S1_CPU_DCOK),
.o_S1_CPUReset_n(mif.o_S1_CPUReset_n),

//.i_Buzzer(mif.i_Buzzer),
.o_Buzzer(mif.o_Buzzer),

.i_AST_PWROn_n(mif.i_AST_PWROn_n),
.i_AST_PWROff_n(mif.i_AST_PWROff_n),
.i_AST_Reset_n(mif.i_AST_Reset_n),
.i_AST_act_n(mif.i_AST_act_n),
.o_CPLD_INT(mif.o_CPLD_INT),
.o_ipmi_perst_n(mif.o_ipmi_perst_n),

.i_scl(mif.scl),
.io_sda(mif.io_sda),  
  
.i_LPCClk(mif.LPCclk),
.i_LPCRst_n(mif.i_LPCRst_n),
.i_Frame(mif.i_Frame),
.io_LAD(mif.io_LAD), 

.i_S0_VS_ALARM_L(mif.i_S0_VS_ALARM_L),
.i_S0_TS_ALARM_L(mif.i_S0_TS_ALARM_L),
.i_S1_VS_ALARM_L(mif.i_S1_VS_ALARM_L),
.i_S1_TS_ALARM_L(mif.i_S1_TS_ALARM_L)
);

assign mif.iic_reg          =u_CPLD_6B.u_iic_reg.reg_a0;
assign mif.iic_beep_reg     =u_CPLD_6B.u_iic_reg.reg_a2;
assign mif.lpc_reg          =u_CPLD_6B.u_lpc_reg.reg_a0;
assign mif.lpc_beep_reg     =u_CPLD_6B.u_lpc_reg.reg_a2;
assign mif.w_btn_PSON       =u_CPLD_6B.w_btn_PSON;
assign mif.w_btn_pwr_off_en =u_CPLD_6B.w_btn_pwr_off_en;
assign mif.w_rst_btn_press  =u_CPLD_6B.w_rst_btn_press;
assign mif.w_BeepEnable     =u_CPLD_6B.w_BeepEnable;
assign mif.w_AST_PSON       =u_CPLD_6B.w_AST_PSON;
assign mif.w_AST_PWROff     =u_CPLD_6B.w_AST_PWROff;
assign mif.w_AST_Reset      =u_CPLD_6B.w_AST_Reset;
//assign mif.sda_oe           =!u_CPLD_6B.i2c_sda_oe_o;

initial begin
  clk = 1;
  forever #15625 clk =~clk; 	// T=31.25us
end  
initial begin
    void'(uvm_config_db#(virtual cpld_if)::set(null,"uvm_test_top.env.*.*","vif",mif));
    run_test();
end
endmodule
