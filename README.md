# Ubuntu in Termux with VNC GUI Support 🐧📱

Ubuntu Termux VNC

**Complete Ubuntu 24.04.3 LTS installation in Termux with lightweight GUI support via VNC**

---

## 🚀 What's New?

* ✅ **Ubuntu 24.04.3 LTS (Noble Numbat)** - Latest stable release
* ✅ **VNC Server Support** - Remote GUI access
* ✅ **Lightweight XFCE4 Desktop** - Only ~2MB total size
* ✅ **Optimized for Mobile** - No app crashes
* ✅ **One-Click Installation** - Automated setup
* ✅ **Multiple Startup Options** - Terminal or GUI mode

---

## 📋 Features

| Feature | Description |
|---------|-------------|
| 🖥️ **Desktop Environment** | XFCE4 (Lightweight & Fast) |
| 🌐 **VNC Remote Access** | Connect from any VNC viewer |
| 🔧 **Development Tools** | Git, Vim, Nano, Curl, Wget |
| 🌍 **Web Browser** | Firefox ESR (Lightweight) |
| 📁 **File Manager** | Thunar (XFCE4 File Manager) |
| 💻 **Terminal** | XFCE4 Terminal |
| 📝 **Text Editor** | Mousepad (Lightweight) |
| 📱 **Mobile Optimized** | Designed for Android devices |

---

## 🔧 Installation Steps

### Prerequisites

* Android device with Termux installed
* Internet connection
* At least 2GB free storage

### Quick Installation

```bash
# 1. Update Termux packages
pkg update && pkg upgrade -y

# 2. Install dependencies
pkg install wget proot git curl tar xz-utils -y

# 3. Clone repository
git clone https://github.com/simpleboykrishna0/ubuntu-gui-termux.git
cd ubuntu-gui-termux

# 4. Give execution permission
chmod +x ubuntu.sh

# 5. Run installer (automated)
./ubuntu.sh -y

# 6. Setup GUI (first time only)
./setupgui.sh

# 7. Start Ubuntu with VNC GUI
./startvnc.sh
```

### Alternative Installation (If packages not available)

```bash
# 1. Update Termux
pkg update && pkg upgrade -y

# 2. Install basic dependencies
pkg install wget proot git curl tar xz-utils -y

# 3. Download scripts manually
wget https://raw.githubusercontent.com/simpleboykrishna0/ubuntu-gui-termux/master/ubuntu.sh
wget https://raw.githubusercontent.com/simpleboykrishna0/ubuntu-gui-termux/master/startubuntu.sh
wget https://raw.githubusercontent.com/simpleboykrishna0/ubuntu-gui-termux/master/startvnc.sh
wget https://raw.githubusercontent.com/simpleboykrishna0/ubuntu-gui-termux/master/setupgui.sh

# 4. Make executable
chmod +x *.sh

# 5. Run installer
./ubuntu.sh -y
```

---

## 🎮 Usage Guide

### Starting Ubuntu

#### Option 1: Terminal Only
```bash
./startubuntu.sh
```

#### Option 2: With VNC GUI
```bash
./startvnc.sh
```

### Connecting with VNC Viewer

1. **Download VNC Viewer App:**  
   * RealVNC Viewer (Recommended)  
   * VNC Viewer by RealVNC  
   * bVNC Pro
2. **Connection Settings:**  
   * **Address:** `localhost:5901`  
   * **Password:** `ubuntu`  
   * **Port:** `5901`
3. **Connect and Enjoy!** 🎉

---

## 📱 VNC Viewer Apps

| App | Size | Features | Rating |
|-----|------|----------|--------|
| **RealVNC Viewer** | \~15MB | Official, Reliable | ⭐⭐⭐⭐⭐  |
| **bVNC Pro**       | \~8MB  | Advanced Features  | ⭐⭐⭐⭐   |
| **VNC Viewer**     | \~12MB | Simple Interface   | ⭐⭐⭐⭐   |

---

## 🛠️ Available Scripts

| Script         | Purpose                   | Usage            |
| -------------- | ------------------------- | ---------------- |
| ubuntu.sh      | Main installer            | ./ubuntu.sh -y   |
| startubuntu.sh | Start Ubuntu (Terminal)   | ./startubuntu.sh |
| startvnc.sh    | Start Ubuntu with VNC GUI | ./startvnc.sh    |
| setupgui.sh    | Setup GUI (First time)    | ./setupgui.sh    |

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### ❌ VNC Connection Failed

# Solution 1: Restart Termux
exit
# Reopen Termux and run:
./startvnc.sh

# Solution 2: Check VNC server status
# Look for "VNC server started on port 5901" message

#### ❌ "Fatal Kernel too old" Error

# Edit startubuntu.sh and uncomment this line:
# command+=" -k 4.14.81"
# Remove the # at the beginning

#### ❌ App Crashes

# Solution: Use lightweight mode
./startubuntu.sh  # Terminal only
# Or reduce VNC resolution:
# Edit startvnc.sh and change: -geometry 800x600

#### ❌ Permission Denied

# Fix permissions:
chmod +x *.sh

---

## 📊 System Requirements

| Component | Requirement |
|-----------|-------------|
| **Android Version** | 7.0+ (API 24+) |
| **RAM** | 2GB minimum, 4GB recommended |
| **Storage** | 2GB free space |
| **Architecture**    | ARM64, ARM32, x86\_64        |
| **Root Required**   | ❌ No root needed             |

---

## 🎯 Performance Optimization

### Size Optimization
* **Total Package Size:** \~2MB
* **Ubuntu Rootfs:** Compressed minimal image
* **GUI Components:** XFCE4 (lightweight)
* **VNC Server:** TightVNC (minimal)

### Memory Optimization
* **Desktop Environment:** XFCE4 (low memory usage)
* **Browser:** Firefox ESR (mobile optimized)
* **File Manager:** Thunar (lightweight)

---

## 🔒 Security Notes

* **VNC Password:** Default is `ubuntu` (change after first login)
* **Network:** VNC runs on localhost only (secure)
* **Permissions:** Runs in user space (no root required)

---

## 📚 Advanced Usage

### Custom VNC Resolution

# Edit startvnc.sh and modify:
vncserver :1 -geometry 1280x720 -depth 16

### Install Additional Software

# Inside Ubuntu:
apt update
apt install package-name

### Backup Ubuntu Installation

# Backup your Ubuntu filesystem:
tar -czf ubuntu-backup.tar.gz ~/ubuntu-fs

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

git clone https://github.com/simpleboykrishna0/ubuntu-gui-termux.git
cd ubuntu-gui-termux
# Make your changes
# Test thoroughly
# Submit PR

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Krishna (simpleboykrishna0)**

* GitHub: @simpleboykrishna0
* Discord: Available for support

---

## 🙏 Acknowledgments

* Termux - Amazing Android terminal emulator
* Ubuntu - Great Linux distribution
* XFCE - Lightweight desktop environment
* VNC - Remote desktop solution

---

## 📞 Support

* **Issues:** GitHub Issues
* **Discord:** Available for real-time support
* **Documentation:** Check this README for common solutions

---

## 🔄 Updates

**Latest Update:** Ubuntu 24.04.3 LTS with VNC GUI Support

* ✅ Added VNC server integration
* ✅ Lightweight XFCE4 desktop
* ✅ Mobile-optimized performance
* ✅ One-click installation
* ✅ Comprehensive documentation

---

## ⭐ Star This Repository

If you found this project helpful, please give it a star! ⭐

---

**Made with ❤️ for the Android Linux community**

GitHub stars GitHub forks
