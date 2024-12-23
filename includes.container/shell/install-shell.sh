#!/bin/bash

#
# Kitty
#
# Copy kitty config
mkdir -p /etc/skel/.config/kitty/
cp -r /shell/.config/kitty /etc/skel/.config/kitty

#
# Bash
#
mkdir -p /etc/skel/.config/bash
cp /shell/.profile /etc/skel/.profile
cp -r /shell/.config/bash /etc/skel/.config/bash

#
# Zsh
#
mkdir -p /etc/skel/.config/zsh
cp /shell/.zshenv /etc/skel/.zshenv
cp -r /shell/.config/zsh /etc/skel/.config/zsh

#
# Oh my posh
#
# Install oh-my-posh
mkdir -p /tmp/shell/
cd /tmp/shell/
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin

# Copy oh-my-posh configuration
mkdir -p /etc/skel/.config/zsh/oh-my-posh/themes
cp /root/.cache/oh-my-posh/themes /etc/skel/.config/zsh/oh-my-posh/themes
cp /shell/omp-config.json /etc/skel/.config/zsh/oh-my-posh/config.json

#
# Prezto
#
# Install Prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git /etc/skel/.config/zsh/.zprezto

# Install Manual plugins
# Install zpm-zsh ls plugin
cd /etc/skel/.config/zsh/.zprezto
# Improved ls commands
git submodule add https://github.com/zpm-zsh/ls.git modules/ls
# conflicts with:
# Replace ls with eza:
git submodule update https://github.com/z-shell/zsh-eza.git
# zcolors
git submodule add https://github.com/marlonrichert/zcolors.git modules/zcolors
# zsh-help
git submodule add https://github.com/Freed-Wu/zsh-help.git modules/zsh-help
# Download all
git submodule update --init --recursive

#
# Eza
#
# Install eza tokyonight theme
git clone https://github.com/eza-community/eza-themes.git /tmp/eza-themes
mkdir -p /etc/skel/.config/eza
cp /tmp/eza-themes/themes/tokyonight.yml /etc/skel/.config/eza/theme.yml
