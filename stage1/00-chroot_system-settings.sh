#!/bin/bash
# This script is to be run within a chroot of the target rootfs
function info {
  printf "\e[1m\e[96m%s \e[0m%s\n" "$1" "$2";
}

info "Setting up user accounts"
useradd -m robot
echo 'root:toor' | chpasswd
echo 'robot:tobor' | chpasswd

info "Setting hostname"
echo robot > /etc/hostname

info "Setting locale"
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo LANG=en_GB.UTF-8 > /etc/locale.conf
echo KEYMAP=uk > /etc/vconsole.conf
