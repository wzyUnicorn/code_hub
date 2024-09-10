module pin_mux_rf (
	input                                  clk                 ,                   
	input                                  rst_n               ,                   

	output             [2:0]               r_io_reuse_pad2     ,                   
	output             [2:0]               r_io_reuse_pad1     ,                   
	output             [2:0]               r_io_reuse_pad4     ,                   
	output             [2:0]               r_io_reuse_pad3     ,                   
	output             [2:0]               r_io_reuse_pad6     ,                   
	output             [2:0]               r_io_reuse_pad5     ,                   
	output             [2:0]               r_io_reuse_pad8     ,                   
	output             [2:0]               r_io_reuse_pad7     ,                   
	output             [2:0]               r_io_reuse_pad10    ,                   
	output             [2:0]               r_io_reuse_pad9     ,                   
	output             [2:0]               r_io_reuse_pad12    ,                   
	output             [2:0]               r_io_reuse_pad11    ,                   
	output             [2:0]               r_io_reuse_pad14    ,                   
	output             [2:0]               r_io_reuse_pad13    ,                   
	output             [2:0]               r_io_reuse_pad16    ,                   
	output             [2:0]               r_io_reuse_pad15    ,                   
	output             [2:0]               r_io_reuse_pad18    ,                   
	output             [2:0]               r_io_reuse_pad17    ,                   
	output             [2:0]               r_io_reuse_pad20    ,                   
	output             [2:0]               r_io_reuse_pad19    ,                   
	input              [15:0]              sft_adr_i           ,                   
	input              [7:0]               sft_dat_i           ,                   
	input                                  sft_wr_i            ,                   
	input                                  sft_rd_i            ,                   
	output                                 sft_rd_cs           ,                   
	output             [7:0]               sft_dat_o                               
);

wire                          sel_sft_io_reuse_0x00         =	sft_adr_i                   ==                  16'h0               ;                   
wire                          sel_sft_io_reuse_0x00_wen     =	sel_sft_io_reuse_0x00       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x01         =	sft_adr_i                   ==                  16'h1               ;                   
wire                          sel_sft_io_reuse_0x01_wen     =	sel_sft_io_reuse_0x01       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x02         =	sft_adr_i                   ==                  16'h2               ;                   
wire                          sel_sft_io_reuse_0x02_wen     =	sel_sft_io_reuse_0x02       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x03         =	sft_adr_i                   ==                  16'h3               ;                   
wire                          sel_sft_io_reuse_0x03_wen     =	sel_sft_io_reuse_0x03       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x04         =	sft_adr_i                   ==                  16'h4               ;                   
wire                          sel_sft_io_reuse_0x04_wen     =	sel_sft_io_reuse_0x04       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x05         =	sft_adr_i                   ==                  16'h5               ;                   
wire                          sel_sft_io_reuse_0x05_wen     =	sel_sft_io_reuse_0x05       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x06         =	sft_adr_i                   ==                  16'h6               ;                   
wire                          sel_sft_io_reuse_0x06_wen     =	sel_sft_io_reuse_0x06       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x07         =	sft_adr_i                   ==                  16'h7               ;                   
wire                          sel_sft_io_reuse_0x07_wen     =	sel_sft_io_reuse_0x07       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x08         =	sft_adr_i                   ==                  16'h8               ;                   
wire                          sel_sft_io_reuse_0x08_wen     =	sel_sft_io_reuse_0x08       &                   sft_wr_i            ;                   
wire                          sel_sft_io_reuse_0x09         =	sft_adr_i                   ==                  16'h9               ;                   
wire                          sel_sft_io_reuse_0x09_wen     =	sel_sft_io_reuse_0x09       &                   sft_wr_i            ;                   
reg       [2:0]               reg_io_reuse_pad2             ;                   
wire      [2:0]               nxt_io_reuse_pad2             ;                   
assign                        r_io_reuse_pad2               =	reg_io_reuse_pad2                     ;                   
assign                        nxt_io_reuse_pad2             =	sel_sft_io_reuse_0x00_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad2  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad2	<=	3'h0 ;
	else 
		reg_io_reuse_pad2	<=	nxt_io_reuse_pad2 ;
end

reg       [2:0]               reg_io_reuse_pad1             ;                   
wire      [2:0]               nxt_io_reuse_pad1             ;                   
assign                        r_io_reuse_pad1               =	reg_io_reuse_pad1                     ;                   
assign                        nxt_io_reuse_pad1             =	sel_sft_io_reuse_0x00_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad1  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad1	<=	3'h0 ;
	else 
		reg_io_reuse_pad1	<=	nxt_io_reuse_pad1 ;
end

reg       [2:0]               reg_io_reuse_pad4             ;                   
wire      [2:0]               nxt_io_reuse_pad4             ;                   
assign                        r_io_reuse_pad4               =	reg_io_reuse_pad4                     ;                   
assign                        nxt_io_reuse_pad4             =	sel_sft_io_reuse_0x01_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad4  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad4	<=	3'h0 ;
	else 
		reg_io_reuse_pad4	<=	nxt_io_reuse_pad4 ;
end

reg       [2:0]               reg_io_reuse_pad3             ;                   
wire      [2:0]               nxt_io_reuse_pad3             ;                   
assign                        r_io_reuse_pad3               =	reg_io_reuse_pad3                     ;                   
assign                        nxt_io_reuse_pad3             =	sel_sft_io_reuse_0x01_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad3  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad3	<=	3'h0 ;
	else 
		reg_io_reuse_pad3	<=	nxt_io_reuse_pad3 ;
end

reg       [2:0]               reg_io_reuse_pad6             ;                   
wire      [2:0]               nxt_io_reuse_pad6             ;                   
assign                        r_io_reuse_pad6               =	reg_io_reuse_pad6                     ;                   
assign                        nxt_io_reuse_pad6             =	sel_sft_io_reuse_0x02_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad6  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad6	<=	3'h0 ;
	else 
		reg_io_reuse_pad6	<=	nxt_io_reuse_pad6 ;
end

reg       [2:0]               reg_io_reuse_pad5             ;                   
wire      [2:0]               nxt_io_reuse_pad5             ;                   
assign                        r_io_reuse_pad5               =	reg_io_reuse_pad5                     ;                   
assign                        nxt_io_reuse_pad5             =	sel_sft_io_reuse_0x02_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad5  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad5	<=	3'h0 ;
	else 
		reg_io_reuse_pad5	<=	nxt_io_reuse_pad5 ;
end

reg       [2:0]               reg_io_reuse_pad8             ;                   
wire      [2:0]               nxt_io_reuse_pad8             ;                   
assign                        r_io_reuse_pad8               =	reg_io_reuse_pad8                     ;                   
assign                        nxt_io_reuse_pad8             =	sel_sft_io_reuse_0x03_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad8  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad8	<=	3'h0 ;
	else 
		reg_io_reuse_pad8	<=	nxt_io_reuse_pad8 ;
end

reg       [2:0]               reg_io_reuse_pad7             ;                   
wire      [2:0]               nxt_io_reuse_pad7             ;                   
assign                        r_io_reuse_pad7               =	reg_io_reuse_pad7                     ;                   
assign                        nxt_io_reuse_pad7             =	sel_sft_io_reuse_0x03_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad7  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad7	<=	3'h0 ;
	else 
		reg_io_reuse_pad7	<=	nxt_io_reuse_pad7 ;
end

reg       [2:0]               reg_io_reuse_pad10            ;                   
wire      [2:0]               nxt_io_reuse_pad10            ;                   
assign                        r_io_reuse_pad10              =	reg_io_reuse_pad10                    ;                   
assign                        nxt_io_reuse_pad10            =	sel_sft_io_reuse_0x04_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad10 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad10	<=	3'h0 ;
	else 
		reg_io_reuse_pad10	<=	nxt_io_reuse_pad10 ;
end

reg       [2:0]               reg_io_reuse_pad9             ;                   
wire      [2:0]               nxt_io_reuse_pad9             ;                   
assign                        r_io_reuse_pad9               =	reg_io_reuse_pad9                     ;                   
assign                        nxt_io_reuse_pad9             =	sel_sft_io_reuse_0x04_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad9  ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad9	<=	3'h0 ;
	else 
		reg_io_reuse_pad9	<=	nxt_io_reuse_pad9 ;
end

reg       [2:0]               reg_io_reuse_pad12            ;                   
wire      [2:0]               nxt_io_reuse_pad12            ;                   
assign                        r_io_reuse_pad12              =	reg_io_reuse_pad12                    ;                   
assign                        nxt_io_reuse_pad12            =	sel_sft_io_reuse_0x05_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad12 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad12	<=	3'h0 ;
	else 
		reg_io_reuse_pad12	<=	nxt_io_reuse_pad12 ;
end

reg       [2:0]               reg_io_reuse_pad11            ;                   
wire      [2:0]               nxt_io_reuse_pad11            ;                   
assign                        r_io_reuse_pad11              =	reg_io_reuse_pad11                    ;                   
assign                        nxt_io_reuse_pad11            =	sel_sft_io_reuse_0x05_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad11 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad11	<=	3'h0 ;
	else 
		reg_io_reuse_pad11	<=	nxt_io_reuse_pad11 ;
end

reg       [2:0]               reg_io_reuse_pad14            ;                   
wire      [2:0]               nxt_io_reuse_pad14            ;                   
assign                        r_io_reuse_pad14              =	reg_io_reuse_pad14                    ;                   
assign                        nxt_io_reuse_pad14            =	sel_sft_io_reuse_0x06_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad14 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad14	<=	3'h0 ;
	else 
		reg_io_reuse_pad14	<=	nxt_io_reuse_pad14 ;
end

reg       [2:0]               reg_io_reuse_pad13            ;                   
wire      [2:0]               nxt_io_reuse_pad13            ;                   
assign                        r_io_reuse_pad13              =	reg_io_reuse_pad13                    ;                   
assign                        nxt_io_reuse_pad13            =	sel_sft_io_reuse_0x06_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad13 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad13	<=	3'h0 ;
	else 
		reg_io_reuse_pad13	<=	nxt_io_reuse_pad13 ;
end

reg       [2:0]               reg_io_reuse_pad16            ;                   
wire      [2:0]               nxt_io_reuse_pad16            ;                   
assign                        r_io_reuse_pad16              =	reg_io_reuse_pad16                    ;                   
assign                        nxt_io_reuse_pad16            =	sel_sft_io_reuse_0x07_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad16 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad16	<=	3'h0 ;
	else 
		reg_io_reuse_pad16	<=	nxt_io_reuse_pad16 ;
end

reg       [2:0]               reg_io_reuse_pad15            ;                   
wire      [2:0]               nxt_io_reuse_pad15            ;                   
assign                        r_io_reuse_pad15              =	reg_io_reuse_pad15                    ;                   
assign                        nxt_io_reuse_pad15            =	sel_sft_io_reuse_0x07_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad15 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad15	<=	3'h0 ;
	else 
		reg_io_reuse_pad15	<=	nxt_io_reuse_pad15 ;
end

reg       [2:0]               reg_io_reuse_pad18            ;                   
wire      [2:0]               nxt_io_reuse_pad18            ;                   
assign                        r_io_reuse_pad18              =	reg_io_reuse_pad18                    ;                   
assign                        nxt_io_reuse_pad18            =	sel_sft_io_reuse_0x08_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad18 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad18	<=	3'h0 ;
	else 
		reg_io_reuse_pad18	<=	nxt_io_reuse_pad18 ;
end

reg       [2:0]               reg_io_reuse_pad17            ;                   
wire      [2:0]               nxt_io_reuse_pad17            ;                   
assign                        r_io_reuse_pad17              =	reg_io_reuse_pad17                    ;                   
assign                        nxt_io_reuse_pad17            =	sel_sft_io_reuse_0x08_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad17 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad17	<=	3'h0 ;
	else 
		reg_io_reuse_pad17	<=	nxt_io_reuse_pad17 ;
end

reg       [2:0]               reg_io_reuse_pad20            ;                   
wire      [2:0]               nxt_io_reuse_pad20            ;                   
assign                        r_io_reuse_pad20              =	reg_io_reuse_pad20                    ;                   
assign                        nxt_io_reuse_pad20            =	sel_sft_io_reuse_0x09_wen             ?	sft_dat_i[6:4]    :                   
                                                                                                    	reg_io_reuse_pad20 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad20	<=	3'h0 ;
	else 
		reg_io_reuse_pad20	<=	nxt_io_reuse_pad20 ;
end

reg       [2:0]               reg_io_reuse_pad19            ;                   
wire      [2:0]               nxt_io_reuse_pad19            ;                   
assign                        r_io_reuse_pad19              =	reg_io_reuse_pad19                    ;                   
assign                        nxt_io_reuse_pad19            =	sel_sft_io_reuse_0x09_wen             ?	sft_dat_i[2:0]    :                   
                                                                                                    	reg_io_reuse_pad19 ;                   
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_io_reuse_pad19	<=	3'h0 ;
	else 
		reg_io_reuse_pad19	<=	nxt_io_reuse_pad19 ;
end

assign	sft_dat_o = 
                              sel_sft_io_reuse_0x00                   ?	{1'h0,r_io_reuse_pad2,1'h0,r_io_reuse_pad1}:                   
                              sel_sft_io_reuse_0x01                   ?	{1'h0,r_io_reuse_pad4,1'h0,r_io_reuse_pad3}:                   
                              sel_sft_io_reuse_0x02                   ?	{1'h0,r_io_reuse_pad6,1'h0,r_io_reuse_pad5}:                   
                              sel_sft_io_reuse_0x03                   ?	{1'h0,r_io_reuse_pad8,1'h0,r_io_reuse_pad7}:                   
                              sel_sft_io_reuse_0x04                   ?	{1'h0,r_io_reuse_pad10,1'h0,r_io_reuse_pad9}:                   
                              sel_sft_io_reuse_0x05                   ?	{1'h0,r_io_reuse_pad12,1'h0,r_io_reuse_pad11}:                   
                              sel_sft_io_reuse_0x06                   ?	{1'h0,r_io_reuse_pad14,1'h0,r_io_reuse_pad13}:                   
                              sel_sft_io_reuse_0x07                   ?	{1'h0,r_io_reuse_pad16,1'h0,r_io_reuse_pad15}:                   
                              sel_sft_io_reuse_0x08                   ?	{1'h0,r_io_reuse_pad18,1'h0,r_io_reuse_pad17}:                   
                              sel_sft_io_reuse_0x09                   ?	{1'h0,r_io_reuse_pad20,1'h0,r_io_reuse_pad19}:                   
                                                                      	8'h0               ;                   
assign	sft_rd_cs =  		
                              sel_sft_io_reuse_0x00                   |                                       
                              sel_sft_io_reuse_0x01                   |                                       
                              sel_sft_io_reuse_0x02                   |                                       
                              sel_sft_io_reuse_0x03                   |                                       
                              sel_sft_io_reuse_0x04                   |                                       
                              sel_sft_io_reuse_0x05                   |                                       
                              sel_sft_io_reuse_0x06                   |                                       
                              sel_sft_io_reuse_0x07                   |                                       
                              sel_sft_io_reuse_0x08                   |                                       
                              sel_sft_io_reuse_0x09                   |                                       
                              1'b0                                    ;                                       
endmodule
