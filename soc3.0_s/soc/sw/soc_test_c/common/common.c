#include <stdint.h>

#define DEV_WRITE(addr, val) (*((volatile unsigned int *)(addr)) = val)
volatile int  *uart_base = (volatile uint8_t *)  0x20010000;

int putchar(int c) {
  DEV_WRITE(0x80004, (unsigned char)c);

  return c;
}

int puts(const char *str) {
	int i;
	i=0;
	//start flag
	DEV_WRITE(0x80000,0xdddd1111);
  while (str[i]!='\0') {
    putchar(str[i]);
	i++;
  }
  //end flag
    DEV_WRITE(0x80000,0xddddeeee);
  return 0;
}

void write(unsigned int addr, unsigned int data)
{
            (*(unsigned int *)addr) = data;
}

void read (unsigned int addr, unsigned int *data)
{
  *data=*(unsigned int *) addr;
}

void prints(char *str) {
    int i;
    int rdata;
    int wdata;

    wdata = 0x44;
    write(0x20060024,wdata); // pad pinmux

    *(uart_base+3)=0x80;  //DLM,DLL register enable
    *uart_base=0x4;       // Set DLL register
    *(uart_base+1)=0x00;  // Set DLM register
    *(uart_base+2)=0xff;
    *(uart_base+3)=0x03;

    for (i = 0; str[i] != '\0'; i++) {
       int ascii_code = (int) str[i];
       *uart_base = ascii_code;
       rdata = *(uart_base+5);
       while ((rdata &0x40)!=0x40) {
       rdata = *(uart_base+5);
       }
    }
}

