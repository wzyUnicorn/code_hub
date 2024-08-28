///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <rst_btn.v>
// File history:
//
// Description: 
//filt signal of  reset button
// Author: <zwp>
module RST_BTN(
input      i_clk_32k,
input      i_rst_n,
input      i_rst_btn,
output     o_rst_btn_press
);

////////////////regs//////////////
`ifdef CONFIG_FOR_SIM
reg [ 3:0] cs_rst_btn_cnt ;
reg [ 3:0] ns_rst_btn_cnt ;
`else
reg [13:0] cs_rst_btn_cnt ;
reg [13:0] ns_rst_btn_cnt ;
`endif
///////////////////////////////////////////////////

    always @(posedge i_clk_32k or negedge i_rst_n)
        if (!i_rst_n)
        begin
            `ifdef CONFIG_FOR_SIM
            cs_rst_btn_cnt <= #1 4'h0;
            `else
            cs_rst_btn_cnt <= #1 13'h0;
            `endif
        end
        else
        begin
            cs_rst_btn_cnt <= ns_rst_btn_cnt;
        end
    always @ *
        begin
            ns_rst_btn_cnt = cs_rst_btn_cnt;
            if (!i_rst_btn)
            begin
                if (!(&cs_rst_btn_cnt)) 
                    ns_rst_btn_cnt = cs_rst_btn_cnt + 1'b1;
            end
            else
            begin 
                `ifdef CONFIG_FOR_SIM
                if (cs_rst_btn_cnt >= 4'h3) 
                    ns_rst_btn_cnt = cs_rst_btn_cnt - 4'h3;
                else
                    ns_rst_btn_cnt = 4'h0;
                `else
                    if (cs_rst_btn_cnt >= 13'h73)
                        ns_rst_btn_cnt = cs_rst_btn_cnt - 13'h73;
                    else
                        ns_rst_btn_cnt = 13'h0;
                `endif
            end
        end
          `ifdef CONFIG_FOR_SIM
    assign o_rst_btn_press = cs_rst_btn_cnt[3]; 
          `else
    assign o_rst_btn_press = cs_rst_btn_cnt[12]; 
          `endif

endmodule
