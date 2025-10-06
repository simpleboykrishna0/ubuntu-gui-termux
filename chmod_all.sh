#!/bin/bash

# Auto-chmod script for ubuntu-gui-termux
# This script automatically makes all .sh files executable
# Author: Krishna (simpleboykrishna0)

echo "Setting execute permissions for all .sh files..."

# Make all .sh files executable in current directory
chmod +x *.sh

# Make all .sh files executable in ubuntu-gui-termux directory
if [ -d "$HOME/ubuntu-gui-termux" ]; then
    chmod +x ~/ubuntu-gui-termux/*.sh
    find ~/ubuntu-gui-termux -name "*.sh" -exec chmod +x {} \;
fi

# Make all .sh files executable recursively
find . -name "*.sh" -exec chmod +x {} \;

echo "All .sh files are now executable!"
echo "You can now run: ./ubuntu.sh -y"
