This guide provides a comprehensive setup process for Arch Linux on the Ideapad Gaming 3 (15IMH05), focusing on Intel and Nvidia graphics with Gnome desktop. It includes essential drivers, development tools, and multimedia applications.

## System Preparation

## Uncomment color and parallel downloads, and enable x86 repo in pacman.conf
```bash
sudo nano /etc/pacman.conf
```
```bash
# Misc options
Color
ParallelDownloads = 5

[multilib]
Include = /etc/pacman.d/mirrorlist
```

## Update system
```bash
sudo pacman -Syu
```

## Reviewing ZRAM Settings
```bash
sudo nano /etc/systemd/zram-generator.conf
```
```
[zram0]
zram-size = ram / 2
compression-algorithm = lz4
```

## Setting the Swappiness Value
```bash
sudo nano /etc/sysctl.d/99-sysctl.conf
```
```
vm.swappiness=10
```
```bash
sudo sysctl -p /etc/sysctl.d/99-sysctl.conf
```

## Install Base Development Tools and Git
```
sudo pacman -S git base-devel
```

## Install Gnome Terminal
```
sudo pacman -S gnome-terminal
```

## Install Intel Microcode
```
sudo pacman -S intel-ucode
```

## Install default video driver
```
sudo pacman -S mesa
sudo pacman -S --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
```

## Install Nvidia driver
```
sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
```

## Install Xorg packages
```
sudo pacman -S xorg-server xorg-xinit
```

## Install UFW
```
sudo pacman -S ufw
```
```
sudo systemctl enable ufw
```
```
sudo systemctl start ufw
```

## Enable daily TRIM for SSD
```
sudo systemctl enable fstrim.timer
```

## Install yay aur helper
```
cd /tmp
```
```
git clone https://aur.archlinux.org/yay.git
```
```
cd /tmp/yay
```
```
makepkg -si
```
```
cd ~/
```

## Incase file:// uris dont open in gnome nautilus
```
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

## Install snapd
```
cd /tmp
```
```
git clone https://aur.archlinux.org/snapd.git
```
```
cd /tmp/snapd
```
```
makepkg -si
```
```
sudo systemctl enable --now snapd.socket
```
```
sudo ln -s /var/lib/snapd/snap /snap
```
```
cd ~/
```

## Install Flatpak
```
sudo pacman -S flatpak
```

## Install VLC
```
sudo pacman -S vlc
```

## Install Steam
```
sudo pacman -S steam
```

## Install papirus icon theme
```
sudo pacman -S papirus-icon-theme
```

## Install tlp
```
sudo pacman -S tlp tlp-rdw
```
```
sudo systemctl enable tlp.service
```
```
sudo systemctl enable NetworkManager-dispatcher.service
```
```
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
```

## Install unzip
```
sudo pacman -S unzip
```

## Install .Net SDK
```
sudo pacman -S dotnet-sdk
```

## Install mono
```
sudo pacman -S mono
```

## Install touchegg
```
sudo pacman -S touchegg
```
```
sudo systemctl enable touchegg.service
```
```
sudo systemctl start touchegg
```

## Install Unity Hub
```
yay -S unityhub
```

## Install Visual Studio Code
```
yay -S visual-studio-code-bin
```

## Install JDK 17
```
sudo pacman -S jre17-openjdk jdk17-openjdk
```

## Install Android Studio
```
yay -S android-studio
```

## Install Rider
```
yay -S rider
```

## Install Pycharm
```
yay -S pycharm-professional
```

## Install Timeshift
```
yay -S timeshift 
```

## Install Basic Fonts
```
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts
```
```
yay -S ttf-ms-win11-auto ttf-adobe-source-fonts
```

## Install GStreamer
```
sudo pacman -S gstreamer
```

## Install Touche
```
flatpak install -y flathub com.github.joseexposito.touche
```

## Install Thunderbird
```
flatpak install -y flathub org.mozilla.Thunderbird
```

## Install Obisidian
```
flatpak install -y flathub md.obsidian.Obsidian
```

## Install Telegram
```
flatpak install -y flathub org.telegram.desktop
```

## Install Libreoffice
```
flatpak install -y flathub org.libreoffice.LibreOffice 
```

## Install Remmina
```
flatpak install -y flathub org.remmina.Remmina
```

## Install Easyeffects
```
flatpak install -y flathub com.github.wwmm.easyeffects
```

## Install Gimp
```
flatpak install -y flathub org.gimp.GIMP
```

## Install Discord
```
flatpak install -y flathub com.discordapp.Discord
```

## Install Kdenlive
```
flatpak install -y flathub org.kde.kdenlive
```

## Install Upscayl
```
flatpak install -y flathub org.upscayl.Upscayl
```

## Install Spotify
```
flatpak install -y flathub com.spotify.Client
```

## Install Proton GE
```
flatpak install -y flathub net.davidotek.pupgui2
flatpak install -y com.valvesoftware.Steam.CompatibilityTool.Proton-GE
```

## Heroic Games Launcher
```
flatpak install -y flathub com.heroicgameslauncher.hgl
```

## Lutris
```
flatpak install -y flathub net.lutris.Lutris
```

## Install Postman
```
sudo snap install postman
```

## Install Flutter
```
sudo snap install flutter --classic
```

## Install Blender
```
sudo snap install blender --classic
```

## Install KVM
```
sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat
```
```
sudo systemctl enable libvirtd.service
```
```
sudo systemctl start libvirtd.service
```
```
usermod -aG libvirt $USER
```
```
sudo systemctl restart libvirtd.service
```

## Install Docker desktop
```
yay -S docker-desktop
```
```
sudo systemctl --user disable docker-desktop
```

## Install Anydesk
```
yay -S anydesk-bin
```

## Install Github Desktop
```
yay -S github-desktop-bin
```

## Install Google Chrome
```
yay -S google-chrome
```

## Install Printer
```
sudo pacman -Syu cups cups-browsed cups-filters cups-pdf system-config-printer --needed
```
```
sudo pacman -Syu ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds --needed
```
```
sudo pacman -Syu print-manager --needed
```
```
sudo systemctl enable --now cups.socket
```
```
sudo systemctl enable --now cups.service
```

### Network Printer
```
sudo pacman -S nss-mdns
```
```
sudo pacman -Syu avahi --needed
```
```
sudo systemctl enable --now avahi-daemon
```
```
sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
```
```
sudo systemctl restart avahi-daemon NetworkManager
```
```
sudo systemctl enable --now cups-browsed.service
```

### Bash Completion
```
sudo pacman -S bash-completion
```

### Gnome Browser Connector
```
sudo pacman -S gnome-browser-connector
```

### Bluetooth module
```
sudo systemctl enable --now bluetooth.service
```

### Python pip
```
sudo pacman -S python-pip
```

### Python pipx
```
sudo pacman -S python-pipx
```

### Easy Effect Presets
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)"
```

### Gogh
```
bash -c "$(wget -qO- https://git.io/vQgMr)"
```
