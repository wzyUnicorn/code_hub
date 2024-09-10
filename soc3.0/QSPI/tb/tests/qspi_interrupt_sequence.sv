class qspi_interrupt_sequence extends uvm_sequence#(apb_txn);
     rand bit[4:0]  TXTH;
     rand bit[4:0]  RXTH;
     virtual qspi_if qspi_vif;


	`uvm_object_utils(qspi_interrupt_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

    constraint INTCFG_con {
        TXTH inside {[1:6]};
        RXTH inside {[1:4]};
    } 

	task body();
        bit [31:0] rdata=0;
        bit [31:0] addr;
        bit [31:0] wdata;

        uvm_status_e status;

        addr = $random();
        wdata[31] = 1;
        wdata[12:8] = RXTH; 
        wdata[4:0] = TXTH; 

        uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),"uvm_test_top.env.qspi_mon","qspi_vif",qspi_vif);
        qspi_vif.data_width =64;
//      Write SPI Device 

        p_sequencer.qspi_rgm.SPI_INTCFG.write(status,wdata);

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00020000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hfeedbeef);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'habcddcba);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h87654321);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h5aa5a55a);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,'h401010);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);

        if(TXTH <5) begin    //bug here,error
            if(qspi_vif.interrupt == 0) begin
                `uvm_error("qspi_interrupt_test",$sformatf("Unexpect interrupt happened TXTH %h !",TXTH));
            end
        end

        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf08);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

      //  p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf08);

      //  rdata = 0;
	  //  while(rdata[5:0]!=1) begin
      //     p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	  //  end

        if(TXTH <3) begin
            if(qspi_vif.interrupt == 0) begin
                `uvm_error("qspi_interrupt_test",$sformatf("Unexpect interrupt happened TXTH %h  !",TXTH));
            end
        end
        else begin
            if(qspi_vif.interrupt != 0) begin
                `uvm_error("qspi_interrupt_test",$sformatf("Expect interrupt not happened TXTH %h  !",TXTH));
            end
        end


//      Read SPI Device 

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00030000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,'h401010);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf04);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

    //    p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf04);
    //    rdata = 0;
	//    while(rdata[5:0]!=1) begin
    //       p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	//    end

        if(RXTH <2 || TXTH <3) begin
            if(qspi_vif.interrupt == 0) begin
                `uvm_error("qspi_interrupt_test",$sformatf("Expect interrupt not happened RXTH %h !",RXTH));
            end
        end
        else begin
            if(qspi_vif.interrupt != 0) begin
                `uvm_error("qspi_interrupt_test",$sformatf("Unexpect interrupt happened RXTH %h  !",RXTH));
            end
        end


        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);


        `uvm_info("QSPI_BASIC_TEST", $sformatf("Get read data %h",rdata),UVM_LOW)
	endtask: body

endclass: qspi_interrupt_sequence
