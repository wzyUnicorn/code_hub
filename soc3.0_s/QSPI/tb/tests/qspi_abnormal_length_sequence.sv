class qspi_abnormal_length_sequence extends uvm_sequence#(apb_txn);
    rand bit [15:0] data_length;
    rand bit [5:0]  addr_length;
    rand bit [5:0]  cmd_length;
    virtual qspi_if qspi_vif;

	`uvm_object_utils(qspi_abnormal_length_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

    constraint qspi_length_c {
        data_length  inside {[0:16]};
        addr_length  inside {[0:16]};
        cmd_length   inside {[0:16]};
        data_length[2:0] == 0;
        addr_length[2:0] == 0;
        cmd_length[2:0]  == 0;
    } 

	task body();
        bit [31:0] rdata=0;
        bit [31:0] addr;
        bit [31:0] wdata;
        uvm_status_e status;

        addr = $random();
        wdata = $random();
        wdata[31:16] = data_length;
        wdata[13:8] = addr_length;
        wdata[5:0] =  cmd_length;
        #10ns;
        uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),"uvm_test_top.env.qspi_mon","qspi_vif",qspi_vif);
        qspi_vif.addr_width = addr_length;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;


//      Write SPI Device 

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00020000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hdeadbeef);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'ha55aa55a);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h87654321);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'habcdabcd);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hfeedbeef);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf08);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

//      Read SPI Device 

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00030000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf04);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

        `uvm_info("QSPI_BASIC_TEST", $sformatf("Get read data %h",rdata),UVM_LOW)
	endtask: body

endclass: qspi_abnormal_length_sequence
