// Heavily based on this video  -- https://www.youtube.com/watch?v=JYzNDl2i75s&t=560s  /// RMS Approach

const int analog_ip = A0; //Naming analog input pin
int inputVal  = 0; 
long lastsample = 0;
long samplesum = 0;
int sampleCount = 0;

// At 5 V
//float vpp = 0.0048828125; // 5V / 1024
//float vpc = 4.8828125; 

// At 3.3V
float vpp = 0.00322265625; // 3.3V / 1024
float vpc = 3.22265625;

void setup()
{
  Serial.begin(9600);
}


void loop() {

  // Takes a sample every milli second 
  if (millis() > lastsample + 1) {
    //take sample.
    inputVal = analogRead (analog_ip);
    samplesum += sq(inputVal - 542);
    sampleCount++;

    lastsample = millis ();
  }

  // Computes the average over a 
  int sampleTime = 1000; // For 1 second
  if (sampleCount == 1000) {
    // averaging stuff

    float mean = samplesum / sampleCount;
    float value = sqrt(mean);
    float mv = value * vpc;
    float amperage = mv / 185;  //66 for 30A  100 for 20A  185 for 5A

    float inputVoltage = 220;
    Serial.println("Input Value is: " + String(inputVal));
    //Serial.println("Sample mean is: " + String(mean));
    Serial.println("RMS Amperage is: " + String(amperage));
    Serial.println("Appox WATTAGE is: " + String(amperage * inputVoltage * 2));

    samplesum = 0;
    sampleCount = 0;

  }
}

// Testing
// DC Current LED 14.4W  ---> Input 12V ---> Out 14.35W ---> Error 3.4% 
// AC Current LED Bulb 14W ---> Input 220V ---> Out 13.3W ---> Error 5% 
// AC Current LED Bulb 12W ---> Input 220V ---> Out 11.2W ---> Error 6.6% 
// AC Current NON-LED Bulb 18W ---> Input 220V ---> Out 22W ---> Error 22.22%


//
////////////////////////////////// Different Approach /////////////////////////////////////////////////////////////
//
//float totAmp,current;
//
//void setup() {
//  Serial.begin(9600);
//}
//
//void loop() {
//
//  //for (int i = 0; i< 60; i+=1)
//  //{
//    float sensorValue= (analogRead(A0));
//    //float value = (4.89*sensorValue)/1000 ;
//    float value = (3.22*sensorValue)/1000 ;
//    float amp = (value-(1.70));
//
//   
//
//  //current = totAmp / 60 ;
// float watt = amp * 12;
//  //Serial.println("Amperage is: " + String(current));
//  Serial.println(amp);
//  current = 0 ;
//  totAmp  = 0;
//  
//
//}

