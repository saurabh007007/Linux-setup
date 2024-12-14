# !/bin/bash

# Configure Alacritty terminal

#arguments
current_dir=$1

#check if alacritty folder exists
if [ ! -d ~/.config/alacritty ]; then
    mkdir -p ~/.config/alacritty
fi
#copy config file
cp -f "$current_dir/configs/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

echo "Alacritty configured"