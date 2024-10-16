#!/bin/bash
# Shell script to download and install gnome extensions
# TOTP
# window chooser in overview
# burn my windows
# system resources
# alphabetical app grid

# gtile
# requires npm, git
git clone https://github.com/gTile/gTile.git /tmp/gTile
cd /tmp/gTile
npm ci
npm run build:dist
npm run install:extension
