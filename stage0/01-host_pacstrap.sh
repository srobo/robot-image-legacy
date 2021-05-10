#!/bin/bash
set -ex

source ./util.sh

export CARCH=armv7l

info "Setting up keyring"
if [ -d "tools" ]; then
    mkdir -p "$BUILD_DIR/etc/pacman.d/gnupg"
    LIBRARY="$PWD/tools/usr/share/makepkg" pacman-key --init --config "$PWD/tools/etc/pacman.conf" --gpgdir "$PWD/tools/etc/pacman.d/gnupg"
fi

info "Bootstrapping" "Arch Linux ARM"
# Reads in common and platform packages and runs pacstrap with them
pacstrap -MGC stage0/pacman.conf "$BUILD_DIR" base
