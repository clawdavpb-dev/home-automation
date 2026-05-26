#!/bin/bash
# Smart Home Automation - Backup Script
# Creates timestamped backup of entire configuration

set -e

echo "💾 Creating backup..."

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Create backup directory
BACKUP_DIR="$SCRIPT_DIR/backups"
mkdir -p "$BACKUP_DIR"

# Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/home-automation_backup_$TIMESTAMP.tar.gz"

# Create backup (exclude build cache and logs)
echo "📦 Archiving configuration..."
tar -czf "$BACKUP_FILE" \
    --exclude='./esphome/.esphome' \
    --exclude='./homeassistant/.cache' \
    --exclude='./homeassistant/home-assistant.log' \
    --exclude='./homeassistant/home-assistant_v2.db*' \
    --exclude='./mosquitto/log/*' \
    --exclude='./mosquitto/data/*' \
    --exclude='./backups' \
    .

# Check backup was created
if [ -f "$BACKUP_FILE" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✅ Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
    echo ""
    echo "📋 Recent backups:"
    ls -lht "$BACKUP_DIR" | head -6
    echo ""
    echo "To restore: ./restore.sh $BACKUP_FILE"
else
    echo "❌ Backup failed!"
    exit 1
fi

# Keep only last 10 backups
echo "🧹 Cleaning old backups (keeping last 10)..."
cd "$BACKUP_DIR"
ls -t home-automation_backup_*.tar.gz | tail -n +11 | xargs -r rm
echo "✅ Cleanup complete."
echo ""
