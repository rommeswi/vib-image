#!/bin/bash
mkdir -p /tmp/shell/
cd /tmp/shell/
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/usr/local/bin
curl -s https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/1_shell.omp.json 
cp /tmp/shell/1_shell.omp.json /etc/skel/.config/oh-my-posh/1_shell.omp.json
cp /shellrc/.zshrc /etc/skel/.zshrc
