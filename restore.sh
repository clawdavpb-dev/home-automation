#!/bin/bash
# Smart Home Automation - Restore Script
# Restores configuration from backup

set -e

# Check if backup file is provided
if [ -z "$1" ]; then
    echo "❌ Usage: ./restore.sh <backup-file>"
    echo ""
    echo "Available backups:"
    ls -lht backups/*.tar.gz 2>/dev/null | head -10 || echo "   No backups found."
    exit 1
fi

BACKUP_FILE="$1"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  WARNING: This will OVERWRITE current configuration!"
echo "   Backup file: $BACKUP_FILE"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Stop services
echo "🛑 Stopping services..."
docker-compose down 2>/dev/null || true

# Create safety backup of current config
echo "💾 Creating safety backup of current config..."
SAFETY_BACKUP="$SCRIPT_DIR/backups/pre-restore_$(date +%Y%m%d_%H%M%S).tar.gz"
mkdir -p backups
tar -czf "$SAFETY_BACKUP" \
    --exclude='./esphome/.esphome' \
    --exclude='./homeassistant/.cache' \
    --exclude='./mosquitto/log/*' \
    --exclude='./mosquitto/data/*' \
    --exclude='./backups' \
    . 2>/dev/null || true
echo "   Safety backup: $SAFETY_BACKUP"

# Extract backup
echo "📦 Restoring from backup..."
tar -xzf "$BACKUP_FILE" -C "$SCRIPT_DIR"

echo "✅ Restore complete!"
echo ""
echo "🚀 Start services: ./start.sh"
echo ""
