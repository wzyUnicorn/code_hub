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
//  puts("Pinmux Test write debug 1\n"); 
//  write(0x20060004,0xa55a);
//
//  puts("Pinmux Test read debug 1\n"); 
//  read(0x20060004,&rdata);
//  if(rdata == 0x52) 
//      puts("Get correct rdata \n");

  read(0x20060004,&rdata);
  if(rdata == 0x52) 
      puts("Get correct rdata \n");


  puts("SPI Test Start debug 1\n"); 

  write(0x20000008,0xf5);
  read(0x20000008,&rdata);
  write(0x2000000c,rdata);
//              Write SPI Device 
  write(0x2000000c,0x00020000);
  write(0x20000010,0xdeadbeef);
  write(0x2000001c,0x12345678);
  write(0x20000014,0x201010);
  write(0x20000018,0x080008);
  write(0x20000000,0xf08);

  puts("SPI Test Start debug 2\n"); 

  while(rdata!=1) {
      read(0x20000004,&rdata);
  }

  puts("SPI Test Start debug 3\n"); 


//              Read SPI Device 
  write(0x2000000c,0x00030000);
  write(0x20000010,0xdeadbeef);
  write(0x20000014,0x201010);
  write(0x20000000,0xf04);

  puts("SPI Test Start debug 4\n"); 

  rdata = 0;
  while(rdata!=0x10001) {
      read(0x20000004,&rdata);
      puts("SPI Test rdata step\n"); 

  }
  
  puts("SPI Test Start debug 5\n"); 

  read(0x20000020,&rdata);

  if(rdata != 0x12345678)
     puts("Error, rdata not match expect !!\n");
  else
     puts("QSPI Test PASS !!\n");
      
while(1);
 
}
