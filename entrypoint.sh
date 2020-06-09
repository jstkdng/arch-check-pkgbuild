#!/bin/sh -l

install_deps() {
    # install make dependencies
    grep -E 'makedepends' PKGBUILD | \
        sed -e 's/.*depends=//' -e 's/ /\n/g' | \
        tr -d "'" | tr -d "(" | tr -d ")" | \
        xargs yay -S --noconfirm
}

# refresh pacman database beforehand
sudo pacman -Syu --noconfirm

yay -S --noconfirm php

php -S 0.0.0.0:8189
