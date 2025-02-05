# Arch Linux Setup Guide

## System Configuration

### Pacman Configuration
```bash
# Edit /etc/pacman.conf
# Uncomment Color
# Uncomment and modify ParallelDownloads
ParallelDownloads = 10
```

### ZRAM Configuration
```bash
# Create/Edit /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = lz4
```

### System Control Settings
```bash
# Add to /etc/sysctl.d/99-sysctl.conf
vm.swappiness=10

# Apply changes
sudo sysctl -p /etc/sysctl.d/99-sysctl.conf
```

### Gaming Optimizations
```bash
# Create/Edit /etc/sysctl.d/80-gamecompatibility.conf
vm.max_map_count = 2147483642
sudo sysctl --system

# Create/Edit /etc/tmpfiles.d/consistent-response-time-for-gaming.conf
#    Path                  Mode UID  GID  Age Argument
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
```

## Package Installation

### System Packages
```bash
sudo pacman -S git base-devel gnome-terminal intel-ucode mesa lib32-mesa vulkan-intel \
    lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader nvidia-dkms nvidia-utils \
    lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader xorg-server \
    xorg-xinit flatpak vlc steam papirus-icon-theme tlp tlp-rdw unzip dotnet-sdk mono \
    touchegg jdk gstreamer qemu-full virt-manager virt-viewer dnsmasq bridge-utils \
    libguestfs ebtables vde2 openbsd-netcat cups cups-browsed cups-filters cups-pdf \
    system-config-printer ghostscript gsfonts foomatic-db-engine foomatic-db \
    foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint \
    foomatic-db-gutenprint-ppds print-manager nss-mdns avahi bash-completion \
    gnome-browser-connector python-pip python-pipx
```

### AUR Helper Installation (yay)
```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
```

### AUR Packages
```bash
yay -S unityhub visual-studio-code-bin android-studio docker-desktop anydesk-bin \
    github-desktop-bin brave-bin timeshift code-nautilus-git
```

### Flatpak Packages
```bash
flatpak install com.github.joseexposito.touche org.mozilla.Thunderbird \
    md.obsidian.Obsidian org.telegram.desktop org.libreoffice.LibreOffice \
    org.remmina.Remmina org.gimp.GIMP org.kde.kdenlive org.upscayl.Upscayl \
    com.spotify.Client net.davidotek.pupgui2 \
    com.valvesoftware.Steam.CompatibilityTool.Proton-GE \
    com.heroicgameslauncher.hgl net.lutris.Lutris
```

## Service Configuration

### Enable Services
```bash
sudo systemctl enable --now fstrim.timer
sudo systemctl enable --now tlp.service
sudo systemctl enable --now NetworkManager-dispatcher.service
sudo systemctl enable --now touchegg.service
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now cups.socket
sudo systemctl enable --now cups.service
sudo systemctl enable --now avahi-daemon
sudo systemctl enable --now cups-browsed.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now systemd-oomd.service
```

### Mask Services
```bash
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
```

## User Configuration

### Group Management
```bash
sudo usermod -aG libvirt $USER
```

### Network Configuration
```bash
sudo sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
```

### GNOME Keyboard Shortcuts
Navigate to Settings > Keyboard > View and Customize Shortcuts:

Navigation:
- Move window one workspace to the left: Shift + Super + Q
- Move window one workspace to the right: Shift + Super + E
- Switch applications: Disabled
- Switch to workspace on the left: Super + Q
- Switch to workspace on the right: Super + E
- Switch windows: Alt + Tab

System:
- Show all apps: Disabled
- Show the run command prompt: Alt + F12

Custom:
- Open terminal (gnome-terminal): Alt + Return
- Playerctl next (playerctl next): Audio next
- Playerctl play/pause (playerctl play-pause): Audio play
- Playerctl previous (playerctl previous): Audio previous

## Audio Configuration

### PipeWire Installation and Service Setup
```bash
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
systemctl --user enable pipewire.service
systemctl --user enable wireplumber.service
systemctl --user enable pipewire-pulse.service
```

### High Quality Audio Configuration

1. PipeWire Main Configuration:
```bash
mkdir -p ~/.config/pipewire/
cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
```

Edit `~/.config/pipewire/pipewire.conf`:
```conf
context.properties = {
    default.clock.rate = 192000             # Highest sampling rate
    default.clock.allowed-rates = [ 44100 48000 96000 192000 ]
    default.clock.quantum = 1024            # Buffer size for better quality
    default.clock.min-quantum = 1024
    default.clock.max-quantum = 2048        # More flexibility
}
```

2. Client Configuration:
```bash
cp /usr/share/pipewire/client.conf ~/.config/pipewire/
```

Edit `~/.config/pipewire/client.conf`:
```conf
stream.properties = {
    resample.quality = 15                   # Highest resampling quality
}

context.modules = [
    { name = libpipewire-module-rt
        args = {
            nice.level = -15                # Higher CPU priority
        }
        flags = [ ifexists nofail ]
    }
]
```

3. WirePlumber Configuration:
```bash
mkdir -p ~/.config/wireplumber/main.lua.d/
touch ~/.config/wireplumber/main.lua.d/51-alsa-custom.lua
```

Content for `51-alsa-custom.lua`:
```lua
rule = {
  matches = {
    {
      { "node.name", "matches", "alsa_output.*" },
    },
  },
  apply_properties = {
    ["audio.format"] = "S24_LE",           # 24-bit audio quality
    ["audio.rate"] = 192000,               # Highest sampling rate
    ["api.alsa.period-size"] = 1024,       # Larger buffer size
    ["api.alsa.headroom"] = 16384,         # More headroom
    ["audio.channels"] = 2,
    ["audio.position"] = "FL,FR",
    ["node.latency"] = "1024/192000",      # Optimized latency
    ["node.pause-on-idle"] = false         # Continuous audio output
  },
}

table.insert(alsa_monitor.rules,rule)
```

4. Apply Configuration:
```bash
systemctl --user restart wireplumber.service pipewire.service pipewire-pulse.service
```

Note: If you experience audio stuttering, adjust these values:
- clock.rate and audio.rate: 96000
- resample.quality: 10
- quantum and period-size: 512
- node.latency: "512/96000"
