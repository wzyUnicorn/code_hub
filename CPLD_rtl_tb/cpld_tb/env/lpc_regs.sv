class lpc_reg_a0 extends uvm_reg;
    `uvm_object_utils(lpc_reg_a0)

    rand uvm_reg_field a0;

    function new(string name="lpc_reg_a0");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        a0=uvm_reg_field::type_id::create("a0");
        a0.configure(this,8,0,"RW",1,0,1,1,0);
    endfunction
endclass
class lpc_reg_a1 extends uvm_reg;
    `uvm_object_utils(lpc_reg_a1)
    rand uvm_reg_field a1;
    function new(string name="lpc_reg_a1");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        a1=uvm_reg_field::type_id::create("a1");
        a1.configure(this,8,0,"RO",1,8'h41,1,1,0);
    endfunction
endclass
class lpc_reg_a2 extends uvm_reg;
    `uvm_object_utils(lpc_reg_a2)
    rand uvm_reg_field a2;
    function new(string name="lpc_reg_a2");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        a2=uvm_reg_field::type_id::create("a2");
        a2.configure(this,8,0,"RW",1,0,1,1,0);
    endfunction
endclass
class lpc_reg_a3 extends uvm_reg;
    `uvm_object_utils(lpc_reg_a3)
    rand uvm_reg_field a3;
    function new(string name="lpc_reg_a3");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        a3=uvm_reg_field::type_id::create("a3");
        a3.configure(this,8,0,"RW",1,0,1,1,0);
    endfunction
endclass
/*class beep_divide extends uvm_reg;
    `uvm_object_utils(beep_divide)
    rand uvm_reg_field divide;
    function new(string name="beep_divide");
        super.new(name,5,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        divide=uvm_reg_field::type_id::create("divide");
        divide.configure(this,5,0,"RW",1,0,1,1,0);
    endfunction
endclass
class beep_en extends uvm_reg;
    `uvm_object_utils(beep_en)
    rand uvm_reg_field en;
    function new(string name="beep_en");
        super.new(name,1,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        en=uvm_reg_field::type_id::create("en");
        en.configure(this,1,0,"RW",1,0,1,1,0);
    endfunction
endclass*/

