// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdint.h>
#define CLK_FIXED_FREQ_HZ (50ULL * 1000 * 1000)
/**
 * Delay loop executing within 8 cycles on ibex
 */
static void delay_loop_ibex(unsigned long loops) {
  int out; /* only to notify compiler of modifications to |loops| */
  asm volatile(
      "1: nop             \n" // 1 cycle
      "   nop             \n" // 1 cycle
      "   nop             \n" // 1 cycle
      "   nop             \n" // 1 cycle
      "   addi %1, %1, -1 \n" // 1 cycle
      "   bnez %1, 1b     \n" // 3 cycles
      : "=&r" (out)
      : "0" (loops)
  );
}

static int usleep_ibex(unsigned long usec) {
  unsigned long usec_cycles;
  usec_cycles = CLK_FIXED_FREQ_HZ * usec / 1000 / 1000 / 8;

  delay_loop_ibex(usec_cycles);
  return 0;
}

static int usleep(unsigned long usec) {
  return usleep_ibex(usec);
}

int main(int argc, char **argv) {
    volatile int  *pwm_base = (volatile uint8_t *)  0x20070000;

    int pulse_width;
    int count_max;
    int wdata;
    int rdata;

    usleep(20);

    wdata = 0x22;

    write(0x20060014,wdata); // pad pinmux
    write(0x20060018,wdata); // pad pinmux
    write(0x2006001c,wdata); // pad pinmux

    write(0x90008,1); // jtag start
    
    rdata = 1;
    while(rdata == 1) {
        read(0x90008,&rdata);  // wait jtag test done
    }

    read(0x15100,&rdata);  // wait jtag data check

    if(rdata != 0x5aa55aa5) {
        puts("Jtag Data compare error !! \n"); 
    }
    
    usleep(20);

    puts("JTAG Test Pass !! \n"); 
      
while(1);
 
}
