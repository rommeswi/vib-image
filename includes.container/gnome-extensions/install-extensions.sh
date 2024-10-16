#!/bin/bash
# Shell script to download and install gnome extensions
# TOTP
# window chooser in overview
# burn my windows
# system resources
# alphabetical app grid
# user themes
# removable drive menu
# system monitor
# pomodoro?
# run or raise?
# day starts on monday
# clipboard manager?

# gtile
# requires npm, git
git clone https://github.com/gTile/gTile.git /tmp/gTile
cd /tmp/gTile
npm ci
npm run build:dist
npm run install:extension

# Burn my windows
# git clone https://github.com/Schneegans/Burn-My-Windows.git /tmp/Burn-My-Windows
# cd /tmp/Burn-My-Windows
# make install
