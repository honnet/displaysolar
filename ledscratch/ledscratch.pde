/* LEDS connections on Teensy:
PORTB:        0,  1,  2,  3,  4,  5,  6,  7
Arduino pin:  0,  1,  2,  3, 15, 14, 13,  4
*/

bool direct = 0;
const int DELAY = 300;


void setup()
{
  DDRB  = B11111111;    // set port B as output
  PORTB = B00000011;    // inital state
}


void loop()
{
  if (PORTB == B00000011 || PORTB == B11000000)
  {
    delay(2*DELAY);
    direct ^= 1; // toggle direct
  }

  PORTB = direct? PORTB<<1 : PORTB>>1;
  delay(DELAY);
}

