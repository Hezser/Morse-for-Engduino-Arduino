import processing.serial.*;

Serial myPort;
int stateSpaces = 0;
int stateReset = 0;
int stateNewLine = 0;
int stateSameLetter = 0;
int writeSpace = 0;
char letter;
char last = '1';                                               // A random value is assigned to last to initialize it
// Initial values for height and width of the writing space
int x = 15;
int y = 120;

PFont font;
PImage imgEng;
PImage imgUCL;

void setup() {
  size(1100, 700);
  background(10);
  smooth(3);                                                   // Anti-aliasing
  
  font = loadFont("Courier-48.vlw");
  textFont(font);
  
  String portName = Serial.list()[2];                          // Change the 2 to a 0 or 1 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  
  style();
}

void draw() {
  fill(250);
  textSize(26);
  
  spaces();
  
  reset();
  
  inp();

  realTimeWriting();                                             // Writing of characters and update of height and width of the writing space (so letters don't superpose each other)
}

void realTimeWriting() {
  // The variable "last" is used for the program to not print a letter everytime it reads it, but only when it is intended
  if (letter != last) {
    if (letter == '\n' && stateNewLine == 0) {                   // When the '\n' character is received from the Engduino, the writting space jumps to a new line and resets
      y += 50;
      x = 15;
      stroke(255);
      line(0, y-35, 810, y-35);
      stateNewLine = 1;
      stateSameLetter = 0;
    }
    // This allows the same letter to be written twice
    else if (letter == '*' && stateSameLetter == 0) {
      writeLetter(last);
      stateSameLetter = 1;
    }
    else if (letter != '*') {
      stateSameLetter = 0;
      writeLetter(letter);
      last = letter;
    }
  }
}

void writeLetter(char letter) {
  stateNewLine = 0;
  text(letter, x, y);
  if (writeSpace == 1) {
    text(" ", x, y);
    x += 20;
    writeSpace = 0;
    stateSpaces = 0;                                             // State is set to '0' here to allow to write a space after the user starts writing letters again
  }
  if (y < 650) {                                                 // These two lines control the x and y
    if (x > 660) {                                               // coordinates to always fit the screen 
      x = 20;
      y += 30;
    }
    else {
      x += 20;
    }
  }
  else {
    fill(0);
    rect(0, 80, 700, 620);                                        // This rectangle is made to cover/erase what has been previously written to allow for the user to continue writing once he/she has reached the bottom on the screen
    x = 0;
    y = 120;
  }
}

void style() {
  // Initial Message
  textSize(36);
  text("Morse!", 290, 50); 
  stroke(255);
  line(0, 80, 810, 80);
  // White Rectangle
  fill(250);
  rect(700,0,400,1000);
  // Logos of UCL Engineering and UCL
  imgEng = loadImage("UCL-Engineering-Logo.png");
  imgEng.resize(0, 175);
  image(imgEng, 850, 370);
  imgUCL = loadImage("UCL-Logo.png");
  imgUCL.resize(0,80);
  image(imgUCL, 765, 570);
  // Alphabet
  fill(0);
  textSize(18);
  text("A   B   C   D   E   F   G   H   I", 720, 30);
  text("J   K   L   M   N   O   P   Q   R", 720, 130);
  text("S   T   U   V   W   X   Y   Z", 740, 230);
  textSize(14);
  text(".-  -...  -.-.  -..  .  ..-.  --.  ....  ..", 718, 80);
  text(".---  -.-  .-..  --  -.  ---  .--.  --.-  .-.", 712, 180);
  text("...   -  ..-  ...-  .--  -..-  -.--  --..", 730, 280);
}
  
void spaces() {
  if (keyPressed == true && key == ' ' && stateSpaces == 0) {
    writeSpace = 1;                                                // This is done this way (instead of just writing the space here) so the space is written after the last letter written and not before
    stateSpaces = 1;                                               // State is set to '1' so the program does not write many unwanted spaces
  }
}

void reset() {
  if (keyPressed == true && key == '0' && stateReset == 0) {
    myPort.write('0');                                             // Sends data to the Engduino to run the "resettingZero" function
    stateReset = 1;                                                // State is set to '1' so the program does not reset many times at once
  }
}

void inp() {
  if (myPort.available() > 0) {
    letter = myPort.readChar();
    stateReset = 0;                                                  // State is set to '0' here to allow to reset after the user starts writing letters again
  }
}