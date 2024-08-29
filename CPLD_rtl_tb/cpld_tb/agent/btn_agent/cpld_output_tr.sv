
    parameter RESET=3'b001, POWER_OFF=3'b010, ALARM=3'b011, DCOK=3'b100;
class cpld_output_tr extends uvm_sequence_item;
    `uvm_object_utils(cpld_output_tr)

    function new(string name="cpld_output_tr");
        super.new(name);
    endfunction

    // monitor sample
    rand bit i_PowerButton_n;
	rand bit o_VDD18_EN;            rand bit o_YellowLED;
	rand bit o_PSOn;                rand bit o_9230_PRST_n;   
	rand bit o_S0_1V2Enable;        rand bit o_HUB_RST_n;     
	rand bit o_S1_1V2Enable;        rand bit o_S0_CPU_DCOK;
	rand bit o_S0_CORE08_EN;        rand bit o_S0_CPUReset_n;
	rand bit o_S1_CORE08_EN;        rand bit o_S1_CPU_DCOK;
	rand bit o_S0_DLI_VDD18_EN;     rand bit o_S1_CPUReset_n;
	rand bit o_S1_DLI_VDD18_EN;     rand bit o_Buzzer;
	rand bit o_PCIEReset0_n;        rand bit o_CPLD_INT;
	rand bit o_PCIEReset1_n;        rand bit o_ipmi_perst_n;
    
    // driver control
    rand int step; rand bit jitter;
    rand bit [2:0] last_step;
    constraint default_operation { soft step==7; soft jitter==0; soft last_step==3'b000;} 
    // about keyword "soft", see IEEE1800 section 18.5.14 Soft constraint
endclass
