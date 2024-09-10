class apb_driver extends uvm_driver#(apb_txn);
	virtual apb_if vif;
	`uvm_component_utils(apb_driver)
	function new(string name, uvm_component parent);
            super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual apb_if)::get(uvm_root::get(),this.get_full_name(),"apb_vif", vif)) begin
               `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
            end
	    drive();
	endtask: run_phase

	virtual task drive();
	    apb_txn apb_tx;
	    apb_txn apb_rsp;
            vif.PADDR=0;
            vif.PWDATA=0;
            vif.PWRITE =0;
            vif.PSEL = 0;
            vif.PENABLE = 0;
	    forever begin
	    	begin
	            seq_item_port.get_next_item(apb_tx);
		    apb_rsp = new("apb_rsp");
		    apb_rsp.set_id_info(apb_tx);
                    @ (posedge vif.PCLK);
                    vif.PSEL = 1;
		    vif.PENABLE = 0;
		    vif.PWRITE = apb_tx.pwrite;
		    vif.PADDR = apb_tx.paddr;
		    if(apb_tx.pwrite==1) 
                        vif.PWDATA = apb_tx.pdata;

                    @ (posedge vif.PCLK);
		    vif.PENABLE = 1;
		    wait(vif.PREADY==1);
                    @ (posedge vif.PCLK);
		    if(apb_tx.pwrite==0)
                         apb_tx.pdata = vif.PRDATA;
                    vif.PADDR=0;
                    vif.PWDATA=0;
                    vif.PWRITE =0;
                    vif.PSEL = 0;
                    vif.PENABLE = 0;		    
	            seq_item_port.item_done(apb_tx);
	   	end
	    end
	endtask: drive
endclass: apb_driver
