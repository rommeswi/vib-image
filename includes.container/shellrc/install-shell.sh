#!/bin/bash

# Install oh-my-posh
mkdir -p /tmp/shell/
cd /tmp/shell/
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
curl -s https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/1_shell.omp.json -o 1_shell.omp.json

# Copy oh-my-posh configuration
mkdir -p /etc/skel/.config/oh-my-posh/themes
cp /root/.cache/oh-my-posh/themes /etc/skel/.config/oh-my-posh/themes
cp /tmp/shell/1_shell.omp.json /etc/skel/.config/oh-my-posh/config.json

# Install Prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git ".config/zsh/.zprezto"

# Copy zshrc
cp /shellrc/.zshrc /etc/skel/.zshrc

# Copy kitty config
mkdir -p /etc/skel/.config/kitty/
cp /shellrc/kitty.conf /etc/skel/.config/kitty/kitty.conf
