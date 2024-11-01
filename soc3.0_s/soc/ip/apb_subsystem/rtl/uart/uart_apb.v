//hubing
`include "timescale.v"
`include "uart_defines.v"

`define UART_DL1 7:0
`define UART_DL2 15:8


module uart_apb(
          pclk, preset_n,
          pwdata, prdata, paddr, psel, pwrite, penable, inta_o,
        stx_pad_o, srx_pad_i, pready
  
`ifdef UART_HAS_BAUDRATE_OUTPUT
  , baud_o
`endif

  );
  
  input pclk;
  input preset_n;
  input [4:0] paddr;
  input [7:0]  pwdata;
  output [7:0] prdata;
  input pwrite;

    input penable;
    input psel;
  
  output stx_pad_o;
  input srx_pad_i;
        output inta_o;
        output pready;

assign inta_o = 1'b0;
  
reg    [1:0]                     fcr;
reg    [7:0]                     lcr;
reg    [3:0]                     ier;
reg    [7:0]                     prdata;
reg                rx_reset;
reg                tx_reset;

wire   enable;

`ifdef UART_HAS_BAUDRATE_OUTPUT
assign baud_o = enable; // baud_o is actually the enable signal
`endif
  
wire                       srx_pad_i;
wire                       srx_pad;
wire                       stx_pad_o;
wire  [10:0]               rf_data_out;

reg lsr_mask_d;
/////////////////// LSR bits wire and regs 2014/8/29  //////////////////////////////
wire [7:0]           lsr;
wire                 lsr0,lsr1,lsr2,lsr3,lsr4,lsr5,lsr6,lsr7;

reg                  lsr0r,lsr1r,lsr2r,lsr3r,lsr4r,lsr5r,lsr6r,lsr7r;
wire                 lsr_mask;

assign               lsr[7:0] = {lsr7r,lsr6r,lsr5r,lsr4r,lsr3r,lsr2r,lsr1r,lsr0r}; 

//transmitter fifo contral s0ignal ;2014/8/8 modified by hubing
reg  tf_push;
reg  rf_pop;

wire dlab; //divisor latch access bit;
assign dlab = lcr[7];

reg [15:0]  dl;    //divisor latch
reg [15:0]  dlc;   //divisor latch counter
reg         start_dlc;

//read out logic
always @( paddr or dl or dlab or ier or lcr or lsr or rf_data_out )
begin
      case(paddr)
        4'b0000 : prdata = dlab ? dl[7:0]  : rf_data_out[10:7];
        4'b0001 : prdata = dlab ? dl[15:8] : ier;
        4'b0010 : prdata = 0;
        4'b0011 : prdata = lcr;
        4'b0100 : prdata = 0;
        4'b0101 : prdata = lsr;     
        default : prdata = 0;        
      endcase        
end

wire fifo_write;
assign fifo_write = pwrite & penable & psel & (paddr == 0) & ~dlab;
assign pready = penable & psel;

// cfg adr = 0 ; configure dl or write data
always @(posedge pclk or negedge preset_n) begin
  if (preset_n == 1'b0)
      dl[7:0] <= 8'd0;
  else if (pwrite & penable & psel & paddr == 5'b0 & dlab)
    dl[7:0] <= pwdata;
  else; 
end

always @(posedge pclk or negedge preset_n) begin
  if (preset_n == 1'b0)
    tf_push <= 1'b0;
  else if (pwrite & penable & psel & paddr == 5'b0 & ~dlab)
    tf_push <= 1'b1;
  else
    tf_push <= 1'b0;
end

// cfg adr = 1 ; ier and reset ,added by hubing 2014/9/20 
// Interrupt Enable Register or UART_DL2
always @(posedge pclk or negedge preset_n) begin
  if (preset_n == 1'b0)
    ier <= 8'b0;                      // ier uses only 4 lsb
  else if (pwrite & penable & psel & paddr == 5'b1 & ~dlab)
    ier <= pwdata;
  else;
end

always @(posedge pclk or negedge preset_n) begin
  if (preset_n == 1'b0) begin
    dl[15:8] <= 8'b0;
    start_dlc <= 1'b0;
  end
  else if (pwrite & penable & psel & paddr == 5'd1 & dlab) begin
    dl[15:8] <= pwdata; 
    start_dlc <= 1'b1;
  end
  else begin
    dl[15:8] <= dl[15:8];
    start_dlc <= 1'b0;
  end
end     

// generate enable;
always @(posedge pclk or negedge preset_n) begin
    if(!preset_n)
    dlc <= 0;
  else if(start_dlc | ~(|dlc))
    dlc <= dl - 1; 
    else
    dlc <= dlc - 1'b1;  
end

assign enable = (dlc == 0) ? 1'b1 : 1'b0;

// cfg adr = 2;  finished by hubing 204/8/27
// fcr is used to choose FIFO depth. currently unused. 
always @(posedge pclk or negedge preset_n) begin
  if(preset_n == 1'b0) begin
    fcr <= 2'b11;
    rx_reset <= 0;
    tx_reset <= 0;
  end
    else if(pwrite & penable & psel & paddr == 5'd2) begin
    fcr <= pwdata[7:6];
    rx_reset <= pwdata[1];
    tx_reset <= pwdata[0];
  end
    else begin
    fcr <= fcr;
    rx_reset <= 0;
    tx_reset <= 0;
  end
end

// cfg adr = 3;  Line Control Register
always @(posedge pclk or negedge preset_n) begin
  if (!preset_n)
    lcr <= 8'b00000011; // 8 bits every transfer;
    else if (pwrite & penable & psel & paddr== 5'd3) 
    lcr <= pwdata;
    
end   

wire [2:0] tstate;
wire [4:0] tf_count;
wire [9:0] counter_t;
wire [4:0] rf_count;
wire [3:0] rstate;
uart_transmitter transmitter(
      .clk    (pclk), 
    .rst_n  (preset_n), 
    .lcr    (lcr),
    .tf_push  (tf_push),
    .dat_i  (pwdata), 
    .enable (enable),
    .stx_pad_o(stx_pad_o), 
    .tstate (tstate), 
    .tf_count (tf_count), 
    .tx_reset (tx_reset), 
    .lsr_mask (lsr_mask)
   );

 // Synchronizing and sampling serial RX input
  uart_sync_flops    i_uart_sync_flops
  (
    .rst_i           (~preset_n),
    .clk_i           (pclk),
    .stage1_rst_i    (1'b0),
    .stage1_clk_en_i (1'b1),
    .async_dat_i     (srx_pad_i),
    .sync_dat_o      (srx_pad)
  );
  defparam i_uart_sync_flops.width      = 1;
  defparam i_uart_sync_flops.init_value = 1'b1;
  
  
//loopback
//wire serial_in = loopback ? serial_out : srx_pad;
//assign stx_pad_o = loopback ? 1'b1 : serial_out;

// receiver instance
uart_receiver receiver(
     .clk(pclk), 
     .rst_n(preset_n), 
     .lcr(lcr), 
     .rf_pop(rf_pop), 
     .srx_pad_i(srx_pad), 
     .enable(enable), 
     .counter_t(counter_t), 
     .rf_count(rf_count), 
     .rf_data_out(rf_data_out), 
     .rf_error_bit(rf_error_bit), 
     .rf_overrun(rf_overrun), 
     .rx_reset(rx_reset), 
     .lsr_mask(lsr_mask), 
     .rstate(rstate), 
     .rf_push_pulse(rf_push_pulse)
);

/////////////////frequency divisor finished by hubing ///////////////////////////          

always @(posedge pclk or negedge preset_n)
begin
      if(!preset_n)
       rf_pop <= 1'b0;
  else if(~pwrite & penable & psel & paddr == 5'd0 & !dlab)
         rf_pop <= 1'b1;
        else
             rf_pop <= 1'b0;      
end
/////////////////rf_pop finished by hubing ///////////////////////////  

wire  lsr_mask_condition;
wire  fifo_read;
//wire  fifo_write; //update

assign lsr_mask_condition = (!pwrite & penable & psel & paddr == 5'd5 & !dlab);


always @(posedge pclk or negedge preset_n)
begin
      if(!preset_n)
        lsr_mask_d <= 0;
     else lsr_mask_d <= lsr_mask_condition;
end

assign lsr_mask = (~lsr_mask_d && lsr_mask_condition )? 1 : 0;


///////////////////////////////msr finished by hubing 2014/8/8 //////////////////////////////////////////
//line status register
assign lsr0 = (rf_count==0 && rf_push_pulse);  // data in receiver fifo available set condition
assign lsr1 = rf_overrun;     // Receiver overrun error
assign lsr2 = rf_data_out[1]; // parity error bit
assign lsr3 = rf_data_out[0]; // framing error bit
assign lsr4 = rf_data_out[2]; // break error in the character
//assign lsr5 = (tf_count==5'b0 && thre_set_en);  // transmitter fifo is empty
//assign lsr6 = (tf_count==5'b0 && thre_set_en && (tstate == /*`S_IDLE */ 0)); // transmitter empty
assign lsr5 = (tf_count==5'b0);                    // transmitter fifo is empty
assign lsr6 = (tf_count==5'b0 && (tstate == 0));  // transmitter empty
assign lsr7 = rf_error_bit | rf_overrun;


//lsr bit 0
reg lsr0_d;
always @(posedge pclk or negedge preset_n) 
    if(!preset_n)  lsr0_d <= 1'b0;
   else     lsr0_d <= lsr0; 

always @(posedge pclk or negedge preset_n)
     if(!preset_n) lsr0r <= 1'b0;
    else     lsr0r <= (rf_count == 1 && rf_pop && !rf_push_pulse || rx_reset) ? 0:
                           lsr0r || (lsr0 & ~lsr0_d);
//lsr bit 1                  
reg lsr1_d;
always @(posedge pclk or negedge preset_n)
        if(!preset_n)  lsr1_d <= 1'b0;
       else     lsr1_d <= lsr1;   
      
always @(posedge pclk or negedge preset_n)
          if (!preset_n) lsr1r <= 1'b0;
       else lsr1r <= lsr_mask ? 0 : lsr1r || (lsr1 && ~lsr1_d) ;
//lsr bit 2
reg lsr2_d;
always @(posedge pclk or negedge preset_n)
    if(!preset_n) lsr2_d <= 1'b0;
   else lsr2_d <= lsr2;
always @(posedge pclk or negedge preset_n)
     if(!preset_n) lsr2r <= 1'b0;
    else   lsr2r <= lsr_mask ? 0 : lsr2r || (lsr2 && ~lsr2_d);
    
// lsr bit 3 (framing error)
reg lsr3_d; 
always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr3_d <= 0;
  else lsr3_d <= lsr3;

always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr3r <= 0;
  else lsr3r <= lsr_mask ? 0 : lsr3r || (lsr3 && ~lsr3_d);

// lsr bit 4 (break indicator)
reg lsr4_d;
always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr4_d <= 0;
  else lsr4_d <= lsr4;

always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr4r <= 0;
  else lsr4r <= lsr_mask ? 0 : lsr4r || (lsr4 && ~lsr4_d);

// lsr bit 5 (transmitter fifo is empty)
reg lsr5_d;
always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr5_d <= 1;
  else lsr5_d <= lsr5;

always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr5r <=  1;
  else lsr5r <= (fifo_write) ? 0 :  lsr5r || (lsr5 && ~lsr5_d);// a serious consideration here; hubing 2014/8/27

// lsr bit 6 (transmitter empty indicator)
reg lsr6_d;
always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr6_d <= 1;
  else lsr6_d <= lsr6;

always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr6r <= 1;
  else lsr6r <= (fifo_write) ? 0 : lsr6r || (lsr6 && ~lsr6_d);// a serious consideration here; hubing 2014/8/27

// lsr bit 7 (error in fifo)
reg lsr7_d;
always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr7_d <= 0;
  else lsr7_d <= lsr7;

always @(posedge pclk or negedge preset_n)
  if (!preset_n) lsr7r <= 0;
  else lsr7r <= lsr_mask ? 0 : lsr7r || (lsr7 && ~lsr7_d);
  
endmodule
                
