# Comprehensive Arch Linux Setup Guide for Ideapad Gaming 3 (15IMH05)

This guide provides a detailed setup process for Arch Linux on the Ideapad Gaming 3 (15IMH05), focusing on Intel and Nvidia graphics with the Gnome desktop. It includes essential drivers, development tools, and multimedia applications.

## System Preparation

### Modify pacman.conf
Uncomment color and parallel downloads, and enable the multilib repository:

```bash
sudo nano /etc/pacman.conf
```

Add or uncomment these lines:
```
# Misc options
Color
ParallelDownloads = 5

[multilib]
Include = /etc/pacman.d/mirrorlist
```

### Update system
```bash
sudo pacman -Syu
```

### Review ZRAM Settings
```bash
sudo nano /etc/systemd/zram-generator.conf
```

Add or modify:
```
[zram0]
zram-size = ram / 2
compression-algorithm = lz4
```

### Set Swappiness Value
```bash
sudo nano /etc/sysctl.d/99-sysctl.conf
```

Add:
```
vm.swappiness=10
```

Apply changes:
```bash
sudo sysctl -p /etc/sysctl.d/99-sysctl.conf
```

## Install Essential Packages

### Base Development Tools and Git
```bash
sudo pacman -S git base-devel
```

### Gnome Terminal
```bash
sudo pacman -S gnome-terminal
```

### Intel Microcode
```bash
sudo pacman -S intel-ucode
```

### Video Drivers
```bash
sudo pacman -S mesa
sudo pacman -S --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
```

### Xorg Packages
```bash
sudo pacman -S xorg-server xorg-xinit
```

### UFW (Uncomplicated Firewall)
```bash
sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
```

### Enable TRIM for SSD
```bash
sudo systemctl enable fstrim.timer
```

## Install AUR Helper (yay)
```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
```

### Fix file:// URIs in Gnome Nautilus (if needed)
```bash
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

## Install Additional Package Managers

### Snapd
```bash
cd /tmp
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
cd ~
```

### Flatpak
```bash
sudo pacman -S flatpak
```

## Install Multimedia and Utility Software

```bash
sudo pacman -S vlc steam papirus-icon-theme tlp tlp-rdw unzip dotnet-sdk mono touchegg
```

Enable services:
```bash
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
sudo systemctl enable touchegg.service
sudo systemctl start touchegg
```

## Install Development Tools

```bash
yay -S unityhub visual-studio-code-bin android-studio rider pycharm-professional
sudo pacman -S jre17-openjdk jdk17-openjdk
```

## Install System Utilities

```bash
yay -S timeshift
```

## Install Fonts

```bash
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts
yay -S ttf-ms-win11-auto ttf-adobe-source-fonts
```

## Install Multimedia Codecs

```bash
sudo pacman -S gstreamer
```

## Install Flatpak Applications

```bash
flatpak install -y flathub com.github.joseexposito.touche
flatpak install -y flathub org.mozilla.Thunderbird
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub org.libreoffice.LibreOffice 
flatpak install -y flathub org.remmina.Remmina
flatpak install -y flathub com.github.wwmm.easyeffects
flatpak install -y flathub org.gimp.GIMP
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub org.kde.kdenlive
flatpak install -y flathub org.upscayl.Upscayl
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub net.davidotek.pupgui2
flatpak install -y com.valvesoftware.Steam.CompatibilityTool.Proton-GE
flatpak install -y flathub com.heroicgameslauncher.hgl
flatpak install -y flathub net.lutris.Lutris
```

## Install Snap Applications

```bash
sudo snap install postman
sudo snap install flutter --classic
sudo snap install blender --classic
```

## Install Virtualization Tools

```bash
sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo usermod -aG libvirt $USER
sudo systemctl restart libvirtd.service
```

## Install Additional Software

```bash
yay -S docker-desktop anydesk-bin github-desktop-bin google-chrome
systemctl --user disable docker-desktop
```

## Install Printer Support

```bash
sudo pacman -S cups cups-browsed cups-filters cups-pdf system-config-printer ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds print-manager
sudo systemctl enable --now cups.socket
sudo systemctl enable --now cups.service
```

### Network Printer Support

```bash
sudo pacman -S nss-mdns avahi
sudo systemctl enable --now avahi-daemon
sudo sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
sudo systemctl restart avahi-daemon NetworkManager
sudo systemctl enable --now cups-browsed.service
```

## Additional Utilities and Settings

```bash
sudo pacman -S bash-completion gnome-browser-connector python-pip python-pipx
sudo systemctl enable --now bluetooth.service
```

### Install Easy Effect Presets

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)"
```

### Install Gogh (Terminal Color Schemes)

```bash
bash -c "$(wget -qO- https://git.io/vQgMr)"
```
## Audio Configuration for High Quality Output

### PipeWire Setup
```bash
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
systemctl --user enable pipewire.service
systemctl --user enable wireplumber.service
systemctl --user enable pipewire-pulse.service
```

### High Quality Audio Configuration

1. PipeWire main configuration:
```bash
mkdir -p ~/.config/pipewire/
cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
```

Edit `~/.config/pipewire/pipewire.conf`:
```
context.properties = {
    default.clock.rate = 192000             # Highest sampling rate
    default.clock.allowed-rates = [ 44100 48000 96000 192000 ]
    default.clock.quantum = 1024            # Buffer size for better quality
    default.clock.min-quantum = 1024
    default.clock.max-quantum = 2048        # More flexibility
}
```

2. Client configuration:
```bash
cp /usr/share/pipewire/client.conf ~/.config/pipewire/
```

Edit `~/.config/pipewire/client.conf`:
```
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

3. WirePlumber configuration:
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

4. Restart services:
```bash
systemctl --user restart wireplumber.service pipewire.service pipewire-pulse.service
```

This configuration provides:
- 192kHz sampling rate
- 24-bit audio depth
- Maximum resampling quality
- Optimized buffer and latency
- Maximum CPU priority

If you experience audio stuttering, you can lower these values to:
- clock.rate and audio.rate: 96000
- resample.quality: 10
- quantum and period-size: 512
- node.latency: "512/96000"
