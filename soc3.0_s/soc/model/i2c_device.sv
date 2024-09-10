module i2c_device(
	scl_pad_i, 
    scl_pad_o, 
    sda_pad_i, 
    sda_pad_o
);
  parameter START_BIT = 1'b0;
  parameter STOP_BIT = 1'b1;
  parameter ACK_BIT = 1'b0;
  parameter NACK_BIT = 1'b1;

// Define state machine states
  parameter IDLE = 3'b000;
  parameter RECEIVE_ADDR = 3'b001;
  parameter RECEIVE_DATA = 3'b010;	
  parameter SENT_DATA    = 3'b011;	
  parameter SENT_ADDR_ACK     = 3'b100;	
  parameter SENT_DATA_ACK     = 3'b101;	
  parameter WAIT_ACK     = 3'b110;	

  input  scl_pad_i;       // SCL-line input
  output scl_pad_o;    // SCL-line output enable (active low)
  
  // i2c data line
  input  sda_pad_i;       // SDA-line input
  output sda_pad_o;    // SDA-line output enable (active low)


  // Define internal state variables
  reg [7:0] addr;
  reg [7:0] data;
  reg [7:0] sdata;
  reg [2:0] state;
  reg [3:0] bit_cnt;
  reg [3:0] byte_cnt;
  reg sda_pad_o;
  reg start;
  reg stop;
  reg wr;
 
  assign scl_pad_o = scl_pad_i;

  // Initialize internal state variables
  initial begin
    state = IDLE;
    bit_cnt = 3'b0;
    byte_cnt = 3'b0;
    sda_pad_o = NACK_BIT;
    start = 0;
    stop = 0;
    wr =0;
    data = 8'h73;
    sdata = 0;
    addr = 0;
  end

  // Synchronize incoming clock signal
  always @(negedge sda_pad_i) begin
      if(scl_pad_i==1 && start==0) begin
          start = 1;
          state = RECEIVE_ADDR;
      end
  end

  always @(posedge sda_pad_i) begin
      if(scl_pad_i==1 && start==1) begin
          start = 0;
          state = IDLE;
      end
  end

  always @(posedge scl_pad_i) begin
    case (state)
      IDLE: begin
         sda_pad_o <= NACK_BIT;
         bit_cnt <= 3'b0;
         byte_cnt <= 3'b0;
         start <= 0;
         stop <= 0;
      end
      RECEIVE_ADDR: begin
        addr[bit_cnt] <= sda_pad_i;
        bit_cnt <= bit_cnt + 1;
        if (bit_cnt == 7) begin
          // Address byte received
          byte_cnt <= 4'b0;
          state <= SENT_ADDR_ACK;
          sda_pad_o <= ACK_BIT;
          $display("Get ADDR %h ,WR %d ! \n",addr[7:1],addr[0]);
        end
      end
      SENT_ADDR_ACK: begin
          if(addr[0]==0) begin
             state <= RECEIVE_DATA;
             data  <= 0;
          end else begin
             state <= SENT_DATA;     
             sdata <= data;        
          end
          sda_pad_o <= NACK_BIT;
      end
      RECEIVE_DATA: begin
        if (byte_cnt < 8) begin
          // Read data byte
          data <= (data<<1);
          data[0] <= sda_pad_i;
          byte_cnt <= byte_cnt + 1;
          sda_pad_o <= NACK_BIT;
        end else begin
          // Data byte received
          byte_cnt <= 3'b0;
          sda_pad_o <= ACK_BIT;
          state <= SENT_DATA_ACK;
          $display("Get DATA %h ! \n",data);
        end
      end
      SENT_DATA_ACK: begin
          sda_pad_o <= NACK_BIT;
          state <= RECEIVE_DATA;
      end
      SENT_DATA: begin
        if (byte_cnt < 8) begin
          // Send data byte
          sda_pad_o <= sdata[7];
          sdata <= sdata<<1;
          byte_cnt <= byte_cnt + 1;
        end else begin
          // Data byte received
          byte_cnt <= 3'b0;
          state <= WAIT_ACK;
          sda_pad_o <= NACK_BIT;
          $display("Send DATA %h ! \n",data);
        end
      end
      WAIT_ACK: begin
          if(sda_pad_i==ACK_BIT) begin
             state <= SENT_DATA;
          end
      end
    endcase
  end

  // Output SDA signal
//  assign sda = (sda_out == 1'bZ) ? 1'b1 : sda_out;


endmodule
