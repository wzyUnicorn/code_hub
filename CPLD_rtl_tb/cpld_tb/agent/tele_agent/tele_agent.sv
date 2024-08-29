class tele_agent extends uvm_agent;
    `uvm_component_utils(tele_agent)

    tele_sequencer sqr;
    tele_driver    drv;
    uvm_analysis_port#(tele_ctrl_item) drvAP;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        sqr=tele_sequencer::type_id::create("sqr",this);
        drv=tele_driver::type_id::create("drv",this);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        drvAP=drv.ap;
    endfunction
endclass
