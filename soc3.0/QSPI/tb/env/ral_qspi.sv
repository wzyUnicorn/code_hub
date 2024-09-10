`ifndef RAL_QSPI
`define RAL_QSPI

import uvm_pkg::*;

class ral_reg_qspi_SPI_CTRL extends uvm_reg;
	rand uvm_reg_field RD;
	rand uvm_reg_field WR;
	rand uvm_reg_field QRD;
	rand uvm_reg_field QWR;
	rand uvm_reg_field SRST;
	rand uvm_reg_field CS;

	function new(string name = "qspi_SPI_CTRL");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.RD = uvm_reg_field::type_id::create("RD",,get_full_name());
      this.RD.configure(this, 1, 0, "WO", 0, 1'b0, 1, 0, 0);
      this.WR = uvm_reg_field::type_id::create("WR",,get_full_name());
      this.WR.configure(this, 1, 1, "WO", 0, 1'b0, 1, 0, 0);
      this.QRD = uvm_reg_field::type_id::create("QRD",,get_full_name());
      this.QRD.configure(this, 1, 2, "WO", 0, 1'b0, 1, 0, 0);
      this.QWR = uvm_reg_field::type_id::create("QWR",,get_full_name());
      this.QWR.configure(this, 1, 3, "WO", 0, 1'b0, 1, 0, 0);
      this.SRST = uvm_reg_field::type_id::create("SRST",,get_full_name());
      this.SRST.configure(this, 1, 4, "WO", 0, 1'b0, 1, 0, 0);
      this.CS = uvm_reg_field::type_id::create("CS",,get_full_name());
      this.CS.configure(this, 4, 8, "WO", 0, 4'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_CTRL)

endclass : ral_reg_qspi_SPI_CTRL


class ral_reg_qspi_SPI_STATUS extends uvm_reg;
	uvm_reg_field STATUS;
	uvm_reg_field RXELEMS;
	uvm_reg_field TXELEMS;

	function new(string name = "qspi_SPI_STATUS");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.STATUS = uvm_reg_field::type_id::create("STATUS",,get_full_name());
      this.STATUS.configure(this, 7, 0, "RO", 0, 7'b0, 1, 0, 1);
      this.RXELEMS = uvm_reg_field::type_id::create("RXELEMS",,get_full_name());
      this.RXELEMS.configure(this, 5, 16, "RO", 0, 5'b0, 1, 0, 1);
      this.TXELEMS = uvm_reg_field::type_id::create("TXELEMS",,get_full_name());
      this.TXELEMS.configure(this, 5, 24, "RO", 0, 5'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_STATUS)

endclass : ral_reg_qspi_SPI_STATUS


class ral_reg_qspi_SPI_CLKDIV extends uvm_reg;
	rand uvm_reg_field CLKDIV;

	function new(string name = "qspi_SPI_CLKDIV");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLKDIV = uvm_reg_field::type_id::create("CLKDIV",,get_full_name());
      this.CLKDIV.configure(this, 8, 0, "RW", 0, 8'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_CLKDIV)

endclass : ral_reg_qspi_SPI_CLKDIV


class ral_reg_qspi_SPI_CMD extends uvm_reg;
	rand uvm_reg_field CMD;

	function new(string name = "qspi_SPI_CMD");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CMD = uvm_reg_field::type_id::create("CMD",,get_full_name());
      this.CMD.configure(this, 32, 0, "RW", 0, 32'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_CMD)

endclass : ral_reg_qspi_SPI_CMD


class ral_reg_qspi_SPI_ADR extends uvm_reg;
	rand uvm_reg_field ADR;

	function new(string name = "qspi_SPI_ADR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.ADR = uvm_reg_field::type_id::create("ADR",,get_full_name());
      this.ADR.configure(this, 32, 0, "RW", 0, 32'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_ADR)

endclass : ral_reg_qspi_SPI_ADR


class ral_reg_qspi_SPI_LEN extends uvm_reg;
	rand uvm_reg_field CMDLEN;
	rand uvm_reg_field ADDRLEN;
	rand uvm_reg_field DATALEN;

	function new(string name = "qspi_SPI_LEN");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CMDLEN = uvm_reg_field::type_id::create("CMDLEN",,get_full_name());
      this.CMDLEN.configure(this, 6, 0, "RW", 0, 6'b0, 1, 0, 1);
      this.ADDRLEN = uvm_reg_field::type_id::create("ADDRLEN",,get_full_name());
      this.ADDRLEN.configure(this, 6, 8, "RW", 0, 6'b0, 1, 0, 1);
      this.DATALEN = uvm_reg_field::type_id::create("DATALEN",,get_full_name());
      this.DATALEN.configure(this, 16, 16, "RW", 0, 16'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_LEN)

endclass : ral_reg_qspi_SPI_LEN


class ral_reg_qspi_SPI_DUM extends uvm_reg;
	rand uvm_reg_field DUMMYRD;
	rand uvm_reg_field DUMMYWR;

	function new(string name = "qspi_SPI_DUM");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DUMMYRD = uvm_reg_field::type_id::create("DUMMYRD",,get_full_name());
      this.DUMMYRD.configure(this, 16, 0, "RW", 0, 16'b0, 1, 0, 1);
      this.DUMMYWR = uvm_reg_field::type_id::create("DUMMYWR",,get_full_name());
      this.DUMMYWR.configure(this, 16, 16, "RW", 0, 16'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_DUM)

endclass : ral_reg_qspi_SPI_DUM


class ral_reg_qspi_SPI_TXFIFO extends uvm_reg;
	rand uvm_reg_field TX;

	function new(string name = "qspi_SPI_TXFIFO");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TX = uvm_reg_field::type_id::create("TX",,get_full_name());
      this.TX.configure(this, 32, 0, "RW", 0, 32'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_TXFIFO)

endclass : ral_reg_qspi_SPI_TXFIFO


class ral_reg_qspi_SPI_RXFIFO extends uvm_reg;
	rand uvm_reg_field RX;

	function new(string name = "qspi_SPI_RXFIFO");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.RX = uvm_reg_field::type_id::create("RX",,get_full_name());
      this.RX.configure(this, 32, 0, "RW", 0, 32'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_RXFIFO)

endclass : ral_reg_qspi_SPI_RXFIFO


class ral_reg_qspi_SPI_INTCFG extends uvm_reg;
	rand uvm_reg_field TXTH;
	rand uvm_reg_field RXTH;
	rand uvm_reg_field EN;

	function new(string name = "qspi_SPI_INTCFG");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TXTH = uvm_reg_field::type_id::create("TXTH",,get_full_name());
      this.TXTH.configure(this, 5, 0, "RW", 0, 5'b0, 1, 0, 1);
      this.RXTH = uvm_reg_field::type_id::create("RXTH",,get_full_name());
      this.RXTH.configure(this, 5, 8, "RW", 0, 5'b0, 1, 0, 1);
      this.EN = uvm_reg_field::type_id::create("EN",,get_full_name());
      this.EN.configure(this, 1, 31, "RW", 0, 1'b0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_INTCFG)

endclass : ral_reg_qspi_SPI_INTCFG


class ral_reg_qspi_SPI_INTSTA extends uvm_reg;
	rand uvm_reg_field TXINT;
	rand uvm_reg_field RXINT;

	function new(string name = "qspi_SPI_INTSTA");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TXINT = uvm_reg_field::type_id::create("TXINT",,get_full_name());
      this.TXINT.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0, 0);
      this.RXINT = uvm_reg_field::type_id::create("RXINT",,get_full_name());
      this.RXINT.configure(this, 1, 1, "RW", 0, 1'b0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_qspi_SPI_INTSTA)

endclass : ral_reg_qspi_SPI_INTSTA


class ral_block_qspi extends uvm_reg_block;
	rand ral_reg_qspi_SPI_CTRL SPI_CTRL;
	rand ral_reg_qspi_SPI_STATUS SPI_STATUS;
	rand ral_reg_qspi_SPI_CLKDIV SPI_CLKDIV;
	rand ral_reg_qspi_SPI_CMD SPI_CMD;
	rand ral_reg_qspi_SPI_ADR SPI_ADR;
	rand ral_reg_qspi_SPI_LEN SPI_LEN;
	rand ral_reg_qspi_SPI_DUM SPI_DUM;
	rand ral_reg_qspi_SPI_TXFIFO SPI_TXFIFO;
	rand ral_reg_qspi_SPI_RXFIFO SPI_RXFIFO;
	rand ral_reg_qspi_SPI_INTCFG SPI_INTCFG;
	rand ral_reg_qspi_SPI_INTSTA SPI_INTSTA;
	rand uvm_reg_field SPI_CTRL_RD;
	rand uvm_reg_field RD;
	rand uvm_reg_field SPI_CTRL_WR;
	rand uvm_reg_field WR;
	rand uvm_reg_field SPI_CTRL_QRD;
	rand uvm_reg_field QRD;
	rand uvm_reg_field SPI_CTRL_QWR;
	rand uvm_reg_field QWR;
	rand uvm_reg_field SPI_CTRL_SRST;
	rand uvm_reg_field SRST;
	rand uvm_reg_field SPI_CTRL_CS;
	rand uvm_reg_field CS;
	uvm_reg_field SPI_STATUS_STATUS;
	uvm_reg_field STATUS;
	uvm_reg_field SPI_STATUS_RXELEMS;
	uvm_reg_field RXELEMS;
	uvm_reg_field SPI_STATUS_TXELEMS;
	uvm_reg_field TXELEMS;
	rand uvm_reg_field SPI_CLKDIV_CLKDIV;
	rand uvm_reg_field CLKDIV;
	rand uvm_reg_field SPI_CMD_CMD;
	rand uvm_reg_field CMD;
	rand uvm_reg_field SPI_ADR_ADR;
	rand uvm_reg_field ADR;
	rand uvm_reg_field SPI_LEN_CMDLEN;
	rand uvm_reg_field CMDLEN;
	rand uvm_reg_field SPI_LEN_ADDRLEN;
	rand uvm_reg_field ADDRLEN;
	rand uvm_reg_field SPI_LEN_DATALEN;
	rand uvm_reg_field DATALEN;
	rand uvm_reg_field SPI_DUM_DUMMYRD;
	rand uvm_reg_field DUMMYRD;
	rand uvm_reg_field SPI_DUM_DUMMYWR;
	rand uvm_reg_field DUMMYWR;
	rand uvm_reg_field SPI_TXFIFO_TX;
	rand uvm_reg_field TX;
	rand uvm_reg_field SPI_RXFIFO_RX;
	rand uvm_reg_field RX;
	rand uvm_reg_field SPI_INTCFG_TXTH;
	rand uvm_reg_field TXTH;
	rand uvm_reg_field SPI_INTCFG_RXTH;
	rand uvm_reg_field RXTH;
	rand uvm_reg_field SPI_INTCFG_EN;
	rand uvm_reg_field EN;
	rand uvm_reg_field SPI_INTSTA_TXINT;
	rand uvm_reg_field TXINT;
	rand uvm_reg_field SPI_INTSTA_RXINT;
	rand uvm_reg_field RXINT;

	function new(string name = "qspi");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.SPI_CTRL = ral_reg_qspi_SPI_CTRL::type_id::create("SPI_CTRL",,get_full_name());
      this.SPI_CTRL.configure(this, null, "");
      this.SPI_CTRL.build();
      this.default_map.add_reg(this.SPI_CTRL, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.SPI_CTRL_RD = this.SPI_CTRL.RD;
		this.RD = this.SPI_CTRL.RD;
		this.SPI_CTRL_WR = this.SPI_CTRL.WR;
		this.WR = this.SPI_CTRL.WR;
		this.SPI_CTRL_QRD = this.SPI_CTRL.QRD;
		this.QRD = this.SPI_CTRL.QRD;
		this.SPI_CTRL_QWR = this.SPI_CTRL.QWR;
		this.QWR = this.SPI_CTRL.QWR;
		this.SPI_CTRL_SRST = this.SPI_CTRL.SRST;
		this.SRST = this.SPI_CTRL.SRST;
		this.SPI_CTRL_CS = this.SPI_CTRL.CS;
		this.CS = this.SPI_CTRL.CS;
      this.SPI_STATUS = ral_reg_qspi_SPI_STATUS::type_id::create("SPI_STATUS",,get_full_name());
      this.SPI_STATUS.configure(this, null, "");
      this.SPI_STATUS.build();
      this.default_map.add_reg(this.SPI_STATUS, `UVM_REG_ADDR_WIDTH'h4, "RO", 0);
		this.SPI_STATUS_STATUS = this.SPI_STATUS.STATUS;
		this.STATUS = this.SPI_STATUS.STATUS;
		this.SPI_STATUS_RXELEMS = this.SPI_STATUS.RXELEMS;
		this.RXELEMS = this.SPI_STATUS.RXELEMS;
		this.SPI_STATUS_TXELEMS = this.SPI_STATUS.TXELEMS;
		this.TXELEMS = this.SPI_STATUS.TXELEMS;
      this.SPI_CLKDIV = ral_reg_qspi_SPI_CLKDIV::type_id::create("SPI_CLKDIV",,get_full_name());
      this.SPI_CLKDIV.configure(this, null, "");
      this.SPI_CLKDIV.build();
      this.default_map.add_reg(this.SPI_CLKDIV, `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
		this.SPI_CLKDIV_CLKDIV = this.SPI_CLKDIV.CLKDIV;
		this.CLKDIV = this.SPI_CLKDIV.CLKDIV;
      this.SPI_CMD = ral_reg_qspi_SPI_CMD::type_id::create("SPI_CMD",,get_full_name());
      this.SPI_CMD.configure(this, null, "");
      this.SPI_CMD.build();
      this.default_map.add_reg(this.SPI_CMD, `UVM_REG_ADDR_WIDTH'hC, "RW", 0);
		this.SPI_CMD_CMD = this.SPI_CMD.CMD;
		this.CMD = this.SPI_CMD.CMD;
      this.SPI_ADR = ral_reg_qspi_SPI_ADR::type_id::create("SPI_ADR",,get_full_name());
      this.SPI_ADR.configure(this, null, "");
      this.SPI_ADR.build();
      this.default_map.add_reg(this.SPI_ADR, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.SPI_ADR_ADR = this.SPI_ADR.ADR;
		this.ADR = this.SPI_ADR.ADR;
      this.SPI_LEN = ral_reg_qspi_SPI_LEN::type_id::create("SPI_LEN",,get_full_name());
      this.SPI_LEN.configure(this, null, "");
      this.SPI_LEN.build();
      this.default_map.add_reg(this.SPI_LEN, `UVM_REG_ADDR_WIDTH'h14, "RW", 0);
		this.SPI_LEN_CMDLEN = this.SPI_LEN.CMDLEN;
		this.CMDLEN = this.SPI_LEN.CMDLEN;
		this.SPI_LEN_ADDRLEN = this.SPI_LEN.ADDRLEN;
		this.ADDRLEN = this.SPI_LEN.ADDRLEN;
		this.SPI_LEN_DATALEN = this.SPI_LEN.DATALEN;
		this.DATALEN = this.SPI_LEN.DATALEN;
      this.SPI_DUM = ral_reg_qspi_SPI_DUM::type_id::create("SPI_DUM",,get_full_name());
      this.SPI_DUM.configure(this, null, "");
      this.SPI_DUM.build();
      this.default_map.add_reg(this.SPI_DUM, `UVM_REG_ADDR_WIDTH'h18, "RW", 0);
		this.SPI_DUM_DUMMYRD = this.SPI_DUM.DUMMYRD;
		this.DUMMYRD = this.SPI_DUM.DUMMYRD;
		this.SPI_DUM_DUMMYWR = this.SPI_DUM.DUMMYWR;
		this.DUMMYWR = this.SPI_DUM.DUMMYWR;
      this.SPI_TXFIFO = ral_reg_qspi_SPI_TXFIFO::type_id::create("SPI_TXFIFO",,get_full_name());
      this.SPI_TXFIFO.configure(this, null, "");
      this.SPI_TXFIFO.build();
      this.default_map.add_reg(this.SPI_TXFIFO, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
		this.SPI_TXFIFO_TX = this.SPI_TXFIFO.TX;
		this.TX = this.SPI_TXFIFO.TX;
      this.SPI_RXFIFO = ral_reg_qspi_SPI_RXFIFO::type_id::create("SPI_RXFIFO",,get_full_name());
      this.SPI_RXFIFO.configure(this, null, "");
      this.SPI_RXFIFO.build();
      this.default_map.add_reg(this.SPI_RXFIFO, `UVM_REG_ADDR_WIDTH'h20, "RW", 0);
		this.SPI_RXFIFO_RX = this.SPI_RXFIFO.RX;
		this.RX = this.SPI_RXFIFO.RX;
      this.SPI_INTCFG = ral_reg_qspi_SPI_INTCFG::type_id::create("SPI_INTCFG",,get_full_name());
      this.SPI_INTCFG.configure(this, null, "");
      this.SPI_INTCFG.build();
      this.default_map.add_reg(this.SPI_INTCFG, `UVM_REG_ADDR_WIDTH'h24, "RW", 0);
		this.SPI_INTCFG_TXTH = this.SPI_INTCFG.TXTH;
		this.TXTH = this.SPI_INTCFG.TXTH;
		this.SPI_INTCFG_RXTH = this.SPI_INTCFG.RXTH;
		this.RXTH = this.SPI_INTCFG.RXTH;
		this.SPI_INTCFG_EN = this.SPI_INTCFG.EN;
		this.EN = this.SPI_INTCFG.EN;
      this.SPI_INTSTA = ral_reg_qspi_SPI_INTSTA::type_id::create("SPI_INTSTA",,get_full_name());
      this.SPI_INTSTA.configure(this, null, "");
      this.SPI_INTSTA.build();
      this.default_map.add_reg(this.SPI_INTSTA, `UVM_REG_ADDR_WIDTH'h28, "RO", 0);
		this.SPI_INTSTA_TXINT = this.SPI_INTSTA.TXINT;
		this.TXINT = this.SPI_INTSTA.TXINT;
		this.SPI_INTSTA_RXINT = this.SPI_INTSTA.RXINT;
		this.RXINT = this.SPI_INTSTA.RXINT;
   endfunction : build

	`uvm_object_utils(ral_block_qspi)

endclass : ral_block_qspi



`endif
