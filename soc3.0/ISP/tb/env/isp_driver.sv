class isp_driver extends uvm_driver#(isp_txn);
	virtual isp_if vif;
	`uvm_component_utils(isp_driver)
	function new(string name, uvm_component parent);
            super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual isp_if)::get(uvm_root::get(),this.get_full_name(),"isp_vif", vif)) begin
               `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
            end
	    drive();
	endtask: run_phase

	virtual task drive();
	    isp_txn isp_tx;
	    isp_txn isp_rsp;

	    vif.demosic_en   = 0;
        vif.dgain_en     = 0;
        vif.dgain_gain   = 0;
        vif.dgain_offset = 0;
        vif.in_href      = 0;
        vif.in_raw       = 0;
        vif.in_vsync     = 0;

	    forever begin
	    	begin
	           seq_item_port.get_next_item(isp_tx);
		       isp_rsp = new("isp_rsp");
		       isp_rsp.set_id_info(isp_tx);
               @ (posedge vif.pclk);

               vif.in_vsync = 1;
               vif.demosic_en = isp_tx.demosic_en;
               vif.dgain_en = isp_tx.dgain_en;
               vif.dgain_gain = isp_tx.dgain_gain;
               vif.dgain_offset = isp_tx.dgain_offset;
               vif.isp_height = isp_tx.isp_height;
               vif.isp_width = isp_tx.isp_width;
               
               repeat(10) @ (posedge vif.pclk);
               vif.in_vsync = 0;

               for(int j=0;j<isp_tx.isp_height;j++) begin

                   for(int i=0;i<isp_tx.isp_width;i++) begin
                       @ (posedge vif.pclk);
                       vif.in_href      = 1;
                       vif.in_raw       = isp_tx.pixl_data[j][i].pixl;
                   end

                   for(int i=0;i<isp_tx.isp_dummy_cycle;i++) begin
                       @ (posedge vif.pclk);
                       vif.in_href      = 0;
                       vif.in_raw       = 0;
                   end

               end
           end
	       seq_item_port.item_done(isp_tx);
	    end
	endtask: drive
endclass: isp_driver
