# Sonic Interaction Design HS2014

Resources and documentation for the sonic interaction design course in the HS2014 semster.

## Hardware

The documentation for the used board can be found in the attached PDF [Data_ACQ_v1.pdf](https://github.com/IAD-ZHDK/SonicInteractionDesignHS2014/blob/master/Data_ACQ_v1.pdf). This board is based on the [Arduino Pro Mini 3.3V/8Mhz](http://arduino.cc/en/pmwiki.php?n=Main/ArduinoBoardProMini) with extended possibilities to attach a [XBee](https://www.sparkfun.com/products/11215) module to have an easy wireless sensor setup. 

The DATA_ACQ board features:

* 6 Analog Inputs (A0...A5)
* I2C Bus (A4/SDA, A5SCL)
* 3.3V onboard Voltage regulator

## Setup

### FDTI Drivers

Download the latest [FDTI drivers](http://www.ftdichip.com/drivers/VCP/MacOSX/FTDIUSBSerialDriver_v2_2_18.dmg) and install them on your computer. They are needed to connect to the DATA_ACQ.

### MIDI

To use MIDI in Processing you have to setup a MIDI IAC Bus as described in this article:

* [How to use the IAC Driver](https://sites.google.com/site/mfalab/mac-stuff/how-to-use-the-iac-driver).

### Arduino

Install the libraries "I2Cdev" and "MPU6050" from the Arduino folder by moving them to your local "Arduino/libraries" folder and restart the Arduino IDE.

1. Load the sketch "Read_IMU.ino".
2. Connect the DATA_ACQ Board via FTDI cale.
3. Select "Arduino Pro or Pro Mini (3.3v, 8Mhz) w/ ATmega168" from the "Board" menu.
4. Select the right port in the "Serial Port" menu.
5. Compile and upload the sketch.

### Processing

Install the library "themidibus" form the Processing folder by moving it to your local "Processing/libraries" folder and restart the Processing IDE.

1. Load the sketch "MIDI_Bridge.pde".
2. In the setup choose the port corresponding with your FTDI cable (e.g. "/dev/tty.usbserial-FTDE61DB").
3. Select the baud rate corresponding with the one in the Arduino sketch (default: 38400).
4. Start the sketch and see values coming from the DATA_ACQ Board.

## MIDI

### Introduction

We are using a library called "themidibus". There are basically to ways to send MIDI data:

1. By sending a MIDI Note.
2. By sending a Controller Change.

### MIDI Notes

MIDI Notes are ideal for triggered events (e.g. playing a sample) that contain information about Channel, Pitch and Velocity. For doing this with the library, we are simply saying:

```java
sendNoteON(channel, pitch, velocity);  
sendNoteOFF(channel, pitch, velocity);
```

### Controller Change

A controller change is a continous change of a value (e.g. influencing filters) and contains information about the Channel, Number and Value. The library supports controller changes by writing:

```java
sendControllerChange(channel, number, value);
```

### Further Information

Can be found in the [repository](https://github.com/sparks/themidibus) of the library.

## Wireless

### Parts

For attaching the FTDI cable and using the XBee to establish a serial connection, we need at least:

* 2 XBee Modules Series 1
* XBee Explorer ([USB](https://www.sparkfun.com/products/11812) or [FTDI](https://www.sparkfun.com/products/11373))
* XCTU Software for programming the XBee ([Download](http://www.digi.com/products/wireless-wired-embedded-solutions/zigbee-rf-modules/xctu))

### Configure XBee

Mark the two Xbee as XBee 1 and XBee 2. Xbee 2 will later be the receiver on the computer and Xbee 2 will sit on the DATA_ACQ Board. To make the settings for the Xbee, connect the Xbee via Explorer to the XCTU Software and set the following parameters (all other could be left untouched).

| Parameter | XBee 1 | Xbee 2 | Description                                            |
|-----------|--------|--------|--------------------------------------------------------|
| MY        | 2      | 1      | Set local ID.                                          |
| DL        | 1      | 2      | Set ID of unit to connect to.                          |
| ID        | 1111   | 1111   | Personnel Area Network ID. Same value on both modules. |
| BD        | 38400  | 38400  | Baud rate. Same value on both modules.                 |
| CH        | B      | B      | Set channel. Same value on both modules.               |

### Test Connection

Plug Xbee 2 via Explorer and FTDI cable to your computer. Place the other Xbee 1 on top of the DATA_ACQ Board. Start Processing sketch "MIDI_Bridge.pde" and power your DATA_ACQ Board with external power supply. You should se the sensor values coming in as before.
