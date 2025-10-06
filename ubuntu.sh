#!/bin/bash

# Ubuntu in Termux with VNC GUI - Clean Installation
# Author: Krishna (simpleboykrishna0)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}===============================================${NC}"
echo -e "${GREEN}Ubuntu in Termux with VNC GUI${NC}"
echo -e "${GREEN}Clean Installation using proot-distro${NC}"
echo -e "${GREEN}Author: Krishna (simpleboykrishna0)${NC}"
echo -e "${GREEN}===============================================${NC}"
echo ""

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${RED}This script must be run in Termux!${NC}"
    exit 1
fi

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}Installing dependencies...${NC}"
    pkg update -y
    pkg install -y proot-distro
    echo -e "${GREEN}Dependencies installed!${NC}"
}

# Function to install Ubuntu
install_ubuntu() {
    echo -e "${YELLOW}Installing Ubuntu using proot-distro...${NC}"
    proot-distro install ubuntu
    echo -e "${GREEN}Ubuntu installed successfully!${NC}"
}

# Function to setup VNC GUI
setup_vnc_gui() {
    echo -e "${YELLOW}Setting up VNC GUI in Ubuntu...${NC}"
    
    proot-distro login ubuntu -- bash -c "
        echo 'Updating Ubuntu packages...'
        apt update
        
        echo 'Installing VNC server and GUI...'
        apt install -y tightvncserver xfce4 xfce4-goodies
        
        echo 'Installing essential applications...'
        apt install -y firefox-esr thunar mousepad xfce4-terminal
        
        echo 'Setting up VNC server...'
        mkdir -p ~/.vnc
        
        # Create VNC startup script
        cat > ~/.vnc/xstartup << 'VNC_EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec /usr/bin/startxfce4
VNC_EOF
        
        chmod +x ~/.vnc/xstartup
        
        # Set VNC password
        echo 'ubuntu' | vncpasswd -f > ~/.vnc/passwd
        chmod 600 ~/.vnc/passwd
        
        echo 'VNC GUI setup complete!'
    "
    
    echo -e "${GREEN}VNC GUI setup complete!${NC}"
}

# Function to create startup scripts
create_scripts() {
    echo -e "${YELLOW}Creating startup scripts...${NC}"
    
    # Create startubuntu.sh
    cat > startubuntu.sh << 'EOF'
#!/bin/bash
echo "Starting Ubuntu..."
proot-distro login ubuntu
EOF

    # Create startvnc.sh
    cat > startvnc.sh << 'EOF'
#!/bin/bash
echo "Starting Ubuntu with VNC GUI..."
proot-distro login ubuntu -- bash -c "
    echo 'Starting VNC server...'
    vncserver :1 -geometry 1024x768 -depth 16
    echo 'VNC server started on port 5901'
    echo 'Connect using VNC viewer to: localhost:5901'
    echo 'Password: ubuntu'
    echo 'Press Ctrl+C to stop VNC server'
    tail -f /dev/null
"
EOF

    # Create setupgui.sh
    cat > setupgui.sh << 'EOF'
#!/bin/bash
echo "Setting up GUI in Ubuntu..."
proot-distro login ubuntu -- bash -c "
    echo 'Installing additional GUI packages...'
    apt update
    apt install -y chromium-browser nano vim git curl wget
    echo 'Additional GUI packages installed!'
"
EOF

    # Make scripts executable
    chmod +x *.sh
    
    echo -e "${GREEN}Startup scripts created!${NC}"
}

# Function to create instructions
create_instructions() {
    cat > VNC_INSTRUCTIONS.txt << 'EOF'
===============================================
Ubuntu in Termux with VNC GUI - Instructions
===============================================

INSTALLATION COMPLETE! 🎉

Now you can use Ubuntu with VNC GUI:

1. START UBUNTU (Terminal only):
   ./startubuntu.sh

2. START UBUNTU WITH VNC GUI:
   ./startvnc.sh

3. SETUP ADDITIONAL GUI PACKAGES:
   ./setupgui.sh

4. CONNECT WITH VNC VIEWER:
   - Download VNC Viewer app from Play Store
   - Connect to: localhost:5901
   - Password: ubuntu

VNC VIEWER APPS:
- RealVNC Viewer (Recommended)
- VNC Viewer by RealVNC
- bVNC Pro

FEATURES:
✅ Ubuntu 24.04 LTS
✅ XFCE4 Desktop Environment
✅ VNC Remote Access
✅ Firefox ESR Browser
✅ File Manager (Thunar)
✅ Terminal (XFCE4 Terminal)
✅ Text Editor (Mousepad)

Total Size: Optimized for mobile

Maintained by: Krishna (simpleboykrishna0)
===============================================
EOF

    echo -e "${GREEN}Instructions created!${NC}"
}

# Main installation function
main() {
    echo -e "${YELLOW}Starting clean Ubuntu installation...${NC}"
    
    # Run installation steps
    install_dependencies
    install_ubuntu
    setup_vnc_gui
    create_scripts
    create_instructions
    
    echo -e "${GREEN}"
    echo "==============================================="
    echo "Ubuntu with VNC GUI Installation Complete! 🎉"
    echo "==============================================="
    echo -e "${NC}"
    
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Run: ./startvnc.sh (to start with VNC GUI)"
    echo "2. Connect VNC viewer to: localhost:5901"
    echo "3. Password: ubuntu"
    echo ""
    echo -e "${YELLOW}Available commands:${NC}"
    echo "• ./startubuntu.sh - Start Ubuntu terminal"
    echo "• ./startvnc.sh - Start Ubuntu with VNC GUI"
    echo "• ./setupgui.sh - Install additional packages"
    echo ""
    echo -e "${GREEN}See VNC_INSTRUCTIONS.txt for detailed guide${NC}"
}

# Run main function
main "$@"