#!/bin/sh -l

# refresh pacman database beforehand
sudo pacman -Syu --noconfirm

sudo chown -R build /github/workspace /github/home

cd $GITHUB_WORKSPACE
makepkg --syncdeps --nobuild --noconfirm

ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed prepairing PKGBUILD"
    exit 1
fi
