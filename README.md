# Ubuntu in Termux with VNC GUI 🐧📱

**Clean Ubuntu installation in Termux using proot-distro with VNC GUI support**

---

## 🚀 Features

* ✅ **Ubuntu 24.04 LTS** - Latest stable release
* ✅ **VNC Server Support** - Remote GUI access
* ✅ **XFCE4 Desktop** - Lightweight desktop environment
* ✅ **Mobile Optimized** - Clean installation method
* ✅ **One-Click Installation** - Automated setup
* ✅ **No Complex Downloads** - Uses proot-distro

---

## 🔧 Installation Steps

### Prerequisites

* Android device with Termux installed
* Internet connection
* At least 1GB free storage

### Quick Installation

```bash
# 1. Update Termux packages
pkg update && pkg upgrade -y

# 2. Clone repository
git clone https://github.com/simpleboykrishna0/ubuntu-gui-termux.git
cd ubuntu-gui-termux

# 3. Make scripts executable
chmod +x *.sh

# 4. Run installer
./ubuntu.sh

# 5. Start Ubuntu with VNC GUI
./startvnc.sh
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

## 🛠️ Available Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `ubuntu.sh` | Main installer | `./ubuntu.sh` |
| `startubuntu.sh` | Start Ubuntu (Terminal) | `./startubuntu.sh` |
| `startvnc.sh` | Start Ubuntu with VNC GUI | `./startvnc.sh` |
| `setupgui.sh` | Install additional packages | `./setupgui.sh` |

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### ❌ VNC Connection Failed
```bash
# Solution: Restart VNC server
./startvnc.sh
```

#### ❌ Permission Denied
```bash
# Fix permissions:
chmod +x *.sh
```

#### ❌ Ubuntu Not Found
```bash
# Reinstall Ubuntu:
proot-distro remove ubuntu
proot-distro install ubuntu
```

---

## 📊 System Requirements

| Component | Requirement |
|-----------|-------------|
| **Android Version** | 7.0+ (API 24+) |
| **RAM** | 2GB minimum |
| **Storage** | 1GB free space |
| **Architecture** | ARM64, ARM32, x86_64 |
| **Root Required** | ❌ No root needed |

---

## 🎯 Features

### Desktop Environment
* **XFCE4** - Lightweight & Fast
* **VNC Remote Access** - Connect from any VNC viewer
* **Firefox ESR** - Web browser
* **Thunar** - File manager
* **XFCE4 Terminal** - Terminal emulator
* **Mousepad** - Text editor

### Development Tools
* **Git** - Version control
* **Vim/Nano** - Text editors
* **Curl/Wget** - Download tools
* **Chromium** - Alternative browser

---

## 🔒 Security Notes

* **VNC Password:** Default is `ubuntu` (change after first login)
* **Network:** VNC runs on localhost only (secure)
* **Permissions:** Runs in user space (no root required)

---

## 📚 Advanced Usage

### Install Additional Software
```bash
# Inside Ubuntu:
apt update
apt install package-name
```

### Custom VNC Resolution
```bash
# Edit startvnc.sh and modify:
vncserver :1 -geometry 1280x720 -depth 16
```

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
* proot-distro - Clean installation method

---

## 📞 Support

* **Issues:** GitHub Issues
* **Discord:** Available for real-time support
* **Documentation:** Check this README for common solutions

---

## ⭐ Star This Repository

If you found this project helpful, please give it a star! ⭐

---

**Made with ❤️ for the Android Linux community**