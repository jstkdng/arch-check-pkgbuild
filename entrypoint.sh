#!/bin/sh -l

install_deps() {
    # install make package dependencies
    grep -E 'makedepends' PKGBUILD | \
        sed -e 's/.*depends=//' -e 's/ /\n/g' | \
        tr -d "'" | tr -d "(" | tr -d ")" | \
        xargs yay -S --noconfirm
}

sudo pacman -Syu --noconfirm

mount
lsblk
ls /

cp /github/workspace/* /home/build/
cd /home/build/
install_deps
makepkg --nobuild --nodeps --clean

ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed prepairing PKGBUILD"
    exit 1
fi
