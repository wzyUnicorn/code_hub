class lpc_reg_model extends uvm_reg_block;
    `uvm_object_utils(lpc_reg_model)
    
    rand lpc_reg_a0 regA0;
    rand lpc_reg_a1 regA1;
    rand lpc_reg_a2 regA2;
    rand lpc_reg_a3 regA3;
    rand beep_divide  beepdv;
    rand beep_en      beepen;
    uvm_reg_map reg_map;

    function new(string name="lpc_reg_model");
        super.new(name,UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        // each reg including a single field only
        regA0=lpc_reg_a0::type_id::create("regA0");
        regA1=lpc_reg_a1::type_id::create("regA1");
        regA2=lpc_reg_a2::type_id::create("regA2");
        regA3=lpc_reg_a3::type_id::create("regA3");
        beepdv=beep_divide::type_id::create("beepdv");
        beepen=beep_en::type_id::create("beepen");

        // setting HDL path for Backdoor access
        set_hdl_path_root("cpld_tb.u_CPLD_6B.u_lpc_reg");
        regA0.configure(this,    // reg block
                        null,    // reg file
                        "reg_a0"); // HDL path identifier of reg in dut module
        regA1.configure(this,null,"reg_a1");
        regA2.configure(this,null,"reg_a2");
        regA3.configure(this,null,"reg_a3");
        beepdv.configure(this,null,"cs_beepa_div");
        beepen.configure(this,null,"cs_beepa_en");
        regA0.build();regA1.build();regA2.build();regA3.build();
        beepdv.build(); beepen.build();

        // instance the map using uvm_reg_block::create_map()
        reg_map=create_map("reg_map", // map name
                                0,    // base address
                                1,    // bus width=1byte
                                UVM_LITTLE_ENDIAN, // endian
                                1);   // addressing by byte enable
        // add regs into the map
        reg_map.add_reg(regA0,   // reg
                        16'h0800,// offset address for Frontdoor access
                        "RW");   // accessability
        reg_map.add_reg(regA1,16'h0804,"RO");
        reg_map.add_reg(regA2,16'h0808,"RW");
        reg_map.add_reg(regA3,16'h080C,"RW");
        reg_map.add_reg(beepdv,16'h0808,"RW");
        reg_map.add_reg(beepen,16'h0808,"RW");

        lock_model();
    endfunction
endclass
