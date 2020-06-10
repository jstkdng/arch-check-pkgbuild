#!/bin/sh -l

# refresh pacman database beforehand
sudo pacman -Syu --noconfirm

# fix permissions
sudo chown -R build $HOME

# install and start distcc
yay -S --noconfirm distcc
sudo /usr/bin/runuser -u nobody -- /usr/bin/distccd --no-detach --daemon $DISTCC_ARGS

