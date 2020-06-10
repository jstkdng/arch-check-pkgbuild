#!/bin/sh -l

install_deps() {
    # install make dependencies
    grep -E 'makedepends' PKGBUILD | \
        sed -e 's/.*depends=//' -e 's/ /\n/g' | \
        tr -d "'" | tr -d "(" | tr -d ")" | \
        xargs yay -S --noconfirm
}

# update packages and install distcc
sudo pacman -Syu --noconfirm distcc

# fix permissions
sudo chown -R build $HOME

# wait for workers
cd $HOME/repo/.github/workflows
go run wait_workers.go 2>> logfile

exit 0

# start building
cd $HOME/repo
install_deps
makepkg --log

