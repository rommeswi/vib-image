#!/bin/bash
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/usr/local/bin
cp /shellrc/.zshrc /etc/skel/.zshrc
