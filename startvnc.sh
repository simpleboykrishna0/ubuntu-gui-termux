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