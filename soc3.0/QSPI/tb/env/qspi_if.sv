interface qspi_if;
	logic  spi_clk;
    logic  spi_csn0;
    logic  spi_csn1;
    logic  spi_csn2;
    logic  spi_csn3;
    logic  spi_sdo0;
    logic  spi_sdo1;
    logic  spi_sdo2;
    logic  spi_sdo3;
    logic  spi_oe0;
    logic  spi_oe1;
    logic  spi_oe2;
    logic  spi_oe3;
    logic  spi_sdi0;
    logic  spi_sdi1;
    logic  spi_sdi2;
    logic  spi_sdi3;
    
    logic [31:0] command_width = 16;
    logic [31:0] addr_width = 16;
    logic [31:0] data_width = 32;
    logic [31:0] rdata_dummy = 3'b100;
    logic [31:0] rdata_addr_dummy = 'h8;
    logic [31:0] wdata_addr_dummy = 'h8;

    logic  interrupt;
    logic  spi_rw;
    logic  spi_quad_mode = 'h1;

endinterface: qspi_if
