// Read Sensors
// Sonic Interaction Design
// Moritz Kemper, IAD Physical Computing Lab
// ZHdK, 09/01/2015

#include "I2Cdev.h"
#include "MPU6050.h"

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
#include "Wire.h"
#endif

MPU6050 accelgyro;

int xbeeAddress = 1;

void setup(void) 
{
  // join I2C bus (I2Cdev library doesn't do this automatically)
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  Wire.begin();
#elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
  Fastwire::setup(400, true);
#endif

  Serial.begin(9600);
  
  //Serial.println("Initializing I2C devices...");
  accelgyro.initialize();

  //Serial.println("Testing device connections...");
  if(accelgyro.testConnection() == true)
    //Serial.println("MPU6050 connection successful");

  delay(5000);

}

void loop() 
{
  int16_t ax, ay, az, gx, gy, gz = 0;
  int16_t adc0, adc1, adc2, adc3 = 0;

  //If MPU6050 is attached, read the acceleromter and gyroscope values
  accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

  //Read the analog ports
  adc0 = analogRead(0);
  adc1 = analogRead(1);
  adc2 = analogRead(2);
  adc3 = analogRead(3);

  //Sending start byte 
  Serial.write(0x7e); 
  //Sending Address
  Serial.write(xbeeAddress);
  Serial.write(xbeeAddress);

  //Sending accelerometer X
  Serial.write((ax >> 8) & 0xff); Serial.write(ax & 0xff);
  //Sending accelerometer Y
  Serial.write((ay >> 8) & 0xff); Serial.write(ay & 0xff);
  //Sending accelerometer Z
  Serial.write((az >> 8) & 0xff); Serial.write(az & 0xff);
  //Sending gyroscope X
  Serial.write((gx >> 8) & 0xff); Serial.write(gx & 0xff);
  //Sending gyroscope Y
  Serial.write((gy >> 8) & 0xff); Serial.write(gy & 0xff);
  //Sending gyroscope Z
  Serial.write((gz >> 8) & 0xff); Serial.write(gz & 0xff);
  
  //Sending zero analog Value
  Serial.write((adc0 >> 8) & 0xff); Serial.write(adc0 & 0xff);
  //Sending first analog Value
  Serial.write((adc1 >> 8) & 0xff); Serial.write(adc1 & 0xff);
  //Sending second analog Value
  Serial.write((adc2 >> 8) & 0xff); Serial.write(adc2 & 0xff);
  //Sending third analog Value
  Serial.write((adc3 >> 8) & 0xff); Serial.write(adc3 & 0xff);
}







