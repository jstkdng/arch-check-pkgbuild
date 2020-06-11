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

# switch to repo
cd $HOME/repo

# wait for the PKGBUILD
while ! test -f "PKGBUILD" do
    sleep 2
done
sleep 10 # wait a bit more just in case

# change permissions
sudo chown -R build:build $HOME

# update packages and install distcc
sudo pacman -Syu --noconfirm distcc

# wait for workers
go run .github/workflows/wait_workers.go |& tee -a logfile

# start building
install_deps |& tee -a logfile
makepkg --nodeps |& tee -a logfile

# terminate workers
go run .github/workflows/end_workers.go |& tee -a logfile
