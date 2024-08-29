////////////////////////////////
//name:clock.v
//Description: time divide 
//author:zwp
//history:v1.0 
////////////////////////////////
module CLOCK(
input     i_InitialSoc,
input     i_rst_n,
output    o_clk_1k,
output    o_clk_8k,
output    o_clk_32k
);

///////////regs//////////
reg [10:0] cs_wave;
reg [10:0] ns_wave;
//////////wire///////////
wire      w_clk;
wire      w_clk_125k;
wire      w_clk_32k;
wire      w_clk_8k;
wire      w_clk_1k;

/*clock 4 divide*/
always @ (posedge i_InitialSoc or negedge i_rst_n)//i_InitialSoc=2M clk
    if (!i_rst_n)
        begin
            cs_wave  <= 11'b0;
            `ifdef CONFIG_FOR_SIM
            ns_wave  <= 11'b1;
            `endif
        end
    else 
        begin
            cs_wave  <= ns_wave;
        end

always @ *
    begin
        ns_wave = cs_wave + 1'b1; 
    end


assign w_clk = cs_wave[1];// 'w_clk' is 500KHz,4 divide of i_InitialSoc.
assign w_clk_125k = cs_wave[3];// 'w_clk_125k' is 125KHz,4 divide of w_clk.
`ifdef CONFIG_FOR_SIM
assign w_clk_32k = i_InitialSoc; //  32KHz
assign w_clk_8k = cs_wave[1];
assign w_clk_1k = cs_wave[4];
`else
assign w_clk_32k = cs_wave[5];// 'w_clk_32k' is 32KHz clock,4 divide of w_clk_125k.
assign w_clk_8k = cs_wave[7];// 'w_clk_8k' is 8KHz clock,16 divide of w_clk_125k.
assign w_clk_1k = cs_wave[10];// 'w_clk_1k' is 1KHz clock,128 divide of w_clk_125k.
`endif

assign o_clk_32k = w_clk_32k;
assign o_clk_8k  = w_clk_8k;
assign o_clk_1k  = w_clk_1k;
endmodule
