class qspi_monitor extends uvm_monitor;

    parameter IDLE = 3'b000;
    parameter COMMAND = 3'b001;
    parameter ADDR = 3'b010;
    parameter WDATA = 3'b011;
    parameter RDATA_DUMMY = 3'b100;
    parameter WDATA_DUMMY = 3'b110;
    parameter RDATA = 3'b101;
    
    parameter COMMAND_WIDTH = 16;
    parameter ADDR_WIDTH = 16;
    parameter DATA_WIDTH = 32;
    
    parameter WRITE_ENABLE = 'h6;
    parameter WRITE_DISABLE = 'h4;
    parameter READ_DATA = 'h3;
    parameter PAGE_PROGRAMMING = 'h2;
    parameter DATA_ADDR_DUMMY = 'h8;

    bit[7:0] command;
    bit[31:0] addr;
    bit[31:0] laddr;

    bit[31:0] data[int];
    bit[31:0] sdata;

    bit[2:0] device_state=IDLE;
    bit[3:0] sample_data;
    bit[4:0] vld_bit_cnt;
    bit[31:0] command_data_cnt;
    bit[31:0] addr_data_cnt;
    bit[31:0] sdata_cnt;
    bit[31:0] data_cnt;

    bit  write_enable=0;
    bit  is_write = 0;

	`uvm_component_utils(qspi_monitor)

	uvm_analysis_port#(qspi_txn) mon_ap;
	uvm_analysis_port#(qspi_txn) mon_cov_ap;

	virtual qspi_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
                mon_ap = new(.name("mon_ap"), .parent(this));
                mon_cov_ap = new(.name("mon_cov_ap"),.parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	    integer counter_mon = 0;
	    qspi_txn qspi_tx;
        if (!uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),this.get_full_name(),"qspi_vif", vif)) begin
            `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
        end
	    qspi_tx = qspi_txn::type_id::create(.name("qspi_tx"), .contxt(get_full_name()));

	    forever begin
	        @(posedge vif.spi_clk)
	        begin
                case(device_state)
                    IDLE: begin
				         `uvm_info("QSPI Monitor", " In IDLE",UVM_HIGH)
                    	 command_data_cnt = 0;
                    	 addr_data_cnt = 0;
                         data_cnt = 0;
                         is_write = 0;
                         command = 0 ;
                         addr = 0;
                         sdata = 0;
                         sample_input_signal();
                         if(vif.command_width != 0) begin
		                     command = command << vld_bit_cnt;
		                     for(int i=0;i<vld_bit_cnt;i++) begin
		                         command[i] = sample_data[i];
	                         end
                             command_data_cnt = command_data_cnt+vld_bit_cnt;
                             device_state = COMMAND;
                         end
                         else  if(vif.addr_width != 0) begin
		                     addr = addr << vld_bit_cnt;
		                     for(int i=0;i<vld_bit_cnt;i++) begin
		                         addr[i] = sample_data[i];
	                         end
                             addr_data_cnt = addr_data_cnt+vld_bit_cnt;
                             device_state = ADDR;
                             is_write = ~vif.spi_rw;
                         end
                         else  begin
		                     sdata = sdata << vld_bit_cnt;
		                     for(int i=0;i<vld_bit_cnt;i++) begin
		                         sdata[i] = sample_data[i];
	                         end
                             sdata_cnt = sdata_cnt+vld_bit_cnt;
                             addr = 'ha55a;                            // write default address

                             if((vif.rdata_addr_dummy != 0)&&(vif.spi_rw==1)) begin
                                 device_state = RDATA_DUMMY;
                                 sdata_cnt = 1;
                             end
                             else if((vif.wdata_addr_dummy != 0) && (vif.spi_rw==0)) begin
                                 device_state = WDATA_DUMMY;
                                 sdata_cnt = 1;
                             end
                             else begin
                                 if(vif.spi_rw==1)
                                     device_state = RDATA;
                                 else 
                                     device_state = WDATA;
                             end
                             laddr = 'ha55a;
                             if(vif.spi_rw == 1)
                                 $display("Monitor read data from 'ha55a"); 
                             else
                                 $display("Monitor write data to 'ha55a"); 
                         end
                    end
                    COMMAND: begin
				        `uvm_info("QSPI Monitor", " In COMMAND",UVM_HIGH)
                         sample_input_signal();
                    	 command = command << vld_bit_cnt;
                    	 for(int i=0;i<vld_bit_cnt;i++) begin
                    	     command[i] = sample_data[i];
                         end
                         command_data_cnt = command_data_cnt+vld_bit_cnt;
                         `uvm_info("QSPI Monitor", $sformatf("Get command %h command_data_cnt %h command_width %h vld_bit_cnt %h ",command,command_data_cnt,vif.command_width,vld_bit_cnt),UVM_HIGH)
                    	  if(command_data_cnt==vif.command_width) 
                             begin
                                 command_data_cnt = 0;
                    	         case(command)
                    		         WRITE_ENABLE: begin
                    		             write_enable =1; 
                    		             device_state = IDLE;    
				                         qspi_tx.command =  command;
                                         `uvm_info("QSPI Monitor", "Send qspi_tx WRITE_ENABLE to SCB ",UVM_HIGH)
				                         mon_ap.write(qspi_tx);
                                         mon_cov_ap.write(qspi_tx);

                    		         end     
                    		         WRITE_DISABLE: begin
                    		             write_enable =0; 
                    		             device_state = IDLE;        
				                         qspi_tx.command =  command;
                                         `uvm_info("QSPI Monitor", "Send qspi_tx WRITE_DISABLE to SCB ",UVM_HIGH)
				                         mon_ap.write(qspi_tx);	
                                         mon_cov_ap.write(qspi_tx);
                 
                    	             end
                    		         READ_DATA:begin
                                         if(vif.addr_width != 0) begin
                                             device_state = ADDR;
			                                 is_write = 0;
                                         end else begin
                                             addr = 'ha55a;
                                             laddr = 'ha55a; 
                                             if(vif.rdata_addr_dummy != 0)
                                                 device_state = RDATA_DUMMY;
                                             else
                                                 device_state = RDATA;
                                         end
                    		         end
                                     PAGE_PROGRAMMING:begin
                                         if(vif.addr_width != 0) begin
                                            device_state = ADDR;
			                                is_write = 1;
                                         end else begin
                                             addr = 'ha55a;
                                             laddr = 'ha55a;
                                             is_write = 1;
                                             if(vif.wdata_addr_dummy != 0)
                                                 device_state = WDATA_DUMMY;
                                             else
                                                 device_state = WDATA;
                                         end
                    		         end
                    		         default: begin
                    		             `uvm_warning(get_type_name(), $sformatf("unsupport command %h ",command));
                    		             device_state = IDLE;
				                         qspi_tx.command =  command;
                                         `uvm_info("QSPI Monitor", "Send qspi_tx to SCB ",UVM_HIGH)
				                         mon_ap.write(qspi_tx);
                                         mon_cov_ap.write(qspi_tx);

                    		         end
                                 endcase
                             end
                          end
                    ADDR: begin
				              `uvm_info("QSPI Monitor", " In ADDR",UVM_HIGH)
                              sample_input_signal();
                    	      addr = addr << vld_bit_cnt;
                    	      for(int i=0;i<vld_bit_cnt;i++) begin
                    	         addr[i] = sample_data[i];
                              end
                              `uvm_info("QSPI Monitor", $sformatf("Get addr %h",addr),UVM_HIGH)
                              addr_data_cnt = addr_data_cnt+vld_bit_cnt;

		                      if(addr_data_cnt==vif.addr_width)	 begin
                                  laddr = addr; 
	                              if(is_write) begin
                                      if(vif.wdata_addr_dummy != 0) begin
		                                   device_state = WDATA_DUMMY;
                                      end else begin
		                                   device_state = WDATA;
                                      end
                                      sdata_cnt = 0;
		                          end else begin
                                      if(vif.rdata_addr_dummy != 0) begin
		                                 device_state = RDATA_DUMMY;
                                      end else begin
		                                 device_state = RDATA;
                                      end
                                      sdata_cnt = 0;
		                          end
		                          addr_data_cnt = 0;
		                      end 

                         end

                    WDATA_DUMMY: begin
				                    `uvm_info("QSPI Monitor", " In WDATA_DUMMY",UVM_HIGH)
                    	             sdata_cnt = sdata_cnt+1;
                    	             if(sdata_cnt == vif.wdata_addr_dummy) begin
                    	                 device_state = WDATA;
                    	                 sdata = 0; 
                    	                 sdata_cnt = 0; 
                                    end
                                 end

                    WDATA: begin
				               `uvm_info("QSPI Monitor", " In WDATA",UVM_HIGH)

                               sample_input_signal();
                    	       sdata = sdata << vld_bit_cnt;
                    	       for(int i=0;i<vld_bit_cnt;i++) begin
                    	           sdata[i] = sample_data[i];
                               end

                               `uvm_info("QSPI Monitor", $sformatf("Get sdata %h",sdata),UVM_HIGH)
                               sdata_cnt = sdata_cnt+vld_bit_cnt;

                    	       if((sdata_cnt == vif.data_width)||(sdata_cnt%32==0)) begin
			                       qspi_tx.command =  command;
				                   qspi_tx.data[laddr] =  sdata;
                                   `uvm_info("QSPI Monitor", $sformatf("Get data %h @ addr %h sdata_cnt %h ,vif.data_width %h ",sdata,laddr,sdata_cnt,vif.data_width),UVM_LOW)
                                   if((sdata_cnt<vif.data_width)&&(sdata_cnt%32==0)) begin
                                       laddr = laddr +4;
                                   end
                                   sdata = 0;
                                   if(sdata_cnt == vif.data_width) begin
				                       qspi_tx.addr =  addr;
				                       qspi_tx.qspi_write =  1;
                    	               device_state = IDLE;
                    	               sdata = 0; 
                    	               sdata_cnt = 0; 
                                       `uvm_info("QSPI Monitor", "Send qspi_tx to SCB ",UVM_HIGH)
				                       mon_ap.write(qspi_tx);
                                       mon_cov_ap.write(qspi_tx);
                                   end
                               end
                          end
                    RDATA_DUMMY: begin
				                    `uvm_info("QSPI Monitor", " In RDATA_DUMMY",UVM_HIGH)
                                    sample_data = 0;
                    	             sdata = sdata << vld_bit_cnt;
                    	             sdata_cnt = sdata_cnt+1;
                    	             if(sdata_cnt == vif.rdata_addr_dummy) begin
                    	                 device_state = RDATA;
                    	                 sdata = 0; 
                    	                 sdata_cnt = 0; 
                                    end
                                 end
                    RDATA: begin
				               `uvm_info("QSPI Monitor", " In RDATA",UVM_HIGH)

                               sample_output_signal();
                    	       sdata = sdata << vld_bit_cnt;

                    	       for(int i=0;i<vld_bit_cnt;i++) begin
                    	           sdata[i] = sample_data[i];
                               end

                               `uvm_info("QSPI Monitor", $sformatf("Get sdata %h",sdata),UVM_HIGH)

                    	       sdata_cnt = sdata_cnt+vld_bit_cnt;

                    	       if((sdata_cnt == vif.data_width)||(sdata_cnt%32==0)) begin
				                  qspi_tx.data[laddr] =  sdata;
                                  if((sdata_cnt<vif.data_width)&&(sdata_cnt%32==0)) begin
                                      laddr = laddr +4;
                                  end   
                                  sdata = 0;                                  
                                  if(sdata_cnt == vif.data_width) begin
                                      qspi_tx.command =  command; 
				                      qspi_tx.addr =  addr;
				                      qspi_tx.qspi_write =  0;
                    	              device_state = IDLE;
                    	              sdata_cnt = 0; 
                                      `uvm_info("QSPI Monitor", "Send qspi_tx to SCB ",UVM_HIGH)
				                      mon_ap.write(qspi_tx);
                                      mon_cov_ap.write(qspi_tx);

                                  end
                               end

                          end

                    default:;
                 endcase
	        end
	    end

	endtask: run_phase

        task sample_input_signal();
            vld_bit_cnt = 0;
            sample_data[0] =  vif.spi_sdo0 & (vif.spi_csn0==0)&(vif.spi_oe0==1);
            sample_data[1] =  vif.spi_sdo1 & (vif.spi_csn1==0)&(vif.spi_oe1==1);
            sample_data[2] =  vif.spi_sdo2 & (vif.spi_csn2==0)&(vif.spi_oe2==1);
            sample_data[3] =  vif.spi_sdo3 & (vif.spi_csn3==0)&(vif.spi_oe3==1);
            if((vif.spi_csn0==0)&&(vif.spi_oe0==1)) vld_bit_cnt = vld_bit_cnt+1;
            if((vif.spi_csn1==0)&&(vif.spi_oe1==1)) vld_bit_cnt = vld_bit_cnt+1;
            if((vif.spi_csn2==0)&&(vif.spi_oe2==1)) vld_bit_cnt = vld_bit_cnt+1;
            if((vif.spi_csn3==0)&&(vif.spi_oe3==1)) vld_bit_cnt = vld_bit_cnt+1;
        endtask
        
        
        task sample_output_signal();
            #1ns;
            vld_bit_cnt = 0;
            sample_data[0] =  vif.spi_sdi0 & (vif.spi_csn0==0);
            sample_data[1] =  vif.spi_sdi1 & (vif.spi_csn1==0);
            sample_data[2] =  vif.spi_sdi2 & (vif.spi_csn2==0);
            sample_data[3] =  vif.spi_sdi3 & (vif.spi_csn3==0);
            if(vif.spi_csn0==0) vld_bit_cnt = vld_bit_cnt+1;
            if(vif.spi_csn1==0) vld_bit_cnt = vld_bit_cnt+1;
            if(vif.spi_csn2==0) vld_bit_cnt = vld_bit_cnt+1;
            if(vif.spi_csn3==0) vld_bit_cnt = vld_bit_cnt+1;
        endtask

endclass: qspi_monitor
