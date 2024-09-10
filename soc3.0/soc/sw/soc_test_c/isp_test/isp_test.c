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
  // The lowest four bits of the highest byte written to the memory region named
  // "stack" are connected to the LEDs of the board.
  volatile int  *uart_base = (volatile uint8_t *)  0x20010000;
  volatile int  *qspi_base = (volatile uint8_t *)  0x20000000;
  *uart_base=0xff;
  *(uart_base+1)=0xff;
  *(uart_base+2)=0xff;
  *(uart_base+3)=0xff;

  *qspi_base=0xF1;
  *(qspi_base+1)=0xF2;
  *(qspi_base+2)=0xF3;
  *(qspi_base+3)=0xF4;
  unsigned int rdata;


// //
   write(0x40000000,0x00061000);   //src
   write(0x40000004,0x00064000);   //target
   write(0x40000008,0x00000100);   //hsize
   write(0x4000000c,0x0000000a);   //vsize
   write(0x40000010,0x00000001);   //xfer start

   rdata = 0;
   while(rdata ==0) {
       read(0x40000014,&rdata); 
   }

  puts("ISP test end \n");
      
while(1);
 
}
