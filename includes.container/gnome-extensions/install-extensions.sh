#!/bin/bash
# Shell script to download and install gnome extensions

# burn my windows
git clone https://github.com/Schneegans/Burn-My-Windows.git /tmp/Burn-My-Windows
cd /tmp/Burn-My-Windows
make zip
ls -a
unzip burn-my-windows@schneegans.github.com.zip
cp -r burn-my-windows@schneegans.github.com /usr/share/gnome-shell/extensions/

# alphabetical app grid
# requires gettext (deb)
git clone https://github.com/stuarthayhurst/alphabetical-grid-extension.git /tmp/alphabetical-grid-extension
cd /tmp/alphabetical-grid-extension
make build
cd ./build/
ls -a
unzip AlphabeticalAppGrid@stuarthayhurst.shell-extension.zip
cp -r AlphabeticalAppGrid@stuarthayhurst.shell-extension /usr/share/gnome-shell/extensions/


# ddterm (maybe downloading the zip is faster)
# requires meson, gtk-builder-tool, gtk4-builder-tool, xsltproc, msgcmp, msgmerge, xgettext, zip
git clone https://github.com/ddterm/gnome-shell-extension-ddterm.git /tmp/gnome-shell-extension-ddterm
cd /tmp/gnome-shell-extension-ddterm
meson setup build-dir
ninja -C build-dir pack
cd /tmp/gnome-shell-extension-ddterm/build-dir/
unzip gnome-shell-extension-ddterm/build-dir/ddterm@amezin.github.com.shell-extension.zip
cp -r gnome-shell-extension-ddterm/build-dir/ddterm@amezin.github.com.shell-extension.zip /usr/share/gnome-shell/extensions/

# run or raise?

# TOTP
# requires jq
git clone https://github.com/dkosmari/gnome-shell-extension-totp.git /tmp/gnome-shell-extension-totp
cd /tmp/gnome-shell-extension-totp
make install

# week starts on monday
#git clone --recurse-submodules https://github.com/F-i-f/weeks-start-on-monday/ /tmp/week-starts-on-monday
#cd /tmp/week-starts-on-monday
#meson setup build
#gnome-extensions install -f /tmp/
# installs by default to user, system wide installation?
# use --destdir to place it into skel?

# windowNavigator
# git clone https://gitlab.gnome.org/GNOME/gnome-shell-extensions.git /tmp/gnome-shell-extensions
# cd /tmp/gnome-shell-extensions
# meson setup build-dir -Dextension_set=all
# ninja -C build-dir


# gtile
# requires npm, git
git clone https://github.com/gTile/gTile.git /tmp/gTile
cd /tmp/gTile
npm ci
npm run build:dist
tar -xzf gtile.dist.tgz
ls -a
npm run install:extension

