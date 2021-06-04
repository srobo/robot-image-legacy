#!/bin/bash
# This script is to be run within a chroot of the target rootfs
function info {
  printf "\e[1m\e[96m%s \e[0m%s\n" "$1" "$2";
}

info "Enabling required systemd units"
systemctl enable \
  systemd-networkd \
  systemd-udevd \
  udisks2 \
  dnsmasq \
  mosquitto \
  astdiskd \
  astmetad \
  astprocd \
  astwifid \
  astoria-udiskie
