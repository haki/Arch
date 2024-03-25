#!/bin/bash

# Arch Setup Script for Ideapad Gaming 3 15IMH05 Notebook (Intel + Nvidia + Gnome)

# Set terminal prompt color to green
echo 'export PS1="\[\e[32m\]\u@\h:\w\$ \[\e[0m\]"' >> ~/.bashrc
source ~/.bashrc

# Uncomment color and parallel downloads, and enable Multilib repo in pacman.conf
sudo sed -i '/^#Color/s/^#//' /etc/pacman.conf
sudo sed -i '/^#ParallelDownloads/s/^#//' /etc/pacman.conf
sudo pacman -Syu --noconfirm

# Install essential packages
sudo pacman -S git base-devel gnome-terminal intel-ucode mesa nvidia-dkms nvidia-utils lib32-nvidia-utils xorg-server xorg-xinit ufw qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat cups cups-browsed cups-filters cups-pdf system-config-printer ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds print-manager nss-mdns avahi jre17-openjdk jdk17-openjdk ttf-dejavu ttf-liberation noto-fonts gstreamer --needed --noconfirm

# Enable and start necessary services
sudo systemctl enable ufw fstrim.timer libvirtd.service cups.socket cups.service avahi-daemon cups-browsed.service
sudo systemctl start ufw libvirtd.service cups.socket cups.service avahi-daemon cups-browsed.service

# Configure network printing and services
sudo sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
sudo systemctl restart avahi-daemon NetworkManager

# Install yay if not installed
if ! command -v yay &> /dev/null
then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~/
fi

# Install AUR packages
yay -S docker-desktop anydesk-bin github-desktop-bin google-chrome unityhub visual-studio-code-bin android-studio rider timeshift ttf-ms-win11-auto ttf-adobe-source-fonts --noconfirm

# Disable docker-desktop autostart
systemctl --user disable docker-desktop

# Install Flatpak packages
flatpak install -y flathub com.github.joseexposito.touche org.mozilla.Thunderbird md.obsidian.Obsidian org.telegram.desktop org.libreoffice.LibreOffice org.remmina.Remmina com.github.wwmm.easyeffects org.gimp.GIMP com.discordapp.Discord org.kde.kdenlive org.upscayl.Upscayl com.spotify.Client

echo "System will restart after 10 seconds."
sleep 10
sudo reboot now
