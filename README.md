# Arch Linux Setup for Ideapad Gaming 3 (15IMH05) - Intel + Nvidia + Gnome

This guide provides a comprehensive setup process for Arch Linux on the Ideapad Gaming 3 (15IMH05), focusing on Intel and Nvidia graphics with Gnome desktop. It includes essential drivers, development tools, and multimedia applications.

## System Preparation
### Enable Color and Parallel Downloads in pacman.conf
```
sudo sed -i '/^#Color/s/^#//' /etc/pacman.conf
sudo sed -i '/^#ParallelDownloads/s/^#//' /etc/pacman.conf
```

### Update system
```
sudo pacman -Syu
```

## Install Base Development Tools and Git
```
sudo pacman -S git base-devel
```

## Installing Graphics Drivers
### Install Intel Microcode
```
sudo pacman -S intel-ucode
```

### Install Default Video Driver (Mesa)
```
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
```

### Install Nvidia Driver
```
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
```

## Xorg and Desktop Environment
### Install Xorg Packages
```
sudo pacman -S xorg-server xorg-xinit
```

### Install GNOME Terminal
```
sudo pacman -S gnome-terminal
```

## AUR Helper Installation
### Install yay AUR Helper
```
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~/
```

## System Optimization
### Enable Daily TRIM for SSD
```
sudo systemctl enable fstrim.timer
```

## Fix Nautilus File URI Handling
### Set Nautilus as Default for inode/directory MIME Type
```
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

## Package Installations
### Install Snapd
```
cd /tmp
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
cd ~/
```

### Install Flatpak
```
sudo pacman -S flatpak
```

### Install Common Applications
```
sudo pacman -S vlc steam papirus-icon-theme tlp tlp-rdw unzip dotnet-sdk mono touchegg ttf-dejavu ttf-liberation noto-fonts gstreamer
```

### Enable TLP Services
```
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
```

### Enable Touchegg Service
```
sudo systemctl enable touchegg.service
sudo systemctl start touchegg
```

## Install Development Tools
### Install Unity Hub
```
yay -S unityhub
```

### Install Visual Studio Code
```
yay -S visual-studio-code-bin
```

### Install JDK 17
```
sudo pacman -S jre17-openjdk jdk17-openjdk
```

### Install Android Studio
```
yay -S android-studio
```

### Install JetBrains Tools
```
yay -S rider pycharm-professional
```

### Install Timeshift
```
yay -S timeshift
sudo systemctl enable --now cronie.service
sudo crontab -e
```

### Install Basic Fonts
```
yay -S ttf-ms-win11-auto ttf-adobe-source-fonts
```

## Multimedia Applications
### Install Applications via Flatpak
```
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
flatpak install -y flathub com.valvesoftware.Steam.CompatibilityTool.Proton-GE
flatpak install -y flathub com.heroicgameslauncher.hgl
flatpak install -y flathub net.lutris.Lutris
```

### Install Applications via Snap
```
sudo snap install postman
sudo snap install flutter --classic
sudo snap install blender --classic
```

## Virtualization
## Install KVM
```
sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo usermod -aG libvirt $USER
sudo systemctl restart libvirtd.service
```

## Additional Tools
### Install Docker Desktop
```
yay -S docker-desktop
systemctl --user disable docker-desktop
```

### Install Various Tools
```
yay -S anydesk-bin github-desktop-bin google-chrome
```

### Install Printer Support
```
sudo pacman -Syu cups cups-browsed cups-filters cups-pdf system-config-printer ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds print-manager --needed
sudo systemctl enable --now cups.socket
sudo systemctl enable --now cups.service
```

### Enable Network Printer
```
sudo pacman -S nss-mdns avahi --needed
sudo systemctl enable --now avahi-daemon
sudo sed -i 's/hosts: mymachines/hosts: mymachines mdns_minimal [NOTFOUND=return]/' /etc/nsswitch.conf
sudo systemctl restart avahi-daemon NetworkManager
sudo systemctl enable --now cups-browsed.service
```

## Network Manager
```
sudo pacman -S networkmanager
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
```

## Power Management:
```
sudo pacman -S thermald
sudo systemctl enable thermald
sudo systemctl start thermald
```

## Firewall Configuration
```
sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
```

## Hardware Acceleration for Media
```
sudo pacman -S ffmpeg vdpauinfo libva-vdpau-driver libva-utils
```

## Shell and Browser Enhancements
### Enable Bash Completion
```
sudo pacman -S bash-completion
```

### Install GNOME Browser Connector
```
sudo pacman -S gnome-browser-connector
```

## Bluetooth and Python Tools
### Enable Bluetooth
```
sudo systemctl enable --now bluetooth.service
```

### Install Python Tools
```
sudo pacman -S python-pip python-pipx
```

## Additional Customizations
### Install Easy Effect Presets
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)"
```

### Install Gogh (Terminal Color Schemes)
```
bash -c "$(wget -qO- https://git.io/vQgMr)"
```
