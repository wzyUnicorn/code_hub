module gnrl_io_pad#(
  parameter PUP = 1,
  parameter PDN = 1
  ) (
  output             pad_i_ival                    ,
  input              pad_o_ie                      ,
  input              pad_o_oval                    ,
  input              pad_o_oe                      ,
  input              pad_o_pue                     ,
  input              pad_o_pde                     ,
  input              pad_o_os                      ,
  input              pad_o_od                      ,
  input              pad_o_cs                      ,
  input              pad_o_dr                      ,
  input              pad_o_sr                      ,
 // input              pad_o_keep                    ,
 // input              pad_o_analog                  ,
//  input              pad_o_spw                     ,

  inout              pad                           ,
  inout              analog_io                     

);

//wire pad_o_pue_analog;
//wire pad_o_pde_analog;
//wire pad_o_oe_analog;
//assign pad_o_pue_analog  = pad_o_analog ? 1'b0 : pad_o_pue;
//assign pad_o_pde_analog  = pad_o_analog ? 1'b0 : pad_o_pde;
//assign pad_o_oe_analog   = pad_o_analog ? 1'b0 : pad_o_oe;

//wire pad_o_keep_analog;
//assign pad_o_keep_analog = pad_o_analog ? 1'b0 : pad_o_keep;
//wire pad_o_pue_keep;
//wire pad_o_pde_keep;
//assign pad_o_pue_keep = pad_o_keep_analog ? pad_i_ival : pad_o_pue_analog;
//assign pad_o_pde_keep = pad_o_keep_analog ? ~pad_i_ival : pad_o_pde_analog;

`ifdef TECH_HH90
    generate

RCMCU_PLBMUX u_pad (
    .PAD     (pad           ),
    .Y       (pad_i_ival    ),
    .YA      (analog_io     ),
    .A       (pad_o_oval    ),
    .IE      (pad_o_ie      ),
    .OS      (pad_o_os      ),
    .PD      (pad_o_pde     ),
    .OD      (pad_o_od      ),
    .PU      (pad_o_pue     ),
    .CS      (pad_o_cs	    ),   //cmos or schmitt
    .OE      (pad_o_oe      ),
    .DR      (pad_o_dr      ), //drive stren
    .SR      (pad_o_sr      )
    );

endgenerate

`endif

`ifndef TECH_HH90 
  `ifndef SYNTHESIS 

generate
if (PUP == 1)
begin
wire pupwire;
pullup(pupwire);
tranif1(pupwire, pad, pad_o_pue);
end
if (PDN == 1)
begin
wire pdnwire;
pulldown(pdnwire);
tranif1(pdnwire, pad, pad_o_pde);
end
endgenerate
  `endif 
assign pad_i_ival = pad & pad_o_ie;
assign pad = pad_o_oe ? pad_o_oval : 1'bz;
`endif 
endmodule