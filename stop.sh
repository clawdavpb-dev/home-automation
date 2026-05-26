#!/bin/bash
# Smart Home Automation - Stop Script

set -e

echo "🛑 Stopping Smart Home Automation System..."

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Stop containers
docker-compose down

echo ""
echo "✅ All services stopped."
echo ""
echo "To start again: ./start.sh"
echo ""
