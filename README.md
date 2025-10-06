# Ubuntu in Termux 🐧📱

**Ubuntu 24.04 LTS installation in Termux with VNC GUI support**

---

## 🚀 Features

* ✅ **Ubuntu 24.04 LTS** - Latest stable release
* ✅ **VNC Server Support** - Remote GUI access
* ✅ **XFCE4 Desktop** - Lightweight desktop environment
* ✅ **Mobile Optimized** - Clean installation method
* ✅ **One-Click Installation** - Automated setup
* ✅ **Multiple Architectures** - ARM64, ARMhf support

---

## 🔧 Installation Steps

### Prerequisites

* Android device with Termux installed
* Internet connection
* At least 2GB free storage

### Quick Installation

```bash
# 1. Download installer
wget https://raw.githubusercontent.com/simpleboykrishna0/ubuntu-gui-termux/master/ubuntu.sh

# 2. Make executable
chmod +x ubuntu.sh

# 3. Run installer
./ubuntu.sh
```

---

## 🎮 Usage Guide

### Starting Ubuntu

#### Option 1: Terminal Only
```bash
ubuntu
# OR
ub
```

#### Option 2: With VNC GUI
```bash
ubuntu vnc
# OR
ub vnc
```

### VNC Commands

```bash
# Set VNC password
ubuntu vnc passwd

# Start VNC server
ubuntu vnc start

# Stop VNC server
ubuntu vnc stop
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

## 🛠️ Available Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `ubuntu` | Start Ubuntu CLI | `ubuntu` |
| `ub` | Shortcut for ubuntu | `ub` |
| `ubuntu vnc` | Start VNC GUI | `ubuntu vnc` |
| `ubuntu vnc passwd` | Set VNC password | `ubuntu vnc passwd` |
| `ubuntu vnc stop` | Stop VNC server | `ubuntu vnc stop` |

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### ❌ VNC Connection Failed
```bash
# Solution: Restart VNC server
ubuntu vnc stop
ubuntu vnc start
```

#### ❌ Permission Denied
```bash
# Fix permissions:
chmod +x ubuntu.sh
```

#### ❌ Ubuntu Not Found
```bash
# Reinstall Ubuntu:
rm -rf ubuntu-*
./ubuntu.sh
```

---

## 📊 System Requirements

| Component | Requirement |
|-----------|-------------|
| **Android Version** | 7.0+ (API 24+) |
| **RAM** | 2GB minimum |
| **Storage** | 2GB free space |
| **Architecture** | ARM64, ARMhf |
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
* **Build Tools** - Development environment

---

## 🔒 Security Notes

* **VNC Password:** Default is `ubuntu` (change with `ubuntu vnc passwd`)
* **Network:** VNC runs on localhost only (secure)
* **Permissions:** Runs in user space (no root required)

---

## 📚 Advanced Usage

### Install Additional Software
```bash
# Inside Ubuntu:
ubuntu
sudo apt update
sudo apt install package-name
```

### Custom VNC Resolution
```bash
# Edit VNC settings:
ubuntu vnc stop
# Modify resolution in ~/.vnc/xstartup
ubuntu vnc start
```

### Run Commands in Ubuntu
```bash
# Run single command
ubuntu -c "sudo apt update"

# Run as root
ubuntu -r
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
* Kali NetHunter - Inspiration for installer script

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
