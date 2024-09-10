class qspi_nquad_addr_data_sequence extends uvm_sequence#(apb_txn);
    rand bit [15:0] data_length;
    rand bit [5:0]  addr_length;
    rand bit [5:0]  cmd_length;
    virtual qspi_if qspi_vif;

	`uvm_object_utils(qspi_nquad_addr_data_sequence)
    `uvm_declare_p_sequencer(qspi_virtual_sequencer);

	function new(string name = "");
		super.new(name);
	endfunction: new

    constraint qspi_length_c {
        data_length  inside {[4:128]};
        addr_length  inside {[4:32]};
        cmd_length   inside {[4:32]};
        data_length[2:0] == 0;
        addr_length[2:0] == 0;
        cmd_length[2:0]  == 0;
    } 

	task body();
        bit [31:0] rdata=0;
        bit [31:0] addr;
        bit [31:0] wdata;
        uvm_status_e status;
        this.randomize();

        cmd_length = 8;
        data_length = 64;
        addr_length = 16;

        addr = $random();
        wdata = $random();
        wdata[31:16] = data_length;
        wdata[13:8] = addr_length;
        wdata[5:0] =  cmd_length;
        #10ns;
        uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),"uvm_test_top.env.qspi_mon","qspi_vif",qspi_vif);

        qspi_vif.spi_quad_mode = 0;

//      Write SPI Device 
//----------------------case 1.1-------------------------------------
//      CMD length ==0 && addr_length  != 0 && data_length != 0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 0 CMD length !=0 && addr_length  != 0 && data_length != 0 && dump_len == 0 "),UVM_LOW)

        qspi_vif.addr_width = addr_length;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;
        qspi_vif.rdata_addr_dummy = 0;
        qspi_vif.wdata_addr_dummy = 0;
        qspi_vif.spi_rw = 0;


        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h02000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hdeadbeef);

        wdata[31:16] = data_length;
        wdata[13:8] = addr_length;
        wdata[5:0] =  cmd_length;

        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,0);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

//----------------------case 1.2-------------------------------------
//      CMD length ==0 && addr_length  != 0 && data_length != 0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 1 CMD length ==0 && addr_length  != 0 && data_length != 0 && dump_len != 0 "),UVM_LOW)

        qspi_vif.addr_width = addr_length;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = 0;
        qspi_vif.rdata_addr_dummy = 8;
        qspi_vif.wdata_addr_dummy = 8;
        qspi_vif.spi_rw = 0;

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h02000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hdeadbeef);

        wdata[31:16] = data_length;
        wdata[13:8] = addr_length;
        wdata[5:0] =  0;

        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

//----------------------case 2-------------------------------------
//      CMD length ==0 && addr_length == 0 && data_length  != 0 
//-----------------------------------------------------------------

        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 2 CMD length ==0 && addr_length  == 0 && data_length != 0 && dump_len != 0  "),UVM_LOW)

        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = 0;
        qspi_vif.rdata_addr_dummy = 8;
        qspi_vif.wdata_addr_dummy = 8;
        qspi_vif.spi_rw = 0;


        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h02000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hdeadbeef);

        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  0;
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

//----------------------case 3-------------------------------------
//      CMD length ==0 && addr_length == 0 && data_length  != 0 && dump_len
//      ==0 
//-----------------------------------------------------------------

        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 3 CMD length ==0 && addr_length  == 0 && data_length != 0 && dump_len == 0 "),UVM_LOW)

        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = 0;
        qspi_vif.rdata_addr_dummy = 0;
        qspi_vif.wdata_addr_dummy = 0;
        qspi_vif.spi_rw = 0;

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h02000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hdeadbeef);

        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  0;
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        wdata = 0;
        p_sequencer.qspi_rgm.SPI_DUM.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end


//----------------------case 4-------------------------------------
//      CMD length !=0 && addr_length == 0 && data_length  != 0 && dump_len
//      !=0 
//-----------------------------------------------------------------

        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 4 CMD length !=0 && addr_length  == 0 && data_length != 0 && dump_len != 0  "),UVM_LOW)

        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;
        qspi_vif.rdata_addr_dummy = 8;
        qspi_vif.wdata_addr_dummy = 8;
        qspi_vif.spi_rw = 0;

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h02000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hdeadbeef);

        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  cmd_length;
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

//----------------------case 5-------------------------------------
//      CMD length !=0 && addr_length == 0 && data_length  != 0 && dump_len
//      ==0 
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 5 CMD length !=0 && addr_length  == 0 && data_length != 0 && dump_len == 0  "),UVM_LOW)
        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;
        qspi_vif.rdata_addr_dummy = 0;
        qspi_vif.wdata_addr_dummy = 0;
        qspi_vif.spi_rw = 0;

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h02000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'h12345678);
        p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,'hdeadbeef);


        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  cmd_length;
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        wdata = 0;
        p_sequencer.qspi_rgm.SPI_DUM.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);
        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
        


//      Read SPI Device 

//----------------------case 6.1-------------------------------------
//      CMD length ==0 && addr_length  != 0 && data_length != 0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 6 read CMD length !=0 && addr_length  != 0 && data_length != 0  && dump_len == 0 "),UVM_LOW)

        qspi_vif.addr_width = addr_length;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;
        qspi_vif.rdata_addr_dummy = 0;
        qspi_vif.wdata_addr_dummy = 0;
        qspi_vif.spi_rw = 1;

        wdata[31:16] = data_length;
        wdata[13:8]  = addr_length;
        wdata[5:0]   = cmd_length;

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h03000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h0);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h101);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

//----------------------case 6.2-------------------------------------
//      CMD length ==0 && addr_length  != 0 && data_length != 0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 6 read CMD length ==0 && addr_length  != 0 && data_length != 0  && dump_len != 0 "),UVM_LOW)

        qspi_vif.addr_width = addr_length;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = 0;
        qspi_vif.rdata_addr_dummy = 8;
        qspi_vif.wdata_addr_dummy = 8;
        qspi_vif.spi_rw = 1;

        wdata[31:16] = data_length;
        wdata[13:8] = addr_length;
        wdata[5:0] =  0;
        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h03000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h101);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

//----------------------case 7-------------------------------------
//      CMD length ==0 && addr_length  == 0 && data_length != 0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 7 read CMD length ==0 && addr_length  == 0 && data_length != 0 && dump_len != 0  "),UVM_LOW)
        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = 0;
        qspi_vif.rdata_addr_dummy = 8;
        qspi_vif.wdata_addr_dummy = 8;
        qspi_vif.spi_rw = 1;

        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  0;
        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h03000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h101);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

//----------------------case 8-------------------------------------
//      CMD length ==0 && addr_length  == 0 && data_length != 0 && dum==0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 8 read CMD length ==0 && addr_length  == 0 && data_length != 0 && && dump_len == 0 "),UVM_LOW)
        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = 0;
        qspi_vif.rdata_addr_dummy = 0;
        qspi_vif.wdata_addr_dummy = 0;
        qspi_vif.spi_rw = 1;

        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  0;
        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h03000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h0);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h101);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);

//----------------------case 9-------------------------------------
//      CMD length ==0 && addr_length  != 0 && data_length != 0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 9 read CMD length !=0 && addr_length  == 0 && data_length != 0 && dump_len != 0  "),UVM_LOW)
        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;
        qspi_vif.rdata_addr_dummy = 8;
        qspi_vif.wdata_addr_dummy = 8;
        qspi_vif.spi_rw = 1;

        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  cmd_length;
        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h03000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h080008);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h101);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);


//----------------------case 10-------------------------------------
//      CMD length ==0 && addr_length  != 0 && data_length != 0
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 10 read CMD length !=0 && addr_length  == 0 && data_length != 0 && dump_len == 0  "),UVM_LOW)
        qspi_vif.addr_width = 0;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;
        qspi_vif.rdata_addr_dummy = 0;
        qspi_vif.wdata_addr_dummy = 0;
        qspi_vif.spi_rw = 1;

        wdata[31:16] = data_length;
        wdata[13:8] = 0;
        wdata[5:0] =  cmd_length;
        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h03000000);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);
        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_DUM.write(status,'h0);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h101);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end
		
        p_sequencer.qspi_rgm.SPI_RXFIFO.read(status,rdata);


//----------------------case 11-------------------------------------
//      CMD WRITE_ENABLE in Single mode
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 11 CMD WRITE_ENABLE in Single mode  "),UVM_LOW)
        qspi_vif.command_width = cmd_length;
        qspi_vif.spi_rw = 0;

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h06000000);

        wdata[31:16] = 0;
        wdata[13:8] = 0;
        wdata[5:0] =  cmd_length;

        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end


//----------------------case 12-------------------------------------
//      CMD WRITE_DISABLE in Single mode
//-----------------------------------------------------------------
        `uvm_info("QSPI_BASIC_TEST", $sformatf("case 12 CMD WRITE_DISABLE in Single mode  "),UVM_LOW)
        qspi_vif.command_width = cmd_length;
        qspi_vif.spi_rw = 0;

        p_sequencer.qspi_rgm.SPI_CMD.write(status,'h04000000);

        wdata[31:16] = 0;
        wdata[13:8] = 0;
        wdata[5:0] =  cmd_length;

        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'h102);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end        

	endtask: body

endclass: qspi_nquad_addr_data_sequence
