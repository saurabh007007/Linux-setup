# !/bin/bash

#this script if for fastfetch configuration

#take the current directory as argument
current_dir=$1

fastfetch --gen-config
mkdir $HOME/.config/fastfetch
cd $HOME/.config/fastfetch

rm config.jsonc

#copying the config file

cp $current_dir/configs/fastfetch/config.jsonc $HOME/.config/fastfetch/config.jsonc

echo "Fastfetch setup complete"