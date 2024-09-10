interface isp_if;
	logic  demosic_en;
    logic  dgain_en;
    logic  [7:0] dgain_gain;
    logic  [7:0] dgain_offset;
    logic  [7:0] dm_b_o;
    logic  [7:0] dm_g_o;
    logic  [7:0] dm_r_o;
    logic  dm_href_o;
    logic  dm_vsync_o;
    logic  in_href;
    logic  [7:0] in_raw;
    logic  in_vsync;
    logic  pclk;
    logic  rst_n;
    logic [31:0] isp_width;
    logic [31:0] isp_height;
endinterface: isp_if
