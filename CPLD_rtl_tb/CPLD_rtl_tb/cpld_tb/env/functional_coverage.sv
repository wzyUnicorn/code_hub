    `uvm_analysis_imp_decl(_btnmon)
    `uvm_analysis_imp_decl(_iicmon)
    `uvm_analysis_imp_decl(_lpcmon)
    `uvm_analysis_imp_decl(_teldrv)
class functional_coverage extends uvm_component;
    `uvm_component_utils(functional_coverage)

    cpld_output_tr  tr0;
    iic_transaction tr1;
    lpc_transaction tr2;
    tele_ctrl_item  tr3;
    uvm_analysis_imp_btnmon#(cpld_output_tr, functional_coverage) ap0;
    uvm_analysis_imp_iicmon#(iic_transaction,functional_coverage) ap1;
    uvm_analysis_imp_lpcmon#(lpc_transaction,functional_coverage) ap2;
    uvm_analysis_imp_teldrv#(tele_ctrl_item, functional_coverage) ap3;

    covergroup poweron_st_cg;
        option.per_instance=1;
	    coverpoint tr0.o_PSOn;              coverpoint tr0.o_YellowLED;
	    coverpoint tr0.o_VDD18_EN;          coverpoint tr0.o_9230_PRST_n;   
	    coverpoint tr0.o_S0_1V2Enable;      coverpoint tr0.o_HUB_RST_n;     
	    coverpoint tr0.o_S1_1V2Enable;      coverpoint tr0.o_S0_CPU_DCOK;
	    coverpoint tr0.o_S0_CORE08_EN;      coverpoint tr0.o_S1_CPU_DCOK;
	    coverpoint tr0.o_S1_CORE08_EN;      coverpoint tr0.o_S0_CPUReset_n;
	    coverpoint tr0.o_S0_DLI_VDD18_EN;   coverpoint tr0.o_S1_CPUReset_n;
	    coverpoint tr0.o_S1_DLI_VDD18_EN;   coverpoint tr0.o_CPLD_INT;
	    coverpoint tr0.o_PCIEReset0_n;      coverpoint tr0.o_ipmi_perst_n;
	    coverpoint tr0.o_PCIEReset1_n;  
    endgroup
    covergroup iic_module_cg;
        option.per_instance=1;
        SLAVE_ADDR: coverpoint tr1.addr{bins iic_addr={7'h64};}
        SLAVE_ACK:  coverpoint tr1.ack{bins ACK={1'b1}; bins NACK={1'b0};}
        RW:         coverpoint tr1.trans{bins slave_read={0}; bins slave_write={1};}
        REG_ADDR:   coverpoint tr1.regAddr{bins a0={8'h00};bins a1={8'h04};bins a2={8'h08};bins a3={8'h0c};}
        DATA:       coverpoint tr1.dataIN{bins on={8'h0f}; bins off={8'hf0}; bins reset={8'hc3}; bins mtrst={8'hee};}
    endgroup
    covergroup lpc_module_cg;
        option.per_instance=1;
        RW:  coverpoint tr2.cyctype[1]{bins read={0};bins write={1};}
        ADDR:coverpoint tr2.addr[7:0]{bins a0={8'h00};bins a1={8'h04};bins a2={8'h08};bins a3={8'h0c};}
        DATA:coverpoint tr2.dataIn{bins vga={8'haa}; bins off={8'hf0};bins softRST={8'hc3};bins mtRST={8'hee};bins ich={8'hff};}
    endgroup
    covergroup tele_control_cg;
        option.per_instance=1;
        IPMI_CTRL:coverpoint tr3.do_action{bins on={AST_ON}; bins reset={AST_RST}; bins off={AST_OFF};}
    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        poweron_st_cg=new();
        iic_module_cg=new();
        lpc_module_cg=new();
        tele_control_cg=new();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        ap0=new("ap0",this);  // connect(btn_agt.mon.map)
        ap1=new("ap1",this);  // connect(iic_agt.mon.map)
        ap2=new("ap2",this);  // connect(lpc_agt.mon.map)
        ap3=new("ap3",this);  // connect(tel_agt.drv.export)
    endfunction
    function void write_btnmon(cpld_output_tr tr);
        if(tr!=null) begin $cast(tr0,tr); poweron_st_cg.sample(); end
    endfunction
    function void write_iicmon(iic_transaction tr);
        if(tr!=null) begin $cast(tr1,tr); iic_module_cg.sample(); end
    endfunction
    function void write_lpcmon(lpc_transaction tr);
        if(tr!=null) begin $cast(tr2,tr); lpc_module_cg.sample(); end
    endfunction
    function void write_teldrv(tele_ctrl_item tr);
        if(tr!=null) begin $cast(tr3,tr); tele_control_cg.sample();end
    endfunction

endclass
