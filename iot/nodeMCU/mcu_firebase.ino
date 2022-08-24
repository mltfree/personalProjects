//1. Include Firebase ESP8266 library (this library)
#include "FirebaseESP8266.h"

//2. Include ESP8266WiFi.h and must be included after FirebaseESP8266.h
#include <ESP8266WiFi.h>

//3. Declare the Firebase Data object in global scope
FirebaseData firebaseData;



int relayInput = 2; // the input to the relay pin



void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println();

  WiFi.begin("Makers Asylum", "passiton");

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println();

  Serial.print("Connected, IP address: ");
  Serial.println(WiFi.localIP());


  //4. Setup Firebase credential in setup()
  Firebase.begin("empr-518a0.firebaseio.com", "----");

  // put your setup code here, to run once:
  // pinMode(relayInput, OUTPUT); // initialize pin as OUTPUT

  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);


}

void loop() {
  // put your main code here, to run repeatedly:
  //In setup(), set the streaming path to "/test/data" and begin stream connection

  //Firebase.setInt(firebaseData, "/user1/switch", 0);
  
  if (!Firebase.beginStream(firebaseData, "/user1/switch"))
  {
    Serial.println(firebaseData.errorReason());
  }
  
  //In loop()
  if (!Firebase.readStream(firebaseData))
  {
    Serial.println(firebaseData.errorReason());
  }
  
  if (firebaseData.streamTimeout())
  {
    Serial.println("Stream timeout, resume streaming...");
    Serial.println();
  }

  if (firebaseData.streamAvailable())
  {
    Serial.println("Stream timeout, resume streaming...");
    Serial.println();
    if (firebaseData.intData() == 1)
      // put your main code here, to run repeatedly:
      //digitalWrite(relayInput, HIGH); // turn relay on;
      digitalWrite(LED_BUILTIN, HIGH); 
    else if (firebaseData.intData() == 0)
      //digitalWrite(relayInput, LOW);  
      digitalWrite(LED_BUILTIN, LOW);
       
  }
  
}
