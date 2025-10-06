#!/bin/bash

# Ubuntu in Termux Startup Script (Terminal Only)
# Author: Krishna (simpleboykrishna0)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}Starting Ubuntu 24.04.3 LTS in Termux...${NC}"

# Check if ubuntu-fs exists
if [ ! -d "$HOME/ubuntu-fs" ]; then
    echo "Ubuntu filesystem not found! Please run ubuntu.sh first."
    exit 1
fi

# Start Ubuntu with proot
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
    /bin/bash --login

echo -e "${BLUE}Ubuntu session ended.${NC}"
