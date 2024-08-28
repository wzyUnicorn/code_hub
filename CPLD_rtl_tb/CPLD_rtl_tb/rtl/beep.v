///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: <beep.v>
// File history:
//
// Description: 
//
// control the buzzer
//
// Targeted device: <Family> <Die> <Package>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// // beep.v


module BEEP( 
    i_clk_32k, 
    i_Rst_n, 
   // i_Intrude_n,
//    i_Buzzer,
    i_BeepEnable,
    i_divide,
    o_Buzzer  
);

input  i_clk_32k; 
input  i_Rst_n;
//input  i_Intrude_n;
//input  i_Buzzer;
input  i_BeepEnable;
input [ 4: 0]  i_divide;

output o_Buzzer;

reg [ 5: 0] cs_wave;
reg [ 5: 0] ns_wave;
reg [ 0: 0] cs_buzzer;
reg [ 0: 0] ns_buzzer;
reg [ 4: 0] r1_divide;
reg [ 4: 0] r2_divide;
//reg         r1_Intrude_n;
//reg         r2_Intrude_n;
//reg         r1_Buzzer;
//reg         r2_Buzzer;
reg         r1_BeepEnable;
reg         r2_BeepEnable;
wire        w_buzzer_en;

always @ (posedge i_clk_32k or negedge i_Rst_n)
if (!i_Rst_n)
begin
    cs_wave       <= 6'b0;
    cs_buzzer     <= 1'b0;
    //ns_wave       <= 3'b1;
    /*  delay 2 clk  synchronous option */
    r1_divide     <= 5'h8; 
    r2_divide     <= 5'h8; 
 //   r1_Intrude_n  <= 1'b1; 
 //   r2_Intrude_n  <= 1'b1; 
    r1_BeepEnable <= 1'b0; 
    r2_BeepEnable <= 1'b0; 
//    r1_Buzzer     <= 1'b0; 
//    r2_Buzzer     <= 1'b0; 
end
else
begin
    cs_wave       <= ns_wave;
    cs_buzzer     <= ns_buzzer;
    r1_divide     <= i_divide; 
    r2_divide     <= r1_divide; 
//    r1_Intrude_n  <= i_Intrude_n;
//    r2_Intrude_n  <= r1_Intrude_n;
    r1_BeepEnable <= i_BeepEnable;
    r2_BeepEnable <= r1_BeepEnable;
   // r1_Buzzer     <= i_Buzzer;
   // r2_Buzzer     <= r1_Buzzer;
end

always @ *
begin
    ns_wave = cs_wave + 1'b1;
end
always @ *
begin
    ns_buzzer = cs_buzzer;
    if      (r2_divide[0]) ns_buzzer = cs_wave[1];
    else if (r2_divide[1]) ns_buzzer = cs_wave[2];
    else if (r2_divide[2]) ns_buzzer = cs_wave[3];
    else if (r2_divide[3]) ns_buzzer = cs_wave[4];
    else if (r2_divide[4]) ns_buzzer = cs_wave[5];
    else                   ns_buzzer = 1'b0;
end

assign w_buzzer_en =  r2_BeepEnable ;
assign o_Buzzer = w_buzzer_en? cs_buzzer : 1'b0; // 'cs_wave[2]' is 8 divide of i_clk_32k
endmodule

