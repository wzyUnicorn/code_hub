class iic_monitor extends uvm_monitor;
    `uvm_component_utils(iic_monitor)
    virtual cpld_if vif;
    uvm_analysis_port#(iic_transaction) map;
    uvm_event trans_start;
    iic_transaction sda, tr; 

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        if(!uvm_config_db#(virtual cpld_if)::get(this,"","vif",vif))
            `uvm_error("monitor","miss the vif!!")
        map=new("map",this);
        trans_start=uvm_event_pool::get_global("trans_start");
    endfunction

    task main_phase(uvm_phase phase);
        forever begin
            tr=new("tr");
            trans_start.wait_trigger();   //start transmiting addr
            `uvm_info("Slave monitor","start sampling addr",UVM_HIGH)
            for(int i=6;i>=0;i--) begin
                @(posedge vif.scl);
                tr.addr[i] = vif.io_sda;
            end
            @(posedge vif.scl);
            tr.trans = vif.io_sda;

            //trans_data.wait_trigger();    //start transmiting reg addr and data
            @(posedge vif.scl); // slave ack

            if(tr.trans==0) begin
            for(int j=7;j>=0;j--) begin
                @(posedge vif.scl);
                tr.regAddr[j] = vif.io_sda;    //master out, slave in
            end
            @(posedge vif.scl);
            for(int k=7;k>=0;k--) begin
                @(posedge vif.scl);
                tr.dataIN[k] = vif.io_sda;     //master out, slave in
            end
            @(posedge vif.scl);                //slave ack data
                tr.ack = vif.io_sda;
            end
            else 
            for(int l=7;l>=0;l--) begin
                @(posedge vif.scl);
                tr.dataOUT[l] = vif.io_sda;    //master in, slave out
            end
            $cast(sda,tr); //$cast(sda,tr.do_copy);
            map.write(sda);
        end
    endtask
endclass
