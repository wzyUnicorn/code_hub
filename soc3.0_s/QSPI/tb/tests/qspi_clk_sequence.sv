class qspi_clk_sequence extends uvm_sequence#(apb_txn);
	`uvm_object_utils(qspi_clk_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        bit [31:0] rdata=0;
        bit [31:0] addr;
        bit [31:0] wdata;
        bit [7:0] clk_div;
        uvm_status_e status;

        addr = $random();
        wdata = $random();
        clk_div = $random();

//      Write SPI Device 
        p_sequencer.qspi_rgm.SPI_CLKDIV.write(status,clk_div);
        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h00020000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,'h201010);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf08);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

       clk_div = $random();
        p_sequencer.qspi_rgm.SPI_CLKDIV.write(status,clk_div);

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

endclass: qspi_clk_sequence
