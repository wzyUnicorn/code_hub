module jtag_master
(
    input   jtag_test_start,
    input   tdo,
    output  tms,
    output  tclk,
    output  tdi,
    output  trst,
    output  jtag_test_done

);

    reg  tms  = 1; 
    reg  tclk = 0;
    reg  tdi  = 0;
    reg  trst = 1;
    reg  jtag_test_done = 0;
    reg  [31:0] rdata;


    initial begin
        #20000ns;
        forever begin
            #100ns;
            tclk = ~tclk;
        end
    end
    
    initial begin
        trst = 0;
        #10ns;
        trst = 1;
    end

    initial begin
        wait(jtag_test_start ==1);

        jtag_ir_command('h11);   //DMIACCESS

//----------------------------write data-------------------------------------------

        jtag_dr_command('h10,'h01,2);  // write register control

        jtag_dr_command('h39,'h15100,2);  // write system bus addr

        jtag_dr_command('h3c,'h5aa55aa5,2);  // write system bus data

//----------------------------read data--------------------------------------------

        jtag_dr_command('h10,'h01,2);  // write register control

        jtag_dr_command('h38,'h100004,2);  // write register sbaddress0

        jtag_dr_command('h39,'h15100,2);  // read from address 15100

        jtag_dr_command('h3c,'h12345678,1);  // read system bus data
       
//--------------------------------------------------------------------------------

        #1000ns;

        jtag_dr_read(rdata);

        if(rdata != 'h5aa55aa5) begin
          $error("Jtag data compare fail! ");  
        end


        jtag_test_done = 1;
        #1000ns;
    end

    task shift_data(input data);
        @ (posedge tclk);  // enter shift DR
        tms = 0;
        #1ns;
        tdi = data;
    endtask

    task shift_rdata(output data);
        reg data;
        @ (posedge tclk);  // enter shift DR
        tms = 0;
        #1ns;
        data = tdo;
    endtask


    task jtag_dr_command(input bit [6:0] address,input bit [31:0] data,input [1:0] op);

        @ (posedge tclk);  // enter DR
        tms = 1;

        @ (posedge tclk);  // enter capture DR
        tms = 0;

        for(int i=0;i<2;i++) begin
            shift_data(op[i]);
        end

        for(int i=0;i<32;i++) begin
            shift_data(data[i]);
        end

        for(int i=0;i<7;i++) begin
            shift_data(address[i]);
        end

        @ (posedge tclk);  // Exit1 DR
        tdi = 0;
        tms = 1;

        @ (posedge tclk);  // Update DR
        tms = 1;

        @ (posedge tclk);  // Return to Idle
        tms = 0;

    endtask

    task jtag_dr_read(output bit [31:0] data);

        reg [31:0] data;
        reg [40:0] datain;


        @ (posedge tclk);  // enter DR
        tms = 1;

        @ (posedge tclk);  // enter capture DR
        tms = 0;

        @ (posedge tclk);  // enter shift DR
        tms = 0;

        for(int i=0;i<41;i++) begin
            shift_rdata(datain[i]);
        end

        @ (posedge tclk);  // Exit1 DR
        tdi = 0;
        tms = 1;

        @ (posedge tclk);  // Update DR
        tms = 1;

        @ (posedge tclk);  // Return to Idle
        tms = 0;

        data = datain[33:2];
    endtask


    task jtag_ir_command(input bit [5:0] ir_cmd);

        @ (posedge tclk);
        tms = 0;
        @ (posedge tclk);  // enter DR
        tms = 1;
        @ (posedge tclk);  // enter  IR
        tms = 1;
        @ (posedge tclk);  // enter  Capture IR
        tms = 0;

        for(int i=0;i<5;i++) begin
            shift_data(ir_cmd[i]);
        end

        @ (posedge tclk);  // Exit1 IR
        tms = 1;
        #1ns;
        tdi = 0;
        @ (posedge tclk);  // Update IR
        tms = 1;

        @ (posedge tclk);  // Return to Idle
        tms = 0;

    endtask




endmodule
