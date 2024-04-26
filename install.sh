# Uncomment color and parallel downloads, and enable x86 repo in pacman.conf
sed -i '/^#Color/s/^#//' /etc/pacman.conf
sed -i '/^#ParallelDownloads/s/^#//' /etc/pacman.conf

# Update system
pacman -Syu --noconfirm

# Install base-devel and git
pacman -S --noconfirm git base-devel

# Install Gnome Terminal
pacman -S --noconfirm gnome-terminal

# Install Intel Microcode
pacman -S --noconfirm intel-ucode

# Install default video driver
pacman -S --noconfirm mesa

# Install Nvidia driver
pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils

# Install Xorg packages
pacman -S --noconfirm xorg-server xorg-xinit

# Install UFW
pacman -S --noconfirm ufw
systemctl enable ufw
systemctl start ufw

# Enable daily TRIM for SSD
systemctl enable fstrim.timer

# Install yay AUR helper
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~/

# In case file:// URIs don't open in Gnome Nautilus
xdg-mime default org.gnome.Nautilus.desktop inode/directory

# Install snapd
cd /tmp
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si --noconfirm
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
cd ~/

# Install Flatpak
pacman -S --noconfirm flatpak

# Install VLC
pacman -S --noconfirm vlc

# Install Steam
pacman -S --noconfirm steam

# Install Papirus icon theme
pacman -S --noconfirm papirus-icon-theme

# Install TLP
pacman -S --noconfirm tlp tlp-rdw
systemctl enable tlp.service
systemctl enable NetworkManager-dispatcher.service
systemctl mask systemd-rfkill.service systemd-rfkill.socket

# Install unzip
pacman -S --noconfirm unzip

# Install .NET SDK
pacman -S --noconfirm dotnet-sdk

# Install Mono
pacman -S --noconfirm mono

# Install Touchegg
pacman -S --noconfirm touchegg
systemctl enable touchegg.service
systemctl start touchegg

# Install Unity Hub
yay -S --noconfirm unityhub

# Install Visual Studio Code
yay -S --noconfirm visual-studio-code-bin

# Install JDK 17
pacman -S --noconfirm jre17-openjdk jdk17-openjdk

# Install Android Studio
yay -S --noconfirm android-studio

# Install Rider
yay -S --noconfirm rider

# Install Timeshift
yay -S --noconfirm timeshift

# Install Basic Fonts
pacman -S --noconfirm ttf-dejavu ttf-liberation noto-fonts
yay -S --noconfirm ttf-ms-win11-auto ttf-adobe-source-fonts

# Install GStreamer
pacman -S --noconfirm gstreamer

# Install Touche
flatpak install -y flathub com.github.joseexposito.touche

# Install Thunderbird
flatpak install -y flathub org.mozilla.Thunderbird

# Install Obsidian
flatpak install -y flathub md.obsidian.Obsidian

# Install Telegram
flatpak install -y flathub org.telegram.desktop

# Install LibreOffice
flatpak install -y flathub org.libreoffice.LibreOffice

# Install Remmina
flatpak install -y flathub org.remmina.Remmina

# Install Easyeffects
flatpak install -y flathub com.github.wwmm.easyeffects

# Install Gimp
flatpak install -y flathub org.gimp.GIMP

# Install Discord
flatpak install -y flathub com.discordapp.Discord

# Install Kdenlive
flatpak install -y flathub org.kde.kdenlive

# Install Upscayl
flatpak install -y flathub org.upscayl.Upscayl

# Install Spotify
flatpak install -y flathub com.spotify.Client

# Install Postman
sudo snap install postman

# Install Flutter
sudo snap install flutter --classic

# Install Blender
sudo snap install blender --classic

# Install KVM
pacman -S --noconfirm qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat
systemctl enable libvirtd.service
systemctl start libvirtd.service
usermod -aG libvirt $USER
systemctl restart libvirtd.service

# Install Docker desktop
yay -S --noconfirm docker-desktop
systemctl --user disable docker-desktop

# Install Anydesk
yay -S --noconfirm anydesk-bin

# Install Github Desktop
yay -S --noconfirm github-desktop-bin

# Install Google Chrome
yay -S --noconfirm google-chrome

# Install Printer
pacman -Syu --noconfirm cups cups-browsed cups-filters cups-pdf system-config-printer
pacman -Syu --noconfirm ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds
pacman -Syu --noconfirm print-manager
systemctl enable --now cups.socket
systemctl enable --now cups.service

# Network Printer
pacman -S --noconfirm nss-mdns
pacman -Syu --noconfirm avahi
systemctl enable --now avahi-daemon
sed -i 's/hosts: mymachines /hosts: mymachines mdns_minimal [NOTFOUND=return] /' /etc/nsswitch.conf
systemctl restart avahi-daemon NetworkManager
systemctl enable --now cups-browsed.service

# Bash Completion
pacman -S --noconfirm bash-completion

# Bluetooth module
systemctl enable --now bluetooth.service
