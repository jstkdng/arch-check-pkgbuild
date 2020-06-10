#!/bin/sh -l

# install required dependencies
sudo pacman -Syu --noconfirm clang distcc

# fix permissions
sudo chown -R build $HOME

# install and start distcc
export DISTCC_DIR=/tmp/distcc
sudo -E /usr/bin/runuser -u nobody -- /usr/bin/distccd --no-detach --daemon $DISTCC_ARGS

