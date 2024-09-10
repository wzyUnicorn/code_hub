class ahb_slave_driver extends uvm_driver#(ahb_txn);

	virtual ahb_if      vif;
    sys_memory          sys_mem;

	`uvm_component_utils(ahb_slave_driver)
	function new(string name, uvm_component parent);
        super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual ahb_if)::get(uvm_root::get(),this.get_full_name(),"ahb_vif", vif)) begin
            `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
        end
	    drive();
	endtask: run_phase

	virtual task drive();
	    ahb_txn ahb_tx;
        bit[31:0] haddr;
        bit[31:0] hwrite;
        bit[31:0] hdata;
        bit[31:0] hwdata;
        fork
            forever begin
                @(vif.hrstn) begin
                     if(vif.hrstn == 0) begin
                         vif.hrdata = 0;
                         vif.hready = 1;
                         vif.hresp = 0;
                     end
                end
            end
	        forever begin
	        	begin
                    @ (posedge vif.hclk);
                    vif.hready = 1;
                    vif.hresp = 0;
                    if((vif.htrans == 'h2)) begin
                        haddr = vif.haddr;
                        hwrite = vif.hwrite; 
                        if(hwrite == 1) begin
                            @ (posedge vif.hclk);
                            hdata = vif.hwdata;
                            sys_mem.write(haddr,hdata);
                        end else begin
                            sys_mem.read(haddr,hdata);
                            vif.hrdata = hdata;
                            @ (posedge vif.hclk);
                        end
                    end
	   	        end
	        end
        join
	endtask: drive
endclass: ahb_slave_driver
