class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)

	uvm_analysis_port#(apb_txn) mon_ap;

	virtual apb_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
                mon_ap = new(.name("mon_ap"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		integer counter_mon = 0;
		apb_txn apb_tx;
                if (!uvm_config_db#(virtual apb_if)::get(uvm_root::get(),this.get_full_name(),"apb_vif", vif)) begin
                    `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
                end
		apb_tx = apb_txn::type_id::create
			(.name("apb_tx"), .contxt(get_full_name()));

	forever begin
	    @(posedge vif.PCLK)
	    begin
	    	if(vif.PSEL==1)
	    	begin
                  apb_tx.paddr=vif.PADDR;
                  apb_tx.pdata=vif.PWDATA;
		  apb_tx.pwrite = vif.PWRITE;
	          @(posedge vif.PCLK)
                  apb_tx.pdata=vif.PWDATA;
                  wait(vif.PREADY==1);
                  if(apb_tx.pwrite==0)
                      apb_tx.pdata = vif.PRDATA;
	          @(posedge vif.PCLK)
                  mon_ap.write(apb_tx);
	    	end
	    end
	end

	endtask: run_phase
endclass: apb_monitor
