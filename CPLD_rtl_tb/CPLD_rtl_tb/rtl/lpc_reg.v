///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <lpc_reg.v>
// File history:
//
// Description: 
// lpc reg write and read
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module LPC_REG(                                                       
	// Generic synchronous two-port RAM interface                        
	i_lpc_clk, i_lpc_rst, i_dog_rst,i_lpc_ce, i_lpc_we, i_lpc_oe, i_lpc_addr, i_lpc_data,i_clk_32k,i_rst_n,o_lpc_data,                  
        o_divide,o_beep_en                        
        ,o_PowerOff,o_MT_RST,o_SoftReset,o_ICH_LinkUp_en,i_ctrl_state,o_vga_SoftReset
);                                                                       
//                                                                       
// Default address and data buses width                                  
//                                                                       
parameter lpc_aw = 2;                                                        
parameter lpc_dw = 8;                                                        
parameter LPC_VERSION= 8'h41;                                              
`ifdef CONFIG_FOR_SIM                                                    
parameter lpc_p_num = 5;                                                     
parameter lpc_s_num = 5;                                                     
parameter lpc_m_num = 5;                                                     
`else                                                                    
parameter lpc_p_num = 12;                                                    
parameter lpc_s_num = 12;                                                    
parameter lpc_m_num = 12;                                                    
`endif                                                                   
////////added ports//////////////                                        
output [4:0]     o_divide;                                               
output           o_beep_en;                                              
output           o_SoftReset;                                            
output           o_MT_RST;                                               
output           o_PowerOff;  
output			 o_ICH_LinkUp_en;
output			 o_vga_SoftReset;
//////////////////////////////////                                       
//                                                                       
// Generic synchronous two-port RAM interface                            
//  
input			i_clk_32k;
input			i_rst_n;
input			i_dog_rst;
input			i_lpc_clk;	// Clock                                         
input			i_lpc_rst;	// Reset                                         
input			i_lpc_ce;	// Chip enable input                             
input			i_lpc_we;	// Write enable input                            
input			i_lpc_oe;	// Output enable input                           
input 	[lpc_aw-1:0]	i_lpc_addr;	// address bus inputs                        
input	[lpc_dw-1:0]	i_lpc_data;	// input data bus                            
output	[lpc_dw-1:0]	o_lpc_data;	// output data bus      
input	[3:0]	i_ctrl_state;

                                                                         
//                                                                       
// Internal wires and registers                                          
//                                                                       
                                                                         
reg                 cs_soft_rst_en;                                             
reg                 cs_mt_rst_en;                                               
reg                 cs_pwr_off_en;                                              
reg [lpc_p_num-1:0] cs_pwr_off_cnt;                                             
reg [lpc_s_num-1:0] cs_soft_rst_cnt;                                            
reg [lpc_m_num-1:0] cs_mt_rst_cnt; 
reg                 cs_ich_linkup_en;
reg                 ns_ich_linkup_en;
reg                 ns_soft_rst_en;                                             
reg                 ns_mt_rst_en;                                               
reg                 ns_pwr_off_en;                                              
reg [lpc_p_num-1:0] ns_pwr_off_cnt;                                             
reg [lpc_s_num-1:0] ns_soft_rst_cnt;                                            
reg [lpc_m_num-1:0] ns_mt_rst_cnt;                                              
reg [4:0]           cs_beepa_div;
reg                 cs_beepa_en;
reg [4:0]           ns_beepa_div;
reg                 ns_beepa_en;
reg [lpc_dw-1:0]    reg_a0;
reg [lpc_dw-1:0]    reg_a1;
reg [lpc_dw-1:0]    reg_a2;
reg [lpc_dw-1:0]    reg_a3;
reg [lpc_dw-1:0]    data_out_a;
reg	[4:0]			r1_ctrl_state;
reg [4:0]			r2_ctrl_state;
reg					ns_vga_soft_rst_en;
reg					cs_vga_soft_rst_en;

//                                                                       
// Data output drivers                                                   
//                                                                       
assign o_lpc_data = (i_lpc_oe) ? data_out_a : {lpc_dw{1'b0}};
                                                                         

/*always @ (posedge i_clk_32k or negedge i_rst_n)
begin
if (!i_rst_n)
	begin
	cs_beepa_en <= 1'b0;
	end
else
begin
	cs_beepa_en  <= ns_beepa_en;
	end
end
*/
//       


always @ ( posedge i_lpc_clk or posedge i_dog_rst)
begin
    if (i_dog_rst)
    begin
		cs_vga_soft_rst_en  <= 1'b0;
	end
	else
	begin
		cs_vga_soft_rst_en  <= ns_vga_soft_rst_en;
	end
end


always @ ( posedge i_lpc_clk or posedge i_lpc_rst)
begin
    if (i_lpc_rst)
    begin
        reg_a0 <= 8'b0;
        reg_a1 <= LPC_VERSION;
        reg_a2 <= 8'b0;
        reg_a3 <= 8'b0;
		r1_ctrl_state <= 4'b0;
		r2_ctrl_state <= 4'b0;
        data_out_a<= 8'b0;
        cs_beepa_en <= 1'b0;  
        `ifdef CONFIG_FOR_SIM
        cs_beepa_div <= 5'h0;	
        `else
        cs_beepa_div <= 5'h10;	
        `endif
        cs_soft_rst_cnt <= {lpc_s_num{1'b0}};
        cs_soft_rst_en  <= 1'b0;
        cs_mt_rst_cnt   <= {lpc_m_num{1'b0}};
        cs_mt_rst_en    <= 1'b0;
        cs_pwr_off_cnt  <= {lpc_p_num{1'b0}};
        cs_pwr_off_en   <= 1'b0;
		cs_ich_linkup_en   <= 1'b0;
        cs_vga_soft_rst_en<=1'b0;
    end
    else
    begin
        if (i_lpc_ce&i_lpc_we)
        begin
            case(i_lpc_addr)
            2'b00: reg_a0 <= i_lpc_data;
            2'b01: reg_a1 <= LPC_VERSION;
            2'b10: reg_a2 <= i_lpc_data;
            2'b11: reg_a3 <= i_lpc_data;
            default: reg_a1 <= LPC_VERSION;
            endcase
        end

        case(i_lpc_addr)
        2'b00: data_out_a <= reg_a0;
        2'b01: data_out_a <= reg_a1;
        2'b10: data_out_a <= reg_a2;
        2'b11: data_out_a <= reg_a3;
        endcase
		r1_ctrl_state <= i_ctrl_state;
		r2_ctrl_state <= r1_ctrl_state;
        cs_beepa_en  <= ns_beepa_en;
        cs_beepa_div <= ns_beepa_div;
        cs_soft_rst_cnt <= ns_soft_rst_cnt;
        cs_soft_rst_en  <= ns_soft_rst_en;
        cs_mt_rst_cnt   <= ns_mt_rst_cnt;
        cs_mt_rst_en    <= ns_mt_rst_en;
        cs_pwr_off_cnt  <= ns_pwr_off_cnt;
        cs_pwr_off_en   <= ns_pwr_off_en;
		cs_ich_linkup_en   <= ns_ich_linkup_en;
    end
end

always @ * 
begin
//control beep via LPC interface
    ns_beepa_en = cs_beepa_en;
    ns_beepa_div = cs_beepa_div;
    if ((i_lpc_addr==3'b010)&&i_lpc_we) 
    begin
        ns_beepa_en = i_lpc_data[0];
        ns_beepa_div = i_lpc_data[7:3];
    end

//control vga soft rst via LPC interface

   ns_vga_soft_rst_en  = cs_vga_soft_rst_en;
    if(!cs_vga_soft_rst_en&&(i_lpc_addr==2'b00)&&i_lpc_we&&(i_lpc_data==8'haa))
       begin
	   ns_vga_soft_rst_en = 1'b1;
	   ns_beepa_en = 1'b1;
	   end
	
	  

//control soft rst via LPC interface
    ns_soft_rst_cnt = cs_soft_rst_cnt;
    ns_soft_rst_en  = cs_soft_rst_en;
    if(!cs_soft_rst_en&&(i_lpc_addr==2'b00)&&i_lpc_we&&(i_lpc_data==8'hc3))
        ns_soft_rst_en = 1'b1;
    if ((&cs_soft_rst_cnt) && cs_soft_rst_en )
        ns_soft_rst_en = 1'b0;
    if (!cs_soft_rst_en ) ns_soft_rst_cnt = {lpc_s_num{1'b0}};
    else if (!(&cs_soft_rst_cnt))
        ns_soft_rst_cnt = cs_soft_rst_cnt + 1'b1;

//control power off via LPC interface
    ns_pwr_off_cnt = cs_pwr_off_cnt;
    ns_pwr_off_en  = cs_pwr_off_en;
    if(!cs_pwr_off_en&&(i_lpc_addr==2'b00)&&i_lpc_we&&(i_lpc_data==8'hf0))
        ns_pwr_off_en = 1'b1;
    if ((&cs_pwr_off_cnt) && cs_pwr_off_en )
        ns_pwr_off_en = 1'b0;
    if (!cs_pwr_off_en ) ns_pwr_off_cnt = {lpc_p_num{1'b0}};
    else if (!(&cs_pwr_off_cnt))
        ns_pwr_off_cnt = cs_pwr_off_cnt + 1'b1;

//control mt rst via LPC interface
    ns_mt_rst_cnt = cs_mt_rst_cnt;
    ns_mt_rst_en  = cs_mt_rst_en;
    if(!cs_mt_rst_en&&(i_lpc_addr==2'b00)&&i_lpc_we&&(i_lpc_data==8'hee))
        ns_mt_rst_en = 1'b1;
    if ((&cs_mt_rst_cnt) && cs_mt_rst_en )
        ns_mt_rst_en = 1'b0;
    if (!cs_mt_rst_en ) ns_mt_rst_cnt = {lpc_m_num{1'b0}};
    else if (!(&cs_mt_rst_cnt))
        ns_mt_rst_cnt = cs_mt_rst_cnt + 1'b1;
		
	//control ICH2 to CPU Link Up via LPC interface
    //ns_ich_linkup_cnt = cs_ich_linkup_cnt;
    ns_ich_linkup_en  = cs_ich_linkup_en;
    if(!cs_ich_linkup_en && (i_lpc_addr==3'b000)&&i_lpc_we && (i_lpc_data==8'hff))
        ns_ich_linkup_en = 1'b1;
	if ((r2_ctrl_state == 4'b1111) && cs_ich_linkup_en)
		ns_ich_linkup_en = 1'b0;

end

assign o_beep_en   = cs_beepa_en ;
assign o_divide    = cs_beepa_div ;
assign o_PowerOff  = cs_pwr_off_en;                           
assign o_MT_RST    = cs_mt_rst_en;                             
assign o_SoftReset = cs_soft_rst_en; 
assign o_ICH_LinkUp_en = cs_ich_linkup_en;
assign o_vga_SoftReset = cs_vga_soft_rst_en;
                                                                         
endmodule                                                                
                                                                         

