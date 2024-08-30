module breath_led(
        //clk & rst
    `ifdef FPGA_SYN
        input               clk_in_p    ,
        input               clk_in_n    ,
        input               rst_n       ,
    `else
        input               rst         ,
        input               clk         ,
    `endif
        //led output        
        output              led         
);

`ifdef FPGA_SYN
localparam  pwm_cnt_max = 16'd10_000  ;
`else
localparam  pwm_cnt_max = 16'd100   ;
`endif


reg [15:0]       pwm_cnt     ;
reg [15:0]      thre_cnt    ;
reg             cnt_flag    ;



`ifdef FPGA_SYN
wire            rst         ;
wire            clk         ;

sysclk_wiz      u_sysclk_wiz(
    // Clock out ports
    .clk_out1   (clk        ),      // output clk_out1
    // Status and control signals
    .resetn     (rst_n      ),      // input resetn
    .locked     (rst        ),      // output locked
   // Clock in ports
    .clk_in1_p  (clk_in_p   ),      // input clk_in1_p
    .clk_in1_n  (clk_in_n   )       // input clk_in1_n
);    // INST_TAG_END ------ End INSTANTIATION Template ---------
`endif

//pwm counter
always @(posedge clk or negedge rst) begin
    if(!rst)
        pwm_cnt <= 16'd0;
    else if(pwm_cnt >= pwm_cnt_max)
        pwm_cnt <= 16'd0;
    else
        pwm_cnt <= pwm_cnt + 1'b1;
end


always @(posedge clk or negedge rst) begin
    if(!rst)
        thre_cnt <=16'd0;
    else if (pwm_cnt == pwm_cnt_max) begin
        if (cnt_flag)
            thre_cnt <= thre_cnt - 1'd1;
        else
            thre_cnt <= thre_cnt + 1'd1;
    end
end

always @(posedge clk) begin
    if (thre_cnt == 16'd0)
        cnt_flag = 1'b0;
    else if(thre_cnt == pwm_cnt_max)
        cnt_flag = 1'b1;
end

assign led = pwm_cnt >= thre_cnt ? 1'b1:1'b0;

endmodule



