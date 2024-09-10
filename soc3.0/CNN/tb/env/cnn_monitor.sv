class cnn_monitor extends uvm_monitor;
     cnn_line cnn_result;
     bit frame_valid = 0;
     bit frame_valid_nxt = 0;
     bit [31:0] pixl_idx = 0;
     bit [31:0] line_cnt = 0;


	`uvm_component_utils(cnn_monitor)

	uvm_analysis_port#(cnn_line) mon_ap;

	virtual cnn_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
        cnn_result = new("cnn_result");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
                mon_ap = new(.name("mon_ap"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	    integer counter_mon = 0;
	    cnn_line cnn_tx;
        if (!uvm_config_db#(virtual cnn_if)::get(uvm_root::get(),this.get_full_name(),"cnn_vif", vif)) begin
            `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
        end
        cnn_tx = new("cnn_tx");
	    forever begin
	        @(posedge vif.pclk)
	        begin
                frame_valid = frame_valid_nxt;
                if(vif.dm_vsync_o==1) begin
                    frame_valid_nxt = 1;
                    cnn_tx.frame_start = 1;
                end

                if(frame_valid == 1) begin
                    if(vif.dm_href_o==1) begin
                       cnn_tx.r_line[pixl_idx] = vif.dm_r_o;
                       cnn_tx.g_line[pixl_idx] = vif.dm_g_o;
                       cnn_tx.b_line[pixl_idx] = vif.dm_b_o;
                       if(pixl_idx<(vif.cnn_width-1)) begin
                          pixl_idx = pixl_idx+1;
                       end
                       else begin
                          pixl_idx = 0;
                          if(line_cnt==1) 
                               cnn_tx.frame_start = 0;
                          mon_ap.write(cnn_tx);
                          if(line_cnt<(vif.cnn_height-1)) 
                              line_cnt = line_cnt+1;
                          else begin
                              line_cnt = 0;
                              frame_valid = 0;
                          end
                       end
                    end
                end
	        end
	    end

	endtask: run_phase

endclass: cnn_monitor
