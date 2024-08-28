///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <pwr_btn.v>
// File history:
//
// Description: 
//filt signal of button
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module PWR_BTN(
input        i_clk_32k,
input        i_rst_n,
input        i_pwr_btn,
output       o_pwr_btn_en,
output       o_Pressed4Second,
output       o_pwr_btn_press
);

/////////////regs///////////////////////////
`ifdef CONFIG_FOR_SIM
reg [6:0]  cs_PowerButtonCnt;
reg [6:0]  ns_PowerButtonCnt;
reg [2:0]  cs_pwr_btn_dly_cnt;
reg [2:0]  ns_pwr_btn_dly_cnt;
`else
reg [16:0]  cs_PowerButtonCnt;
reg [16:0]  ns_PowerButtonCnt;
reg [9:0]  cs_pwr_btn_dly_cnt;
reg [9:0]  ns_pwr_btn_dly_cnt;
`endif 
reg        cs_ButtonPressed;
reg        ns_ButtonPressed;
reg        cs_Pressed4Second;
reg        ns_Pressed4Second;
reg        cs_pwr_btn_en;
reg        ns_pwr_btn_en;
///////////////////////////////////////////////////////////////
    always @(posedge i_clk_32k or negedge i_rst_n)
        if (!i_rst_n)
        begin
            `ifdef CONFIG_FOR_SIM
            cs_PowerButtonCnt <=#1 7'h0;
            cs_pwr_btn_dly_cnt <=#1 3'b000;
            `else
            cs_PowerButtonCnt <=#1 17'h0;
            cs_pwr_btn_dly_cnt <=#1 10'b000;
            `endif 
            cs_ButtonPressed  <=#1 1'b0;
            cs_Pressed4Second <=#1 1'b0;
            cs_pwr_btn_en     <= 1'b0;
        end
        else
        begin
            cs_PowerButtonCnt  <= ns_PowerButtonCnt;
            cs_ButtonPressed   <= ns_ButtonPressed; 
            cs_Pressed4Second  <= ns_Pressed4Second;
            cs_pwr_btn_en      <= ns_pwr_btn_en;
            cs_pwr_btn_dly_cnt <= ns_pwr_btn_dly_cnt;
        end    

    always @ *
    begin
        ns_PowerButtonCnt  = cs_PowerButtonCnt;
	ns_ButtonPressed   = cs_ButtonPressed; 
	ns_Pressed4Second  = cs_Pressed4Second;
        if (!i_pwr_btn)
        begin
            if (!(&cs_PowerButtonCnt))  ns_PowerButtonCnt = cs_PowerButtonCnt + 1'b1;
			
        end  
        else
        begin
            `ifdef CONFIG_FOR_SIM
            if (cs_PowerButtonCnt[6:0]>= 7'h0f)     
                ns_PowerButtonCnt =  cs_PowerButtonCnt- 7'hf; 
            else
                ns_PowerButtonCnt =  7'h0;
            `else
            if (cs_PowerButtonCnt[16:0]>= 17'hf7)   
                ns_PowerButtonCnt =  cs_PowerButtonCnt - 8'hf7; 
            else
                ns_PowerButtonCnt =  17'h0;
            `endif 
        end
        `ifdef CONFIG_FOR_SIM
        ns_ButtonPressed  =  (|cs_PowerButtonCnt[6:4]);
        ns_Pressed4Second =  (&cs_PowerButtonCnt[6:4]);
        `else
        ns_ButtonPressed  =   (|cs_PowerButtonCnt[16:12]);
        ns_Pressed4Second =   (&cs_PowerButtonCnt[16:12]);
        `endif
    end
    
//////////////////////////////////////////////////////////////////////////
always@*
begin
    ns_pwr_btn_en      = cs_pwr_btn_en;
    ns_pwr_btn_dly_cnt = cs_pwr_btn_dly_cnt;
    if (&cs_pwr_btn_dly_cnt) 
		ns_pwr_btn_en = 1'b1;
    else                     
		ns_pwr_btn_en = 1'b0;
    if (i_pwr_btn)
        begin
            if (!(&cs_pwr_btn_dly_cnt))
				ns_pwr_btn_dly_cnt = cs_pwr_btn_dly_cnt +1'b1;
            else                        
				ns_pwr_btn_dly_cnt = cs_pwr_btn_dly_cnt ;
        end
    else                            
		ns_pwr_btn_dly_cnt = cs_pwr_btn_dly_cnt ;
end
////////////////////////////////////////////////////////////////////////////
    assign o_pwr_btn_en     = cs_pwr_btn_en;
    assign o_pwr_btn_press  = cs_ButtonPressed;
    assign o_Pressed4Second = cs_Pressed4Second;

endmodule
