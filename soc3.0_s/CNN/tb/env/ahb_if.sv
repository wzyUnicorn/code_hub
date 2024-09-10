interface ahb_if;

    logic          hclk      ;
    logic          hrstn     ;
    logic          hsel      ;
    logic   [31:0] haddr     ;
    logic   [ 1:0] htrans    ;
    logic   [ 2:0] hsize     ;
    logic   [2:0]  hburst    ;
    logic          hwrite    ;
    logic          hready    ;
    logic   [31:0] hwdata    ;
    logic   [31:0] hrdata    ;
    logic          hreadyout ;
    logic   [1:0]  hresp     ;

endinterface: ahb_if
