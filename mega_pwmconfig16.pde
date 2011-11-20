
void setup(){
  TCCR1A = (1<<COM1A1)|(1<<COM1B1)|(1<<COM1C1)|(1<<WGM11);
  TCCR1B = (1<<WGM12)|(1<<WGM13)|(1<<CS10);
  ICR1 = 0xFFFF;
}

void loop(){
  
}
