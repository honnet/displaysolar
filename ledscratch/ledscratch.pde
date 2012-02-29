#include <Encoder.h>
// check the README file for instruction to use this library
#define ENCODER_OPTIMIZE_INTERRUPTS //TODO add in master branch


#define DEBUG

#ifdef DEBUG
#  define DPbegin(s)      Serial.begin(s)
#  define DP(...)         Serial.println( __VA_ARGS__)
#  define TOGGLE_LED()    digitalWrite(DEBUG_LED_PIN, state = !state);
#else
#  define DPbegin(s)
#  define DP(...)
#  define TOGGLE_LED()
#endif


Encoder myEnc(5, 6);
long oldPos=0;
const int TICK_DIV=2*(8000/25); //TODO why 2 ?

const int DEBUG_LED_PIN=11;
bool state=HIGH;


void setup()
{
  pinMode(DEBUG_LED_PIN, OUTPUT);
  DPbegin(115200);
}


void loop()
{
  long newPos = myEnc.read();
  long difPos = newPos-oldPos;

  if ( abs(difPos) > TICK_DIV ) // "divide" encoders ticks
  {
    TOGGLE_LED();
    oldPos = newPos;
    DP(newPos);
  }
}

