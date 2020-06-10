#!/bin/sh -l
# update packages and install distcc
sudo pacman -Syu --noconfirm distcc

# fix permissions
sudo chown -R build $HOME

# wait for workers
cd $HOME/repo/.github/workflows
go run wait_workers.go 2>> logfile

# start building
cd $HOME/repo
makepkg -s --noconfirm |& tee -a logfile

# terminate workers
cd $HOME/repo/.github/workflows
go run end_workers.go 2>> logfile
