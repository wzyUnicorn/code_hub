class qspi_dummy_sequence extends uvm_sequence#(apb_txn);
    rand bit [15:0]  dummy_write;
    rand bit [15:0]  dummy_read;
    virtual qspi_if qspi_vif;
    
	`uvm_object_utils(qspi_dummy_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

    constraint qspi_length_c {
        dummy_write  inside {[4:128]};
        dummy_read   inside {[4:128]};
    } 

	task body();
        bit [31:0] rdata=0;
        bit [31:0] addr;
        bit [31:0] wdata;
        uvm_status_e status;

        addr = $random();
        wdata[31:16] = dummy_write;
        wdata[15:0] = dummy_read;

        uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),"uvm_test_top.env.qspi_mon","qspi_vif",qspi_vif);
        qspi_vif.wdata_addr_dummy = dummy_write;
        qspi_vif.rdata_addr_dummy = dummy_read;
//      Write SPI Device 

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00020000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,'h201010);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf08);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

//      Read SPI Device 

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00030000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,'h201010);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf04);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

        `uvm_info("QSPI_BASIC_TEST", $sformatf("Get read data %h",rdata),UVM_LOW)
	endtask: body

endclass: qspi_dummy_sequence
