#!/bin/bash
mkdir -p /nerdfonts/SpaceMono
cd /nerdfonts/SpaceMono
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*SpaceMono.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./SpaceMono.tar.xz
tar -xf SpaceMono.tar.xz
rm SpaceMono.tar.xz
mkdir -p /nerdfonts/0xProto
cd /nerdfonts/0xProto
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*0xProto.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./0xProto.tar.xz
tar -xf 0xProto.tar.xz
rm 0xProto.tar.xz
mkdir -p /nerdfonts/Meslo
cd /nerdfonts/Meslo
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*Meslo.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./Meslo.tar.xz
tar -xf Meslo.tar.xz
rm Meslo.tar.xz
mkdir -p /nerdfonts/SauceCodePro
cd /nerdfonts/SauceCodePro
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*SourceCodePro.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./SourceCodePro.tar.xz
tar -xf SourceCodePro.tar.xz
rm SourceCodePro.tar.xz
mkdir -p /nerdfonts/MPlus
cd /nerdfonts/MPlus
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*MPlus.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./MPlus.tar.xz
tar -xf MPlus.tar.xz
rm MPlus.tar.xz
mkdir -p /nerdfonts/HeavyData
cd /nerdfonts/HeavyData
FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep 'browser_download_url.*HeavyData.tar.xz' | cut -d '"' -f 4)
curl $FONT_URL -fLo ./HeavyData.tar.xz
tar -xf HeavyData.tar.xz
rm HeavyData.tar.xz
mv -f /nerdfonts/* /usr/local/share/fonts/
fc-cache -f -v
