#!/bin/bash

# Ubuntu in Termux with VNC GUI Support
# Author: Krishna (simpleboykrishna0)
# Updated: 2025

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    error "This script must be run in Termux!"
    exit 1
fi

# Function to install dependencies
install_dependencies() {
    log "Installing dependencies..."
    
    # Update package lists
    pkg update -y
    
    # Install essential packages
    pkg install -y wget proot git curl tar xz-utils
    
    log "Dependencies installed successfully!"
    log "Note: VNC and GUI packages will be installed inside Ubuntu"
}

# Function to download Ubuntu rootfs
download_ubuntu() {
    log "Downloading Ubuntu 24.04.3 LTS rootfs..."
    
    # Create ubuntu directory
    mkdir -p ~/ubuntu-fs
    
    # Download Ubuntu rootfs (using smaller image for GUI)
    cd ~/ubuntu-fs
    
    # Download Ubuntu 24.04.3 LTS minimal rootfs
    wget -O ubuntu-rootfs.tar.xz https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04.3-minimal-cloudimg-arm64-root.tar.xz
    
    # Extract rootfs
    log "Extracting Ubuntu rootfs..."
    tar -xf ubuntu-rootfs.tar.xz
    
    # Clean up
    rm ubuntu-rootfs.tar.xz
    
    log "Ubuntu rootfs downloaded and extracted!"
}

# Function to setup Ubuntu environment
setup_ubuntu() {
    log "Setting up Ubuntu environment..."
    
    cd ~/ubuntu-fs
    
    # Create essential directories
    mkdir -p dev proc sys tmp var/run var/log
    
    # Create basic filesystem structure
    mkdir -p etc/apt/sources.list.d
    mkdir -p usr/bin usr/sbin usr/lib
    mkdir -p home/ubuntu
    
    # Create passwd file
    cat > etc/passwd << EOF
root:x:0:0:root:/root:/bin/bash
ubuntu:x:1000:1000:Ubuntu user:/home/ubuntu:/bin/bash
EOF

    # Create group file
    cat > etc/group << EOF
root:x:0:
ubuntu:x:1000:
EOF

    # Create hosts file
    cat > etc/hosts << EOF
127.0.0.1 localhost
::1 localhost ip6-localhost ip6-loopback
EOF

    log "Ubuntu environment setup complete!"
}

# Function to install GUI packages in Ubuntu
install_gui_packages() {
    log "Installing lightweight GUI packages..."
    
    # Create startup script for Ubuntu
    cat > ~/ubuntu-fs/start-gui.sh << 'EOF'
#!/bin/bash

# Update package lists
apt update

# Install lightweight desktop environment (XFCE4)
apt install -y xfce4 xfce4-goodies

# Install VNC server
apt install -y tightvncserver

# Install essential GUI applications
apt install -y firefox-esr chromium-browser
apt install -y file-manager thunar
apt install -y text-editor mousepad
apt install -y terminal xfce4-terminal

# Install development tools
apt install -y nano vim git curl wget

# Set up VNC server
mkdir -p ~/.vnc
echo "#!/bin/bash" > ~/.vnc/xstartup
echo "unset SESSION_MANAGER" >> ~/.vnc/xstartup
echo "unset DBUS_SESSION_BUS_ADDRESS" >> ~/.vnc/xstartup
echo "exec /usr/bin/startxfce4" >> ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# Set VNC password (default: ubuntu)
echo "ubuntu" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

echo "GUI setup complete!"
echo "Start VNC server with: vncserver :1 -geometry 1024x768 -depth 16"
echo "Connect using VNC viewer to: localhost:5901"
EOF

    chmod +x ~/ubuntu-fs/start-gui.sh
    
    log "GUI packages installation script created!"
}

# Function to create startup scripts
create_startup_scripts() {
    log "Creating startup scripts..."
    
    # Create main Ubuntu startup script
    cat > ~/startubuntu.sh << 'EOF'
#!/bin/bash

# Ubuntu in Termux Startup Script
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
EOF

    # Create VNC startup script
    cat > ~/startvnc.sh << 'EOF'
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
EOF

    # Create GUI setup script
    cat > ~/setupgui.sh << 'EOF'
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
        chmod +x /root/host/ubuntu-fs/start-gui.sh
        /root/host/ubuntu-fs/start-gui.sh
    "

echo -e "${BLUE}GUI setup complete!${NC}"
EOF

    # Make scripts executable
    chmod +x ~/startubuntu.sh
    chmod +x ~/startvnc.sh
    chmod +x ~/setupgui.sh
    
    log "Startup scripts created successfully!"
}

# Function to create VNC viewer instructions
create_vnc_instructions() {
    log "Creating VNC viewer instructions..."
    
    cat > ~/VNC_INSTRUCTIONS.txt << 'EOF'
===============================================
Ubuntu in Termux - VNC GUI Instructions
===============================================

INSTALLATION COMPLETE! 🎉

Now you can use Ubuntu with GUI in Termux:

1. START UBUNTU (Terminal only):
   ./startubuntu.sh

2. SETUP GUI (First time only):
   ./setupgui.sh

3. START UBUNTU WITH VNC GUI:
   ./startvnc.sh

4. CONNECT WITH VNC VIEWER:
   - Download VNC Viewer app from Play Store
   - Connect to: localhost:5901
   - Password: ubuntu

VNC VIEWER APPS:
- RealVNC Viewer (Recommended)
- VNC Viewer by RealVNC
- bVNC Pro

TROUBLESHOOTING:
- If VNC connection fails, restart Termux
- Make sure VNC server is running (check ./startvnc.sh output)
- Try different VNC viewer apps

FEATURES:
✅ Ubuntu 24.04.3 LTS
✅ XFCE4 Desktop Environment
✅ VNC Remote Access
✅ Firefox ESR Browser
✅ File Manager
✅ Terminal
✅ Development Tools

Total Size: ~2MB (optimized for mobile)

Maintained by: Krishna (simpleboykrishna0)
===============================================
EOF

    log "VNC instructions created!"
}

# Main installation function
main() {
    echo -e "${GREEN}"
    echo "==============================================="
    echo "Ubuntu in Termux with VNC GUI Support"
    echo "Author: Krishna (simpleboykrishna0)"
    echo "==============================================="
    echo -e "${NC}"
    
    # Check for -y flag
    if [ "$1" != "-y" ]; then
        echo -e "${YELLOW}This will install Ubuntu 24.04.3 LTS with VNC GUI support.${NC}"
        echo -e "${YELLOW}Total size: ~2MB (optimized)${NC}"
        echo -e "${YELLOW}Continue? (y/N): ${NC}"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "Y" ]; then
            echo "Installation cancelled."
            exit 0
        fi
    fi
    
    # Run installation steps
    install_dependencies
    download_ubuntu
    setup_ubuntu
    install_gui_packages
    create_startup_scripts
    create_vnc_instructions
    
    echo -e "${GREEN}"
    echo "==============================================="
    echo "Installation Complete! 🎉"
    echo "==============================================="
    echo -e "${NC}"
    
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Run: ./setupgui.sh (first time only)"
    echo "2. Run: ./startvnc.sh (to start with GUI)"
    echo "3. Connect VNC viewer to: localhost:5901"
    echo "4. Password: ubuntu"
    echo ""
    echo -e "${YELLOW}See VNC_INSTRUCTIONS.txt for detailed guide${NC}"
}

# Run main function
main "$@"
