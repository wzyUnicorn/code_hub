///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <cpld_6a.v>
// File history:
//
// Description: 
// the top of all module
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
//`define CONFIG_FOR_SIM
module CPLD_6B(
        `ifdef CONFIG_FOR_SIM
        input         w_InitialSoc,
        `else
        `endif
        //power
	input         i_DCOKSby, 
	input         i_RST_BUTTON_n, 
	input         i_PowerButton_n,
	input         i_ATX_PG,
	output        o_VDD18_EN,
	output        o_S0_1V2Enable,
	output        o_S1_1V2Enable,
	input         i_WorkPowerGood1,
	input         i_WorkPowerGood2,
	input         i_S0_VTT_PWRGD,
	input         i_S1_VTT_PWRGD,
	output        o_S0_CORE08_EN,
	output        o_S1_CORE08_EN,
	input         i_S0_CORE08_PG,
	input         i_S1_CORE08_PG,
	output        o_S0_DLI_VDD18_EN,
	output        o_S1_DLI_VDD18_EN,
	input         i_S0_DLI_VDD18_PG,
	input         i_S1_DLI_VDD18_PG,
	output        o_PSOn,
//	input         i_8619_PG,
	//reset
	output        o_PCIEReset0_n,
	output        o_PCIEReset1_n,
	output        o_9230_PRST_n,
	output        o_HUB_RST_n,
	output        o_S0_CPU_DCOK,
	output        o_S0_CPUReset_n,	
	output        o_S1_CPU_DCOK,
	output        o_S1_CPUReset_n,
		
	//Buzzer	
//	input         i_Buzzer,
	output        o_Buzzer,
	//ipmi
	input         i_AST_PWROn_n,
	input         i_AST_PWROff_n,
	input         i_AST_Reset_n,
	input         i_AST_act_n,
	output        o_CPLD_INT,
	output        o_ipmi_perst_n,
	//output		  o_POWER_ON_INT_uid_sw,
	//input		  i_Buzzer_uid_led,
	//UID
	//input         i_UID_BUT_n,	
	//output        o_UID_LED,
	//i2c	
	input         i_scl,
	inout         io_sda,
	
//	output        o_sda_en,
	output        o_YellowLED,
	//output        o_GreenLED,
 
	//lpc (not used)   
	input         i_LPCClk,
	input         i_LPCRst_n,
	input         i_Frame,
	inout [3:0]   io_LAD,
	
	//wen du he dian ya bao jing
	input 		  i_S0_VS_ALARM_L,
	input         i_S0_TS_ALARM_L,
	input 		  i_S1_VS_ALARM_L,
	input         i_S1_TS_ALARM_L
);

/////////////////regs//////////////////

////////////////wire///////////////////
`ifdef CONFIG_FOR_SIM
`else
wire        w_InitialSoc;
`endif
wire        w_SbyReset_n;
wire        w_clk_1k;
wire        w_clk_8k;
wire        w_clk_32k;
wire        w_RST_BUTTON_n;
//wire        w_ipmi_rst_btn;
wire        w_AST_act_n;
wire        w_AST_Reset_n;
wire        w_AST_PWROff_n;
wire        w_AST_PWROn_n;
//wire        w_Buzzer;
wire        w_ATX_PG;
//wire        w_8619_PG;

wire        w_WorkPowerGood1;
wire        w_WorkPowerGood2;
wire        w_S0_VTT_PWRGD;
wire        w_S1_VTT_PWRGD;
wire        w_S0_CORE08_PG;
wire        w_S1_CORE08_PG;
wire        w_S0_DLI_VDD18_PG;
wire        w_S1_DLI_VDD18_PG;

wire        w_PowerButton_n;
wire        w_pwr_btn_en;
wire        w_Pressed4Second;
wire        w_pwr_btn_press;
wire        w_rst_btn_press;
//wire        w_ipmi_btn_press;
wire        w_reg_pwr_off;
wire        w_btn_PSON;
wire [2:0]  w_PowerState;
wire        w_MT_Reset_n;
wire [4:0]  w_divide;
wire        w_BeepEnable;

wire [3:0]  w_lad_i;
wire [3:0]  w_lad_o;
wire [0:0]  w_lad_oe;
wire [7:0]  w_lpc_rdata;
wire [7:0]  w_lpc_addr;
wire [7:0]  w_lpc_wdata;
wire        w_lpc_write;
wire        w_lpc_read;
wire        w_lpc_en;
wire [4:0]  w_lpc_divide;
wire        w_lpc_beep_en;
wire        w_lpc_PowerOff;
wire        w_lpc_MT_RST;
wire        w_lpc_SoftReset;

wire [7:0]  w_iic_rdata;
wire [7:0]  w_iic_addr;
wire [7:0]  w_iic_wdata;
wire        w_iic_write;
wire        w_iic_read;
wire        w_iic_en;
wire [4:0]  w_iic_divide;
wire        w_iic_beep_en;
wire        w_iic_PowerOff;
wire        w_iic_PowerOn;
wire        w_iic_MT_RST;
wire        w_iic_SoftReset;

wire [3:0]  w_ctrl_state;
//wire        w_dly1ms;
//wire        w_dly1000ms;
wire        w_SoftRst;
wire        w_AST_PSON;
//wire        w_CPLD_INT;
wire        w_AST_PWROff;
wire        w_AST_Reset;
wire        w_btn_pwr_off_en;
//wire        w_VCC09Enable;
//wire        w_UID_BUT_n;
//wire		w_UID_BUT_n_n;
//wire        w_UID_LED;
wire        w_9230_PRST_n;
wire		w_clear_timeout;

wire		w_ATX_PG2;
wire		w_IO_PG;
wire		w_CORE08_PG;
wire		w_VTT_PWRGD;
wire		w_DLI_VDD18_PG;
wire		w_1V2Enable;
wire        w_VDD18_EN;
wire        w_CPU_DCOK;
wire        w_CORE08Enable;
wire        w_CPUReset_n;
//wire		w_Buzzer_uid_led;

wire        w_S0_VS_ALARM_L;
wire		w_S0_TS_ALARM_L;
wire		w_S1_VS_ALARM_L;
wire		w_S1_TS_ALARM_L;
wire		w_TS_VS_ALARM_L;

wire		w_vga_btn_cnt_en;
wire		w_vga_soft_rst_en;
wire		w_lpc_softrst;

    `ifdef CONFIG_FOR_SIM
    `else
    defparam OSCH_inst.NOM_FREQ = "2.08";// This is the default frequency:2MHz
    //defparam OSCH_inst.NOM_FREQ = "20.46";//20M clk
    OSCH OSCH_inst( 
    	 .STDBY		(1'b0), 	// 0=Enabled, 1=Disabled also Disabled with Bandgap=OFF
    	 .OSC		(w_InitialSoc),
    	 .SEDSTDBY	()		// this signal is not required if not using SED
    );
    `endif
 SBY_RST u_sby_rst(
       .i_InitialSoc(w_InitialSoc),
       .i_DCOKSby   (i_DCOKSby),
       .o_SbyReset_n(w_SbyReset_n)
 );	

 CLOCK u_clock(
       .i_InitialSoc(w_InitialSoc),
       .i_rst_n     (w_SbyReset_n),
       .o_clk_1k   (w_clk_1k),	   
       .o_clk_8k   (w_clk_8k),	   	   
       .o_clk_32k   (w_clk_32k)
 );

 ASYNC u_async(
       .i_clk_32k        (w_clk_32k),
       .i_rst_n          (w_SbyReset_n),
       .i_RST_BUTTON_n   (i_RST_BUTTON_n),
       .i_PowerButton_n  (i_PowerButton_n),
       .i_WorkPowerGood1 (i_WorkPowerGood1),
       .i_WorkPowerGood2 (i_WorkPowerGood2),
       .i_S0_VTT_PWRGD   (i_S0_VTT_PWRGD),
       .i_S1_VTT_PWRGD   (i_S1_VTT_PWRGD),
	   .i_S0_CORE08_PG   (i_S0_CORE08_PG),
	   .i_S1_CORE08_PG   (i_S1_CORE08_PG),
	   .i_S0_DLI_VDD18_PG(i_S0_DLI_VDD18_PG),
	   .i_S1_DLI_VDD18_PG(i_S1_DLI_VDD18_PG),
//`	   .i_8619_PG        (i_8619_PG),
       .i_ATX_PG         (i_ATX_PG),
       //.i_Buzzer         (i_Buzzer),
	   //.i_Buzzer         (1'b0),
       .i_AST_PWROn_n    (i_AST_PWROn_n),
       .i_AST_PWROff_n   (i_AST_PWROff_n),
       .i_AST_Reset_n    (i_AST_Reset_n),
       .i_AST_act_n      (i_AST_act_n),
//	   .i_UID_BUT_n      (i_UID_BUT_n),
//	   .i_Buzzer_uid_led  (i_Buzzer_uid_led),
	   .i_S0_VS_ALARM_L  (i_S0_VS_ALARM_L),
	   .i_S0_TS_ALARM_L  (i_S0_TS_ALARM_L),
	   .i_S1_VS_ALARM_L  (i_S1_VS_ALARM_L),
	   .i_S1_TS_ALARM_L  (i_S1_TS_ALARM_L),
//       .o_UID_BUT_n      (w_UID_BUT_n),
       .o_RST_BUTTON_n   (w_RST_BUTTON_n),
       .o_PowerButton_n  (w_PowerButton_n),
       .o_WorkPowerGood1 (w_WorkPowerGood1),
       .o_WorkPowerGood2 (w_WorkPowerGood2),
	   .o_S0_VTT_PWRGD   (w_S0_VTT_PWRGD),
	   .o_S1_VTT_PWRGD   (w_S1_VTT_PWRGD),
       .o_S0_CORE08_PG   (w_S0_CORE08_PG),
	   .o_S1_CORE08_PG   (w_S1_CORE08_PG),
       .o_S0_DLI_VDD18_PG(w_S0_DLI_VDD18_PG),
       .o_S1_DLI_VDD18_PG(w_S1_DLI_VDD18_PG),
//	   .o_8619_PG        (w_8619_PG),
       .o_ATX_PG         (w_ATX_PG),
       //.o_Buzzer         (w_Buzzer),
       .o_AST_PWROn_n    (w_AST_PWROn_n),
       .o_AST_PWROff_n   (w_AST_PWROff_n),
       .o_AST_Reset_n    (w_AST_Reset_n),
       .o_AST_act_n      (w_AST_act_n),
//	   .o_ipmi_rst_btn   (w_ipmi_rst_btn),
//	   .o_Buzzer_uid_led (w_Buzzer_uid_led),
	   .o_S0_VS_ALARM_L  (w_S0_VS_ALARM_L),
	   .o_S0_TS_ALARM_L  (w_S0_TS_ALARM_L),
	   .o_S1_VS_ALARM_L  (w_S1_VS_ALARM_L),
	   .o_S1_TS_ALARM_L  (w_S1_TS_ALARM_L)
	   
);

 PWR_BTN u_pwr_btn(
       .i_clk_32k       (w_clk_32k),
       .i_rst_n         (w_SbyReset_n),
       .i_pwr_btn       (w_PowerButton_n),
       .o_pwr_btn_en    (w_pwr_btn_en),
       .o_Pressed4Second(w_Pressed4Second),
       .o_pwr_btn_press (w_pwr_btn_press)
 );

 RST_BTN u_rst_btn(
       .i_clk_32k      (w_clk_32k),
       .i_rst_n        (w_SbyReset_n),
       .i_rst_btn      (w_RST_BUTTON_n),
       .o_rst_btn_press(w_rst_btn_press)
);

/*IPMI_BTN u_ipmi_btn(
       .i_clk_32k       (w_clk_32k),
       .i_rst_n         (w_SbyReset_n),
       .i_ipmi_btn      (w_ipmi_rst_btn),
       .o_ipmi_btn_press(w_ipmi_btn_press)
);*/

VGA_BTN_CNT u_vga_btn_cnt(
       .i_clk_32k      (w_clk_32k),
       .i_rst_n        (w_SbyReset_n & w_RST_BUTTON_n),	   
       .i_vga_btn_cnt      (w_RST_BUTTON_n),
       .o_vga_btn_cnt_en	(w_vga_btn_cnt_en)
);

 POWER_STATE u_power_state(
       .i_clk_32k       (w_clk_32k),
       .i_rst_n         (w_SbyReset_n),
       .i_pwr_btn_en    (w_pwr_btn_en),
       .i_btn_press4s   (w_Pressed4Second),
       .i_ButtonPressed (w_pwr_btn_press),
       .i_reg_pwr_off   (w_reg_pwr_off),
       .o_ctrl_PSON     (w_btn_PSON),
       .o_btn_pwr_off_en(w_btn_pwr_off_en),
       .o_PowerState    (w_PowerState)
);

 MT_RST u_mt_rst(
       .i_clk_32k   (w_clk_32k),
       .i_rst_n     (w_SbyReset_n),//all area rst
       .i_ctrl_state(w_ctrl_state),
       .i_UI_rst_n  (1'b1),//Uper interface rst
       .i_reg_mt_rst(w_iic_MT_RST | w_lpc_MT_RST),
       .o_MT_Reset_n(w_MT_Reset_n)
);

 TELE_CTRL u_tele_ctrl(
       .i_clk_32k     (w_clk_32k),
       .i_rst_n       (w_SbyReset_n),
       .i_AST_PWROn_n (w_AST_PWROn_n),
       .i_AST_PWROff_n(w_AST_PWROff_n),
       .i_AST_Reset_n (w_AST_Reset_n),
       .i_AST_act_n   (w_AST_act_n),
	   //.i_AST_PWROn_n (1'b1),
       //.i_AST_PWROff_n(1'b1),
       //.i_AST_Reset_n (1'b1),
       //.i_AST_act_n   (1'b1),
       // .o_CPLD_INT    (w_CPLD_INT),
       .o_AST_PSON    (w_AST_PSON),
       .o_AST_PWROff  (w_AST_PWROff),
       .o_AST_Reset   (w_AST_Reset)
);

BEEP u_beep(
       .i_clk_32k   (w_clk_32k),
       .i_Rst_n     (w_SbyReset_n ),
       //.i_Intrude_n (1'b1),
       //.i_Buzzer    (w_Buzzer),
	   //.i_Buzzer    (1'b0),
       .i_BeepEnable(w_BeepEnable),
	  // .i_BeepEnable(w_vga_soft_rst_en),
       .i_divide    (w_divide),
       .o_Buzzer    (o_Buzzer)
);

LPC_SLAVE u_lpc_slave(
       .i_LPCClk   (i_LPCClk),
       .i_rst_n    (i_LPCRst_n & w_RST_BUTTON_n & w_SbyReset_n),
       .i_lpc_rdata(w_lpc_rdata),
       .o_lpc_addr (w_lpc_addr),
       .o_lpc_wdata(w_lpc_wdata),
       .o_lpc_write(w_lpc_write),
       .o_lpc_read (w_lpc_read),//maybe delay one cycle
       .o_lpc_en   (w_lpc_en),
       .i_Frame    (i_Frame),
       .i_LAD      (w_lad_i),
       .o_LAD      (w_lad_o),
       .o_LAD_OE   (w_lad_oe)
);

LPC_REG u_lpc_reg(
       .i_lpc_clk  (i_LPCClk),
	   .i_clk_32k     (w_clk_32k),
       .i_rst_n       (w_SbyReset_n),
       .i_lpc_rst  (!(i_LPCRst_n & w_RST_BUTTON_n & w_SbyReset_n)),
	   .i_dog_rst  (w_SoftRst),
       .i_ctrl_state(w_ctrl_state),
       .i_lpc_ce   (w_lpc_en),
       .i_lpc_we   (w_lpc_write),
       .i_lpc_oe   (w_lpc_read),
       .i_lpc_addr (w_lpc_addr[3:2]),
       .i_lpc_data (w_lpc_wdata),
       .o_lpc_data (w_lpc_rdata),
       .o_divide   (w_lpc_divide),
       .o_beep_en  (w_lpc_beep_en),
       .o_PowerOff (w_lpc_PowerOff),
       .o_MT_RST   (w_lpc_MT_RST),
       .o_SoftReset(w_lpc_SoftReset),
	   //.o_vga_SoftReset()
	   .o_vga_SoftReset(w_vga_soft_rst_en)
);

IIC_SLAVER u_iic_slaver(
       .clk         (w_InitialSoc),
       .rst         (!w_SbyReset_n),
       .sda         (i_sda),
       .scl         (i_scl),
       .i2c_sda_oe_o(i2c_sda_oe_o),

       .iic_en      (w_iic_en),
       .readEn      (w_iic_read),
       .dataIn      (w_iic_rdata),
       .dataOut     (w_iic_wdata),
       .writeEn     (w_iic_write),
       .regAddr     (w_iic_addr)
);

IIC_REG u_iic_reg(
       .i_iic_clk  (w_InitialSoc),
       .i_iic_rst  (!w_SbyReset_n),
       .i_iic_ce   (w_iic_en),
       .i_iic_we   (w_iic_write),
       .i_iic_oe   (w_iic_read),
       .i_iic_addr (w_iic_addr[3:2]),
       .i_iic_data (w_iic_wdata),
	   .i_fsm_state(w_ctrl_state),//zhy add iic check fsm state
       .o_iic_data (w_iic_rdata),
       .o_divide   (w_iic_divide),
       .o_beep_en  (w_iic_beep_en),
       .o_PowerOff (w_iic_PowerOff),
       .o_PowerOn  (w_iic_PowerOn),
       .o_MT_RST   (w_iic_MT_RST),
       .o_SoftReset(w_iic_SoftReset)
);

 FSM_CTRL u_fsm_ctrl(
       .i_clk_32k     (w_clk_32k),
       .i_clk_8k      (w_clk_8k),
       .i_clk_1k      (w_clk_1k),
       .i_rst_n       (w_SbyReset_n),
       .i_DCOKSby     (w_SbyReset_n),
       .i_btn_PSON    (w_btn_PSON),
       .i_btn_rst     (w_rst_btn_press),
       .i_All_PWRGD   (w_All_PWRGD),
       .i_ATX_PWRGD   (w_ATX_PG2),
       .i_IO_PWRGD    (w_IO_PG),
       .i_DLI_VDD18_PG(w_DLI_VDD18_PG),
	   .i_CORE08_PG	  (w_CORE08_PG),
       .i_VTT_PWRGD   (w_VTT_PWRGD),
       .i_PowerOn     (w_PowerOn),
       .i_PowerOff    (w_PowerOff),
       .i_MT_RST      (w_iic_MT_RST | w_lpc_MT_RST),//
       .i_SoftRst     (w_SoftRst),
//	   .i_UID_BUT_n   (w_UID_BUT_n),
	   .i_TS_VS_ALARM_L (w_TS_VS_ALARM_L),
	   .i_vga_cnt_en  (w_vga_btn_cnt_en),
	   .i_vga_soft_rst_en(w_vga_soft_rst_en),
	   //.o_UID_LED     (w_UID_LED),
	   .o_DLI_VDD18_EN(w_DLI_VDD18_EN),
	   .o_1V2Enable   (w_1V2Enable),
	   .o_CORE08Enable(w_CORE08Enable),
       .o_PCIEReset0  (w_PCIEReset0),
       .o_CPU_DCOK    (w_CPU_DCOK),
       .o_CPUReset_n  (w_CPUReset_n),
       .o_PSON        (w_PSON),
       .o_GreenLED    (w_GreenLED),
       .o_YellowLED   (w_YellowLED),
	   .o_9230_PRST_n (w_9230_PRST_n),
	   .o_Clear_TimeOut (w_clear_timeout),
	   .o_VDD18_EN    (w_VDD18_EN),
//	   .o_UID_BUT_n   (w_UID_BUT_n_n),
	   //test
	   //.o_dly64ms     (o_dly64ms),
       //.o_SoftReset   (o_SoftReset),
       .o_ctrl_state  (w_ctrl_state)
);                
/*DELAY u_dly_1ms(
       .i_clk_32k   (w_clk_32k),
       .i_rst_n     (w_SbyReset_n),
       .i_dly_en    (1'b1),
       .i_data      (12'h1),//time scale is ms
       .o_delay_time(w_dly1ms)
);

DELAY u_dly_1000ms(
       .i_clk_32k   (w_clk_32k),
       .i_rst_n     (w_SbyReset_n),
       .i_cnt_en    (w_PCIEReset0),
       .i_dly_en    (1'b1),
       .i_data      (12'h400),//time scale is ms,1000ms
       .o_delay_time(w_dly1000ms)
);*/

	assign  w_TS_VS_ALARM_L  = w_S0_VS_ALARM_L & w_S0_TS_ALARM_L & w_S1_VS_ALARM_L & w_S1_TS_ALARM_L;
 	//assign  w_ATX_PG2        = w_ATX_PG & w_WorkPowerGood1;
	assign  w_ATX_PG2        = w_WorkPowerGood1;
	assign  w_IO_PG          = w_ATX_PG2 & w_WorkPowerGood2;
	assign  w_CORE08_PG      = w_S0_CORE08_PG & w_S1_CORE08_PG;
	//assign  w_CORE08_PG      = w_S1_CORE08_PG;
	//assign  w_VTT_PWRGD      = w_S0_VTT_PWRGD & w_S1_VTT_PWRGD;
	assign  w_VTT_PWRGD      = w_S1_VTT_PWRGD;
	assign  w_DLI_VDD18_PG   = w_S0_DLI_VDD18_PG & w_S1_DLI_VDD18_PG;
    assign  w_All_PWRGD      = w_VTT_PWRGD & w_CORE08_PG & w_DLI_VDD18_PG & w_IO_PG ;
    //assign  w_BeepEnable     = w_iic_beep_en; 
    //assign  w_divide         = w_iic_divide;
    assign  w_PowerOn        = w_btn_PSON | (w_AST_PSON) | w_iic_PowerOn;
    assign  w_PowerOff       = w_btn_pwr_off_en | w_AST_PWROff | (w_lpc_PowerOff | w_iic_PowerOff);
    assign  w_reg_pwr_off    = w_AST_PWROff | (w_lpc_PowerOff | w_iic_PowerOff);
	//assign  w_reg_pwr_off    = 1'b0;
    assign  w_SoftRst        = w_rst_btn_press | w_AST_Reset | (w_lpc_SoftReset | w_iic_SoftReset);


    assign  o_PSOn           = w_PSON;
    assign  o_S0_1V2Enable   = w_1V2Enable;
	//assign  o_S0_1V2Enable   = 1'b0;
    assign  o_S1_1V2Enable   = w_1V2Enable;
    assign  o_PCIEReset0_n   = w_PCIEReset0;
    assign  o_PCIEReset1_n   = w_PCIEReset0;
	assign  o_HUB_RST_n      = w_PCIEReset0;
	assign  o_9230_PRST_n    = w_9230_PRST_n;
    assign  o_S0_CPUReset_n  = w_CPUReset_n;
    assign  o_S1_CPUReset_n  = w_CPUReset_n;	
    assign  o_S0_CPU_DCOK       = w_CPU_DCOK;
	assign  o_S1_CPU_DCOK       = w_CPU_DCOK;
    assign  o_YellowLED      = w_YellowLED;
    //assign  o_GreenLED       = w_GreenLED;
    //assign  o_state          = w_ctrl_state;
	//assign  o_UID_LED        = w_UID_LED;
	//assign  o_UID_LED        = w_Buzzer_uid_led;
	//assign  o_VGA_SEL        = w_Buzzer_uid_led;
	//assign  w_UID_LED        = w_Buzzer_uid_led;
   assign   o_CPLD_INT       = (w_ctrl_state==4'b1110)? 1'b1:1'b0;
	//assign  o_CPLD_INT       = 1'b1;
    assign  o_ipmi_perst_n   = w_PCIEReset0 ;
    assign  io_LAD           = w_lad_oe ? w_lad_o : 4'bzzzz;
	assign  w_lad_i          = io_LAD;
    assign  io_sda           = i2c_sda_oe_o? 1'b0 : 1'bz;
    assign  i_sda            = io_sda;
	assign  o_S0_CORE08_EN   = w_CORE08Enable;
	//assign  o_S0_CORE08_EN   = 1'b0;
	assign  o_S1_CORE08_EN   = w_CORE08Enable;
	assign  o_VDD18_EN       = w_VDD18_EN;
	assign  o_S0_DLI_VDD18_EN= w_DLI_VDD18_EN;
	assign  o_S1_DLI_VDD18_EN= w_DLI_VDD18_EN;
//	assign  o_ipmi_rst_n     = !w_ipmi_btn_press;
	assign  w_divide         = w_lpc_divide | w_iic_divide;
	assign  w_BeepEnable     = w_lpc_beep_en | w_iic_beep_en;
	assign  w_lpc_softrst    = ~w_lpc_SoftReset;
	//assign  w_vga_btn_cnt_en = 1'b1;
   // assign  o_sda_en         = ~i2c_sda_oe_o;
	//assign  o_POWER_ON_INT_uid_sw = w_UID_BUT_n_n;

endmodule

