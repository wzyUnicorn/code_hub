class qspi_add_fun_cov_sequence extends uvm_sequence#(apb_txn);

	`uvm_object_utils(qspi_add_fun_cov_sequence)
    `uvm_declare_p_sequencer(qspi_virtual_sequencer);

    qspi_operation_sequence qspi_op_seq;

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        `uvm_do_on_with(qspi_op_seq,p_sequencer,
         {
             command == QSPI_WRITE_DISABLE;
             cmd_length == 24;
         })
         `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

        `uvm_do_on_with(qspi_op_seq,p_sequencer,
         {
             command == QSPI_WRITE_DISABLE;
             cmd_length == 32;
         })
         `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

        `uvm_do_on_with(qspi_op_seq,p_sequencer,
         {
             command == QSPI_WRITE_DISABLE;
             rdata_addr_dummy == 0;
         })
         `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

        `uvm_do_on_with(qspi_op_seq,p_sequencer,
         {
             command == QSPI_WRITE_ENABLE;
             rdata_addr_dummy == 0;
         })
         `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)


        `uvm_do_on_with(qspi_op_seq,p_sequencer,
         {
             command == QSPI_PAGE_PROGRAMMING;
             cmd_length == 32;
         })
         `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

        `uvm_do_on_with(qspi_op_seq,p_sequencer,
         {
             command == QSPI_READ_DATA;
             cmd_length == 32;
             data_length == 128;
         })
         `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

	endtask: body

endclass: qspi_add_fun_cov_sequence
