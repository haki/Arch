#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error occurred at step: \$1"
    exit 1
}

# Arch Linux Setup for Ideapad Gaming 3 (15IMH05) - Intel + Nvidia + Gnome
# Step 1: Update system
echo "Step 1: Updating system"
sudo pacman -Syu --noconfirm || handle_error "Update system"

# Step 2: Install Base Development Tools and Git
echo "Step 2: Installing Base Development Tools and Git"
sudo pacman -S --noconfirm git base-devel || handle_error "Install Base Development Tools and Git"

# Step 3: Install Intel Microcode
echo "Step 3: Installing Intel Microcode"
sudo pacman -S --noconfirm intel-ucode || handle_error "Install Intel Microcode"

# Step 4: Install Default Video Driver (Mesa)
echo "Step 4: Installing Default Video Driver (Mesa)"
sudo pacman -S --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader || handle_error "Install Default Video Driver (Mesa)"

# Step 5: Install Nvidia Driver
echo "Step 5: Installing Nvidia Driver"
sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader || handle_error "Install Nvidia Driver"

# Step 6: Install Xorg Packages
echo "Step 6: Installing Xorg Packages"
sudo pacman -S --noconfirm xorg-server xorg-xinit || handle_error "Install Xorg Packages"

# Step 7: Install GNOME Terminal
echo "Step 7: Installing GNOME Terminal"
sudo pacman -S --noconfirm gnome-terminal || handle_error "Install GNOME Terminal"

# Step 8: Install yay AUR Helper
echo "Step 8: Installing yay AUR Helper"
cd /tmp || handle_error "Change directory to /tmp"
git clone https://aur.archlinux.org/yay.git || handle_error "Clone yay repository"
cd yay || handle_error "Change directory to yay"
makepkg -si --noconfirm || handle_error "Install yay"
cd ~/

# Step 9: Enable Daily TRIM for SSD
echo "Step 9: Enabling Daily TRIM for SSD"
sudo systemctl enable fstrim.timer || handle_error "Enable Daily TRIM for SSD"

# Step 10: Set Nautilus as Default for inode/directory MIME Type
echo "Step 10: Setting Nautilus as Default for inode/directory MIME Type"
xdg-mime default org.gnome.Nautilus.desktop inode/directory || handle_error "Set Nautilus as Default for inode/directory MIME Type"

# Step 11: Install Snapd
echo "Step 11: Installing Snapd"
cd /tmp || handle_error "Change directory to /tmp"
git clone https://aur.archlinux.org/snapd.git || handle_error "Clone snapd repository"
cd snapd || handle_error "Change directory to snapd"
makepkg -si --noconfirm || handle_error "Install snapd"
sudo systemctl enable --now snapd.socket || handle_error "Enable snapd.socket"
sudo ln -s /var/lib/snapd/snap /snap || handle_error "Create snap symlink"
cd ~/

# Step 12: Install Flatpak
echo "Step 12: Installing Flatpak"
sudo pacman -S --noconfirm flatpak || handle_error "Install Flatpak"

# Step 13: Install Common Applications
echo "Step 13: Installing Common Applications"
sudo pacman -S --noconfirm vlc steam papirus-icon-theme tlp tlp-rdw unzip dotnet-sdk mono touchegg ttf-dejavu ttf-liberation noto-fonts gstreamer || handle_error "Install Common Applications"

# Step 14: Enable TLP Services
echo "Step 14: Enabling TLP Services"
sudo systemctl enable tlp.service || handle_error "Enable tlp.service"
sudo systemctl enable NetworkManager-dispatcher.service || handle_error "Enable NetworkManager-dispatcher.service"
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket || handle_error "Mask systemd-rfkill.service and systemd-rfkill.socket"

# Step 15: Enable Touchegg Service
echo "Step 15: Enabling Touchegg Service"
sudo systemctl enable touchegg.service || handle_error "Enable touchegg.service"
sudo systemctl start touchegg || handle_error "Start touchegg"

# Step 16: Install Unity Hub
echo "Step 16: Installing Unity Hub"
yay -S --noconfirm unityhub || handle_error "Install Unity Hub"

# Step 17: Install Visual Studio Code
echo "Step 17: Installing Visual Studio Code"
yay -S --noconfirm visual-studio-code-bin || handle_error "Install Visual Studio Code"

# Step 18: Install JDK 17
echo "Step 18: Installing JDK 17"
sudo pacman -S --noconfirm jre17-openjdk jdk17-openjdk || handle_error "Install JDK 17"

# Step 19: Install Android Studio
echo "Step 19: Installing Android Studio"
yay -S --noconfirm android-studio || handle_error "Install Android Studio"

# Step 20: Install JetBrains Tools
echo "Step 20: Installing JetBrains Tools"
yay -S --noconfirm rider pycharm-professional || handle_error "Install JetBrains Tools"

# Step 21: Install Timeshift
echo "Step 21: Installing Timeshift"
yay -S --noconfirm timeshift || handle_error "Install Timeshift"
sudo systemctl enable --now cronie.service || handle_error "Enable cronie.service"
sudo crontab -e || handle_error "Edit crontab"

# Step 22: Install Basic Fonts
echo "Step 22: Installing Basic Fonts"
yay -S --noconfirm ttf-ms-win11-auto ttf-adobe-source-fonts || handle_error "Install Basic Fonts"

# Step 23: Install Applications via Flatpak
echo "Step 23: Installing Applications via Flatpak"
flatpak install -y flathub com.github.joseexposito.touche || handle_error "Install touche via Flatpak"
flatpak install -y flathub org.mozilla.Thunderbird || handle_error "Install Thunderbird via Flatpak"
flatpak install -y flathub md.obsidian.Obsidian || handle_error "Install Obsidian via Flatpak"
flatpak install -y flathub org.telegram.desktop || handle_error "Install Telegram via Flatpak"
flatpak install -y flathub org.libreoffice.LibreOffice || handle_error "Install LibreOffice via Flatpak"
flatpak install -y flathub org.remmina.Remmina || handle_error "Install Remmina via Flatpak"
flatpak install -y flathub com.github.wwmm.easyeffects || handle_error "Install EasyEffects via Flatpak"
flatpak install -y flathub org.gimp.GIMP || handle_error "Install GIMP via Flatpak"
flatpak install -y flathub com.discordapp.Discord || handle_error "Install Discord via Flatpak"
flatpak install -y flathub org.kde.kdenlive || handle_error "Install Kdenlive via Flatpak"
flatpak install -y flathub org.upscayl.Upscayl || handle_error "Install Upscayl via Flatpak"
flatpak install -y flathub com.spotify.Client || handle_error "Install Spotify via Flatpak"
flatpak install -y flathub net.davidotek.pupgui2 || handle_error "Install PupGUI2 via Flatpak"
flatpak install -y flathub com.valvesoftware.Steam.CompatibilityTool.Proton-GE || handle_error "Install Proton-GE via Flatpak"
flatpak install -y flathub com.heroicgameslauncher.hgl || handle_error "Install Heroic Games Launcher via Flatpak"
flatpak install -y flathub net.lutris.Lutris || handle_error "Install Lutris via Flatpak"

# Step 24: Install Applications via Snap
echo "Step 24: Installing Applications via Snap"
sudo snap install postman || handle_error "Install Postman via Snap"
sudo snap install flutter --classic || handle_error "Install Flutter via Snap"
sudo snap install blender --classic || handle_error "Install Blender via Snap"

# Step 25: Install KVM
echo "Step 25: Installing KVM"
sudo pacman -S --noconfirm qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat || handle_error "Install KVM"
sudo systemctl enable libvirtd.service || handle_error "Enable libvirtd.service"
sudo systemctl start libvirtd.service || handle_error "Start libvirtd.service"
sudo usermod -aG libvirt $USER || handle_error "Add user to libvirt group"
sudo systemctl restart libvirtd.service || handle_error "Restart libvirtd.service"

# Step 26: Install Docker Desktop
echo "Step 26: Installing Docker Desktop"
yay -S --noconfirm docker-desktop || handle_error "Install Docker Desktop"
systemctl --user disable docker-desktop || handle_error "Disable Docker Desktop"

# Step 27: Install Various Tools
echo "Step 27: Installing Various Tools"
yay -S --noconfirm anydesk-bin github-desktop-bin google-chrome || handle_error "Install Various Tools"

# Step 28: Install Printer Support
echo "Step 28: Installing Printer Support"
sudo pacman -Syu --noconfirm cups cups-browsed cups-filters cups-pdf system-config-printer ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds print-manager --needed || handle_error "Install Printer Support"
sudo systemctl enable --now cups.socket || handle_error "Enable cups.socket"
sudo systemctl enable --now cups.service || handle_error "Enable cups.service"

# Step 29: Enable Network Printer
echo "Step 29: Enabling Network Printer"
sudo pacman -S --noconfirm nss-mdns avahi --needed || handle_error "Install nss-mdns and avahi"
sudo systemctl enable --now avahi-daemon || handle_error "Enable avahi-daemon"
sudo sed -i 's/hosts: mymachines/hosts: mymachines mdns_minimal [NOTFOUND=return]/' /etc/nsswitch.conf || handle_error "Edit /etc/nsswitch.conf"
sudo systemctl restart avahi-daemon NetworkManager || handle_error "Restart avahi-daemon and NetworkManager"
sudo systemctl enable --now cups-browsed.service || handle_error "Enable cups-browsed.service"

# Step 30: Network Manager
echo "Step 30: Installing and Enabling Network Manager"
sudo pacman -S --noconfirm networkmanager || handle_error "Install Network Manager"
sudo systemctl enable NetworkManager.service || handle_error "Enable NetworkManager.service"
sudo systemctl start NetworkManager.service || handle_error "Start NetworkManager.service"

# Step 31: Power Management
echo "Step 31: Installing and Enabling Power Management"
sudo pacman -S --noconfirm thermald || handle_error "Install thermald"
sudo systemctl enable thermald || handle_error "Enable thermald"
sudo systemctl start thermald || handle_error "Start thermald"

# Step 32: Firewall Configuration
echo "Step 32: Configuring Firewall"
sudo pacman -S --noconfirm ufw || handle_error "Install ufw"
sudo systemctl enable ufw || handle_error "Enable ufw"
sudo systemctl start ufw || handle_error "Start ufw"
sudo ufw default deny incoming || handle_error "Set ufw default deny incoming"
sudo ufw default allow outgoing || handle_error "Set ufw default allow outgoing"
sudo ufw allow ssh || handle_error "Allow ssh in ufw"
sudo ufw enable || handle_error "Enable ufw"

# Step 33: Hardware Acceleration for Media
echo "Step 33: Installing Hardware Acceleration for Media"
sudo pacman -S --noconfirm ffmpeg vdpauinfo libva-vdpau-driver libva-utils || handle_error "Install Hardware Acceleration for Media"

# Step 34: Enable Bash Completion
echo "Step 34: Enabling Bash Completion"
sudo pacman -S --noconfirm bash-completion || handle_error "Install bash-completion"

# Step 35: Install GNOME Browser Connector
echo "Step 35: Installing GNOME Browser Connector"
sudo pacman -S --noconfirm gnome-browser-connector || handle_error "Install GNOME Browser Connector"

# Step 36: Enable Bluetooth
echo "Step 36: Enabling Bluetooth"
sudo systemctl enable --now bluetooth.service || handle_error "Enable bluetooth.service"

# Step 37: Install Python Tools
echo "Step 37: Installing Python Tools"
sudo pacman -S --noconfirm python-pip python-pipx || handle_error "Install Python Tools"

# Step 38: Install Easy Effect Presets
echo "Step 38: Installing Easy Effect Presets"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)" || handle_error "Install Easy Effect Presets"

# Step 39: Install Gogh (Terminal Color Schemes)
echo "Step 39: Installing Gogh (Terminal Color Schemes)"
bash -c "$(wget -qO- https://git.io/vQgMr)" || handle_error "Install Gogh"

echo "Arch Linux setup completed successfully!"
