# ⚡ QUICK START — 5 Minutes to Smart Home

**Get your smart home running in 5 minutes!**

---

## 🎯 What You'll Get

After 5 minutes:
- ✅ Home Assistant dashboard (27 virtual devices)
- ✅ Mobile app access from your phone
- ✅ 5 pre-configured automations
- ✅ Temperature, humidity, and gas sensors
- ✅ Smart door lock with auto-lock
- ✅ Gas leak alerts

**No hardware needed yet** — everything runs virtually for testing!

---

## 📋 Prerequisites

- ✅ Ubuntu server (your AWS EC2)
- ✅ Docker installed
- ✅ 2GB RAM minimum
- ✅ Ports 8503, 8504, 1883 available

---

## 🚀 Step 1: Navigate to Project (30 seconds)

```bash
cd /home/ubuntu/.openclaw/workspace-nexus/home-automation
```

---

## ⚙️ Step 2: Configure Your Server IP (1 minute)

```bash
# Edit configuration
nano homeassistant/configuration.yaml
```

**Find line 10 and change IP:**
```yaml
external_url: "http://YOUR_SERVER_IP:8503"  # ← Change to YOUR server IP
```

**Save:** `Ctrl+X` → `Y` → `Enter`

---

## 🔥 Step 3: Open Firewall Ports (1 minute)

```bash
# Allow Home Assistant port
sudo ufw allow 8503/tcp

# Allow ESPHome port
sudo ufw allow 8504/tcp

# Allow MQTT port
sudo ufw allow 1883/tcp

# Check firewall status
sudo ufw status
```

**⚠️ AWS EC2 Users:** Also add these ports in **EC2 Security Groups**:
1. Go to AWS Console → EC2 → Security Groups
2. Select your instance's security group
3. **Add Inbound Rules:**
   - Port 8503 (Custom TCP) - Source: 0.0.0.0/0
   - Port 8504 (Custom TCP) - Source: 0.0.0.0/0
   - Port 1883 (Custom TCP) - Source: 0.0.0.0/0

---

## 🚀 Step 4: Start Everything (2 minutes)

```bash
# Make scripts executable
chmod +x *.sh

# Start all services
./start.sh
```

**What this does:**
1. Checks Docker is running
2. Verifies ports are available
3. Pulls latest images (Home Assistant, ESPHome, Mosquitto)
4. Starts 3 Docker containers
5. Waits for services to be ready
6. Shows access URLs

**Wait for:** "✅ Smart Home Automation is RUNNING!"

---

## 🌐 Step 5: Access Dashboard (30 seconds)

Open in your browser:
```
http://YOUR_SERVER_IP:8503
```
*(Replace with YOUR server IP)*

**First-time setup wizard:**
1. **Create admin account**
   - Name: Your name
   - Username: `admin`
   - Password: (strong password!)
2. **Location**
   - Set home location on map
   - Timezone: Asia/Kolkata (or yours)
   - Unit: Metric
   - Currency: INR
3. **Analytics:** Choose No (recommended)
4. Click **"FINISH"**

**🎉 Dashboard loads with 27 devices!**

---

## 📱 Step 6: Configure MQTT (30 seconds)

In Home Assistant:
1. **Settings** (sidebar) → **Devices & Services**
2. Click **"+ ADD INTEGRATION"** (bottom right)
3. Search: **"MQTT"**
4. Enter:
   - Broker: `mosquitto`
   - Port: `1883`
   - Username: *(leave blank)*
   - Password: *(leave blank)*
5. Click **SUBMIT**

✅ **MQTT connected!**

---

## 🎮 Step 7: Control Your First Device (10 seconds)

On the dashboard:
1. Find **"Living Room Main Light"**
2. Click the toggle
3. **Watch it turn on!** 💡

**Try these:**
- Toggle **Living Room Fan**
- Lock/unlock **Front Door**
- Check **Living Room Temperature**
- Toggle **Kitchen Light**

---

## 📱 Mobile App Setup (2 minutes)

### Android:
1. Open **Play Store**
2. Search **"Home Assistant"**
3. Install (FREE, by Home Assistant)
4. Open app → **"Enter server address"**
5. Enter: `http://YOUR_IP:8503`
6. Login with your username/password
7. **Done!** Control from your phone 📱

### iOS:
1. Open **App Store**
2. Search **"Home Assistant"**
3. Install (FREE)
4. Same steps as Android above

---

## 🎯 What's Pre-Configured?

### 27 Devices Ready to Control:
- **5 rooms** (Living, Bedroom 1-3, Kitchen)
- **Lights** (main, accent, night lamps)
- **Fans** (ceiling fans with on/off)
- **Appliances** (TV, geyser, exhaust)
- **Door lock** (front door with auto-lock)
- **Outdoor** (porch, balcony, corridor lights)

### 8 Sensors:
- Temperature (living room, bedrooms, kitchen)
- Humidity (3 sensors)
- Gas detector (kitchen)
- Motion sensors (4 zones)
- Door/window sensors (front door, kitchen window)
- Video doorbell (ready for ESP32-CAM)

### 5 Smart Automations:
1. **Gas Leak Alert** — Notification if gas > 200 ppm
2. **Auto Geyser Off** — Turns off after 30 minutes
3. **Night Mode (11 PM)** — Turns off all main lights
4. **Auto Door Lock** — Locks door after 30 seconds unlocked
5. **Morning Routine (6:30 AM)** — Turns on kitchen & corridor lights

---

## 🔧 Useful Commands

```bash
# Check status
./status.sh

# View logs
docker-compose logs -f

# Restart everything
./restart.sh

# Stop everything
./stop.sh

# Create backup
./backup.sh

# Restore from backup
./restore.sh backups/home-automation_backup_XXXXXX.tar.gz
```

---

## 🎨 Customize Your Dashboard

In Home Assistant:
1. Click **⋮ menu** (top right)
2. **"Edit Dashboard"**
3. **"+ ADD CARD"** to add new cards
4. **Drag cards** to rearrange
5. Click card → **"⋮"** → **"Edit"** to customize
6. **Done** when finished

**Card Types:**
- **Entities** — List multiple devices
- **Thermostat** — Climate control
- **Button** — Single device control
- **Gauge** — Sensor value with dial
- **Picture Entity** — Camera feed
- **Map** — Location tracking

---

## ✨ Next Steps

### Add More Devices
Edit `homeassistant/configuration.yaml`:
```yaml
input_boolean:
  my_new_device:
    name: My New Device
    icon: mdi:lightbulb
```

Restart: `./restart.sh`

### Create Automations
**Settings → Automations & Scenes → "+ CREATE AUTOMATION"**

**Example: Motion-activated light**
- Trigger: Living Room Motion → On
- Condition: After sunset
- Action: Turn on Living Room Light
- Add delay: 5 minutes
- Action: Turn off Living Room Light

### Buy Hardware (See RESEARCH.md)
When ready for real hardware:
1. **Order ESP32 relay boards** (₹800-1,200 each)
2. **Flash with ESPHome** (uses `esphome/living-room-board.yaml`)
3. **Wire to switches** (see README.md Hardware Setup)
4. **Auto-discovers** in Home Assistant!

---

## 🐛 Troubleshooting

### Can't access http://YOUR_IP:8503
```bash
# Check service is running
docker-compose ps

# Check port is open
sudo netstat -tulpn | grep 8503

# Check firewall
sudo ufw status

# View logs
docker-compose logs homeassistant
```

### Services won't start
```bash
# Check ports aren't in use
sudo fuser -k 8503/tcp
sudo fuser -k 8504/tcp
sudo fuser -k 1883/tcp

# Restart
./start.sh
```

### Forgot admin password
```bash
# Stop services
./stop.sh

# Remove auth file
rm homeassistant/.storage/auth

# Restart (creates new admin account)
./start.sh
```

---

## 📚 Full Documentation

- **README.md** — Complete setup guide
- **RESEARCH.md** — Hardware buying guide (₹19,000 total)
- **homeassistant/configuration.yaml** — All device configs
- **esphome/living-room-board.yaml** — ESP32 firmware template

---

## 🎉 Success!

You now have:
- ✅ **Smart home dashboard** running
- ✅ **27 devices** ready to control
- ✅ **5 automations** active
- ✅ **Mobile app** connected
- ✅ **MQTT broker** for ESP32 devices
- ✅ **Backup system** ready

**Total time:** 5 minutes ⚡

**Next:** Order hardware from **RESEARCH.md** → Flash ESP32 → Wire first room → Go live! 🚀

---

**Questions?**  
Read **README.md** for detailed docs or ask Nexus!

**Built by:** Nexus AI Agent  
**For:** Aniket  
**Date:** May 2026
