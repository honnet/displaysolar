#include <Encoder.h>
// check the README file for instruction to use this library

#define DEBUG

#ifdef DEBUG
#  define DPbegin(s)      Serial.begin(s)
#  define DP(...)         Serial.println( __VA_ARGS__)
#else
#  define DPbegin(s)
#  define DP(...)
#endif

/* LEDS connections on Teensy:
PORTB:  0,  1,  2,  3,  4,  5,  6,  7
pin  :  0,  1,  2,  3, 13, 14, 14,  4
*/

Encoder myEnc(5, 6);
long oldPos = 0;
const int TICK_DIV=(8000/25)/4;
/* The TICK_DIV constant will divide the tick counter, here are some details:
- The highest frequency that we can get from the timecoded vinyl is 8000Hz
- We can see 25 images/sec so we can't blink faster
- The encoder counts 4 ticks per period */
const int DEBUG_LED_PIN=11;
bool state=HIGH;


void setup()
{
  pinMode(DEBUG_LED_PIN, OUTPUT);
  DPbegin(115200);
  DDRB  = 0xFF;    // output
  PORTB = 0x01;    // inital state: 0000 0001
}


void loop()
{
  long newPos = myEnc.read();
  long difPos = newPos-oldPos;

  if ( abs(difPos) > TICK_DIV )
  {
    if ( abs(newPos) > 1<<15 ) // avoid overflows
    {
      oldPos=0;
      myEnc.write(0);
      DP("\n!!! RESET ENCODER !!!\n");
    }
    else
    {
      bool reverse = (difPos<0)? true : false;
      shiftLEDs(reverse);
      
      oldPos = newPos;
      DP(newPos);
    }
    digitalWrite(DEBUG_LED_PIN, state = !state); // toggle debug LED
  }
}


void shiftLEDs(bool reverse)
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
