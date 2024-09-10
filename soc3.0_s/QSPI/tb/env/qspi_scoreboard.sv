class qspi_scoreboard extends uvm_scoreboard;

parameter WRITE_ENABLE = 'h6;
parameter WRITE_DISABLE = 'h4;
parameter READ_DATA = 'h3;
parameter PAGE_PROGRAMMING = 'h2;

	`uvm_component_utils(qspi_scoreboard)
	uvm_analysis_export #(apb_txn) sb_export_apb;
	uvm_analysis_export #(qspi_txn) sb_export_qspi;

	uvm_tlm_analysis_fifo #(apb_txn) apb_fifo;
	uvm_tlm_analysis_fifo #(qspi_txn) qpi_fifo;
	apb_txn transaction_apb;
	qspi_txn transaction_qspi;
    bit apb_get_tr=0;
    bit ch1_get_tr=0;

    bit[31:0] qspi_reg[int];
    bit[31:0] qspi_tx_fifo[$];
	bit[31:0] device_data[int];
	bit[31:0] rdata_fifo[$];
    bit[31:0] laddr;
    bit[31:0] laddr1;
    bit[31:0] data_width;
    bit[31:0] cmd_width;
    bit[31:0] qspi_cmd;
    bit[31:0] addr_width;
    bit[31:0] data_chk_width;
    bit[31:0] data_wait_width;
    bit[31:0] data_mask;
    bit[31:0] dev_value;
    bit[31:0] mon_value;


    bit qspi_is_pending=0;
    bit qspi_is_write_busy = 0;
    bit [31:0]  pending_width = 0;


	function new(string name, uvm_component parent);
		super.new(name, parent);

		transaction_apb	= new("transaction_apb");
        transaction_qspi         = new("transaction_qspi");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_export_apb	= new("sb_export_apb", this);
		sb_export_qspi     	= new("sb_export_qspi", this);
   		apb_fifo		= new("apb_fifo", this);
        qpi_fifo		= new("qpi_fifo", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		sb_export_apb.connect(apb_fifo.analysis_export);
        sb_export_qspi.connect(qpi_fifo.analysis_export);
	endfunction: connect_phase

	task run();
        bit [31:0] fifo_output;
        fork
		    forever begin
		    	apb_fifo.get(transaction_apb);
		 	    `uvm_info("QSPI SCOREBOARD", "Get APB transaction...",UVM_LOW)

                cmd_width = qspi_reg['h14][5:0];
                addr_width = qspi_reg['h14][13:8];
                data_width =  qspi_reg['h14][31:16];
                qspi_cmd = qspi_reg['hc] >> (32-cmd_width);

			    if(transaction_apb.pwrite==1)
			    begin

		            qspi_reg[transaction_apb.paddr] = transaction_apb.pdata;

			        if(transaction_apb.paddr==0 && (qspi_cmd==PAGE_PROGRAMMING || (cmd_width==0))&&((transaction_apb.pdata[3]==1)||(transaction_apb.pdata[1]==1))) begin

                       if(addr_width != 0) begin
                           laddr = qspi_reg['h10];
                           laddr = laddr >> (32-addr_width);
                       end 
                       else
                           laddr = 'ha55a;

                       qspi_is_write_busy = 1;
                       for(int i=0;i<data_width;i=i+32) begin
                           fifo_output = qspi_tx_fifo.pop_front();
			    	       device_data[laddr]=  (data_width<32) ? (fifo_output >> (32-data_width)) : fifo_output ;
                            `uvm_info("QSPI SCOREBOARD", $sformatf("qspi_tx_fifo pop data %h",fifo_output),UVM_LOW)
                            `uvm_info("QSPI SCOREBOARD", $sformatf("write device_data[%h] %h",laddr,device_data[laddr]),UVM_LOW)
                           laddr = laddr+4;
                       end
                       `uvm_info("QSPI SCOREBOARD", $sformatf("Get device_data[%h] %h",qspi_reg['h10][31:16],device_data[qspi_reg['h10][31:16]]),UVM_LOW)
			        end

			        if(transaction_apb.paddr==0 &&(transaction_apb.pdata[4]==1)&&(qspi_is_write_busy==1)) begin  //softreset clear fifo
                       laddr1 = qspi_reg['h10][31:16];
                       data_width =  qspi_reg['h14][31:16];
                       qspi_tx_fifo.delete();
                       for(int i=0;i<data_width;i=i+32) begin
			    	       device_data[laddr1]=  0;
                           laddr1 = laddr1+4;
                       end
                       laddr1 = qspi_reg['h10][31:16];
                       qspi_is_pending =  1;
			        end


			        if(transaction_apb.paddr=='h1c) begin
                       if(qspi_is_pending==0) begin
                           qspi_tx_fifo.push_back(qspi_reg['h1c]);
                           `uvm_info("QSPI SCOREBOARD", $sformatf("qspi_tx_fifo push data %h",qspi_reg['h1c]),UVM_LOW)
                       end else begin
                          device_data[laddr1]= qspi_reg['h1c];
                          laddr1 = laddr1 +4;
                          pending_width = pending_width+32;
                          if(pending_width >= data_width ) begin
                             qspi_is_pending = 0;
                             laddr1 = qspi_reg['h10][31:16];
                          end
                       end
                      `uvm_info("QSPI SCOREBOARD", $sformatf("Get QSPI DATA %h",qspi_reg['h1c]),UVM_LOW)
			        end


			    end
			    else begin
			        if(transaction_apb.paddr=='h20) begin
			    	    bit[31:0] real_data;
                        if(rdata_fifo.size()>0) begin
			    	        real_data = rdata_fifo.pop_front();
                            `uvm_info("QSPI SCOREBOARD", $sformatf("rdata_fifo pop data %h",real_data),UVM_HIGH)
                        end
 			    	    if(transaction_apb.pdata != real_data) begin
                            `uvm_error("Scoreboard",$sformatf("Expect read fifo data 0x%h while get 0x%h",transaction_apb.pdata,real_data))	
			    	    end
			        end		  
			    end
		    end
		    forever begin
		    	qpi_fifo.get(transaction_qspi);
		    	`uvm_info("QSPI SCOREBOARD", "Get QSPI transaction...",UVM_LOW)
                cmd_width = qspi_reg['h14][5:0];
                addr_width = qspi_reg['h14][13:8];
                data_width =  qspi_reg['h14][31:16];
                qspi_cmd = qspi_reg['hc] >> (32-cmd_width);

                transaction_qspi.print();

			    case(transaction_qspi.command)
			        WRITE_ENABLE: begin 
			            if(qspi_cmd !=WRITE_ENABLE) 
			    	  `uvm_error("Scoreboard",$sformatf("Expect get WRITE_ENABLE while get Reg_8 = 0x%h ",qspi_reg['hc]));
			        end
			        WRITE_DISABLE:begin
			            if(qspi_cmd !=WRITE_DISABLE) 
			    	  `uvm_error("Scoreboard",$sformatf("Expect get WRITE_DISABLE while get Reg_8 = 0x%h ",qspi_reg['hc]));
			        end
			        READ_DATA: begin
                      laddr = transaction_qspi.addr;
                      data_width =  qspi_reg['h14][31:16];
                      data_wait_width=data_width;
                      for(int i=0;i<data_width;i=i+32) begin

                        if(data_wait_width>32) begin
                            data_wait_width = data_wait_width - 32; 
                            data_chk_width = 32;
                        end else begin
                            data_chk_width = data_wait_width;
                        end

			    	    rdata_fifo.push_back(transaction_qspi.data[laddr]);
                        `uvm_info("QSPI SCOREBOARD", $sformatf("rdata_fifo push back addr %h, data %h",laddr,transaction_qspi.data[laddr]),UVM_HIGH)


                        dev_value = device_data[laddr] >> (32-data_chk_width);
                        mon_value = transaction_qspi.data[laddr]; 

			            if(qspi_cmd !=READ_DATA) 
			    	       `uvm_error("Scoreboard",$sformatf("Expect get READ_DATA while get Reg_8 = 0x%h cmd_width = 0x%h ",qspi_reg['hc],cmd_width));
			            if(dev_value != mon_value)
			    	       `uvm_error("Scoreboard",$sformatf("Expect read device data[%h] 0x%h while get 0x%h",laddr,device_data[laddr],transaction_qspi.data[laddr]));
                        laddr = laddr+4;

                      end
			        end
			        PAGE_PROGRAMMING: begin
			            if(qspi_cmd !=PAGE_PROGRAMMING) 
			    	        `uvm_error("Scoreboard",$sformatf("Expect get PAGE_PROGRAMMING while get Reg_8 = 0x%h ",qspi_reg['hc]));
                        laddr = transaction_qspi.addr;
                        data_width =  qspi_reg['h14][31:16];
                        data_wait_width=data_width;
                        for(int i=0;i<data_width;i=i+32) begin

                            if(data_wait_width>32) begin
                                data_wait_width = data_wait_width - 32; 
                                data_chk_width = 32;
                            end else begin
                                data_chk_width = data_wait_width;
                            end
                            
                            dev_value = device_data[laddr] >> (32-data_chk_width);
                            mon_value = transaction_qspi.data[laddr]; 

			                if(dev_value != mon_value)
			    	          `uvm_error("Scoreboard",$sformatf("Expect write device data[%h] 0x%h while get 0x%h",laddr,device_data[laddr],transaction_qspi.data[laddr]));
                            laddr = laddr+4;
                        end
                        qspi_is_write_busy = 0;
                    end
                    default: begin
                        if((cmd_width ==0) && (transaction_qspi.qspi_write==0)) begin
                             if(addr_width != 0)
                                 laddr = transaction_qspi.addr;
                             else 
                                 laddr = 'ha55a;
                             data_width =  qspi_reg['h14][31:16];
                             for(int i=0;i<data_width;i=i+32) begin
			    	           rdata_fifo.push_back(transaction_qspi.data[laddr]);
                               `uvm_info("QSPI SCOREBOARD", $sformatf("rdata_fifo push back addr %h, data %h",laddr,transaction_qspi.data[laddr]),UVM_HIGH)
			                   if(device_data[laddr] != transaction_qspi.data[laddr])
			    	              `uvm_error("Scoreboard",$sformatf("Expect read device data[%h] 0x%h while get 0x%h",laddr,device_data[laddr],transaction_qspi.data[laddr]));
                               laddr = laddr+4;
                             end                             
                        end
                    end
	 	        endcase
		    end
        join
	endtask: run
endclass: qspi_scoreboard
