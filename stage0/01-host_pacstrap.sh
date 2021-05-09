#!/bin/bash
set -e

source ./util.sh

export CARCH=armv7l
info "Bootstrapping" "Arch Linux ARM"
# Reads in common and platform packages and runs pacstrap with them
pacstrap -MGC stage0/pacman.conf "$BUILD_DIR" base