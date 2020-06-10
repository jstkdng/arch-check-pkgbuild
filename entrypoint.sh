#!/bin/sh -l

# switch to canada mirror
sudo echo "Server = http://archlinux.mirror.colo-serv.net/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

# install required dependencies
sudo pacman -Syu --noconfirm clang distcc

# fix permissions
sudo chown -R build $HOME

# start distcc
sudo /usr/bin/runuser -u nobody -- /usr/bin/distccd --no-detach --daemon $DISTCC_ARGS

