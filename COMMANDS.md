# ⚡ Quick Command Reference

**Essential commands for managing your smart home system**

---

## 🚀 System Control

```bash
# START everything
./start.sh

# STOP everything
./stop.sh

# RESTART everything
./restart.sh

# CHECK status (health check)
./status.sh
```

---

## 📊 Monitoring

```bash
# View all logs (live)
docker-compose logs -f

# View Home Assistant logs only
docker-compose logs -f homeassistant

# View MQTT logs only
docker-compose logs -f mosquitto

# View ESPHome logs only
docker-compose logs -f esphome

# Last 50 lines
docker-compose logs --tail=50 homeassistant

# Check container status
docker-compose ps

# Check resource usage
docker stats
```

---

## 💾 Backup & Restore

```bash
# CREATE backup (timestamped)
./backup.sh

# LIST backups
ls -lh backups/

# RESTORE from backup
./restore.sh backups/home-automation_backup_20260525_190500.tar.gz
```

---

## 🔧 Configuration

```bash
# Edit main configuration
nano homeassistant/configuration.yaml

# Edit automations
nano homeassistant/automations.yaml

# Edit ESP32 firmware
nano esphome/living-room-board.yaml

# Check configuration is valid (in Home Assistant UI)
# Settings → System → Check Configuration

# Restart after config changes
./restart.sh
```

---

## 🐳 Docker Commands

```bash
# Pull latest images
docker-compose pull

# Update containers (pull + restart)
docker-compose pull && docker-compose up -d

# Stop and remove containers
docker-compose down

# Rebuild containers (after code changes)
docker-compose up -d --build

# Remove old images
docker image prune -a

# Check disk usage
docker system df
```

---

## 🔍 Troubleshooting

```bash
# Check if ports are in use
sudo netstat -tulpn | grep -E '8503|8504|1883'

# Kill process on port
sudo fuser -k 8503/tcp

# Check firewall status
sudo ufw status

# Allow port
sudo ufw allow 8503/tcp

# Test MQTT connection
mosquitto_pub -h localhost -t test -m "hello"
mosquitto_sub -h localhost -t test

# Check Docker is running
docker info

# Restart Docker
sudo systemctl restart docker

# Check service logs
journalctl -u docker -f
```

---

## 🌐 Network Access

```bash
# Get your server IP
hostname -I

# Access URLs
echo "Home Assistant: http://$(hostname -I | awk '{print $1}'):8503"
echo "ESPHome: http://$(hostname -I | awk '{print $1}'):8504"

# Test if services are responding
curl -I http://localhost:8503
curl -I http://localhost:8504

# Check open ports
sudo ss -tulpn
```

---

## 📱 Mobile App Setup

**Android:**
1. Install "Home Assistant" from Play Store (FREE)
2. Open app → Enter server: `http://YOUR_IP:8503`
3. Login with username/password

**iOS:**
1. Install "Home Assistant" from App Store (FREE)
2. Same steps as Android

---

## 🔐 Security

```bash
# Change MQTT password
docker-compose exec mosquitto mosquitto_passwd /mosquitto/config/passwd admin

# Enable MQTT authentication (edit config)
nano mosquitto/config/mosquitto.conf
# Add: allow_anonymous false
# Add: password_file /mosquitto/config/passwd

# Restart MQTT
docker-compose restart mosquitto

# Check fail2ban (if installed)
sudo fail2ban-client status
```

---

## 🚨 Emergency Commands

```bash
# HARD STOP (force kill)
docker-compose kill

# Remove everything (including volumes)
docker-compose down -v

# Reset Home Assistant (CAUTION: deletes all settings!)
rm -rf homeassistant/.storage
./restart.sh

# Restore from latest backup
./restore.sh backups/$(ls -t backups/*.tar.gz | head -1)

# Check disk space (if running out)
df -h
du -sh homeassistant mosquitto esphome
docker system prune -a --volumes
```

---

## 📦 ESPHome (When Hardware Arrives)

```bash
# Access ESPHome dashboard
# Browser: http://YOUR_IP:8504

# Flash ESP32 (via CLI)
esphome run esphome/living-room-board.yaml

# Check ESP32 logs (live)
esphome logs esphome/living-room-board.yaml

# Compile firmware (without uploading)
esphome compile esphome/living-room-board.yaml

# OTA update (wireless, after first flash)
esphome upload esphome/living-room-board.yaml --device 192.168.1.100
```

---

## 🔄 Update System

```bash
# Update Docker images
docker-compose pull

# Update and restart
docker-compose pull && docker-compose up -d

# Check Home Assistant version
docker exec homeassistant ha info

# Update Home Assistant (via UI)
# Settings → System → Updates → Install

# Backup before updating (always!)
./backup.sh
docker-compose pull && docker-compose up -d
```

---

## 📈 Performance

```bash
# Check RAM usage
free -h

# Check CPU usage
top

# Check disk I/O
iostat -x 1

# Docker container stats
docker stats --no-stream

# Home Assistant database size
du -h homeassistant/home-assistant_v2.db

# Reduce database size (via UI)
# Settings → System → Storage → Configure
# Set Purge Keep Days: 3
```

---

## 🎨 Customization

```bash
# Install HACS (Home Assistant Community Store)
# 1. Download HACS
wget -O - https://get.hacs.xyz | bash -

# 2. Restart Home Assistant
./restart.sh

# 3. Add integration (in UI)
# Settings → Devices & Services → + Add Integration → HACS

# Install custom theme
cd homeassistant/themes
git clone https://github.com/basnijholt/lovelace-ios-themes.git
# Settings → Profile → Theme → Select theme

# Edit Lovelace dashboard
# Click ⋮ menu → Edit Dashboard
```

---

## 🔗 Useful Paths

```bash
# Main configuration
homeassistant/configuration.yaml

# Automations
homeassistant/automations.yaml

# Scripts
homeassistant/scripts.yaml

# Scenes
homeassistant/scenes.yaml

# Dashboard
homeassistant/ui-lovelace.yaml

# Secrets (passwords)
homeassistant/secrets.yaml

# Database
homeassistant/home-assistant_v2.db

# Logs
homeassistant/home-assistant.log

# ESPHome configs
esphome/*.yaml

# MQTT config
mosquitto/config/mosquitto.conf

# Backups
backups/
```

---

## 📞 Quick Links

- **Dashboard:** http://YOUR_IP:8503
- **ESPHome:** http://YOUR_IP:8504
- **Docs:** `cat README.md`
- **Quick Start:** `cat QUICKSTART.md`
- **Deployment:** `cat DEPLOYMENT.md`
- **Hardware:** `cat RESEARCH.md`
- **Summary:** `cat PROJECT_SUMMARY.md`

---

## 💡 Pro Tips

```bash
# Alias for quick access (add to ~/.bashrc)
alias ha='cd /home/ubuntu/.openclaw/workspace-nexus/home-automation'
alias ha-start='cd /home/ubuntu/.openclaw/workspace-nexus/home-automation && ./start.sh'
alias ha-stop='cd /home/ubuntu/.openclaw/workspace-nexus/home-automation && ./stop.sh'
alias ha-logs='cd /home/ubuntu/.openclaw/workspace-nexus/home-automation && docker-compose logs -f homeassistant'
alias ha-status='cd /home/ubuntu/.openclaw/workspace-nexus/home-automation && ./status.sh'

# Reload bashrc
source ~/.bashrc

# Now you can just type:
ha          # Go to home automation directory
ha-start    # Start system
ha-stop     # Stop system
ha-logs     # View logs
ha-status   # Check status
```

---

**Keep this file open in a terminal for quick reference!**

```bash
# Keep it handy
cat COMMANDS.md | less
```
