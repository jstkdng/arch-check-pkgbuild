#!/bin/sh -l

install_deps() {
    # install make package dependencies
    grep -E 'makedepends' PKGBUILD | \
        sed -e 's/.*depends=//' -e 's/ /\n/g' | \
        tr -d "'" | tr -d "(" | tr -d ")" | \
        xargs yay -S --noconfirm
}

# refresh pacman database beforehand
sudo pacman -Syu --noconfirm

sudo chown -R build /github/workspace /github/home

cd $GITHUB_WORKSPACE
install_deps
makepkg --nobuild --nodeps --clean

ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed prepairing PKGBUILD"
    exit 1
fi

# restore old permissions
sudo chown -R root /github/workspace /github/home
