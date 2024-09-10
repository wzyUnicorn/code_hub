class qspi_reg_rw_sequence extends uvm_sequence#(apb_txn);
	`uvm_object_utils(qspi_reg_rw_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        bit [31:0] rdata=0;
        bit [31:0] wdata=0;

        uvm_status_e status;
        uvm_reg regs[$];
        p_sequencer.qspi_rgm.get_registers(regs);
        foreach(regs[i]) begin
            wdata = $random;
            if(regs[i].get_name == "SPI_STATUS" || regs[i].get_name == "SPI_TXFIFO" || regs[i].get_name == "SPI_RXFIFO" )
                p_sequencer.qspi_rgm.default_map.set_check_on_read(0);
            else
                p_sequencer.qspi_rgm.default_map.set_check_on_read(1);

            regs[i].write(status,wdata);
            regs[i].read(status,rdata);
        end
        `uvm_info("QSPI_BASIC_TEST", $sformatf("Get read data %h",rdata),UVM_LOW)
	endtask: body
endclass: qspi_reg_rw_sequence
