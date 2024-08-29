class btn_driver extends uvm_driver#(cpld_output_tr);
    `uvm_component_utils(btn_driver)
    virtual cpld_if vif;
    cpld_output_tr seq_item;
    uvm_event DCOKSby;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        if(!uvm_config_db#(virtual cpld_if)::get(this,"","vif",vif))
        `uvm_error("Button Driver","Miss virtual interface !!")
        DCOKSby=uvm_event_pool::get_global("DCOKSby");
    endfunction

    task main_phase(uvm_phase phase);
        initialize();
        repeat(10) @(posedge vif.clk);
        @(posedge vif.clk);
        vif.i_DCOKSby=1;
        repeat(40) @(posedge vif.clk);  // DCOKSby pull up for a while

        forever begin
        seq_item_port.get_next_item(seq_item);
        `uvm_info("Button Driver","Power-on start",UVM_LOW)
        `uvm_info("Button Driver",$sformatf("step=%0d,last step=2'b%b",seq_item.step,seq_item.last_step),UVM_LOW)

        if(seq_item.jitter==1) sim_btn_jitter();
        repeat(1) begin
            if(seq_item.step==0) begin 
                DCOKSby.trigger();      // Trigger to others driver
                break;
            end
        vif.i_PowerButton_n=0;
        repeat(16) @(posedge vif.clk);  // Power Button pull down 0.5ms for power on
        `uvm_info("Button Driver","PowerButton Pressed !!",UVM_LOW)
        vif.i_PowerButton_n=1;
        end

        repeat(1) begin

        if(seq_item.step==1) break;
        fork
        wait(vif.o_PSOn & vif.o_VDD18_EN);
        forever @(posedge vif.clk);
        join_any disable fork;
        @(posedge vif.clk);
        vif.i_ATX_PG=1;
        @(posedge vif.clk);
        vif.i_WorkPowerGood1=1;
        if(seq_item.step==2) break;

        fork
        wait(vif.o_YellowLED);
        forever @(posedge vif.clk);
        join_any disable fork;
        @(posedge vif.clk);
        vif.i_WorkPowerGood2=1;
        if(seq_item.step==3) break;

        fork
        wait(vif.o_S0_1V2Enable & vif.o_S1_1V2Enable);
        forever @(posedge vif.clk);
        join_any disable fork;
        @(posedge vif.clk);
        vif.i_S0_VTT_PWRGD=1;
        vif.i_S1_VTT_PWRGD=1;   
        if(seq_item.step==4) break;

        fork
        wait(vif.o_S0_CORE08_EN & vif.o_S1_CORE08_EN);
        forever @(posedge vif.clk);
        join_any disable fork;
        @(posedge vif.clk);   
        vif.i_S0_CORE08_PG=1;     
        vif.i_S1_CORE08_PG=1;
        if(seq_item.step==5) break;

        fork
        wait(vif.o_S0_DLI_VDD18_EN & vif.o_S1_DLI_VDD18_EN);
        forever @(posedge vif.clk);
        join_any disable fork;
        @(posedge vif.clk);
        vif.i_S0_DLI_VDD18_PG=1;     
        vif.i_S1_DLI_VDD18_PG=1;
        if(seq_item.step==6) break;

        fork
        wait(vif.o_CPLD_INT);
        forever @(posedge vif.clk);
        join_any disable fork;          // power on complete

        end // end repeat(1) loop

        if(seq_item.jitter==1) sim_btn_jitter();

        repeat(10) @(posedge vif.clk);
        case(seq_item.last_step)            // do something after power on
        RESET:begin
            vif.i_RST_BUTTON_n=0;
            repeat(16) @(posedge vif.clk);  // Reset Button pressed 0.5ms to reset
            vif.i_RST_BUTTON_n=1;
        end
        POWER_OFF:begin
            vif.i_PowerButton_n=0;
            repeat(160) @(posedge vif.clk); // Power Button pressed 5ms to shut down
            vif.i_PowerButton_n=1;
        end
        ALARM:begin
            vif.i_S0_VS_ALARM_L=0;vif.i_S0_TS_ALARM_L=0;
            vif.i_S1_VS_ALARM_L=0;vif.i_S1_TS_ALARM_L=0;
            repeat(16) @(posedge vif.clk);  // temprature and voltage alarm
            vif.i_S0_VS_ALARM_L=1;vif.i_S0_TS_ALARM_L=1;
            vif.i_S1_VS_ALARM_L=1;vif.i_S1_TS_ALARM_L=1;
        end
        DCOK:begin
            vif.i_DCOKSby=0;                // power cut off in a short time
            repeat(10) @(posedge vif.clk);
            vif.i_DCOKSby=1;
            repeat(16) @(posedge vif.clk);
        end
        endcase

        repeat(25) @(posedge vif.clk);       // wait 23 clk at least
        `uvm_info("Button Driver","seq_item done",UVM_LOW)
        seq_item=null;
        seq_item_port.item_done();
        end
    endtask

    task shutdown_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("Button Driver","Shut down phase: power cut off at the end of simulation",UVM_LOW)
        @(posedge vif.clk) vif.i_DCOKSby=0;
        @(posedge vif.clk) initialize();
        repeat(16) @(posedge vif.clk);
        phase.drop_objection(this);
    endtask

    task initialize();
        //button                    //lpc
        vif.i_DCOKSby=0;            vif.i_LPCRst_n=0;
        vif.i_8619_PG=1;            vif.i_Frame=1;
        vif.i_RST_BUTTON_n=1;       vif.lad_oe=1;
        vif.i_PowerButton_n=1;      vif.LAD_o=4'b0;
        vif.i_ATX_PG=0;             //iic
        vif.i_WorkPowerGood1=0;     vif.scl=1;
        vif.i_WorkPowerGood2=0;     vif.sda_oe=1;
        vif.i_S0_VTT_PWRGD=0;       
        vif.i_S1_VTT_PWRGD=0;       //ipmi
        vif.i_S0_CORE08_PG=0;       vif.i_AST_PWROn_n=1;
        vif.i_S1_CORE08_PG=0;       vif.i_AST_PWROff_n=1;
        vif.i_S0_DLI_VDD18_PG=0;    vif.i_AST_Reset_n=1;
        vif.i_S1_DLI_VDD18_PG=0;    vif.i_AST_act_n=1;
        vif.i_8619_PG=1;            //temperature and voltage alarm
                                    vif.i_S0_VS_ALARM_L=1;
        vif.i_Buzzer=0;             vif.i_S0_TS_ALARM_L=1;
                                    vif.i_S1_VS_ALARM_L=1;
                                    vif.i_S1_TS_ALARM_L=1;
    endtask
    task sim_btn_jitter();
        `uvm_info("Button Driver","Simulating PowerButton jitter !!",UVM_LOW)
        //rand int n;
        repeat(5) begin
        //n=$randomize() with {n<15;n>2;};
        vif.i_PowerButton_n=0;
        repeat(10) @(posedge vif.clk);
        vif.i_PowerButton_n=1;
        end
    endtask
endclass
