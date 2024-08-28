///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <iic_reg.v>
// File history:
//
// Description: 
// iic reg write and read
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module IIC_REG(                                                       
	// Generic synchronous two-port RAM interface                        
	i_iic_clk, i_iic_rst, i_iic_ce, i_iic_we, i_iic_oe, i_iic_addr, i_iic_data, o_iic_data, i_fsm_state                 
        ,o_divide,o_beep_en                        
        ,o_PowerOn
        ,o_PowerOff,o_MT_RST,o_SoftReset
);                                                                       
//                                                                       
// Default address and data buses width                                  
//                                                                       
parameter iic_aw = 2;                                                        
parameter iic_dw = 8;                                                        
parameter IIC_VERSION= 8'h32;                                              
`ifdef CONFIG_FOR_SIM                                                    
parameter iic_p_num = 6;                                                     
parameter iic_s_num = 6;                                                     
parameter iic_m_num = 6;                                                     
`else                                                                    
parameter iic_p_num = 12;                                                    
parameter iic_s_num = 12;                                                    
parameter iic_m_num = 12;                                                    
`endif                                                                   
////////added ports//////////////                                        
output [4:0]     o_divide;                                               
output           o_beep_en;                                              
output           o_SoftReset;                                            
output           o_MT_RST;                                               
output           o_PowerOff;                                             
output           o_PowerOn;                                             
//////////////////////////////////                                       
//                                                                       
// Generic synchronous two-port RAM interface                            
//                                                                       
input			i_iic_clk;	// Clock                                         
input			i_iic_rst;	// Reset                                         
input			i_iic_ce;	// Chip enable input                             
input			i_iic_we;	// Write enable input                            
input			i_iic_oe;	// Output enable input                           
input 	[iic_aw-1:0]	i_iic_addr;	// address bus inputs                        
input	[iic_dw-1:0]	i_iic_data;	// input data bus 
input   [3:0]           i_fsm_state;//zhy add iic check fsm state
output	[iic_dw-1:0]	o_iic_data;	// output data bus                           
                                                                         
//                                                                       
// Internal wires and registers                                          
//                                                                       
                                                                         
reg                 cs_pwr_on_en;                                             
reg                 cs_soft_rst_en;                                             
reg                 cs_mt_rst_en;                                               
reg                 cs_pwr_off_en;                                              
reg [iic_p_num-1:0] cs_pwr_off_cnt;                                             
reg [iic_p_num-1:0] cs_pwr_on_cnt;                                             
reg [iic_s_num-1:0] cs_soft_rst_cnt;                                            
reg [iic_m_num-1:0] cs_mt_rst_cnt;                                              
reg                 ns_pwr_on_en;                                             
reg                 ns_soft_rst_en;                                             
reg                 ns_mt_rst_en;                                               
reg                 ns_pwr_off_en;                                              
reg [iic_p_num-1:0] ns_pwr_off_cnt;                                             
reg [iic_p_num-1:0] ns_pwr_on_cnt;                                             
reg [iic_s_num-1:0] ns_soft_rst_cnt;                                            
reg [iic_m_num-1:0] ns_mt_rst_cnt;                                              
reg [4:0]           cs_beepa_div;
reg                 cs_beepa_en;
reg [4:0]           ns_beepa_div;
reg                 ns_beepa_en;
reg [iic_dw-1:0]    reg_a0;
reg [iic_dw-1:0]    reg_a1;
reg [iic_dw-1:0]    reg_a2;
reg [iic_dw-1:0]    reg_a3;
reg [iic_dw-1:0]    data_out_a;
//reg [3:0]           r1_fsm_state;//zhy add iic check fsm state
//reg [3:0]           r2_fsm_state;//zhy add iic check fsm state
//                                                                       
// Data output drivers                                                   
//                                                                       
assign o_iic_data = (i_iic_oe) ? data_out_a : {iic_dw{1'b0}};
                                                                         
//                                                                       
//                                                                       
always @ ( posedge i_iic_clk or posedge i_iic_rst)
begin
    if (i_iic_rst)
    begin
        reg_a0 <= 8'b0;
        reg_a1 <= IIC_VERSION;
        reg_a2 <= 8'b0;
        reg_a3 <= 8'b0;
        data_out_a<= 8'b0;
		//r1_fsm_state <= 4'b0;
		//r2_fsm_state <= 4'b0;
        cs_beepa_en <= 1'b0;  
        `ifdef CONFIG_FOR_SIM
        cs_beepa_div <= 5'h0;		  
        `else
        cs_beepa_div <= 5'h10;		  
        `endif
        cs_soft_rst_cnt <= {iic_s_num{1'b0}};
        cs_soft_rst_en  <= 1'b0;
        cs_mt_rst_cnt   <= {iic_m_num{1'b0}};
        cs_mt_rst_en    <= 1'b0;
        cs_pwr_off_cnt  <= {iic_p_num{1'b0}};
        cs_pwr_off_en   <= 1'b0;
        cs_pwr_on_cnt   <= {iic_p_num{1'b0}};
        cs_pwr_on_en    <= 1'b0;
    end
    else
    begin
        if (i_iic_ce&i_iic_we)
        begin
            case(i_iic_addr)
            2'b00: reg_a0 <= i_iic_data;
            2'b01: reg_a1 <= IIC_VERSION;
            2'b10: reg_a2 <= i_iic_data;//zhy change ,this reg is read only for iic check fsm state
            2'b11: reg_a3 <= i_iic_data;
            default: reg_a1 <= IIC_VERSION;
            endcase
        end

        case(i_iic_addr)
        2'b00: data_out_a <= reg_a0;
        2'b01: data_out_a <= reg_a1;
        2'b10: data_out_a <= reg_a2;
		//2'b10: data_out_a <= r2_fsm_state;//zhy add iic check fsm state
        2'b11: data_out_a <= reg_a3;
        endcase
        cs_beepa_en  <= ns_beepa_en;
        cs_beepa_div <= ns_beepa_div;
        cs_soft_rst_cnt <= ns_soft_rst_cnt;
        cs_soft_rst_en  <= ns_soft_rst_en;
        cs_mt_rst_cnt   <= ns_mt_rst_cnt;
        cs_mt_rst_en    <= ns_mt_rst_en;
        cs_pwr_off_cnt  <= ns_pwr_off_cnt;
        cs_pwr_off_en   <= ns_pwr_off_en;
        cs_pwr_on_cnt   <= ns_pwr_on_cnt;
        cs_pwr_on_en    <= ns_pwr_on_en;
		//r1_fsm_state    <= i_fsm_state;////zhy add iic check fsm state 
		//r2_fsm_state    <= r1_fsm_state;///zhy add iic check fsm state
    end
end

always@*
begin
//control beep
    ns_beepa_en = cs_beepa_en;
    ns_beepa_div = cs_beepa_div;
    if ((i_iic_addr==2'b10)&&i_iic_we) 
    begin
        ns_beepa_en = i_iic_data[0];
        ns_beepa_div = i_iic_data[7:3];
    end
//control soft rst via IIC interface
    ns_soft_rst_cnt = cs_soft_rst_cnt;
    ns_soft_rst_en  = cs_soft_rst_en;
    if(!cs_soft_rst_en&&(i_iic_addr==2'b00)&&i_iic_we&&(i_iic_data==8'hc3))
        ns_soft_rst_en = 1'b1;
    if ((&cs_soft_rst_cnt) && cs_soft_rst_en )
        ns_soft_rst_en = 1'b0;
    if (!cs_soft_rst_en ) ns_soft_rst_cnt = {iic_s_num{1'b0}};
    else if (!(&cs_soft_rst_cnt))
        ns_soft_rst_cnt = cs_soft_rst_cnt + 1'b1;

//control power on via IIC interface
    ns_pwr_on_cnt = cs_pwr_on_cnt;
    ns_pwr_on_en  = cs_pwr_on_en;
    if(!cs_pwr_on_en&&(i_iic_addr==2'b00)&&i_iic_we&&(i_iic_data==8'h0f))
        ns_pwr_on_en = 1'b1;
    if ((&cs_pwr_on_cnt) && cs_pwr_on_en )
        ns_pwr_on_en = 1'b0;
    if (!cs_pwr_on_en ) ns_pwr_on_cnt = {iic_p_num{1'b0}};
    else if (!(&cs_pwr_on_cnt))
        ns_pwr_on_cnt = cs_pwr_on_cnt + 1'b1;

//control power off via IIC interface
    ns_pwr_off_cnt = cs_pwr_off_cnt;
    ns_pwr_off_en  = cs_pwr_off_en;
    if(!cs_pwr_off_en&&(i_iic_addr==2'b00)&&i_iic_we&&(i_iic_data==8'hf0))
        ns_pwr_off_en = 1'b1;
    if ((&cs_pwr_off_cnt) && cs_pwr_off_en )
        ns_pwr_off_en = 1'b0;
    if (!cs_pwr_off_en ) ns_pwr_off_cnt = {iic_p_num{1'b0}};
    else if (!(&cs_pwr_off_cnt))
        ns_pwr_off_cnt = cs_pwr_off_cnt + 1'b1;

//control mt rst via IIC interface
    ns_mt_rst_cnt = cs_mt_rst_cnt;
    ns_mt_rst_en  = cs_mt_rst_en;
    if(!cs_mt_rst_en&&(i_iic_addr==2'b00)&&i_iic_we&&(i_iic_data==8'hee))
        ns_mt_rst_en = 1'b1;
    if ((&cs_mt_rst_cnt) && cs_mt_rst_en )
        ns_mt_rst_en = 1'b0;
    if (!cs_mt_rst_en ) ns_mt_rst_cnt = {iic_m_num{1'b0}};
    else if (!(&cs_mt_rst_cnt))
        ns_mt_rst_cnt = cs_mt_rst_cnt + 1'b1;
end

                                                                         
assign o_beep_en   = cs_beepa_en ;
assign o_divide    = cs_beepa_div ;
assign o_PowerOff  = cs_pwr_off_en;                           
assign o_MT_RST    = cs_mt_rst_en;                             
assign o_SoftReset = cs_soft_rst_en;                         
assign o_PowerOn   = cs_pwr_on_en;
                                                                         
endmodule                                                                
                                                                         

