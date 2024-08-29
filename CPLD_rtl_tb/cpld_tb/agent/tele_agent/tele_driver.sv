class tele_driver extends uvm_driver#(tele_ctrl_item);
    `uvm_component_utils(tele_driver)
    virtual cpld_if vif;
    tele_ctrl_item seq_item;
    uvm_analysis_port#(tele_ctrl_item) ap;

    function new(string name,uvm_component parent);
        super.new(name,parent);
        ap=new("ap",this);
    endfunction
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        if(!uvm_config_db#(virtual cpld_if)::get(this,"","vif",vif))
        `uvm_error("IPMI Driver","Miss virtual interface !!")
    endfunction

    virtual task main_phase(uvm_phase phase);
        repeat(10) @(posedge vif.clk);

        forever begin
        seq_item_port.get_next_item(seq_item);
        `uvm_info("IPMI Driver",$sformatf("IPMI control, do action=2'b%b",seq_item.do_action),UVM_LOW)
        ap.write(seq_item);

        @(posedge vif.clk);
        vif.i_AST_act_n=0;
        @(posedge vif.clk);
        case(seq_item.do_action)
            AST_ON: begin vif.i_AST_PWROn_n=0;
                    repeat(8) @(posedge vif.clk);
                    vif.i_AST_PWROn_n=1;
                    vif.i_AST_act_n=1;
                    @(posedge vif.o_CPLD_INT);
                    end
            AST_RST:begin vif.i_AST_Reset_n=0; 
                    repeat(8) @(posedge vif.clk);
                    vif.i_AST_Reset_n=1;
                    end
            AST_OFF:begin vif.i_AST_PWROff_n=0;
                    repeat(8) @(posedge vif.clk);
                    vif.i_AST_PWROff_n=1;
                    end
            default:vif.i_AST_act_n=1;
        endcase
        @(posedge vif.clk);
        vif.i_AST_act_n=1;

        repeat(25) @(posedge vif.clk);       // wait 23 clk at least
        `uvm_info("IPMI Driver","seq_item done",UVM_LOW)
        seq_item=null;
        seq_item_port.item_done();
        end
    endtask

endclass
