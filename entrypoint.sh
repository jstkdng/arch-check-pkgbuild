#!/bin/sh -l

# switch to canada mirror
echo "Server = https://mirror.csclub.uwaterloo.ca/archlinux/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

# install required dependencies
sudo pacman -Syu --noconfirm clang distcc

# fix permissions
sudo chown -R build $HOME

# install and start distcc
export DISTCC_DIR=/tmp/distcc
sudo -E /usr/bin/runuser -u nobody -- /usr/bin/distccd --no-detach --daemon $DISTCC_ARGS

