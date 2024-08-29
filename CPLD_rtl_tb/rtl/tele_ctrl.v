///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <tele_ctrl.v>
// File history:
//
// Description: 
// control the power far away
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module TELE_CTRL(
input       i_clk_32k,
input       i_rst_n,
input       i_AST_PWROn_n,
input       i_AST_PWROff_n,
input       i_AST_Reset_n,
input       i_AST_act_n,
//output      o_CPLD_INT,
output      o_AST_PSON,
output      o_AST_PWROff,
output      o_AST_Reset
);

////////////regs////////////////
reg         r1_AST_PWROn_n;
reg         r2_AST_PWROn_n;
reg         r1_AST_PWROff_n;
reg         r2_AST_PWROff_n;
reg         r1_AST_Reset_n;
reg         r2_AST_Reset_n;
reg         r1_AST_act_n;
reg         r2_AST_act_n;


    always @(posedge i_clk_32k or negedge i_rst_n)
    begin
        if (!i_rst_n)
        begin
            r1_AST_PWROn_n <=1'b1;
            r2_AST_PWROn_n <=1'b1;
            r1_AST_PWROff_n<=1'b1;
            r2_AST_PWROff_n<=1'b1;
            r1_AST_Reset_n <=1'b1;
            r2_AST_Reset_n <=1'b1;
            r1_AST_act_n   <=1'b0;
            r2_AST_act_n   <=1'b0;
        end
        else
        begin
            r1_AST_PWROn_n <=i_AST_PWROn_n;
            r2_AST_PWROn_n <=r1_AST_PWROn_n;
            r1_AST_PWROff_n<=i_AST_PWROff_n;
            r2_AST_PWROff_n<=r1_AST_PWROff_n;
            r1_AST_Reset_n <=i_AST_Reset_n ;
            r2_AST_Reset_n <=r1_AST_Reset_n;
            r1_AST_act_n   <=i_AST_act_n;
            r2_AST_act_n   <=r1_AST_act_n;
        end
    end
//assign o_CPLD_INT   = !r2_AST_PWROn_n | (!r2_AST_PWROff_n) | (!r2_AST_Reset_n);
assign o_AST_PSON   = !r2_AST_PWROn_n & (!r2_AST_act_n);  
assign o_AST_PWROff = !r2_AST_PWROff_n & (!r2_AST_act_n);
assign o_AST_Reset  = !r2_AST_Reset_n & (!r2_AST_act_n);
endmodule
