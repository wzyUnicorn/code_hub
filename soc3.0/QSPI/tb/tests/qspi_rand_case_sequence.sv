class qspi_rand_case_sequence extends uvm_sequence#(apb_txn);

	`uvm_object_utils(qspi_rand_case_sequence)
    `uvm_declare_p_sequencer(qspi_virtual_sequencer);

    qspi_operation_sequence qspi_op_seq;

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        bit [31:0] rdata=0;
        uvm_status_e status;

        for(int i=0;i<19;i++) begin
            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_PAGE_PROGRAMMING;
                qspi_read_write ==0;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_READ_DATA;
            })

            for(int j=0;j<qspi_op_seq.data_length;j=j+32) begin
                p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);
            end
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_DISABLE;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_ENABLE;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

        end
	endtask: body

endclass: qspi_rand_case_sequence
