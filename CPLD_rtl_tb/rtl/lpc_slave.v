
///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <lpc_slaver.v>
// File history:
//
// Description: 
// receive data from LPC master
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////


module LPC_SLAVE(
    input            i_LPCClk,
    input            i_rst_n,
    input            i_Frame,
    input [3:0]      i_LAD,
    input      [7:0] i_lpc_rdata, 
    output     [7:0] o_lpc_addr,
    output     [7:0] o_lpc_wdata,
    output     [0:0] o_lpc_write,
    output     [0:0] o_lpc_read,//maybe delay one cycle
    output     [0:0] o_lpc_en,
    output[3:0]      o_LAD,
    output           o_LAD_OE
);

    `define CPLD_VERSION 8'h16

    `define IO_WRITE        4'b0010             // LPC Address state (4 cycles)
    `define IO_READ         4'b0000             // LPC Address state (4 cycles)
    `define MEM_WRITE       4'b0110             
    `define MEM_READ        4'b0100             
    `define DMA_WRITE       4'b1010             
    `define DMA_READ        4'b1000             

    parameter IDLE   = 4'b0000;             // LPC IDLE state
    parameter START  = 4'b0001;             // LPC Start state
    parameter CYCTYP = 4'b0010;             // LPC Cycle Type State
    parameter ADDR   = 4'b0011;             // LPC Address state (4 cycles)
    parameter H_DATA = 4'b0100;             // LPC Host Data state (2 cycles)
    parameter P_DATA = 4'b0101;             // LPC Peripheral Data state (2 cycles)
    parameter H_TAR1 = 4'b0110;             // LPC Host Turnaround 1 (Drive LAD 4'hF)
    parameter H_TAR2 = 4'b0111;             // LPC Host Turnaround 2 (Float LAD)
    parameter P_TAR1 = 4'b1000;             // LPC Peripheral Turnaround 1 (Drive LAD = 4'hF)
    parameter P_TAR2 = 4'b1001;             // LPC Peripheral Turnaround 2 (Float LAD)
    parameter SYNC   = 4'b1010;             // LPC Sync State (may be multiple cycles for wait-states)
    parameter ABORT  = 4'b1011;             // LPC transmission ABORT 

    reg [3:0]  r_LAD;
    reg        r_LAD_OE; 
    reg [3:0]  cs_LPCState;
    reg [3:0]  ns_LPCState;
    reg [1:0]  cs_adr_cnt;
    reg [1:0]  cs_dat_p_cnt;
    reg [1:0]  cs_dat_cnt;
    reg [1:0]  cs_abort_cnt;
    reg [1:0]  ns_adr_cnt;
    reg [1:0]  ns_dat_p_cnt;
    reg [1:0]  ns_dat_cnt;
    reg [1:0]  ns_abort_cnt;
    reg        cs_io_write;
    reg        ns_io_write;
    wire       w_io_write;
    reg [15:0] cs_lpc_adr_reg;
    reg [15:0] ns_lpc_adr_reg;
    reg [ 7:0] cs_lpc_dat_reg;
    reg [ 7:0] ns_lpc_dat_reg;
    wire[ 7:0] w_lpc_dat_reg;
    reg [ 7:0] r_lpc_dat_i;
    reg [ 0:0] cs_sync_cnt;
    reg [ 0:0] ns_sync_cnt;
    reg        r_lpc_p_ack;
    wire       w_lpc_write;
    wire       w_lpc_read;
    wire       w_addr_hit;
    reg        cs_lpc_en;
    reg        ns_lpc_en;
    //reg [1:0]  Frame_staging;

    always @(*)
        begin
            ns_LPCState   = cs_LPCState;
    	    ns_io_write   = cs_io_write;
    	    ns_lpc_adr_reg= cs_lpc_adr_reg;
    	    ns_lpc_dat_reg= cs_lpc_dat_reg;
    	    ns_lpc_en     = cs_lpc_en;
            ns_dat_cnt = cs_dat_cnt;
            ns_adr_cnt = cs_adr_cnt;
            ns_abort_cnt = cs_abort_cnt;
            ns_dat_p_cnt = cs_dat_p_cnt;
            ns_sync_cnt  = cs_sync_cnt;
            //Frame_staging = {Frame_staging[0],i_Frame};
            if ((cs_LPCState==H_DATA)&&(!(&cs_dat_cnt))) 
                ns_dat_cnt = cs_dat_cnt + 1;
            else 
                ns_dat_cnt = 2'b00;
            if ((cs_LPCState==ADDR)&&(!(&cs_adr_cnt)))
                ns_adr_cnt = cs_adr_cnt + 1;
            else
                ns_adr_cnt = 2'b00;
            if ((cs_LPCState==START & i_Frame==1'b0)&&(!(&cs_abort_cnt)))
                ns_abort_cnt = cs_abort_cnt + 1;
            else
                ns_abort_cnt = 2'b00;
            if ((cs_LPCState==P_DATA)&&(!(&cs_dat_p_cnt)))
                ns_dat_p_cnt = cs_dat_p_cnt + 1;
            else
                ns_dat_p_cnt = 2'b00;
            if ((cs_LPCState==SYNC)&&(!(&cs_sync_cnt)))
                ns_sync_cnt = cs_sync_cnt + 1;
            else
                ns_sync_cnt = 1'b0;

            /*if(Frame_staging==2'b10) begin
                if(i_rst_n)
                    ns_LPCState = START;
                else
                    ns_LPCState = IDLE;
                end 
            else ns_LPCState = cs_LPCState;*/ 

            case (cs_LPCState)
                IDLE://idle
                    begin
                        r_lpc_p_ack = 1'b0;
                        r_LAD_OE    = 1'b0;
                        if (!i_Frame) 
                        ns_LPCState= START;
                    end
                START://start
                    begin
                        ns_lpc_en   = 1'b0;
                        r_lpc_p_ack = 1'b0;
                        r_LAD_OE    = 1'b0;
                        if(cs_abort_cnt==2'b11 && i_LAD==4'b1111) // LFRAME pull down 4 clock and last LAD==4'b1111, transmition will be abort
                            ns_LPCState= ABORT;
                        else ns_LPCState= START;
                        if (i_Frame) begin 
                            if(i_LAD==4'b0000) 
                            ns_LPCState= CYCTYP;
                            else
                            ns_LPCState= START;
                        end
                    end
                ABORT:// abort
                    begin
                        ns_lpc_en = 1'b0;
                        r_lpc_p_ack = 1'b0;
                        r_LAD_OE    = 1'b0;
                        if(i_Frame)
                        ns_LPCState= IDLE;
                    end
                CYCTYP://cyctype-dir
                    begin
                        ns_lpc_en   = 1'b1;
                        if (!i_Frame) 
                        ns_LPCState= START;
                        else
                        if (i_LAD==`IO_WRITE) //io write
                        begin
                            ns_LPCState = ADDR;
                            ns_io_write= 1'b1;
                        end
                        else if (i_LAD==`IO_READ)//io read
                        begin
                            ns_LPCState = ADDR;
                            ns_io_write= 1'b0;
                        end
                        else ns_LPCState= IDLE;
                    end
                ADDR://addr
                    begin
                        case (cs_adr_cnt)
                        2'b00: ns_lpc_adr_reg[15:12] = i_LAD;
                        2'b01: ns_lpc_adr_reg[11: 8] = i_LAD;
                        2'b10: ns_lpc_adr_reg[ 7: 4] = i_LAD;
                        2'b11: ns_lpc_adr_reg[ 3: 0] = i_LAD;
                        endcase
                        if (!i_Frame) 
                        ns_LPCState= START;
                        else
                        if (cs_adr_cnt == 2'b11)//last addr
                        begin
                            if (!w_addr_hit)    // if(cs_lpc_adr_reg[11]==0)
                                ns_LPCState = IDLE;
                                //ns_LPCState = START;
                            else                   // (cs_lpc_adr_reg[11]==1'b1)
                                if (w_io_write==1) 
                                    ns_LPCState= H_DATA;//wrtie data
                                else            
                                    ns_LPCState= H_TAR1;//tar1
                        end
                        else
                        begin
                            ns_LPCState = ADDR;// continue sampling addr
                        end
                    end
                H_DATA://data  write
                    begin
                        case (cs_dat_cnt)
                        2'b00: ns_lpc_dat_reg[ 3: 0] = i_LAD;
                        2'b01: ns_lpc_dat_reg[ 7: 4] = i_LAD;
                        endcase
                        if (!i_Frame) 
                        ns_LPCState= START;
                        else
                        if (cs_dat_cnt == 2'b01)//last addr
                        begin
                            ns_LPCState= H_TAR1;//tar1
                        end
                        else
                        begin
                            ns_LPCState= H_DATA;//continue sampling data write
                        end
                    end
                H_TAR1://tar1 host
                    begin
                        r_LAD= 4'b1111;
                        if (!i_Frame) 
                        ns_LPCState= START;
                        else
                        if (w_io_write==0)
                            r_lpc_p_ack = 1'b1;
                        else
                            r_lpc_p_ack = 1'b0;
                        ns_LPCState= H_TAR2;//tar2 host
                    end
                H_TAR2://tar2 host
                    begin
                        if (!i_Frame) 
                        ns_LPCState= START;
                        else begin
                        ns_LPCState = SYNC;//sync
                        r_LAD_OE    = 1'b1;
                        r_LAD       = H_TAR2;//short wait,2 clocks
                        end
                    end
                SYNC://sync
                    begin
                        r_LAD_OE= 1'b1;
                        if (!i_Frame) 
                        begin
                        ns_LPCState= START;
                        r_LAD_OE= 1'b0;
                        end
                        else
                        if (cs_sync_cnt == 1'b0)
                        begin
                            r_LAD= 4'b0101;//short wait,2 clocks
                            ns_LPCState= SYNC;//sync
                        end
                        else
                        begin
                            if (w_io_write)
                            begin
                                ns_LPCState= P_TAR1;//tar1 perph
                                r_LAD= 4'b0000;//short wait,2 clocks
                            end
                            else
                            begin
                                ns_LPCState= P_DATA;//data,read
                                r_LAD= 4'b0000;//short wait,2 clocks
                            end
                        end
                        // peripheral get into long SYNC   
                    end
                P_TAR1://tar1 perph
                    begin
                        ns_LPCState= P_TAR2;//tar2 perph
                        r_LAD= 4'b1111;
                        if (!i_Frame) 
                        begin
                        ns_LPCState= START;
                        r_LAD_OE= 1'b0;
                        end
                        else
                        if (w_io_write)
                        r_lpc_p_ack = 1'b1;
                        else
                           r_lpc_p_ack = 1'b0;
                    end
                P_TAR2://tar2 perph
                    begin
                        r_LAD_OE= 1'b0;
                        ns_LPCState= IDLE;//idle
                        //ns_LPCState= START;//idle
                    end
                P_DATA://data read
                    begin
                        case(cs_dat_p_cnt[1:0])
                            2'h0: r_LAD= r_lpc_dat_i[3:0];
                            2'h1: r_LAD= r_lpc_dat_i[7:4];
                        endcase
                        if (!i_Frame) 
                        begin
                        ns_LPCState= START;
                        r_LAD_OE= 1'b0;
                        end
                        else
                        if (cs_dat_p_cnt >= 2'b1)//last data
                            begin
                                ns_LPCState= P_TAR1;//tar1 perph
                            end
                        else
                            begin
                                //ns_LPCState= H_TAR2;//data read
                                ns_LPCState= P_DATA;//data read
                            end
                            r_LAD_OE= 1'b1;
                    end
                default:ns_LPCState=IDLE;
            endcase
        end


    always @ (posedge i_LPCClk or negedge i_rst_n)
    begin
        if (~i_rst_n)
            cs_LPCState    <= IDLE;
        else
            cs_LPCState    <= ns_LPCState;
    end

    always @ (posedge i_LPCClk or negedge i_rst_n)
    begin
        if (~i_rst_n)
        begin
            r_lpc_dat_i  <= 8'b0;
 
            cs_io_write    <= 1'b0;
            cs_lpc_dat_reg <= 8'h0;
            cs_lpc_adr_reg <= 16'h0;
            //ns_LPCState    <= 4'b0000; // ERROR !! FSM does not extract
            `ifdef CONFIG_FOR_SIM
            ns_io_write    <= 1'b0;
            ns_lpc_dat_reg <= 8'h0;
            ns_lpc_adr_reg <= 16'h0;
            `endif

            cs_dat_cnt   <= 2'b0;
            cs_adr_cnt   <= 2'b00;
            cs_dat_p_cnt <= 2'b00;
            cs_abort_cnt <= 2'b00;
            cs_sync_cnt  <= 1'b0;
            cs_lpc_en    <= 1'b0;
            `ifdef CONFIG_FOR_SIM
            ns_dat_cnt   <= 2'b0;
            ns_adr_cnt   <= 2'b00;
            ns_dat_p_cnt <= 2'b00;
            ns_abort_cnt <= 2'b00;
            ns_sync_cnt  <= 1'b0;
            `endif
            r_lpc_p_ack  <= 1'b0;
    	    r_LAD_OE <= 1'b0;
    	    r_LAD    <= 4'b0000;
            //Frame_staging <= 2'b11;
        end
        else
        begin
            if (w_lpc_read)
            begin
                r_lpc_dat_i <= i_lpc_rdata;
            end

	        cs_io_write    <= ns_io_write;
	        cs_lpc_adr_reg <= ns_lpc_adr_reg;
	        cs_lpc_dat_reg <= ns_lpc_dat_reg;

            cs_dat_cnt   <= ns_dat_cnt;
            cs_adr_cnt   <= ns_adr_cnt;
            cs_abort_cnt <= ns_abort_cnt;
            cs_dat_p_cnt <= ns_dat_p_cnt;
            cs_sync_cnt  <= ns_sync_cnt;
            cs_lpc_en    <= ns_lpc_en;
        end
    end


    assign w_addr_hit   = cs_lpc_adr_reg[11];
    assign w_lpc_write  = r_lpc_p_ack & w_io_write;
    assign w_lpc_read   = r_lpc_p_ack & (!w_io_write);
    assign w_io_write   = cs_io_write;

    assign o_lpc_addr   = cs_lpc_adr_reg[7:0];
    assign o_lpc_wdata  = w_lpc_dat_reg;
    assign o_lpc_write  = w_lpc_write;
    assign o_lpc_read   = w_lpc_read;
    assign o_lpc_en     = cs_lpc_en;

    assign w_lpc_dat_reg= cs_lpc_dat_reg;
    assign o_LAD        = r_LAD;
    assign o_LAD_OE     = r_LAD_OE;

endmodule

