#!/bin/sh -l

sudo pacman -S --noconfirm base-devel,git
cd /github
makepkg -sor

ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed prepairing PKGBUILD"
    exit 1
fi
