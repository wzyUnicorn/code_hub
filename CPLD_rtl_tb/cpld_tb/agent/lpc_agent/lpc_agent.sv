class lpc_agent extends uvm_agent;
    `uvm_component_utils(lpc_agent)

    lpc_sequencer sqr;
    lpc_driver    drv;
    lpc_monitor   mon;
    uvm_analysis_port#(lpc_transaction) lpcAP;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        sqr=lpc_sequencer::type_id::create("sqr",this);
        drv=lpc_driver::type_id::create("drv",this);
        mon=lpc_monitor::type_id::create("mon",this);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        lpcAP=mon.map;
    endfunction
endclass
