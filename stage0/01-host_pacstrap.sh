#!/bin/bash
set -e

source ./util.sh

export CARCH=armv7l
info "Bootstrapping" "Arch Linux ARM"
# bootstraps the system, installing the base package
pacstrap -cMGC stage0/pacman.conf "$BUILD_DIR" base

info "Generating" "/etc/fstab"
genfstab -U "$BUILD_DIR" > "$BUILD_DIR/etc/fstab"

