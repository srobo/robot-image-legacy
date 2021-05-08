#!/bin/bash
# This script is to be run within a chroot of the target rootfs
function info {
  printf "\e[1m\e[96m%s \e[0m%s\n" "$1" "$2";
}

printf "\e[1m\e[93m%s\n" "Updating pacman keyring and system packages"

info "Initialising pacman keyring"
pacman-key --init

info "Populating keyring"
pacman-key --populate archlinuxarm

info "Adding SR kit-packages repository"
echo "
[srobo]
SigLevel = Optional
Server = https://srobo.github.io/kit-packages/armv7l/" >> /etc/pacman.conf
