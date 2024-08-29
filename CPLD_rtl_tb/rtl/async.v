///////////////////////////////////////
//module:async.v
//discription:asynchronous signal
//history:v1.0 
//author:zwp
///////////////////////////////////////
module ASYNC(
input       i_clk_32k,
input       i_rst_n,
//detecting signals
input       i_RST_BUTTON_n,
input       i_PowerButton_n,
input       i_WorkPowerGood1,
input       i_WorkPowerGood2,
input       i_S0_VTT_PWRGD,
input       i_S1_VTT_PWRGD,
input       i_S0_CORE08_PG,
input       i_S1_CORE08_PG,
input       i_S0_DLI_VDD18_PG,
input       i_S1_DLI_VDD18_PG,
//input       i_8619_PG,
input       i_ATX_PG,
//input       i_Buzzer,
input       i_AST_PWROn_n,
input       i_AST_PWROff_n,
input       i_AST_Reset_n,
input       i_AST_act_n,
//input       i_UID_BUT_n,
//input       i_ipmi_rst_btn,
//input		  i_Buzzer_uid_led,

input 		  i_S0_VS_ALARM_L,
input         i_S0_TS_ALARM_L,
input 		  i_S1_VS_ALARM_L,
input         i_S1_TS_ALARM_L,
	
//output      o_UID_BUT_n,
output      o_RST_BUTTON_n,
output      o_PowerButton_n,
output      o_WorkPowerGood1,
output      o_WorkPowerGood2,
output      o_S0_VTT_PWRGD,
output      o_S1_VTT_PWRGD,
output      o_S0_CORE08_PG,
output      o_S1_CORE08_PG,
output      o_S0_DLI_VDD18_PG,
output      o_S1_DLI_VDD18_PG,
//output      o_8619_PG,
output      o_ATX_PG,
//output      o_Buzzer,
output      o_AST_PWROn_n,
output      o_AST_PWROff_n,
output      o_AST_Reset_n,
output      o_AST_act_n,
//output      o_ipmi_rst_btn,
//output		  o_Buzzer_uid_led,

output 		  o_S0_VS_ALARM_L,
output         o_S0_TS_ALARM_L,
output 		  o_S1_VS_ALARM_L,
output        o_S1_TS_ALARM_L
//asynchronous signal
);

////////////////regs/////////////////
reg         r1_RST_BUTTON_n    ;    
reg         r2_RST_BUTTON_n    ;   
reg         r1_PowerButton_n   ;    
reg         r2_PowerButton_n   ;    
reg         r1_WorkPowerGood1  ;    
reg         r2_WorkPowerGood1  ;  
reg         r1_WorkPowerGood2  ;    
reg         r2_WorkPowerGood2  ; 
reg         r1_S0_VTT_PWRGD    ; 
reg         r2_S0_VTT_PWRGD    ;
reg         r1_S1_VTT_PWRGD    ; 
reg         r2_S1_VTT_PWRGD    ;
reg         r1_S0_CORE08_PG    ; reg         r2_S0_CORE08_PG    ; 
reg         r1_S1_CORE08_PG    ;
reg         r2_S1_CORE08_PG    ;
reg         r1_S0_DLI_VDD18_PG ; 
reg         r2_S0_DLI_VDD18_PG ;
reg         r1_S1_DLI_VDD18_PG ; 
reg         r2_S1_DLI_VDD18_PG ;
reg         r1_ATX_PG          ;        
reg         r2_ATX_PG          ;
reg         r1_AST_PWROn_n     ;
reg         r2_AST_PWROn_n     ;
reg         r1_AST_PWROff_n    ;
reg         r2_AST_PWROff_n    ;
reg         r1_AST_Reset_n     ;
reg         r2_AST_Reset_n     ;
reg         r1_AST_act_n       ;
reg         r2_AST_act_n       ;
//reg         r1_ipmi_rst_btn    ;
//reg         r2_ipmi_rst_btn    ;
//reg         r1_UID_BUT_n       ;
//reg         r2_UID_BUT_n       ;
//reg         r1_Buzzer;
//reg         r2_Buzzer;
//reg         r1_8619_PG;
//reg         r2_8619_PG;
//reg			r1_Buzzer_uid_led;
//reg			r2_Buzzer_uid_led;

reg			r1_S0_VS_ALARM_L;
reg			r2_S0_VS_ALARM_L;
reg			r1_S0_TS_ALARM_L;
reg			r2_S0_TS_ALARM_L;
reg			r1_S1_VS_ALARM_L;
reg			r2_S1_VS_ALARM_L;
reg			r1_S1_TS_ALARM_L;
reg			r2_S1_TS_ALARM_L;


///////////////wire//////////////////

always @ (posedge i_clk_32k or negedge i_rst_n)
begin
    if(!i_rst_n)
    begin
    //detecting signals
        r1_RST_BUTTON_n    <= 1'b1;    
        r2_RST_BUTTON_n    <= 1'b1;   
        r1_PowerButton_n   <= 1'b1;    
        r2_PowerButton_n   <= 1'b1;    
        r1_WorkPowerGood1  <= 1'b1;    
        r2_WorkPowerGood1  <= 1'b1;   
        r1_WorkPowerGood2 <= 1'b0; 
        r2_WorkPowerGood2 <= 1'b0;
        r1_S0_VTT_PWRGD <= 1'b0; 
        r2_S0_VTT_PWRGD <= 1'b0;
        r1_S1_VTT_PWRGD <= 1'b0; 
        r2_S1_VTT_PWRGD <= 1'b0;		
        r1_S0_CORE08_PG    <= 1'b0;        
        r2_S0_CORE08_PG    <= 1'b0;
        r1_S1_CORE08_PG    <= 1'b0;        
        r2_S1_CORE08_PG    <= 1'b0;
		r1_S0_DLI_VDD18_PG <= 1'b0;
		r2_S0_DLI_VDD18_PG <= 1'b0;     	
		r1_S1_DLI_VDD18_PG <= 1'b0;
		r2_S1_DLI_VDD18_PG <= 1'b0;     	
        r1_ATX_PG          <= 1'b0;         
        r2_ATX_PG          <= 1'b0; 
        r1_AST_PWROn_n     <= 1'b1;
        r2_AST_PWROn_n     <= 1'b1;
        r1_AST_PWROff_n    <= 1'b1;
        r2_AST_PWROff_n    <= 1'b1;
        r1_AST_Reset_n     <= 1'b1;
        r2_AST_Reset_n     <= 1'b1;
        r1_AST_act_n       <= 1'b0;
        r2_AST_act_n       <= 1'b0;
        //r1_ipmi_rst_btn    <= 1'b1;
        //r2_ipmi_rst_btn    <= 1'b1;
//        r1_Buzzer          <= 1'b0; 
//        r2_Buzzer          <= 1'b0;
//		r1_UID_BUT_n       <= 1'b1;
//        r2_UID_BUT_n       <= 1'b1;
//		r1_8619_PG         <= 1'b0;
//		r2_8619_PG         <= 1'b0;
		r1_S0_VS_ALARM_L   <= 1'b0;
		r2_S0_VS_ALARM_L   <= 1'b0;
		r1_S0_TS_ALARM_L   <= 1'b0;
		r2_S0_TS_ALARM_L   <= 1'b0;
		r1_S1_VS_ALARM_L   <= 1'b0;
		r2_S1_VS_ALARM_L   <= 1'b0;
		r1_S1_TS_ALARM_L   <= 1'b0;
		r2_S1_TS_ALARM_L   <= 1'b0;
//		r1_Buzzer_uid_led  <= 1'b0;
//		r2_Buzzer_uid_led  <= 1'b0;


    //asynchronous signal
    end
    else
    begin
    //detecting signals
//	    r1_UID_BUT_n       <= i_UID_BUT_n; 
//      r2_UID_BUT_n       <= r1_UID_BUT_n; 
        r1_RST_BUTTON_n    <= i_RST_BUTTON_n;    
        r2_RST_BUTTON_n    <= r1_RST_BUTTON_n;   
        r1_PowerButton_n   <= i_PowerButton_n;    
        r2_PowerButton_n   <= r1_PowerButton_n;    
        r1_WorkPowerGood1  <= i_WorkPowerGood1;    
        r2_WorkPowerGood1  <= r1_WorkPowerGood1;   
        r1_WorkPowerGood2 <= i_WorkPowerGood2; 
        r2_WorkPowerGood2 <= r1_WorkPowerGood2;
        r1_S0_VTT_PWRGD <= i_S0_VTT_PWRGD; 
        r2_S0_VTT_PWRGD <= r1_S0_VTT_PWRGD;
        r1_S1_VTT_PWRGD <= i_S1_VTT_PWRGD; 
        r2_S1_VTT_PWRGD <= r1_S1_VTT_PWRGD;		
        r1_S0_CORE08_PG    <= i_S0_CORE08_PG;        
        r2_S0_CORE08_PG    <= r1_S0_CORE08_PG;
        r1_S1_CORE08_PG    <= i_S1_CORE08_PG;        
        r2_S1_CORE08_PG    <= r1_S1_CORE08_PG;
		r1_S0_DLI_VDD18_PG <= i_S0_DLI_VDD18_PG;
		r2_S0_DLI_VDD18_PG <= r1_S0_DLI_VDD18_PG;     
		r1_S1_DLI_VDD18_PG <= i_S1_DLI_VDD18_PG;
		r2_S1_DLI_VDD18_PG <= r1_S1_DLI_VDD18_PG;  		
        r1_ATX_PG          <= i_ATX_PG;        
        r2_ATX_PG          <= r1_ATX_PG;
        r1_AST_PWROn_n     <= i_AST_PWROn_n;
        r2_AST_PWROn_n     <= r1_AST_PWROn_n;
        r1_AST_PWROff_n    <= i_AST_PWROff_n;
        r2_AST_PWROff_n    <= r1_AST_PWROff_n;
        r1_AST_Reset_n     <= i_AST_Reset_n ;
        r2_AST_Reset_n     <= r1_AST_Reset_n;
        r1_AST_act_n       <= i_AST_act_n;
        r2_AST_act_n       <= r1_AST_act_n;
//        r1_Buzzer          <= i_Buzzer;
//        r2_Buzzer          <= r1_Buzzer;
	//	r1_8619_PG         <= i_8619_PG;
//		r2_8619_PG         <= r1_8619_PG;
		r1_S0_VS_ALARM_L   <= i_S0_VS_ALARM_L;
		r2_S0_VS_ALARM_L   <= r1_S0_VS_ALARM_L;
		r1_S0_TS_ALARM_L   <= i_S0_TS_ALARM_L;
		r2_S0_TS_ALARM_L   <= r1_S0_TS_ALARM_L;
		r1_S1_VS_ALARM_L   <= i_S1_VS_ALARM_L;
		r2_S1_VS_ALARM_L   <= r1_S1_VS_ALARM_L;
		r1_S1_TS_ALARM_L   <= i_S1_TS_ALARM_L;
		r2_S1_TS_ALARM_L   <= r1_S1_TS_ALARM_L;
//		r1_Buzzer_uid_led  <= i_Buzzer_uid_led;
//		r2_Buzzer_uid_led  <= r1_Buzzer_uid_led;
		
    //asynchronous signal
    end
end

//assign o_UID_BUT_n       = r2_UID_BUT_n;
assign o_RST_BUTTON_n    = r2_RST_BUTTON_n;
assign o_PowerButton_n   = r2_PowerButton_n;
assign o_WorkPowerGood1    = r2_WorkPowerGood1;
assign o_WorkPowerGood2    = r2_WorkPowerGood2;
assign o_S0_VTT_PWRGD = r2_S0_VTT_PWRGD;
assign o_S1_VTT_PWRGD = r2_S1_VTT_PWRGD;
assign o_S0_CORE08_PG = r2_S0_CORE08_PG;
assign o_S1_CORE08_PG = r2_S1_CORE08_PG;
assign o_S0_DLI_VDD18_PG = r2_S0_DLI_VDD18_PG;
assign o_S1_DLI_VDD18_PG = r2_S1_DLI_VDD18_PG;
assign o_ATX_PG          = r2_ATX_PG ;
//assign o_Buzzer          = r2_Buzzer;
assign o_AST_PWROn_n     = r2_AST_PWROn_n;
assign o_AST_PWROff_n    = r2_AST_PWROff_n;
assign o_AST_Reset_n     = r2_AST_Reset_n;
assign o_AST_act_n       = r2_AST_act_n;
//assign o_8619_PG         = r2_8619_PG;
//assign o_ipmi_rst_btn    = r2_ipmi_rst_btn;
//assign o_Buzzer_uid_led  = r2_Buzzer_uid_led;
assign o_S0_VS_ALARM_L   = r2_S0_VS_ALARM_L;
assign o_S0_TS_ALARM_L   = r2_S0_TS_ALARM_L;
assign o_S1_VS_ALARM_L   = r2_S1_VS_ALARM_L;
assign o_S1_TS_ALARM_L   = r2_S1_TS_ALARM_L;
endmodule
