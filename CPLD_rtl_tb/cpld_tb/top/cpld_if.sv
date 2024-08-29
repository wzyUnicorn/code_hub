interface cpld_if(input logic clk);

    //button                        //state
	logic i_DCOKSby;              	logic o_PCIEReset0_n;
	logic i_RST_BUTTON_n;         	logic o_PCIEReset1_n;
	logic i_PowerButton_n;        	logic o_9230_PRST_n;
	logic i_ATX_PG;               	logic o_HUB_RST_n;
	logic o_VDD18_EN;             	logic o_S0_CPU_DCOK;
	logic o_S0_1V2Enable;         	logic o_S0_CPUReset_n;	
	logic o_S1_1V2Enable;         	logic o_S1_CPU_DCOK;
	logic i_WorkPowerGood1;       	logic o_S1_CPUReset_n;
	logic i_WorkPowerGood2;         //buzzer
	logic i_S0_VTT_PWRGD;         	logic i_Buzzer;
	logic i_S1_VTT_PWRGD;         	logic o_Buzzer;
	logic o_S0_CORE08_EN;           //ipmi
	logic o_S1_CORE08_EN;         	logic i_AST_PWROn_n;
	logic i_S0_CORE08_PG;         	logic i_AST_PWROff_n;
	logic i_S1_CORE08_PG;         	logic i_AST_Reset_n;
	logic o_S0_DLI_VDD18_EN;      	logic i_AST_act_n;
	logic o_S1_DLI_VDD18_EN;      	logic o_CPLD_INT;
	logic i_S0_DLI_VDD18_PG;      	logic o_ipmi_perst_n;
	logic i_S1_DLI_VDD18_PG;      
	logic o_PSOn;                   //temperature and voltage alarm
	logic i_8619_PG;              	logic i_S0_VS_ALARM_L;
	logic o_YellowLED;            	logic i_S0_TS_ALARM_L;
                                    logic i_S1_VS_ALARM_L;
                                    logic i_S1_TS_ALARM_L;

//some signal not use
	//wire		  o_POWER_ON_INT_uid_sw;
	//reg		  i_Buzzer_uid_led;
	//UID
	//reg         i_UID_BUT_n;	
	//wire        o_UID_LED;
	
modport button(
	input i_DCOKSby,		  output o_VDD18_EN,
	input i_RST_BUTTON_n,     output o_PSOn,
	input i_PowerButton_n,    output o_YellowLED,
	input i_ATX_PG,
	
	input i_WorkPowerGood1,	
	input i_WorkPowerGood2,   
	input i_S0_VTT_PWRGD,     output o_S0_1V2Enable,
	input i_S1_VTT_PWRGD,     output o_S1_1V2Enable,
	
	input i_S0_CORE08_PG,	  output o_S0_CORE08_EN,
	input i_S1_CORE08_PG,     output o_S1_CORE08_EN,
	
	input i_S0_DLI_VDD18_PG,  output o_S0_DLI_VDD18_EN,
	input i_S1_DLI_VDD18_PG,  output o_S1_DLI_VDD18_EN,
	input i_8619_PG);

modport state(
	output o_PCIEReset0_n,  o_S0_CPU_DCOK,
	output o_PCIEReset1_n,  o_S0_CPUReset_n,	
	output o_9230_PRST_n,   o_S1_CPU_DCOK,
	output o_HUB_RST_n,     o_S1_CPUReset_n);

modport buzzer(input i_Buzzer, output o_Buzzer);

modport tele(
	input i_AST_PWROn_n,	output o_CPLD_INT,
	input i_AST_PWROff_n,   output o_ipmi_perst_n,
	input i_AST_Reset_n,
	input i_AST_act_n);
	
//-----------------lpc--------------------
    logic LPCclk;
    logic i_LPCRst_n;
    logic i_Frame;
    wire  [3:0] io_LAD;
    reg   [3:0] LAD_o;  // tb output
    bit         lad_oe;

    assign io_LAD=(lad_oe)? LAD_o:4'bzzzz;
    assign LPCclk=clk;
modport lpc(input LPCclk, i_LPCRst_n, i_Frame, LAD_o,inout io_LAD);	    
//----------------------------------------

//-----------------iic--------------------
	logic scl,scl2, sda_oe;
    wire  io_sda;          
    reg   sda_out;  //tb output to dut
    reg [2:0] counter; reg r1,r2;

    always @(posedge clk) begin     // Tscl=16*Tclk
        counter <= counter+1;
        if(counter==3'b111) begin
            scl=!scl;
        end
        r1  <=!scl;
        r2  <=r1;
        scl2<=r2;
    end
    initial begin r1=1'b0;r2=1'b0; counter=3'b0; end
    assign io_sda=(sda_oe)? sda_out:1'bz;
modport iic(input scl, sda_out,inout io_sda); 
//----------------------------------------

modport alarm(input i_S0_VS_ALARM_L, i_S0_TS_ALARM_L, 
                    i_S1_VS_ALARM_L, i_S1_TS_ALARM_L);

// Assertion property for modeling cpld functional interaction
    reg [7:0] iic_reg, lpc_reg;
    reg [7:0] iic_beep_reg, lpc_beep_reg;
    wire w_btn_PSON, w_btn_pwr_off_en, w_rst_btn_press, w_BeepEnable;
    wire w_AST_PSON, w_AST_PWROff, w_AST_Reset;
    
    sequence power_btn_pressed_on;
        $fell(i_PowerButton_n) ##[16:111] $rose(i_PowerButton_n); // w_btn_PSON==1'b1;
    endsequence
    sequence power_btn_pressed_off;
        $fell(i_PowerButton_n) ##[112:200] $rose(i_PowerButton_n);// w_btn_pwr_off_en==1;
    endsequence
    sequence reset_btn_pressed;
        $fell(i_RST_BUTTON_n) ##[7:30] $rose(i_RST_BUTTON_n);     // w_rst_btn_press==1;
    endsequence
    sequence cpld_power_off;
        $fell(o_CPLD_INT) ##1 (o_PSOn & o_VDD18_EN & o_S0_1V2Enable & o_S0_CORE08_EN & o_S0_DLI_VDD18_EN & o_PCIEReset0_n 
        & o_S0_CPU_DCOK & o_S0_CPUReset_n & o_YellowLED)==0;
    endsequence
    sequence cpld_reset;
        $fell(o_CPLD_INT) ##1 ($fell(o_PCIEReset0_n) & $fell(o_ipmi_perst_n) & $fell(o_S0_CPU_DCOK) & $fell(o_S0_CPUReset_n))
        ##[10:70] ($rose(o_PCIEReset0_n) & $rose(o_ipmi_perst_n)) ##4 $rose(o_S0_CPU_DCOK) ##4 $rose(o_S0_CPUReset_n);
    endsequence
    sequence cpld_mt_reset;
        $fell(o_CPLD_INT) ##1 ($stable(o_PCIEReset0_n) & $stable(o_ipmi_perst_n) & $fell(o_S0_CPU_DCOK) & $fell(o_S0_CPUReset_n))
        ##4 $rose(o_S0_CPU_DCOK) ##4 $rose(o_S0_CPUReset_n);
    endsequence

    property button_power_on;
        @(posedge clk) w_btn_PSON |-> ##[0:$] $rose(o_CPLD_INT);
    endproperty
    property button_power_off;
        @(posedge clk) w_btn_pwr_off_en |-> ##[1:$] cpld_power_off;
    endproperty
    property button_reset;
        @(posedge clk) $rose(w_rst_btn_press) |-> ##[1:$] cpld_reset;
    endproperty
    property btn_on_iic_reset;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] w_btn_PSON ##[1:$] iic_reg==8'hc3 ##[0:$] cpld_reset;
    endproperty
    property btn_on_iic_off;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] w_btn_PSON ##[1:$] iic_reg==8'hf0 ##[0:$] cpld_power_off;
    endproperty
    property btn_on_iic_ctrl_beep;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] w_btn_PSON ##[1:$] iic_beep_reg[0]==1 ##[0:$] w_BeepEnable;
    endproperty
    property btn_on_tele_reset;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] w_AST_Reset ##[1:$] cpld_reset;
    endproperty
    property btn_on_tele_off;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] w_AST_PWROff ##[1:$] cpld_power_off;
    endproperty
    property iic_on_btn_reset;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[0:$] w_rst_btn_press ##[0:$] cpld_reset;
    endproperty
    property iic_on_btn_off;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[1:$] w_btn_pwr_off_en ##[0:$] cpld_power_off;
    endproperty
    property iic_on_lpc_soft_reset;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[1:$] lpc_reg==8'hc3 ##[0:$] cpld_reset;
    endproperty
    property iic_on_lpc_mt_reset;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[1:$] lpc_reg==8'hee ##[0:$] cpld_mt_reset;
    endproperty
    property iic_on_lpc_off;
        @(negedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[1:$] lpc_reg==8'hf0 ##[0:$] cpld_power_off;
    endproperty
    property iic_on_lpc_ctrl_beep;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[1:$] lpc_beep_reg[0]==1 ##[0:$] w_BeepEnable;
    endproperty
    property iic_on_tele_reset;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[1:$] w_AST_Reset ##[1:$] cpld_reset;
    endproperty
    property iic_on_tele_off;
        @(posedge clk) $rose(i_DCOKSby) |-> ##[1:$] iic_reg==8'h0f ##[1:$] $rose(o_CPLD_INT) 
        ##[1:$] w_AST_PWROff ##[1:$] cpld_power_off;
    endproperty
    property tele_on_btn_off;
        @(posedge clk) w_AST_PSON |-> ##[1:$] $rose(o_CPLD_INT) ##[1:$] w_btn_pwr_off_en ##[0:$] cpld_power_off;
    endproperty
    property tele_on_btn_reset;
        @(posedge clk) w_AST_PSON |-> ##[1:$] $rose(o_CPLD_INT) ##[1:$] w_rst_btn_press ##[0:$] cpld_reset;
    endproperty
    property tele_on_iic_reset;
        @(posedge clk) w_AST_PSON |-> ##[1:$] $rose(o_CPLD_INT) ##[1:$] iic_reg==8'hc3 ##[0:$] cpld_reset;
    endproperty
    property tele_on_iic_off;
        @(posedge clk) w_AST_PSON |-> ##[1:$] $rose(o_CPLD_INT) ##[1:$] iic_reg==8'hf0 ##[0:$] cpld_power_off;
    endproperty
    property tele_on_lpc_reset;
        @(posedge clk) w_AST_PSON |-> ##[1:$] $rose(o_CPLD_INT) ##[1:$] lpc_reg==8'hc3 ##[0:$] cpld_reset;
    endproperty
    property tele_on_lpc_off;
        @(posedge clk) w_AST_PSON |-> ##[1:$] $rose(o_CPLD_INT) ##[1:$] lpc_reg==8'hf0 ##[0:$] cpld_power_off;
    endproperty

    cover property(button_power_on);
    cover property(button_power_off);
    cover property(button_reset);
    cover property(btn_on_iic_reset);
    cover property(btn_on_iic_off);
    cover property(btn_on_iic_ctrl_beep);
    cover property(btn_on_tele_reset);
    cover property(btn_on_tele_off);
    cover property(iic_on_btn_reset);
    cover property(iic_on_btn_off);
    cover property(iic_on_lpc_soft_reset);
    cover property(iic_on_lpc_mt_reset);
    cover property(iic_on_lpc_off);
    cover property(iic_on_lpc_ctrl_beep);
    cover property(iic_on_tele_reset);
    cover property(iic_on_tele_off);
    cover property(tele_on_btn_reset);
    cover property(tele_on_btn_off);
    cover property(tele_on_iic_reset);
    cover property(tele_on_iic_off);
    cover property(tele_on_lpc_reset);
    cover property(tele_on_lpc_off);
endinterface

