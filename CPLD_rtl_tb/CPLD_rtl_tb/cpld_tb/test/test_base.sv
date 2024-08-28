class test_base extends uvm_test;
    `uvm_component_utils(test_base)

    environment env;
    virtual_sequencer vsqr;

    function new(string name="test_base",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=environment::type_id::create("env",this);
        vsqr=virtual_sequencer::type_id::create("vsqr",this);
        uvm_config_db#(uvm_object_wrapper)::set(this,"vsqr.main_phase","default_sequence",virtual_sequence_base::type_id::get());
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        vsqr.vbtn_sqr=env.btn_agt.sqr;
        vsqr.viic_sqr=env.iic_agt.sqr;
        vsqr.vlpc_sqr=env.lpc_agt.sqr;
        vsqr.vtel_sqr=env.tel_agt.sqr;
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.set_timeout(10000*31.25us,1);
        uvm_top.print_topology();
        factory.print();
    endfunction

    virtual function void report_phase(uvm_phase phase);
        uvm_report_server server;
        int error_num;
        super.report_phase(phase);
        server=get_report_server();
        error_num=server.get_severity_count(UVM_ERROR);
    endfunction

  /*virtual task main_phase(uvm_phase phase);
        virtual_sequence vseq;
        phase.raise_objection(this);
        vseq=new();
        vseq.start(vsqr);
        phase.drop_objection(this);
    endtask */

endclass
