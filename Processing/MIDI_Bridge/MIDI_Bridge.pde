// MIDI Bridge
// Sonic Interaction Design
// Moritz Kemper, IAD Physical Computing Lab
// ZHdK, 09/01/2015

import processing.serial.*;    // Import the Processing Serial Library 
import themidibus.*;           // Import the MIDI Bus Library: https://github.com/sparks/themidibus 

Serial myXbeePort;             // The used Serial Port
MidiBus myMidiBus;             // The used MIDI Port

int xbeeAddress = 1;           // The Address we are listening to

PVector accel = new PVector(); // Variable to store Accelerometer Data
PVector gyro = new PVector();  // Variable to store Gyroscope Data
int[] adc = new int[4];    // Variable to store Analog Data

void setup()
{
  size(500, 500);

  println(Serial.list()); // Prints the list of serial available devices (Arduino should be on top of the list)
  myXbeePort = new Serial(this, "/dev/tty.usbserial-FTDE61DB", 38400); // Open a new port and connect with Arduino at 38400 baud
  myXbeePort.buffer(22);

  MidiBus.list(); // List all available Midi devices
  myMidiBus = new MidiBus(this, "", "P5toMIDI"); //Mac
}

void draw()
{
  background(0);
  drawGraph(width/2, 10);
  myMidiBus.sendControllerChange(1, 20, int(map(gyro.y, -32768, +32767, 0, 127)));
}

void serialEvent(Serial myXbeePort) // Is called everytime there is new data to read
{
  if (myXbeePort.available() == 22)
  {
    if (myXbeePort.read() == 0x7e)
    {
      xbeeAddress = myXbeePort.read();

      byte[] inBuffer = new byte[20]; // Create an empty Byte Array to fill it with data from Arduino
      inBuffer = myXbeePort.readBytes(); // Read in the Bytes

        //Assign the values for the Accelerometer
      accel.x = int(0.8*accel.x + 0.2*(int)((inBuffer[1] << 8) | (inBuffer[0] & 0xff)));
      accel.y = int(0.8*accel.y + 0.2*(int)((inBuffer[3] << 8) | (inBuffer[2] & 0xff)));
      accel.z = int(0.8*accel.z + 0.2*(int)((inBuffer[5] << 8) | (inBuffer[4] & 0xff)));

      //Assign the values for the Gyroscope
      gyro.x = int(0.8*gyro.x + 0.2*(int)((inBuffer[7] << 8) | (inBuffer[6] & 0xff)));
      gyro.y = int(0.8*gyro.y + 0.2*(int)((inBuffer[9] << 8) | (inBuffer[8] & 0xff)));
      gyro.z = int(0.8*gyro.z + 0.2*(int)((inBuffer[11] << 8) | (inBuffer[10] & 0xff)));


      //Assign the values for the Analog Pins
      adc[0] = int(0.8*adc[0] + 0.2*(int)((inBuffer[13] << 8) | (inBuffer[12] & 0xff)));
      adc[1] = int(0.8*adc[1] + 0.2*(int)((inBuffer[15] << 8) | (inBuffer[14] & 0xff)));
      adc[2] = int(0.8*adc[2] + 0.2*(int)((inBuffer[17] << 8) | (inBuffer[16] & 0xff)));
      adc[3] = int(0.8*adc[3] + 0.2*(int)((inBuffer[19] << 8) | (inBuffer[18] & 0xff)));
    }
  }
}

void drawGraph(int x, int y)
{
  fill(255);
  noStroke();
  text("XBee Nr  "+xbeeAddress, x-width/2+10, y);
  text("Accel X  "+accel.x, x-width/2+10, y+20); 
  rect(x, y+=10, map(accel.x, -32768, +32767, -64, 63), 10);
  text("Accel Y  "+accel.y, x-width/2+10, y+20); 
  rect(x, y+=10, map(accel.y, -32768, +32767, -64, 63), 10);
  text("Accel Z  "+accel.z, x-width/2+10, y+20); 
  rect(x, y+=10, map(accel.z, -32768, +32767, -64, 63), 10);
  y+=20;
  text("Gyro X  "+gyro.x, x-width/2+10, y+20); 
  rect(x, y+=10, map(gyro.x, -32768, +32767, -64, 63), 10);
  text("Gyro Y  "+gyro.y, x-width/2+10, y+20); 
  rect(x, y+=10, map(gyro.y, -32768, +32767, -64, 63), 10);
  text("Gyro Z  "+gyro.z, x-width/2+10, y+20); 
  rect(x, y+=10, map(gyro.z, -32768, +32767, -64, 63), 10);
  y+=20;
  text("ADC 0  "+adc[0], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[0], 0, 1023, 0, 127), 10);
  text("ADC 1  "+adc[1], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[1], 0, 1023, 0, 127), 10);
  text("ADC 2  "+adc[2], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[2], 0, 1023, 0, 127), 10);
  text("ADC 3  "+adc[3], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[3], 0, 1023, 0, 127), 10);
}

void keyPressed()
{
  switch(key)
  {
  case 'a':
    myMidiBus.sendNoteOn(1, 64, 127); // Send a Midi noteOn
    myMidiBus.sendNoteOff(1, 64, 127); // Send a Midi noteOn
    break;
  case 'c':

    break;
  }
}

