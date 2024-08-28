
    parameter AST_ON=2'b01, AST_RST=2'b10, AST_OFF=2'b11;
class tele_ctrl_item extends uvm_sequence_item;
    `uvm_object_utils(tele_ctrl_item)

    function new(string name="tele_ctrl_item");
        super.new(name);
    endfunction

    rand bit [1:0] do_action;
    //constraint default_operation { soft do_action==2'b00;} 
endclass
