class sys_memory extends uvm_component;

  // Memory properties
  rand int mem_size;
  rand bit [31:0] memory[];

  // Constructor
  function new(string name = "sys_memory", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Randomize the memory content
    if (!uvm_config_db#(int)::get(this, "", "mem_size", mem_size))
      mem_size = 20480; // Default memory size if not configured

    memory = new[mem_size];
    if (!randomize(memory))
      `uvm_error("MEM_INIT_ERR", "Failed to randomize memory content");
  endfunction

  // Read a word from memory at the given address
  virtual function bit read(int address, output int data);

    if (address < 0 || address >= mem_size) begin
      `uvm_error("MEM_READ_ERR", $sformatf("Invalid memory address: %0d", address));
      return 0;
    end

    data = memory[address];
    `uvm_info("MEM_READ", $sformatf("Read from address %0d, data = %h", address, data), UVM_HIGH);
    return 1;
  endfunction

  // Write a word to memory at the given address
  virtual function bit write(int address, int data);
    if (address < 0 || address >= mem_size) begin
      `uvm_error("MEM_WRITE_ERR", $sformatf("Invalid memory address: %0d", address));
      return 0;
    end

    memory[address] = data;
    `uvm_info("MEM_WRITE", $sformatf("Write to address %0d, data = %h", address, data), UVM_HIGH);
    return 1;
  endfunction


  // Write a word to memory at the given address
  virtual function bit load_mem(bit[31:0] address, bit[31:0] data[]);
    int data_size = data.size();
    if (address < 0 || address >= mem_size) begin
      `uvm_error("MEM_LOAD_ERR", $sformatf("Invalid memory address: %0d", address));
      return 0;
    end
   
    for(int i=0;i<data_size;i++) begin
        memory[address+i*4] = data[i];
        `uvm_info("MEM_LOAD", $sformatf("LOAD data 0x%h to address 0x%h", data[i],address+i*4), UVM_HIGH);
    end
    `uvm_info("MEM_LOAD", $sformatf("LOAD to address %0d Done", address), UVM_LOW);
    return 1;
  endfunction


  // Add the UVM macros for factory registration
  `uvm_component_utils(sys_memory)

endclass
