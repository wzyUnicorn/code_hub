class qspi_fun_cov extends uvm_component;

parameter WRITE_ENABLE = 'h6;
parameter WRITE_DISABLE = 'h4;
parameter READ_DATA = 'h3;
parameter PAGE_PROGRAMMING = 'h2;


	`uvm_component_utils(qspi_fun_cov)
    uvm_analysis_imp #(qspi_txn,qspi_fun_cov) qspi_imp;
	qspi_txn transaction_qspi;

	virtual qspi_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
        transaction_qspi         = new("transaction_qspi");
        cov_qspi = new();
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		qspi_imp  = new("qspi_imp", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
	endfunction: connect_phase
 
    task run_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual qspi_if)::get(uvm_root::get(),this.get_full_name(),"qspi_vif", vif)) begin
            `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
        end
  	endtask: run_phase
        
    function write(qspi_txn tr);
        tr.print();

        if(!$cast(transaction_qspi, tr)) begin
           `uvm_fatal("NOT_APB_TYPES","Provided transaction_qspi is not correct type");
        end
        `uvm_info("QSPI Coverage ", "Get transaction_qspi here  ",UVM_HIGH)
        transaction_qspi.print();
        cov_qspi.sample();
    endfunction 

    covergroup cov_qspi;

        command:coverpoint transaction_qspi.command {
               bins WRITE_ENABLE = {6};
               bins WRITE_DISABLE = {4};
               bins READ_DATA = {3};
               bins PAGE_PROGRAMMING = {2};
        }

        addr :coverpoint  transaction_qspi.addr { 
            option.auto_bin_max =5; 
        }

        read_write : coverpoint transaction_qspi.qspi_write {
               bins read = {0};
               bins write = {1};
        }

        cmd_width: coverpoint vif.command_width {
               bins command_width_zero =  {0};
               bins command_width_8bit =  {8};
               bins command_width_16bit =  {16};
               bins command_width_24bit =  {24};
               bins command_width_32bit =  {32};
        }

        data_width: coverpoint vif.data_width {
               bins data_width_32bit =   {32};
               bins data_width_64bit =   {64};
               bins data_width_128bit =  {128};
        }

        spi_quad_mode: coverpoint vif.spi_quad_mode {
               bins quad_mode = {1};
               bins single_mode = {0};
        }

        rdata_addr_dummy: coverpoint vif.rdata_addr_dummy {
               bins rdata_addr_dummy_zero   =  {0};
               bins rdata_addr_dummy_8cycle =  {8};
        }

        wdata_addr_dummy: coverpoint vif.wdata_addr_dummy {
               bins wdata_addr_dummy_zero   =  {0};
               bins wdata_addr_dummy_8cycle =  {8};
        }
        
        cp_command_spi_quad_mode: cross command,spi_quad_mode;

        cp_command_cmd_width:   cross command,cmd_width;

        cp_command_data_width:  cross command,data_width;

        cp_command_rdata_dummy: cross command,rdata_addr_dummy {
            bins cp_cmd_dummy = binsof(command) intersect{READ_DATA};
        }

        cp_command_wdata_dummy: cross command,wdata_addr_dummy {
            ignore_bins  ign_write_enable=binsof(command) intersect{WRITE_ENABLE};
            ignore_bins  ign_write_disable=binsof(command) intersect{WRITE_DISABLE};
            ignore_bins  ign_read_data=binsof(command) intersect{READ_DATA};
        }

    endgroup



endclass: qspi_fun_cov
