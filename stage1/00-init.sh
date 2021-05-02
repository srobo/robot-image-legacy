#!/bin/bash
function info {
  printf "\e[1m\e[96m%s \e[0m%s\n" "$1" "$2";
}

printf "\e[1m\e[93m%s\n" "Updating pacman keyring and system packages"

info "Initialising pacman keyring"
pacman-key --init

info "Populating keyring"
pacman-key --populate archlinuxarm

info "Updating system"
pacman -Syu --noconfirm

info "Setting up user accounts"
useradd -mp $(openssl passwd -crypt tobor) robot
echo 'root:toor' | chpasswd
