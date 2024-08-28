class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    cpld_output_tr  tr0;
    iic_transaction tr1;
    lpc_transaction tr2;
    lpc_transaction lpc_read[$],lpc_write[$],lpc_write2[$];
    uvm_analysis_imp_btnmon#(cpld_output_tr, scoreboard) ap0;
    uvm_analysis_imp_iicmon#(iic_transaction,scoreboard) ap1;
    uvm_analysis_imp_lpcmon#(lpc_transaction,scoreboard) ap2;
    iic_reg_model iicrgm;
    lpc_reg_model lpcrgm;
    int score=0;
    bit PSOn=0;     bit CPU_RST=0;
    bit PSOn2=0;    bit PRST9230=0;
    bit WorkPG1=0;  bit HUB_RST=0;
    bit WorkPG2=0;  bit Buzzer=0;
    bit DLIPG=0;    bit CPLD_INT=0;
    bit VTTPG=0;    bit ipmi_perst=0;
    bit CPU_DCOK=0;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        ap0=new("ap0",this);
        ap1=new("ap1",this);
        ap2=new("ap2",this);
    endfunction

    function void write_btnmon(cpld_output_tr tr);
        `uvm_info("Scoreboard","receive a transaction from btn monitor",UVM_HIGH)
	    if(tr.o_PSOn & tr.o_VDD18_EN) PSOn=1; 
	    if(tr.o_YellowLED)            PSOn2=1; 
	    if(tr.o_S0_1V2Enable & tr.o_S1_1V2Enable) WorkPG1=1; 
	    if(tr.o_S0_CORE08_EN & tr.o_S1_CORE08_EN) WorkPG2=1;
	    if(tr.o_S0_DLI_VDD18_EN & tr.o_S1_DLI_VDD18_EN) DLIPG=1; 
	    if(tr.o_PCIEReset0_n & tr.o_PCIEReset1_n)   VTTPG=1;
	    if(tr.o_S0_CPU_DCOK & tr.o_S1_CPU_DCOK)     CPU_DCOK=1;
	    if(tr.o_S0_CPUReset_n & tr.o_S1_CPUReset_n) CPU_RST=1;
	    if(tr.o_9230_PRST_n)     PRST9230=1;
	    if(tr.o_HUB_RST_n)       HUB_RST=1;
	    if(tr.o_Buzzer)          Buzzer=1;
	    if(tr.o_CPLD_INT)        CPLD_INT=1;
	    if(tr.o_ipmi_perst_n)    ipmi_perst=1;
    endfunction

    function void write_iicmon(iic_transaction tr);
        `uvm_info("Scoreboard","Get iic tr",UVM_LOW)
    endfunction

    function void write_lpcmon(lpc_transaction tr);  // tr from lpc_monitor
        if(tr.cyctype[1]) begin 
            lpc_write.push_back(tr);   // Frontdoor write tr via sequence or reg_model
            lpc_write2.push_back(tr);
            `uvm_info("Scoreboard",$sformatf("get write tr from slave monitor, addr=%h,dataIn=%h",tr.addr, tr.dataIn),UVM_HIGH)
        end
        else begin 
            lpc_read.push_back(tr);    // Frontdoor read tr
            `uvm_info("Scoreboard",$sformatf("get read tr from slave monitor, dataOut=%0h",tr.dataOut),UVM_HIGH)
        end
        `uvm_info("Scoreboard",$sformatf("lpc_write contain %0d tr",lpc_write.size),UVM_HIGH)
        if(lpc_write.size!=0 & lpc_read.size!=0) begin
            for(int i=0;i<lpc_write.size;i++) 
                score=score+checkWRtr(lpc_write[i]);
            `uvm_info("Scoreboard",$sformatf("Score=%0d/%0d",score,lpc_write.size),UVM_LOW)
        end
    endfunction
	
    function bit checkWRtr(lpc_transaction trWrite);
        for(int j=0;j<lpc_read.size;j++) begin
            if(trWrite.dataIn==lpc_read[j].dataOut)  
                checkWRtr=1;
            else
                checkWRtr=0;
        `uvm_info("Scoreboard",$sformatf("dataIn = %h, dataOut = %h",trWrite.dataIn,lpc_read[j].dataOut),UVM_LOW)
        end
    endfunction

    task main_phase(uvm_phase phase);
    lpc_transaction lpc_tr;
    uvm_reg_data_t value;
    uvm_status_e status;
    // the threads below sensetive to this.imp.write()
    fork
        begin wait(PSOn==1);        `uvm_info("Scoreboard","Power-On step: PSOn",UVM_LOW) end
        begin wait(PSOn2==1);       `uvm_info("Scoreboard","Power-On step: PSOn2",UVM_LOW) end
        begin wait(WorkPG1==1);     `uvm_info("Scoreboard","Power-On step: WorkPG1",UVM_LOW) end 
        begin wait(WorkPG2==1);     `uvm_info("Scoreboard","Power-On step: WorkPG2",UVM_LOW) end
        begin wait(DLIPG==1);       `uvm_info("Scoreboard","Power-On step: DLIPG",UVM_LOW) end
        begin wait(VTTPG==1);       `uvm_info("Scoreboard","Power-On step: VTTPG",UVM_LOW) end
        begin wait(CPU_DCOK==1);    `uvm_info("Scoreboard","Power-On step: CPU_DCOK",UVM_LOW) end
        begin wait(CPU_RST==1);     `uvm_info("Scoreboard","Power-On step: CPU_RST",UVM_LOW) end
        begin wait(PRST9230==1);    `uvm_info("Scoreboard","Power-On step: PRST9230",UVM_LOW) end
        begin wait(HUB_RST==1);     `uvm_info("Scoreboard","Power-On step: HUB_RST",UVM_LOW) end
        begin wait(Buzzer==1);      `uvm_info("Scoreboard","Power-On step: Buzzer",UVM_LOW) end
        begin wait(CPLD_INT==1);    `uvm_info("Scoreboard","Power-On step: CPLD_INT",UVM_LOW) end
        begin wait(ipmi_perst==1);  `uvm_info("Scoreboard","Power-On step: ipmi_perst",UVM_LOW) end
        forever begin
            wait(lpc_write2.size>0); 
            lpc_tr=lpc_write2.pop_front();
                case(lpc_tr.addr[7:0])
                8'h00 : lpcrgm.regA0.peek(status,value); // task peek();
                8'h04 : lpcrgm.regA1.peek(status,value);
                8'h08 : lpcrgm.regA2.peek(status,value);
                8'h0C : lpcrgm.regA3.peek(status,value);
                default : lpcrgm.regA0.peek(status,value);
                endcase
            if(value==lpc_tr.dataIn)
            `uvm_info("Scoreboard",$sformatf("LPC write data succeed, dataIn=%h, reg value=%h",lpc_tr.dataIn,value[7:0]),UVM_LOW)
            else `uvm_info("Scoreboard",$sformatf("LPC write data fail!! addr=%h, dataIn=%h, reg value=%h",
                lpc_tr.addr,lpc_tr.dataIn,value[7:0]),UVM_LOW)
        end
    join_none
    endtask
endclass
