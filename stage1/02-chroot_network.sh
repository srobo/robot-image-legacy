#!/bin/bash
# This script is to be run within a chroot of the target rootfs
function info {
  printf "\e[1m\e[96m%s \e[0m%s\n" "$1" "$2";
}

info "Enabling DHCP for Ethernet"
cp stage1/files/eth0.network "$BUILD_DIR/etc/systemd/network/eth0.network"
