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

sudo chown -R build $HOME

cd $HOME/repo

echo "Hello from arch" >> greet.txt
ls -l >> greet.txt

exit 1
yay -S --noconfirm distcc


cd $GITHUB_WORKSPACE
install_deps
makepkg

ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed prepairing PKGBUILD"
    exit 1
fi
