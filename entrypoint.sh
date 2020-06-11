#!/bin/sh -l
install_deps() {
    # install make dependencies
    grep -E 'depends|makedepends' PKGBUILD | \
        sed -e 's/.*depends=//' -e 's/ /\n/g' | \
        tr -d "'" | tr -d "(" | tr -d ")" | \
        xargs yay -S --noconfirm
}

# switch to canada mirror
echo "Server = http://archlinux.mirror.colo-serv.net/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

# update packages and install distcc
sudo pacman -Syu --noconfirm

# change permissions
sleep 30
sudo chown -R build $HOME

# switch to repo
cd $HOME/repo

echo "Starting build..." > logfile

# wait for workers
go run .github/workflows/wait_workers.go |& tee -a logfile

# install dependencies
yay -S --noconfirm distcc |& tee -a logfile
#install_deps |& tee -a logfile

# start build
makepkg --syncdeps --noconfirm |& tee -a logfile

# terminate workers
go run .github/workflows/end_workers.go |& tee -a logfile
