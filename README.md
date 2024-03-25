# Arch
# For my Ideapad Gaming 3 15IMH05 Notebook (Intel + Nvidia + Gnome)

## Uncomment color and parallel downloads, and enable x86 repo in pacman.conf
```
sudo sed -i '/^#Color/s/^#//' /etc/pacman.conf
```
```
sudo sed -i '/^#ParallelDownloads/s/^#//' /etc/pacman.conf
```
```
sudo sed -i '/^#\[multilib\]/s/^#//' /etc/pacman.conf
```
```
sudo sed -i '/^\s*#\s*\[multilib\]/s/^#//; /^\s*#\s*Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf
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

## Install papirus icon theme
```
pacman -S papirus-icon-theme
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
