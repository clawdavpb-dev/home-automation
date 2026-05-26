# 🏠 Smart Home Automation System
**Comprehensive Open-Source Home Automation**  
Built with Home Assistant + ESPHome + MQTT

---

## 📋 Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Requirements](#requirements)
4. [Quick Start](#quick-start)
5. [Detailed Setup](#detailed-setup)
6. [Hardware Setup](#hardware-setup)
7. [Configuration](#configuration)
8. [Troubleshooting](#troubleshooting)
9. [Mobile App Access](#mobile-app-access)
10. [Security](#security)

---

## 🎯 Overview

This is a **complete, production-ready home automation system** that controls:
- ✅ **27 devices** (lights, fans, appliances, AC, geyser, lock)
- ✅ **8 sensors** (temperature, humidity, gas, motion, door/window)
- ✅ **Smart door lock** with auto-lock
- ✅ **Video doorbell** (ESP32-CAM ready)
- ✅ **Automated routines** (morning, night, safety alerts)
- ✅ **Mobile app control** from anywhere

**Cost:** ~₹19,000 hardware + ₹0 software (100% open source)

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────┐
│         YOUR PHONE (Anywhere)                │
│    Home Assistant Mobile App (FREE)          │
└──────────────────┬───────────────────────────┘
                   │ (Internet / VPN)
┌──────────────────▼───────────────────────────┐
│        THIS SERVER (Docker Containers)       │
│  ┌────────────────────────────────────────┐  │
│  │  Home Assistant (Port 8503)            │  │
│  │  + ESPHome (Port 8504)                 │  │
│  │  + Mosquitto MQTT (Port 1883)          │  │
│  └────────────────────────────────────────┘  │
└──────────────────┬───────────────────────────┘
                   │ WiFi / MQTT
    ┌──────────────┼──────────────────┐
    │              │                  │
┌───▼────┐   ┌─────▼─────┐   ┌───────▼────────┐
│ESP32    │   │ESP32-CAM  │   │ESP32 + IR      │
│Relay    │   │Video      │   │AC Controller   │
│Boards   │   │Doorbell   │   │+ Sensors       │
└─────────┘   └───────────┘   └────────────────┘
(5 boards)    (Lock + Video)  (Temp/Gas/Motion)
```

---

## 📦 Requirements

### Software (Pre-installed)
- ✅ Docker & Docker Compose
- ✅ Port 8503 available (Home Assistant dashboard)
- ✅ Port 8504 available (ESPHome dashboard)
- ✅ Port 1883 available (MQTT broker)

### Hardware (Future, see RESEARCH.md for buying guide)
- **Raspberry Pi 4 4GB** OR any server with Docker (you're using AWS EC2 ✅)
- **5× ESP32 4-Channel Relay Boards** (~₹5,000)
- **1× ESP32-CAM** for video doorbell (~₹700)
- **1× Solenoid Lock** (~₹500)
- **Sensors pack** (DHT22, PIR, Gas detector ~₹1,500)
- **Total:** ~₹19,000

**RIGHT NOW:** You can run everything in **VIRTUAL MODE** (no hardware) to test the system!

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Clone This Repo (if not already on server)
```bash
cd /home/ubuntu/.openclaw/workspace-nexus
# (already here!)
```

### Step 2: Configure Your Details
```bash
cd home-automation

# Edit docker-compose.yml — change timezone if needed
nano docker-compose.yml
# (Currently set to Asia/Kolkata)

# Edit homeassistant/configuration.yaml — change external URL
nano homeassistant/configuration.yaml
# Change external_url to your server IP: http://YOUR_IP:8503
```

### Step 3: Start Everything
```bash
# Make startup script executable
chmod +x start.sh

# Start all services
./start.sh
```

### Step 4: Access the Dashboard
Open in browser:
```
http://YOUR_SERVER_IP:8503
```

**First-time setup:**
1. Create admin account (username + password)
2. Click through the onboarding wizard
3. Dashboard loads with **27 virtual devices** ready to control!

---

## 📖 Detailed Setup

### Directory Structure
```
home-automation/
├── README.md                    ← YOU ARE HERE
├── RESEARCH.md                  ← Hardware buying guide
├── docker-compose.yml           ← All 3 services
├── start.sh                     ← Quick start script
├── stop.sh                      ← Stop all services
├── backup.sh                    ← Backup config
├── restore.sh                   ← Restore from backup
├── homeassistant/
│   ├── configuration.yaml       ← Main config (27 devices)
│   ├── automations.yaml         ← Auto-lock, gas alert, etc.
│   ├── scripts.yaml             ← Reusable actions
│   ├── scenes.yaml              ← Preset device states
│   ├── secrets.yaml             ← Passwords (gitignored)
│   └── ui-lovelace.yaml         ← Dashboard layout
├── esphome/
│   └── living-room-board.yaml   ← ESP32 firmware template
└── mosquitto/
    ├── config/mosquitto.conf    ← MQTT broker config
    ├── data/                    ← Message persistence
    └── log/                     ← MQTT logs
```

---

## 🔧 Detailed Setup Steps

### 1. Pre-Flight Checks
```bash
# Check Docker is running
docker --version
docker-compose --version

# Check required ports are free
sudo netstat -tulpn | grep -E '8503|8504|1883'
# (Should return nothing)

# If ports are in use, stop conflicting services
sudo fuser -k 8503/tcp  # Kill process on port 8503
sudo fuser -k 8504/tcp
sudo fuser -k 1883/tcp
```

### 2. Configure Firewall (AWS EC2 Security Group)
```bash
# Allow Home Assistant port
sudo ufw allow 8503/tcp
sudo ufw allow 8504/tcp
sudo ufw allow 1883/tcp
sudo ufw status
```

**AWS EC2 Console:**
1. Go to **EC2 → Security Groups**
2. Find your instance's security group
3. Add inbound rules:
   - Port 8503 (Home Assistant)
   - Port 8504 (ESPHome)
   - Port 1883 (MQTT)

### 3. Customize Configuration

#### A. Set Your Server IP
```bash
nano homeassistant/configuration.yaml
```
Change line 10:
```yaml
external_url: "http://YOUR_SERVER_IP:8503"
```

#### B. Set WiFi for ESP32 (when hardware arrives)
```bash
nano esphome/living-room-board.yaml
```
Change lines 14-15:
```yaml
wifi:
  ssid: "YOUR_WIFI_NAME"
  password: "YOUR_WIFI_PASSWORD"
```

#### C. Set MQTT Broker IP (when hardware arrives)
Change line 35:
```yaml
mqtt:
  broker: "YOUR_HA_SERVER_IP"
```

### 4. Start Services
```bash
# Start in foreground (see logs)
docker-compose up

# OR start in background
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f homeassistant
docker-compose logs -f mosquitto
docker-compose logs -f esphome
```

### 5. First-Time Home Assistant Setup
1. Open `http://YOUR_IP:8503` in browser
2. **Create admin user:**
   - Name: Your name
   - Username: `admin`
   - Password: (strong password)
   - Confirm password
3. **Location setup:**
   - Set your home location on map
   - Timezone: Asia/Kolkata (or yours)
   - Unit system: Metric
   - Currency: INR
4. **Anonymous analytics:** Choose (I recommend "No")
5. Click "NEXT" → "FINISH"

### 6. Configure MQTT Integration
1. In Home Assistant, go to **Settings → Devices & Services**
2. Click **"+ ADD INTEGRATION"**
3. Search for **"MQTT"**
4. Enter:
   - Broker: `mosquitto`
   - Port: `1883`
   - Username: (leave blank)
   - Password: (leave blank)
5. Click **SUBMIT**
6. MQTT integration now active!

---

## 🔌 Hardware Setup (When Your ESP32 Boards Arrive)

### A. Flash ESP32 with ESPHome

#### Method 1: ESPHome Dashboard (Easiest)
1. Open `http://YOUR_IP:8504` (ESPHome dashboard)
2. Click **"+ NEW DEVICE"**
3. Give it a name: `living-room-board`
4. Click **"INSTALL"** → **"Plug into this computer"**
5. Connect ESP32 via USB
6. Select serial port
7. Wait for flash to complete (~2 minutes)
8. **Done!** Board auto-discovers in Home Assistant

#### Method 2: ESPHome CLI
```bash
# Install ESPHome CLI
pip3 install esphome

# Flash board
cd home-automation/esphome
esphome run living-room-board.yaml

# Select USB port when prompted
# Wait for flash complete
```

### B. Wire ESP32 Relay Board to Switches

**⚠️ WARNING: HIGH VOLTAGE! Turn off mains before wiring!**

**Tools needed:**
- Screwdriver
- Wire stripper
- Multimeter (test for 0V before touching!)

**Wiring diagram for 1 relay:**
```
Wall Switch Box                    ESP32 Relay Board
┌──────────────┐                  ┌─────────────────┐
│              │                  │  Relay 1        │
│  Phase (L) ──┼──────────────────┼─► COM           │
│              │                  │                 │
│  Neutral(N)──┼──────────────────┼─► (not used)    │
│              │                  │                 │
│  Light ──────┼──────────────────┼─► NO (normally  │
│              │                  │    open)        │
└──────────────┘                  └─────────────────┘

Power for ESP32:
- 5V DC adapter (micro-USB or 5V pin)
```

**Steps:**
1. **Turn OFF main circuit breaker**
2. **Test voltage = 0V** with multimeter
3. Open existing switch box
4. Connect:
   - Phase wire (L) → Relay COM
   - Light wire → Relay NO
   - Neutral → Direct to light (or use NC for reverse logic)
5. Power ESP32 with 5V adapter
6. Close switch box
7. Turn ON main breaker
8. Test in Home Assistant app!

**Repeat for all 4 relays on the board.**

### C. Install ESP32-CAM Video Doorbell

**Hardware needed:**
- ESP32-CAM module
- Push button (doorbell trigger)
- 5V power supply
- Weatherproof case

**Wiring:**
```
ESP32-CAM
├─ 5V  ← 5V power supply (+)
├─ GND ← Power supply (-) + Button (one side)
├─ GPIO13 ← Button (other side)
└─ Camera ← Already attached
```

**Flash firmware:**
```bash
# Use ESPHome dashboard or CLI
cd home-automation/esphome
nano doorbell.yaml
```

**Create `doorbell.yaml`:**
```yaml
esphome:
  name: doorbell-cam

esp32:
  board: esp32cam

wifi:
  ssid: "YOUR_WIFI"
  password: "YOUR_PASSWORD"

api:
  encryption:
    key: "YOUR_ENCRYPTION_KEY"

ota:
  password: "ota_password"

camera:
  - platform: esp32_camera
    name: "Front Door Camera"
    id: cam

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO13
      mode: INPUT_PULLUP
      inverted: true
    name: "Doorbell Button"
    on_press:
      - homeassistant.event:
          event: esphome.doorbell_pressed
```

**Mount at front door:**
1. Flash ESP32-CAM
2. Mount in weatherproof case
3. Wire doorbell button
4. Power via 5V adapter
5. Add to Home Assistant (auto-discovers)
6. Live video feed appears in dashboard!

### D. Smart Lock Installation

**Hardware:**
- Solenoid door lock (12V)
- ESP32 board
- 1-channel relay module
- 12V 2A power supply

**Wiring:**
```
12V Power → Relay COM
Relay NO → Solenoid (+)
Solenoid (-) → Ground
ESP32 GPIO → Relay IN
```

**Add to ESPHome config:**
```yaml
switch:
  - platform: gpio
    pin: GPIO21
    name: "Front Door Lock"
    id: door_lock
    icon: "mdi:lock"
```

---

## ⚙️ Configuration

### Adding More Rooms

**Copy template:**
```bash
cd esphome
cp living-room-board.yaml bedroom1-board.yaml
nano bedroom1-board.yaml
```

**Change device name:**
```yaml
esphome:
  name: bedroom1-board  # Change this
  friendly_name: "Bedroom 1 Board"  # And this
```

**Change switch names:**
```yaml
switch:
  - platform: gpio
    pin: GPIO16
    name: "Bedroom 1 Main Light"  # Update names
```

**Flash new board → Auto-discovers in HA!**

### Creating Automations

**Via Home Assistant UI:**
1. **Settings → Automations & Scenes**
2. **"+ CREATE AUTOMATION"**
3. **Choose trigger:**
   - Time (7:00 AM)
   - Device state change
   - Sensor threshold
   - Motion detected
4. **Choose action:**
   - Turn on/off device
   - Send notification
   - Call service
5. **Save**

**Example: Motion-activated light**
```yaml
# automations.yaml
- alias: "Living Room Auto Light"
  trigger:
    - platform: state
      entity_id: binary_sensor.living_room_motion
      to: "on"
  condition:
    - condition: sun
      after: sunset
  action:
    - service: input_boolean.turn_on
      target:
        entity_id: input_boolean.living_room_light_1
    - delay: "00:05:00"  # 5 minutes
    - service: input_boolean.turn_off
      target:
        entity_id: input_boolean.living_room_light_1
```

### Dashboard Customization

**Edit UI:**
1. Home Assistant → Click top-right **⋮ menu**
2. **"Edit Dashboard"**
3. **"+ ADD CARD"**
4. Choose card type:
   - **Entities** (list of devices)
   - **Thermostat** (climate control)
   - **Picture Entity** (camera feed)
   - **Gauge** (sensor value)
   - **Button** (single device)
5. Drag to rearrange
6. Click **DONE**

---

## 🐛 Troubleshooting

### Home Assistant won't start
```bash
# Check logs
docker-compose logs homeassistant

# Common fix: permission issue
sudo chown -R 1000:1000 homeassistant/

# Restart
docker-compose restart homeassistant
```

### Can't access dashboard
```bash
# Check port is open
sudo netstat -tulpn | grep 8503

# Check firewall
sudo ufw status

# Allow port
sudo ufw allow 8503/tcp

# Check AWS Security Group allows port 8503
```

### MQTT not connecting
```bash
# Check Mosquitto logs
docker-compose logs mosquitto

# Test MQTT locally
sudo apt-get install mosquitto-clients
mosquitto_pub -h localhost -t test -m "hello"
mosquitto_sub -h localhost -t test
```

### ESP32 won't connect to WiFi
1. **Check WiFi credentials** in `esphome/your-board.yaml`
2. **Check WiFi is 2.4GHz** (ESP32 doesn't support 5GHz)
3. **Re-flash firmware** with correct SSID/password
4. **Check router allows device** (MAC filtering off)

### Devices not appearing in Home Assistant
1. **Settings → Devices & Services → ESPHome**
2. Should see all ESP32 boards listed
3. If missing, check **Integration → + ADD INTEGRATION → ESPHome**
4. Enter ESP32 IP address manually

---

## 📱 Mobile App Access

### Option 1: Home Assistant Companion App (Recommended)
1. Download **Home Assistant** app (FREE)
   - Android: https://play.google.com/store/apps/details?id=io.homeassistant.companion.android
   - iOS: https://apps.apple.com/app/home-assistant/id1099568401
2. Open app → **"Enter server address"**
3. Enter: `http://YOUR_SERVER_IP:8503`
4. Login with your username/password
5. **Done!** Control everything from anywhere

### Option 2: Remote Access (From Anywhere)

#### Method A: Tailscale (Free VPN) — Recommended
```bash
# On your server
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# On your phone
1. Install Tailscale app
2. Login with same account
3. Access Home Assistant via Tailscale IP: http://100.x.x.x:8503
```

#### Method B: Cloudflare Tunnel (Free Domain)
```bash
# Install cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Authenticate
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create home
cloudflared tunnel route dns home home.yourdomain.com

# Run tunnel
cloudflared tunnel --url http://localhost:8503 run home
```
Access from anywhere: `https://home.yourdomain.com`

#### Method C: Nabu Casa (Paid, Easiest)
1. In Home Assistant: **Settings → Home Assistant Cloud**
2. **"START 30-DAY TRIAL"** (then ~₹550/mo)
3. Creates `https://YOUR-ID.ui.nabu.casa`
4. Works instantly, no config needed

---

## 🔒 Security Best Practices

### 1. Change Default Passwords
```bash
# Edit secrets.yaml
nano homeassistant/secrets.yaml

# Add:
http_password: "YOUR_STRONG_PASSWORD"
```

**Update configuration.yaml:**
```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.16.0.0/12
  ip_ban_enabled: true
  login_attempts_threshold: 5
```

### 2. Enable HTTPS (Let's Encrypt)
```bash
# In Home Assistant:
# Settings → Add-ons → Add-on Store
# Install "Let's Encrypt" add-on
# Configure with your domain
```

### 3. Network Segmentation
- Put ESP32 devices on **separate VLAN** (guest network)
- Firewall rules: ESP32 → MQTT only, no internet needed

### 4. Regular Backups
```bash
# Manual backup
./backup.sh

# Automated (add to crontab)
crontab -e
# Add: 0 2 * * * /path/to/home-automation/backup.sh
```

### 5. Update Regularly
```bash
# Update containers
docker-compose pull
docker-compose up -d

# Update Home Assistant via UI
# Settings → System → Updates
```

---

## 📊 Monitoring & Logs

### View Live Logs
```bash
# All services
docker-compose logs -f

# Just Home Assistant
docker-compose logs -f homeassistant

# Last 100 lines
docker-compose logs --tail=100 homeassistant
```

### Home Assistant System Info
In UI: **Settings → System → System Information**
- CPU usage
- Memory usage
- Disk space
- Database size

---

## 🎛️ Advanced Features

### 1. Voice Control (Local, Free)
Install **Piper TTS + Whisper STT** add-ons in Home Assistant:
- Settings → Add-ons → Add-on Store
- Search "Piper" → Install
- Search "Whisper" → Install
- Configure with USB microphone
- No Alexa/Google needed!

### 2. Energy Monitoring
Add **PZEM-004T** energy meter to ESP32:
```yaml
# In esphome config
sensor:
  - platform: pzemac
    current:
      name: "Living Room Current"
    voltage:
      name: "Living Room Voltage"
    energy:
      name: "Living Room Energy"
    power:
      name: "Living Room Power"
    frequency:
      name: "Living Room Frequency"
```

### 3. Smart LED Strips (WLED)
Flash ESP32 with WLED firmware:
- https://install.wled.me (web flasher)
- Auto-integrates with Home Assistant
- 100+ effects, music sync, Alexa/Google compatible

### 4. Presence Detection
Use phone app for geofencing:
- Home Assistant app → App Configuration → Location
- Create automation: "When I leave home → turn off all lights"

---

## 🆘 Getting Help

### Official Documentation
- Home Assistant: https://www.home-assistant.io/docs/
- ESPHome: https://esphome.io/
- Mosquitto: https://mosquitto.org/documentation/

### Community Forums
- Home Assistant Community: https://community.home-assistant.io/
- ESPHome Discord: https://discord.gg/KhAMKrd
- Reddit: r/homeassistant

### Debug Mode
Enable detailed logging:
```yaml
# configuration.yaml
logger:
  default: info
  logs:
    homeassistant.core: debug
    homeassistant.components.mqtt: debug
```

---

## 📝 Maintenance Checklist

### Weekly
- [ ] Check Home Assistant updates
- [ ] Review automation logs
- [ ] Test critical automations (door lock, gas alert)

### Monthly
- [ ] Backup configuration
- [ ] Update all Docker containers
- [ ] Check disk space usage
- [ ] Review security logs

### Quarterly
- [ ] Test disaster recovery (restore from backup)
- [ ] Audit user accounts
- [ ] Review sensor battery levels (when using battery sensors)

---

## 🎉 You're All Set!

Your smart home is now:
- ✅ **100% private** (no cloud, no tracking)
- ✅ **Future-proof** (open standards)
- ✅ **Expandable** (add devices anytime)
- ✅ **Cost-effective** (fraction of commercial systems)

**Next steps:**
1. Order hardware from **RESEARCH.md** buying guide
2. Flash ESP32 boards with ESPHome
3. Wire first room (start with 1 board!)
4. Test everything works
5. Expand to all rooms
6. Create custom automations
7. Enjoy your smart home! 🏠✨

---

**Questions?** Ask Nexus or check the official docs!

**Built by:** Nexus (AI Orchestrator Agent)  
**For:** Aniket  
**Date:** May 2026  
**License:** MIT (use freely, modify as needed)
