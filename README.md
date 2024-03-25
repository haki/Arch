# Arch
## For my Ideapad Gaming 3 15IMH05 Notebook (Intel + Nvidia + Gnome)

## Uncomment color and parallel downloads, and enable x86 repo in pacman.conf
```
sed -i '/^#Color/s/^#//' /etc/pacman.conf
```
```
sed -i '/^#ParallelDownloads/s/^#//' /etc/pacman.conf
```
```
sed -i '/^\s*#\s*\[multilib\]/s/^#//; /^\s*#\s*Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf
```
```
pacman -Syu
```

## Install Intel Microcode
```
pacman -S intel-ucode
```

## Install default video driver
```
pacman -S mesa
```

## Install Nvidia driver
```
pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils
```

## Install Xorg packages
```
pacman -S xorg-server xorg-xinit
```

## Install UFW
```
pacman -S ufw
```
```
systemctl enable ufw
```
```
systemctl start ufw
```

## Enable daily TRIM for SSD
```
systemctl enable fstrim.timer
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
pacman -S flatpak
```

## Install VLC
```
pacman -S vlc
```

## Install Steam
```
pacman -S steam
```

## Install papirus icon theme
```
pacman -S papirus-icon-theme
```

## Install tlp
```
pacman -S tlp tlp-rdw
```
```
systemctl enable tlp.service
```
```
systemctl enable NetworkManager-dispatcher.service
```
```
systemctl mask systemd-rfkill.service systemd-rfkill.socket
```

## Install unzip
```
pacman -S unzip
```

## Install .Net SDK
```
pacman -S dotnet-sdk
```

## Install mono
```
pacman -S mono
```

## Install touchegg
```
pacman -S touchegg
```
```
systemctl enable touchegg.service
```
```
systemctl start touchegg
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
pacman -S jre17-openjdk jdk17-openjdk
```

## Install Android Studio
```
yay -S android-studio
```

## Install Rider
```
yay -S rider
```

## Install Basic Fonts
```
pacman -S ttf-dejavu ttf-liberation noto-fonts
```
```
yay -S ttf-ms-win11-auto ttf-adobe-source-fonts
```

## Install GStreamer
```
pacman -S gstreamer
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
pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat
```
```
systemctl enable libvirtd.service
```
```
systemctl start libvirtd.service
```
```
usermod -aG libvirt $USER
```
```
systemctl restart libvirtd.service
```

## Install Docker desktop
```
yay -S docker-desktop
```
```
systemctl --user disable docker-desktop
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
pacman -Syu cups cups-browsed cups-filters cups-pdf system-config-printer --needed
```
```
pacman -Syu ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds --needed
```
```
pacman -Syu print-manager --needed
```
```
systemctl enable --now cups.socket
```
```
systemctl enable --now cups.service
```

### Network Printer
```
pacman -S nss-mdns
```
```
pacman -Syu avahi --needed
```
```
systemctl enable --now avahi-daemon
```
```
sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
```
```
systemctl restart avahi-daemon NetworkManager
```
```
systemctl enable --now cups-browsed.service
```
