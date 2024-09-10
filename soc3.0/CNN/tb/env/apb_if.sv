//cxjl_version_7867
interface apb_if;
    logic   [11:0] PADDR;
    logic   [31:0] PWDATA;    
    logic   PWRITE;	
	logic   PSEL;
	logic   PENABLE;
	logic   [31:0] PRDATA;
	logic   PREADY;
	logic   PSLVERR;
    logic   PCLK;
    logic   PRST;
	clocking drv_cb @(posedge PCLK);
		default input #1 output #1;
		output PWDATA;
		input PRDATA;
	endclocking
endinterface: apb_if
