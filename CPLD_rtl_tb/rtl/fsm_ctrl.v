///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <fsm_ctrl.v>
// File history:
//
// Description: 
// control the FSM of design
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
//`define         DCOK_DELAY
//`define         CPU_RST_L
module FSM_CTRL(
input        i_clk_32k,
input        i_clk_8k,
input        i_clk_1k,
input        i_rst_n,
input        i_DCOKSby,
input        i_btn_PSON,
input        i_btn_rst ,
input        i_All_PWRGD,
input        i_ATX_PWRGD,
input        i_IO_PWRGD,
input        i_DLI_VDD18_PG,
input		 i_CORE08_PG,
input        i_VTT_PWRGD,
input        i_PowerOn,
input        i_PowerOff,
input        i_MT_RST,
input        i_SoftRst,
//input        i_UID_BUT_n,
input		  i_TS_VS_ALARM_L,
input		 i_vga_cnt_en,
input	     i_vga_soft_rst_en,
//output       o_UID_LED,
output       o_DLI_VDD18_EN,
output       o_1V2Enable,
output       o_CORE08Enable,
output       o_PCIEReset0,
output       o_PCIEReset1,
output       o_CPU_DCOK,
output       o_CPUReset_n,
output       o_PSON,
output       o_GreenLED,
output       o_YellowLED,
output       o_Clear_TimeOut,
output       o_VDD18_EN,
//output		 o_UID_BUT_n,

//test
//output       o_dly64ms,
//output       o_SoftReset,

output       o_9230_PRST_n,
output [3:0] o_ctrl_state
);
////////////parameters/////////

parameter Start           = 4'b0000;
parameter Sby             = 4'b0001;
parameter SbyEnd          = 4'b0010;
parameter PSOn            = 4'b0011;
parameter PSOn2           = 4'b0100;
parameter ATXPowerGood    = 4'b0101;
parameter WorkPowerGood   = 4'b0110;
parameter DLIPowerGood    = 4'b0111;
parameter VTTPowerGood    = 4'b1000;
parameter AllPowerGood    = 4'b1001;
parameter PCIEReset       = 4'b1010;
parameter PCIEResetEnd    = 4'b1011;
parameter CPU_DCOk        = 4'b1100;  
parameter And             = 4'b1101;
parameter End             = 4'b1110;
parameter Bnd             = 4'b1111;


///////////////regs////////////
reg           r1_DCOKSby		;
reg           r2_DCOKSby		;
reg           r1_All_PWRGD      ;
reg           r2_All_PWRGD      ;
reg           r1_ATX_PWRGD      ;
reg           r2_ATX_PWRGD      ;
reg           r1_IO_PWRGD      ;
reg           r2_IO_PWRGD      ;
reg           r1_SoftRst        ;
reg           r2_SoftRst        ;
reg           r1_MT_RST         ; 
reg           r2_MT_RST         ; 
reg           r1_PowerOn        ; 
reg           r2_PowerOn        ; 
reg           r1_PowerOff       ; 
reg           r2_PowerOff       ; 
reg           r1_btn_PSON       ; 
reg           r2_btn_PSON       ; 
reg           r1_btn_rst        ; 
reg           r2_btn_rst        ; 
//reg           r1_UID_BUT_n      ;
//reg           r2_UID_BUT_n      ;
reg			  r1_TS_VS_ALARM_L;
reg			  r2_TS_VS_ALARM_L;
reg [3:0]     cs_ctrl_state     ;		
reg           cs_1V2Enable      ;
reg           cs_PCIEReset0_n   ;
reg           cs_PCIEReset1_n   ;
reg           cs_CPU_DCOK       ;
reg           cs_CPUReset_n     ;
reg           cs_PSON           ;
reg           cs_GreenLED       ;
reg           cs_YellowLED      ;
//reg           cs_UID_led      ;
reg           cs_9230_PRST_n    ; 

reg           ns_9230_PRST_n    ;
//reg           ns_UID_led      ;
//reg           r_UID_LED         ;
reg [3:0]     ns_ctrl_state     ;		
reg           ns_1V2Enable      ;
reg           ns_PCIEReset0_n   ;
reg           ns_PCIEReset1_n   ;
reg           ns_CPU_DCOK       ;
reg           ns_CPUReset_n     ;
reg           ns_PSON           ;
reg           ns_GreenLED       ;
reg           ns_YellowLED      ;
reg           cs_CORE08Enable;
reg           ns_CORE08Enable;
reg           cs_DLI_VDD18_EN;
reg           ns_DLI_VDD18_EN;
reg           cs_clear_timeout;
reg			  ns_clear_timeout;
reg           r1_VTT_PWRGD;
reg           r2_VTT_PWRGD;
reg           r1_DLI_VDD18_PG;
reg           r2_DLI_VDD18_PG;
reg           r1_CORE08_PG	;
reg           r2_CORE08_PG	;
reg           cs_VDD18_EN;
reg           ns_VDD18_EN;
reg			  r1_vga_cnt_en;
reg			  r2_vga_cnt_en;
reg			  r1_vga_soft_rst_en;
reg			  r2_vga_soft_rst_en;
reg			  r3_vga_soft_rst_en;
reg			  r4_vga_soft_rst_en;
reg			  r5_vga_soft_rst_en;
reg			  r6_vga_soft_rst_en;

reg[4:0]      cs_vga_rst_cnt;
reg[4:0] 	  ns_vga_rst_cnt;

//reg [12:0]    ns_UIDButtonCnt;
//reg [12:0]    cs_UIDButtonCnt;
//////////////////wire//////////////
wire          w_dly2ms;
wire          w_dly128ms;
wire          w_dly256ms;
wire          w_dly32ms;
wire          w_dly64ms;
wire          w_dly512ms;
wire          w_PowerOn ;
wire          w_PowerOff;
wire          w_SoftReset;
wire          w_dly120ms;
//wire          w_UIDButtonPress;
wire          w_dly2s;
wire		  w_ich_wait_128s;
wire          w_ich_link_delay1;
//wire          w_ich_link_delay2;

wire		  w_on_wait_10s;
reg		      r_on_wait_10s;
wire          p_on_wait_10s;

`ifdef DCOK_DELAY
wire          w_dly2000ms;
`else
`endif
////////////////////UID LED Control////////////////////////
    always @(posedge i_clk_32k or negedge i_rst_n)
        if (!i_rst_n)
            begin
				//cs_UID_led   <= 1'b0;//active high Jun Zhong
				//cs_UID_led   <= 1'b1;//active LOW
				//r_UID_LED    <= 1'b0;
                //r1_UID_BUT_n <= 1'b1;
                //r2_UID_BUT_n <= 1'b1;
					 r_on_wait_10s <= 1'b0;			 
            end
        else
            begin
			//	cs_UID_led <= ns_UID_led;
              //  r1_UID_BUT_n <= i_UID_BUT_n;
                //r2_UID_BUT_n <= r1_UID_BUT_n;	
					 r_on_wait_10s <= w_on_wait_10s;
            end
   /* always @ *
        begin
			ns_UID_led = cs_UID_led;
			if (r1_UID_BUT_n && (!r2_UID_BUT_n))
			   begin	
			       if (!cs_UID_led)
				      ns_UID_led = 1'b1;//active hight for Jun Zhong
					  //ns_UID_led = 1'b0;//active low
				   else	  
                      ns_UID_led = 1'b0;//active hight for Jun Zhong
                      //ns_UID_led = 1'b1;//active low					  
			   end		  
        end			
		*/
////////////////////UID LED END////////////////
    always @(posedge i_clk_32k or negedge i_rst_n)
        if (!i_rst_n)
            begin
                r1_DCOKSby        <= 1'b0;
                r2_DCOKSby        <= 1'b0;
                r1_All_PWRGD      <= 1'b0;
                r2_All_PWRGD      <= 1'b0;
                r1_ATX_PWRGD      <= 1'b0;
                r2_ATX_PWRGD      <= 1'b0;
				r1_VTT_PWRGD      <= 1'b0;
                r2_VTT_PWRGD      <= 1'b0;
                r1_SoftRst        <= 1'b0;
                r2_SoftRst        <= 1'b0;
                r1_MT_RST         <= 1'b0; 
                r2_MT_RST         <= 1'b0; 
                r1_PowerOn        <= 1'b0; 
                r2_PowerOn        <= 1'b0; 
                r1_PowerOff       <= 1'b0; 
                r2_PowerOff       <= 1'b0; 
                r1_btn_PSON       <= 1'b0; 
                r2_btn_PSON       <= 1'b0; 
                r1_btn_rst        <= 1'b0; 
                r2_btn_rst        <= 1'b0;				
                `ifdef CONFIG_FOR_SIM
                cs_ctrl_state     <= ns_ctrl_state;	
                `else
                cs_ctrl_state     <= Sby; 	
                `endif
                cs_1V2Enable      <= 1'b0;
				r1_IO_PWRGD       <= 1'b0;
				r2_IO_PWRGD       <= 1'b0;
				r1_DLI_VDD18_PG   <= 1'b0;
				r2_DLI_VDD18_PG   <= 1'b0;
				r1_CORE08_PG	  <= 1'b0;
				r2_CORE08_PG	  <= 1'b0;
				r1_TS_VS_ALARM_L  <= 1'b0;
				r2_TS_VS_ALARM_L  <= 1'b0;
				r1_vga_cnt_en	  <= 1'b0;
				r2_vga_cnt_en	  <= 1'b0;
				r1_vga_soft_rst_en <= 1'b0;
				r2_vga_soft_rst_en <= 1'b0;
				r3_vga_soft_rst_en <= 1'b0;
				r4_vga_soft_rst_en <= 1'b0;				
				r5_vga_soft_rst_en <= 1'b0;
				r6_vga_soft_rst_en <= 1'b0;				
				cs_CORE08Enable   <= 1'b0;
                cs_PCIEReset0_n   <= 1'b0;
                cs_PCIEReset1_n   <= 1'b0;				
                cs_CPU_DCOK       <= 1'b0;
                cs_CPUReset_n     <= 1'b0;
		        cs_PSON           <= 1'b0;
                cs_GreenLED       <= 1'b0;
                cs_YellowLED      <= 1'b0;
				cs_9230_PRST_n    <= 1'b0;
				cs_clear_timeout  <= 1'b0;
				cs_DLI_VDD18_EN   <= 1'b0;
				cs_VDD18_EN       <= 1'b0;
				cs_vga_rst_cnt    <= 5'b0;
            end 
        else 
            begin
				cs_vga_rst_cnt    <= ns_vga_rst_cnt;
				cs_PSON           <= ns_PSON;
                cs_PCIEReset0_n   <= ns_PCIEReset0_n;
				cs_PCIEReset1_n   <= ns_PCIEReset1_n;
				cs_9230_PRST_n    <= ns_9230_PRST_n;
                cs_CPU_DCOK       <= ns_CPU_DCOK;
                cs_CPUReset_n     <= ns_CPUReset_n;
                cs_1V2Enable     <= ns_1V2Enable;
				cs_CORE08Enable    <= ns_CORE08Enable;
				cs_GreenLED       <= ns_GreenLED;
				cs_YellowLED      <= ns_YellowLED;
                cs_ctrl_state     <= ns_ctrl_state;	
				cs_clear_timeout  <= ns_clear_timeout;
                r1_DCOKSby        <= i_DCOKSby;
                r2_DCOKSby        <= r1_DCOKSby;
                r1_All_PWRGD      <= i_All_PWRGD;
                r2_All_PWRGD      <= r1_All_PWRGD;
                r1_VTT_PWRGD      <=  i_VTT_PWRGD;
                r2_VTT_PWRGD      <= r1_VTT_PWRGD;
                r1_ATX_PWRGD      <=  i_ATX_PWRGD;
                r2_ATX_PWRGD      <= r1_ATX_PWRGD;
                r1_btn_PSON       <= i_btn_PSON;
                r2_btn_PSON       <= r1_btn_PSON;
                r1_btn_rst        <= i_btn_rst ;
                r2_btn_rst        <= r1_btn_rst ;
                r1_SoftRst        <= i_SoftRst;
                r2_SoftRst        <= r1_SoftRst;
                r1_MT_RST         <= i_MT_RST;
                r2_MT_RST         <= r1_MT_RST;
                r1_PowerOn        <= i_PowerOn;
                r2_PowerOn        <= r1_PowerOn;
                r1_PowerOff       <= i_PowerOff;
                r2_PowerOff       <= r1_PowerOff;
				r1_IO_PWRGD       <= i_IO_PWRGD;
				r2_IO_PWRGD       <= r1_IO_PWRGD;
				r1_DLI_VDD18_PG   <= i_DLI_VDD18_PG;
				r2_DLI_VDD18_PG   <= r1_DLI_VDD18_PG;
				cs_DLI_VDD18_EN   <= ns_DLI_VDD18_EN;
				cs_VDD18_EN       <= ns_VDD18_EN;
				r1_CORE08_PG	   <= i_CORE08_PG	;
				r2_CORE08_PG	   <= r1_CORE08_PG	;
				r1_TS_VS_ALARM_L   <= i_TS_VS_ALARM_L ;
				r2_TS_VS_ALARM_L   <= r1_TS_VS_ALARM_L ;
				r1_vga_cnt_en	  <= i_vga_cnt_en;
				r2_vga_cnt_en	  <= r1_vga_cnt_en;
				r1_vga_soft_rst_en <= i_vga_soft_rst_en;
				r2_vga_soft_rst_en <= r1_vga_soft_rst_en;
				r3_vga_soft_rst_en <= r2_vga_soft_rst_en;
				r4_vga_soft_rst_en <= r3_vga_soft_rst_en;
				r5_vga_soft_rst_en <= r4_vga_soft_rst_en;
				r6_vga_soft_rst_en <= r5_vga_soft_rst_en;				
        end

	
    always @ *
        begin
			ns_vga_rst_cnt    = cs_vga_rst_cnt;
			ns_9230_PRST_n    = cs_9230_PRST_n;
            ns_PCIEReset0_n   = cs_PCIEReset0_n;
			ns_PCIEReset1_n   = cs_PCIEReset1_n;
            ns_CPU_DCOK       = cs_CPU_DCOK;
            ns_CPUReset_n     = cs_CPUReset_n;
            ns_1V2Enable      = cs_1V2Enable;
            ns_YellowLED      = cs_YellowLED;
            ns_GreenLED       = cs_GreenLED ;
            ns_ctrl_state     = cs_ctrl_state;		
			ns_PSON           = cs_PSON;
			ns_CORE08Enable    = cs_CORE08Enable;
			ns_clear_timeout  = cs_clear_timeout;
			ns_DLI_VDD18_EN   = cs_DLI_VDD18_EN;
			ns_VDD18_EN       = cs_VDD18_EN;

	    case(cs_ctrl_state)
        /*Start://0000
            begin
               ns_ctrl_state = Sby;
            end*/
	    Sby://0001    等待r2_DCOKSby信号延时完成
	        begin
                    //rst all regs
                    ns_PCIEReset0_n   = 1'b0;
					ns_PCIEReset1_n   = 1'b0;
					ns_9230_PRST_n    = 1'b0;
                    ns_CPU_DCOK       = 1'b0;
                    ns_CPUReset_n     = 1'b0;
                    ns_1V2Enable      = 1'b0;
					ns_CORE08Enable   = 1'b0;
					ns_DLI_VDD18_EN   = 1'b0;
					ns_VDD18_EN       = 1'b0;
                    ns_YellowLED      = 1'b0;
                    ns_GreenLED       = 1'b0;
                    ns_PSON           = 1'b0;
					ns_clear_timeout  = 1'b0;
					
                    if (r2_DCOKSby)
                    begin
                        ns_ctrl_state = SbyEnd;
                    end
                    else
                    begin
                        ns_ctrl_state = Sby;
                    end 
	        end
	    SbyEnd://0010  开机等待状态，按下开机键大于1/8S，触发开机
	        begin

                    ns_PSON = 1'b0;
                    ns_PCIEReset0_n   = 1'b0;
					ns_PCIEReset1_n   = 1'b0;
					ns_9230_PRST_n    = 1'b0;
                    ns_CPU_DCOK       = 1'b0;
                    ns_CPUReset_n     = 1'b0;
                    ns_1V2Enable      = 1'b0;  
                    ns_PSON           = 1'b0;
                    ns_YellowLED      = 1'b0;
                    ns_GreenLED       = 1'b1;
					ns_CORE08Enable  = 1'b0;
					ns_DLI_VDD18_EN  = 1'b0;
					ns_VDD18_EN      = 1'b0;
					ns_clear_timeout = 1'b0;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOn&(!w_PowerOff))//w_PSON=BTN_PSON_en
                         begin
                            ns_ctrl_state = PSOn;
                         end
                     else
                         begin
                            ns_ctrl_state = SbyEnd;
                         end
			end
	        
            PSOn://0011      输出PSON和ns_VDD18_EN信号高电平，打开电源，同时检查上个状态信号
                begin
                    ns_PSON = 1'b1;
					ns_1V2Enable   = 1'b0;
					ns_CORE08Enable  = 1'b0;
					ns_clear_timeout = 1'b0;
					ns_DLI_VDD18_EN  = 1'b0;
					ns_VDD18_EN      = 1'b1;	
					
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (w_dly32ms)
                    begin
                        ns_ctrl_state = PSOn2;
						//ns_ctrl_state = PSOn;
                    end
                    else
                    begin
                        ns_ctrl_state = PSOn;
                    end
                end
			PSOn2://0100     等待电源上电完成 并检测r2_ATX_PWRGD正常
			    begin
                    ns_PSON = 1'b1;
					ns_1V2Enable   = 1'b0;
					ns_CORE08Enable  = 1'b0;
					ns_clear_timeout = 1'b0;
					ns_DLI_VDD18_EN  = 1'b0;
					ns_VDD18_EN      = 1'b1;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (r2_ATX_PWRGD)
                    begin
                        ns_ctrl_state = ATXPowerGood;
                    end
                    else
                    begin
                        ns_ctrl_state = PSOn2;
                    end
                end
			ATXPowerGood:	//0101   检测之前电源上电是否正常，同时检测之前状态是否正常
                begin
                    ns_YellowLED    = 1'b1;
                    ns_PSON         = 1'b1;
                    ns_GreenLED     = 1'b0;
                    ns_1V2Enable    = 1'b0;
					ns_CORE08Enable  = 1'b0;
					ns_VDD18_EN      = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_DLI_VDD18_EN  = 1'b0;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
					else if (r2_IO_PWRGD)
                    begin
                        ns_ctrl_state = WorkPowerGood;
						//ns_ctrl_state = ATXPowerGood;
                    end
                    else
                    begin
                        ns_ctrl_state = ATXPowerGood;
                    end
                end			
            WorkPowerGood://0110  使能ns_1V2Enable， 检测之前电源上电是否正常，同时检测之前状态是否正常
 				begin
                    ns_YellowLED    = 1'b1;
                    ns_PSON         = 1'b1;
                    ns_GreenLED     = 1'b0;
					ns_VDD18_EN      = 1'b1;
                    ns_1V2Enable    = 1'b1;
					ns_CORE08Enable  = 1'b0;
					ns_DLI_VDD18_EN  = 1'b0;
					ns_clear_timeout = 1'b0;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
					else if (r2_IO_PWRGD & r2_VTT_PWRGD)
                    begin
                        ns_ctrl_state = DLIPowerGood;
						//ns_ctrl_state = WorkPowerGood;
                    end
                    else
                    begin
                        ns_ctrl_state = WorkPowerGood;
                    end					
				end
		   DLIPowerGood://0111  使能ns_CORE08Enable， 检测之前电源上电是否正常，同时检测之前状态是否正常
				begin
                    ns_YellowLED    = 1'b1;
                    ns_PSON         = 1'b1;
                    ns_GreenLED     = 1'b0;
                    ns_1V2Enable    = 1'b1;
					ns_CORE08Enable  = 1'b1;
					ns_DLI_VDD18_EN  = 1'b0;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (r2_IO_PWRGD & r2_CORE08_PG & r2_VTT_PWRGD & w_dly2ms)
                    begin
                        ns_ctrl_state = VTTPowerGood;
						//ns_ctrl_state = DLIPowerGood;
						
                    end
                    else
                    begin
                        ns_ctrl_state = DLIPowerGood;
                    end
                end
		   VTTPowerGood://1000  使能ns_DLI_VDD18_EN， 检测所有电源上电是否正常，同时检测之前状态是否正常
                begin
                    ns_YellowLED    = 1'b1;
                    ns_PSON         = 1'b1;
                    ns_GreenLED     = 1'b0;
                    ns_1V2Enable    = 1'b1;
					ns_CORE08Enable  = 1'b1;
					ns_DLI_VDD18_EN  = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (r2_All_PWRGD)
                    begin
                        ns_ctrl_state = AllPowerGood;
						//ns_ctrl_state = VTTPowerGood;
                    end
                    else
                    begin
                        ns_ctrl_state = VTTPowerGood;
                    end
                end
            AllPowerGood://1001   延时64ms，同时检测之前状态是否正常
                begin
                    ns_PCIEReset0_n = 1'b0;
                    ns_PCIEReset1_n = 1'b0;
					ns_9230_PRST_n  = 1'b0;	
		            ns_CPU_DCOK     = 1'b0;
		            ns_CPUReset_n   = 1'b0;
		            ns_1V2Enable    = 1'b1;
		            ns_PSON         = 1'b1;
					ns_DLI_VDD18_EN  = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (!r2_All_PWRGD)
                    begin
                        ns_ctrl_state = WorkPowerGood;
                    end
                    else if (w_dly64ms&(!w_SoftReset))					
                    begin
                        ns_ctrl_state = PCIEReset;
                    end
                    else
                    begin
                        ns_ctrl_state = AllPowerGood;
                    end
                end
			PCIEReset://1010  延时512ms，同时检测之前状态是否正常
               begin
                    ns_PCIEReset0_n = 1'b0;
                    ns_PCIEReset1_n = 1'b0;
					ns_9230_PRST_n  = 1'b0;	
		            ns_CPU_DCOK     = 1'b0;
		            ns_CPUReset_n   = 1'b0;
		            ns_1V2Enable    = 1'b1;
		            ns_PSON         = 1'b1;
					ns_DLI_VDD18_EN  = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (!r2_All_PWRGD)
                    begin
                        ns_ctrl_state = WorkPowerGood;  //to do
                    end
                    else if (w_dly512ms)
                        ns_ctrl_state = PCIEResetEnd;
                    else
                        ns_ctrl_state = PCIEReset;
				end
			PCIEResetEnd://1011  释放所有外设复位信号，同时检测之前状态是否正常
                begin
                    ns_PCIEReset0_n = 1'b1;
					ns_PCIEReset1_n = 1'b1;
					ns_9230_PRST_n = 1'b1;					
                    ns_CPU_DCOK = 1'b0;
                    ns_CPUReset_n = 1'b0;
		            ns_1V2Enable    = 1'b1;
		            ns_PSON         = 1'b1;
					ns_DLI_VDD18_EN  = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;

                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (!r2_All_PWRGD)
                    begin
                        ns_ctrl_state = WorkPowerGood;
                    end
                    else if (w_dly128ms)
                    begin
                        ns_ctrl_state = CPU_DCOk;
                    end
                    else
                    begin
                        ns_ctrl_state = PCIEResetEnd;
                    end
                end
	    CPU_DCOk://1100  释放ns_CPU_DCOK，同时检测之前状态是否正常
	        begin
                    ns_PCIEReset0_n = 1'b1;
					ns_PCIEReset1_n = 1'b1;
					ns_9230_PRST_n = 1'b1;					
                    ns_CPU_DCOK = 1'b1;
                    ns_CPUReset_n = 1'b0;
		            ns_1V2Enable    = 1'b1;
		            ns_PSON         = 1'b1;
					ns_DLI_VDD18_EN  = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;

                   if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (!r2_All_PWRGD)
                    begin
                        ns_ctrl_state = WorkPowerGood;
                    end else if (w_SoftReset) begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = AllPowerGood;
					end else if(w_dly256ms) begin
						ns_ctrl_state =And;
					end else begin
						ns_ctrl_state = CPU_DCOk;
					end		
						
	        end
           And://1101    释放ns_CPUReset_n，正常运行看门狗延时256s，同时检测之前状态是否正常
                begin
                    ns_CPUReset_n   = 1'b1;
                    ns_PCIEReset0_n = 1'b1;
					ns_PCIEReset1_n = 1'b1;
					ns_9230_PRST_n = 1'b1;					
                    ns_CPU_DCOK = 1'b1;
		            ns_1V2Enable    = 1'b1;
		            ns_PSON         = 1'b1;
					ns_DLI_VDD18_EN  = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;

                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff || !r2_TS_VS_ALARM_L)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end
                    else if (!r2_All_PWRGD)
                    begin
                        ns_ctrl_state = WorkPowerGood;
                    end
                    else if (r2_MT_RST)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = PCIEResetEnd;
                    end
                    else if (w_SoftReset)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = AllPowerGood;
                    end
					else if (w_ich_link_delay1) 
					begin
						ns_ctrl_state	= End;
				    end
                    else
                    begin
                        ns_ctrl_state = And;
                    end
                end  
		
					
		End://1110    看门狗信号检测，检测信号不正常就关机重启并计数，连续触发共32次；同时检测之前状态是否正常
                begin
                    ns_CPUReset_n   = 1'b1;
                    ns_PCIEReset0_n = 1'b1;
					ns_PCIEReset1_n = 1'b1;
					ns_9230_PRST_n = 1'b1;					
                    ns_CPU_DCOK = 1'b1;
		            ns_1V2Enable    = 1'b1;
		            ns_PSON         = 1'b1;
					ns_DLI_VDD18_EN  = 1'b1;
					ns_clear_timeout = 1'b0;
					ns_VDD18_EN      = 1'b1;
                    if (!r2_DCOKSby)
                    begin
                        ns_ctrl_state = Sby;
                    end
                    else if (w_PowerOff)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = SbyEnd;
                    end				
                    else if (!r2_All_PWRGD)
                    begin
                        ns_ctrl_state = WorkPowerGood;
                    end
                    else if (r2_MT_RST)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = PCIEResetEnd;
                    end
                    else if (w_SoftReset)
                    begin
						ns_clear_timeout = 1'b1;
                        ns_ctrl_state = AllPowerGood;
                    end		
					else if (r6_vga_soft_rst_en && cs_vga_rst_cnt != 31 )
                    begin
                        ns_vga_rst_cnt = cs_vga_rst_cnt + 1;
								ns_ctrl_state = SbyEnd;		
						end 						
					else if (r6_vga_soft_rst_en)
                    begin
                        ns_vga_rst_cnt = 5'b0 ;	
                        ns_ctrl_state = End;								
						end 				
                    else
                    begin
                        ns_ctrl_state = End;
                    end
                end
			 
	     default:
	         begin
	             ns_ctrl_state = Sby;
	         end
	     endcase
	end


DELAY u_dly_64ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     (cs_ctrl_state == AllPowerGood),
  .i_cnt_en    (cs_ctrl_state == AllPowerGood),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h2),//time scale is 2ms；  由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'h40),//time scale is 64ms
  `endif
  .o_delay_time(w_dly64ms)
);

DELAY u_dly_32ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     (cs_ctrl_state == PSOn),
  .i_cnt_en    (cs_ctrl_state == PSOn),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h2),//time scale is 2ms, 由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'h20),//time scale is 64ms
  `endif
  .o_delay_time(w_dly32ms)
);

DELAY u_dly_512ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     (cs_ctrl_state == PCIEReset),
  .i_cnt_en    (cs_ctrl_state == PCIEReset),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h2),//time scale is 2ms, 由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'h200),//time scale is ms
  `endif
  .o_delay_time(w_dly512ms)
);

DELAY u_dly_256ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     (cs_ctrl_state == CPU_DCOk),
  .i_cnt_en    (cs_ctrl_state == CPU_DCOk),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h2),//time scale is 2ms, 由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'h100),//time scale is ms
  `endif
  .o_delay_time(w_dly256ms)
);

DELAY u_dly_2ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     (cs_ctrl_state == DLIPowerGood),
  .i_cnt_en    (cs_ctrl_state == DLIPowerGood),
  .i_dly_en    (1'b1),
  .i_data      (12'h2),//time scale is ms ； 由于delay里也有仿真语句设置，实际结果零延时；
  .o_delay_time(w_dly2ms)
);
DELAY u_dly_128ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     (cs_ctrl_state == PCIEResetEnd),
  .i_cnt_en    (cs_ctrl_state == PCIEResetEnd),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h2),//time scale is ms,modify 2ms 由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'h80),//time scale is ms,modify 128ms for test 20170303
  `endif
  .o_delay_time(w_dly128ms)
);
/*
DELAY u_dly_128ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     (cs_ctrl_state == PCIEResetEnd),
  .i_cnt_en    (cs_ctrl_state == PCIEResetEnd),
  .i_dly_en    (1'b1),
  `ifdef CPU_RST_L
  .i_data      (12'h800),//time scale is ms,modify 2000ms for test 20170303
  `else
  .i_data      (12'h80),//time scale is ms,modify 128ms for test 20170303
  `endif
  .o_delay_time(w_dly128ms)
);

`ifdef DCOK_DELAY
DELAY u_dly_2000ms(
  .i_clk_32k   (i_clk_32k),
  .i_rst_n     ((cs_ctrl_state == ICH_DCOk)&(i_ICHPowerGood)),
  .i_cnt_en    ((cs_ctrl_state == ICH_DCOk)&(i_ICHPowerGood)),
  .i_dly_en    (1'b1),
  .i_data      (12'h800),//time scale is ms,modify 2000ms for test 20170419
  .o_delay_time(w_dly2000ms)
);
`else
`endif
*/



assign p_on_wait_10s = w_on_wait_10s && (!r_on_wait_10s) && (cs_vga_rst_cnt != 0 ) ;

DELAY_X32 u_wait_10s(
  .i_clk_1k   (i_clk_1k),
  .i_rst_n     (cs_ctrl_state == SbyEnd),
  .i_cnt_en    (cs_ctrl_state == SbyEnd),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h1),//time scale is 32ms,  由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'h140),//time scale is 32ms
  `endif
  .o_delay_time(w_on_wait_10s)
);

DELAY_X32 u_wait_128s(
  .i_clk_1k   (i_clk_1k),
  .i_rst_n     (cs_ctrl_state == And),
  .i_cnt_en    (cs_ctrl_state == And),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h1),//time scale is 32ms, 由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'hFA0),//time scale is ms
  `endif
  .o_delay_time(w_ich_wait_128s)
);

DELAY_X32 u_delay_256s(
  .i_clk_1k   (i_clk_1k),
  .i_rst_n     (w_ich_wait_128s),
  .i_cnt_en    (w_ich_wait_128s),
  .i_dly_en    (1'b1),
  `ifdef CONFIG_FOR_SIM
  .i_data      (12'h1),//time scale is 32ms, 由于delay里也有仿真语句设置，实际结果零延时；
  `else
  .i_data      (12'hFA0),//time scale is ms
  `endif
  .o_delay_time(w_ich_link_delay1)
);
/*
DELAY_X32 u_delay_304s(
  .i_clk_1k   (i_clk_1k),
  .i_rst_n     (w_ich_link_delay1),
  .i_cnt_en    (w_ich_link_delay1),
  .i_dly_en    (1'b1),
  .i_data      (12'h600),//time scale is ms
  .o_delay_time(w_ich_link_delay2));
*/


assign o_ctrl_state     = cs_ctrl_state     ;		
assign o_1V2Enable      = cs_1V2Enable   ;
assign o_CORE08Enable   = cs_CORE08Enable    ;
assign o_VDD18_EN       = cs_VDD18_EN   ;
assign o_DLI_VDD18_EN   = cs_DLI_VDD18_EN  ;
assign o_PCIEReset0     = cs_PCIEReset0_n   ;
assign o_PCIEReset1     = cs_PCIEReset1_n   ;
assign o_CPU_DCOK       = cs_CPU_DCOK       ;
assign o_CPUReset_n     = cs_CPUReset_n     ;
assign o_PSON           = cs_PSON           ;
assign o_GreenLED       = cs_GreenLED       ;
assign o_YellowLED      = cs_YellowLED      ;
assign w_PowerOn        = (r1_btn_PSON & (!r2_btn_PSON)) || (r1_PowerOn & (!r2_PowerOn)) || p_on_wait_10s;
assign o_9230_PRST_n    = cs_9230_PRST_n    ;
assign w_PowerOff       =  r2_PowerOff;
assign w_SoftReset      = r2_btn_rst || r2_SoftRst;
//assign o_UID_LED        = cs_UID_led;
assign o_Clear_TimeOut  = cs_clear_timeout;
//assign o_UID_BUT_n      = r2_UID_BUT_n;
///test
//assign o_dly64ms        = w_dly64ms;
//assign o_SoftReset      = w_SoftReset;

endmodule
