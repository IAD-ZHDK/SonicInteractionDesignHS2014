# SonicInteractionDesignHS2014
Files and Dokumentation for the Sonic Interaction Design Course HS2014 
[Physical Computing Lab](http://blog.zhdk.ch/physicalcomputinglab) at [VIAD](http://iad.zhdk.ch)

## 1 Hardware
The documentation for the used board could be found in the attached PDF (Data_ACQ_v1.pdf). This board is based on the [Arduino Pro Mini 3.3V/8Mhz](http://arduino.cc/en/pmwiki.php?n=Main/ArduinoBoardProMini) with extended possibility to attach a [XBee](https://www.sparkfun.com/products/11215) module to have an easy wireless sensor setup. 

The DATA_ACQ Board features:

* 6 Analog Inputs (A0...A5)
* I2C Bus (A4/SDA, A5SCL)
* 3.3V onboard Voltage regulator

## 2 Setup
#####1. FDTI Drivers
Download the latest FDTI drivers [here](http://www.ftdichip.com/drivers/VCP/MacOSX/FTDIUSBSerialDriver_v2_2_18.dmg) and install them into your computer. They are needed to connect to the DATA_ACQ.

#####2. MIDI Setup
To use MIDI in Processing you have to setup a MIDI IAC Bus as described in this link ["How to use the IAD Driver"](https://sites.google.com/site/mfalab/mac-stuff/how-to-use-the-iac-driver)

#####3. Arduino
Install the libraries "I2Cdev" and "MPU6050" from the Arduino folder by moving it to your local "Arduino/libraries" folder and restart the Arduino IDE. 

1. Load the sketch "Read_IMU.ino"
2. Connect the DATA_ACQ Board via FTDI cale
3. Select "Arduino Pro or Pro Mini (3.3v, 8Mhz) w/ ATmega168" from the "Board" menu
4. Select the right port in the "Serial Port" menu
5. Compile and upload the sketch

#####4. Processing
Install the library "themidibus" form the Processing folder by moving it to your local "Processing/libraries" folder and restart the Processing IDE.

1. Load the sketch "MIDI_Bridge.pde"
2. In the setup choose the port corresponding with your FTDI cable (e.g. "/dev/tty.usbserial-FTDE61DB")
3. Select the baud rate corresponding with the one in the Arduino sketch (default: 38400)
4. Start the sketch and see values coming from the DATA_ACQ Board

## 3 MIDI
##### Introduction
We are using a library called "themidibus". There are basically to ways to send MIDI data:
1. Sending a MIDI Note
2. Sending a Controller Change

##### 1. MIDI Notes
MIDI Notes are ideal for triggered events (e.g. playing a sample) contain information about Channel, Pitch and Velocity. For doing this with the library, we are simply saying:

sendNoteON(channel, pitch, velocity);  
sendNoteOFF(channel, pitch, velocity);

#### 2. Controller Change
A controller change is a continous change of a value (e.g. influencing filters) and contain information about Channel, Number and the Value. The library supports controller changes by writing:

sendControllerChange(channel, number, value);

##### 3. Further Information
Could be found in the [github of the library](https://github.com/sparks/themidibus)

## 4 Wireless
Unfortunately there are some issues with the I2C Bus and XBee. At the moment it is only possible to use the Analog pins in conjunction with the XBee.

#####1. Parts
For replacing the FTDI cable and using the XBee to establish a serial connection, we need at least:

* 2 XBee Modules Series 1
* XBee Explorer  ([USB](https://www.sparkfun.com/products/11812) or [FTDI](https://www.sparkfun.com/products/11373))
* XCTU Software for programming the XBee ([Download](http://www.digi.com/products/wireless-wired-embedded-solutions/zigbee-rf-modules/xctu))

#####2. Configure XBee
Mark the two Xbee as XBee 1 and XBee 2. Xbee 2 will later be the receiver on the computer and Xbee 2 will sit on the DATA_ACQ Board. To make the settings for the Xbee, connect the Xbee via Explorer to the XCTU Software and set the following parameters (all other could be left untouched).

|Parameter|XBee 1 | Xbee 2 | Description|
|---------|-------|--------|------------|
|MY|2|1|Set local ID|
|DL|1|2|Set ID of unit to connect to|
|ID|1111|1111|Personnel Area Network ID. Same value on both modules|
|BD|38400|38400|Baud rate. Same value on both modules|
|CH|B|B|Set channel. Same value on both modules|

#####3. Test Connection
Plug Xbee 2 via Explorer and FTDI cable to your computer. Place the other Xbee 1 on top of the DATA_ACQ Board. Start Processing sketch "MIDI_Bridge.pde" and power your DATA_ACQ Board with external power supply. You should se the sensor values coming in as before.
