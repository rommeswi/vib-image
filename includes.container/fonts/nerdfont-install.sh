#!/bin/bash
mkdir -p /fonts/SpaceMono
cd /fonts/SpaceMono
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*SpaceMono.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./SpaceMono.tar.xz
tar -xf SpaceMono.tar.xz
rm SpaceMono.tar.xz
mkdir -p /fonts/0xProto
cd /fonts/0xProto
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*0xProto.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./0xProto.tar.xz
tar -xf 0xProto.tar.xz
rm 0xProto.tar.xz
mkdir -p /fonts/Meslo
cd /fonts/Meslo
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*Meslo.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./Meslo.tar.xz
tar -xf Meslo.tar.xz
rm Meslo.tar.xz
mkdir -p /fonts/SauceCodePro
cd /fonts/SauceCodePro
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*SourceCodePro.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./SourceCodePro.tar.xz
tar -xf SourceCodePro.tar.xz
rm SourceCodePro.tar.xz
mv /fonts/* /usr/local/share/fonts/opentype/
fc-cache -f -v
