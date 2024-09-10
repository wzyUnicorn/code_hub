class cnn_driver extends uvm_driver#(cnn_txn);
	virtual cnn_if vif;
	`uvm_component_utils(cnn_driver)
	function new(string name, uvm_component parent);
            super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual cnn_if)::get(uvm_root::get(),this.get_full_name(),"cnn_vif", vif)) begin
               `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
            end
	    drive();
	endtask: run_phase

	virtual task drive();
	    cnn_txn cnn_tx;
	    cnn_txn cnn_rsp;

	    vif.demosic_en   = 0;
        vif.dgain_en     = 0;
        vif.dgain_gain   = 0;
        vif.dgain_offset = 0;
        vif.in_href      = 0;
        vif.in_raw       = 0;
        vif.in_vsync     = 0;

	    forever begin
	    	begin
	           seq_item_port.get_next_item(cnn_tx);
		       cnn_rsp = new("cnn_rsp");
		       cnn_rsp.set_id_info(cnn_tx);
               @ (posedge vif.pclk);

               vif.in_vsync = 1;
               vif.demosic_en = cnn_tx.demosic_en;
               vif.dgain_en = cnn_tx.dgain_en;
               vif.dgain_gain = cnn_tx.dgain_gain;
               vif.dgain_offset = cnn_tx.dgain_offset;
               vif.cnn_height = cnn_tx.cnn_height;
               vif.cnn_width = cnn_tx.cnn_width;
               
               repeat(10) @ (posedge vif.pclk);
               vif.in_vsync = 0;

               for(int j=0;j<cnn_tx.cnn_height;j++) begin

                   for(int i=0;i<cnn_tx.cnn_width;i++) begin
                       @ (posedge vif.pclk);
                       vif.in_href      = 1;
                       vif.in_raw       = cnn_tx.pixl_data[j][i].pixl;
                   end

                   for(int i=0;i<cnn_tx.cnn_dummy_cycle;i++) begin
                       @ (posedge vif.pclk);
                       vif.in_href      = 0;
                       vif.in_raw       = 0;
                   end

               end
           end
	       seq_item_port.item_done(cnn_tx);
	    end
	endtask: drive
endclass: cnn_driver
