# Home Automation Research — Complete Guide
**Date:** April 20, 2026 | **Prepared by:** Nexus for Aniket

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────┐
│              YOUR PHONE (Anywhere)              │
│         Home Assistant Companion App            │
│            (Android / iOS - FREE)               │
└──────────────────────┬──────────────────────────┘
                       │ (Internet / VPN)
┌──────────────────────▼──────────────────────────┐
│          RASPBERRY PI (Home Server)             │
│    ┌─────────────────────────────────────┐      │
│    │   Home Assistant (Open Source)      │      │
│    │   + ESPHome Add-on                 │      │
│    │   + Mosquitto MQTT Broker          │      │
│    │   + Frigate NVR (Camera AI)        │      │
│    └─────────────────────────────────────┘      │
└──────────────────────┬──────────────────────────┘
                       │ WiFi
    ┌──────────────────┼──────────────────────┐
    │                  │                      │
┌───▼───┐      ┌──────▼──────┐     ┌─────────▼────────┐
│ESP32   │      │ ESP32-CAM   │     │ ESP32 + IR       │
│Relay   │      │ Doorbell    │     │ AC Controller    │
│Boards  │      │ + Lock      │     │ + Sensors        │
└────────┘      └─────────────┘     └──────────────────┘
 Lights           Door Lock           AC, TV, Fan
 Fans             Live Video          Temp/Humidity
 Appliances       Motion Detect       Gas Detection
```

---

## 📦 PART 1: SOFTWARE STACK (100% Free & Open Source)

### 1. Home Assistant — The Brain
- **What:** Open-source home automation platform (local control, no cloud needed)
- **License:** Apache 2.0
- **Website:** https://www.home-assistant.io
- **GitHub:** https://github.com/home-assistant/core (72K+ ⭐)
- **Mobile App:** FREE on Play Store & App Store
- **Remote Access:** Built-in (Home Assistant Cloud @ ₹550/mo) OR free via Tailscale/WireGuard VPN
- **Why this:** 2700+ integrations, massive community, local-first privacy

### 2. ESPHome — Device Firmware
- **What:** Turns ESP32/ESP8266 into smart devices using simple YAML config
- **License:** MIT
- **Website:** https://esphome.io
- **GitHub:** https://github.com/esphome/esphome (9K+ ⭐)
- **Latest:** ESPHome 2026.4.0 (performance boost for ESP32)
- **Why this:** No coding needed — write YAML, flash, done. Auto-discovers in Home Assistant.

### 3. Mosquitto MQTT — Communication Broker
- **What:** Lightweight message broker for device communication
- **License:** EPL 2.0
- **Website:** https://mosquitto.org
- **Why this:** Standard IoT protocol, runs on RPi, all ESP devices speak MQTT

### 4. Frigate NVR — Camera AI
- **What:** AI-powered NVR with real-time object detection
- **License:** MIT
- **GitHub:** https://github.com/blakeblackshear/frigate
- **Why this:** Detect people/animals on camera feed, send alerts to phone

### 5. Mobile App Options
- **Home Assistant Companion** (recommended) — FREE, Android + iOS
- **OR build custom:** Flutter + Home Assistant REST API + WebSocket API
  - Flutter: https://flutter.dev (free, cross-platform)
  - HA REST API: https://developers.home-assistant.io/docs/api/rest/
  - HA WebSocket API: https://developers.home-assistant.io/docs/api/websocket/

### 6. Remote Access (Free Options)
| Method | Cost | Setup Difficulty |
|--------|------|-----------------|
| Tailscale VPN | Free (personal) | Easy |
| WireGuard VPN | Free | Medium |
| Cloudflare Tunnel | Free | Medium |
| Nabu Casa (HA Cloud) | ~₹550/mo | Easiest |

---

## 🔧 PART 2: HARDWARE — Complete Shopping List

### A. Central Hub — Raspberry Pi

| Item | Price (₹) | Where to Buy |
|------|-----------|--------------|
| **Raspberry Pi 4 Model B 4GB** (recommended) | ₹5,200-5,800 | [Amazon.in](https://www.amazon.in/raspberry-pi-4-model-b-4gb/s?k=raspberry+pi+4+model+b+4gb) |
| Raspberry Pi 4 8GB (overkill but future-proof) | ₹6,500-7,500 | [Amazon.in](https://www.amazon.in/Raspberry-Pi-Cortex-A72-Computer-RPI4-MODBP-8GB/dp/B0899VXM8F) |
| Raspberry Pi 5 4GB (latest) | ₹5,500-6,500 | [ThinkRobotics](https://thinkrobotics.com/collections/buy-raspberry-pi-online) |
| 32GB microSD Card (SanDisk) | ₹350-450 | Amazon.in |
| RPi 4 Power Supply (USB-C 5V 3A) | ₹400-500 | Amazon.in |
| RPi Case with Fan | ₹300-500 | Amazon.in |

**💡 Recommendation:** Raspberry Pi 4 4GB — sweet spot for Home Assistant

---

### B. Smart Switches — ESP32 Relay Boards (Lights, Fans, Appliances)

| Item | Price (₹) | Where to Buy |
|------|-----------|--------------|
| **ESP32 4-Channel Relay Board** (Easy Electronics) | ₹800-1,200 | [Amazon.in](https://www.amazon.in/Electronics-ESP32-Controller-Electronic-WiFi/dp/B0BXP671TL) |
| ESP32 4-Channel Relay (DORHEA, 2-pack) | ₹1,500-2,000 | [Amazon.in](https://www.amazon.in/DORHEA-ESP32-WROOM-32E-Development-Controller-Wireless/dp/B0DF2P197J) |
| ESP32 WROVER 4-Channel Relay | ₹900-1,400 | [Amazon.in](https://www.amazon.in/ESP32-WROVER-4-Channel-Relay-Module/dp/B0D78SRXLP) |
| ESP32 4-Channel WiFi Relay (Hexatech) | ₹800-1,100 | [Flipkart](https://www.flipkart.com/hexatech-esp32-4-channel-wifi-relay-board-electronic-components-hobby-kit/p/itm1ba110d40f56b) |
| 4-Way AC/DC ESP32 Relay (NeoGiga) | ₹900-1,300 | [NeoGiga.in](https://www.neogiga.in/product/4-way-ac-dc-esp32-wifi-bluetooth-relay-module-esp32-wroom-32/) |
| 1-Channel Relay Module (for single switch) | ₹100-190 | [Amazon.in](https://www.amazon.in/relay-module-for-esp32/s?k=relay+module+for+esp32) |

**💡 How many needed:** 1 board per room (each board controls 4 devices). Estimate:
- Living room: 1 board (2 lights + fan + TV plug) 
- Bedroom x2: 2 boards
- Kitchen: 1 board
- **Total: ~4-5 boards ≈ ₹4,000-6,000**

---

### C. AC Control — IR Blaster

| Item | Price (₹) | Where to Buy |
|------|-----------|--------------|
| **IR Transmitter LED (940nm)** | ₹10-20 each | Amazon.in / Robocraze |
| **IR Receiver Module (TSOP1738)** | ₹30-50 | Amazon.in |
| ESP32 Dev Board (separate if not using relay board) | ₹350-500 | Amazon.in |

**💡 How it works:** ESP32 + IR LED learns your AC remote codes → ESPHome sends IR signals → controls AC from phone. Works with ALL brands (Daikin, Voltas, LG, etc.)

**Open Source Library:** 
- IRremoteESP8266: https://github.com/crankyoldgit/IRremoteESP8266
- ESPHome Climate IR: https://esphome.io/components/climate/ir_climate.html

---

### D. Smart Door Lock System

| Item | Price (₹) | Where to Buy |
|------|-----------|--------------|
| **12V Solenoid Door Lock** | ₹250-500 | [Amazon.in](https://www.amazon.in/DC-12V-Solenoid-Door-Lock/dp/B0998M415X) |
| 12V Solenoid Lock (Robodo) | ₹300-450 | [Amazon.in](https://www.amazon.in/Robodo-Electronics-SLNDLTCH12-Assembly-Consumption/dp/B07B918RK9) |
| 12V Solenoid Lock (Robocraze) | ₹400-600 | [Flipkart](https://www.flipkart.com/robocraze-12v-dc-solenoid-electric-door-lock-automotive-electronic-hobby-kit/p/itm99d0742384c91) |
| ESP32 (to control lock) | ₹350-500 | Amazon.in |
| 1-Channel Relay Module | ₹100-190 | Amazon.in |
| 12V 2A Power Supply | ₹200-300 | Amazon.in |
| RFID RC522 Module (optional keycard) | ₹120-200 | Amazon.in |
| Numeric Keypad 4x4 (optional PIN) | ₹80-150 | Amazon.in |

**💡 Total for smart lock: ₹1,000-1,700**

---

### E. Video Doorbell — ESP32-CAM

| Item | Price (₹) | Where to Buy |
|------|-----------|--------------|
| **ESP32-CAM with OV2640** | ₹450-700 | [Amazon.in](https://www.amazon.in/FlyRobo-ESP32-Based-Recognition-System/dp/B0DDTJJ4YG) / [LearnElectronics](https://www.learnelectronicsindia.com/product-page/esp32-cam-with-ov2640-camera) |
| ESP32-CAM Face Recognition Door Lock Kit (complete) | ₹1,200-1,800 | [FlyRobo](https://www.flyrobo.in/esp32-cam-based-face-recognition-door-lock-system-stem-diy-kit) / [Iyzer](https://iyzer.in/product/esp32-cam-face-detection-door-lock-system-kit/) |
| Push Button (doorbell trigger) | ₹10-20 | Amazon.in |
| Buzzer Module | ₹30-50 | Amazon.in |
| USB-FTDI Programmer (for initial flash) | ₹200-350 | Amazon.in |
| Weatherproof Case (3D print or buy) | ₹100-300 | Amazon.in |

**💡 Features you get:**
- Live video streaming to phone
- Motion detection alerts
- Face recognition (built into ESP32-CAM)
- Telegram notifications when someone rings
- Two-way audio (with I2S mic + speaker add-on ~₹200)

**Open Source Projects:**
- ESP32-CAM Doorbell: https://github.com/mtekman/doorbell-camera
- Zbotic Guide: https://zbotic.in/diy-smart-doorbell-esp32-cam-with-telegram-notification/

---

### F. Sensors (Add-ons I Recommend)

| Item | Purpose | Price (₹) | Where to Buy |
|------|---------|-----------|--------------|
| **DHT22 Temp+Humidity Sensor** | Room climate monitoring | ₹149-250 | [Robocraze](https://robocraze.com/products/dht22-temperature-sensor) / [Amazon.in](https://www.amazon.in/dht22-sensor/s?k=dht22+sensor) |
| **PIR Motion Sensor (HC-SR501)** | Auto-lights when you enter room | ₹60-100 | Amazon.in |
| **RCWL-0516 Radar Sensor** | Better motion detection (through walls) | ₹45-80 | [IndiaMART](https://www.indiamart.com/proddetail/rcwl0516-microwave-radar-sensor-21830037748.html) / Amazon.in |
| **MQ-2 Gas/Smoke Sensor** | Kitchen safety — gas leak alert | ₹80-150 | Amazon.in |
| **MQ-135 Air Quality Sensor** | Air quality monitoring | ₹100-180 | Amazon.in |
| **Water Leak Sensor** | Bathroom/kitchen flood detection | ₹50-100 | Amazon.in |
| **LDR Light Sensor Module** | Auto-brightness adjustment | ₹20-40 | Amazon.in |
| **Reed Switch (Magnetic)** | Door/window open/close detection | ₹30-60 | Amazon.in |
| **BMP280 Pressure Sensor** | Weather station add-on | ₹100-180 | Amazon.in |

---

### G. Fan Speed Control (Ceiling Fan Regulator)

| Item | Price (₹) | Where to Buy |
|------|-----------|--------------|
| **BTA16 TRIAC Module** | ₹80-150 | Amazon.in |
| **MOC3021 Optocoupler** | ₹20-30 | Amazon.in |
| Zero-Cross Detection Module | ₹50-80 | Amazon.in |

**💡 This lets you control ceiling fan speed (not just on/off) from your phone using AC dimming via TRIAC.**

---

## 💰 TOTAL BUDGET ESTIMATE

| Category | Items | Cost (₹) |
|----------|-------|----------|
| Raspberry Pi 4 4GB + accessories | Hub | ₹6,500 |
| ESP32 Relay Boards (×5 rooms) | Switches | ₹5,000 |
| ESP32 IR Blasters (×2 ACs) | AC Control | ₹800 |
| Solenoid Lock + ESP32 + Relay | Smart Lock | ₹1,500 |
| ESP32-CAM + accessories | Video Doorbell | ₹1,200 |
| Sensors pack (DHT22, PIR, Gas, etc.) | Safety & Comfort | ₹1,500 |
| Fan speed controllers (×3) | Fan Dimming | ₹500 |
| Wires, connectors, power supplies | Misc | ₹2,000 |
| **TOTAL** | | **₹19,000** |

**Compare to commercial:** Equivalent Alexa/Google smart home setup = ₹50,000-80,000+
**Your savings: 60-75%** and you own the code!

---

## 🔌 PART 3: KEY OPEN SOURCE LIBRARIES

| Library | Purpose | GitHub |
|---------|---------|--------|
| **ESPHome** | ESP32 firmware (YAML config) | https://github.com/esphome/esphome |
| **Home Assistant** | Central automation hub | https://github.com/home-assistant/core |
| **IRremoteESP8266** | IR codes for AC/TV control | https://github.com/crankyoldgit/IRremoteESP8266 |
| **Arduino-ESP32** | ESP32 Arduino framework | https://github.com/espressif/arduino-esp32 |
| **Frigate** | Camera NVR with AI detection | https://github.com/blakeblackshear/frigate |
| **Mosquitto** | MQTT message broker | https://github.com/eclipse/mosquitto |
| **ESP32-Camera** | Camera driver library | https://github.com/espressif/esp32-camera |
| **Tasmota** | Alternative ESP firmware | https://github.com/arendst/Tasmota |
| **WLED** | LED strip controller | https://github.com/Aircoookie/WLED |
| **Zigbee2MQTT** | Zigbee device support | https://github.com/Koenkk/zigbee2mqtt |

---

## 🎯 BONUS ADD-ONS I RECOMMEND

### 1. 🌈 Smart LED Strip Lighting
- WS2812B LED Strip (5m, 60 LED/m): ₹800-1,200 on Amazon.in
- Flash ESP32 with **WLED** firmware → gorgeous room lighting effects
- Control from Home Assistant or dedicated WLED app

### 2. 🔊 Voice Control (Free, Local)
- USB Microphone (~₹300) + Raspberry Pi
- **Piper TTS** + **Whisper STT** (open source, runs locally)
- No Alexa/Google needed — your own voice assistant!

### 3. 📊 Energy Monitoring
- PZEM-004T Energy Meter Module: ₹400-600 on Amazon.in
- Monitor real-time power consumption per room
- Dashboard in Home Assistant

### 4. 🚿 Smart Geyser Control
- ESP32 + Relay + DHT22 = auto turn off geyser when water reaches set temp
- Schedule-based: auto-on at 6 AM, auto-off at 7 AM

### 5. 🌱 Garden/Balcony Automation
- Soil Moisture Sensor: ₹50-80
- Submersible Water Pump (5V): ₹150-250
- Auto-water plants when soil is dry

---

## 📱 REMOTE ACCESS SETUP (Access from Anywhere)

Since you want mobile app control from anywhere:

**Recommended: Tailscale (Free)**
1. Install Tailscale on Raspberry Pi
2. Install Tailscale on your phone
3. Both devices join your private encrypted network
4. Access Home Assistant from anywhere as if you're on home WiFi
5. Zero port forwarding, zero security risk

**Alternative: Cloudflare Tunnel (Free)**
1. Create Cloudflare account
2. Install cloudflared on Raspberry Pi
3. Map your Home Assistant to a custom domain
4. Access via https://home.yourdomain.com

---

## 📋 IMPLEMENTATION ORDER

1. **Week 1:** Buy Raspberry Pi → Install Home Assistant
2. **Week 2:** Buy 1-2 ESP32 relay boards → Set up 1 room (living room)
3. **Week 3:** Set up IR blaster for AC control
4. **Week 4:** Build video doorbell (ESP32-CAM)
5. **Week 5:** Install smart lock + sensors
6. **Week 6:** Expand to all rooms + add automations
7. **Week 7:** Set up remote access + polish mobile app

---

## 🛒 QUICK BUY LINKS (India)

**Recommended Stores:**
- **Amazon.in** — https://www.amazon.in (widest selection, fast delivery)
- **Flipkart** — https://www.flipkart.com
- **Robocraze** — https://robocraze.com (specialized electronics, good prices)
- **ThinkRobotics** — https://thinkrobotics.com (authorized RPi distributor)
- **Robu.in** — https://robu.in (electronics components)
- **NeoGiga** — https://www.neogiga.in (ESP32 modules)
- **Zbotic** — https://zbotic.in (great DIY guides + components)
- **FlyRobo** — https://www.flyrobo.in (kits and modules)
- **Probots** — https://probots.co.in (sensors and modules)
