

//int firstSensor = 0;    // first analog sensor
//int secondSensor = 0;   // second analog sensor
//int thirdSensor = 0;    // digital sensor
int inByte = 0;         // incoming serial byte

void setup()
{
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(13, OUTPUT);     
  pinMode(2, OUTPUT);      
  pinMode(7, OUTPUT);      
  pinMode(6, OUTPUT); //G     
  pinMode(3, OUTPUT);     
  pinMode(5, OUTPUT);     
  // start serial port at 9600 bps:
  Serial.begin(9600);
  pinMode(2, INPUT);   // digital sensor is on digital pin 2
  establishContact();  // send a byte to establish contact until receiver responds 
  // settings for PWM
  TCCR3A = (1<<COM3A1)|(1<<COM3B1)|(1<<COM3C1)|(1<<WGM31);
  TCCR3B = (1<<WGM32)|(1<<WGM33)|(1<<CS30);
  ICR3 = 0xFFFF;
  TCCR4A = (1<<COM4A1)|(1<<COM4B1)|(1<<COM4C1)|(1<<WGM41);
  TCCR4B = (1<<WGM42)|(1<<WGM43)|(1<<CS40);
  ICR4 = 0xFFFF;
}

void loop()
{
  // if we get a valid byte, read analog ins:
  char valbuf[4];
  unsigned char output = 0;
  unsigned char bufpos = 0;
  unsigned char state = 0;
  unsigned int vals[3];
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    switch(state){
      case 0:
        if(inByte == '\n'){
          state = 1;
        }
        break;
      case 1:
        if(inByte == 'S'){
          state = 2;
        }else{
          state = 0;
        }
        break;
      case 2:
        if(inByte == ' '){
          state = 3;
          output = 0;
          bufpos = 0;
        }else{
          state = 0;
        }
        break;
      case 3:
        valbuf[bufpos] = inByte;
        if(bufpos < 3){
          bufpos++;
        }else{
          if(asciiHexToInt(valbuf, &vals[output])){
            output++;
            if(output == 4){
              OCR3A = vals[0];
              OCR4A = vals[1];
              OCR4B = vals[2];
              output = 0;
              state = 0;
            }
          }else{
            //Parse error.
            state = 0;
          }
        }
        break;
      }
  }
}

boolean asciiHexToInt(char* str, unsigned int* dest){
  unsigned int output = 0;
  for(unsigned char i=0; i<4; i++){
    if(*str >= '0' && *str <= '9'){
      output += (*str-'0')<<(i*4);
    }else if(*str >= 'a' && *str <= 'f'){
      output += (0xA+((*str-'a')<<(i*4)));
    }else{
      //Error. No hex.
      return false;
    }
    str++;
  }
  *dest = output;
  return true;
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0,0,0");   // send an initial string
    delay(300);
  }
}



