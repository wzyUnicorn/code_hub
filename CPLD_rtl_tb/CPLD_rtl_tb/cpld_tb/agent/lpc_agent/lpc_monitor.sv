class lpc_monitor extends uvm_monitor;
    `uvm_component_utils(lpc_monitor)
    virtual cpld_if vif;
    uvm_analysis_port#(lpc_transaction) map;
    lpc_transaction sent2scb; 

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        if(!uvm_config_db#(virtual cpld_if)::get(this,"","vif",vif))
            `uvm_error("LPC Monitor","miss the vif!!")
        map=new("map",this);
    endfunction

    task main_phase(uvm_phase phase);
        lpc_transaction tr;
        forever begin
            tr=new("tr");
            @(negedge vif.i_Frame);
            @(posedge vif.i_Frame);
            tr.start = vif.io_LAD;
            @(posedge vif.LPCclk);         // monitor sampling delay a clock
            @(posedge vif.LPCclk);         // cycle type
            tr.cyctype = vif.io_LAD;
            `uvm_info("Slave Monitor",$sformatf("sampling cyctype = %h",tr.cyctype),UVM_HIGH)
            for(int i=4;i>=1;i--) begin // addr
                @(posedge vif.LPCclk);
                tr.addr[(4*i-1) -: 4] = vif.io_LAD;
            end
            `uvm_info("Slave Monitor",$sformatf("sampled addr = %h",tr.addr),UVM_HIGH)
            if(tr.cyctype[1]==1) // I/O cycle write
            begin
                @(posedge vif.LPCclk)      // data write
                tr.dataIn[3:0] = vif.io_LAD;
                @(posedge vif.LPCclk)
                tr.dataIn[7:4] = vif.io_LAD;
                repeat(2) @(posedge vif.LPCclk); // Host TAR
                @(posedge vif.LPCclk);     // peripheral SYNC
                tr.sync = vif.io_LAD;
                repeat(2) @(posedge vif.LPCclk); // peripheral TAR
            end
            else begin           // I/O cycle read
                repeat(2) @(posedge vif.LPCclk); // Host TAR
                @(posedge vif.LPCclk);     // SYNC
                @(posedge vif.LPCclk);     // SYNC
                tr.sync = vif.io_LAD;
                @(posedge vif.LPCclk)      // data read
                tr.dataOut[3:0] = vif.io_LAD;
                @(posedge vif.LPCclk)
                tr.dataOut[7:4] = vif.io_LAD;
                repeat(2) @(posedge vif.LPCclk); // Peri TAR
            end
            @(negedge vif.LPCclk) $cast(sent2scb,tr);
            map.write(sent2scb);
            `uvm_info("Slave Monitor","send tr to Scoreboard",UVM_HIGH)
        end
    endtask
endclass
