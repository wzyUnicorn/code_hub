///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <power_state.v>
// File history:
//
// Description: 
//control the FSM of power state
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////
module POWER_STATE(
input        i_clk_32k,
input        i_rst_n,
input        i_pwr_btn_en,
input        i_btn_press4s,
input        i_ButtonPressed,
input        i_reg_pwr_off,
output       o_ctrl_PSON,
output       o_btn_pwr_off_en,
output [2:0] o_PowerState
);

//////////////////parameters/////////
    parameter PSIdle          = 3'b000;
    parameter PSStartCnt      = 3'b001;
    parameter PSGotoPowerUp   = 3'b010;
    parameter PSPowerDown     = 3'b011;
    parameter PSPowerUp       = 3'b100;
    parameter PSGotoPowerDown = 3'b101;
/////////////////regs////////////////
reg [2:0]   cs_PowerState;
reg [2:0]   ns_PowerState;
reg         cs_btn_pwr_off_en;
reg         ns_btn_pwr_off_en;
reg         r1_btn_pwr_off_en;
reg         r2_btn_pwr_off_en;

////////////////////////////////////////////////////////////////////////////
    always @(posedge i_clk_32k or negedge i_rst_n)
    	if (!i_rst_n) 
            begin
                cs_PowerState <=#1 3'b000;
                cs_btn_pwr_off_en <= 1'b0;
                r1_btn_pwr_off_en <= 1'b0;
                r2_btn_pwr_off_en <= 1'b0;
            end 
            else 
            begin
                cs_PowerState <=#1 ns_PowerState ;
                cs_btn_pwr_off_en <= ns_btn_pwr_off_en;
                r1_btn_pwr_off_en <= cs_PowerState[2];
                r2_btn_pwr_off_en <= r1_btn_pwr_off_en;
            end

    always @ *
        begin
            ns_btn_pwr_off_en = cs_btn_pwr_off_en;
            if(r2_btn_pwr_off_en&(!r1_btn_pwr_off_en))//--|__  //输出1个周期关机信号
            begin
                ns_btn_pwr_off_en = 1'b1;
            end
            else
            begin
                ns_btn_pwr_off_en = 1'b0;
            end

//control power state of PSON
            ns_PowerState = cs_PowerState ;
            case(cs_PowerState)
            PSIdle: //verify button not stuck, wait for release
                if (!i_ButtonPressed && i_pwr_btn_en) 
                    ns_PowerState= PSStartCnt; 
            PSStartCnt: //wait for power-on button triggered
                if (i_ButtonPressed)  begin 
                    ns_PowerState= PSGotoPowerUp;
                end else begin
                    ns_PowerState= PSStartCnt;
                end
            PSGotoPowerUp: //when button released power on
                if (!i_ButtonPressed) begin 
                    ns_PowerState= PSPowerUp;     //power button released, power-on
                end else 
                begin
                    ns_PowerState = PSGotoPowerUp;
                end
            PSPowerUp:
                if (i_ButtonPressed) begin       //power button pressed during working
                    ns_PowerState = PSGotoPowerDown; 
                end 
				else
					begin
					//ns_PowerState= PSPowerUp;
                    if (i_reg_pwr_off) 
						ns_PowerState= PSPowerDown;
                    else               
						ns_PowerState= PSPowerUp;
                end
            PSGotoPowerDown: 
            begin
                if (!(i_ButtonPressed || i_reg_pwr_off)) begin 
                    ns_PowerState= PSPowerUp;     
                end 
				else 
					begin              //power button continue pressed
                    if (i_btn_press4s || i_reg_pwr_off) 
						ns_PowerState= PSPowerDown;   //4s shutdown||soft power off
                    else                                
						ns_PowerState= PSGotoPowerDown;
                end
            end
            default:  
                ns_PowerState= PSIdle;         //return to idle when released
            endcase
	end

assign   o_PowerState = cs_PowerState;
assign   o_ctrl_PSON  = cs_PowerState[2];
assign   o_btn_pwr_off_en = cs_btn_pwr_off_en;
endmodule
