module pwm_apb #(
  parameter int PwmWidth   = 4 , // pwm channel number
  parameter int PwmCtrSize = 32, // control register width 1-32
  parameter int BusWidth   = 32  // bus width
)(
  input  logic                pclk,
  input  logic                preset_n,
  input  logic                penable,
  input  logic                psel,
  input  logic                pwrite,
  input  logic [        15:0] paddr,
  input  logic [BusWidth-1:0] pwdata,
  output logic [BusWidth-1:0] prdata,
  output logic                pready,

  // Collected output of all PWMs.
  output logic [PwmWidth-1:0] pwm_o
);

  localparam int unsigned AddrWidth = 16;
  localparam int unsigned PwmIdxOffset = $clog2(BusWidth / 8) + 1;
  localparam int unsigned PwmIdxWidth = AddrWidth - PwmIdxOffset;

  // Generate PwmWidth number of PWMs.
  logic [PwmCtrSize-1:0] counter_q [0:PwmWidth-1];
  logic [PwmCtrSize-1:0] pulse_width_q [0:PwmWidth-1];
  for(genvar i=0; i<PwmWidth; i++) begin:gen_pwm
    logic [PwmCtrSize-1:0] data_d;
    logic counter_en;
    logic pulse_width_en;
    logic [PwmIdxWidth-1:0] pwm_idx;    

    assign pwm_idx = i;

    // Byte enables are currently unsupported for PWM.
    assign data_d         = pwdata[PwmCtrSize-1:0]; // Only take PwmCtrSize LSBs. 
    // Each PWM has a 64-bit block. The most significant 32 bits are the counter 
    // and the least significant 32 bits are the pulse width.
    assign counter_en     = penable & psel & pwrite &  
                            paddr[PwmIdxOffset-1] &
                                                        (paddr[AddrWidth-1:PwmIdxOffset] == pwm_idx);
    assign pulse_width_en = penable & psel & pwrite & 
                            ~paddr[PwmIdxOffset-1] &
                                                        (paddr[AddrWidth-1:PwmIdxOffset] == pwm_idx);

    always @(posedge pclk or negedge preset_n) begin
      if (!preset_n) begin
        counter_q[i]       <= '0;
        pulse_width_q[i]   <= '0;
      end else begin
        if (counter_en) begin
          counter_q[i]     <= data_d;
        end
        if (pulse_width_en) begin
          pulse_width_q[i] <= data_d;
        end
      end
    end 
    pwm #(
      .CtrSize( PwmCtrSize )
    ) u_pwm (
      .clk_i        (pclk            ),
      .rst_ni       (preset_n        ),
      .pulse_width_i(pulse_width_q[i]),
      .max_counter_i(counter_q[i]    ),
      .modulated_o  (pwm_o[i]        )
    );
  end:gen_pwm

  assign pready = penable & psel;

  //read out logic
  always @( * )begin
    if(paddr[15:3] < PwmWidth )begin
      if(paddr[PwmIdxOffset-1])begin
        prdata = counter_q[paddr[AddrWidth-1:PwmIdxOffset]];
      end else begin
        prdata = pulse_width_q[paddr[AddrWidth-1:PwmIdxOffset]];
      end
    end
    else
      prdata=0;  
  end

endmodule
