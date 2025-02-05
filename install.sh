#!/bin/bash

# Exit on error
set -e

# System Configuration
configure_system() {
    # Pacman Configuration
    sudo sed -i 's/#Color/Color/' /etc/pacman.conf
    sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf

    # ZRAM Configuration
    echo -e "[zram0]\nzram-size = ram / 2\ncompression-algorithm = lz4" | sudo tee /etc/systemd/zram-generator.conf

    # System Control Settings
    echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-sysctl.conf
    sudo sysctl -p /etc/sysctl.d/99-sysctl.conf

    # Gaming Optimizations
    echo "vm.max_map_count = 2147483642" | sudo tee /etc/sysctl.d/80-gamecompatibility.conf
    sudo sysctl --system

    # Gaming Performance Configuration
    cat << 'EOF' | sudo tee /etc/tmpfiles.d/consistent-response-time-for-gaming.conf
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
w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000
w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000
w /sys/kernel/debug/sched/nr_migrate - - - - 8
EOF
}

# Package Installation
install_packages() {
    # System Packages
    sudo pacman -S --noconfirm git base-devel gnome-terminal intel-ucode mesa lib32-mesa \
        vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader \
        nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader \
        lib32-vulkan-icd-loader xorg-server xorg-xinit flatpak vlc steam papirus-icon-theme \
        tlp tlp-rdw unzip dotnet-sdk mono touchegg jdk gstreamer qemu-full virt-manager \
        virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat cups \
        cups-browsed cups-filters cups-pdf system-config-printer ghostscript gsfonts \
        foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree \
        foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds print-manager \
        nss-mdns avahi bash-completion gnome-browser-connector python-pip python-pipx \
        pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

    # Install yay
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~

    # AUR Packages
    yay -S --noconfirm unityhub visual-studio-code-bin android-studio docker-desktop \
        anydesk-bin github-desktop-bin brave-bin timeshift code-nautilus-git

    # Flatpak Packages
    flatpak install -y com.github.joseexposito.touche org.mozilla.Thunderbird \
        md.obsidian.Obsidian org.telegram.desktop org.libreoffice.LibreOffice \
        org.remmina.Remmina org.gimp.GIMP org.kde.kdenlive org.upscayl.Upscayl \
        com.spotify.Client net.davidotek.pupgui2 \
        com.valvesoftware.Steam.CompatibilityTool.Proton-GE \
        com.heroicgameslauncher.hgl net.lutris.Lutris
}

# Service Configuration
configure_services() {
    # Enable Services
    services=(
        "fstrim.timer"
        "tlp.service"
        "NetworkManager-dispatcher.service"
        "touchegg.service"
        "libvirtd.service"
        "cups.socket"
        "cups.service"
        "avahi-daemon"
        "cups-browsed.service"
        "bluetooth.service"
        "systemd-oomd.service"
    )

    for service in "${services[@]}"; do
        sudo systemctl enable --now "$service"
    done

    # Mask Services
    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
}

# User Configuration
configure_user() {
    # Add user to libvirt group
    sudo usermod -aG libvirt "$USER"

    # Network Configuration
    sudo sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
}

# Audio Configuration
configure_audio() {
    # Enable PipeWire services
    systemctl --user enable pipewire.service
    systemctl --user enable wireplumber.service
    systemctl --user enable pipewire-pulse.service

    # PipeWire Configuration
    mkdir -p ~/.config/pipewire/
    cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
    cat << 'EOF' > ~/.config/pipewire/pipewire.conf
context.properties = {
    default.clock.rate = 192000
    default.clock.allowed-rates = [ 44100 48000 96000 192000 ]
    default.clock.quantum = 1024
    default.clock.min-quantum = 1024
    default.clock.max-quantum = 2048
}
EOF

    # Client Configuration
    cp /usr/share/pipewire/client.conf ~/.config/pipewire/
    cat << 'EOF' > ~/.config/pipewire/client.conf
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

    # WirePlumber Configuration
    mkdir -p ~/.config/wireplumber/main.lua.d/
    cat << 'EOF' > ~/.config/wireplumber/main.lua.d/51-alsa-custom.lua
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

# Main execution
echo "Starting Arch Linux setup..."
configure_system
install_packages
configure_services
configure_user
configure_audio
echo "Setup completed successfully!"
