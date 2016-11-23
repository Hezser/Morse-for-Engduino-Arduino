#include <EngduinoLEDs.h>
#include <EngduinoButton.h>
#include <EngduinoThermistor.h>

unsigned long spentPressed = 0;
unsigned long startPressed = 0;
unsigned long endPressed = 0;
unsigned long spentSilent = 0;
unsigned long startSilent = 0;
unsigned long endSilent = 0;

int state = 0;                      // State is used to rectify the behaviour of resettingTemp function, which used to write an unwanted letter after resetting. 

String letter = "";
char translated;
char last = 'a';                    // "Last" is first set to any letter, so a '*' won't be sent at the beginning of the program 

void morseCode ();

void translation(String);

void resettingTemp(float);
void resettingZero(int);

void setup() { 
  EngduinoLEDs.begin();
  EngduinoButton.begin();
  EngduinoThermistor.begin();
  Serial.begin(9600);
}

void loop() { 
  EngduinoButton.waitUntilPressed();
  float temp = EngduinoThermistor.temperature();

  endSilent = millis();
  startPressed = millis();
  EngduinoLEDs.setAll(CYAN);
  
  EngduinoButton.waitUntilReleased();
  endPressed = millis();
  EngduinoLEDs.setAll(OFF);
  
  spentPressed = endPressed - startPressed;
  spentSilent = endSilent - startSilent;
  
  morseCode();
  
  char inp = Serial.read();
  resettingZero(inp);
  resettingTemp(temp);
  
  startSilent = millis();
}
// Determines the composition of a letter
void morseCode () {
  // Spaces between letters
  if (spentSilent > 400) {
    if (state == 0) {
      translation(letter);
      if (translated != last) {
        Serial.print(translated);
      }
      else {
        Serial.print('*');        // This is used for the Processing to be able to print two letters which are the same
      }
      last = translated;
    }
    else {
      state = 0;
    }
    letter = "";
  }
  // Dots
  if (spentPressed < 171) {
    letter += ".";
  }
  // Dashes
  else if (spentPressed < 2000) {
    letter += "_";
  }
}

void resettingTemp(float temp) {
  if (temp > 30) {                // The temperature (30) can be changed to adjust to the evironment the user is in
    Serial.print('\n');
    letter = "";
    state = 1;
  }
}

void resettingZero(int inp) {
  if (inp == '0') {
    Serial.print('\n');
    letter = "";
  }
}
// Translates a letter from morse code (this function works as a dictionary)
void translation(String letter) {
  if (letter == "._") {
    translated = 'A';
  }
  else if (letter == "_...") {
    translated = 'B';
  }
  else if (letter == "_._.") {
    translated = 'C';
  }
  else if (letter == "_..") {
    translated = 'D';
  }
  else if (letter == ".") {
    translated = 'E';
  }
  else if (letter == ".._.") {
    translated = 'F';
  }
  else if (letter == "__.") {
    translated = 'G';
  }
  else if (letter == "....") {
    translated = 'H';
  }
  else if (letter == "..") {
    translated = 'I';
  }
  else if (letter == ".___") {
    translated = 'J';
  }
  else if (letter == "_._") {
    translated = 'K';
  }
  else if (letter == "._..") {
    translated = 'L';
  }
  else if (letter == "__") {
    translated = 'M';
  }
  else if (letter == "_.") {
    translated = 'N';
  }
  else if (letter == "___") {
    translated = 'O';
  }
  else if (letter == ".__.") {
    translated = 'P';
  }
  else if (letter == "__._") {
    translated = 'Q';
  }
  else if (letter == "._.") {
    translated = 'R';
  }
  else if (letter == "...") {
    translated = 'S';
  }
  else if (letter == "_") {
    translated = 'T';
  }
  else if (letter == ".._") {
    translated = 'U';
  }
  else if (letter == "..._") {
    translated = 'V';
  }
  else if (letter == ".__") {
    translated = 'W';
  }
    else if (letter == "_.._") {
    translated = 'X';
  }
  else if (letter == "_.__") {
    translated = 'Y';
  }
  else if (letter == "__..") {
    translated = 'Z';
  }
  else {
    //Not a valid character
  }
}
  
