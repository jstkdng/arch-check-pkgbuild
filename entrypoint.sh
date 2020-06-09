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

yay -S --noconfirm distcc

sudo chown -R build $GITHUB_WORKSPACE $HOME

cd $GITHUB_WORKSPACE
install_deps
makepkg

ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed prepairing PKGBUILD"
    exit 1
fi
