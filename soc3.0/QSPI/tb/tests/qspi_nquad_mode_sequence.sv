class qspi_nquad_mode_sequence extends uvm_sequence#(apb_txn);
    virtual qspi_if qspi_vif;
	`uvm_object_utils(qspi_nquad_mode_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        bit [31:0] rdata=0;
        uvm_status_e status;
        uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),"uvm_test_top.env.qspi_mon","qspi_vif",qspi_vif);

//              Write SPI Device 
        qspi_vif.spi_quad_mode = 0;

//case write disable
		reg_write('hc,'h00040000);   //CMD
		reg_write('h10,'hdeadbeef);  //ADDR
	    reg_write('h14,'h10);    // LENGTH
	    reg_write('h1c,'h12345678);    // TX DATA FIFO
		reg_write('h18,'h080008);    //DUM
		reg_write('h00,'h102);       // CTRL

        rdata = 0;
	    while(rdata[5:0]!=1) begin
		   reg_read('h4,rdata);
	    end

//case write disable
		reg_write('hc,'h00060000);   //CMD
		reg_write('h10,'hdeadbeef);  //ADDR
	    reg_write('h14,'h10);    // LENGTH
	    reg_write('h1c,'h12345678);    // TX DATA FIFO
		reg_write('h18,'h080008);    //DUM
		reg_write('h00,'h102);       // CTRL

        rdata = 0;
	    while(rdata[5:0]!=1) begin
		   reg_read('h4,rdata);
	    end


// case page program 
		reg_write('hc,'h00020000);   //CMD
		reg_write('h10,'hdeadbeef);  //ADDR
	    reg_write('h14,'h201010);    // LENGTH
	    reg_write('h1c,'h12345678);    // TX DATA FIFO
		reg_write('h18,'h080008);    //DUM
		reg_write('h00,'h102);       // CTRL

        rdata = 0;
	    while(rdata[5:0]!=1) begin
		   reg_read('h4,rdata);
	    end


// case Read SPI Device 
		reg_write('hc,'h00030000);   //CMD
		reg_write('h10,'hdeadbeef);  //ADDR
		reg_write('h14,'h201010);    //LENGTH
		reg_write('h00,'h101);       //CTRL

        rdata = 0;
	    while(rdata[5:0]!=1) begin
		   reg_read('h4,rdata);
	    end
		
		reg_read('h20,rdata);

        `uvm_info("QSPI_BASIC_TEST", $sformatf("Get read data %h",rdata),UVM_LOW)
	endtask: body

	task reg_write(bit[11:0] addr,bit[31:0] data);
		apb_txn apb_tx;
		apb_tx = apb_txn::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
                `uvm_do_on_with(apb_tx,p_sequencer.apb_sqr,{
		    apb_tx.pdata == data;
	            apb_tx.paddr == addr;
		    apb_tx.pwrite == 1;
		 });
		get_response(rsp);
	endtask

	task reg_read(bit[11:0] addr,ref bit[31:0] data);
		apb_txn apb_tx;
		apb_tx = apb_txn::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
                `uvm_do_on_with(apb_tx,p_sequencer.apb_sqr,{
	            apb_tx.paddr == addr;
		    apb_tx.pwrite == 0;		
		});
		get_response(rsp);
		data = apb_tx.pdata;
	endtask


endclass: qspi_nquad_mode_sequence
