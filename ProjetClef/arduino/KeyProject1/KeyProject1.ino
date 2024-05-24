#include "WiFi.h"
#include "ESPAsyncWebServer.h"

// Inclut la bibliothèque AccelStepper:
#include <AccelStepper.h>

// setup rotor
int numberOfTurns = 7.3;
int speed = 1500;

void wifiInit();
void stepperMotorInit();
String getStateStr();
String getKeyStr();

// IP adress of ESP
// 192.168.5.31
const char* ssid = "NOVA_F610";  //replace
const char* password =  "rule9654"; //replace

IPAddress staticIP(192, 168, 5, 199);
IPAddress gateway(192, 168, 5, 1);   // Replace this with your gateway IP Addess
IPAddress subnet(255, 255, 255, 0);  // Replace this with your Subnet Mask
IPAddress dns(192, 168, 5, 1);   // Replace this with your DNS

AsyncWebServer server(80);

// Définitions des broches du moteur:
#define motorPin1  32      // IN1 on the ULN2003 driver
#define motorPin2  33      // IN2 on the ULN2003 driver
#define motorPin3  12     // IN3 on the ULN2003 driver
#define motorPin4  13     // IN4 on the ULN2003 driver

// Define Pin input for key missing check (low = missing) 
#define keyPin     4

// Define Pin output to the shield that provides power to the motor ( High = motor enabled, low = disabled) 
#define shieldPin  25


// Définit le type d'interface AccelStepper; Moteur 4 fils en mode demi-pas:
#define MotorInterfaceType 8

// Initialisation avec la séquence de broches IN1-IN3-IN2-IN4 pour utiliser la bibliothèque AccelStepper avec le moteur pas à pas 28BYJ-48:
AccelStepper stepper = AccelStepper(MotorInterfaceType, motorPin1, motorPin3, motorPin2, motorPin4);

int stepsPerAngle = 4096/360;
int WingAngle = stepper.currentPosition();

// state flags
#define OPENING   0
#define CLOSING   1
#define OPENED    2
#define CLOSED    3




int State = CLOSED; 
int keyIsOn = 0;
int keyWasOn = 0;

unsigned long startTime = 0;
unsigned long currentTime = 0;
unsigned long elapsedTime = 0;

void setup(){
  wifiInit();
  stepperMotorInit();
  pinMode(keyPin, INPUT);
  keyIsOn = digitalRead(keyPin);
  pinMode(shieldPin, OUTPUT);
  digitalWrite(shieldPin, LOW);   
}
 
void loop(){
  
  
  switch ( State )
{
    case OPENING:
        digitalWrite(shieldPin, HIGH);
        delay(500);
        WingAngle = numberOfTurns*360;
        stepper.runToNewPosition(WingAngle*stepsPerAngle);
        delay(500);
        State = OPENED;
        startTime = millis();
        break;
    case CLOSING:
        delay(2000);
        WingAngle = 0;
        stepper.runToNewPosition(WingAngle*stepsPerAngle);
        delay(500);
        State = CLOSED;
        break;
    case OPENED:
        keyWasOn = keyIsOn;
        keyIsOn = digitalRead(keyPin);
        if(keyWasOn != keyIsOn){
          delay(500);
          keyIsOn = digitalRead(keyPin); // prevent jitter & noise errors
          }
        currentTime = millis();
        elapsedTime = currentTime - startTime;
        if(keyWasOn == LOW && keyIsOn == HIGH){
          State = CLOSING;
        }
        else if(keyIsOn == HIGH && elapsedTime > 60000){
          State = CLOSING;
        }
        else if(keyIsOn == LOW && elapsedTime > 120000){
          State = CLOSING;
        }
        break;
    case CLOSED:
        digitalWrite(shieldPin, LOW);
        break;
    default:
        break;
}
  }


void stepperMotorInit(){
  // Définit le nombre maximum de pas par seconde:
  stepper.setMaxSpeed(speed);
  stepper.setSpeed(speed);
  stepper.setAcceleration(1000);
  stepper.run();
  stepper.runToNewPosition(0);
}

void wifiInit(){
  
  
  Serial.begin(115200);
 
  if (WiFi.config(staticIP, gateway, subnet, dns, dns) == false) {
   Serial.println("Configuration failed.");
  }
   
  WiFi.begin(ssid, password);
 
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }
 
  Serial.println(WiFi.localIP());
 
  server.on("/hello", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(200, "text/plain", "Hello World");
  });

  server.on("/relay/off", HTTP_GET   , [](AsyncWebServerRequest *request){
    request->send(200, "text/plain", "Closing"+getKeyStr());
    State = CLOSING;
    
  });
   server.on("/relay/on", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(200, "text/plain","Opening"+getKeyStr());
    State = OPENING; 
  });
  
  server.on("/relay/toggle", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(200, "text/plain","ok");
  });
  
  server.on("/relay", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(200, "text/plain", getStateStr()+getKeyStr());
  });
  
  server.begin();
}

String getKeyStr(){
  keyIsOn = digitalRead(keyPin);
  String textState = "";
    switch ( keyIsOn )
  {
    case HIGH:
        textState = " / Key if ON";
        break;
    case LOW:
        textState = " / Key is OFF";
        break;
    default:
        textState = " / Unknown key state";
  }
  return textState;
}

String getStateStr(){
    String textState = "";
    switch ( State )
  {
    
    case OPENING:
        textState = "Opening";
        break;
    case CLOSING:
        textState = "Closing";
        break;
    case OPENED:
        textState = "Opened";
        break;
    case CLOSED:
        textState = "Closed";
        break;
    default:
        break;
  }
  return textState;
 }
