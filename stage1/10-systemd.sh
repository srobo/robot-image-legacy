#!/bin/bash
# This script is to be run within a chroot of the target rootfs
printf "\e[1m\e[93m%s\n" "Enabling required systemd units"
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable systemd-udevd
systemctl enable udisks2
systemctl enable openssh
systemctl enable astdiskd
systemctl enable astmetad
systemctl enable astprocd
