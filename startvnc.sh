#!/bin/bash

# VNC Server Startup Script
# Author: Krishna (simpleboykrishna0)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Starting Ubuntu with VNC GUI...${NC}"

# Check if ubuntu-fs exists
if [ ! -d "$HOME/ubuntu-fs" ]; then
    echo "Ubuntu filesystem not found! Please run ubuntu.sh first."
    exit 1
fi

# Start Ubuntu with VNC support
proot \
    --link2symlink \
    --kill-on-exit \
    --root-id \
    --rootfs="$HOME/ubuntu-fs" \
    --cwd=/root \
    --bind=/dev \
    --bind=/proc \
    --bind=/sys \
    --bind=/tmp \
    --bind="$HOME:/root/host" \
    /usr/bin/env -i \
    HOME=/root \
    TERM="xterm-256color" \
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash -c "
        echo 'Starting VNC server...'
        vncserver :1 -geometry 1024x768 -depth 16
        echo -e '${YELLOW}VNC server started on port 5901${NC}'
        echo -e '${BLUE}Connect using VNC viewer to: localhost:5901${NC}'
        echo -e '${BLUE}Password: ubuntu${NC}'
        echo 'Press Ctrl+C to stop VNC server'
        tail -f /dev/null
    "

echo -e "${BLUE}VNC session ended.${NC}"
