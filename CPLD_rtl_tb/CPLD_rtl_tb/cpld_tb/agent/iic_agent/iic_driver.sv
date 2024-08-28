class iic_driver extends uvm_driver#(iic_transaction);
    `uvm_component_utils(iic_driver)

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
    bit ack;
    vif.sda_oe=1;       //sda output enable
    vif.sda_out =1;     //start as high
    forever begin
        seq_item_port.get_next_item(tr);
        @(posedge vif.scl);
        vif.sda_oe=1;
        @(negedge vif.clk); 
        vif.sda_out = 0;    //iic transmit start !
        trans_start.trigger();
        `uvm_info("IIC Driver","IIC transfer start",UVM_LOW)

        for(int i=0;i<=6;i++) begin    //master sent slave address
            @(posedge vif.scl2);
            vif.sda_out = tr.addr[6-i]; //MSB transfirstly
        end
        @(posedge vif.scl2);
        vif.sda_out = tr.trans;  //specify transmit direction
        slave_ack(ack);
        if(ack==0) begin //slave ACK for slave addr. if not,terminate this transmission
            `uvm_info("IIC Driver","IIC Slave Acknowledge slave address transmit",UVM_LOW)

            if(tr.trans==0) begin //slave read data
            `uvm_info("IIC Driver","Master Writing",UVM_LOW)
                for(int j=7;j>=0;j--) begin //master sent reg addr
                    @(posedge vif.scl2);
                    vif.sda_out = tr.regAddr[j];
                end
                
                slave_ack(ack); //wait slave ACK/NACK for reg addr
                if(ack==0) begin
                    `uvm_info("IIC Driver","IIC Slave Acknowledge reg addr transmit",UVM_LOW)

                    for(int k=7;k>=0;k--) begin //master sent data
                        @(posedge vif.scl2);
                        vif.sda_out = tr.dataIN[k];
                    end
                    slave_ack(ack); //wait slave ACK/NACK for data
                    if(ack==0) `uvm_info("IIC Driver","IIC Slave Acknowledge data transmit",UVM_LOW)
                    else `uvm_info("IIC Driver","IIC Slave did not Acknowledge data transmit !!",UVM_LOW)
                end
                else `uvm_info("IIC Driver","IIC Slave did not Acknowledge reg addr transmit !!",UVM_LOW)
            end 
            else begin  //slave write data
                `uvm_info("IIC Driver","Master Reading",UVM_LOW)
                vif.sda_oe =0;
                repeat(8) @(posedge vif.scl); //wait tb.monitor read
                @(negedge vif.scl);
                vif.sda_oe =1;
                vif.sda_out=0;//master ACK for read data
            end

        end else `uvm_info("IIC Driver","IIC Slave did not acknowledge slave address, transmit interrupted!!",UVM_LOW)

        vif.sda_out=0;
        @(posedge vif.scl);
        @(negedge vif.clk);
        vif.sda_out=1; //transmit finish
        `uvm_info("IIC Driver","IIC transfer finish",UVM_LOW)
        @(negedge vif.scl);
        //vif.sda_oe=0;

        if(tr.dataIN==8'h0f)
        fork
        wait(vif.o_CPLD_INT==1);
        forever @(posedge vif.clk);
        join_any disable fork;

        repeat(4) @(posedge vif.scl); // wait monitor sampling
        `uvm_info("IIC Driver","IIC seq item done",UVM_LOW)
        tr=null;
        seq_item_port.item_done();
    end
    endtask

    task slave_ack(output bit acknowledge);
        @(negedge vif.scl);
        repeat(3) @(posedge vif.clk);
        vif.sda_oe = 0;
        @(posedge vif.scl);
        if(vif.io_sda==0) acknowledge=0;
        else acknowledge=1;
        @(negedge vif.scl);     // bus multi-driving
        repeat(2) @(posedge vif.clk);
        vif.sda_oe = 1;
    endtask
endclass
