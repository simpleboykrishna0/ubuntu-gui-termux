#!/bin/bash

# Ubuntu in Termux - Simple Installer with DNS Fix
echo "Installing Ubuntu in Termux..."

# Update packages
pkg update -y

# Install proot-distro
pkg install -y proot-distro

# Install Ubuntu
proot-distro install ubuntu

# Fix DNS resolution issue
proot-distro login ubuntu -- bash -c "
    echo 'Fixing DNS resolution...'
    echo 'nameserver 8.8.8.8' > /etc/resolv.conf
    echo 'nameserver 8.8.4.4' >> /etc/resolv.conf
    echo 'DNS resolution fixed!'
"

# Create simple launcher script
cat > ubuntu << 'EOF'
#!/bin/bash
proot-distro login ubuntu
EOF

chmod +x ubuntu

echo "Ubuntu installed successfully!"
echo "Run './ubuntu' to start Ubuntu"
echo "DNS resolution has been fixed!"
