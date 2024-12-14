#!/bin/bash

### configuring git

# Function to prompt for user input
prompt_user() {
    read -p "$1: " user_input
    echo "$user_input"
}

# Function to generate Ed25519 SSH key
generate_ed25519_key() {
    ssh-keygen -t ed25519 -C "$1" -f "$2"
}

# Function to add SSH key to agent
add_ssh_to_agent() {
    ssh-add $1
}

# Start SSH agent
eval "$(ssh-agent -s)"

# Prompt for work profile creation
read -p "Do you want to create a work profile? (y/n): " create_work_profile

if [ "$create_work_profile" = "y" ]; then
    # Creating directory for work git
    mkdir -p ~/work
    cd ~/work
    
    # Prompt for work-related information
    work_email=$(prompt_user "Enter work email")
    work_username=$(prompt_user "Enter work username")
    github_username=$(prompt_user "Enter GitHub username for work")
    
    # Generate .gitconfig.work
    cat <<EOF > ~/work/.gitconfig.work
[user]
    email = $work_email
    name = $work_username
    signingkey = ~/.ssh/work_key

[github]
    user = "$github_username"

[commit]
    gpgsign = true

[gpg]
    format = ssh

[core]
    sshCommand = "ssh -i ~/.ssh/work_key"
EOF
    
    # Generate Ed25519 SSH key for work
    generate_ed25519_key "$work_email" ~/.ssh/work_key
    
    # Add SSH key to agent
    add_ssh_to_agent ~/.ssh/work_key
fi

# Creating directory for personal git
mkdir -p ~/personal
cd ~/personal

# Prompt for personal-related information
personal_email=$(prompt_user "Enter personal email")
personal_username=$(prompt_user "Enter personal username")
github_username=$(prompt_user "Enter GitHub username for personal")

# Generate .gitconfig.personal
cat <<EOF > ~/personal/.gitconfig.personal
[user]
    email = $personal_email
    name = $personal_username
    signingkey = ~/.ssh/personal_key

[github]
    user = "$github_username"

[commit]
    gpgsign = true

[gpg]
    format = ssh

[core]
    sshCommand = "ssh -i ~/.ssh/personal_key"
EOF

# Generate Ed25519 SSH key for personal
generate_ed25519_key "$personal_email" ~/.ssh/personal_key

# Add SSH key to agent
add_ssh_to_agent ~/.ssh/personal_key

# Configure global gitconfig
cat <<EOF > ~/.gitconfig
[includeIf "gitdir:~/personal/"]
    path = ~/personal/.gitconfig.personal
[includeIf "gitdir:~/work/"]
    path = ~/work/.gitconfig.work
EOF

echo "CAT the .pub files and add the contents to Github.com in their respective accounts"