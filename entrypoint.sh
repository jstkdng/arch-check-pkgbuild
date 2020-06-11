#!/bin/sh -l
shopt -s dotglob

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

# wait for the PKGBUILD
while ! test -f "$HOME/repo/PKGBUILD" do
    sleep 1
done
sleep 5 # wait a bit more just in case

# switch to home
cd $HOME

# copy all contents from repo
cp -r repo/* .

# wait for workers
go run .github/workflows/wait_workers.go

# symlink logfile
sudo touch repo/logfile && sudo chown build:build repo/logfile

# start building
install_deps |& tee -a repo/logfile
makepkg --nodeps |& tee -a repo/logfile

# terminate workers
go run .github/workflows/end_workers.go
