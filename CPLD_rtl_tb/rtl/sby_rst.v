////////////////////////////////
//module:sby_rst.v
//discription:produce rst for all area
//history:v1.0 initial version,  20170109
//name:zwp
///////////////////////////////
module SBY_RST(
input      i_InitialSoc,
input      i_DCOKSby,
output     o_SbyReset_n
);

/////////////regs///////////////
reg        r1_DCOK;
reg        r2_DCOK;
reg        cs_DCOK_n;
reg        ns_DCOK_n;
reg        cs_SbyPowerGood_n;
reg        ns_SbyPowerGood_n;
`ifdef CONFIG_FOR_SIM
reg [3:0]  cs_DCOK_DlyCnt;
reg [3:0]  ns_DCOK_DlyCnt;
reg [3:0]  cs_PowerUpDlyCnt;
reg [3:0]  ns_PowerUpDlyCnt;
`else
reg [16:0] cs_DCOK_DlyCnt;
reg [16:0] ns_DCOK_DlyCnt;
reg [7:0]  cs_PowerUpDlyCnt;
reg [7:0]  ns_PowerUpDlyCnt;
`endif

//////////wire////////////
wire         w_DCOK_PowerGood_n;

//synchronize reset

    always @(posedge i_InitialSoc or  negedge i_DCOKSby)
        if (!i_DCOKSby)	
            begin
                r1_DCOK <= 1'b0;
                r2_DCOK <= 1'b0;
            end
        else 
            begin
                r1_DCOK <= 1'b1;
                r2_DCOK <= r1_DCOK;
            end

 always @(posedge i_InitialSoc or  negedge r2_DCOK)
        if (!r2_DCOK)
        begin
            `ifdef CONFIG_FOR_SIM
            cs_DCOK_DlyCnt <= 4'b0;
            `else
            cs_DCOK_DlyCnt <= 17'b0;
            `endif
            cs_DCOK_n<= 1'b0;
        end
        else
            begin
            `ifdef CONFIG_FOR_SIM
            cs_DCOK_DlyCnt<= ns_DCOK_DlyCnt;
            `else
            cs_DCOK_DlyCnt <= ns_DCOK_DlyCnt;
            `endif
            cs_DCOK_n<= ns_DCOK_n; 
        end
    always @ *  
        begin
            `ifdef CONFIG_FOR_SIM
             ns_DCOK_DlyCnt = cs_DCOK_DlyCnt;
            `else
             ns_DCOK_DlyCnt = cs_DCOK_DlyCnt;
            `endif
             ns_DCOK_n= cs_DCOK_n;
             if (!(&cs_DCOK_DlyCnt))
                  ns_DCOK_DlyCnt = cs_DCOK_DlyCnt + 1'b1;
             ns_DCOK_n = (&cs_DCOK_DlyCnt);
        end
	////////////////////////////////////////////////////////
    always @(posedge i_InitialSoc or negedge w_DCOK_PowerGood_n)
        if (!w_DCOK_PowerGood_n)
        begin
            `ifdef CONFIG_FOR_SIM
            cs_PowerUpDlyCnt <= 4'b0;
            `else
            cs_PowerUpDlyCnt <= 8'b0;
            `endif
            cs_SbyPowerGood_n<= 1'b0;
        end
        else
            begin
            `ifdef CONFIG_FOR_SIM
            cs_PowerUpDlyCnt<= ns_PowerUpDlyCnt;
            `else
            cs_PowerUpDlyCnt <= ns_PowerUpDlyCnt;
            `endif
            cs_SbyPowerGood_n<= ns_SbyPowerGood_n; 
        end
    always @ *  
        begin
            `ifdef CONFIG_FOR_SIM
             ns_PowerUpDlyCnt = cs_PowerUpDlyCnt;
            `else
             ns_PowerUpDlyCnt = cs_PowerUpDlyCnt;
            `endif
             ns_SbyPowerGood_n= cs_SbyPowerGood_n;
             if (!(&cs_PowerUpDlyCnt))
                  ns_PowerUpDlyCnt = cs_PowerUpDlyCnt + 1'b1;
             ns_SbyPowerGood_n = (&cs_PowerUpDlyCnt);
        end

    assign w_DCOK_PowerGood_n = cs_DCOK_n;
    assign o_SbyReset_n       = cs_SbyPowerGood_n;

endmodule
