#!/bin/sh -l

# refresh pacman database beforehand
sudo pacman -Syu --noconfirm

# fix permissions
sudo chown -R build $GITHUB_WORKSPACE $HOME

cd $GITHUB_WORKSPACE

# install and start distcc
yay -S --noconfirm distcc
sudo /usr/bin/runuser -u nobody -- /usr/bin/distccd --no-detach --daemon $DISTCC_ARGS

