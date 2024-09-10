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
endinterface: apb_if
