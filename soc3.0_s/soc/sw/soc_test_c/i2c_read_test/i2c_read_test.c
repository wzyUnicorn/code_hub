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
  volatile int  *i2c_base = (volatile uint8_t *)  0x20030000;

  unsigned int rdata =  0;

  unsigned int wdata =  0;
  wdata = 0x22;
  write(0x20060004,wdata); // pad pinmux
  write(0x90008,4); // i2c start

  write(0x20030000,0x10);
  write(0x20030004,0x00);
  write(0x20030008,0xc0);

  write(0x20030014,0x5b);  // bit0 = 1, read i2c device
  write(0x20030018,0xa0);

  read(0x20030010,&rdata);
  while((rdata&0x02) ==0x02)  {
      puts("Wait I2C idle \n");
      read(0x20030010,&rdata);
  }

  write(0x20030018,0x60);   // read i2c device data

  read(0x20030010,&rdata);
  while((rdata&0x02) ==0x02)  {
      puts("Wait I2C idle \n");
      read(0x20030010,&rdata);
  }
  
  read(0x2003000c,&rdata);
  
  if(rdata != 0x73) {
      puts("Error data not match ! \n");
  } else {
      puts("read data compare pass ! \n");
  }

      
while(1);
 
}
