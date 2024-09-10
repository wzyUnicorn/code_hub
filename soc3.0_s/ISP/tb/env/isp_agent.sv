class isp_agent extends uvm_agent;
	`uvm_component_utils(isp_agent)
	isp_sequencer	 	    sqr;
	isp_driver		        isp_drv;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sqr	 	 = isp_sequencer::type_id::create(.name("sqr"), .parent(this));
		isp_drv	 = isp_driver::type_id::create(.name("isp_drv"), .parent(this));
	endfunction: build_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		isp_drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction: connect_phase
endclass: isp_agent
