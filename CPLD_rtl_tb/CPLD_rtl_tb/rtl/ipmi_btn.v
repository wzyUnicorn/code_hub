///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <ipmi_btn.v>
// File history:
//
// Description: 
//filt signal of ipmi button
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module IPMI_BTN(
input     i_clk_32k,
input     i_rst_n,
input     i_ipmi_btn,
output    o_ipmi_btn_press
);

//////////////regs///////////////
`ifdef CONFIG_FOR_SIM
reg [ 6:0]  cs_IPMI_BTN_Cnt;
reg [ 6:0]  ns_IPMI_BTN_Cnt;
reg [ 6:0]  cs_IPMI_RST_BTN_Cnt;
reg [ 6:0]  ns_IPMI_RST_BTN_Cnt;
`else
reg [12:0]  cs_IPMI_BTN_Cnt;
reg [12:0]  ns_IPMI_BTN_Cnt;
reg [13:0]  cs_IPMI_RST_BTN_Cnt;
reg [13:0]  ns_IPMI_RST_BTN_Cnt;
`endif
reg         cs_IPMI_BTN_OK;
reg         ns_IPMI_BTN_OK;
reg         cs_IPMI_BTN_PRESS;
reg         ns_IPMI_BTN_PRESS;
reg         r1_ipmi_btn;
reg         r2_ipmi_btn;
////////////////////////dly ipmi rst btn 2s////////////////////////////

always @(posedge i_clk_32k or negedge i_rst_n)
    begin
        if (!i_rst_n)
        begin
            `ifdef CONFIG_FOR_SIM
            ns_IPMI_RST_BTN_Cnt <=7'b0;
            cs_IPMI_RST_BTN_Cnt <=7'b0;
            ns_IPMI_BTN_Cnt <=7'b0;
            cs_IPMI_BTN_Cnt <=7'b0;
            `else
            cs_IPMI_RST_BTN_Cnt <=14'b0;
            cs_IPMI_BTN_Cnt <=13'b0;
            `endif
            cs_IPMI_BTN_OK <=1'b0;
            cs_IPMI_BTN_PRESS<=1'b0;
						r1_ipmi_btn <= 1'b0;
						r2_ipmi_btn <= 1'b0;
        end
        else
        begin
            cs_IPMI_BTN_OK <=ns_IPMI_BTN_OK;
            cs_IPMI_BTN_PRESS<=ns_IPMI_BTN_PRESS;
            cs_IPMI_RST_BTN_Cnt <=ns_IPMI_RST_BTN_Cnt;
						r1_ipmi_btn <= i_ipmi_btn;
						r2_ipmi_btn <= r1_ipmi_btn;
        end
    end

always @ *
    begin
        ns_IPMI_RST_BTN_Cnt  = cs_IPMI_RST_BTN_Cnt;
        ns_IPMI_BTN_OK       = cs_IPMI_BTN_OK;
	ns_IPMI_BTN_PRESS    = cs_IPMI_BTN_PRESS;
        if (r2_ipmi_btn)//ipmi btn do not work
        begin
            if (!(&cs_IPMI_RST_BTN_Cnt))  ns_IPMI_RST_BTN_Cnt = cs_IPMI_RST_BTN_Cnt + 1'b1;
            else                          ns_IPMI_RST_BTN_Cnt = cs_IPMI_RST_BTN_Cnt;
            `ifdef CONFIG_FOR_SIM
            if (cs_IPMI_BTN_Cnt[6:0]>= 7'h0f)     
                ns_IPMI_BTN_Cnt =  cs_IPMI_BTN_Cnt- 7'hf; 
            else
                ns_IPMI_BTN_Cnt=  7'h0;
            `else
            if (cs_IPMI_BTN_Cnt[12:0]>= 13'hf7)   
                ns_IPMI_BTN_Cnt =  cs_IPMI_BTN_Cnt - 8'hf7; 
            else
                ns_IPMI_BTN_Cnt =  13'h0;
            `endif 
        end  
        else
        begin
            if (!(&cs_IPMI_BTN_Cnt)&&cs_IPMI_BTN_OK)  ns_IPMI_BTN_Cnt = cs_IPMI_BTN_Cnt + 1'b1;
            else                      ns_IPMI_BTN_Cnt = cs_IPMI_BTN_Cnt;
            ns_IPMI_RST_BTN_Cnt = cs_IPMI_RST_BTN_Cnt;

        end
        ns_IPMI_BTN_OK = &cs_IPMI_RST_BTN_Cnt;
        `ifdef CONFIG_FOR_SIM
        ns_IPMI_BTN_PRESS = |cs_IPMI_BTN_Cnt[6:5];
        `else
        ns_IPMI_BTN_PRESS = |cs_IPMI_BTN_Cnt[12:11]; 
        `endif
    end

///////////////////////////////////////////////////////////////////////
assign  o_ipmi_btn_press = cs_IPMI_BTN_PRESS;

endmodule
