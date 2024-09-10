//**********************************************
//  File Name: isp_top.v
//  Author   : hubing
//  Function : TOP module
//**********************************************
module isp_top #(
  parameter BITS      = 8   ,
  parameter WIDTH     = 256 ,
  parameter HEIGHT    = 10 ,
  parameter BAYER     = 0     //0:RGGB 1:GRBG 2:GBRG 3:BGGR
)(
  input             pclk       ,
  input             rst_n      ,
  
  input             in_href    ,
  input             in_vsync   ,
  input [BITS-1:0]  in_raw     ,
  
  output            dm_href_o  ,
  output            dm_vsync_o ,
  output [BITS-1:0] dm_r_o     ,
  output [BITS-1:0] dm_g_o     ,
  output [BITS-1:0] dm_b_o     ,
  
  input             dgain_en   , 
  input             demosic_en , 

  input [     7:0]  dgain_gain    ,
  input [BITS-1:0]  dgain_offset
);

//`define USE_DGAIN 1
`define USE_DEMOSIC 1

  wire dgain_href_o, dgain_vsync_o ;
  wire dgain_href  , dgain_vsync   ;

  wire [BITS-1:0] dgain_raw_o;
  wire [BITS-1:0] dgain_raw;
  wire [BITS-1:0] dm_r;
  wire [BITS-1:0] dm_g;
  wire [BITS-1:0] dm_b;

`ifdef USE_DGAIN
    isp_dgain #(BITS, WIDTH, HEIGHT) dgain_i0(
        .pclk       (pclk          ),
        .rst_n      (rst_n&dgain_en),
        .gain       (dgain_gain    ),
        .offset     (dgain_offset  ),
        .in_href    (in_href       ),
        .in_vsync   (in_vsync      ),  
        .in_raw     (in_raw        ), 
        .out_href   (dgain_href    ), 
        .out_vsync  (dgain_vsync   ), 
        .out_raw    (dgain_raw     )
    );

    vid_mux #(BITS) mux_dgain_i0(
        .pclk       (pclk          ), 
        .rst_n      (rst_n         ), 
        .sel        (dgain_en      ), 
        .in_href_0  (in_href       ), 
        .in_vsync_0 (in_vsync      ), 
        .in_data_0  (in_raw        ), 
        .in_href_1  (dgain_href    ), 
        .in_vsync_1 (dgain_vsync   ), 
        .in_data_1  (dgain_raw     ), 
        .out_href   (dgain_href_o  ), 
        .out_vsync  (dgain_vsync_o ), 
        .out_data   (dgain_raw_o   )
    );
`else
    assign dgain_href_o  = in_href  ;
    assign dgain_vsync_o = in_vsync ;
    assign dgain_raw_o   = in_raw   ;
`endif

`ifdef USE_DEMOSIC
    isp_demosaic #(BITS, WIDTH, HEIGHT, BAYER) demosaic_i0(
        .pclk      (pclk             ), 
        .rst_n     (rst_n&demosic_en ), 
        .in_href   (dgain_href_o     ), 
        .in_vsync  (dgain_vsync_o    ), 
        .in_raw    (dgain_raw_o      ), 
        .out_href  (dm_href          ), 
        .out_vsync (dm_vsync         ), 
        .out_r     (dm_r             ), 
        .out_g     (dm_g             ), 
        .out_b     (dm_b             )
    );

    vid_mux #(BITS*3) mux_demosaic_i0(
        .pclk       (pclk            ), 
        .rst_n      (rst_n           ), 
        .sel        (demosic_en      ), 
        .in_href_0  (dgain_href_o    ), 
        .in_vsync_0 (dgain_vsync_o   ), 
        .in_data_0  ({3{dgain_raw_o}}), 
        .in_href_1  (dm_href         ), 
        .in_vsync_1 (dm_vsync        ), 
        .in_data_1  ({dm_r,dm_g,dm_b}), 
        .out_href   (dm_href_o       ), 
        .out_vsync  (dm_vsync_o      ), 
        .out_data   ({dm_r_o,dm_g_o,dm_b_o})
    );
`else
    assign dm_href_o  = dgain_href_o  ;
    assign dm_vsync_o = dgain_vsync_o ;
    assign dm_r_o     = dgain_raw_o   ;
    assign dm_g_o     = dgain_raw_o   ;
    assign dm_b_o     = dgain_raw_o   ;
`endif

endmodule

module vid_mux #(
  parameter BITS = 8
)(
  input              pclk       ,
  input              rst_n      ,

  input              sel        ,

  input              in_href_0  ,
  input              in_vsync_0 ,
  input [BITS-1:0]   in_data_0  ,

  input              in_href_1  ,
  input              in_vsync_1 ,
  input [BITS-1:0]   in_data_1  ,

  output             out_href   ,
  output             out_vsync  ,
  output [BITS-1:0]  out_data
);

  wire in_href  = sel ? in_href_1  : in_href_0  ;
  wire in_vsync = sel ? in_vsync_1 : in_vsync_0 ;

  wire [BITS-1:0] in_data = sel ? in_data_1 : in_data_0;

  reg href_reg, vsync_reg;
  reg [BITS-1:0] data_reg;
  
  always @(posedge pclk or negedge rst_n) begin
      if(!rst_n) begin
          href_reg  <= 0;
          vsync_reg <= 0;
          data_reg  <= 0;
      end
      else begin
          href_reg  <= in_href ;
          vsync_reg <= in_vsync;
          data_reg  <= in_data ;
      end
  end
  
  assign out_href  = href_reg  ;
  assign out_vsync = vsync_reg ;
  assign out_data  = data_reg  ;

endmodule
