#!/bin/bash

#Make it so user doesn't have to type password to use sudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

#Rank mirrors
sudo pacman -S reflector --noconfirm
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

#Perform upgrade
sudo pacman -Syu

packages=(
    niri
    hyprlock
    hypridle
    brightnessctl
    socat
    jq
    fd
    nwg-look
    ttf-jetbrains-mono-nerd
    imagemagick
    blueman
    bluez
    bluez-libs
    bluez-utils
    ttf-fira-code
    inter-font
    eza
    gvfs-smb
    tumbler
    xdg-user-dirs
    flatpak
    greetd
    kitty
    thunar
    file-roller
    thunar-archive-plugin
    firefox
    kate
    bitwarden
    cliphist
    fzf
    nano
    fastfetch
    networkmanager
    network-manager-applet
    cmake
    meson
    cpio
    pkgconf
    gparted
    tlp
    mesa
    lib32-mesa
    vulkan-radeon
    lib32-vulkan-radeon
    libva-utils
    ntfs-3g
    gnome-keyring
    libsecret
    go
    obsidian
    mission-center
    adw-gtk-theme
    zoxide
)

#Install the needed pacman packages
for package in ${packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done

#Install yay (AUR helper)
git clone https://aur.archlinux.org/yay.git ~/builds/yay
cd ~/builds/yay
makepkg -si --noconfirm --needed

#Create user directories in home folder
xdg-user-dirs-update

#Add Flatpak repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#flatpakages=(
#)

#Install flatpak packages
#for package in ${flatpakages[@]}; do
#    flatpak install flathub ${package} --noninteractive
#done

#Install Segoe UI font
#git clone https://github.com/mrbvrz/segoe-ui-linux ~/builds/segoe-ui-linux
#cd ~/builds/segoe-ui-linux
#chmod +x install.sh
#./install.sh

#Install Tela icons
#git clone https://github.com/vinceliuice/Tela-icon-theme ~/builds/Tela-icon-theme
#cd ~/builds/Tela-icon-theme
#chmod +x install.sh
#./install.sh grey

yaypackages=(
    niriswitcher
    libinput-gestures
    swayosd-git
    qimgv-git
    wofi
    google-chrome
    waybar
    wlogout
    wallust
    asusctl
    localsend-bin
    pwvucontrol
)

#Try to install all yay packages at once
yay -S --noconfirm --removemake --cleanafter "${yaypackages[@]}"

#Check for missing packages and install any that are found
for pkg in "${yaypackages[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
        echo "Retrying installation of missing package: $pkg"
        yay -S --noconfirm --removemake --cleanafter "$pkg"
    fi
done

#Add to input and video group for libinput-gestures
sudo gpasswd -a $USER input

#And the video group too
sudo gpasswd -a $USER video

#Copy the .config dot files (~/.config)
mkdir -p ~/.config/
cp -r ~/builds/niridots/config/* ~/.config/

#Copy the .local dot files (~/.local)
mkdir -p ~/.local/
cp -r ~/builds/niridots/.local/* ~/.local/

#Copy the .icons dot files (~/.icons)
mkdir -p ~/.icons/
cp -r ~/builds/niridots/.icons/* ~/.icons/

#Copy .bashrc to home (~)
cp -r ~/builds/niridots/home/.bashrc ~/

#Copy the /etc files (/etc)
sudo cp -r ~/builds/niridots/etc/* /etc/

#Make scripts executable
#chmod +x ~/.config/hypr/scripts/*
#chmod +x ~/.config/hypr/UserScripts/*

#Set defaults
xdg-mime default thunar.desktop inode/directory
xdg-mime default org.kde.kate.desktop application/json text/plain text/x-shellscript
xdg-mime default qimgv.desktop image/png image/jpeg

#Install hyprshot-gui
curl -fsSL https://raw.githubusercontent.com/s-adi-dev/hyprshot-gui/main/install.sh | bash

#GTK settings
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'Inter Display Light 10'
#gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"

#Enable TLP
sudo systemctl enable --now tlp.service
sudo tlp start

#Enable services
services=(
    greetd.service
    bluetooth.service
    NetworkManager.service
)

#Enable services
for service in ${services[@]}; do
    sudo systemctl enable ${service}
done

#Network Manager config - was maybe more stable this way with Mediatek wifi
#sudo systemctl enable iwd
#sudo systemctl disable wpa_supplicant

echo
echo -e "\e[33mDONE. You should reboot now.\e[0m"
