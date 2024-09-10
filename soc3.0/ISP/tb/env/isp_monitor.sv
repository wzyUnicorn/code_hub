class isp_monitor extends uvm_monitor;
     isp_line isp_result;
     bit frame_valid = 0;
     bit frame_valid_nxt = 0;
     bit [31:0] pixl_idx = 0;
     bit [31:0] line_cnt = 0;


	`uvm_component_utils(isp_monitor)

	uvm_analysis_port#(isp_line) mon_ap;

	virtual isp_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
        isp_result = new("isp_result");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
                mon_ap = new(.name("mon_ap"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	    integer counter_mon = 0;
	    isp_line isp_tx;
        if (!uvm_config_db#(virtual isp_if)::get(uvm_root::get(),this.get_full_name(),"isp_vif", vif)) begin
            `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
        end
        isp_tx = new("isp_tx");
	    forever begin
	        @(posedge vif.pclk)
	        begin
                frame_valid = frame_valid_nxt;
                if(vif.dm_vsync_o==1) begin
                    frame_valid_nxt = 1;
                    isp_tx.frame_start = 1;
                end

                if(frame_valid == 1) begin
                    if(vif.dm_href_o==1) begin
                       isp_tx.r_line[pixl_idx] = vif.dm_r_o;
                       isp_tx.g_line[pixl_idx] = vif.dm_g_o;
                       isp_tx.b_line[pixl_idx] = vif.dm_b_o;
                       if(pixl_idx<(vif.isp_width-1)) begin
                          pixl_idx = pixl_idx+1;
                       end
                       else begin
                          pixl_idx = 0;
                          if(line_cnt==1) 
                               isp_tx.frame_start = 0;
                          mon_ap.write(isp_tx);
                          if(line_cnt<(vif.isp_height-1)) 
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

endclass: isp_monitor
