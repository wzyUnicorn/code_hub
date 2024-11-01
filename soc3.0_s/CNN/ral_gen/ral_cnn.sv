`ifndef RAL_CNN
`define RAL_CNN

import uvm_pkg::*;

class ral_reg_cnn_CNN_CTRL0 extends uvm_reg;
	rand uvm_reg_field START;
	rand uvm_reg_field CLEAR;

	function new(string name = "cnn_CNN_CTRL0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.START = uvm_reg_field::type_id::create("START",,get_full_name());
      this.START.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0, 0);
      this.CLEAR = uvm_reg_field::type_id::create("CLEAR",,get_full_name());
      this.CLEAR.configure(this, 1, 1, "RW", 0, 1'b0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_CTRL0)

endclass : ral_reg_cnn_CNN_CTRL0


class ral_reg_cnn_CNN_CTRL1 extends uvm_reg;
	rand uvm_reg_field MODE;

	function new(string name = "cnn_CNN_CTRL1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.MODE = uvm_reg_field::type_id::create("MODE",,get_full_name());
      this.MODE.configure(this, 3, 0, "RW", 0, 3'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_CTRL1)

endclass : ral_reg_cnn_CNN_CTRL1


class ral_reg_cnn_CNN_COUNT0 extends uvm_reg;
	rand uvm_reg_field POOL_COUNT;
	rand uvm_reg_field CONV_COUNT;

	function new(string name = "cnn_CNN_COUNT0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.POOL_COUNT = uvm_reg_field::type_id::create("POOL_COUNT",,get_full_name());
      this.POOL_COUNT.configure(this, 16, 0, "RW", 0, 16'b0, 1, 0, 1);
      this.CONV_COUNT = uvm_reg_field::type_id::create("CONV_COUNT",,get_full_name());
      this.CONV_COUNT.configure(this, 16, 16, "RW", 0, 16'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_COUNT0)

endclass : ral_reg_cnn_CNN_COUNT0


class ral_reg_cnn_CNN_COUNT1 extends uvm_reg;
	rand uvm_reg_field LINE_COUNT;

	function new(string name = "cnn_CNN_COUNT1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.LINE_COUNT = uvm_reg_field::type_id::create("LINE_COUNT",,get_full_name());
      this.LINE_COUNT.configure(this, 16, 0, "RW", 0, 16'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_COUNT1)

endclass : ral_reg_cnn_CNN_COUNT1


class ral_reg_cnn_CNN_STATUS extends uvm_reg;
	rand uvm_reg_field DONE;
	rand uvm_reg_field UNDERFLOW;
	rand uvm_reg_field OVERFLOW;

	function new(string name = "cnn_CNN_STATUS");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DONE = uvm_reg_field::type_id::create("DONE",,get_full_name());
      this.DONE.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0, 0);
      this.UNDERFLOW = uvm_reg_field::type_id::create("UNDERFLOW",,get_full_name());
      this.UNDERFLOW.configure(this, 1, 1, "RW", 0, 1'b0, 1, 0, 0);
      this.OVERFLOW = uvm_reg_field::type_id::create("OVERFLOW",,get_full_name());
      this.OVERFLOW.configure(this, 1, 2, "RW", 0, 1'b0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_STATUS)

endclass : ral_reg_cnn_CNN_STATUS


class ral_reg_cnn_CNN_DMA_EN extends uvm_reg;
	rand uvm_reg_field DOUT_EN;
	uvm_reg_field RSV_0;
	rand uvm_reg_field DIN_EN;
	uvm_reg_field RSV_1;

	function new(string name = "cnn_CNN_DMA_EN");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DOUT_EN = uvm_reg_field::type_id::create("DOUT_EN",,get_full_name());
      this.DOUT_EN.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0, 0);
      this.RSV_0 = uvm_reg_field::type_id::create("RSV_0",,get_full_name());
      this.RSV_0.configure(this, 14, 1, "RO", 0, 14'b0, 1, 0, 0);
      this.DIN_EN = uvm_reg_field::type_id::create("DIN_EN",,get_full_name());
      this.DIN_EN.configure(this, 1, 15, "RW", 0, 1'b0, 1, 0, 0);
      this.RSV_1 = uvm_reg_field::type_id::create("RSV_1",,get_full_name());
      this.RSV_1.configure(this, 14, 16, "RO", 0, 14'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_DMA_EN)

endclass : ral_reg_cnn_CNN_DMA_EN


class ral_reg_cnn_CNN_SRC_ADDR extends uvm_reg;
	rand uvm_reg_field SRC_ADDR;

	function new(string name = "cnn_CNN_SRC_ADDR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.SRC_ADDR = uvm_reg_field::type_id::create("SRC_ADDR",,get_full_name());
      this.SRC_ADDR.configure(this, 32, 0, "RW", 0, 32'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_SRC_ADDR)

endclass : ral_reg_cnn_CNN_SRC_ADDR


class ral_reg_cnn_CNN_DST_ADDR extends uvm_reg;
	rand uvm_reg_field DST_ADDR;

	function new(string name = "cnn_CNN_DST_ADDR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DST_ADDR = uvm_reg_field::type_id::create("DST_ADDR",,get_full_name());
      this.DST_ADDR.configure(this, 32, 0, "RW", 0, 32'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_DST_ADDR)

endclass : ral_reg_cnn_CNN_DST_ADDR


class ral_reg_cnn_CNN_INT_EN extends uvm_reg;
	rand uvm_reg_field DONE_INT_EN;
	rand uvm_reg_field UNDERFLOW_INT_EN;
	rand uvm_reg_field OVERFLOW_INT_EN;

	function new(string name = "cnn_CNN_INT_EN");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DONE_INT_EN = uvm_reg_field::type_id::create("DONE_INT_EN",,get_full_name());
      this.DONE_INT_EN.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0, 0);
      this.UNDERFLOW_INT_EN = uvm_reg_field::type_id::create("UNDERFLOW_INT_EN",,get_full_name());
      this.UNDERFLOW_INT_EN.configure(this, 1, 1, "RW", 0, 1'b0, 1, 0, 0);
      this.OVERFLOW_INT_EN = uvm_reg_field::type_id::create("OVERFLOW_INT_EN",,get_full_name());
      this.OVERFLOW_INT_EN.configure(this, 1, 2, "RW", 0, 1'b0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_INT_EN)

endclass : ral_reg_cnn_CNN_INT_EN


class ral_reg_cnn_CNN_INT extends uvm_reg;
	rand uvm_reg_field DONE_INT;
	rand uvm_reg_field UNDERFLOW_INT;
	rand uvm_reg_field OVERFFLOW_INT;

	function new(string name = "cnn_CNN_INT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DONE_INT = uvm_reg_field::type_id::create("DONE_INT",,get_full_name());
      this.DONE_INT.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0, 1);
      this.UNDERFLOW_INT = uvm_reg_field::type_id::create("UNDERFLOW_INT",,get_full_name());
      this.UNDERFLOW_INT.configure(this, 1, 8, "RW", 0, 1'b0, 1, 0, 1);
      this.OVERFFLOW_INT = uvm_reg_field::type_id::create("OVERFFLOW_INT",,get_full_name());
      this.OVERFFLOW_INT.configure(this, 1, 16, "RW", 0, 1'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_cnn_CNN_INT)

endclass : ral_reg_cnn_CNN_INT


class ral_block_cnn extends uvm_reg_block;
	rand ral_reg_cnn_CNN_CTRL0 CNN_CTRL0;
	rand ral_reg_cnn_CNN_CTRL1 CNN_CTRL1;
	rand ral_reg_cnn_CNN_COUNT0 CNN_COUNT0;
	rand ral_reg_cnn_CNN_COUNT1 CNN_COUNT1;
	rand ral_reg_cnn_CNN_STATUS CNN_STATUS;
	rand ral_reg_cnn_CNN_DMA_EN CNN_DMA_EN;
	rand ral_reg_cnn_CNN_SRC_ADDR CNN_SRC_ADDR;
	rand ral_reg_cnn_CNN_DST_ADDR CNN_DST_ADDR;
	rand ral_reg_cnn_CNN_INT_EN CNN_INT_EN;
	rand ral_reg_cnn_CNN_INT CNN_INT;
	rand uvm_reg_field CNN_CTRL0_START;
	rand uvm_reg_field START;
	rand uvm_reg_field CNN_CTRL0_CLEAR;
	rand uvm_reg_field CLEAR;
	rand uvm_reg_field CNN_CTRL1_MODE;
	rand uvm_reg_field MODE;
	rand uvm_reg_field CNN_COUNT0_POOL_COUNT;
	rand uvm_reg_field POOL_COUNT;
	rand uvm_reg_field CNN_COUNT0_CONV_COUNT;
	rand uvm_reg_field CONV_COUNT;
	rand uvm_reg_field CNN_COUNT1_LINE_COUNT;
	rand uvm_reg_field LINE_COUNT;
	rand uvm_reg_field CNN_STATUS_DONE;
	rand uvm_reg_field DONE;
	rand uvm_reg_field CNN_STATUS_UNDERFLOW;
	rand uvm_reg_field UNDERFLOW;
	rand uvm_reg_field CNN_STATUS_OVERFLOW;
	rand uvm_reg_field OVERFLOW;
	rand uvm_reg_field CNN_DMA_EN_DOUT_EN;
	rand uvm_reg_field DOUT_EN;
	uvm_reg_field CNN_DMA_EN_RSV_0;
	uvm_reg_field RSV_0;
	rand uvm_reg_field CNN_DMA_EN_DIN_EN;
	rand uvm_reg_field DIN_EN;
	uvm_reg_field CNN_DMA_EN_RSV_1;
	uvm_reg_field RSV_1;
	rand uvm_reg_field CNN_SRC_ADDR_SRC_ADDR;
	rand uvm_reg_field SRC_ADDR;
	rand uvm_reg_field CNN_DST_ADDR_DST_ADDR;
	rand uvm_reg_field DST_ADDR;
	rand uvm_reg_field CNN_INT_EN_DONE_INT_EN;
	rand uvm_reg_field DONE_INT_EN;
	rand uvm_reg_field CNN_INT_EN_UNDERFLOW_INT_EN;
	rand uvm_reg_field UNDERFLOW_INT_EN;
	rand uvm_reg_field CNN_INT_EN_OVERFLOW_INT_EN;
	rand uvm_reg_field OVERFLOW_INT_EN;
	rand uvm_reg_field CNN_INT_DONE_INT;
	rand uvm_reg_field DONE_INT;
	rand uvm_reg_field CNN_INT_UNDERFLOW_INT;
	rand uvm_reg_field UNDERFLOW_INT;
	rand uvm_reg_field CNN_INT_OVERFFLOW_INT;
	rand uvm_reg_field OVERFFLOW_INT;

	function new(string name = "cnn");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.CNN_CTRL0 = ral_reg_cnn_CNN_CTRL0::type_id::create("CNN_CTRL0",,get_full_name());
      this.CNN_CTRL0.configure(this, null, "");
      this.CNN_CTRL0.build();
      this.default_map.add_reg(this.CNN_CTRL0, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.CNN_CTRL0_START = this.CNN_CTRL0.START;
		this.START = this.CNN_CTRL0.START;
		this.CNN_CTRL0_CLEAR = this.CNN_CTRL0.CLEAR;
		this.CLEAR = this.CNN_CTRL0.CLEAR;
      this.CNN_CTRL1 = ral_reg_cnn_CNN_CTRL1::type_id::create("CNN_CTRL1",,get_full_name());
      this.CNN_CTRL1.configure(this, null, "");
      this.CNN_CTRL1.build();
      this.default_map.add_reg(this.CNN_CTRL1, `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
		this.CNN_CTRL1_MODE = this.CNN_CTRL1.MODE;
		this.MODE = this.CNN_CTRL1.MODE;
      this.CNN_COUNT0 = ral_reg_cnn_CNN_COUNT0::type_id::create("CNN_COUNT0",,get_full_name());
      this.CNN_COUNT0.configure(this, null, "");
      this.CNN_COUNT0.build();
      this.default_map.add_reg(this.CNN_COUNT0, `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
		this.CNN_COUNT0_POOL_COUNT = this.CNN_COUNT0.POOL_COUNT;
		this.POOL_COUNT = this.CNN_COUNT0.POOL_COUNT;
		this.CNN_COUNT0_CONV_COUNT = this.CNN_COUNT0.CONV_COUNT;
		this.CONV_COUNT = this.CNN_COUNT0.CONV_COUNT;
      this.CNN_COUNT1 = ral_reg_cnn_CNN_COUNT1::type_id::create("CNN_COUNT1",,get_full_name());
      this.CNN_COUNT1.configure(this, null, "");
      this.CNN_COUNT1.build();
      this.default_map.add_reg(this.CNN_COUNT1, `UVM_REG_ADDR_WIDTH'hC, "RW", 0);
		this.CNN_COUNT1_LINE_COUNT = this.CNN_COUNT1.LINE_COUNT;
		this.LINE_COUNT = this.CNN_COUNT1.LINE_COUNT;
      this.CNN_STATUS = ral_reg_cnn_CNN_STATUS::type_id::create("CNN_STATUS",,get_full_name());
      this.CNN_STATUS.configure(this, null, "");
      this.CNN_STATUS.build();
      this.default_map.add_reg(this.CNN_STATUS, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.CNN_STATUS_DONE = this.CNN_STATUS.DONE;
		this.DONE = this.CNN_STATUS.DONE;
		this.CNN_STATUS_UNDERFLOW = this.CNN_STATUS.UNDERFLOW;
		this.UNDERFLOW = this.CNN_STATUS.UNDERFLOW;
		this.CNN_STATUS_OVERFLOW = this.CNN_STATUS.OVERFLOW;
		this.OVERFLOW = this.CNN_STATUS.OVERFLOW;
      this.CNN_DMA_EN = ral_reg_cnn_CNN_DMA_EN::type_id::create("CNN_DMA_EN",,get_full_name());
      this.CNN_DMA_EN.configure(this, null, "");
      this.CNN_DMA_EN.build();
      this.default_map.add_reg(this.CNN_DMA_EN, `UVM_REG_ADDR_WIDTH'h14, "RW", 0);
		this.CNN_DMA_EN_DOUT_EN = this.CNN_DMA_EN.DOUT_EN;
		this.DOUT_EN = this.CNN_DMA_EN.DOUT_EN;
		this.CNN_DMA_EN_RSV_0 = this.CNN_DMA_EN.RSV_0;
		this.RSV_0 = this.CNN_DMA_EN.RSV_0;
		this.CNN_DMA_EN_DIN_EN = this.CNN_DMA_EN.DIN_EN;
		this.DIN_EN = this.CNN_DMA_EN.DIN_EN;
		this.CNN_DMA_EN_RSV_1 = this.CNN_DMA_EN.RSV_1;
		this.RSV_1 = this.CNN_DMA_EN.RSV_1;
      this.CNN_SRC_ADDR = ral_reg_cnn_CNN_SRC_ADDR::type_id::create("CNN_SRC_ADDR",,get_full_name());
      this.CNN_SRC_ADDR.configure(this, null, "");
      this.CNN_SRC_ADDR.build();
      this.default_map.add_reg(this.CNN_SRC_ADDR, `UVM_REG_ADDR_WIDTH'h18, "RW", 0);
		this.CNN_SRC_ADDR_SRC_ADDR = this.CNN_SRC_ADDR.SRC_ADDR;
		this.SRC_ADDR = this.CNN_SRC_ADDR.SRC_ADDR;
      this.CNN_DST_ADDR = ral_reg_cnn_CNN_DST_ADDR::type_id::create("CNN_DST_ADDR",,get_full_name());
      this.CNN_DST_ADDR.configure(this, null, "");
      this.CNN_DST_ADDR.build();
      this.default_map.add_reg(this.CNN_DST_ADDR, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
		this.CNN_DST_ADDR_DST_ADDR = this.CNN_DST_ADDR.DST_ADDR;
		this.DST_ADDR = this.CNN_DST_ADDR.DST_ADDR;
      this.CNN_INT_EN = ral_reg_cnn_CNN_INT_EN::type_id::create("CNN_INT_EN",,get_full_name());
      this.CNN_INT_EN.configure(this, null, "");
      this.CNN_INT_EN.build();
      this.default_map.add_reg(this.CNN_INT_EN, `UVM_REG_ADDR_WIDTH'h20, "RW", 0);
		this.CNN_INT_EN_DONE_INT_EN = this.CNN_INT_EN.DONE_INT_EN;
		this.DONE_INT_EN = this.CNN_INT_EN.DONE_INT_EN;
		this.CNN_INT_EN_UNDERFLOW_INT_EN = this.CNN_INT_EN.UNDERFLOW_INT_EN;
		this.UNDERFLOW_INT_EN = this.CNN_INT_EN.UNDERFLOW_INT_EN;
		this.CNN_INT_EN_OVERFLOW_INT_EN = this.CNN_INT_EN.OVERFLOW_INT_EN;
		this.OVERFLOW_INT_EN = this.CNN_INT_EN.OVERFLOW_INT_EN;
      this.CNN_INT = ral_reg_cnn_CNN_INT::type_id::create("CNN_INT",,get_full_name());
      this.CNN_INT.configure(this, null, "");
      this.CNN_INT.build();
      this.default_map.add_reg(this.CNN_INT, `UVM_REG_ADDR_WIDTH'h24, "RW", 0);
		this.CNN_INT_DONE_INT = this.CNN_INT.DONE_INT;
		this.DONE_INT = this.CNN_INT.DONE_INT;
		this.CNN_INT_UNDERFLOW_INT = this.CNN_INT.UNDERFLOW_INT;
		this.UNDERFLOW_INT = this.CNN_INT.UNDERFLOW_INT;
		this.CNN_INT_OVERFFLOW_INT = this.CNN_INT.OVERFFLOW_INT;
		this.OVERFFLOW_INT = this.CNN_INT.OVERFFLOW_INT;
   endfunction : build

	`uvm_object_utils(ral_block_cnn)

endclass : ral_block_cnn



`endif
