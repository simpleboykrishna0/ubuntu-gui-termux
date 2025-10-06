#!/bin/bash

# GUI Setup Script
# Author: Krishna (simpleboykrishna0)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}Setting up GUI in Ubuntu...${NC}"

# Check if ubuntu-fs exists
if [ ! -d "$HOME/ubuntu-fs" ]; then
    echo "Ubuntu filesystem not found! Please run ubuntu.sh first."
    exit 1
fi

# Run GUI setup inside Ubuntu
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
        echo 'Updating package lists...'
        apt update
        
        echo 'Installing lightweight desktop environment (XFCE4)...'
        apt install -y xfce4 xfce4-goodies
        
        echo 'Installing VNC server...'
        apt install -y tightvncserver
        
        echo 'Installing essential GUI applications...'
        apt install -y firefox-esr chromium-browser
        apt install -y file-manager thunar
        apt install -y text-editor mousepad
        apt install -y terminal xfce4-terminal
        
        echo 'Installing development tools...'
        apt install -y nano vim git curl wget
        
        echo 'Setting up VNC server...'
        mkdir -p ~/.vnc
        echo '#!/bin/bash' > ~/.vnc/xstartup
        echo 'unset SESSION_MANAGER' >> ~/.vnc/xstartup
        echo 'unset DBUS_SESSION_BUS_ADDRESS' >> ~/.vnc/xstartup
        echo 'exec /usr/bin/startxfce4' >> ~/.vnc/xstartup
        chmod +x ~/.vnc/xstartup
        
        echo 'Setting VNC password (default: ubuntu)...'
        echo 'ubuntu' | vncpasswd -f > ~/.vnc/passwd
        chmod 600 ~/.vnc/passwd
        
        echo 'GUI setup complete!'
        echo 'Start VNC server with: vncserver :1 -geometry 1024x768 -depth 16'
        echo 'Connect using VNC viewer to: localhost:5901'
    "

echo -e "${BLUE}GUI setup complete!${NC}"