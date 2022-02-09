#include <mega16a.h>
#include <delay.h>
unsigned char k=0;
unsigned long x=0xFFFFFF;
void chia(){
     PORTA=x>>16;
     PORTC=x>>8;
     PORTB=x;
}
void h_u1(){
    x=~x;
    delay_ms(300);
    chia();
}
void h_u2(){
    x=0xAAAAAA;
    chia();
    delay_ms(300);
    x=~x;
    chia();
    delay_ms(300);
}
void h_u3(){
    unsigned char i,j;
    unsigned char cd,c;
    cd=0xFF;
    for(i=8;i>0;i--){
        c=0xFE;
        for(j=0;j<i;j++){
             PORTC=PORTB=c&cd;
             PORTA.0=PORTC.7;
             PORTA.1=PORTC.6;
             PORTA.2=PORTC.5;
             PORTA.3=PORTC.4;
             PORTA.4=PORTC.3;
             PORTA.5=PORTC.2;
             PORTA.6=PORTC.1;
             PORTA.7=PORTC.0;
             delay_ms(85);
             c=(c<<1)|1;
        } 
        cd=PORTC;
    }
}
void h_u4(){
    unsigned char i;
    unsigned char a=0xFC;
    for(i=0;i<4;i++){
        PORTC=PORTB=a; 
        PORTA.0=PORTC.7;
        PORTA.1=PORTC.6;
        PORTA.2=PORTC.5;
         PORTA.3=PORTC.4;
         PORTA.4=PORTC.3;
         PORTA.5=PORTC.2;
         PORTA.6=PORTC.1;
         PORTA.7=PORTC.0;
        delay_ms(200);
        a=(a<<2)|0x03;
    }
}
void h_u5(){
   unsigned char i;
   unsigned char x=0xFF;    //fe  7f
   unsigned char y=0xFF;
   for(i=0;i<4;i++){
      PORTC=PORTB=x&y;
      PORTA.0=PORTC.7;
     PORTA.1=PORTC.6;
     PORTA.2=PORTC.5;
     PORTA.3=PORTC.4;
     PORTA.4=PORTC.3;
     PORTA.5=PORTC.2;
     PORTA.6=PORTC.1;
     PORTA.7=PORTC.0;
      delay_ms(150); 
      x=(x<<1);
      y=(y>>1);
   }
   x=y=0;
 for(i=0;i<4;i++){
      x=(x<<1)&0x01;
      y=(y>>1)&0x04;
     PORTC=PORTB=x|y; 
     PORTA.0=PORTC.7;
     PORTA.1=PORTC.6;
     PORTA.2=PORTC.5;
     PORTA.3=PORTC.4;
     PORTA.4=PORTC.3;
     PORTA.5=PORTC.2;
     PORTA.6=PORTC.1;
     PORTA.7=PORTC.0;
      delay_ms(150); 
   }
}
void h_u6(){      //  so led chay qua chay lai tang dan trong mot khoang thoi gian
    char k[8]={0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00}; 
    unsigned char i,j;
    unsigned int r; 
    for(i=0;i<8;i++){
        r=k[i]; 
        for(j=8;j>i;j--){  
           PORTB=PORTC=r; 
           PORTA.0=PORTC.7;
             PORTA.1=PORTC.6;
             PORTA.2=PORTC.5;
             PORTA.3=PORTC.4;
             PORTA.4=PORTC.3;
             PORTA.5=PORTC.2;
             PORTA.6=PORTC.1;
             PORTA.7=PORTC.0;
           delay_ms(65);
           r=(r<<1)|1;
      }   
        for(j=9;j>i;j--){  
          PORTB=PORTC=r; 
          PORTA.0=PORTC.7;
         PORTA.1=PORTC.6;
         PORTA.2=PORTC.5;
         PORTA.3=PORTC.4;
         PORTA.4=PORTC.3;
         PORTA.5=PORTC.2;
         PORTA.6=PORTC.1;
         PORTA.7=PORTC.0;
           delay_ms(65);
           r=(r>>1);
      }
      r=0xFF; 
      delay_ms(65);
   }
}
void h_u7(){
    unsigned char m=0xF0;
    unsigned char i;
    for(i=0;i<2;i++){
       PORTB=PORTC=m;  
       PORTA.0=PORTC.7;
     PORTA.1=PORTC.6;
     PORTA.2=PORTC.5;
     PORTA.3=PORTC.4;
     PORTA.4=PORTC.3;
     PORTA.5=PORTC.2;
     PORTA.6=PORTC.1;
     PORTA.7=PORTC.0;
        delay_ms(200);
        m=(m<<4)|0x0F;
    }
}
void h_u8(){     //vao hai ben va chay ra 2 ben
   unsigned char i;
   unsigned int a,b,c ;
   b=0xFE;
   a=0x7F;
   for(i=0;i<4;i++){
      c=b&a;
      PORTB=PORTC=c; 
      PORTA.0=PORTC.7;
     PORTA.1=PORTC.6;
     PORTA.2=PORTC.5;
     PORTA.3=PORTC.4;
     PORTA.4=PORTC.3;
     PORTA.5=PORTC.2;
     PORTA.6=PORTC.1;
     PORTA.7=PORTC.0;
      delay_ms(200); 
       b=(b<<1)|1;
        a=(a>>1)|0x80;
   }                   
   PORTB=PORTC=0xFF; 
   PORTA.0=PORTC.7;
     PORTA.1=PORTC.6;
     PORTA.2=PORTC.5;
     PORTA.3=PORTC.4;
     PORTA.4=PORTC.3;
     PORTA.5=PORTC.2;
     PORTA.6=PORTC.1;
     PORTA.7=PORTC.0;
   delay_ms(200);
   b=0xEF;
   a=0xF7;  
   for(i=0;i<4;i++){
      c=b&a;
      PORTB=PORTC=c;  
      PORTA.0=PORTC.7;
     PORTA.1=PORTC.6;
     PORTA.2=PORTC.5;
     PORTA.3=PORTC.4;
     PORTA.4=PORTC.3;
     PORTA.5=PORTC.2;
     PORTA.6=PORTC.1;
     PORTA.7=PORTC.0;
      delay_ms(200); 
       a=(a<<1)|1;
        b=(b>>1)|0x80;
   }
}
interrupt [EXT_INT0] void ext_int0_isr(void)
{
   k++;
   if(k==8)k=0;  
}

void main(void)
{
    PORTD.2=1;   
    DDRD=0x00;
    PORTA=0x00;   
    DDRA=0xFF;
    PORTC=0xFF;
    DDRC=0xFF;
    PORTB=0xFF;
    DDRB=0xFF;
// INT0: On    Low level
GICR|=(1<<6); // bat int 
MCUCR|=(1<<1);  // che do hoat dong int0
#asm("sei")//khai bao ngat toan cuc
while (1)
      {
          if(k==0)h_u1();
          else if(k==1)h_u2();
          else if(k==2)h_u3();
          else if(k==3)h_u4();
          else if(k==4)h_u5(); 
          else if(k==5)h_u6();  
          else if(k==6) h_u7(); 
          else if(k==7)h_u8();
      }
}
