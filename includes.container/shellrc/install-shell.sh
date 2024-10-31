#!/bin/bash

# Copy zshrc
cp /shellrc/.zshenv /etc/skel/.zshenv
cp /shellrc/.config/zsh /etc/skel/.config/zsh

# Install oh-my-posh
mkdir -p /tmp/shell/
cd /tmp/shell/
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin

# Copy oh-my-posh configuration
mkdir -p /etc/skel/.config/zsh/oh-my-posh/themes
cp /root/.cache/oh-my-posh/themes /etc/skel/.config/zsh/oh-my-posh/themes
cp /shellrc/omp-config.json /etc/skel/.config/zsh/oh-my-posh/config.json

# Install Prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git /etc/skel/.config/zsh/.zprezto

# Copy kitty config
mkdir -p /etc/skel/.config/kitty/
cp /shellrc/kitty.conf /etc/skel/.config/kitty/kitty.conf
