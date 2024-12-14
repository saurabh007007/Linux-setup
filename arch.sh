# !/bin/bash
# This file is used to setup Manjro for my setup
# the commands for verbose and redundant for better calrity

set -e  # Exit on error

current_dir=$(pwd)

#pacman updates & installing rust up
sudo pacman -Syu base-devel --noconfirm

curl https://sh.rustup.rs -sSf | sh -s -- -y --profile default --default-toolchain stable
source $HOME/.cargo/env


# Install Paru if not already installed
if ! command -v paru &> /dev/null
then
    echo "Paru not found. Installing Paru..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
fi

####------------------------------------------------------ installng software ------------------------------------------------------####

install_apps() {
    # Define the path to apps.txt
    APPS_FILE="$current_dir/common/applist.txt"
    
    # Read the list of apps from apps.txt
    mapfile -t apps < "$APPS_FILE"
    
    # Install all apps in parallel using paru
    paru -S --noconfirm --sudoloop "${apps[@]}"
}

install_apps

#installing foundry
curl -L https://foundry.paradigm.xyz | bash

#installing nerd-fonts
sudo pacman -S $(pacman -Sgq nerd-fonts) --noconfirm

#gaming related congigurations
# Ask if to enable gaming

read -p "Do you want to enable gaming? (y/n): " game_on

if [ "$game_on" == "y" ]; then
    paru -S cachyos-gaming-meta protonup-rs-bin --noconfirm
fi

#####-------------------------------------- Grub fixes ------------------------------------------------#####

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable grub-btrfsd

#updating system
paru -Syyuu --noconfirm

####---------------------------------------------configuring fish ------------------------------------------------------####

# Make Fish the default shell
chsh -s $(which fish)

# Install Fisher
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

#installing and configuring tide
fish -c "fisher install IlanCosman/tide"

#configuring tide prmpt
fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Lightest --prompt_spacing=Sparse --icons='Many icons' --transient=Yes"


# Set aliases
fish -c 'alias dog "code"; funcsave dog;'
fish -c 'alias lss "ls -a -h"; funcsave lss;'
fish -c 'alias rmf "rm -r -f -v"; funcsave rmf;'
fish -c 'alias ps "ps auxfh"; funcsave ps;'
fish -c 'alias lss "ls -a -h"; funcsave lss;'
fish -c 'alias rmf "rm -r -f -v"; funcsave rmf;'
fish -c 'alias ps "ps auxfh"; funcsave ps;'
fish -c 'function cursor; command cursor $argv > /dev/null 2>&1 &; end; funcsave cursor'

####------------------------------------------------------configuring-fish ------------------------------------------------------####

# Configure Fish shell
#copy config.fish from config folder to ~/.config/fish

#making sure that the fish folder exists
if [ ! -d ~/.config/fish ]; then
    mkdir -p ~/.config/fish
fi

cp "$current_dir/configs/fish/config.fish" $HOME/.config/fish/config.fish


####------------------------------------------------------ git config ------------------------------------------------------####
# ask if git configuration is required
read -p "Do you want to configure git? (y/n): " git_config


# if yes then run the configure_git.sh script
if [ "$git_config" = "y" ]; then
    #give the script executable permissions
    chmod +x "$current_dir/helpers/configure_git.sh"
    #use the configure_git.sh script to configure git
    
    bash -c "$current_dir/helpers/configure_git.sh"
fi

####---------------------------------configuring kitty terminal ------------------------------------####

# use the kitty.sh script to configure kitty

#give the script executable permissions
chmod +x "$current_dir/helpers/kitty.sh"

bash -c "$current_dir/helpers/kitty.sh $current_dir"

#######---------------------------------configuring spicetify ------------------------------------#######
#use the spicetify.sh script to configure spicetify

#give the script executable permissions
chmod +x "$current_dir/helpers/spicetify.sh"

bash -c "$current_dir/helpers/spicetify.sh $current_dir"

###########---------------------------------configuring alacritty ------------------------------------####
#use the alacritty.sh script to configure alacritty

#give the script executable permissions
chmod +x "$current_dir/helpers/alacritty.sh"

bash -c "$current_dir/helpers/alacritty.sh $current_dir"

####---------------------------KDE-connect fix----------------------------------####
if pgrep -x "kdeconnectd" > /dev/null
then
    killall kdeconnectd || true
fi

#making sure that the kdeconnect folder exists
if [ ! -d ~/.config/kdeconnect ]; then
    mkdir -p ~/.config/kdeconnect
fi

mv ~/.config/kdeconnect ~/.config/kdeconnect.bak

sudo iptables -I INPUT -p tcp --dport 1714:1764 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 1714:1764 -j ACCEPT

sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload

####---------------------------------configuring bluetooth ------------------------------------####

#ask if to enable bluetooth
read -p "Do you want to enable bluetooth ? (y/n): " bt_on

if [ "$bt_on"="y" ]; then
    #enable bluetooth
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth
    echo "Bluetooth enabled !"
fi

####------------------------------------------------------------------ configuring fastfetch ------------------------------------------------------####
# Configure Fastfetch

#use the fastfetch.sh script to configure fastfetch

#give the script executable permissions
chmod +x "$current_dir/helpers/fastfetch.sh"

bash -c "$current_dir/helpers/fastfetch.sh $current_dir"

######-------------------------------- private dns ------------------------------------####
# ask if to enable private dns
read -p "Do you want to enable private dns ? (y/n): " pvt_dns

# if yes then run the pvt-dns.sh script
if [ "$pvt_dns" = "y" ]; then
    bash -c "$current_dir/helpers/pvt-dns.sh"
fi

####---------------------------------configuring zed ------------------------------------####
## copying zed config file to the zed config folder
# cp "$current_dir/configs/zed/settings.json" $HOME/.config/zed/settings.json

####------------------------------------configure Kde force blur ------------------------------------####
# Configure KDE Force Blur

#prompt if this is kde environment or not if yes then execute the following commands
read -p "Is this a KDE environment? (y/n): " kde_env

if [ "$kde_env" = "y" ]; then
    paru -S base-devel git extra-cmake-modules qt6-tools --noconfirm
    
    git clone https://github.com/taj-ny/kwin-effects-forceblur
    cd kwin-effects-forceblur
    mkdir build
    cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=/usr
    make
    sudo make install
    
    echo "Force blur Installed!"
    echo "Enable it from settings > desktop effects > force blur"
    echo "configure force blurr and set enable blur all except matching"
    echo "Kvantum theme name is OCEAN link is present in script"
    #https://store.kde.org/p/1427568/
    
fi

echo "installation complete! Restart your terminal"
