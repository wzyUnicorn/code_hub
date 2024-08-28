///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <delay.v>
// File history:
//
// Description: 
// delay time for design
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module DELAY(
input        i_clk_32k,
input        i_rst_n,
input        i_cnt_en,
input        i_dly_en,
input [11:0] i_data,//time scale is ms
output       o_delay_time
);
/////////parameters///////
parameter INTER = 32;
parameter INTER_SIM = 2;
/////////regs////////////
`ifdef CONFIG_FOR_SIM
reg [ 3:0]   cs_dly_cnt;
reg [ 3:0]   ns_dly_cnt;
`else
reg [16:0]   cs_dly_cnt;
reg [16:0]   ns_dly_cnt;
`endif
reg          cs_dly_time;
reg          ns_dly_time;
reg [16:0]   r_rcv_cnt;
reg          r1_cnt_en;
reg          r2_cnt_en;
reg          cs_dly_set;
reg          ns_dly_set;
    always @(posedge i_clk_32k or negedge i_rst_n)
    begin
        if (!i_rst_n)
        begin
	    `ifdef CONFIG_FOR_SIM
	    cs_dly_cnt <= 4'hf;
	    `else
	    cs_dly_cnt <= 17'h1ffff;
	    `endif
            cs_dly_time<= 1'b0;
	    r_rcv_cnt  <= 17'h1ffff;
            r1_cnt_en  <= 1'b0;
            r2_cnt_en  <= 1'b0;
            cs_dly_set <= 1'b0;
        end
        else
	begin
            cs_dly_cnt <= ns_dly_cnt;
            cs_dly_time<= ns_dly_time;
            `ifdef CONFIG_FOR_SIM
	    r_rcv_cnt  <= INTER_SIM * i_data;
            `else
	    r_rcv_cnt  <= INTER * i_data;
            `endif
            r1_cnt_en  <= i_cnt_en;
            r2_cnt_en  <= r1_cnt_en;
            cs_dly_set <= ns_dly_set;
        end
    end
    always @ *
    begin
	ns_dly_cnt  = cs_dly_cnt;
	ns_dly_time = cs_dly_time;
        ns_dly_set  = cs_dly_set;
        if (!r2_cnt_en && r1_cnt_en)//__|--
        begin
	    `ifdef CONFIG_FOR_SIM
	    ns_dly_cnt = r_rcv_cnt[7:4];
	    `else
	    ns_dly_cnt = r_rcv_cnt; 
	    `endif
            ns_dly_time = 1'b0;
            ns_dly_set  = 1'b1;
        end
        else
        begin
            if (|cs_dly_cnt)
                ns_dly_cnt = cs_dly_cnt - 1'b1;
            else 
                ns_dly_cnt = cs_dly_cnt;
            ns_dly_time = !(|cs_dly_cnt);
        end
    end
assign o_delay_time = (i_dly_en&cs_dly_set) ? cs_dly_time : 1'b0; 

endmodule
