class iic_reg_a0 extends uvm_reg;
    `uvm_object_utils(iic_reg_a0)

    rand uvm_reg_field a0;

    function new(string name="iic_reg_a0");
        super.new(name,
                  8,  // total bits in the register
                  UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        a0=uvm_reg_field::type_id::create("a0");
        // setting the configuration for reg_field
        a0.configure(this,  // parent class
                       8,   // size
                       0,   // LSB position in the reg
                       "RW",// access
                       1,   // volatile
                       0,   // reset value
                       1,   // reset enable
                       1,   // randomize enable
                       0);  // individually access
    endfunction
endclass
class iic_reg_a1 extends uvm_reg;
    `uvm_object_utils(iic_reg_a1)
    rand uvm_reg_field a1;
    function new(string name="iic_reg_a1");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        a1=uvm_reg_field::type_id::create("a1");
        a1.configure(this,8,0,"RO",1,8'h32,1,1,0);
    endfunction
endclass
class iic_reg_a2 extends uvm_reg;
    `uvm_object_utils(iic_reg_a2)
    rand uvm_reg_field a2;
    function new(string name="iic_reg_a2");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        a2=uvm_reg_field::type_id::create("a2");
        a2.configure(this,8,0,"RW",1,0,1,1,0);
    endfunction
endclass
class iic_reg_a3 extends uvm_reg;
    `uvm_object_utils(iic_reg_a3)
    rand uvm_reg_field a3;
    function new(string name="iic_reg_a3");
        super.new(name,8,UVM_NO_COVERAGE);
    endfunction
    virtual function void build();
        a3=uvm_reg_field::type_id::create("a3");
        a3.configure(this,8,0,"RW",1,0,1,1,0);
    endfunction
endclass
class beep_divide extends uvm_reg;
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
endclass

