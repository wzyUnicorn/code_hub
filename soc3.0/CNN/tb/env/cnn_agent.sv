class cnn_agent extends uvm_agent;
	`uvm_component_utils(cnn_agent)
	cnn_sequencer	 	    sqr;
	cnn_driver		        cnn_drv;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sqr	 	 = cnn_sequencer::type_id::create(.name("sqr"), .parent(this));
		cnn_drv	 = cnn_driver::type_id::create(.name("cnn_drv"), .parent(this));
	endfunction: build_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		cnn_drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction: connect_phase
endclass: cnn_agent
