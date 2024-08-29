class iic_driver2 extends uvm_driver#(iic_transaction);
    `uvm_component_utils(iic_driver2)

    virtual cpld_if vif;
    uvm_event trans_start; // trigger to monitor
    iic_transaction tr;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(uvm_config_db#(virtual cpld_if)::get(this,"","vif",vif))
            `uvm_info("IIC Driver","IIC driver get virtual interface.",UVM_HIGH)
        else `uvm_error("IIC Driver","IIC driver miss vif !!")
        trans_start=uvm_event_pool::get_global("trans_start");
    endfunction

    task main_phase(uvm_phase phase);
    bit ack; int byte_cycle;
    vif.sda_oe=1;       //sda output enable
    vif.sda_out =1;     //start as high
    forever begin
        seq_item_port.get_next_item(tr);
    fork
    begin:control_sda_out_en
        trans_start.wait_trigger();
        vif.sda_oe=1;
        if(tr.trans==0)
        repeat(3) begin
        repeat(8) @(posedge vif.scl);
        @(negedge vif.scl);
        repeat(3) @(posedge vif.clk);
        vif.sda_oe = 0;
        @(posedge vif.scl);     // iic slave acknowledge
        @(negedge vif.scl);
        repeat(2) @(posedge vif.clk);
        vif.sda_oe = 1;
        end
        else begin
        repeat(8) @(posedge vif.scl);
        @(negedge vif.scl);
        repeat(3) @(posedge vif.clk);
        vif.sda_oe = 0;
        @(posedge vif.scl);     // iic slave acknowledge
        @(negedge vif.scl);
        repeat(2) @(posedge vif.clk);
        repeat(8) @(posedge vif.scl);
        vif.sda_oe = 1;
        end
    end
    begin:driving_sda
        @(posedge vif.scl);
        @(negedge vif.clk); 
        vif.sda_out = 0;    //iic transmit start !
        trans_start.trigger();
        `uvm_info("IIC Driver","IIC transfer start",UVM_LOW)

        for(int i=0;i<=6;i++) begin     //master sent slave address
            @(posedge vif.scl2);
            vif.sda_out = tr.addr[6-i]; //MSB transfirstly
        end
        @(posedge vif.scl2);
            vif.sda_out = tr.trans;     //specify transmit direction
        @(posedge vif.scl);

        repeat(1) begin

        @(posedge vif.scl);     //slave ack
        if(vif.io_sda==1) begin
            `uvm_info("IIC Driver","IIC Slave did not acknowledge slave address, transmit interrupted!!",UVM_LOW)
            break;
        end 

        if(tr.trans==0) begin   //slave read data
        `uvm_info("IIC Driver","Master Writing",UVM_LOW)
            for(int j=7;j>=0;j--) begin //master sent reg addr
                @(posedge vif.scl2);
                vif.sda_out = tr.regAddr[j];
            end
            @(posedge vif.scl);
            
            @(posedge vif.scl); //slave ACK/NACK for reg addr
            if(vif.io_sda==1) begin
                `uvm_info("IIC Driver","IIC Slave did not Acknowledge reg addr transmit !!",UVM_LOW)
                break;
            end

            for(int k=7;k>=0;k--) begin //master sent data
                @(posedge vif.scl2);
                vif.sda_out = tr.dataIN[k];
            end
            @(posedge vif.scl);

            @(posedge vif.scl); //slave ACK/NACK for data
            if(vif.io_sda==1) begin
                `uvm_info("IIC Driver","IIC Slave did not Acknowledge data transmit !!",UVM_LOW)
                break;
            end
        end 
        else begin  //slave write data
            `uvm_info("IIC Driver","Master Reading",UVM_LOW)
            repeat(8) @(posedge vif.scl); //wait tb.monitor read
            @(negedge vif.scl);
            vif.sda_out=0;//master ACK for read data
        end

        end // end repeat(1)

        @(posedge vif.scl2);
        vif.sda_out=0;
        @(posedge vif.scl);
        @(negedge vif.clk);
        vif.sda_out=1; //transmit finish
        `uvm_info("IIC Driver","IIC transfer finish",UVM_LOW)
        end
        join_any

        if(tr.dataIN==8'h0f)
        fork
        wait(vif.o_CPLD_INT==1);
        forever @(posedge vif.clk);
        join_any disable fork;

        repeat(5) @(posedge vif.scl); // wait monitor sampling
        seq_item_port.item_done();
    end
    endtask

endclass
