`include "timescale.v"
`include "uart_defines.v"

module uart_transmitter(		  
input               clk		,
input               rst_n	,
input [7:0]         lcr		,
input               tf_push	,
input [7:0]         dat_i	,
input               enable	,
input               tx_reset	,
input               lsr_mask	,

output [2:0]        tstate	,
//output [3:0]        tstate	, //update
output [4:0]        tf_count	,
output              stx_pad_o	
);
reg             stx_pad_o	;
reg [2:0]       tstate		;
reg [7:0]       shift_out	;
reg [3:0]       counter		;
reg [2:0]       bit_counter	;
reg             tf_pop		;
reg             parity_xor	;
reg             bit_out		;
reg         	tf_pop_d	;
reg [3:0]	next_tstate	;
 
wire [7:0]      tf_data_out	;
wire [4:0]      tf_count	;
wire        	tf_pop_pulse	; 
wire [7:0] 	tf_data_in	;

localparam s_idle        = 3'b000;
localparam s_send_start  = 3'b001;
localparam s_send_byte   = 3'b011;
localparam s_send_parity = 3'b010;
localparam s_send_stop   = 3'b110;
localparam s_pop_byte    = 3'b111;

assign tf_data_in = dat_i;    

uart_tfifo_hubing uart_tfifo_hubing(
                         .clk		(clk		), 
			 .rst_n		(rst_n		), 
			 .data_in	(tf_data_in	), 
			 .data_out	(tf_data_out	), 
			 .push		(tf_push	), 
			 .pop		(tf_pop_pulse	), 
			 .overrun	(overrun	), 
			 .count		(tf_count	), 
			 .fifo_reset	(tx_reset	), 
			 .reset_status	(reset_status	)
		      );

// modified and corrected by hubing 2014/9/9
// modified and corrected by hubing 2016/10/4
always @(posedge clk or negedge rst_n) begin 
    if (rst_n == 1'b0)
	tf_pop_d <= 0;
    else 
	tf_pop_d <= tf_pop;
end

assign tf_pop_pulse = (tf_pop & ~tf_pop_d);

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
	counter <= 4'b1111;
    else if ((enable == 1'b1) && (tstate != s_idle) && (tstate != s_pop_byte))
	counter <= counter - 4'b1;
    else;
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
        tf_pop <= 1'b0;
    else if ((tstate == s_pop_byte) && (enable == 1'b1))
	tf_pop <= 1'b1;
    else
	tf_pop <= 1'b0;	 
end

always @(posedge clk) begin
    if (enable == 1'b1)
        if (tstate == s_pop_byte)
            case(lcr[1:0])
				2'b00 : begin
	      		            bit_counter <= 4;
	    		            parity_xor  <= ^tf_data_out[4:0];
	        	        end
	        	2'b01 : begin
	        	            bit_counter <= 5;
	    		            parity_xor  <= ^tf_data_out[5:0];
	    		    	end
	        	2'b10 : begin
	    		            bit_counter <= 6;
	    		            parity_xor  <= ^tf_data_out[6:0];
	    		    	end
	        	2'b11 : begin
	    		            bit_counter <= 7;
	    		            parity_xor  <= ^tf_data_out[7:0];
	    		    	end	
			endcase 
    	else if ((tstate == s_send_byte) && (counter == 4'b0)) begin
		bit_counter <= bit_counter - 4'b1;
		parity_xor  <= parity_xor;
	end
    	else;
    else;
end

// ----------------------------------------------------------
// state machine 
// ----------------------------------------------------------

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
		tstate <= s_idle;
    else 
		tstate <= next_tstate;
end

always @(*) begin
    if (enable == 1'b1)
        case (tstate)
            s_idle :	if (tf_count != 4'b0)
							next_tstate = s_pop_byte;
						else
							next_tstate = s_idle;
            s_pop_byte: 
							next_tstate = s_send_start;
            s_send_start : if (counter == 4'b0)
            	               next_tstate = s_send_byte ;
            	           else
							   next_tstate = s_send_start;
            s_send_byte  : if ((bit_counter == 4'b0) && (counter == 4'b0))
								if (~lcr[`UART_LC_PE])
									next_tstate = s_send_stop;
								else 
									next_tstate = s_send_parity;
						   else
							   next_tstate = s_send_byte;
			s_send_parity: if (counter == 4'b0)
								next_tstate = s_send_stop;
							else
								next_tstate = s_send_parity;
			s_send_stop  : if (counter == 4'b0)
								next_tstate = s_idle;
							else 
								next_tstate = s_send_stop;
            default: next_tstate = s_idle;
		 endcase
    else
		next_tstate = tstate;
end
 
always @(*) begin
    case (tstate)
	s_send_start : 
			stx_pad_o = 1'b0;
	s_send_byte  : 
			stx_pad_o = shift_out[0];
	s_send_parity:
	    		case({lcr[`UART_LC_EP],lcr[`UART_LC_SP]})
	    		    //update 2'b00: stx_pad_o <= ~parity_xor;
	    		    //update 2'b01: stx_pad_o <= 1'b1;
	    		    //update 2'b10: stx_pad_o <= parity_xor;
	    		    //update 2'b11: stx_pad_o <= 1'b0;
	    		    2'b00: stx_pad_o = ~parity_xor;
	    		    2'b01: stx_pad_o = 1'b1;
	    		    2'b10: stx_pad_o = parity_xor;
	    		    2'b11: stx_pad_o = 1'b0;
	    		endcase
	s_send_stop  :  
			stx_pad_o = 1'b1;
	default	     : 
			stx_pad_o = 1'b1;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin 
	shift_out <= 8'b1111_1111;
    end
    else if (enable == 1'b1) begin
    	if (tstate == s_pop_byte) begin
	    shift_out <= tf_data_out;
	end
        else if ((tstate == s_send_byte) && (counter == 4'b0)) begin
	    shift_out[7:0] <= {1'b0,shift_out[7:1]};
	end
	else;
    end
    else;	    
end

endmodule
//always @(posedge clk or negedge rst_n) begin
//    if (rst_n == 1'b0) begin
//	tstate 	    <= s_idle;    
//	stx_pad_o   <= 1'b1;
//	bit_counter <= 3'b0;
//        tf_pop      <= 1'b0;
//        counter     <= 4'b0;
//    end
//    else if (enable) begin
//        case (tstate)
//	     s_idle : if(~|tf_count) begin
//		          stx_pad_o <= 1;    
//			  tstate <= s_idle;
//		      end 
//		      else begin
//		          tf_pop <= 0;
//		          stx_pad_o <= 1;
//			  tstate <= s_pop_byte; 
//		      end 
//	     s_pop_byte : begin
//			      tf_pop <= 1'b1;
//			      case(lcr[1:0])
//			          2'b00 : begin
//				  	      bit_counter <= 4;
//					      parity_xor  <= ^tf_data_out[4:0];
//				          end
//				  2'b01 : begin
//				              bit_counter <= 5;
//					      parity_xor  <= ^tf_data_out[5:0];
//					  end
//				  2'b10 : begin
//					      bit_counter <= 6;
//					      parity_xor  <= ^tf_data_out[6:0];
//					  end
//				  2'b11 : begin
//					      bit_counter <= 7;
//					      parity_xor  <= ^tf_data_out[7:0];
//					  end	
//			      endcase	
//			      tstate <= s_send_start;	 
//			      {shift_out[6:0],bit_out} <= tf_data_out;
//			  end
//	     s_send_start : begin
//			        tf_pop <= 1'b0;
//				if(~|counter) begin
//				    counter   <= 4'b1111;
//				    tstate    <= tstate ;
//				    stx_pad_o <= 1'b1;
//				end
//				else if (counter == 1) begin
//				    counter   <= 4'b0;
//				    tstate    <= s_send_byte;
//				    stx_pad_o <= 1'b1; 
//				end
//				else begin
//				    counter   <= counter - 4'b1; 
//				    tstate    <= tstate;
//			     	    stx_pad_o <= 1'b0;
//				end
//			    end
//	      s_send_byte : begin
//	                        tf_pop <= 1'b0;
//				if(~|counter)
//				    counter <= 4'b1111;
//				else if (counter == 1) begin
//				    if (bit_counter > 0) begin
//					tstate <= s_send_byte;
//					bit_counter <= bit_counter - 1'b1;
//					{shift_out[5:0],bit_out} <= {shift_out[6:1],shift_out[0]};
//				    end
//				    else if(~lcr[`UART_LC_PE])
//				        tstate <= s_send_stop;
//				    else begin
//					tstate <= s_send_parity;
//					case({lcr[`UART_LC_EP],lcr[`UART_LC_SP]})
//					        2'b00:	bit_out <= ~parity_xor;
//					        2'b01:	bit_out <= 1'b1;
//					        2'b10:	bit_out <= parity_xor;
//					        2'b11:	bit_out <= 1'b0;
//					endcase
//				    end
//				    counter <= 0;
//				end
//				else 
//				    counter <= counter - 1;
//				    stx_pad_o <= bit_out;      	  
//                                end	
//		s_send_parity :	begin
//		                    if(~|counter)
//                                        counter <= 4'b1111;
//		                    else if(counter == 1) begin
//					tstate <= s_send_stop;
//					counter <= 0;	
//				    end
//				    else  
//				        counter <= counter - 1;
//				        stx_pad_o <= bit_out;		 
//				 end
//		s_send_stop :  begin  // should take a serious consideration here hubing 2014/9/18;
//				   if(~|counter)
//				       casex ({lcr[`UART_LC_SB],lcr[`UART_LC_BITS]})
//  				           3'b0xx:	  counter <= 5'b01101;     // 1 stop bit ok igor
//  				           3'b100:	  counter <= 5'b10101;     // 1.5 stop bit
//  				           default:	  counter <= 5'b11101;     // 2 stop bits
//				       endcase
//				   else if(counter == 1)
//				       begin
//				   	    counter <= 0;
//					    tstate <= s_idle;
//				       end
//				   else 
//				       counter <= counter - 1;
//				       stx_pad_o <= 1'b1;  
//				   end
//		default : ;
//		endcase			
//	end					 
//end
