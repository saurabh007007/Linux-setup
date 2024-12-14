# !/bin/bash


#########---------------------------------------- installing fastanime ------------------------------------####
fish -c 'uv tool install "fastanime[standard]"'

#installing completions
mkdir -p $HOME/temps/fastanime
cd $HOME/temps/fastanime
wget "https://github.com/Benexl/FastAnime/blob/e668f9326a822f15a593afa0e261ef53f58ff1b7/completions/fastanime.fish"
fish -c "mv fastanime.fish ~/.config/fish/completions"

# Attempt to find the path to fastanime and add it to fish path
fastanime_path=$(find / -name fastanime 2>/dev/null | head -n 1)
if [ -n "$fastanime_path" ]; then
  fish -c "set -U fish_user_paths \$fish_user_paths $(dirname $fastanime_path)"
else
  echo "fastanime not found in the system."
fi

####---------------------------------configuring MPV ------------------------------------####
#installing uosc
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"