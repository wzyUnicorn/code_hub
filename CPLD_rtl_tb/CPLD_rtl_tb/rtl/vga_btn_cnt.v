///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <pwr_btn.v>
// File history:
//
// Description: 
//filt signal of button
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module VGA_BTN_CNT(
input        i_clk_32k,
input        i_rst_n,
input        i_vga_btn_cnt,
//input        i_vga_btn,
output       o_vga_btn_cnt_en

);


reg [8:0]  cs_vga_btn_cnt;
reg [8:0]  ns_vga_btn_cnt;
reg         cs_vga_btn_dly_en;
reg 	      ns_vga_btn_dly_en;

//reg        cs_vga_btn_en;
//reg        ns_vga_btn_en;
///////////////////////////////////////////////////////////////
    always @(posedge i_clk_32k or negedge i_rst_n)
        if (!i_rst_n)
			begin
            
            cs_vga_btn_cnt 	 <= 1'b0;
				cs_vga_btn_dly_en  <= 1'b0;
           // cs_vga_btn_en     <= 1'b0;
			end
        else
			begin
         
            //cs_vga_btn_en      <= ns_vga_btn_en;
            cs_vga_btn_cnt 	 <= ns_vga_btn_cnt;
				cs_vga_btn_dly_en  <= ns_vga_btn_dly_en;
			end    

   
always@*
begin
		//ns_vga_btn_en      = cs_vga_btn_en;
		ns_vga_btn_cnt 	 = cs_vga_btn_cnt;
		ns_vga_btn_dly_en  = cs_vga_btn_dly_en;
		/* if (!cs_vga_btn_dly_cnt)
				ns_vga_btn_en = 1'b0;
		else 
				ns_vga_btn_en = 1'b1; */
		/*if (!i_vga_btn_cnt)
			begin
				if (!(&cs_vga_btn_cnt))			
				ns_vga_btn_cnt = cs_vga_btn_cnt + 1'b1;
				else 
				ns_vga_btn_dly_en = 1'b1;
			end			
		else          
			begin
				ns_vga_btn_dly_en = 1'b1;
			end */
		if (i_vga_btn_cnt)
			begin
				if (!(&cs_vga_btn_cnt))			
				ns_vga_btn_cnt = cs_vga_btn_cnt + 1'b1;
				else 
				ns_vga_btn_dly_en = 1'b1;
			end			
		else          
			begin
				ns_vga_btn_dly_en = 1'b0;
			end 
		
end
////////////////////////////////////////////////////////////////////////////
    assign o_vga_btn_cnt_en     = cs_vga_btn_dly_en;
  

endmodule
