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

sudo chown -R build $GITHUB_WORKSPACE $HOME

cd $GITHUB_WORKSPACE
yay -S --noconfirm php
echo "<p>Hello from $NAME on arch</p>" > index.html
php -S 0.0.0.0:8189
