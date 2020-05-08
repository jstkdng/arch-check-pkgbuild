#!/bin/sh -l

pacman -Sy --noconfirm base-devel git

cd $GITHUB_WORKSPACE

makepkg -sor

ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed prepairing PKGBUILD"
    exit 1
fi
