/////////////////////////////////////////////////////////////////


// Define board clock - main system clock period
// 20ns period = 50MHz freq.
`define BOARD_CLOCK_PERIOD 50

// Included modules: define to include
//`define JTAG_DEBUG
`define UART0
`define I2C
//`define RAM_WB
//`define INTGEN

// end of included module defines - keep this comment line here

//
// Arbiter defines
//

// Uncomment to register things through arbiter (hopefully quicker design)
// Instruction bus arbiter
//`define ARBITER_IBUS_REGISTERING
//`define ARBITER_IBUS_WATCHDOG
// Watchdog timeout: 2^(ARBITER_IBUS_WATCHDOG_TIMER_WIDTH+1) cycles
//`define ARBITER_IBUS_WATCHDOG_TIMER_WIDTH 12

// Data bus arbiter

//`define ARBITER_DBUS_REGISTERING
//`define ARBITER_DBUS_WATCHDOG
// Watchdog timeout: 2^(ARBITER_DBUS_WATCHDOG_TIMER_WIDTH+1) cycles
//`define ARBITER_DBUS_WATCHDOG_TIMER_WIDTH 12

// Byte bus (peripheral bus) arbiter
// Don't really need the watchdog here - the databus will pick it up
//`define ARBITER_BYTEBUS_WATCHDOG
// Watchdog timeout: 2^(ARBITER_BYTEBUS_WATCHDOG_TIMER_WIDTH+1) cycles
//`define ARBITER_BYTEBUS_WATCHDOG_TIMER_WIDTH 9

