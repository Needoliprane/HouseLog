const int doorCloseWirePin = 2;
const int doorLockedWirePin = 4;

const int redLedPin = 8;
const int yellowLedPin = 9;
const int greenLedPin = 10;

enum states {
  OPEN = 0,
  CLOSED = 1,
  LOCKED = 2
};

int doorState = 0;

void setup(void) {
   pinMode(doorCloseWirePin, INPUT);
   pinMode(doorLockedWirePin, INPUT);

   pinMode(redLedPin, OUTPUT);
   pinMode(yellowLedPin, OUTPUT);
   pinMode(greenLedPin, OUTPUT);

   digitalWrite(redLedPin, HIGH);
}

bool continuityStatus(int pin)
{
  return (digitalRead(doorState) == HIGH);  
}

void turnOffLeds(void)
{
  digitalWrite(redLedPin, LOW);
  digitalWrite(yellowLedPin, LOW);
  digitalWrite(greenLedPin, LOW);
}

void lightLeds(int doorState) 
{
  turnOffLeds();
  switch (doorState) {
    case OPEN:
      digitalWrite(redLedPin, HIGH);
      break;
    case CLOSED:
      digitalWrite(yellowLedPin, HIGH);
      break;
    case LOCKED:
      digitalWrite(greenLedPin, HIGH);
      break;
  }
}

void loop() {
  int doorState = 0;
  doorState = digitalRead(doorCloseWirePin) ? CLOSED : OPEN;
  doorState = digitalRead(doorLockedWirePin) ? LOCKED : doorState;

  lightLeds(doorState);
}
