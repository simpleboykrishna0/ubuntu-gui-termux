#!/bin/bash
echo "Setting up GUI in Ubuntu..."
proot-distro login ubuntu -- bash -c "
    echo 'Installing additional GUI packages...'
    apt update
    apt install -y chromium-browser nano vim git curl wget
    echo 'Additional GUI packages installed!'
"