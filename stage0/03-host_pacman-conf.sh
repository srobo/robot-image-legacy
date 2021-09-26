#!/bin/bash
# This script is to be run within a chroot of the target rootfs
function info {
  printf "\e[1m\e[96m%s \e[0m%s\n" "$1" "$2";
}

info "Copying pacman configuration"
cp stage0/pacman.conf "$BUILD_DIR/etc/pacman.conf"
