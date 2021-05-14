#!/bin/bash
set -e

source ./util.sh

export CARCH=armv7l
info "Bootstrapping" "Arch Linux ARM"
# bootstraps the system, installing the base and snapper packages
pacstrap -cMGC stage0/pacman.conf "$BUILD_DIR" base snapper

info "Generating" "/etc/fstab"
genfstab -U "$BUILD_DIR" > "$BUILD_DIR/etc/fstab"

