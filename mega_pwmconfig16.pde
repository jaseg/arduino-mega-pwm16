
void setup(){
  TCCR1A = (1<<COM1A1)|(1<<COM1B1)|(1<<COM1C1)|(1<<WGM11);
  TCCR1B = (1<<WGM12)|(1<<WGM13)|(1<<CS10);
  ICR1 = 0xFFFF;
}

boolean asciiHexToInt(char* str, unsigned int* dest){
  unsigned int output = 0;
  for(unsigned char i=0; i<4; i++){
    if(*str >= '0' && *str <= '9'){
      output += (*str-'0')<<(i*4);
    }else if(*str >= 'A' && str <= 'F'){
      output += (0xA+((*str-'0')<<(i*4)));      
    }else{
      //Error. No hex.
      return false;
    }
    str++;
  }
  *dest = output;
  return true;
}

void loop(){
  
}
