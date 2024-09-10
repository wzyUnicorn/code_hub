class qspi_soft_reset_sequence extends uvm_sequence#(apb_txn);
	`uvm_object_utils(qspi_soft_reset_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        bit [31:0] rdata=0;
        bit [31:0] addr;
        bit [31:0] wdata;
        uvm_status_e status;

        addr = $random();
        wdata = $random();
//      Write SPI Device 

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00020000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,'h201010);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf08);
        p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);

        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf10);   // sw reset 

        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h55aaaa55);  // set h55aaaa55

	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

//      Read SPI Device 

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00030000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,'h201010);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf04);
        p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf10);   // sw reset 
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

        `uvm_info("QSPI_BASIC_TEST", $sformatf("Get read data %h",rdata),UVM_LOW)
	endtask: body

endclass: qspi_soft_reset_sequence
