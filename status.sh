#!/bin/bash
# Smart Home Automation - Status Check Script

set -e

echo "🏠 Smart Home Automation - System Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Docker status
echo "🐳 Docker Status:"
if docker info > /dev/null 2>&1; then
    echo "   ✅ Docker is running"
else
    echo "   ❌ Docker is not running"
    exit 1
fi
echo ""

# Container status
echo "📦 Containers:"
docker-compose ps
echo ""

# Port checks
echo "🔌 Port Status:"
check_port() {
    PORT=$1
    NAME=$2
    if sudo netstat -tulpn 2>/dev/null | grep -q ":$PORT "; then
        echo "   ✅ Port $PORT ($NAME) - LISTENING"
    else
        echo "   ❌ Port $PORT ($NAME) - NOT LISTENING"
    fi
}

check_port 8503 "Home Assistant"
check_port 8504 "ESPHome"
check_port 1883 "MQTT"
echo ""

# Service health checks
echo "🏥 Service Health:"

# Home Assistant
if curl -s http://localhost:8503 > /dev/null 2>&1; then
    echo "   ✅ Home Assistant - RESPONDING"
else
    echo "   ❌ Home Assistant - NOT RESPONDING"
fi

# ESPHome
if curl -s http://localhost:8504 > /dev/null 2>&1; then
    echo "   ✅ ESPHome - RESPONDING"
else
    echo "   ❌ ESPHome - NOT RESPONDING"
fi

# MQTT
if timeout 2 bash -c "</dev/tcp/localhost/1883" 2>/dev/null; then
    echo "   ✅ MQTT - ACCEPTING CONNECTIONS"
else
    echo "   ❌ MQTT - NOT ACCEPTING CONNECTIONS"
fi
echo ""

# Disk usage
echo "💾 Disk Usage:"
du -sh homeassistant mosquitto esphome 2>/dev/null || echo "   (Directories not found)"
echo ""

# Recent logs
echo "📋 Recent Log Entries (last 5 lines):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Home Assistant:"
docker-compose logs --tail=5 homeassistant 2>/dev/null | tail -5 || echo "   (No logs)"
echo ""
echo "MQTT:"
docker-compose logs --tail=5 mosquitto 2>/dev/null | tail -5 || echo "   (No logs)"
echo ""

# Access URLs
echo "🌐 Access URLs:"
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "   Home Assistant:  http://$SERVER_IP:8503"
echo "   ESPHome:         http://$SERVER_IP:8504"
echo "   MQTT Broker:     mqtt://$SERVER_IP:1883"
echo ""

# Quick actions
echo "⚡ Quick Actions:"
echo "   View logs:     docker-compose logs -f"
echo "   Restart:       ./restart.sh"
echo "   Stop:          ./stop.sh"
echo "   Backup:        ./backup.sh"
echo ""
