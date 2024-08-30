module tb;
    
logic           clk = 0     ;
logic           rst = 0     ;
logic           led         ;

always #5 clk = ~clk        ;

initial begin
    #50ns;
    rst = 1 ;
    #1ms;
    $finish;
end
breath_led  u_breath_led(
        //clk & rst
        .clk           (clk     ),
        .rst           (rst     ),
        //led output   ()     
        .led           (led     )  
);

//----------------------------------
//gen fsdb
//----------------------------------

initial	begin
	    $fsdbDumpfile("tb.fsdb");	    
        $fsdbDumpvars;
end

endmodule
