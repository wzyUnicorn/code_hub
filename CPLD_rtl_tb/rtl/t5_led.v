
/////////////////////////////////////
//name: t5_led.v
//author:zwp
//discription:control the led of T5
//time:20170116
/////////////////////////////////////
module T5_LED (
	input       i_clk_32k,
	input       i_rst_n,
	input       i_LED1_1_CPLD,
	input       i_LED1_3_CPLD,
	input       i_LED2_1_CPLD,
	input       i_LED2_3_CPLD,
	output      o_LED1_SPD2_CPLD,
	output      o_LED2_SPD2_CPLD
	);
//////////////regs////////////
reg         cs_LED1_SPD2_CPLD;
reg         ns_LED1_SPD2_CPLD;
reg         cs_LED2_SPD2_CPLD;
reg         ns_LED2_SPD2_CPLD;
reg         r1_LED1_1_CPLD;
reg         r2_LED1_1_CPLD;
reg         r1_LED1_3_CPLD;
reg         r2_LED1_3_CPLD;
reg         r1_LED2_1_CPLD;
reg         r2_LED2_1_CPLD;
reg         r1_LED2_3_CPLD;
reg         r2_LED2_3_CPLD;

//////////////wire////////////

always @ (posedge i_clk_32k , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        cs_LED1_SPD2_CPLD <= 1'b0;///?????????????
        cs_LED2_SPD2_CPLD <= 1'b0;///?????????????
        r1_LED1_1_CPLD    <= 1'b0;
        r2_LED1_1_CPLD    <= 1'b0;
        r1_LED1_3_CPLD    <= 1'b0;
        r2_LED1_3_CPLD    <= 1'b0;
        r1_LED2_1_CPLD    <= 1'b0;
        r2_LED2_1_CPLD    <= 1'b0;
        r1_LED2_3_CPLD    <= 1'b0;
        r2_LED2_3_CPLD    <= 1'b0;
    end
    else
    begin
        cs_LED1_SPD2_CPLD <= ns_LED1_SPD2_CPLD;
        cs_LED2_SPD2_CPLD <= ns_LED2_SPD2_CPLD;
        r1_LED1_1_CPLD    <= i_LED1_1_CPLD;
        r2_LED1_1_CPLD    <= r1_LED1_1_CPLD;
        r1_LED1_3_CPLD    <= i_LED1_3_CPLD;
        r2_LED1_3_CPLD    <= r1_LED1_3_CPLD;
        r1_LED2_1_CPLD    <= i_LED2_1_CPLD;
        r2_LED2_1_CPLD    <= r1_LED2_1_CPLD;
        r1_LED2_3_CPLD    <= i_LED2_3_CPLD;
        r2_LED2_3_CPLD    <= r1_LED2_3_CPLD;
    end
end

always @ *
begin
    ns_LED1_SPD2_CPLD = cs_LED1_SPD2_CPLD;
    case({r2_LED1_3_CPLD,r2_LED1_1_CPLD})
    2'b00:
    begin
    	ns_LED1_SPD2_CPLD = 1'b1;
    end
    2'b01:
    begin
    	ns_LED1_SPD2_CPLD = 1'b0;
    end
    2'b10:
    begin
    	ns_LED1_SPD2_CPLD = 1'b0;
    end
    2'b11:
    begin
    	ns_LED1_SPD2_CPLD = 1'b1;
    end
    default:
    begin
    	ns_LED1_SPD2_CPLD = 1'b0;
    end
    endcase
end

always @ *
begin
    ns_LED2_SPD2_CPLD = cs_LED2_SPD2_CPLD;
    case({r2_LED2_3_CPLD,r2_LED2_1_CPLD})
    2'b00:
    begin
    	ns_LED2_SPD2_CPLD = 1'b1;
    end
    2'b01:
    begin
    	ns_LED2_SPD2_CPLD = 1'b0;
    end
    2'b10:
    begin
    	ns_LED2_SPD2_CPLD = 1'b0;
    end
    2'b11:
    begin
    	ns_LED2_SPD2_CPLD = 1'b1;
    end
    default:
    begin
    	ns_LED2_SPD2_CPLD = 1'b0;
    end
    endcase
end

assign 	o_LED1_SPD2_CPLD = cs_LED1_SPD2_CPLD;
assign 	o_LED2_SPD2_CPLD = cs_LED2_SPD2_CPLD;


endmodule
