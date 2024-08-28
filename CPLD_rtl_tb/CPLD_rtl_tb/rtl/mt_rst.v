///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <mt_rst.v>
// File history:
//
// Description: 
//control MT_RST of ICH
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module MT_RST(
input        i_clk_32k,
input        i_rst_n,//all area rst
input [3:0]  i_ctrl_state,
input        i_UI_rst_n,//Uper interface rst
input        i_reg_mt_rst,
output       o_MT_Reset_n
);

//////////parameters/////////
    parameter Start           = 4'b0000;
    parameter Sby             = 4'b0001;
    parameter SbyEnd          = 4'b0010;
    parameter PSOn            = 4'b0011;
    parameter WorkPowerGood   = 4'b0100;
    parameter AllPowerGood    = 4'b0101;
    parameter T5_Reset        = 4'b0110;
    parameter T5_ResetEnd     = 4'b0111;
    parameter PCIEResetEnd    = 4'b1000;
    parameter ICH_DCOk        = 4'b1001;
    parameter ICHPowerGood    = 4'b1010;
    parameter CPU_DCOk        = 4'b1011;
    parameter End             = 4'b1100;

//////////regs//////////////
reg          cs_ICH_MT_Reset_n;
reg          ns_ICH_MT_Reset_n;
reg          r1_reg_mt_rst;
reg          r2_reg_mt_rst;
///////////////////////////////////////////////
    always @(posedge i_clk_32k or negedge i_rst_n)
        if (!i_rst_n)
        begin
            cs_ICH_MT_Reset_n <= 1'b0;
            r1_reg_mt_rst     <= 1'b0;
            r2_reg_mt_rst     <= 1'b0;
        end
        else
        begin
            cs_ICH_MT_Reset_n <= ns_ICH_MT_Reset_n; 
            r1_reg_mt_rst     <= i_reg_mt_rst;
            r2_reg_mt_rst     <= r1_reg_mt_rst;
        end
always @ *
begin
    ns_ICH_MT_Reset_n = cs_ICH_MT_Reset_n; 
    if (i_ctrl_state==Sby) ns_ICH_MT_Reset_n = 1'b0;
    else if (i_ctrl_state < ICH_DCOk) ns_ICH_MT_Reset_n = 1'b0;
    else if ( (i_ctrl_state>=ICH_DCOk) )  ns_ICH_MT_Reset_n = 1'b1;
    else if (i_ctrl_state==End && i_UI_rst_n) ns_ICH_MT_Reset_n = !r2_reg_mt_rst;
    else  ns_ICH_MT_Reset_n = cs_ICH_MT_Reset_n;
end
assign o_MT_Reset_n = cs_ICH_MT_Reset_n;
endmodule
