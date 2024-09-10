`include "i2c_master_defines.v"

//hubing 
module i2c_master_top(
	pclk, prst, 
  psel, penable, paddr, pwrite,
	pwdata, prdata, 
  i2c_int,
	scl_pad_i, scl_pad_o, scl_padoen_o, 
  sda_pad_i, sda_pad_o, sda_padoen_o);
	
	input        pclk;    
	input        prst;  
  input        penable;
  input        psel;    
	input  [2:0] paddr;    
	input  [7:0] pwdata;     
	output [7:0] prdata;   
	input        pwrite;             
	output       i2c_int;  
	
 	input  scl_pad_i;       // SCL-line input
	output scl_pad_o;       // SCL-line output (always 1'b0)
	output scl_padoen_o;    // SCL-line output enable (active low)

	// i2c data line
	input  sda_pad_i;       // SDA-line input
	output sda_pad_o;       // SDA-line output (always 1'b0)
	output sda_padoen_o;    // SDA-line output enable (active low)

reg [7:0]           prdata;
reg [15:0]          prer;
reg [7:0]           ctr;  //control registers
reg [7:0]           txr;
wire [7:0]          rxr;
reg [7:0]           cr; // command registers
wire [7:0]          sr;
reg                 i2c_int;

reg                 al; //arbitration lost
wire                irxack;
reg                 rxack;

reg                 tip;
reg                 irq_flag;

wire                i2c_al;
wire                done;
wire                we;
assign we = psel & penable & pwrite;

// assign prdata
always @(paddr or prer or ctr or rxr or sr or txr or cr)
  
begin
	  case (paddr) 
	    3'b000: prdata <= prer[ 7:0];
	    3'b001: prdata <= prer[15:8];
	    3'b010: prdata <= ctr;
	    3'b011: prdata <= rxr; // write is transmit register (txr)
	    3'b100: prdata <= sr;  // write is command register (cr)
	    3'b101: prdata <= txr;
	    3'b110: prdata <= cr;
	    3'b111: prdata <= 0;   // reserved
	  endcase
end
	
//configure registers
always @(posedge pclk or negedge prst)begin
   if(~prst)begin
	  prer <= 16'hffff;
    ctr <= 8'b0;
	  txr <= 8'b0;
	 end
   else if(we)
        case(paddr)
		  4'b0000: prer[7:0] <= pwdata;
		  4'b0001: prer[15:8] <= pwdata; 
		  4'b0010: ctr <= pwdata; 
		  4'b0011: txr <= pwdata;
		  default: ;
	endcase
end

//decode control registers
wire core_en, ien;
assign core_en  =   ctr[7]; 
assign ien      =   ctr[6];

always @(posedge pclk or negedge prst)
begin 
  if(~prst)
     cr <= 0;
  else if(we)
      begin
        if(core_en & (paddr== 4'b0100))
         cr <= pwdata;	
      end 
  else 
     begin
       if(done | i2c_al)
	 cr[7:4] <= 4'b0;
	 cr[2:1] <= 2'b0;
	 cr[0]   <= 1'b0;
     end
end

//decode command registers
wire start, stop, read, write, ack, iack;
assign start = cr[7];
assign stop  = cr[6];
assign read  = cr[5];
assign write = cr[4];
assign ack   = cr[3];
assign iack  = cr[0];

i2c_master_byte_ctrl byte_controller(
         .clk    ( pclk     ), 
				 .rst    ( prst     ), 
				 .din    ( txr          ), 
				 .dout   ( rxr          ), 
				 .start  ( start        ), 
				 .stop   ( stop         ), 
				 .read   ( read         ), 
				 .write  ( write        ), 
				 .ack_in ( ack          ),
         .scl_i  ( scl_pad_i    ), 
				 .scl_o  ( scl_pad_o    ), 
				 .scl_padoen_o ( scl_padoen_o ), 
				 .sda_i  ( sda_pad_i    ), 
				 .sda_o   ( sda_pad_o   ), 
				 .sda_padoen_o (sda_padoen_o  ),
			   .i2c_busy ( i2c_busy   ), 
				 .i2c_al ( i2c_al       ), 
				 .ena    ( core_en      ), 
				 .clk_cnt( prer         ), 
				 .ack_out( irxack       ),  
				 .byte_cmd_ack( done    )
			  );
			  


//sr : status registers
always @(posedge pclk or negedge prst)
begin
   if(~prst)
     begin
      rxack <= 1'b0;
      al <= 1'b0;
      tip <= 1'b0;
      irq_flag <= 1'b0;
     end
   else
      begin
	rxack <= irxack;
	al <= (i2c_al | al) & (~start);
	tip <= (read | write);          // data transfer is happening
	irq_flag <= (done | i2c_al) & ~iack;
      end	
end

//interrupt
always @(posedge pclk or negedge prst)
begin
   if(~prst)
	        i2c_int <= 1'b0;
   else if(irq_flag & ien)
	        i2c_int <= 1'b1;
end


			  
assign sr[7] = rxack;	
assign sr[6] = i2c_busy;
assign sr[5] = al;
assign sr[4:2] = 3'b000;
assign sr[1] = tip;  // data transfer is happening
assign sr[0] = irq_flag;

endmodule
			 
