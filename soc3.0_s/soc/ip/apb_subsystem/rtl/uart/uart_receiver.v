//hubing
`include "timescale.v"
`include "uart_defines.v"

module uart_receiver(
       clk, rst_n, lcr, rf_pop, srx_pad_i, enable, 
      counter_t, rf_count, rf_data_out, rf_error_bit, rf_overrun, rx_reset, 
      lsr_mask, rstate, rf_push_pulse);
  
input                clk; 
input                rst_n;
input [7:0]          lcr;
input                rf_pop;
input                srx_pad_i;
input                enable;
input                rx_reset;
input                lsr_mask;

output                rf_push_pulse;
output [`UART_FIFO_COUNTER_W - 1 : 0]          rf_count;     //`define UART_FIFO_COUNTER_W  5
output [`UART_FIFO_REC_WIDTH - 1 : 0]          rf_data_out;  //`define UART_FIFO_REC_WIDTH  11
output                rf_error_bit;   
output                rf_overrun;  
output  [3:0]         rstate;  
output  [9:0]         counter_t;

reg                   rf_push_q;
reg [3:0]             rstate;
reg [3:0]             next_state;
//reg                 rbit; // i think it's of no use ,hubing 2014/8/30; ya_debug_0901_329505
reg [3:0]             rcounter16;
reg [2:0]             rbit_counter;
reg [10:0]            rf_data_in;

reg                   rf_push;
wire                  rf_push_pulse;

reg [7:0]             rshift;
reg                   rparity_error;
reg                   rframing_error;

//instance of rf_fifo 2014/9/18
uart_rfifo_hubing i_uart_rfifo_hubing(
    .clk(clk), 
    .rst_n(rst_n), 
    .data_in(rf_data_in), 
    .data_out(rf_data_out), 
    .push(rf_push_pulse), 
    .pop(rf_pop), 
    .overrun(rf_overrun), 
    .count(rf_count), 
    .error_bit(rf_error_bit),
    .fifo_reset(rx_reset), 
    .reset_status(lsr_mask)
    );
                      
parameter  r_idle         = 4'd0;
parameter  r_rec_start      = 4'd1;
parameter  r_rec_bit      = 4'd2;
parameter  r_rec_parity     = 4'd3;
parameter  r_rec_stop       = 4'd4;

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)
    rcounter16 <= 4'hf;
  else if(rstate == r_idle)
    rcounter16 <= 4'hf;
  else if(enable == 1'b1)
    rcounter16 <= rcounter16 - 1'b1;
  else;
end

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)
    rbit_counter <= 3'h0;
  else if(enable == 1'b1) begin 
    if(rstate == r_rec_start && next_state == r_rec_bit)
      case(lcr[1:0])
        2'b00 : rbit_counter <= 3'b100; //5;
        2'b01 : rbit_counter <= 3'b101; //6;
        2'b10 : rbit_counter <= 3'b110; //7;
        2'b11 : rbit_counter <= 3'b111; //8;
      endcase
    else if(rstate == r_rec_bit && rcounter16 == 4'b0)
      if(rbit_counter != 3'b0)
        rbit_counter <= rbit_counter - 1'b1;
      else;
    else;
  end
  else;
end

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)
    rstate <= r_idle;
  else 
    rstate <= next_state;
end

always @(*) begin
  if(enable == 1'b1) begin
    case(rstate)
      r_idle:
          if(srx_pad_i == 1'b0) 
            next_state = r_rec_start;
          else
            next_state = rstate;
      r_rec_start:
            if(rcounter16 == 4'h8 && srx_pad_i == 1'b1)
              next_state = r_idle;
            else if(rcounter16 == 4'h3 && srx_pad_i == 1'b0)
              next_state = r_rec_bit;
            else
              next_state = rstate;
      r_rec_bit:
            if(rcounter16 == 4'h0 && rbit_counter == 3'b0)
              if(lcr[`UART_LC_PE])
                next_state = r_rec_parity;
                else
                next_state = r_rec_stop;
            else
              next_state = rstate;
      r_rec_parity:
             if(rcounter16 == 4'h0)
               next_state = r_rec_stop;
             else
               next_state = rstate;
      r_rec_stop:
               if(rcounter16 == 4'h0)
               next_state = r_idle;
             else
               next_state = rstate;
      default:
            next_state = r_idle;
     endcase
  end
  else 
    next_state = rstate;
end

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)
    rshift <= 8'b0;
  else if(enable == 1'b1 && rcounter16 == 4'h8)
    if(rstate == r_rec_bit)
      case(lcr[1:0])
        2'b00 : rshift[4:0] <= {srx_pad_i,rshift[4:1]};
        2'b01 : rshift[5:0] <= {srx_pad_i,rshift[5:1]};
        2'b10 : rshift[6:0] <= {srx_pad_i,rshift[6:1]};
        2'b11 : rshift[7:0] <= {srx_pad_i,rshift[7:1]};
        default : ;
      endcase
  else;
end

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)
    rparity_error <= 1'b0;
  else if(enable == 1'b1 && rcounter16 == 4'h8 && (rstate == r_rec_parity))
    rparity_error <= srx_pad_i;
  else;
end

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)
    rframing_error <= 1'b0;
  else if(enable == 1'b1 && rcounter16 == 4'h8 && (rstate == r_rec_stop))
    rframing_error <= ~srx_pad_i;
  else;
end

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0) begin
    rf_data_in <= 11'b0;
    rf_push <= 1'b1;
  end
  else if(enable == 1'b1 && rstate == r_rec_stop && rcounter16 == 4'b0) begin
    rf_data_in <= {rshift, 1'b0, rparity_error, rframing_error};
    rf_push <= 1'b1;
  end
  else begin
    rf_data_in <= 11'b0;
    rf_push <= 1'b0;
  end
end

always @(posedge clk or negedge rst_n)
begin
      if(!rst_n)
       rf_push_q <= 0;
    else 
       rf_push_q <= rf_push;
end

assign rf_push_pulse = (~rf_push_q) & rf_push; 

endmodule

