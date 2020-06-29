#include <SoftwareSerial.h>

const String ssid = "Freebox-titi";
const String pass = "CC778B13E0";
const int port = 80;
SoftwareSerial ESP8266(2, 3);

const int doorCloseWirePin = 4;
const int doorLockedWirePin = 5;

const int redLedPin = 8;
const int yellowLedPin = 9;
const int greenLedPin = 10;

enum states {
  OPEN = 0,
  CLOSED = 1,
  LOCKED = 2
};

int doorState = 0;

void sendESP8266(String commande)
{  
  ESP8266.println(commande);
}

void getESP8266(const int timeout)
{
  String res = "";
  long int time = millis();
  while( (time+timeout) > millis())
    while(ESP8266.available())
      res += (char)ESP8266.read();
  Serial.println(res);
}

void add_door()
{
  ESP8266.println("add_door {\"username\":\"bob\",\"name\":\"porte\",\"position\":\"salon\",\"status\":\"close\" }");
}

void initEsp8266()
{
  ESP8266.begin(9600);
  sendESP8266("AT+RST");
  getESP8266(2000);
  sendESP8266("AT+CWMODE=3");
  getESP8266(5000);
  sendESP8266("AT+CWJAP=\""+ ssid + "\",\"" + pass +"\"");
  getESP8266(10000);
  sendESP8266("AT+CIFSR");
  getESP8266(1000);
  sendESP8266("AT+CIPMUX=1");   
  getESP8266(1000);
  sendESP8266("AT+CIPSERVER=1,80");
  getESP8266(1000);
  sendESP8266("AT+CIPSTART: \"TCP\",\"192.168.0.49\",80");
  getESP8266(10000);
  add_door();
}

void setup(void) {
  Serial.begin(9600);
  initEsp8266();

  pinMode(doorCloseWirePin, INPUT);
  pinMode(doorLockedWirePin, INPUT);

  pinMode(redLedPin, OUTPUT);
  pinMode(yellowLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);

  digitalWrite(redLedPin, HIGH);
}

bool continuityStatus(int pin)
{
  return (digitalRead(pin) == HIGH);  
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

void sendData(int state)
{
  if (state == OPEN)
    ESP8266.println("update_door {\"username\":\"bob\",\"name\":\"porte\",\"position\":\"salon\",\"status\":\"open\"}");
  else if (state == CLOSED)
    ESP8266.println("update_door {\"username\":\"bob\",\"name\":\"porte\",\"position\":\"salon\",\"status\":\"close\"}");
  else
    ESP8266.println("update_door {\"username\":\"bob\",\"name\":\"porte\",\"position\":\"salon\",\"status\":\"locked\"}");
  getESP8266(500);
}

void loop() {
  int doorState = 0;
  doorState = digitalRead(doorCloseWirePin) ? CLOSED : OPEN;
  doorState = digitalRead(doorLockedWirePin) ? LOCKED : doorState;

  lightLeds(doorState);
  sendData(doorState);
}
