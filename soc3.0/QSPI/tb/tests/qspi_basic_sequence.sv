class qspi_basic_sequence extends uvm_sequence#(apb_txn);
	`uvm_object_utils(qspi_basic_sequence)
        `uvm_declare_p_sequencer(qspi_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        bit [31:0] rdata=0;
        uvm_status_e status;
//              Write SPI Device 
        p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hdead1234);
		reg_write('h8,'h00020000);
		reg_write('hc,'hdeadbeef);
		reg_write('h18,'h12345678);
	        reg_write('h10,'h201010);
		reg_write('h14,'h080008);
		reg_write('h00,'hf08);

                rdata = 0;
	        while(rdata[5:0]!=1) begin
		   reg_read(0,rdata);
	        end

//              Read SPI Device 
		reg_write('h8,'h00030000);
		reg_write('hc,'hdeadbeef);
		reg_write('h10,'h201010);
		reg_write('h00,'hf04);
                rdata = 0;
	        while(rdata[5:0]!=1) begin
		   reg_read(0,rdata);
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


endclass: qspi_basic_sequence
