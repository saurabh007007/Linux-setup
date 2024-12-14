#!/bin/bash
current_dir=$1

# Giving folder permission
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

# Creating Extensions folder if it doesn't exist
if [ ! -d $HOME/.config/spicetify/Extensions ]; then
    echo "Creating Extensions folder"
    mkdir -p $HOME/.config/spicetify/Extensions
fi

#if .config/spotify doesn't exist, create it
if [ ! -d $HOME/.config/spotify ]; then
    echo "Creating .config/spotify folder"
    mkdir -p $HOME/.config/spotify
    touch $HOME/.config/spotify/prefs
fi

#generating config file
spicetify
#copying my own config file
cp $current_dir/configs/spicetify/config-xpui.ini $HOME/.config/spicetify/

# Backup the current config
spicetify backup apply

#installing spiceify marketplace
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh

#check if the marketplace folder exists

if [ ! -d $HOME/.config/spicetify/Themes/marketplace ]; then
    echo "Creating marketplace folder"
    mkdir -p $HOME/.config/spicetify/Themes
fi


spicetify config inject_css 1
spicetify config replace_colors 1
spicetify config current_theme marketplace


spicetify config custom_apps marketplace
spicetify apply

#the theme name is hazy