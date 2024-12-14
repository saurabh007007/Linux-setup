#configuring kitty

#accepting the default values
current_dir=$1

# kitty config

#check if kitty folder exists
if [ ! -d ~/.config/kitty ]; then
    mkdir -p ~/.config/kitty
fi

#copy config file
cp -f "$current_dir/configs/kitty/kitty.conf" ~/.config/kitty/kitty.conf

echo "Kitty configured"