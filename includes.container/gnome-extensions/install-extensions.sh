#!/bin/bash
# Shell script to download and install gnome extensions

# burn my windows
git clone https://github.com/Schneegans/Burn-My-Windows.git /tmp/Burn-My-Windows
cd /tmp/Burn-My-Windows
make install

# alphabetical app grid
# requires gettext (deb)
git clone https://github.com/stuarthayhurst/alphabetical-grid-extension.git /tmp/alphabetical-grid-extension
cd /tmp/alphabetical-grid-extension
make build
make install

# ddterm (maybe downloading the zip is faster)
# requires meson, gtk-builder-tool, gtk4-builder-tool, xsltproc, msgcmp, msgmerge, xgettext, zip
git clone https://github.com/ddterm/gnome-shell-extension-ddterm.git /tmp/gnome-shell-extension-ddterm
cd /tmp/gnome-shell-extension-ddterm
meson setup build-dir
ninja -C build-dir pack
gnome-extensions install -f /tmp/gnome-shell-extension-ddterm/build-dir/ddterm@amezin.github.com.shell-extension.zip

# run or raise?
# TOTP
# user themes
# week starts on monday
# windowNavigator

# gtile
# requires npm, git
git clone https://github.com/gTile/gTile.git /tmp/gTile
cd /tmp/gTile
npm ci
npm run build:dist
npm run install:extension

