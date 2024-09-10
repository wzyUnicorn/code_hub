class ahb_slave_agent extends uvm_agent;
	`uvm_component_utils(ahb_slave_agent)

	uvm_analysis_port#(ahb_txn) agent_ap;
	ahb_slave_sequencer		    sqr;
	ahb_slave_driver		    ahb_slv_drv;

    sys_memory                  sys_mem;
	
    function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		
        super.build_phase(phase);
        
        agent_ap	         =   new(.name("agent_ap"), .parent(this));
		sqr	    	         =   ahb_slave_sequencer::type_id::create(.name("sqr"), .parent(this));
		ahb_slv_drv	         =   ahb_slave_driver::type_id::create(.name("ahb_slv_drv"), .parent(this));
        sys_mem              =   sys_memory::type_id::create(.name("sys_mem"), .parent(this));
        ahb_slv_drv.sys_mem  =   sys_mem;

	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ahb_slv_drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction: connect_phase

endclass: ahb_slave_agent
