#include <Encoder.h>
// check the README file for instruction to use this library
#define ENCODER_OPTIMIZE_INTERRUPTS


#define DEBUG

#ifdef DEBUG
#  define DP_INIT(s)          Serial.begin(s)
#  define DP(...)             Serial.println( __VA_ARGS__)
#else
#  define DP_INIT(s)
#  define DP(...)
#endif

/* LEDS connections on Teensy:
PORTB:        0,  1,  2,  3,  4,  5,  6,  7
Arduino pin:  0,  1,  2,  3, 15, 14, 13,  4
*/

Encoder myEnc(5, 6);
long oldPos = 0;
const int TICK_DIV=((8000/25)*4)/4;
/* The TICK_DIV constant will divide the tick counter, here are some details:
- The highest frequency that we can get from the timecoded vinyl is 8000Hz
- We can see 25 images/sec so we can't blink faster
- The encoder counts 4 ticks per period
- The last value is empirical, it allows a better scratch feedback */


void setup()
{
  DP_INIT(115200);
  DDRB  = 0xFF;    // set port B as output
  PORTB = 0x01;    // inital state: 0000 0001
}


void loop()
{
  long newPos = myEnc.read();
  long difPos = newPos-oldPos;

  if ( abs(difPos) > TICK_DIV ) // tick divider
  {
    bool reverse = (difPos<0)? true : false;
    shiftLEDs(reverse);
      
    oldPos = newPos;
    DP(newPos);
  }
}


void shiftLEDs(bool reverse) // barrel shifter
{
  if (reverse)
  {
    if (PORTB == 0x01) PORTB = 0x80;
    else PORTB >>= 1;
  }
  else
  {
    if (PORTB == 0x80) PORTB = 0x01;
    else PORTB <<= 1;
  }
}
