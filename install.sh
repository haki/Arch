#!/bin/bash

# Set strict error handling
set -euo pipefail
IFS=$'\n\t'

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define log file
LOG_FILE="/tmp/arch_setup_$(date +%Y%m%d_%H%M%S).log"

# Helper functions
log() {
    local message="$1"
    echo -e "${GREEN}[INFO]${NC} $message"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" >> "$LOG_FILE"
}

error() {
    local message="$1"
    echo -e "${RED}[ERROR]${NC} $message" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $message" >> "$LOG_FILE"
    exit 1
}

warning() {
    local message="$1"
    echo -e "${YELLOW}[WARNING]${NC} $message"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] $message" >> "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
    fi
}

# Function to handle errors
handle_error() {
    local line_number=$1
    local error_code=$2
    error "Error occurred in script at line $line_number (Error code: $error_code)"
}

trap 'handle_error ${LINENO} $?' ERR

# Check if running as root
check_root

# Create backup of original configuration files
backup_configs() {
    log "Creating backup of configuration files..."
    local backup_dir="/root/config_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # List of files to backup
    local files=(
        "/etc/pacman.conf"
        "/etc/systemd/zram-generator.conf"
        "/etc/sysctl.d/99-sysctl.conf"
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$backup_dir/" || warning "Failed to backup $file"
        fi
    done
    
    log "Backups created in $backup_dir"
}

# Configure pacman
configure_pacman() {
    log "Configuring pacman..."
    
    # Enable color and parallel downloads
    sed -i 's/#Color/Color/' /etc/pacman.conf
    sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
    
    # Enable multilib repository
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    fi
    
    # Update system
    pacman -Syu --noconfirm || error "System update failed"
}

# Configure ZRAM
configure_zram() {
    log "Configuring ZRAM..."
    
    cat > /etc/systemd/zram-generator.conf << EOF
[zram0]
zram-size = ram / 2
compression-algorithm = lz4
EOF
}

# Configure swappiness
configure_swappiness() {
    log "Configuring swappiness..."
    
    echo "vm.swappiness=10" > /etc/sysctl.d/99-sysctl.conf
    sysctl -p /etc/sysctl.d/99-sysctl.conf || warning "Failed to apply swappiness settings"
}

# Install base packages
install_base_packages() {
    log "Installing base packages..."
    
    local packages=(
        "git" "base-devel" "gnome-terminal" "intel-ucode"
        "mesa" "lib32-mesa" "vulkan-intel" "lib32-vulkan-intel"
        "vulkan-icd-loader" "lib32-vulkan-icd-loader"
        "nvidia-dkms" "nvidia-utils" "lib32-nvidia-utils"
        "nvidia-settings" "xorg-server" "xorg-xinit"
        "ufw" "pipewire" "pipewire-alsa" "pipewire-pulse"
        "pipewire-jack" "wireplumber"
    )
    
    pacman -S --needed --noconfirm "${packages[@]}" || error "Failed to install base packages"
}

# Configure services
configure_services() {
    log "Configuring system services..."
    
    local services=(
        "ufw"
        "fstrim.timer"
        "libvirtd"
        "bluetooth"
        "cups.socket"
        "cups.service"
        "avahi-daemon"
    )
    
    for service in "${services[@]}"; do
        systemctl enable "$service" || warning "Failed to enable $service"
        systemctl start "$service" || warning "Failed to start $service"
    done
}

# Install AUR helper (yay)
install_yay() {
    log "Installing yay AUR helper..."
    
    if ! command -v yay &> /dev/null; then
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    else
        log "yay is already installed"
    fi
}

# Install development tools
install_dev_tools() {
    log "Installing development tools..."
    
    # Install from official repos
    pacman -S --needed --noconfirm jre17-openjdk jdk17-openjdk || warning "Failed to install Java"
    
    # Install from AUR
    local aur_packages=(
        "visual-studio-code-bin"
        "android-studio"
        "rider"
        "pycharm-professional"
        "docker-desktop"
        "github-desktop-bin"
    )
    
    for package in "${aur_packages[@]}"; do
        yay -S --needed --noconfirm "$package" || warning "Failed to install $package"
    done
}

# Configure audio
configure_audio() {
    log "Configuring high-quality audio..."
    
    # Create necessary directories
    mkdir -p ~/.config/pipewire/
    mkdir -p ~/.config/wireplumber/main.lua.d/
    
    # Copy and configure PipeWire configs
    cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
    cp /usr/share/pipewire/client.conf ~/.config/pipewire/
    
    # Configure main PipeWire settings
    cat > ~/.config/pipewire/pipewire.conf << EOF
context.properties = {
    default.clock.rate = 192000
    default.clock.allowed-rates = [ 44100 48000 96000 192000 ]
    default.clock.quantum = 1024
    default.clock.min-quantum = 1024
    default.clock.max-quantum = 2048
}
EOF

    # Configure client settings
    cat > ~/.config/pipewire/client.conf << EOF
stream.properties = {
    resample.quality = 15
}

context.modules = [
    { name = libpipewire-module-rt
        args = {
            nice.level = -15
        }
        flags = [ ifexists nofail ]
    }
]
EOF

    # Configure WirePlumber
    cat > ~/.config/wireplumber/main.lua.d/51-alsa-custom.lua << EOF
rule = {
  matches = {
    {
      { "node.name", "matches", "alsa_output.*" },
    },
  },
  apply_properties = {
    ["audio.format"] = "S24_LE",
    ["audio.rate"] = 192000,
    ["api.alsa.period-size"] = 1024,
    ["api.alsa.headroom"] = 16384,
    ["audio.channels"] = 2,
    ["audio.position"] = "FL,FR",
    ["node.latency"] = "1024/192000",
    ["node.pause-on-idle"] = false
  },
}

table.insert(alsa_monitor.rules,rule)
EOF

    # Restart audio services
    systemctl --user restart wireplumber.service pipewire.service pipewire-pulse.service
}

# Install Flatpak applications
install_flatpak_apps() {
    log "Installing Flatpak applications..."
    
    local apps=(
        "com.github.joseexposito.touche"
        "org.mozilla.Thunderbird"
        "md.obsidian.Obsidian"
        "org.telegram.desktop"
        "org.libreoffice.LibreOffice"
        "org.remmina.Remmina"
        "com.github.wwmm.easyeffects"
        "org.gimp.GIMP"
        "com.discordapp.Discord"
        "org.kde.kdenlive"
        "org.upscayl.Upscayl"
        "com.spotify.Client"
        "net.davidotek.pupgui2"
        "com.valvesoftware.Steam.CompatibilityTool.Proton-GE"
        "com.heroicgameslauncher.hgl"
        "net.lutris.Lutris"
    )
    
    for app in "${apps[@]}"; do
        flatpak install -y flathub "$app" || warning "Failed to install $app"
    done
}

# Main execution
main() {
    log "Starting Arch Linux setup script..."
    
    backup_configs
    configure_pacman
    configure_zram
    configure_swappiness
    install_base_packages
    configure_services
    install_yay
    install_dev_tools
    configure_audio
    install_flatpak_apps
    
    log "Setup completed successfully!"
    log "Please check the log file at $LOG_FILE for details"
}

# Execute main function
main
