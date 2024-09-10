class qspi_direct_case_sequence extends uvm_sequence#(apb_txn);

	`uvm_object_utils(qspi_direct_case_sequence)
    `uvm_declare_p_sequencer(qspi_virtual_sequencer);

    qspi_operation_sequence qspi_op_seq;

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();

        bit[15:0] data_length_list[5]; 
        bit[5:0] addr_length_list[5]; 
        bit[5:0] cmd_length_list[5] ; 

        bit[31:0] rdata_addr_dummy_list[3];
        bit[31:0] wdata_addr_dummy_list[3];

        bit[15:0] addr_list[5]; 

        bit [31:0] rdata=0;
        uvm_status_e status;

        data_length_list = {0,32,64,96,128};
        addr_length_list = {0,8,16,24,32};
        cmd_length_list  = {0,8,16,24,32};
        rdata_addr_dummy_list = {0,8,16};
        wdata_addr_dummy_list = {0,8,16};
        addr_list = {5,'h3334,'h6668,'h9998,'hcccd};


        for(int i=0;i<5;i++) begin
            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_PAGE_PROGRAMMING;
                addr == addr_list[i];
                addr_length ==32;
                qspi_read_write ==0;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

        end

        for(int i=0;i<5;i++) begin
            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_PAGE_PROGRAMMING;
                if(i>0) data_length == data_length_list[i];
                qspi_read_write ==0;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_READ_DATA;
                if(i>0) data_length == data_length_list[i];
                qspi_read_write ==1;
            })
            for(int j=0;j<qspi_op_seq.data_length;j=j+32) begin
                p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);
            end
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

        end

        for(int i=0;i<5;i++) begin
            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_PAGE_PROGRAMMING;
                cmd_length == cmd_length_list[i];
                qspi_read_write ==0;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_READ_DATA;
                cmd_length == cmd_length_list[i];
                qspi_read_write ==1;
            })
            for(int j=0;j<qspi_op_seq.data_length;j=j+32) begin
                p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);
            end

            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_DISABLE;
                if(i>0) cmd_length == cmd_length_list[i];
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_ENABLE;
                if(i>0) cmd_length == cmd_length_list[i];
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)
        end


        for(int i=0;i<5;i++) begin
            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_PAGE_PROGRAMMING;
                addr_length == addr_length_list[i];
                qspi_read_write ==0;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_READ_DATA;
                addr_length == addr_length_list[i];
                qspi_read_write ==1;
            })
            for(int j=0;j<qspi_op_seq.data_length;j=j+32) begin
                p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);
            end

            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)
        end

        for(int i=0;i<3;i++) begin
            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_PAGE_PROGRAMMING;
                rdata_addr_dummy == rdata_addr_dummy_list[i];
                qspi_read_write ==0;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_READ_DATA;
                rdata_addr_dummy == rdata_addr_dummy_list[i];
                qspi_read_write ==1;
            })

            for(int j=0;j<qspi_op_seq.data_length;j=j+32) begin
                p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);
            end

            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_DISABLE;
                rdata_addr_dummy == rdata_addr_dummy_list[i];
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_ENABLE;
                rdata_addr_dummy == rdata_addr_dummy_list[i];
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)
        end

        for(int i=0;i<3;i++) begin
            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_PAGE_PROGRAMMING;
                wdata_addr_dummy ==  wdata_addr_dummy_list[i];
                qspi_read_write ==0;
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_READ_DATA;
                wdata_addr_dummy ==  wdata_addr_dummy_list[i];
                qspi_read_write ==1;
            })

            for(int j=0;j<qspi_op_seq.data_length;j=j+32) begin
                p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);
            end

            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_DISABLE;
                wdata_addr_dummy ==  wdata_addr_dummy_list[i];
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)

            `uvm_do_on_with(qspi_op_seq,p_sequencer,
            {
                command == QSPI_WRITE_ENABLE;
                wdata_addr_dummy ==  wdata_addr_dummy_list[i];
            })
            `uvm_info("QSPI_RAND_TEST", $sformatf("qspi_op_seq :\n %s",qspi_op_seq.sprint()),UVM_LOW)
        end
	endtask: body

endclass: qspi_direct_case_sequence
