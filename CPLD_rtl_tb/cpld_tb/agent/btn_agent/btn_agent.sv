class btn_agent extends uvm_agent;
    `uvm_component_utils(btn_agent)

    btn_sequencer sqr;
    btn_driver    drv;
    btn_monitor   mon;
    uvm_analysis_port#(cpld_output_tr) btnAP;
    //uvm_active_passive_enum is_active;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        sqr=btn_sequencer::type_id::create("sqr",this);
        drv=btn_driver::type_id::create("drv",this);
        mon=btn_monitor::type_id::create("mon",this);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        btnAP=mon.btnmonAP;
    endfunction
endclass
