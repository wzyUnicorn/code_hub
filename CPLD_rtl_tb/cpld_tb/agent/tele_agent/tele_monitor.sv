class tele_monitor extends uvm_monitor;
    `uvm_component_utils(tele_monitor)
    virtual cpld_if vif;
    uvm_analysis_port#(cpld_output_tr) telemonAP;
    cpld_output_tr tr,sent2scb;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        if(!uvm_config_db#(virtual cpld_if)::get(this,"","vif",vif))
        `uvm_error("Button MOnitor","Miss virtual interface !!")
        telemonAP=new("telemonAP",this);
    endfunction

    virtual task main_phase(uvm_phase phase);
        forever begin
            tr=new("tr");
            @(posedge vif.clk);
	        tr.o_VDD18_EN       =vif.o_VDD18_EN;
	        tr.o_PSOn           =vif.o_PSOn;
	        tr.o_YellowLED      =vif.o_YellowLED;
	        tr.o_S0_1V2Enable   =vif.o_S0_1V2Enable;
	        tr.o_S1_1V2Enable   =vif.o_S1_1V2Enable;
	        tr.o_S0_CORE08_EN   =vif.o_S0_CORE08_EN;
	        tr.o_S1_CORE08_EN   =vif.o_S1_CORE08_EN;
	        tr.o_S0_DLI_VDD18_EN=vif.o_S0_DLI_VDD18_EN;
	        tr.o_S1_DLI_VDD18_EN=vif.o_S1_DLI_VDD18_EN;
	        tr.o_PCIEReset0_n   =vif.o_PCIEReset0_n;
	        tr.o_PCIEReset1_n   =vif.o_PCIEReset1_n;
	        tr.o_9230_PRST_n    =vif.o_9230_PRST_n;
	        tr.o_HUB_RST_n      =vif.o_HUB_RST_n;
            tr.o_S0_CPU_DCOK    =vif.o_S0_CPU_DCOK;
            tr.o_S0_CPUReset_n  =vif.o_S0_CPUReset_n;
            tr.o_S1_CPU_DCOK    =vif.o_S1_CPU_DCOK;
            tr.o_S1_CPUReset_n  =vif.o_S1_CPUReset_n;
            tr.o_Buzzer         =vif.o_Buzzer;
            tr.o_CPLD_INT       =vif.o_CPLD_INT;
            tr.o_ipmi_perst_n   =vif.o_ipmi_perst_n;
            tr.i_PowerButton_n  =vif.i_PowerButton_n;
            $cast(sent2scb,tr);
            telemonAP.write(sent2scb);
        end
    endtask
endclass
