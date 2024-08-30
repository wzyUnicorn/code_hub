//Lab 1 - Task 4, Step 6a
//
//Add `timescale
//ToDo

module router_test_top;
  parameter simulation_cycle = 100;

  bit SystemClock;

  //Lab 1 - Task 4, Step 3
  //
  //Add an interface instance
  //ToDo
  
  //Lab 1 - Task 4, Step 4
  //
  //Instantiate the test program
  //Make I/O connection via interface
  //ToDo

  router dut(
    //Lab 1 - Task 4, Step 5
    //
    //Modify DUT connection to connect via interface
    //ToDo

    .reset_n	(reset_n),
    .clock		(clock),
    .din		(din),
    .frame_n	(frame_n),
    .valid_n	(valid_n),
    .dout		(dout),
    .valido_n	(valido_n),
    .busy_n		(busy_n),
    .frameo_n	(frameo_n)
  );

  initial begin
    //Lab 1 - Task 4, Step 6b
    //
    //Add $timeformat
    //ToDo

    SystemClock = 0;
    forever begin
      #(simulation_cycle/2)
        SystemClock = ~SystemClock;
    end
  end

endmodule
