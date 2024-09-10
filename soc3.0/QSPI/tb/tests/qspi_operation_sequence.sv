typedef enum {
    QSPI_WRITE_ENABLE =32'h6 , 
    QSPI_WRITE_DISABLE =32'h4 , 
    QSPI_READ_DATA =32'h3,
    QSPI_PAGE_PROGRAMMING = 32'h2
} qspi_command_e;

class qspi_operation_sequence extends uvm_sequence#(apb_txn);
    rand bit [15:0] data_length;
    rand bit [5:0]  addr_length;
    rand bit [5:0]  cmd_length;
    rand qspi_command_e command;
    rand bit        qspi_read_write;
    rand bit [31:0] rdata_addr_dummy;
    rand bit [31:0] wdata_addr_dummy;
    rand bit [31:0] addr;
    rand bit [31:0] data1;  
    rand bit [31:0] data2;  
    rand bit [31:0] data3;  
    rand bit [31:0] data4;  


    virtual qspi_if qspi_vif;

	`uvm_object_utils_begin(qspi_operation_sequence)
    `uvm_field_enum(qspi_command_e,command, UVM_ALL_ON)
    `uvm_field_int(cmd_length, UVM_ALL_ON)
    `uvm_field_int(addr_length, UVM_ALL_ON)
    `uvm_field_int(data_length, UVM_ALL_ON)
    `uvm_field_int(rdata_addr_dummy, UVM_ALL_ON)
    `uvm_field_int(wdata_addr_dummy, UVM_ALL_ON)
    `uvm_field_int(qspi_read_write, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data1, UVM_ALL_ON)
    `uvm_field_int(data2, UVM_ALL_ON)
    `uvm_field_int(data3, UVM_ALL_ON)
    `uvm_field_int(data4, UVM_ALL_ON)
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(qspi_virtual_sequencer);

    constraint qspi_length_c {
        data_length  inside {0,32,64,96,128};
        addr_length  inside {0,8,16,24,32};
        cmd_length   inside {0,8,16,24,32};
        data_length[2:0] == 0;
        addr_length[2:0] == 0;
        cmd_length[2:0]  == 0;
    } 
    
    constraint command_c {
        (command==QSPI_READ_DATA) -> (qspi_read_write==1);
        (command==QSPI_PAGE_PROGRAMMING) -> (qspi_read_write==0);
        (command==QSPI_READ_DATA) -> (data_length > 0);
        (command==QSPI_PAGE_PROGRAMMING) -> (data_length > 0);
    }
 
    constraint qspi_write_enable_c {
        if(command==QSPI_WRITE_ENABLE){
            qspi_read_write==0;
            data_length == 0;
            addr_length == 0;
            cmd_length >0;
        }
    }

    constraint qspi_write_disable_c {
        if(command==QSPI_WRITE_DISABLE){
            qspi_read_write==0;
            data_length == 0;
            addr_length == 0;
            cmd_length > 0;
        }
    }

    constraint addr_c {
        addr inside {[32'h0:32'h1000],[32'h3320:32'h4000],[32'h6500:32'h6665],[32'h6666:32'h9998],[32'hcc00:32'hd000],[32'hff00:32'hffff]};
    }

    constraint dummy_c {
        rdata_addr_dummy inside {0,8,16};
        wdata_addr_dummy inside {0,8,16};
    }

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        bit [31:0] rdata=0;
        bit [31:0] wdata=0;
        uvm_status_e status;

        uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),"uvm_test_top.env.qspi_mon","qspi_vif",qspi_vif);

        `uvm_info("QSPI_OPERATION_TEST", $sformatf(" QSPI Operation start addr_length %h !",addr_length),UVM_LOW)

        qspi_vif.addr_width = addr_length;
        qspi_vif.data_width = data_length;
        qspi_vif.command_width = cmd_length;
        qspi_vif.rdata_addr_dummy = rdata_addr_dummy;
        qspi_vif.wdata_addr_dummy = wdata_addr_dummy;
        qspi_vif.spi_rw = qspi_read_write;

        wdata = command << (32-cmd_length);
        p_sequencer.qspi_rgm.SPI_CMD.write(status,wdata);
        p_sequencer.qspi_rgm.SPI_ADR.write(status,addr);

        if(qspi_read_write==0) begin
             if(data_length>0)
                p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,data1);
             if(data_length>32)
                p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,data2);
             if(data_length>64)
                p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,data3);
             if(data_length>96) 
                p_sequencer.qspi_rgm.SPI_TXFIFO.write(status,data4);
        end

        wdata[31:16] = data_length;
        wdata[13:8] = addr_length;
        wdata[5:0] =  cmd_length;

        p_sequencer.qspi_rgm.SPI_LEN.write(status,wdata);
        wdata[31:16] = wdata_addr_dummy;
        wdata[15:0]  = rdata_addr_dummy;
        p_sequencer.qspi_rgm.SPI_DUM.write(status,wdata);

        if(qspi_read_write==1)
            p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf04);
        else
            p_sequencer.qspi_rgm.SPI_CTRL.write(status,'hf08);

        rdata = 0;
	    while(rdata[5:0]!=1) begin
           p_sequencer.qspi_rgm.SPI_STATUS.read(status,rdata);
	    end

        `uvm_info("QSPI_OPERATION_TEST", $sformatf(" QSPI Operation Done !"),UVM_LOW)

	endtask: body

endclass: qspi_operation_sequence
