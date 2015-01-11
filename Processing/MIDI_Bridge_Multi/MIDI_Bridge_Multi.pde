// MIDI Bridge
// Sonic Interaction Design
// Moritz Kemper, IAD Physical Computing Lab
// ZHdK, 09/01/2015

import processing.serial.*;    // Import the Processing Serial Library 
import themidibus.*;           // Import the MIDI Bus Library: https://github.com/sparks/themidibus 

Serial myXbeePort;             // The used Serial Port
MidiBus myMidiBus;             // The used MIDI Port

PVector[] accel = new PVector[5]; // Variable to store Accelerometer Data
PVector[] gyro = new PVector[5];  // Variable to store Gyroscope Data
int[][] adc = new int[5][4];    // Variable to store Analog Data

void setup()
{
  size(500, 500);
  
  for(int i=0; i<5; i++)
  {
    accel[i] = new PVector(0,0);
    gyro[i] = new PVector(0,0);
  }
  
  println(Serial.list()); // Prints the list of serial available devices (Arduino should be on top of the list)
  myXbeePort = new Serial(this, "/dev/tty.usbserial-FTDE61DB", 38400); // Open a new port and connect with Arduino at 38400 baud
  myXbeePort.buffer(22);

  MidiBus.list(); // List all available Midi devices
  myMidiBus = new MidiBus(this, "", "P5toMIDI"); //Mac
}

void draw()
{
  background(0);
  drawGraph(1,width/2,10);
  myMidiBus.sendControllerChange(1, 20, int(map(gyro[1].x, -32768, +32767, 0, 127)));
}

void serialEvent(Serial myXbeePort) // Is called everytime there is new data to read
{
  if (myXbeePort.available() == 22)
  {
    if (myXbeePort.read() == 0x7e)
    {
      int xbeeAddress = myXbeePort.read(); // Look were we are sending from

      byte[] inBuffer = new byte[20]; // Create an empty Byte Array to fill it with data from Arduino
      inBuffer = myXbeePort.readBytes(); // Read in the Bytes

      //Assign the values for the Accelerometer
      accel[xbeeAddress].x = int(0.8*accel[xbeeAddress].x + 0.2*(int)((inBuffer[1] << 8) | (inBuffer[0] & 0xff)));
      accel[xbeeAddress].y = int(0.8*accel[xbeeAddress].y + 0.2*(int)((inBuffer[3] << 8) | (inBuffer[2] & 0xff)));
      accel[xbeeAddress].z = int(0.8*accel[xbeeAddress].z + 0.2*(int)((inBuffer[5] << 8) | (inBuffer[4] & 0xff)));
      
      //Assign the values for the Gyroscope
      gyro[xbeeAddress].x = int(0.8*gyro[xbeeAddress].x + 0.2*(int)((inBuffer[7] << 8) | (inBuffer[6] & 0xff)));
      gyro[xbeeAddress].y = int(0.8*gyro[xbeeAddress].y + 0.2*(int)((inBuffer[9] << 8) | (inBuffer[8] & 0xff)));
      gyro[xbeeAddress].z = int(0.8*gyro[xbeeAddress].z + 0.2*(int)((inBuffer[11] << 8) | (inBuffer[10] & 0xff)));
      
      //Assign the values for the Analog Pins
      adc[xbeeAddress][0] = int(0.8*adc[xbeeAddress][0] + 0.2*(int)((inBuffer[13] << 8) | (inBuffer[12] & 0xff)));
      adc[xbeeAddress][1] = int(0.8*adc[xbeeAddress][1] + 0.2*(int)((inBuffer[15] << 8) | (inBuffer[14] & 0xff)));
      adc[xbeeAddress][2] = int(0.8*adc[xbeeAddress][2] + 0.2*(int)((inBuffer[17] << 8) | (inBuffer[16] & 0xff)));
      adc[xbeeAddress][3] = int(0.8*adc[xbeeAddress][3] + 0.2*(int)((inBuffer[19] << 8) | (inBuffer[18] & 0xff)));;
    }
  }
}

void drawGraph(int index, int x, int y)
{
  fill(255);
  noStroke();
  text("XBee Nr  "+index, x-width/2+10, y);
  text("Accel X  "+accel[index].x, x-width/2+10, y+20); 
  rect(x, y+=10, map(accel[index].x, -32768, +32767, -64, 63), 10);
  text("Accel Y  "+accel[index].y, x-width/2+10, y+20); 
  rect(x, y+=10, map(accel[index].y, -32768, +32767, -64, 63), 10);
  text("Accel Z  "+accel[index].z, x-width/2+10, y+20); 
  rect(x, y+=10, map(accel[index].z, -32768, +32767, -64, 63), 10);
  y+=20;
  text("Gyro X  "+gyro[index].x, x-width/2+10, y+20); 
  rect(x, y+=10, map(gyro[index].x, -32768, +32767, -64, 63), 10);
  text("Gyro Y  "+gyro[index].y, x-width/2+10, y+20); 
  rect(x, y+=10, map(gyro[index].y, -32768, +32767, -64, 63), 10);
  text("Gyro Z  "+gyro[index].z, x-width/2+10, y+20); 
  rect(x, y+=10, map(gyro[index].z, -32768, +32767, -64, 63), 10);
  y+=20;
  text("ADC 0  "+adc[index][0], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[index][0], 0, 1023, 0, 127), 10);
  text("ADC 1  "+adc[index][1], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[index][1], 0, 1023, 0, 127), 10);
  text("ADC 2  "+adc[index][2], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[index][2], 0, 1023, 0, 127), 10);
  text("ADC 3  "+adc[index][3], x-width/2+10, y+20); 
  rect(x, y+=10, map(adc[index][3], 0, 1023, 0, 127), 10);
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

