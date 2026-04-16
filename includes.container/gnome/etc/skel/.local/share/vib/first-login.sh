#!/bin/bash
dconf write /org/gnome/shell/extensions/burn-my-windows/active-profile \
  "\"$HOME/.config/burn-my-windows/profiles/1875091100000000.conf\""
rm -- "$HOME/.config/autostart/vib-first-login.desktop"
