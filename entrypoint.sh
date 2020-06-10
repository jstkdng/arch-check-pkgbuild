#!/bin/sh -l

# wait for workers
go run .github/workflows/wait_workers.go

# switch to canada mirror
sudo echo "Server = https://mirror.scd31.com/arch/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

# update packages and install distcc
sudo pacman -Syu --noconfirm distcc

# fix permissions
sudo chown -R build $HOME

# switch to repo
cd $HOME/repo

# start building
makepkg -s --noconfirm |& tee -a logfile

# terminate workers
go run .github/workflows/end_workers.go
