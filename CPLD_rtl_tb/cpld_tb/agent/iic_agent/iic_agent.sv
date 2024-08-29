class iic_agent extends uvm_agent;
    `uvm_component_utils(iic_agent)

    iic_sequencer sqr;
    iic_driver    drv;
    iic_monitor   mon;
    uvm_analysis_port#(iic_transaction) iicAP;
    //uvm_active_passive_enum is_active;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        //if(is_active==UVM_ACTIVE)
        begin
        sqr=iic_sequencer::type_id::create("sqr",this);
        drv=iic_driver::type_id::create("drv",this);
        end
        mon=iic_monitor::type_id::create("mon",this);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        iicAP=mon.map;
    endfunction
endclass
