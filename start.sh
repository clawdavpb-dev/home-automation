#!/bin/bash
# Smart Home Automation - Start Script
# Starts Home Assistant + ESPHome + Mosquitto MQTT

set -e  # Exit on error

echo "🏠 Starting Smart Home Automation System..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running!"
    echo "   Start Docker first: sudo systemctl start docker"
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose not found!"
    echo "   Install: sudo apt-get install docker-compose"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "📂 Working directory: $SCRIPT_DIR"
echo ""

# Check if ports are available
echo "🔍 Checking required ports..."
PORTS_IN_USE=0

if sudo netstat -tulpn 2>/dev/null | grep -q ":8503 "; then
    echo "   ⚠️  Port 8503 (Home Assistant) is in use"
    PORTS_IN_USE=1
fi

if sudo netstat -tulpn 2>/dev/null | grep -q ":8504 "; then
    echo "   ⚠️  Port 8504 (ESPHome) is in use"
    PORTS_IN_USE=1
fi

if sudo netstat -tulpn 2>/dev/null | grep -q ":1883 "; then
    echo "   ⚠️  Port 1883 (MQTT) is in use"
    PORTS_IN_USE=1
fi

if [ $PORTS_IN_USE -eq 1 ]; then
    echo ""
    echo "   Stop conflicting services first:"
    echo "   sudo fuser -k 8503/tcp"
    echo "   sudo fuser -k 8504/tcp"
    echo "   sudo fuser -k 1883/tcp"
    echo ""
    read -p "   Try to kill processes and continue? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "   🔪 Killing processes on ports..."
        sudo fuser -k 8503/tcp 2>/dev/null || true
        sudo fuser -k 8504/tcp 2>/dev/null || true
        sudo fuser -k 1883/tcp 2>/dev/null || true
        sleep 2
    else
        exit 1
    fi
else
    echo "   ✅ All ports available"
fi

echo ""

# Create directories if they don't exist
echo "📁 Ensuring directory structure..."
mkdir -p homeassistant mosquitto/config mosquitto/data mosquitto/log esphome

# Check if configuration files exist
if [ ! -f "homeassistant/configuration.yaml" ]; then
    echo "❌ configuration.yaml not found!"
    echo "   Please restore configuration files first."
    exit 1
fi

if [ ! -f "mosquitto/config/mosquitto.conf" ]; then
    echo "⚠️  mosquitto.conf not found. Creating default..."
    cat > mosquitto/config/mosquitto.conf << EOF
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
EOF
fi

echo "   ✅ Configuration files present"
echo ""

# Pull latest images
echo "📦 Pulling latest Docker images (this may take a few minutes)..."
docker-compose pull

echo ""

# Start containers
echo "🚀 Starting containers..."
docker-compose up -d

echo ""

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 5

# Check container status
echo ""
echo "📊 Container status:"
docker-compose ps

echo ""

# Check if Home Assistant is responding
echo "🏥 Health check..."
HA_HEALTHY=0
for i in {1..30}; do
    if curl -s http://localhost:8503 > /dev/null 2>&1; then
        HA_HEALTHY=1
        break
    fi
    echo -n "."
    sleep 2
done

echo ""

if [ $HA_HEALTHY -eq 1 ]; then
    echo "✅ Home Assistant is responding!"
else
    echo "⚠️  Home Assistant is not responding yet. It may still be starting up."
    echo "   Check logs: docker-compose logs -f homeassistant"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Smart Home Automation is RUNNING!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Access URLs:"
echo "   Home Assistant:  http://$(hostname -I | awk '{print $1}'):8503"
echo "   ESPHome:         http://$(hostname -I | awk '{print $1}'):8504"
echo "   MQTT Broker:     mqtt://$(hostname -I | awk '{print $1}'):1883"
echo ""
echo "📱 Mobile App Setup:"
echo "   1. Install 'Home Assistant' app (FREE)"
echo "   2. Enter server: http://$(hostname -I | awk '{print $1}'):8503"
echo "   3. Create admin account (first time)"
echo ""
echo "📋 Useful Commands:"
echo "   View logs:       docker-compose logs -f"
echo "   Stop system:     ./stop.sh"
echo "   Restart:         docker-compose restart"
echo "   Status:          docker-compose ps"
echo ""
echo "📚 Full documentation: cat README.md"
echo ""
