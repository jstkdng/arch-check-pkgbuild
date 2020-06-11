#!/bin/sh -l

install_deps() {
    # install make dependencies
    grep -E 'makedepends' PKGBUILD | \
        sed -e 's/.*depends=//' -e 's/ /\n/g' | \
        tr -d "'" | tr -d "(" | tr -d ")" | \
        xargs yay -S --noconfirm
}

# switch to canada mirror
sudo echo "Server = http://archlinux.mirror.colo-serv.net/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

# update packages and install distcc
sudo pacman -Syu --noconfirm distcc

# fix permissions
#sudo chown -R build $HOME

# switch to repo
cd $HOME

# copy all contents from repo
cp -r repo/* .

# wait for workers
go run .github/workflows/wait_workers.go

# symlink logfile
touch logfile
sudo ln -s $HOME/logfile $HOME/repo/logfile

# start building
install_deps
makepkg --nodeps |& tee -a logfile

# terminate workers
go run .github/workflows/end_workers.go
