/*
 * Username : stefanozzz123
 * Created : 23/01/2016 
 * Hostname : lynxzz
 * Operating System : GNU/Linux 4.3.3-stefanozzz123_build (Arch)
 */
 
#define BTN 1 // Modalità Pulsante per printSerial
#define LED 2 // Modalità Led per printSerial
const int led = 13; // pin del led
const int btn = 8; // pin del bottone

void setup() { //funzione setup
  pinMode(led,OUTPUT); //imposta il pin led in modalità output 
  pinMode(btn,INPUT); //imposta il pin btn in modalità input
  Serial.begin(9600); //Uso della comunicazione seriale, usato per avere un resoconto degli stati logici
}

void loop() { //funzione loop
  /*
   * digitalRead(int pin) => Prototipo della funzione
   * "int pin" sarebbe il numero del pin da cui ricavare lo stato logico attuale
   * ad esempio
   * digitalRead(12) => ritorna '0' se il pin è "spento", '1' se "Acceso"
   */
   
  int __getval_btn = digitalRead(btn); // nella variabile __getval_btn viene memorizzato il valore di ritorno di digitalRead(btn)
  int __getval_led = digitalRead(led); // stessa cosa per il led
  
  String __getval_btn_str = String(__getval_btn); //conversione dei valori interi '__getval_*' per poter essere mostrati su schermo in stringhe
  String __getval_led_str = String(__getval_led);

  //vedere la funzione scritta sotto per info su printSerial()
  printSerial(BTN,__getval_btn_str);
  printSerial(LED,__getval_led_str);
  
  if(__getval_btn == HIGH && __getval_led == HIGH) { //se il bottone è premuto e il led è acceso
    digitalWrite(led,LOW); //spegni il led
    delay(250); //aspetta 250 millisecondi (altrimenti potrebbe non funzionare bene
  }
  
  else if(__getval_btn == HIGH && __getval_led == LOW) { //se il bottone è premuto e il led è spento
    digitalWrite(led,HIGH); //accendi il led
    delay(250); //aspetta 250 millisecondi (stesso motivo di prima)
  }
}

/*
 * [void] printSerial(int oggetto,String valore)
 * Funzione da me definita per facilitare "la mostra a video" degli stati logici
 * Fornisce infatti delle regole prestabilite, bisogna solo dargli come argomento l'oggetto (led o bottone) e il valore da far visualizzare
 * 
 */
void printSerial(int oggetto,String valore) {
  char * obj;
  if (oggetto == BTN) obj = "Pulsante";
  if (oggetto == LED) obj = "Led";
  Serial.print(obj);
  Serial.print(": ");
  Serial.print(valore);
  Serial.print('\n'); 
}

