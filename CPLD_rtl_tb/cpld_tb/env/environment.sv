class environment extends uvm_env;
    `uvm_component_utils(environment)

    btn_agent btn_agt;
    iic_agent iic_agt;
    lpc_agent lpc_agt;
    tele_agent tel_agt;
    scoreboard scb;
    functional_coverage fnc;

    iic_reg_model iic_rgm;
    lpc_reg_model lpc_rgm;
    uvm_reg_predictor#(iic_transaction) iic_predictor;
    uvm_reg_predictor#(lpc_transaction) lpc_predictor;
    iic_adapter iic_rgm2sqr, iic_mon2rgm;
    lpc_adapter lpc_rgm2sqr, lpc_mon2rgm;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        btn_agt=btn_agent::type_id::create("btn_agt",this);
        iic_agt=iic_agent::type_id::create("iic_agt",this);
        lpc_agt=lpc_agent::type_id::create("lpc_agt",this);
        tel_agt=tele_agent::type_id::create("tel_agt",this);
        scb=scoreboard::type_id::create("scb",this);
        fnc=functional_coverage::type_id::create("fnc",this);

        iic_rgm=iic_reg_model::type_id::create("iic_rgm",this);
        iic_rgm.configure(null,"");
        iic_rgm.build();
        iic_rgm.reset();
        iic_rgm2sqr=new("iic_rgm2sqr"); 
        iic_mon2rgm=new("iic_mon2rgm");
        iic_predictor=new("iic_predictor",this);

        lpc_rgm=lpc_reg_model::type_id::create("lpc_rgm",this);
        lpc_rgm.configure(null,"");
        lpc_rgm.build();
        lpc_rgm.reset();
        lpc_rgm2sqr=new("lpc_rgm2sqr"); 
        lpc_mon2rgm=new("lpc_mon2rgm");
        lpc_predictor=new("lpc_predictor",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        btn_agt.btnAP.connect(this.fnc.ap0);
        iic_agt.iicAP.connect(this.fnc.ap1);
        lpc_agt.lpcAP.connect(this.fnc.ap2);
        tel_agt.drvAP.connect(this.fnc.ap3);
        btn_agt.btnAP.connect(this.scb.ap0);
        iic_agt.iicAP.connect(this.scb.ap1);
        lpc_agt.lpcAP.connect(this.scb.ap2);
        iic_agt.iicAP.connect(iic_predictor.bus_in);
        lpc_agt.lpcAP.connect(lpc_predictor.bus_in);

        iic_rgm.reg_map.set_sequencer(this.iic_agt.sqr, iic_rgm2sqr);
        iic_rgm.reg_map.set_auto_predict(0);
        iic_predictor.map=iic_rgm.reg_map;
        iic_predictor.adapter=iic_mon2rgm;

        lpc_rgm.reg_map.set_sequencer(this.lpc_agt.sqr, lpc_rgm2sqr);
        lpc_rgm.reg_map.set_auto_predict(0);
        lpc_predictor.map=lpc_rgm.reg_map;
        lpc_predictor.adapter=lpc_mon2rgm;

        scb.iicrgm=this.iic_rgm;
        scb.lpcrgm=this.lpc_rgm;
    endfunction
endclass
