#!/bin/bash
# Smart Home Automation - Restart Script

set -e

echo "🔄 Restarting Smart Home Automation System..."
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Restart all containers
docker-compose restart

echo ""
echo "✅ All services restarted."
echo ""
echo "View logs: docker-compose logs -f"
echo ""
