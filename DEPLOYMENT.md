# 🚀 DEPLOYMENT GUIDE
**Deploy Smart Home Automation to Any Server**

---

## 📋 Deployment Checklist

### ☑️ Prerequisites
- [ ] Ubuntu 20.04+ / Debian 11+ / RHEL 8+ (any Linux with Docker support)
- [ ] 2GB RAM minimum (4GB recommended)
- [ ] 10GB free disk space
- [ ] Docker 20.10+ installed
- [ ] Docker Compose 1.29+ installed
- [ ] Root or sudo access
- [ ] Static IP or dynamic DNS (for remote access)

---

## 🖥️ Server Options

### Option 1: AWS EC2 (Current Setup ✅)
**Instance Type:** t3.small or larger  
**OS:** Ubuntu 22.04 LTS  
**Storage:** 20GB GP3  
**Network:** Public IP + Security Group with ports 8503, 8504, 1883 open

### Option 2: Raspberry Pi 4
**Model:** 4GB RAM minimum (8GB recommended)  
**OS:** Raspberry Pi OS 64-bit / Ubuntu Server 22.04  
**Storage:** 32GB microSD (Class 10 or better)  
**Power:** Official 5V 3A USB-C adapter

### Option 3: Home Server / NAS
**Specs:** 2GB RAM, x86_64 or ARM64  
**OS:** Ubuntu Server / Debian  
**Network:** Static LAN IP recommended

### Option 4: VPS (DigitalOcean, Linode, Vultr)
**Plan:** $12-20/mo (2GB RAM)  
**OS:** Ubuntu 22.04  
**Datacenter:** Closest to your location

---

## 📦 Installation Steps

### Step 1: Install Docker
```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (no sudo needed)
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt-get install docker-compose -y

# Verify installation
docker --version
docker-compose --version

# Logout and login for group changes to take effect
```

### Step 2: Clone/Copy Project Files
```bash
# Option A: From this server (if copying to another machine)
cd /home/ubuntu/.openclaw/workspace-nexus
tar -czf home-automation.tar.gz home-automation/
scp home-automation.tar.gz user@new-server:/home/user/
# On new server:
tar -xzf home-automation.tar.gz
cd home-automation

# Option B: From Git (if you pushed to GitHub/GitLab)
git clone https://github.com/yourusername/home-automation.git
cd home-automation
```

### Step 3: Configure Server-Specific Settings
```bash
# 1. Get your server IP
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "Your server IP: $SERVER_IP"

# 2. Update Home Assistant config
sed -i "s|http://YOUR_SERVER_IP:8503|http://$SERVER_IP:8503|g" homeassistant/configuration.yaml

# 3. Set timezone (optional)
sed -i 's|Asia/Kolkata|YOUR_TIMEZONE|g' docker-compose.yml
# List timezones: timedatectl list-timezones
```

### Step 4: Configure Firewall
```bash
# UFW (Ubuntu/Debian)
sudo ufw allow 8503/tcp comment 'Home Assistant'
sudo ufw allow 8504/tcp comment 'ESPHome'
sudo ufw allow 1883/tcp comment 'MQTT'
sudo ufw status

# Firewalld (RHEL/CentOS)
sudo firewall-cmd --permanent --add-port=8503/tcp
sudo firewall-cmd --permanent --add-port=8504/tcp
sudo firewall-cmd --permanent --add-port=1883/tcp
sudo firewall-cmd --reload
```

### Step 5: Start Services
```bash
# Make scripts executable
chmod +x *.sh

# Start everything
./start.sh

# Check status
./status.sh
```

### Step 6: Initial Configuration
1. Open browser: `http://YOUR_SERVER_IP:8503`
2. Create admin account
3. Complete onboarding wizard
4. Add MQTT integration:
   - Settings → Devices & Services → + Add Integration
   - Search "MQTT"
   - Broker: `mosquitto`, Port: `1883`

---

## 🔐 Security Hardening

### 1. Enable HTTPS (Let's Encrypt)
```bash
# Install Certbot
sudo apt-get install certbot -y

# Get certificate (requires domain name)
sudo certbot certonly --standalone -d home.yourdomain.com

# Update docker-compose.yml to mount certificates
# Add to homeassistant service volumes:
#   - /etc/letsencrypt:/certs:ro
```

### 2. Restrict MQTT Access
Edit `mosquitto/config/mosquitto.conf`:
```conf
listener 1883
allow_anonymous false
password_file /mosquitto/config/passwd
```

Create password file:
```bash
# Create user
docker-compose exec mosquitto mosquitto_passwd -c /mosquitto/config/passwd admin

# Restart MQTT
docker-compose restart mosquitto
```

### 3. Enable Home Assistant Authentication
Already enabled by default (admin account required).

To add more users:
- Settings → People → Add Person

### 4. Network Segmentation (Advanced)
Put ESP32 devices on separate VLAN with firewall rules:
- Allow: ESP32 → MQTT (port 1883)
- Block: ESP32 → Internet (unless needed for updates)

---

## 🌐 Remote Access Setup

### Option 1: Tailscale (Free, Easiest, Most Secure)
```bash
# On server
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# On phone
# 1. Install Tailscale app
# 2. Login with same account
# 3. Access: http://100.x.x.x:8503 (Tailscale IP)
```

### Option 2: WireGuard VPN (Free, More Control)
```bash
# Install WireGuard
sudo apt-get install wireguard -y

# Generate keys
wg genkey | tee privatekey | wg pubkey > publickey

# Configure /etc/wireguard/wg0.conf
# (See WireGuard documentation)

# Start
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0
```

### Option 3: Cloudflare Tunnel (Free, Public URL)
```bash
# Install cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Authenticate
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create home

# Route DNS
cloudflared tunnel route dns home home.yourdomain.com

# Run tunnel
cloudflared tunnel --url http://localhost:8503 run home

# Make it a service
sudo cloudflared service install
sudo systemctl start cloudflared
```

### Option 4: Nabu Casa (Paid, Official)
- In Home Assistant: Settings → Home Assistant Cloud
- Subscribe (~₹550/mo or $6.50/mo)
- Instant remote access via `https://your-id.ui.nabu.casa`
- Supports: Alexa, Google Assistant, webhooks

---

## 🔄 Auto-Start on Boot

### SystemD Service (Recommended)
```bash
# Create service file
sudo nano /etc/systemd/system/home-automation.service
```

Paste this:
```ini
[Unit]
Description=Home Automation System
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/ubuntu/.openclaw/workspace-nexus/home-automation
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable home-automation
sudo systemctl start home-automation

# Check status
sudo systemctl status home-automation
```

### Docker Compose Restart Policy (Already Configured)
Docker containers auto-restart on crash:
```yaml
# In docker-compose.yml
restart: unless-stopped
```

---

## 💾 Backup Strategy

### Automated Daily Backups
```bash
# Add to crontab
crontab -e

# Add this line (backup every day at 2 AM)
0 2 * * * /home/ubuntu/.openclaw/workspace-nexus/home-automation/backup.sh

# Verify
crontab -l
```

### Remote Backup (S3, SFTP, etc.)
```bash
# Install AWS CLI (for S3)
sudo apt-get install awscli -y

# Configure credentials
aws configure

# Modify backup.sh to upload to S3
# Add after tar command:
aws s3 cp "$BACKUP_FILE" s3://your-bucket/home-automation/
```

### Backup What?
✅ **Include:**
- `homeassistant/` (all YAML configs)
- `esphome/` (device firmware configs)
- `mosquitto/config/` (MQTT config)

❌ **Exclude:**
- `.esphome/` build cache
- `homeassistant/.cache/`
- `homeassistant/home-assistant.log`
- `mosquitto/data/` (message persistence, not critical)
- `mosquitto/log/`

---

## 📊 Monitoring

### Health Check Script (status.sh)
```bash
# Run manually
./status.sh

# Add to cron for monitoring (every 5 minutes)
*/5 * * * * /home/ubuntu/.openclaw/workspace-nexus/home-automation/status.sh > /tmp/ha-status.log

# Alert on failure (requires mail setup)
*/5 * * * * /path/to/status.sh || mail -s "HA DOWN" admin@example.com < /tmp/ha-status.log
```

### Log Rotation
Docker handles log rotation automatically, but you can configure:
```bash
# Edit /etc/docker/daemon.json
sudo nano /etc/docker/daemon.json
```

Add:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Restart Docker:
```bash
sudo systemctl restart docker
```

### Prometheus + Grafana (Advanced)
Home Assistant has built-in Prometheus exporter:
- Settings → Add-ons → Prometheus (install)
- Add Grafana add-on
- Beautiful dashboards for system metrics

---

## 🔧 Performance Tuning

### For Raspberry Pi
```bash
# Increase swap (if only 4GB RAM)
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# Set: CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

# Disable unnecessary services
sudo systemctl disable bluetooth
sudo systemctl disable avahi-daemon

# Use Docker overlay2 storage driver
# (Already default on newer systems)
```

### For Low-End Servers
Reduce Home Assistant database retention:
```yaml
# In homeassistant/configuration.yaml
recorder:
  purge_keep_days: 3  # Keep only 3 days of history
  commit_interval: 60  # Reduce disk writes
  db_url: sqlite:////config/home-assistant_v2.db
```

---

## 🚚 Migration Guide

### Migrating to New Server
```bash
# On old server
cd /home/ubuntu/.openclaw/workspace-nexus/home-automation
./backup.sh
scp backups/home-automation_backup_*.tar.gz user@new-server:/home/user/

# On new server
# (After installing Docker and Docker Compose)
mkdir -p /home/user/home-automation
cd /home/user/home-automation
scp user@old-server:/path/to/backup.tar.gz .
tar -xzf home-automation_backup_*.tar.gz

# Update IP in configuration
nano homeassistant/configuration.yaml
# Change external_url

# Start
./start.sh
```

### Changing Port Numbers
Edit `docker-compose.yml`:
```yaml
services:
  homeassistant:
    ports:
      - "8123:8123"  # Change 8503 → 8123 (HA default)
```

Update firewall and restart:
```bash
sudo ufw allow 8123/tcp
docker-compose down
docker-compose up -d
```

---

## 🐛 Common Issues

### "Port already in use"
```bash
# Find process using port
sudo lsof -i :8503

# Kill process
sudo fuser -k 8503/tcp

# Or change port in docker-compose.yml
```

### "Permission denied"
```bash
# Fix ownership
sudo chown -R $USER:$USER homeassistant mosquitto esphome

# Restart
./restart.sh
```

### "Container keeps restarting"
```bash
# Check logs
docker-compose logs homeassistant

# Common fix: corrupt database
cd homeassistant
mv home-assistant_v2.db home-assistant_v2.db.backup
# Restart (creates new DB)
cd ..
./restart.sh
```

---

## ✅ Post-Deployment Checklist

- [ ] Home Assistant accessible at `http://YOUR_IP:8503`
- [ ] Admin account created
- [ ] MQTT integration configured
- [ ] Mobile app connected
- [ ] All virtual devices working
- [ ] Firewall ports open (8503, 8504, 1883)
- [ ] Backup script tested (`./backup.sh`)
- [ ] Auto-start on boot configured
- [ ] Remote access method chosen (Tailscale/VPN/Nabu Casa)
- [ ] HTTPS enabled (if using public access)
- [ ] Monitoring/alerting set up
- [ ] Documentation reviewed (README.md)

---

## 📞 Support

- **Documentation:** `README.md` (full guide)
- **Quick Start:** `QUICKSTART.md` (5-minute setup)
- **Hardware:** `RESEARCH.md` (buying guide)
- **Community:** https://community.home-assistant.io
- **Discord:** https://discord.gg/home-assistant

---

**Deployment Time:** 15-30 minutes  
**Difficulty:** Beginner (with Docker experience)  
**Cost:** $0 software + server costs (VPS/cloud) OR ₹5,500 (Raspberry Pi 4)

---

**Built by:** Nexus AI Agent  
**For:** Aniket  
**Last Updated:** May 2026
