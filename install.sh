#!/bin/bash

# Arch Setup Script for Ideapad Gaming 3 15IMH05 Notebook (Intel + Nvidia + Gnome)

echo 'export PS1="\[\e[32m\]\u@\h:\w\$ \[\e[0m\]"' >> ~/.bashrc
source ~/.bashrc

## Uncomment color and parallel downloads, and enable x86 repo in pacman.conf
sudo sed -i '/^#Color/s/^#//' /etc/pacman.conf
sudo sed -i '/^#ParallelDownloads/s/^#//' /etc/pacman.conf
sudo sed -i '/^\s*#\s*\[multilib\]/s/^#//; /^\s*#\s*Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf
sudo pacman -Syu --noconfirm

## Install Intel Microcode
sudo pacman -S intel-ucode --noconfirm

## Install default video driver
sudo pacman -S mesa --noconfirm

## Install Nvidia driver
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils --noconfirm

## Install Xorg packages
sudo pacman -S xorg-server xorg-xinit --noconfirm

## Install UFW
sudo pacman -S ufw --noconfirm
sudo systemctl enable ufw
sudo systemctl start ufw

## Enable daily TRIM for SSD
sudo systemctl enable fstrim.timer

## Install yay aur helper
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~/

## In case file:// uris don't open in gnome nautilus
xdg-mime default org.gnome.Nautilus.desktop inode/directory

## Install snapd
cd /tmp
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si --noconfirm
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

## Install Postman
sudo snap install postman

## Install Flutter
sudo snap install flutter --classic

## Install Blender
sudo snap install blender --classic

## Install KVM
sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat --noconfirm
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo usermod -aG libvirt $USER
sudo systemctl restart libvirtd.service

## Install Docker desktop
yay -S docker-desktop --noconfirm
systemctl --user disable docker-desktop

## Install Anydesk
yay -S anydesk-bin --noconfirm

## Install Github Desktop
yay -S github-desktop-bin --noconfirm

## Install Google Chrome
yay -S google-chrome --noconfirm

## Install Printer
sudo pacman -Syu cups cups-browsed cups-filters cups-pdf system-config-printer --needed --noconfirm
sudo pacman -Syu ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds --needed --noconfirm
sudo pacman -Syu print-manager --needed --noconfirm
sudo systemctl enable --now cups.socket
sudo systemctl enable --now cups.service

### Network Printer
sudo pacman -S nss-mdns --noconfirm
sudo pacman -Syu avahi --needed --noconfirm
sudo systemctl enable --now avahi-daemon
sudo sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
sudo systemctl restart avahi-daemon NetworkManager
sudo systemctl enable --now cups-browsed.service

echo "System will restart after 10 seconds"
sleep 10
sudo reboot now
