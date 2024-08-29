///////////////////////////////////////////////////////////////////////////////////////////////////
// File: <lpc_slaver.v>
// File history:
//
// Description: 
// receive data from LPC master
// Author: <zwp>
///////////////////////////////////////////////////////////////////////////////////////////////////


module LPC_SLAVER(
    input            i_LPCClk,
    input            i_rst_n,
    input  [ 7:0]    i_lpc_rdata, 
    output     [7:0] o_lpc_addr,
    output     [7:0] o_lpc_wdata,
    output     [0:0] o_lpc_write,
    output     [0:0] o_lpc_read,//maybe delay one cycle
    output     [0:0] o_lpc_en,
    input            i_Frame,
    input [3:0]      i_LAD,
    output[3:0]      o_LAD,
    output           o_LAD_OE
);

    `define CPLD_VERSION 8'h16

    `define IO_WRITE        4'b0010             // LPC Address state (4 cycles)
    `define IO_READ         4'b0000             // LPC Address state (4 cycles)
    `define MEM_WRITE       4'b0110             // LPC Address state (4 cycles)
    `define MEM_READ        4'b0100             // LPC Address state (4 cycles)
    `define DMA_WRITE       4'b1010             // LPC Address state (4 cycles)
    `define DMA_READ        4'b1000             // LPC Address state (4 cycles)

    //`define LPC_ST_IDLE     4'b0000             // LPC Start state
    `define LPC_ST_START    4'b0000             // LPC Start state
    `define LPC_ST_CYCTYP   4'b0001             // LPC Cycle Type State
    `define LPC_ST_ADDR     4'b0010             // LPC Address state (4 cycles)
    `define LPC_ST_H_DATA   4'b0011             // LPC Host Data state (2 cycles)
    `define LPC_ST_P_DATA   4'b0100             // LPC Peripheral Data state (2 cycles)
    `define LPC_ST_H_TAR1   4'b0101             // LPC Host Turnaround 1 (Drive LAD 4'hF)
    `define LPC_ST_H_TAR2   4'b0111             // LPC Host Turnaround 2 (Float LAD)
    `define LPC_ST_P_TAR1   4'b1000             // LPC Peripheral Turnaround 1 (Drive LAD = 4'hF)
    `define LPC_ST_P_TAR2   4'b0110             // LPC Peripheral Turnaround 2 (Float LAD)
    `define LPC_ST_SYNC     4'b1010             // LPC Sync State (may be multiple cycles for wait-states)

    reg [3:0]  r_LAD;
    reg        r_LAD_OE; 
    reg [3:0]  cs_LPCState;
    reg [3:0]  ns_LPCState;
    reg [1:0]  cs_adr_cnt;
    reg [1:0]  cs_dat_p_cnt;
    reg [1:0]  cs_dat_cnt;
    reg [1:0]  ns_adr_cnt;
    reg [1:0]  ns_dat_p_cnt;
    reg [1:0]  ns_dat_cnt;
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

    always @ (posedge i_LPCClk or negedge i_rst_n)
    begin
        if (~i_rst_n)
        begin
            r_lpc_dat_i  <= 8'b0;
 
            cs_LPCState    <= 4'b0000;
            cs_io_write    <= 1'b0;
            cs_lpc_dat_reg <= 8'h0;
            cs_lpc_adr_reg <= 16'h0;
            `ifdef CONFIG_FOR_SIM
            ns_LPCState    <= 4'b0000;
            ns_io_write    <= 1'b0;
            ns_lpc_dat_reg <= 8'h0;
            ns_lpc_adr_reg <= 16'h0;
            `endif

            cs_dat_cnt   <= 2'b0;
            cs_adr_cnt   <= 2'b00;
            cs_dat_p_cnt <= 2'b00;
            cs_sync_cnt  <= 1'b0;
            cs_lpc_en    <= 1'b0;
            `ifdef CONFIG_FOR_SIM
            ns_dat_cnt   <= 2'b0;
            ns_adr_cnt   <= 2'b00;
            ns_dat_p_cnt <= 2'b00;
            ns_sync_cnt  <= 1'b0;
            `endif
        end
        else
        begin
            if (w_lpc_read)
            begin
                r_lpc_dat_i <= i_lpc_rdata;
            end

            cs_LPCState    <= ns_LPCState;
	    cs_io_write    <= ns_io_write;
	    cs_lpc_adr_reg <= ns_lpc_adr_reg;
	    cs_lpc_dat_reg <= ns_lpc_dat_reg;

            cs_dat_cnt   <= ns_dat_cnt;
            cs_adr_cnt   <= ns_adr_cnt;
            cs_dat_p_cnt <= ns_dat_p_cnt;
            cs_sync_cnt  <= ns_sync_cnt;
            cs_lpc_en    <= ns_lpc_en;
        end
    end

    always @ *
        begin
            ns_dat_cnt = cs_dat_cnt;
            ns_adr_cnt = cs_adr_cnt;
            ns_dat_p_cnt = cs_dat_p_cnt;
            ns_sync_cnt  = cs_sync_cnt;
            if ((cs_LPCState==`LPC_ST_H_DATA)&&(!(&cs_dat_cnt))) 
                ns_dat_cnt = cs_dat_cnt + 1;
            else 
                ns_dat_cnt = 2'b00;
            if ((cs_LPCState==`LPC_ST_ADDR)&&(!(&cs_adr_cnt)))
                ns_adr_cnt = cs_adr_cnt + 1;
            else
                ns_adr_cnt = 2'b00;
            if ((cs_LPCState==`LPC_ST_P_DATA)&&(!(&cs_dat_p_cnt)))
                ns_dat_p_cnt = cs_dat_p_cnt + 1;
            else
                ns_dat_p_cnt = 2'b00;
            if ((cs_LPCState==`LPC_ST_SYNC)&&(!(&cs_sync_cnt)))
                ns_sync_cnt = cs_sync_cnt + 1;
            else
                ns_sync_cnt = 1'b0;
        end

    always @ *
        begin
            ns_LPCState   = cs_LPCState;
    	    ns_io_write= cs_io_write;
    	    ns_lpc_adr_reg= cs_lpc_adr_reg;
    	    ns_lpc_dat_reg= cs_lpc_dat_reg;
    	    ns_lpc_en     = cs_lpc_en;
            r_lpc_p_ack   = 1'b0;
    	    r_LAD_OE = 1'b0;
    	    r_LAD    = 4'b0000;

            case (cs_LPCState)
                //`LPC_ST_IDLE:
                //    begin
                //        r_lpc_p_ack = 1'b0;
                //        r_LAD_OE    = 1'b0;
                //        ns_LPCState= `LPC_ST_START;
                //    end
                `LPC_ST_START://start,idle
                    begin
                        ns_lpc_en   = 1'b0;
                        r_lpc_p_ack = 1'b0;
                        r_LAD_OE    = 1'b0;
                        if (!i_Frame) 
                            ns_LPCState= `LPC_ST_CYCTYP;
                        else          
                            ns_LPCState= `LPC_ST_START;
                    end
                `LPC_ST_CYCTYP://cyctype-dir
                    begin
                        ns_lpc_en   = 1'b1;
                        if (i_LAD==`IO_WRITE) //io write
                        begin
                            ns_LPCState = `LPC_ST_ADDR;
                            ns_io_write= 1'b1;
                        end
                        else if (i_LAD==`IO_READ)//io read
                        begin
                            ns_LPCState = `LPC_ST_ADDR;
                            ns_io_write= 1'b0;
                        end
                        else ns_LPCState= `LPC_ST_START;
                    end
                `LPC_ST_ADDR://addr
                    begin
                        case (cs_adr_cnt)
                        2'b00: ns_lpc_adr_reg[15:12] = i_LAD;
                        2'b01: ns_lpc_adr_reg[11: 8] = i_LAD;
                        2'b10: ns_lpc_adr_reg[ 7: 4] = i_LAD;
                        2'b11: ns_lpc_adr_reg[ 3: 0] = i_LAD;
                        endcase
                        if (cs_adr_cnt == 2'b11)//last addr
                        begin
                            if (w_addr_hit==1'b0)
                                //ns_LPCState = `LPC_ST_IDLE;
                                ns_LPCState = `LPC_ST_START;
                            else
                                if (w_io_write) 
                                    ns_LPCState= `LPC_ST_H_DATA;//wrtie data
                                else            
                                    ns_LPCState= `LPC_ST_H_TAR1;//tar1
                        end
                        else
                        begin
                            ns_LPCState = `LPC_ST_ADDR;//addr
                        end
                    end
                `LPC_ST_H_DATA://data  write
                    begin
                        case (cs_dat_cnt)
                        2'b00: ns_lpc_dat_reg[ 3: 0] = i_LAD;
                        2'b01: ns_lpc_dat_reg[ 7: 4] = i_LAD;
                        endcase
                        if (cs_dat_cnt == 2'b01)//last addr
                        begin
                            ns_LPCState= `LPC_ST_H_TAR1;//tar1
                        end
                        else
                        begin
                            ns_LPCState= `LPC_ST_H_DATA;//data write
                        end
                    end
                `LPC_ST_H_TAR1://tar1 host
                    begin
                        r_LAD= 4'b1111;
                        if (!w_io_write)
                            r_lpc_p_ack = 1'b1;
                        else
                            r_lpc_p_ack = 1'b0;
                        ns_LPCState= `LPC_ST_H_TAR2;//tar2 host
                    end
                `LPC_ST_H_TAR2://tar2 host
                    begin
                        ns_LPCState = `LPC_ST_SYNC;//sync
                        r_LAD_OE    = 1'b1;
                        r_LAD       = `LPC_ST_H_TAR2;//short wait,2 clocks
                    end
                `LPC_ST_SYNC://sync
                    begin
                        r_LAD_OE= 1'b1;
                        if (cs_sync_cnt == 1'b0)
                        begin
                            r_LAD= `LPC_ST_H_TAR2;//short wait,2 clocks
                            ns_LPCState= `LPC_ST_SYNC;//sync
                        end
                        else
                        begin
                            if (w_io_write)
                            begin
                                ns_LPCState= `LPC_ST_P_TAR1;//tar1 perph
                                r_LAD= `LPC_ST_START;//short wait,2 clocks
                            end
                            else
                            begin
                                ns_LPCState= `LPC_ST_P_DATA;//data,read
                                r_LAD= `LPC_ST_START;//short wait,2 clocks
                            end
                        end
                          
                    end
                `LPC_ST_P_TAR1://tar1 perph
                    begin
                        ns_LPCState= `LPC_ST_P_TAR2;//tar2 perph
                        r_LAD= 4'b1111;
                        if (w_io_write)
                        r_lpc_p_ack = 1'b1;
                        else
                           r_lpc_p_ack = 1'b0;
                    end
                `LPC_ST_P_TAR2://tar2 perph
                    begin
                        r_LAD_OE= 1'b0;
                        //ns_LPCState= `LPC_ST_IDLE;//idle
                        ns_LPCState= `LPC_ST_START;//idle
                    end
                `LPC_ST_P_DATA://data read
                    begin
                        case(cs_dat_p_cnt[1:0])
                            2'h0: r_LAD= r_lpc_dat_i[ 3: 0];
                            2'h1: r_LAD= r_lpc_dat_i[ 7: 4];
                        endcase
                        if (cs_dat_p_cnt >= 2'b1)//last data
                            begin
                                ns_LPCState= `LPC_ST_P_TAR1;//tar1 perph
                            end
                        else
                            begin
                                //ns_LPCState= `LPC_ST_H_TAR2;//data read
                                ns_LPCState= `LPC_ST_P_DATA;//data read
                            end
                            r_LAD_OE= 1'b1;
                    end
                default:// start,idle
                    begin
                        ns_LPCState=`LPC_ST_START;
                    end
            endcase
        end
    assign w_addr_hit   = (cs_lpc_adr_reg[11]==1'b1);
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

