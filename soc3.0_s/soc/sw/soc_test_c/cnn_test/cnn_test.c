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
    volatile int  *cnn_base = (volatile uint8_t *)  0x20080000;

    int dst_addr;
    int src_addr;
    int cnn_dma_en;
    int cnn_count0;
    int cnn_count1;
    int cnn_ctrl1;
    int cnn_int_en;
    int cnn_ctrl0;
    int rdata;
    int addr;
    int expect_data[10];

    usleep(20);

    dst_addr = 0x15000;
    write(0x2008001c,dst_addr);

    src_addr = 0x10000;
    write(0x20080018,src_addr);

    cnn_dma_en = 0x00010001;
    write(0x20080014,cnn_dma_en);

// 
    cnn_count0 = 0x202000e1;
    write(0x20080008,cnn_count0);

// 
    cnn_count1 = 0x000001c2;
    write(0x2008000c,cnn_count1);

// cnn mode conv/pool/line
    cnn_ctrl1  = 7;
    write(0x20080004,cnn_ctrl1);

// cnn interrupt enable
    cnn_int_en = 0x7;
    write(0x20080020,cnn_int_en);


// cnn start
    prints("CNN Test Start !! \n"); 

    cnn_ctrl0 = 0x1;
    write(0x20080000,cnn_ctrl0);

    rdata = 0;
    while(rdata == 0) {
        read(0x20080024,&rdata);
    }
    prints("CNN Output Data compare !! \n");

    expect_data[0] = 0x000000e6;
    expect_data[1] = 0x000000c9;
    expect_data[2] = 0x0000009b;
    expect_data[3] = 0x000000a7;
    expect_data[4] = 0x000000ac;
    expect_data[5] = 0x00000076;
    expect_data[6] = 0x000000ef;
    expect_data[7] = 0x00000027;
    expect_data[8] = 0x00000052;
    expect_data[9] = 0x0000005e;

    for(int i=0;i<10;i++) {
        addr = 0x15000+i*4;
        read(addr,&rdata);
        if(rdata != expect_data[i]) {
            puts("CNN Data compare error !! \n"); 
        }
    }

    prints("CNN Test Pass !! \n"); 
      
while(1);
 
}
