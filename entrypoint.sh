#!/bin/sh -l

# switch to canada mirror
echo "Server = http://archlinux.mirror.colo-serv.net/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

# update dependencies
sudo pacman -Syu --noconfirm

# install dependencies
yay -S --noconfirm clang distcc

# start distcc
sudo /usr/bin/runuser -u nobody -- /usr/bin/distccd --no-detach --daemon $DISTCC_ARGS

