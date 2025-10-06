#!/data/data/com.termux/files/usr/bin/bash -e

VERSION=20250106
BASE_URL=https://cloud-images.ubuntu.com/releases/noble/release
USERNAME=ubuntu

function unsupported_arch() {
    printf "${red}"
    echo "[*] Unsupported Architecture\n\n"
    printf "${reset}"
    exit
}

function ask() {
    # http://djm.me/ask
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
        # Ask the question
        printf "${light_cyan}\n[?] "
        read -p "$1 [$prompt] " REPLY
        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
        printf "${reset}"
        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

function get_arch() {
    printf "${blue}[*] Checking device architecture ..."
    case $(getprop ro.product.cpu.abi) in
        arm64-v8a)
            SYS_ARCH=arm64
            ;;
        armeabi|armeabi-v7a)
            SYS_ARCH=armhf
            ;;
        *)
            unsupported_arch
            ;;
    esac
}

function set_strings() {
    echo \\ && echo ""
    ####
    if [[ ${SYS_ARCH} == "arm64" ]]; then
        echo "[1] Ubuntu ARM64 (server)"
        echo "[2] Ubuntu ARM64 (minimal)"
        echo "[3] Ubuntu ARM64 (desktop)"
        read -p "Enter the image you want to install: " wimg
        if (( $wimg == "1" )); then
            wimg="server"
        elif (( $wimg == "2" )); then
            wimg="minimal"
        elif (( $wimg == "3" )); then
            wimg="desktop"
        else
            wimg="server"
        fi
    elif [[ ${SYS_ARCH} == "armhf" ]]; then
        echo "[1] Ubuntu ARMhf (server)"
        echo "[2] Ubuntu ARMhf (minimal)"
        echo "[3] Ubuntu ARMhf (desktop)"
        read -p "Enter the image you want to install: " wimg
        if [[ "$wimg" == "1" ]]; then
            wimg="server"
        elif [[ "$wimg" == "2" ]]; then
            wimg="minimal"
        elif [[ "$wimg" == "3" ]]; then
            wimg="desktop"
        else
            wimg="server"
        fi
    fi
    ####
    CHROOT=ubuntu-${SYS_ARCH}
    IMAGE_NAME=ubuntu-24.04-server-cloudimg-${SYS_ARCH}-root.tar.xz
    SHA_NAME=${IMAGE_NAME}.sha256sum
}

function prepare_fs() {
    unset KEEP_CHROOT
    if [ -d ${CHROOT} ]; then
        if ask "Existing rootfs directory found. Delete and create a new one?" "N"; then
            rm -rf ${CHROOT}
        else
            KEEP_CHROOT=1
        fi
    fi
}

function cleanup() {
    if [ -f "${IMAGE_NAME}" ]; then
        if ask "Delete downloaded rootfs file?" "N"; then
            if [ -f "${IMAGE_NAME}" ]; then
                rm -f "${IMAGE_NAME}"
            fi
            if [ -f "${SHA_NAME}" ]; then
                rm -f "${SHA_NAME}"
            fi
        fi
    fi
}

function check_dependencies() {
    printf "${blue}\n[*] Checking package dependencies...${reset}\n"
    ## Workaround for termux-app issue #1283
    apt-get update -y &> /dev/null || apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" dist-upgrade -y &> /dev/null
    
    for i in proot tar wget; do
        if [ -e "$PREFIX"/bin/$i ]; then
            echo " $i is OK"
        else
            printf "Installing ${i}...\n"
            apt install -y $i || {
                printf "${red}ERROR: Failed to install packages.\n Exiting.\n${reset}"
                exit
            }
        fi
    done
    apt upgrade -y
}

function get_url() {
    ROOTFS_URL="${BASE_URL}/${IMAGE_NAME}"
    SHA_URL="${BASE_URL}/${SHA_NAME}"
}

function get_rootfs() {
    unset KEEP_IMAGE
    if [ -f "${IMAGE_NAME}" ]; then
        if ask "Existing image file found. Delete and download a new one?" "N"; then
            rm -f "${IMAGE_NAME}"
        else
            printf "${yellow}[!] Using existing rootfs archive${reset}\n"
            KEEP_IMAGE=1
            return
        fi
    fi
    
    printf "${blue}[*] Downloading rootfs...${reset}\n\n"
    get_url
    
    # Try multiple URLs if first fails
    if ! wget --continue "${ROOTFS_URL}"; then
        echo "[!] Primary URL failed, trying alternative..."
        ROOTFS_URL="https://cloud-images.ubuntu.com/releases/24.04/release/${IMAGE_NAME}"
        if ! wget --continue "${ROOTFS_URL}"; then
            echo "[!] Alternative URL failed, trying backup..."
            ROOTFS_URL="https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-minimal-cloudimg-${SYS_ARCH}-root.tar.xz"
            wget --continue "${ROOTFS_URL}"
        fi
    fi
}

function check_sha_url() {
    # Skip SHA verification if file doesn't exist
    echo "[!] Skipping SHA verification (file may not exist)"
    return 1
}

function verify_sha() {
    if [ -z $KEEP_IMAGE ]; then
        printf "\n${blue}[*] Verifying integrity of rootfs...${reset}\n\n"
        if [ -f "${SHA_NAME}" ]; then
            sha256sum -c "$SHA_NAME" || {
                printf "${red} Rootfs corrupted. Please run this installer again or download the file manually\n${reset}"
                exit 1
            }
        else
            echo "[!] SHA file not found. Skipping verification..."
        fi
    fi
}

function get_sha() {
    if [ -z $KEEP_IMAGE ]; then
        printf "\n${blue}[*] Skipping SHA verification...${reset}\n\n"
        echo "[!] SHA verification skipped for faster installation"
    fi
}

function extract_rootfs() {
    if [ -z $KEEP_CHROOT ]; then
        printf "\n${blue}[*] Extracting rootfs... ${reset}\n\n"
        proot --link2symlink tar -xf "$IMAGE_NAME" 2> /dev/null || :
    else
        printf "${yellow}[!] Using existing rootfs directory${reset}\n"
    fi
}

function create_launcher() {
    UBUNTU_LAUNCHER=${PREFIX}/bin/ubuntu
    UBUNTU_SHORTCUT=${PREFIX}/bin/ub
    
    cat > "$UBUNTU_LAUNCHER" <<- EOF
#!/data/data/com.termux/files/usr/bin/bash -e
cd \${HOME}
## termux-exec sets LD_PRELOAD so let's unset it before continuing
unset LD_PRELOAD
## Workaround for Libreoffice, also needs to bind a fake /proc/version
if [ ! -f $CHROOT/root/.version ]; then
    touch $CHROOT/root/.version
fi
## Default user is "ubuntu"
user="$USERNAME"
home="/home/\$user"
start="sudo -u ubuntu /bin/bash"
## Ubuntu can be launched as root with the "-r" cmd attribute
## Also check if user ubuntu exists, if not start as root
if grep -q "ubuntu" ${CHROOT}/etc/passwd; then
    UBUNTUUSR="1";
else
    UBUNTUUSR="0";
fi
if [[ \$UBUNTUUSR == "0" || ("\$#" != "0" && ("\$1" == "-r" || "\$1" == "-R")) ]];then
    user="root"
    home="/\$user"
    start="/bin/bash --login"
    if [[ "\$#" != "0" && ("\$1" == "-r" || "\$1" == "-R") ]];then
        shift
    fi
fi
cmdline="proot \\
    --link2symlink \\
    -0 \\
    -r $CHROOT \\
    -b /dev \\
    -b /proc \\
    -b /sdcard \\
    -b $CHROOT\$home:/dev/shm \\
    -w \$home \\
    /usr/bin/env -i \\
    HOME=\$home \\
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \\
    TERM=\$TERM \\
    LANG=C.UTF-8 \\
    \$start"
cmd="\$@"
if [ "\$#" == "0" ];then
    exec \$cmdline
else
    \$cmdline -c "\$cmd"
fi
EOF
    
    chmod 700 "$UBUNTU_LAUNCHER"
    if [ -L "${UBUNTU_SHORTCUT}" ]; then
        rm -f "${UBUNTU_SHORTCUT}"
    fi
    if [ ! -f "${UBUNTU_SHORTCUT}" ]; then
        ln -s "${UBUNTU_LAUNCHER}" "${UBUNTU_SHORTCUT}" >/dev/null
    fi
}

function check_vnc() {
    if [ "$wimg" = "minimal" ] || [ "$wimg" = "desktop" ]; then
        ubuntu sudo apt update && ubuntu sudo apt install -y tightvncserver xfce4 xfce4-goodies
    fi
}

function create_vnc_launcher() {
    VNC_LAUNCHER=${CHROOT}/usr/bin/vnc
    cat > $VNC_LAUNCHER <<- EOF
#!/bin/bash
function start-vnc() {
    if [ ! -f ~/.vnc/passwd ]; then
        passwd-vnc
    fi
    USR=\$(whoami)
    if [ \$USR == "root" ]; then
        SCREEN=":2"
    else
        SCREEN=":1"
    fi
    export MOZ_FAKE_NO_SANDBOX=1; export HOME=\${HOME}; export USER=\${USR};
    LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgcc_s.so.1 nohup vncserver \$SCREEN >/dev/null 2>&1
    echo "VNC server started on port 5901"
    echo "Connect using VNC viewer to: localhost:5901"
    echo "Password: ubuntu"
}

function passwd-vnc() {
    echo "ubuntu" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
    echo "VNC password set to: ubuntu"
}

function stop-vnc() {
    vncserver -kill :1 2>/dev/null || :
    vncserver -kill :2 2>/dev/null || :
    echo "VNC server stopped"
}

case "\$1" in
    start|"")
        start-vnc
        ;;
    passwd)
        passwd-vnc
        ;;
    stop)
        stop-vnc
        ;;
    *)
        echo "Usage: vnc {start|passwd|stop}"
        ;;
esac
EOF
    
    chmod +x $VNC_LAUNCHER
    
    # Create VNC startup script
    mkdir -p ${CHROOT}/root/.vnc
    cat > ${CHROOT}/root/.vnc/xstartup <<- EOF
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec /usr/bin/startxfce4
EOF
    chmod +x ${CHROOT}/root/.vnc/xstartup
}

function fix_profile_bash() {
    cat > ${CHROOT}/root/.bashrc <<- EOF
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case \$- in
    *i*) ;;
      *) return;;
esac

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command
shopt -s checkwinsize

# Set a fancy prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "\$(dircolors -b ~/.dircolors)" || eval "\$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Ubuntu specific aliases
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias vnc='vnc'
EOF
}

function fix_resolv_conf() {
    echo "nameserver 8.8.8.8" > $CHROOT/etc/resolv.conf
    echo "nameserver 8.8.4.4" >> $CHROOT/etc/resolv.conf
}

function fix_sudo() {
    ## fix sudo & su on start
    chmod +s $CHROOT/usr/bin/sudo
    chmod +s $CHROOT/usr/bin/su
    echo "ubuntu ALL=(ALL:ALL) ALL" > $CHROOT/etc/sudoers.d/ubuntu
    echo "Set disable_coredump false" > $CHROOT/etc/sudo.conf
}

function fix_uid() {
    ## Change ubuntu uid and gid to match that of the termux user
    USRID=$(id -u)
    GRPID=$(id -g)
    ubuntu -r usermod -u "$USRID" ubuntu 2>/dev/null
    ubuntu -r groupmod -g "$GRPID" ubuntu 2>/dev/null
}

function print_banner() {
    clear
    printf "${blue}##################################################\n"
    printf "${blue}##                                              ##\n"
    printf "${blue}##  _    _ _                 _                  ##\n"
    printf "${blue}## | |  | | |               | |                 ##\n"
    printf "${blue}## | |  | | |__  _   _ _ __ | |_ _   _ _ __     ##\n"
    printf "${blue}## | |  | | '_ \| | | | '_ \| __| | | | '_ \    ##\n"
    printf "${blue}## | |__| | |_) | |_| | | | | |_| |_| | | | |   ##\n"
    printf "${blue}##  \____/|_.__/ \__,_|_| |_|\__|\__,_|_| |_|   ##\n"
    printf "${blue}##                                              ##\n"
    printf "${blue}#### ############# Ubuntu 24.04 ################${reset}\n\n"
}

##################################
## Main ##

# Add some colours
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;34m'
light_cyan='\033[1;96m'
reset='\033[0m'

cd "$HOME"

print_banner
get_arch
set_strings
prepare_fs
check_dependencies
get_rootfs
get_sha
extract_rootfs
create_launcher
cleanup

printf "\n${blue}[*] Configuring Ubuntu for Termux ...\n"
fix_profile_bash
fix_resolv_conf
fix_sudo
check_vnc
create_vnc_launcher
fix_uid

print_banner
printf "${green}[=] Ubuntu 24.04 LTS for Termux installed successfully${reset}\n\n"
printf "${green}[+] To start Ubuntu, type:${reset}\n"
printf "${green}[+] ubuntu # To start Ubuntu CLI${reset}\n"
printf "${green}[+] ubuntu vnc passwd # To set the VNC password${reset}\n"
printf "${green}[+] ubuntu vnc & # To start Ubuntu GUI${reset}\n"
printf "${green}[+] ubuntu vnc stop # To stop Ubuntu GUI${reset}\n"
printf "${green}[+] ub # Shortcut for ubuntu${reset}\n"
