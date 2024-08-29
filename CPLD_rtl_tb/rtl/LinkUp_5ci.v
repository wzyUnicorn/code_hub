/***********************************************************
#
# Filename      : LinkUp_5ci.v
#
# Author        : Haiyu Zhang
# Description   : ---
# Create Time   : 2019-03-29 15:37:06
# Last Modified : 2019-03-29 17:39:50
***********************************************************/
`timescale 1 ns / 1 ns
module LINKUP (
    input   i_Clk,
    input   i_Rst_n,
    input   i_LinkUp_En,
	input   i_Clear_TimeOut,
	input   i_ich_linkup,
    output  o_TimeOut);

    reg         r1_linkup_en;
    reg         r2_linkup_en;
    reg         ns_timeout;
    reg         cs_timeout;
    reg [2:0]   ns_timecnt;
    reg [2:0]   cs_timecnt;

    wire    w_timecnt_en;

    always @(posedge i_Clk or negedge i_Rst_n) begin
        if (!i_Rst_n) begin
            r1_linkup_en    <= 1'b0;
            r2_linkup_en    <= 1'b0;
            cs_timeout      <= 1'b0;
            cs_timecnt      <= 3'b0;
        end else begin
            r1_linkup_en <= i_LinkUp_En;
            r2_linkup_en <= r1_linkup_en;
            cs_timeout   <= ns_timeout;
            cs_timecnt   <= ns_timecnt;
        end
    end

    //always @(*) begin
        //ns_timeout  = cs_timeout;
        //ns_timecnt  = cs_timecnt;
        //if (w_timecnt_en) begin
            //ns_timecnt = cs_timecnt + 1'b1;
        //end
        //if (cs_timecnt == 3'b101) begin
            //ns_timecnt = 3'b0;
            //ns_timeout = 1'b1;
        //end else if (i_Clear_TimeOut) begin
            //ns_timeout = 1'b0;
        //end else begin
			//ns_timeout = cs_timeout;
		//end
    //end

    always @(*) begin
        ns_timeout  = cs_timeout;
        ns_timecnt  = cs_timecnt;
        if (w_timecnt_en) begin
            ns_timecnt = cs_timecnt + 1'b1;
        end else begin
			if ((cs_timecnt == 3'b101)|| i_ich_linkup) begin
				ns_timecnt = 3'b0;
			end else begin
				ns_timecnt  = cs_timecnt;
			end
		end
		if (cs_timecnt == 3'b101) begin
            ns_timeout = 1'b1;
        end else if (i_Clear_TimeOut) begin
			ns_timeout = 1'b0;
		end
    end
    assign w_timecnt_en = r1_linkup_en && (!r2_linkup_en);
	//assign w_ich_link = i_ich_linkup_en || i_Clear_TimeOut;
    assign o_TimeOut = cs_timeout;
endmodule
