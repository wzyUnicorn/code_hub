class apb_agent extends uvm_agent;
	`uvm_component_utils(apb_agent)
	uvm_analysis_port#(apb_txn) agent_ap;
	apb_sequencer		sqr;
	apb_driver		apb_drv;
	apb_monitor          	apb_mon;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent_ap	= new(.name("agent_ap"), .parent(this));
		sqr		= apb_sequencer::type_id::create(.name("sqr"), .parent(this));
		apb_drv		= apb_driver::type_id::create(.name("apb_drv"), .parent(this));
		apb_mon  	= apb_monitor::type_id::create(.name("apb_mon"), .parent(this));
	endfunction: build_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_drv.seq_item_port.connect(sqr.seq_item_export);
		apb_mon.mon_ap.connect(agent_ap);
	endfunction: connect_phase
endclass: apb_agent
