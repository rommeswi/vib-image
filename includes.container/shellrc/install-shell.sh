#!/bin/bash
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin
cp /shellrc/.zshrc /etc/skel/.zshrc
