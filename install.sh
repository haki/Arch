#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
print_status() {
    echo -e "${BLUE}[*] $1...${NC}"
}

print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

print_error() {
    echo -e "${RED}[!] $1${NC}"
}

# Function to execute commands with sudo
run_with_sudo() {
    if [ $# -eq 0 ]; then
        print_error "No command provided to run_with_sudo"
        return 1
    fi
    
    echo -e "${BLUE}[*] This operation requires sudo privileges${NC}"
    sudo "$@"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Don't run this script as root! Run as normal user."
    exit 1
fi

# Create temporary directory for downloads
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to install packages in parallel
install_packages() {
    local packages=("$@")
    print_status "Installing packages: ${packages[*]}"
    run_with_sudo pacman -S --needed --noconfirm "${packages[@]}"
}

# Function to install AUR packages in parallel
install_aur_packages() {
    local packages=("$@")
    print_status "Installing AUR packages: ${packages[*]}"
    yay -S --noconfirm "${packages[@]}"
}

# 1. Configure pacman and update system
print_status "Configuring pacman"
run_with_sudo sed -i -e 's/#Color/Color/' \
                     -e 's/#ParallelDownloads = 5/ParallelDownloads = 10/' \
                     -e '/\[multilib\]/,+1 s/^#//' /etc/pacman.conf

print_status "Updating system"
run_with_sudo pacman -Syu --noconfirm

# 2. Configure ZRAM and sysctl
print_status "Configuring ZRAM"
run_with_sudo tee /etc/systemd/zram-generator.conf > /dev/null << 'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = lz4
EOF

print_status "Configuring sysctl parameters"
run_with_sudo tee /etc/sysctl.d/99-sysctl.conf > /dev/null << 'EOF'
vm.swappiness=10
vm.max_map_count=2147483642
EOF

run_with_sudo sysctl --system

# 3. Install base packages in parallel
base_packages=(
    git base-devel gnome-terminal intel-ucode
    mesa lib32-mesa vulkan-intel lib32-vulkan-intel
    vulkan-icd-loader lib32-vulkan-icd-loader
    nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
    xorg-server xorg-xinit firewalld
)
install_packages "${base_packages[@]}"

# 4. Enable core services
print_status "Enabling system services"
services=(fstrim.timer firewalld systemd-oomd.service)
for service in "${services[@]}"; do
    run_with_sudo systemctl enable "$service"
done

# 5. Install AUR helper (yay) if not present
if ! command -v yay &> /dev/null; then
    print_status "Installing yay AUR helper"
    git clone https://aur.archlinux.org/yay.git "$TEMP_DIR/yay"
    (cd "$TEMP_DIR/yay" && makepkg -si --noconfirm)
fi

# 6. Install multimedia and development packages
multimedia_packages=(
    vlc steam papirus-icon-theme tlp tlp-rdw unzip
    dotnet-sdk mono touchegg flatpak jre17-openjdk jdk17-openjdk
)
install_packages "${multimedia_packages[@]}"

# 7. Install AUR packages in parallel
aur_packages=(
    unityhub visual-studio-code-bin android-studio timeshift
    docker-desktop anydesk-bin github-desktop-bin
    google-chrome microsoft-edge-stable-bin
)
install_aur_packages "${aur_packages[@]}"

# 8. Configure printer support
printer_packages=(
    cups cups-browsed cups-filters cups-pdf system-config-printer
    ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds
    foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint
    foomatic-db-gutenprint-ppds print-manager nss-mdns avahi
)
install_packages "${printer_packages[@]}"

# Enable printer services
printer_services=(cups.socket cups.service avahi-daemon cups-browsed.service)
for service in "${printer_services[@]}"; do
    run_with_sudo systemctl enable --now "$service"
done

# 9. Configure audio with PipeWire
print_status "Configuring PipeWire"
audio_packages=(pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber)
install_packages "${audio_packages[@]}"

mkdir -p ~/.config/pipewire/
cat > ~/.config/pipewire/pipewire.conf << 'EOF'
context.properties = {
    default.clock.rate = 192000
    default.clock.allowed-rates = [ 44100 48000 96000 192000 ]
    default.clock.quantum = 1024
    default.clock.min-quantum = 1024
    default.clock.max-quantum = 2048
}
EOF

# 10. Configure gaming optimizations
print_status "Configuring gaming optimizations"
run_with_sudo tee /etc/tmpfiles.d/gaming-optimizations.conf > /dev/null << 'EOF'
w /proc/sys/vm/compaction_proactiveness - - - - 0
w /proc/sys/vm/watermark_boost_factor - - - - 1
w /proc/sys/vm/min_free_kbytes - - - - 1048576
w /proc/sys/vm/watermark_scale_factor - - - - 500
w /proc/sys/vm/swappiness - - - - 10
w /sys/kernel/mm/lru_gen/enabled - - - - 5
w /proc/sys/vm/zone_reclaim_mode - - - - 0
w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise
w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise
w /sys/kernel/mm/transparent_hugepage/defrag - - - - never
w /proc/sys/vm/page_lock_unfairness - - - - 1
w /proc/sys/kernel/sched_child_runs_first - - - - 0
w /proc/sys/kernel/sched_autogroup_enabled - - - - 1
w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000
EOF

# 11. Install and configure Flatpak applications
flatpak_apps=(
    com.github.joseexposito.touche
    org.mozilla.Thunderbird
    md.obsidian.Obsidian
    org.telegram.desktop
    org.libreoffice.LibreOffice
    org.remmina.Remmina
    com.github.wwmm.easyeffects
    org.gimp.GIMP
    com.discordapp.Discord
    org.kde.kdenlive
    org.upscayl.Upscayl
    com.spotify.Client
    net.davidotek.pupgui2
    com.valvesoftware.Steam.CompatibilityTool.Proton-GE
    com.heroicgameslauncher.hgl
    net.lutris.Lutris
)

print_status "Installing Flatpak applications"
for app in "${flatpak_apps[@]}"; do
    flatpak install -y flathub "$app"
done

print_success "Installation completed successfully!"
echo "Please restart your system to apply all changes"
