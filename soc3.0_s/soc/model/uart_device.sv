module uart_slave (
  input clk,
  input reset_n,
  input rx,
  output reg tx
);

  parameter integer BAUD_RATE = 9600;
  parameter integer CLOCK_FREQ = 100000000;
  parameter integer BIT_COUNT = 9;
  parameter integer PULSE_WIDTH = 64;
  parameter integer TOTAL_BIT = 8;

  parameter [1:0] STATE_IDLE = 2'b00;
  parameter [1:0] STATE_START = 2'b01;
  parameter [1:0] STATE_DATA = 2'b10;
  parameter [1:0] STATE_STOP = 2'b11;

  reg [1:0] state_reg, state_next;
  reg [7:0] data_reg;
  int       rcv_data;
  reg [BIT_COUNT:0] bit_count_reg;
  reg               bit_enable;
  reg               rx_bit_enable;
  reg [3:0]         bit_num;
  reg rx_reg, rx_next;
  reg tx_reg, tx_next;
  bit               already_print=0;

  string             to_display;
  string             get_char;

  localparam integer BIT_PERIOD = (CLOCK_FREQ / BAUD_RATE);
  localparam integer HALF_BIT_PERIOD = (BIT_PERIOD / 2);

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state_reg <= STATE_IDLE;
      rx_reg <= 1'b1;
      tx_reg <= 1'b1;
      data_reg <= '0;
      bit_count_reg <= 5;
      bit_enable <=0;
      rx_bit_enable <= 0;
      bit_num <= 0;
    end else begin
      state_reg <= state_next;
      rx_reg <= rx_next;
      tx_reg <= tx_next;
      if(rx_bit_enable==1)
          data_reg <= {rx, data_reg[7:1]};
      if(bit_enable==1) begin
          if(bit_count_reg < PULSE_WIDTH-1)
              bit_count_reg <= bit_count_reg + 1;
          else
              bit_count_reg <= 0;
      end else begin
              bit_count_reg <= 0;
      end
    
      if(state_reg == STATE_DATA) begin
           if (bit_count_reg == (PULSE_WIDTH-1)/2) begin
               rx_bit_enable <= 1;
               bit_num <= bit_num +1;
           end else begin
               rx_bit_enable <= 0;
           end
       end else begin
             bit_num <= 0;
             rx_bit_enable <= 0;
       end
       if(state_reg == STATE_STOP) begin
          if(already_print==0) begin
               get_char= $sformatf("%c",data_reg);
               to_display = {to_display,get_char};
               if(data_reg=='ha) begin
                   $display("%s",to_display);
                   to_display = "";
               end
               data_reg <= 0;
               already_print = 1;
          end
      end else begin
          already_print = 0;
      end

    end
  end

  always @* begin
    state_next = state_reg;
    rx_next = rx_reg;
    tx_next = tx_reg;

    case (state_reg)
      STATE_IDLE: begin
        if (!rx) begin
          state_next = STATE_START;
          bit_enable = 1;
        end else begin
          tx_next = 1'b1;
          bit_enable = 0;
        end
      end
      STATE_START: begin
        if (bit_count_reg == PULSE_WIDTH-1) begin
          state_next = STATE_DATA;
        end else begin
          tx_next = 1'b0;
        end
      end
      STATE_DATA: begin
        if (bit_num == TOTAL_BIT) begin
          state_next = STATE_STOP;
        end else begin
          tx_next = data_reg[0];
        end
      end
      STATE_STOP: begin
        if (bit_count_reg == PULSE_WIDTH-1) begin
          state_next = STATE_IDLE;
          bit_enable = 0;
        end else begin
          tx_next = 1'b1;
        end
      end
      default: begin
        state_next = STATE_IDLE;
        tx_next = 1'b1;
        bit_count_reg = 0;
        bit_enable = 0;
      end
    endcase
  end

  assign tx = tx_reg;

endmodule

