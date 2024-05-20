#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>

#ifdef __AVR__
#include <avr/power.h>
#endif

#define SERVICE_UUID "87e3a34b-5a54-40bb-9d6a-355b9237d42b"
#define CHARACTERISTIC_UUID "cdc7651d-88bd-4c0d-8c90-4572db5aa14b"
#define bleServerName "ESP32 Test Device"

BLEServer* pServer = NULL;
BLEService* pService = NULL;
BLECharacteristic* pCharacteristic = NULL;
BLEAdvertising* pAdvertising = NULL;

bool deviceConnected = false;

class MyServerCallbacks : public BLEServerCallbacks {
};

class CharacteristicCallback : public BLECharacteristicCallbacks {
};

void setup() {
}

void loop() {
}